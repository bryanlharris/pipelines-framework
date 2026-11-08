#!/usr/bin/env pwsh
# Makes fake PDFs, uploads them to the documents inbox, then deletes them.
# The ingest job moves each PDF to raw files.
#
#   ./datasets/documents/upload_documents.ps1 -Count 9

param(
    [int]$Count = 9,
    [string]$Catalog = "documents",
    [string]$DatabricksProfile = "free"
)

$inbox = "dbfs:/Volumes/$Catalog/raw/inbox"

# Fail before making anything if the inbox can't be reached, e.g. a wrong profile.
$check = databricks fs ls $inbox --profile $DatabricksProfile 2>&1
if ($LASTEXITCODE -ne 0) { throw "Cannot reach $inbox (profile $DatabricksProfile): $check" }

$temp = Join-Path ([System.IO.Path]::GetTempPath()) "documents_pdfs"
$py   = if (Get-Command py -ErrorAction SilentlyContinue) { "py" } else { "python3" }
& $py "$PSScriptRoot/make_fake_pdf.py" -n $Count $temp
if ($LASTEXITCODE -ne 0) { throw "Could not make the PDFs" }

databricks fs cp -r $temp $inbox --overwrite --profile $DatabricksProfile
if ($LASTEXITCODE -ne 0) { throw "Upload failed" }
Remove-Item -Recurse $temp
Write-Host "Done."
