← [add_schemas_and_volumes.md](add_schemas_and_volumes.md) | [add_ingest_job.md](add_ingest_job.md) →

# Add an Upload Script

Puts a file in **inbox/** from your computer.

1. Copy the upload template into the dataset's folder.
2. Replace **YOUR_DATASET** and **YOUR_TABLE**.
3. Change the two **CHANGE_ME** lines.
4. Run it.
5. List **inbox/**. The file is there.
6. Delete it, so the ingest job sees the next upload as new.

```
cp doc/templates/upload/upload.ps1 datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
edit datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
databricks fs ls dbfs:/Volumes/YOUR_CATALOG/raw/inbox
databricks fs rm dbfs:/Volumes/YOUR_CATALOG/raw/inbox/YOUR_FILE
```

---

← [add_schemas_and_volumes.md](add_schemas_and_volumes.md) | [add_ingest_job.md](add_ingest_job.md) →
