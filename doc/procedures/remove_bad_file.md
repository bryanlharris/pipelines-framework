# Remove a Bad File

Skips a bad file, and loads a fixed copy if you have one. The bad file
stays in **raw/files**, since nothing there is ever deleted; the
**not_a_bad_file** rule in the dataset's **conf/bronze_expectations.yml**
skips it.

## Pipeline Stopped

A fail rule stopped the pipeline on the file. Its records never landed, so
no full refresh is needed.

1. Find the bad file in the failed update's error, or in
   **raw/files/YOUR_TABLE/**, e.g. **YOUR_TABLE_20261107_150000.json**.
2. Download it, and fix it on your computer.
3. Add a line for it to the **not_a_bad_file** rule: **'%/** and the
   file's name.
4. Deploy.
5. Run the apply settings job. In Jobs & Pipelines, open
   **YOUR_DATASET - apply settings**, and click Run now.
6. Upload the fixed file to the inbox. The router gives it a new name, and
   the ingest job runs.
7. Open **YOUR_DATASET - ingest**. The run is green.
8. End.

```
databricks fs cp dbfs:/Volumes/YOUR_CATALOG/raw/files/YOUR_TABLE/YOUR_FILE . -p YOUR_TARGET
edit YOUR_FILE
edit datasets/YOUR_DATASET/conf/bronze_expectations.yml
databricks bundle deploy -t YOUR_TARGET
databricks fs cp YOUR_FILE dbfs:/Volumes/YOUR_CATALOG/raw/inbox/ -p YOUR_TARGET
```

## Records Already Landed

The file's records are already in bronze and silver. A full refresh
rebuilds both from **raw/files**, without them.

1. Find the bad file in **raw/files/YOUR_TABLE/**.
2. Add a line for it to the **not_a_bad_file** rule.
3. Deploy.
4. Run the apply settings job.
5. Full refresh the pipeline.
6. Ask Genie: "Are any records in YOUR_CATALOG.silver.YOUR_TABLE from
   YOUR_FILE?" None are.
7. End.

```
databricks fs ls dbfs:/Volumes/YOUR_CATALOG/raw/files/YOUR_TABLE
edit datasets/YOUR_DATASET/conf/bronze_expectations.yml
databricks bundle deploy -t YOUR_TARGET
databricks bundle run YOUR_DATASET_pipeline -t YOUR_TARGET --full-refresh-all
```

## The Rule

```
expect_or_drop:
  not_a_bad_file: >-
    NOT source_file LIKE ANY (
      '%/none',
      '%/YOUR_TABLE_20261107_150000.json'
    )
```
