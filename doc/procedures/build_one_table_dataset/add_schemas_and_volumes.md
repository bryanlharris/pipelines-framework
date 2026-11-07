← [add_catalog.md](add_catalog.md) | [add_upload_script.md](add_upload_script.md) →

# Add Schemas and Volumes

1. Add the schemas and volumes template to the end of **resources.yml**.
2. Replace **YOUR_DATASET**.
3. Check the plan. Four schemas and three volumes show create.
4. Deploy.
5. Check the plan again. All show unchanged.

```
cat doc/templates/build_one_table_dataset/schemas_and_volumes/resources.yml >> datasets/YOUR_DATASET/resources.yml
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
```

---

← [add_catalog.md](add_catalog.md) | [add_upload_script.md](add_upload_script.md) →
