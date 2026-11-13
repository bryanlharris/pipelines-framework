#!/usr/bin/env pwsh
# Downloads edsm's files and uploads them to its inbox. For free,
# which can't fetch; enterprise targets use the fetch job.
# The ingest job moves each file to raw files.
#
#   ./datasets/edsm/upload_edsm.ps1
#   ./datasets/edsm/upload_edsm.ps1 -Fake    # dev: the made-up files in fake/

param(
    [string]$Catalog = "edsm",
    [string]$DatabricksProfile = "free",
    [switch]$Fake
)

# One line per file, like fetch.yml. Name each file after its table.
# Put ${year} where the url has a year. Add gunzip = $true to unzip a .gz;
# name is then the unzipped name.
$year  = (Get-Date).Year
$files = @(
    # @{ name = "YOUR_FILE"; url = "CHANGE_ME → where to download it" }
    @{ name = "powerPlay.json"; url = "https://www.edsm.net/dump/powerPlay.json.gz"; gunzip = $true }
    @{ name = "systemsWithCoordinates7days.json"; url = "https://www.edsm.net/dump/systemsWithCoordinates7days.json.gz"; gunzip = $true }
    @{ name = "systemsWithoutCoordinates.json"; url = "https://www.edsm.net/dump/systemsWithoutCoordinates.json.gz"; gunzip = $true }
    @{ name = "bodies7days.json"; url = "https://www.edsm.net/dump/bodies7days.json.gz"; gunzip = $true }
)

$inbox = "dbfs:/Volumes/$Catalog/raw/inbox"

# Fail before downloading if the inbox can't be reached, e.g. a wrong profile.
$check = databricks fs ls $inbox --profile $DatabricksProfile 2>&1
if ($LASTEXITCODE -ne 0) { throw "Cannot reach $inbox (profile $DatabricksProfile): $check" }

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

foreach ($f in $files) {
    $temp = Join-Path ([System.IO.Path]::GetTempPath()) $f.name
    Write-Host "Downloading $($f.name)"
    # curl, not Invoke-WebRequest: some sites (e.g. FRED) reset its connection.
    if ($f.gunzip) {
        curl -sfL -o "$temp.gz" $f.url
        if ($LASTEXITCODE -ne 0) { throw "Download failed: $($f.name)" }
        $in   = [System.IO.File]::OpenRead("$temp.gz")
        $out  = [System.IO.File]::Create($temp)
        $gzip = [System.IO.Compression.GZipStream]::new($in, [System.IO.Compression.CompressionMode]::Decompress)
        $gzip.CopyTo($out)
        $gzip.Close(); $out.Close(); $in.Close()
        Remove-Item "$temp.gz"
    } else {
        curl -sfL -o $temp $f.url
        if ($LASTEXITCODE -ne 0) { throw "Download failed: $($f.name)" }
    }

    # Some sites answer with an HTML error page instead of the file.
    $head = (Get-Content $temp -TotalCount 1 -ErrorAction SilentlyContinue) -as [string]
    if ($head -match '^\s*<(!doctype html|html)') { throw "Got an HTML page, not $($f.name). See $temp" }

    Write-Host "Uploading to $inbox/$($f.name)"
    databricks fs cp $temp "$inbox/$($f.name)" --overwrite --profile $DatabricksProfile
    if ($LASTEXITCODE -ne 0) { throw "Upload failed: $($f.name)" }
    Remove-Item $temp
}
Write-Host "Done."
