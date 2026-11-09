← [add_silver_scd2.md](add_silver_scd2.md) | [add_fetch_job.md](add_fetch_job.md) →

# Add a Current View

Every history table can have a current view. The view shows the latest
version of each record, not the full history.

1. Make the **tables/** folder.
2. Copy the current view template into it, as **silver.YOUR_TABLE**.sql.
3. Read the library template into the pipeline. Go to the notebook
   library's last line, **path**, and add the template's lines below it.
   - vim: type **:r doc/templates/bootcamp/view/pipeline_library.yml**
   - VS Code: open the template, press **Ctrl+A** and **Ctrl+C**. Click
     the very start of the next line, and press **Ctrl+V**.
   - Then replace **YOUR_TABLE** in **resources.yml**.
4. Open the view, **tables/silver.YOUR_TABLE**.sql.
5. Replace **YOUR_TABLE**.
6. Change the **CHANGE_ME** line.
7. Check the plan. The pipeline shows change.
8. Deploy.
9. Check the plan again. All show unchanged.
10. Upload a file. The ingest job runs the router, then the pipeline.
11. Open the pipeline's last update. Its graph shows the view after the
    history table.
12. Ask Genie how many records the view has. As many as the history
    table, until a value changes.

```
mkdir datasets/YOUR_DATASET/tables/
cp doc/templates/bootcamp/view/current.sql datasets/YOUR_DATASET/tables/silver.YOUR_TABLE.sql
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
