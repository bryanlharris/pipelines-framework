← [add_silver_scd2.md](add_silver_scd2.md) | [add_fetch_job.md](add_fetch_job.md) →

# Add a Current View

The view shows only the current version of each record, without
**__START_AT** and **__END_AT**. It takes the table's plain name; the
history table keeps **_history**. The ingest job remakes the views
after each pipeline run.

1. Make the **views/** folder.
2. Copy the current view template into it, as **YOUR_TABLE**.sql.
3. Read the views task template into the ingest job, after the pipeline
   task. Go to the pipeline task's last line, **pipeline_id**, and add the
   template's lines below it. In vim, type
   :r doc/templates/build_one_table_dataset/view/ingest_task.yml
4. Replace **YOUR_DATASET** in **resources.yml**.
5. Open the view, **views/YOUR_TABLE**.sql.
6. Replace **YOUR_TABLE**.
7. Change the **CHANGE_ME** line.
8. Check the plan. The ingest job shows update.
9. Deploy.
10. Check the plan again. All show unchanged.
11. Open the ingest job in Jobs & Pipelines. Its tasks now end with **views**.
12. Upload a file. The ingest job runs the router, the pipeline, then
    the views.
13. Open the **views** task's output. It shows ✅ **YOUR_TABLE**.sql.
14. Ask Genie how many records the view has. As many as the history
    table, until a value changes.

```
mkdir datasets/YOUR_DATASET/views/
cp doc/templates/build_one_table_dataset/view/current.sql datasets/YOUR_DATASET/views/YOUR_TABLE.sql
edit datasets/YOUR_DATASET/resources.yml
edit datasets/YOUR_DATASET/views/YOUR_TABLE.sql
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
Genie → How many records in YOUR_DATASET.silver.YOUR_TABLE?
```

---

← [add_silver_scd2.md](add_silver_scd2.md) | [add_fetch_job.md](add_fetch_job.md) →
