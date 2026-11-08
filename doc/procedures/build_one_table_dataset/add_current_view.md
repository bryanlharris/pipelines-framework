← [add_silver_scd2.md](add_silver_scd2.md) | [add_fetch_job.md](add_fetch_job.md) →

# Add a Current View

The view shows only the current version of each record, without
**__START_AT** and **__END_AT**. It takes the table's plain name; the
history table keeps **_history**. The pipeline makes the view, after the
history table.

1. Make the **tables/** folder.
2. Copy the current view template into it, as **silver.YOUR_TABLE**.sql.
3. Read the library template into the pipeline. Go to the notebook
   library's last line, **path**, and add the template's lines below it.
   In vim, type
   :r doc/templates/build_one_table_dataset/view/pipeline_library.yml
4. Replace **YOUR_TABLE** in **resources.yml**.
5. Open the view, **tables/silver.YOUR_TABLE**.sql.
6. Replace **YOUR_TABLE**.
7. Change the **CHANGE_ME** line.
8. Check the plan. The pipeline shows update.
9. Deploy.
10. Check the plan again. All show unchanged.
11. Upload a file. The ingest job runs the router, then the pipeline.
12. Open the pipeline's last update. Its graph shows the view after the
    history table.
13. Ask Genie how many records the view has. As many as the history
    table, until a value changes.

```
mkdir datasets/YOUR_DATASET/tables/
cp doc/templates/build_one_table_dataset/view/current.sql datasets/YOUR_DATASET/tables/silver.YOUR_TABLE.sql
edit datasets/YOUR_DATASET/resources.yml
edit datasets/YOUR_DATASET/tables/silver.YOUR_TABLE.sql
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
Genie → How many records in YOUR_DATASET.silver.YOUR_TABLE?
```

---

← [add_silver_scd2.md](add_silver_scd2.md) | [add_fetch_job.md](add_fetch_job.md) →
