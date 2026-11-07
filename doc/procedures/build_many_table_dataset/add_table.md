← [add_dataset.md](add_dataset.md) | none →

# Add a Table

Adds a table to a dataset: bronze, silver SCD2 and a current view. Each
dataset file keeps one commented block per table; you copy it, and
uncomment the copy.

To add several tables, do steps 1–8 for each table, then steps 9–17 once.

To copy a block, and uncomment the copy:

- vim: on the block's first line, type **V**, go to its last line, and type
  **y**. Go to the **To here** line, and type **p**. Then type
  **:'[,']s/# //**
- VS Code: select the block, and press **Ctrl+C**. Click the end of the
  **To here** line, press **Enter**, then **Ctrl+V**. Select the pasted
  lines, and press **Ctrl+/**.

## Enterprise Edition

1. Set **$d**, **$t** and **$f**: the dataset, the table, and its file,
   e.g. **powerPlay.json**. Name the file after the table.
2. In **conf/onboarding.yml**, copy the table block, and uncomment the
   copy. Change its **CHANGE_ME** lines.
3. Do the same in **conf/silver_transformations.yml**. For the casts, give
   the AI a sample file, and ask for the select lines.
4. Do the same in **fetch.yml**.
5. In **resources.yml**, copy the **# - YOUR_TABLE** line under
   **--names**, and uncomment the copy.
6. Copy the view template into **views/**. Change its **CHANGE_ME** line.
7. Replace **YOUR_TABLE** and **YOUR_FILE** in the uncommented lines.
8. Search for leftovers outside comments. Nothing shows.
9. Check the plan. The ingest job shows change, for **--names**. Nothing
   else changes.
10. Deploy.
11. Check the plan again. All show unchanged.
12. Run the fetch job, **YOUR_DATASET - fetch**. It fetches every file in
    **fetch.yml**, not just the new table's; repeats add no new versions.
    The ingest job runs, and skips the new table: its settings come next.
13. Run the apply settings job. In Jobs & Pipelines, open
    **YOUR_DATASET - apply settings**, and click Run now. Apply settings
    after the file lands: the pipeline fails on a new table with no files.
14. Run **YOUR_DATASET - ingest** by hand: open it, and click Run now. The
    run is green.
15. Ask Genie: "How many records are in YOUR_CATALOG.silver.YOUR_TABLE_history?"
16. Ask Genie: "How many records are in YOUR_CATALOG.silver.YOUR_TABLE?"
17. End.

```
$d = "YOUR_DATASET"
$t = "YOUR_TABLE"
$f = "YOUR_FILE"
edit datasets/$d/conf/onboarding.yml
edit datasets/$d/conf/silver_transformations.yml
edit datasets/$d/fetch.yml
edit datasets/$d/resources.yml
cp doc/templates/dataset/views/YOUR_TABLE.sql datasets/$d/views/$t.sql
edit datasets/$d/views/$t.sql
sed -i "/^\s*#/!{s/YOUR_TABLE/$t/g; s/YOUR_FILE/$f/g}" (grep -rlE "YOUR_TABLE|YOUR_FILE" datasets/$d)
grep -rnE "YOUR_|CHANGE_ME" datasets/$d | grep -vE ":[0-9]+:\s*(#|--)"
py tools/bundle_plan.py dev
databricks bundle deploy -t dev
py tools/bundle_plan.py dev
```

## Free Edition

1. Set **$d**, **$t** and **$f**: the dataset, the table, and its file,
   e.g. **powerPlay.json**. Name the file after the table.
2. In **conf/onboarding.yml**, copy the table block, and uncomment the
   copy. Change its **CHANGE_ME** lines.
3. Do the same in **conf/silver_transformations.yml**. For the casts, give
   the AI a sample file, and ask for the select lines.
4. Do the same with the commented line in the upload script. If the
   dataset will run on enterprise too, do the same in **fetch.yml**.
5. In **resources.yml**, copy the **# - YOUR_TABLE** line under
   **--names**, and uncomment the copy.
6. Copy the view template into **views/**. Change its **CHANGE_ME** line.
7. Replace **YOUR_TABLE** and **YOUR_FILE** in the uncommented lines.
8. Search for leftovers outside comments. Nothing shows.
9. Check the plan. The ingest job shows change, for **--names**. Nothing
   else changes.
10. Deploy.
11. Check the plan again. All show unchanged.
12. Run the upload script. It sends every file it lists, not just the new
    table's; repeats add no new versions. The ingest job runs, and skips
    the new table: its settings come next.
13. Run the apply settings job. In Jobs & Pipelines, open
    **YOUR_DATASET - apply settings**, and click Run now. Apply settings
    after the file lands: the pipeline fails on a new table with no files.
14. Run **YOUR_DATASET - ingest** by hand: open it, and click Run now. The
    run is green.
15. Ask Genie: "How many records are in YOUR_CATALOG.silver.YOUR_TABLE_history?"
16. Ask Genie: "How many records are in YOUR_CATALOG.silver.YOUR_TABLE?"
17. End.

```
$d = "YOUR_DATASET"
$t = "YOUR_TABLE"
$f = "YOUR_FILE"
edit datasets/$d/conf/onboarding.yml
edit datasets/$d/conf/silver_transformations.yml
edit datasets/$d/upload_$d.ps1
edit datasets/$d/fetch.yml
edit datasets/$d/resources.yml
cp doc/templates/dataset/views/YOUR_TABLE.sql datasets/$d/views/$t.sql
edit datasets/$d/views/$t.sql
sed -i "/^\s*#/!{s/YOUR_TABLE/$t/g; s/YOUR_FILE/$f/g}" (grep -rlE "YOUR_TABLE|YOUR_FILE" datasets/$d)
grep -rnE "YOUR_|CHANGE_ME" datasets/$d | grep -vE ":[0-9]+:\s*(#|--)"
py tools/bundle_plan.py free
databricks bundle deploy -t free
py tools/bundle_plan.py free
& ./datasets/$d/upload_$d.ps1
```

---

← [add_dataset.md](add_dataset.md) | none →
