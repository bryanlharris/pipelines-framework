← [add_current_view.md](add_current_view.md) | none →

# Add the Fetch Job

Fetches files on a schedule.
It downloads each file in **fetch.yml** into **inbox/**, and the ingest
job takes over. The schedule starts paused.

1. Copy the fetch list template into the dataset's folder.
2. Replace **YOUR_FILE**.
3. Change the **CHANGE_ME** line.
4. Read the fetch job template into **resources.yml**, after the apply
   settings job. Go to that job's last line,
   **${var.sdp_meta_dependency}**, and add the template's lines below it.
   In vim, type
   :r doc/templates/fetch/resources.yml
5. Replace **YOUR_DATASET**.
6. Check the plan. One job shows create.
7. Deploy.
8. Check the plan again. All show unchanged.
9. Run the fetch job.
10. Open its run. **list_fetches** shows 📋 and the url. **fetch** shows
    ✅ and the file's size.
11. Open the ingest job. A new run started, from the fetched file.

```
cp doc/templates/fetch/fetch.yml datasets/YOUR_DATASET/
edit datasets/YOUR_DATASET/fetch.yml
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
databricks bundle run YOUR_DATASET_fetch -t YOUR_TARGET
```

---

← [add_current_view.md](add_current_view.md) | none →
