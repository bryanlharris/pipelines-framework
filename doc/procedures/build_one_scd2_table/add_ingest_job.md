← [add_upload_script.md](add_upload_script.md) | [add_apply_settings_job.md](add_apply_settings_job.md) →

# Add the Ingest Job

Moves each new file from **inbox/** to **files/**, with a time stamp. The
pipeline part adds the rest: bronze and silver.

1. Add the ingest template to the end of **resources.yml**.
2. Replace **YOUR_DATASET** and **YOUR_TABLE**.
3. Check the plan. One job shows create.
4. Deploy.
5. Check the plan again. All show unchanged.
6. Upload a file. The job starts a minute or two later.
7. List **files/**. The file is there, with a time stamp.

```
cat doc/templates/ingest/resources.yml >> datasets/YOUR_DATASET/resources.yml
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
databricks fs ls dbfs:/Volumes/YOUR_CATALOG/raw/files/YOUR_TABLE
```

---

← [add_upload_script.md](add_upload_script.md) | [add_apply_settings_job.md](add_apply_settings_job.md) →
