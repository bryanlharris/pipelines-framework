#!/usr/bin/env pwsh
# Downloads YOUR_TABLE and uploads it to the YOUR_DATASET inbox. Runs on your computer.
# The ingest job moves it to raw files.
#
#   ./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1

param(
    [string]$Catalog = "YOUR_DATASET",
    [string]$DatabricksProfile = "free"
)

$table = "YOUR_TABLE"
$ext   = "CHANGE_ME → the file's extension, e.g. xml, no dot"
$url   = "CHANGE_ME → where to download it"
$inbox = "dbfs:/Volumes/$Catalog/raw/inbox"
$file  = Join-Path ([System.IO.Path]::GetTempPath()) "$table.$ext"

Write-Host "Downloading $table"
Invoke-WebRequest -Uri $url -OutFile $file

Write-Host "Uploading to $inbox/$table.$ext"
databricks fs cp $file "$inbox/$table.$ext" --overwrite --profile $DatabricksProfile
if ($LASTEXITCODE -ne 0) { throw "Upload failed: $table" }

Remove-Item $file
Write-Host "Done."
