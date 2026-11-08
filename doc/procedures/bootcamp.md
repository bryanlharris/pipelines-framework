# Build a One Table Dataset

This procedure teaches how to build a one-table pipeline using sdp-meta techniques. The finished
product reads an xml from a URL, saves it to S3, loads to bronze, then silver SCD2, then builds
a simple view to only show the "current" records from the SCD2.

- Catalog
- Schemas and volumes
- Upload script (ps1)
- Ingest job
- Apply Settings job
- Pipeline
- Fetch job

## Prerequisites

1. [setup.md](setup.md): set up the computer and CLI
2. [targets/](targets/README.md): set up your target

## Build

1. [add_catalog.md](bootcamp/add_catalog.md): add the catalog and its comment
2. [add_schemas_and_volumes.md](bootcamp/add_schemas_and_volumes.md): add the schemas and volumes
3. [add_upload_script.md](bootcamp/add_upload_script.md): add the upload script
4. [add_ingest_job.md](bootcamp/add_ingest_job.md): add the ingest job
5. [add_apply_settings_job.md](bootcamp/add_apply_settings_job.md): add the apply settings job
6. [add_bronze_settings.md](bootcamp/add_bronze_settings.md): add the bronze settings
7. [add_pipeline.md](bootcamp/add_pipeline.md): add the pipeline
8. [add_silver_scd2.md](bootcamp/add_silver_scd2.md): add the silver SCD2 table
9. [add_current_view.md](bootcamp/add_current_view.md): add the view
10. [add_fetch_job.md](bootcamp/add_fetch_job.md): add the fetch job
11. End.

## Practice on Treasury

US Treasury publishes daily interest rates as an XML file. Use these values for the blanks.

| Blank        | Value          |
|--------------|----------------|
| YOUR_DATASET | treasury       |
| YOUR_CATALOG | treasury       |
| YOUR_TABLE   | yieldCurve     |
| YOUR_FILE    | yieldCurve.xml |
| YOUR_TARGET  | free           |

On dev, YOUR_CATALOG is **dev_treasury**. See [setup_dev.md](targets/dev/setup_dev.md).

The url for **fetch.yml**:

https://home.treasury.gov/resource-center/data-chart-center/interest-rates/pages/xml?data=daily_treasury_yield_curve&field_tdr_date_value={year}
