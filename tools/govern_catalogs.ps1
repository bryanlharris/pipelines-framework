#!/usr/bin/env pwsh
# Binds each of the bundle's catalogs to this workspace, isolates it, turns
# on data classification, and turns on data quality monitoring for silver
# and gold. The bundle can't do these yet.
# Safe to run again; it skips each step that is already done.
#
# On prod, -StagingWorkspace also binds each catalog read-only to staging, so
# staging's pipelines can read its raw.files. The lead's read grant comes
# from the catalog's grants in resources.yml.
#
#   ./tools/govern_catalogs.ps1 -Target dev
#   ./tools/govern_catalogs.ps1 -Target prod -StagingWorkspace YOUR_WORKSPACE_ID

param([Parameter(Mandatory)][string]$Target, [string]$StagingWorkspace)

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
    if ($StagingWorkspace) {
        if ($bound -contains $StagingWorkspace) {
            Write-Host "   already readable from staging workspace $StagingWorkspace"
        } else {
            $ro = @{ add = @(@{ workspace_id = [long]$StagingWorkspace; binding_type = "BINDING_TYPE_READ_ONLY" }) } | ConvertTo-Json -Depth 3 -Compress
            databricks workspace-bindings update-bindings catalog $c --json $ro -p $Target | Out-Null
            Write-Host "   readable from staging workspace $StagingWorkspace"
        }
        $bound += [long]$StagingWorkspace
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

    # Data quality monitoring watches silver and gold for stale or odd data.
    foreach ($s in "silver", "gold") {
        $id = (databricks schemas get "$c.$s" -p $Target -o json 2>$null | ConvertFrom-Json).schema_id
        if (-not $id) { continue }
        databricks data-quality get-monitor schema $id -p $Target 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   $s monitoring already on"
        } else {
            $monitor = @{ object_type = "schema"; object_id = $id; anomaly_detection_config = @{} } | ConvertTo-Json -Compress
            databricks data-quality create-monitor --json $monitor -p $Target 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) { Write-Host "   $s monitoring on" }
            else { Write-Host "   $s monitoring failed" }
        }
    }
}
