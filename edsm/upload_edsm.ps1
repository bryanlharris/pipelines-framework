# Downloads the edsm dumps and uploads them to the edsm inbox.
# Free Edition has no internet access to edsm, so this runs on the PC.
# The router (job "edsm") adds the time stamp and moves them to raw.files.
#
#   .\edsm\upload_edsm.ps1                 # both dumps
#   .\edsm\upload_edsm.ps1 -Names powerPlay

param(
    [string[]]$Names = @("powerPlay", "systemsWithCoordinates7days"),
    [string]$DatabricksProfile = "DEFAULT"
)

$inbox = "dbfs:/Volumes/edsm/raw/inbox"
$work  = "$env:TEMP\edsm_upload"
New-Item -ItemType Directory -Force $work | Out-Null

foreach ($name in $Names) {
    $gz   = "$work\$name.json.gz"
    $json = "$work\$name.json"

    Write-Host "Downloading $name"
    Invoke-WebRequest -Uri "https://www.edsm.net/dump/$name.json.gz" -OutFile $gz

    $in   = [System.IO.File]::OpenRead($gz)
    $out  = [System.IO.File]::Create($json)
    $gzip = New-Object System.IO.Compression.GZipStream($in, [System.IO.Compression.CompressionMode]::Decompress)
    $gzip.CopyTo($out)
    $gzip.Close(); $out.Close(); $in.Close()

    Write-Host "Uploading to $inbox/$name.json"
    databricks fs cp $json "$inbox/$name.json" --overwrite --profile $DatabricksProfile
    if ($LASTEXITCODE -ne 0) { throw "Upload failed: $name" }

    Remove-Item $gz, $json
}

Write-Host "Done. Job edsm starts about a minute after the last upload."
