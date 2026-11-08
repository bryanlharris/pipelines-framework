← [add_pipeline.md](add_pipeline.md) | [add_current_view.md](add_current_view.md) →

# Add a Silver SCD2 Table

Silver keeps every version of each record with a **__START_AT** and
**__END_AT** date range for each record.

1. Add the silver template to the end of **conf/onboarding.yml**.
2. Copy the silver transformations template into **conf/**.
3. Replace **YOUR_TABLE** in both.
4. Change the **CHANGE_ME** lines in both.
5. Deploy. It uploads **conf/**.
6. Run the apply settings job.
7. Ask Genie for the silver settings. One record, for **YOUR_TABLE**_history.
8. Upload a file.
9. Open the pipeline's latest update. Its graph shows bronze, then silver.
10. Ask Genie how many records the silver table has. One per record
    name, unless a value changed.

```
cat doc/templates/bootcamp/silver_scd2/onboarding.yml >> datasets/YOUR_DATASET/conf/onboarding.yml
cp doc/templates/bootcamp/silver_scd2/silver_transformations.yml datasets/YOUR_DATASET/conf/
edit datasets/YOUR_DATASET/conf/onboarding.yml
edit datasets/YOUR_DATASET/conf/silver_transformations.yml
databricks bundle deploy -t YOUR_TARGET
databricks bundle run YOUR_DATASET_apply_settings -t YOUR_TARGET
Genie → Show the records in YOUR_DATASET.sdp_meta.silver_dataflowspec.
./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
Genie → How many records in YOUR_DATASET.silver.YOUR_TABLE_history?
```

---

← [add_pipeline.md](add_pipeline.md) | [add_current_view.md](add_current_view.md) →
