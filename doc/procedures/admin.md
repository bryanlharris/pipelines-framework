# Admin

Small tasks you run now and then. Each section stands alone.

## Names in Commands

**bundle run** takes the key from **resources.yml**, not the name the GUI
shows.

```
  pipelines:
    edsm_pipeline:              <- the key: databricks bundle run edsm_pipeline
      name: edsm - pipeline     <- the name in the GUI
```

Jobs work the same way, e.g. **edsm_apply_settings** and **edsm_ingest**.

## Apply Settings

After any change to **conf/**, deploy then apply settings.
The pipeline reads its settings from tables that get populated
from the deployed **conf/** (not from your laptop) by this job.

1. Deploy the bundle.
2. Run the apply settings job.
3. End.

```
databricks bundle deploy -t YOUR_TARGET
databricks bundle run YOUR_DATASET_apply_settings -t YOUR_TARGET
```

## Refresh

A refresh loads new files only. The ingest job does this after each file
lands; run it by hand to retry a failed update.

1. Run the pipeline.
2. End.

```
databricks bundle run YOUR_DATASET_pipeline -t YOUR_TARGET
```

## Full Refresh

A full refresh empties the tables and rebuilds them from every file in
**raw/files**. It is slow and costs more on a big dataset. Rebuild one table
when only one is wrong.

1. Full refresh every table, or just one table's bronze and silver.
2. End.

```
databricks bundle run YOUR_DATASET_pipeline -t YOUR_TARGET --full-refresh-all
databricks bundle run YOUR_DATASET_pipeline -t YOUR_TARGET --full-refresh bronze.YOUR_TABLE,silver.YOUR_TABLE_history
```

## Run Ingest by Hand

Files can sit in the inbox when a run was stopped, or the trigger missed
them. The ingest job moves them, then runs the pipeline and the views.

1. Run the ingest job.
2. End.

```
databricks bundle run YOUR_DATASET_ingest -t YOUR_TARGET
```

## Check Unknown Files

The router moves a file it can't match to a table into **inbox/unknown_files/**.
Its name must start with a table's name, e.g. **powerPlay.json**.

1. List the unknown files.
2. If the name is wrong, move the file back to the inbox with the right
   name. The ingest job runs.
3. If it is a new table, add the table first: see
   [add_table.md](build_many_table_dataset/add_table.md).
4. End.

```
databricks fs ls dbfs:/Volumes/YOUR_CATALOG/raw/inbox/unknown_files -p YOUR_TARGET
databricks fs mv dbfs:/Volumes/YOUR_CATALOG/raw/inbox/unknown_files/YOUR_FILE dbfs:/Volumes/YOUR_CATALOG/raw/inbox/YOUR_FILE -p YOUR_TARGET
```

## Check Rule Counts

Rules in **conf/bronze_expectations.yml** and **conf/silver_expectations/**
count each record they drop or warn about.

1. Open the pipeline in Jobs & Pipelines, and click a table.
2. Open the **Data quality** tab. Each rule shows passed and failed records.
3. End.

## Find a Pipeline Error

1. Open the pipeline in Jobs & Pipelines.
2. Click the failed update.
3. In the event log, filter on **Error**. The first error is the cause; the
   rest follow from it.
4. End.

## Stop a Stuck Pipeline

1. Open the pipeline in Jobs & Pipelines.
2. Click **Stop**.
3. End.

## Pause or Start the Fetch Schedule

Change a fetch job's schedule in the dataset's **resources.yml**. Don't change it in the GUI.

1. Set **pause_status** under **schedule:** to **PAUSED** or **UNPAUSED**.
2. Deploy.
3. End.

```
edit datasets/YOUR_DATASET/resources.yml
databricks bundle deploy -t YOUR_TARGET
```

```
    YOUR_DATASET_fetch:
      name: YOUR_DATASET - fetch
      schedule:
        quartz_cron_expression: "0 17 4 * * ?"
        timezone_id: America/Chicago
        pause_status: PAUSED
```

## Deploy Fails: No Volume Is Defined

A new dataset's inbox can take a few minutes to show up. Until then, the
ingest job can't watch it.

1. Wait a few minutes.
2. Deploy again.
3. End.

```
databricks bundle deploy -t YOUR_TARGET
```
