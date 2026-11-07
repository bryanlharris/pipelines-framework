← [setup_dev.md](setup_dev.md) | [release_dev.md](release_dev.md) →

# Test Dev

Runs a dataset on dev end to end, to prove the target works.

1. Run the apply settings job. In Jobs & Pipelines, open
   **YOUR_DATASET - apply settings**, and click Run now.
2. Run the fetch job, **YOUR_DATASET - fetch**. The ingest job starts when
   the file lands.
3. Open **YOUR_DATASET - ingest**. The run is green.
4. Ask Genie: "How many records are in YOUR_CATALOG.silver.YOUR_TABLE_history?"
5. Ask Genie: "How many records are in YOUR_CATALOG.silver.YOUR_TABLE?"
6. Check the plan. All show unchanged.
7. End.

```
py tools/bundle_plan.py dev
```

## Practice on Treasury

| Blank        | Value        |
|--------------|--------------|
| YOUR_DATASET | treasury     |
| YOUR_CATALOG | dev_treasury |
| YOUR_TABLE   | yieldCurve   |

---

← [setup_dev.md](setup_dev.md) | [release_dev.md](release_dev.md) →
