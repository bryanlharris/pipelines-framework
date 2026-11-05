# Uploads every PDF in a folder to the documents inbox.
# Each file is named pdf_<its name>.pdf in the inbox, so the router knows
# it belongs to table pdf. The router (job "documents - ingest") adds the time stamp
# and moves it to raw.files.
#
#   .\datasets\documents\upload_documents.ps1 C:\temp\pdfs
#
# Test PDFs with fake PII: py datasets/documents/make_fake_pdf.py -n 9 C:\temp\pdfs

param(
    [Parameter(Mandatory = $true)][string]$Folder,
    [string]$DatabricksProfile = "DEFAULT"
)

$inbox = "dbfs:/Volumes/documents/raw/inbox"
$pdfs  = Get-ChildItem -Path $Folder -Filter *.pdf -File
if (-not $pdfs) { throw "No PDFs in $Folder" }

foreach ($pdf in $pdfs) {
    $name = if ($pdf.BaseName -like "pdf_*") { $pdf.Name } else { "pdf_$($pdf.Name)" }
    Write-Host "Uploading $($pdf.Name) to $inbox/$name"
    databricks fs cp $pdf.FullName "$inbox/$name" --overwrite --profile $DatabricksProfile
    if ($LASTEXITCODE -ne 0) { throw "Upload failed: $($pdf.Name)" }
}

Write-Host "Done. $($pdfs.Count) PDFs. Job "documents - ingest" starts a minute or two after the last upload."
