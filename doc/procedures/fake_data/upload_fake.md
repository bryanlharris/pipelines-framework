← [make_fake_file.md](make_fake_file.md) | [wipe_dev.md](wipe_dev.md) →

# Upload Fake Files

Sends a dataset's fake files to your dev copy's inbox. The ingest job takes
them from there, the same as real files.

Each dataset's upload script does this with **-Fake**. Without it, the
script downloads real files: that's for free only. On dev, never run the
fetch job: it downloads real data. Its schedule starts paused.

Each run gives the files a new inbox name, e.g.
**fedfunds_fake_143005.csv**, so the ingest job starts every time.

## Prerequisites

1. The dataset has a **fake/** folder: [make_fake_file.md](make_fake_file.md)
2. The apply settings job has run on dev since the last change to **conf/**

## Steps

1. Run the upload script with **-Fake**, your catalog and the **dev**
   profile.
2. Check the ingest job's latest run. It's green. If it didn't start, run
   it by hand.
3. Ask Genie: "Show YOUR_CATALOG.silver.YOUR_TABLE." The values are fake.
4. End.

```
./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1 -Fake -Catalog YOUR_CATALOG -DatabricksProfile dev
databricks bundle run YOUR_DATASET_ingest -t dev
```

← [make_fake_file.md](make_fake_file.md) | [wipe_dev.md](wipe_dev.md) →
