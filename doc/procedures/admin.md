# Admin

Small tasks you run now and then. Each section stands alone.

## Names in Commands

**bundle run** takes the key from **resources.yml**, not the name the GUI
shows.

```
  pipelines:
    edsm_pipeline:              <- the key: databricks bundle run edsm_pipeline
      name: ${var.catalog_prefix}edsm - pipeline   <- the name in the GUI
```

The GUI name starts with the target's prefix, e.g. **edsm - pipeline** on
free, **dev_jim_edsm - pipeline** on dev. The key never changes.
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
them. The ingest job moves them, then runs the pipeline.

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

1. Open the pipeline's failed update.
2. List its errors. The first error is the cause; the rest follow from it.
3. End.

```
databricks pipelines logs YOUR_DATASET_pipeline -t YOUR_TARGET --level ERROR
```

## Stop a Stuck Pipeline

1. Stop the pipeline.
2. End.

```
databricks pipelines stop YOUR_DATASET_pipeline -t YOUR_TARGET
```

## Table Is Managed by Another Pipeline

Only the pipeline that made a table can update it. If the bundle loses its
pipeline, e.g. after a deploy that stopped partway, it makes a new one, and
the new one fails on the old tables. The error names the old pipeline's
number.

1. Look up the old pipeline by its number.
2. If it exists, bind it to the bundle key. Then delete the new, empty
   pipeline in the GUI: the one created later.
3. If it doesn't exist, drop each table the error names. raw.files keeps
   every file, so nothing is lost.
4. Run the pipeline. It rebuilds what you dropped. If another table fails
   with the same number, drop it too, and run again.
5. Check the plan. All show unchanged.
6. End.

```
databricks pipelines get YOUR_PIPELINE_ID -p YOUR_TARGET
databricks bundle deployment bind YOUR_DATASET_pipeline YOUR_PIPELINE_ID -t YOUR_TARGET --auto-approve
DROP TABLE YOUR_CATALOG.YOUR_SCHEMA.YOUR_TABLE;
databricks bundle run YOUR_DATASET_pipeline -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
```

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

## Give a User One Catalog

CREATE CATALOG covers every name, so instead an admin makes the catalog and
hands it over. The user's bundle then takes it over with a bind.

1. An admin creates the catalog, **YOUR_CATALOG**, e.g. **dev_jim_treasury**.
2. The admin makes the user its owner, or grants **ALL PRIVILEGES**.
3. The user binds it, once per target.
4. Check the plan. The catalog shows change, never create.
5. Deploy.
6. End.

```
CREATE CATALOG YOUR_CATALOG
databricks bundle deployment bind YOUR_DATASET YOUR_CATALOG -t YOUR_TARGET --auto-approve
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
```

## Deploy Fails: No Volume Is Defined

A new dataset's inbox can take a few minutes to show up. If that happens
just run the deploy again after a minute or two.

1. Wait a few minutes.
2. Deploy again.
3. End.

```
databricks bundle deploy -t YOUR_TARGET
```

When I deployed new datasets on free,
  the ingest job failed with "No volume is defined at /Volumes/edsm/raw/inbox/". The inbox volume had
  just been made and wasn't visible yet. A few minutes later, deploying again worked. It happened for
  edsm, fred and documents