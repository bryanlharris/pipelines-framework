#!/usr/bin/env pwsh
# Binds each of the bundle's catalogs to this workspace, isolates it, and
# turns on data classification. The bundle can't do these yet.
# Safe to run again; classification says "already exists" where it is on.
#
#   ./tools/bind_catalogs.ps1 -Target dev

param([Parameter(Mandatory)][string]$Target)

$ws = (databricks metastores current -p $Target -o json | ConvertFrom-Json).workspace_id
$bind = @{ add = @(@{ workspace_id = $ws; binding_type = "BINDING_TYPE_READ_WRITE" }) } | ConvertTo-Json -Depth 3 -Compress
$catalogs = (databricks bundle validate -t $Target -o json | ConvertFrom-Json).resources.catalogs.PSObject.Properties.Value.name

foreach ($c in $catalogs) {
    Write-Host "== $c"
    # Bind first, so isolating can't lock you out.
    databricks workspace-bindings update-bindings catalog $c --json $bind -p $Target | Out-Null
    databricks catalogs update $c --isolation-mode ISOLATED -p $Target | Out-Null
    databricks data-classification create-catalog-config "catalogs/$c" -p $Target
}
