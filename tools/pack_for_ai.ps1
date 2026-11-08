#!/usr/bin/env pwsh
# Glues the AI rules, the build procedure, the dataset template and edsm
# (built from that template) into one text file, for an AI that can't read
# the repo, e.g. work Copilot.
# Upload or paste the file, then ask, e.g. "add a dataset for <source>".
#
#   ./tools/pack_for_ai.ps1

param([string]$Out = (Join-Path ([System.IO.Path]::GetTempPath()) "sdp_framework_for_ai.txt"))

$paths = @(
    "AGENTS.md",
    "doc/procedures/build_many_table_dataset.md",
    "doc/procedures/build_many_table_dataset",
    "doc/templates/dataset",
    "datasets/edsm"
)

$files = $paths | ForEach-Object { Get-ChildItem $_ -File -Recurse } | Sort-Object FullName -Unique
$root = (Get-Location).Path + [System.IO.Path]::DirectorySeparatorChar
$text = foreach ($f in $files) {
    "===== $($f.FullName.Replace($root, '').Replace('\', '/')) ====="
    Get-Content $f.FullName -Raw
}
$text | Set-Content $Out -Encoding utf8
Write-Host "Wrote $($files.Count) files to $Out"
