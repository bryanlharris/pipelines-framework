← [add_ingest_job.md](add_ingest_job.md) | [add_bronze_settings.md](add_bronze_settings.md) →

# Add the Apply Settings Job

The sdp pipeline reads its settings from tables this job writes. It
turns **datasets/YOUR_DATASET/conf/*.yml** into those tables. Run it
after each change to **conf/*.yml**. Databricks folks call this onboarding; we
call it apply settings, for now.

The template adds a second job under the **jobs:** section, so the
ingest job must be last in **resources.yml**.

1. Add the apply settings template to the end of **resources.yml**.
2. Replace **YOUR_DATASET**.
3. Check the plan. One job shows create.
4. Deploy.
5. Check the plan again. All show unchanged.

Don't run it yet. **conf/** doesn't exist until the bronze part.

```
cat doc/templates/bootcamp/settings/resources.yml >> datasets/YOUR_DATASET/resources.yml
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
```

---

← [add_ingest_job.md](add_ingest_job.md) | [add_bronze_settings.md](add_bronze_settings.md) →
