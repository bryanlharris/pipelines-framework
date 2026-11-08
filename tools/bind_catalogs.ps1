#!/usr/bin/env pwsh
# Binds each of the bundle's catalogs to this workspace, isolates it, and
# turns on data classification. The bundle can't do these yet.
# Safe to run again; it skips each step that is already done.
#
#   ./tools/bind_catalogs.ps1 -Target dev

param([Parameter(Mandatory)][string]$Target)

$ws = (databricks metastores current -p $Target -o json | ConvertFrom-Json).workspace_id
$wsHost = (databricks auth describe -p $Target -o json | ConvertFrom-Json).details.host -replace "^https://", ""
$bind = @{ add = @(@{ workspace_id = $ws; binding_type = "BINDING_TYPE_READ_WRITE" }) } | ConvertTo-Json -Depth 3 -Compress
$catalogs = (databricks bundle validate -t $Target -o json | ConvertFrom-Json).resources.catalogs.PSObject.Properties.Value.name

foreach ($c in $catalogs) {
    Write-Host "== $c"

    # Bind first, so isolating can't lock you out.
    $bound = @(databricks workspace-bindings get-bindings catalog $c -p $Target -o json | ConvertFrom-Json).workspace_id
    if ($bound -contains $ws) {
        Write-Host "   already bound to workspace $ws ($wsHost)"
    } else {
        databricks workspace-bindings update-bindings catalog $c --json $bind -p $Target | Out-Null
        Write-Host "   bound to workspace $ws ($wsHost)"
    }
    $others = $bound | ? { $_ -ne $ws }
    if ($others) { Write-Host "   also bound to $($others -join ', ')" }

    $mode = (databricks catalogs get $c -p $Target -o json | ConvertFrom-Json).isolation_mode
    if ($mode -eq "ISOLATED") {
        Write-Host "   already isolated"
    } else {
        databricks catalogs update $c --isolation-mode ISOLATED -p $Target | Out-Null
        Write-Host "   isolated"
    }

    databricks data-classification get-catalog-config "catalogs/$c/config" -p $Target 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   classification already on"
    } else {
        databricks data-classification create-catalog-config "catalogs/$c" -p $Target 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { Write-Host "   classification on" }
        else { Write-Host "   classification failed, e.g. not supported on free" }
    }
}
