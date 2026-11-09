# Bootcamp

This procedure teaches how to build a one-table pipeline. You'll learn about each of these things:

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

| Blank        | Free           | Dev                   |
|--------------|----------------|-----------------------|
| YOUR_DATASET | treasury       | treasury              |
| YOUR_CATALOG | treasury       | dev_jim_treasury      |
| YOUR_TABLE   | yieldCurve     | yieldCurve            |
| YOUR_FILE    | yieldCurve.xml | yieldCurve.xml        |
| YOUR_TARGET  | free           | dev                   |

On dev, the catalog starts with dev_ and your first name. See
[dev_team.md](targets/dev_team.md).

The url for **fetch.yml**:

https://home.treasury.gov/resource-center/data-chart-center/interest-rates/pages/xml?data=daily_treasury_yield_curve&field_tdr_date_value={year}
