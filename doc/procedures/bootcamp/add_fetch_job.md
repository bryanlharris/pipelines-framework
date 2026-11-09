← [add_current_view.md](add_current_view.md) | none →

# Add the Fetch Job

Fetches files on a schedule. It downloads each file in **fetch.yml** into
**inbox/**. The schedule starts paused but can be unpaused in the yml file.

1. Copy the fetch list template into the dataset's folder.
2. Replace **YOUR_FILE**.
3. Change the **CHANGE_ME** line.
4. Read the fetch job template into **resources.yml**, after the apply
   settings job. Go to that job's last line,
   **${var.sdp_meta_dependency}**, and add the template's lines below it.
   - vim: type **:r doc/templates/bootcamp/fetch/resources.yml**
   - VS Code: open the template, press **Ctrl+A** and **Ctrl+C**. Click
     the very start of the next line, and press **Ctrl+V**.
   - Then replace **YOUR_DATASET** in **resources.yml**.
5. Check the plan. One job shows create.
6. Deploy.
7. Check the plan again. All show unchanged.
8. Run the fetch job.
9. Open its run. **list_fetches** shows 📋 and the url. **fetch** shows
   ✅ and the file's size.
10. Open the ingest job. A new run started, from the fetched file.

```
cp doc/templates/bootcamp/fetch/fetch.yml datasets/YOUR_DATASET/
edit datasets/YOUR_DATASET/fetch.yml
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
databricks bundle run YOUR_DATASET_fetch -t YOUR_TARGET
```

---

← [add_current_view.md](add_current_view.md) | none →
