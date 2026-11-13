← [upload_fake.md](upload_fake.md) | none →

# Wipe Dev

Dev only. Empties your dev copy of a dataset, so the next upload starts
fresh. Never do this on staging or prod: there, nothing in raw files is
ever deleted.

## Steps

1. Check the catalog starts with your dev prefix, e.g.
   **dev_jim_treasury**. Stop if it doesn't.
2. In Catalog Explorer, open **YOUR_CATALOG.raw.files**, and delete each
   table's folder.
3. Open **YOUR_CATALOG.raw.inbox**, and delete any files left there.
4. Full refresh the pipeline. Bronze and silver come back empty.
5. Ask Genie: "How many records are in YOUR_CATALOG.silver.YOUR_TABLE?"
   None are.
6. End.

```
databricks fs rm -r dbfs:/Volumes/YOUR_CATALOG/raw/files/YOUR_TABLE -p dev
databricks fs ls dbfs:/Volumes/YOUR_CATALOG/raw/inbox -p dev
databricks bundle run YOUR_DATASET_pipeline -t dev --full-refresh-all
```

← [upload_fake.md](upload_fake.md) | none →
