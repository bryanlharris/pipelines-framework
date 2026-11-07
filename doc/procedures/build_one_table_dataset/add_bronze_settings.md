← [add_apply_settings_job.md](add_apply_settings_job.md) | [add_pipeline.md](add_pipeline.md) →

# Add Bronze Settings

Starts **conf/onboarding.yml** with one table's bronze entry, then applies
it.

1. Make the **conf/** folder.
2. Copy the bronze template into it.
3. Replace **YOUR_DATASET** and **YOUR_TABLE**.
4. Change the **CHANGE_ME** lines.
5. Deploy. It uploads **conf/**.
6. Run the apply settings job.
7. Check the bronze settings table. One record, for **YOUR_TABLE**. Its
   source path starts **/Volumes/YOUR_CATALOG/**, not
   **${workspace.file_path}**.

```
mkdir datasets/YOUR_DATASET/conf/
cp doc/templates/build_one_table_dataset/bronze/onboarding.yml datasets/YOUR_DATASET/conf/
edit datasets/YOUR_DATASET/conf/onboarding.yml
databricks bundle deploy -t YOUR_TARGET
databricks bundle run YOUR_DATASET_apply_settings -t YOUR_TARGET
SELECT dataFlowId, sourceDetails, targetDetails FROM YOUR_DATASET.sdp_meta.bronze_dataflowspec
```

---

← [add_apply_settings_job.md](add_apply_settings_job.md) | [add_pipeline.md](add_pipeline.md) →
