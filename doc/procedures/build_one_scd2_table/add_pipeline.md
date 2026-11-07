← [add_bronze_settings.md](add_bronze_settings.md) | [add_silver_scd2.md](add_silver_scd2.md) →

# Add the Pipeline

The pipeline loads files into bronze, then silver, as the settings
tables say. The ingest job runs it after the router moves a file.

1. Add the pipeline template to the end of **resources.yml**.
2. Read the ingest tasks template into the ingest job, after the router
   task. Go to the router's last line, **YOUR_TABLE**, and add the
   template's lines below it. In vim, type
   :r doc/templates/pipeline/ingest_tasks.yml
3. Replace **YOUR_DATASET**.
4. Check the plan. One pipeline shows create, and the ingest job update.
5. Deploy.
6. Check the plan again. All show unchanged.
7. Open the ingest job in Jobs & Pipelines. Its tasks now run **router**,
   **any_moved**, **pipeline**, in a chain.
8. Upload a file. The ingest job runs the router, then the pipeline.
9. Open the pipeline's latest update. Its graph shows the bronze table.
10. Ask Genie how many records the bronze table has.

```
cat doc/templates/pipeline/resources.yml >> datasets/YOUR_DATASET/resources.yml
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
Genie → How many records in YOUR_DATASET.bronze.YOUR_TABLE?
```

---

← [add_bronze_settings.md](add_bronze_settings.md) | [add_silver_scd2.md](add_silver_scd2.md) →
