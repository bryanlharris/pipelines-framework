#!/usr/bin/env pwsh
# Downloads yieldCurve and uploads it to the treasury inbox. Runs on your PC.
# The ingest job moves it to raw files.
#
#   pwsh datasets/treasury/upload_treasury.ps1
#   pwsh datasets/treasury/upload_treasury.ps1 -Fake    # dev: the made-up files in fake/

param(
    [string]$Catalog = "treasury",
    [string]$DatabricksProfile = "free",
    [switch]$Fake
)

$table = "yieldCurve"
$ext   = "xml"
$url   = "https://home.treasury.gov/resource-center/data-chart-center/interest-rates/pages/xml?data=daily_treasury_yield_curve&field_tdr_date_value=$((Get-Date).Year)"
$inbox = "dbfs:/Volumes/$Catalog/raw/inbox"

# -Fake sends the made-up files in fake/ instead, for dev. Each run gets a
# new inbox name, so the ingest job's file trigger sees a new file.
if ($Fake) {
    $run = Get-Date -Format HHmmss
    foreach ($f in Get-ChildItem "$PSScriptRoot/fake") {
        $name = "$($f.BaseName)_fake_$run$($f.Extension)"
        Write-Host "Uploading to $inbox/$name"
        databricks fs cp $f.FullName "$inbox/$name" --overwrite --profile $DatabricksProfile
        if ($LASTEXITCODE -ne 0) { throw "Upload failed: $name" }
    }
    Write-Host "Done."
    exit
}

$file  = Join-Path ([System.IO.Path]::GetTempPath()) "$table.$ext"

Write-Host "Downloading $table"
Invoke-WebRequest -Uri $url -OutFile $file

Write-Host "Uploading to $inbox/$table.$ext"
databricks fs cp $file "$inbox/$table.$ext" --overwrite --profile $DatabricksProfile
if ($LASTEXITCODE -ne 0) { throw "Upload failed: $table" }

Remove-Item $file
Write-Host "Done."
