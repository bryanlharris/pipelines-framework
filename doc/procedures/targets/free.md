# Set Up Free

Deploys every dataset to a Free Edition workspace, and loads its files. Free
can't create catalogs through the bundle, so you make each one with SQL,
then bind it.

## Prerequisites

1. [setup.md](../setup.md): set up the computer and the CLI, with the
   **free** profile

## Steps

1. Copy the free targets template into **targets/**, unless you have it.
2. Uncomment **free**. If a dataset has a **genie.yml**, change its
   **CHANGE_ME** line to the SQL warehouse's id.
3. List the catalogs the bundle needs. It prints one name per dataset.
4. Create each catalog in the SQL editor. They can take a minute to show.
5. Bind each one, so the bundle takes it over.
6. Check the plan. All show create, but the catalogs show change. A catalog
   that shows create didn't bind.
7. Deploy. If the ingest job fails with **No volume is defined**, wait a few
   minutes, and deploy again.
8. Check the plan again. All show unchanged.
9. Run govern_catalogs. It limits each catalog to this workspace, and turns
   on data quality monitoring. Classification shows failed: free doesn't
   support it.
10. For each dataset, run the apply settings job. Do this before the files
    land, so each ingest run has its settings. Free runs one or two jobs at
    a time; the rest wait in a queue.
11. For each dataset, run its upload script. Its ingest job starts when the
    files land. A file that lands in the first minute after the deploy
    doesn't start it; then run the ingest job by hand.
12. End.

```
cp doc/templates/target/targets.free.local.yml targets/
edit targets/targets.free.local.yml
$catalogs = (databricks bundle validate -t free -o json | ConvertFrom-Json).resources.catalogs.PSObject.Properties
$catalogs.Value.name
CREATE CATALOG YOUR_CATALOG
foreach ($c in $catalogs) { databricks bundle deployment bind $c.Name $c.Value.name -t free --auto-approve }
py tools/bundle_plan.py free
databricks bundle deploy -t free
py tools/bundle_plan.py free
./tools/govern_catalogs.ps1 -Target free
databricks bundle run YOUR_DATASET_apply_settings -t free
& ./datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1
databricks bundle run YOUR_DATASET_ingest -t free
```
