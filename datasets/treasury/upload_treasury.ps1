# Downloads this year's daily yield curve XML and uploads it to the treasury inbox.
# Runs on the PC, like upload_edsm.ps1. The router (job "treasury") adds the
# time stamp and moves it to raw.files. Each file holds the whole year so far.
#
#   .\datasets\treasury\upload_treasury.ps1               # this year
#   .\datasets\treasury\upload_treasury.ps1 -Year 2025    # another year

param(
    [int]$Year = (Get-Date).Year,
    [string]$DatabricksProfile = "DEFAULT"
)

$inbox = "dbfs:/Volumes/treasury/raw/inbox"
$work  = "$env:TEMP\treasury_upload"
$xml   = "$work\yieldCurve.xml"
$url   = "https://home.treasury.gov/resource-center/data-chart-center/interest-rates/pages/xml?data=daily_treasury_yield_curve&field_tdr_date_value=$Year"
New-Item -ItemType Directory -Force $work | Out-Null

Write-Host "Downloading yieldCurve $Year"
Invoke-WebRequest -Uri $url -OutFile $xml

Write-Host "Uploading to $inbox/yieldCurve.xml"
databricks fs cp $xml "$inbox/yieldCurve.xml" --overwrite --profile $DatabricksProfile
if ($LASTEXITCODE -ne 0) { throw "Upload failed: yieldCurve" }

Remove-Item $xml
Write-Host "Done. Job treasury starts about a minute after the last upload."
