# Staging, Team

Deploys a release to staging. The team lead tags master and deploys the
tag. Staging is one shared copy, e.g. **staging_treasury**; its state
lives in a shared folder, so only the lead can change it.

Staging's pipelines read prod's raw.files, e.g. **treasury.raw.files**.
Prod grants the access: [prod_team.md](prod_team.md), step 7.

Staging's own inbox and raw.files stay empty. No file starts a staging
pipeline, so the lead runs each one.

Never start staging's fetch job. Its files land in staging's raw.files,
and the pipelines ignore them.

A new dataset or table has no files in prod until the release reaches
prod. Staging checks only its deploy. Prod's first run is its first test.

## Prerequisites

1. [setup.md](../setup.md): set up the computer and the CLI, with the
   **staging** profile
2. An admin gives the lead **CREATE CATALOG** on the metastore, and
   **CREATE MANAGED STORAGE** on the staging bucket's external location.
3. The change is merged into master, and tested in dev:
   [dev_team.md](dev_team.md)
4. Prod is deployed and governed, so staging can read its files. The
   first release deploys both at once: [prod_team.md](prod_team.md#first-release)

## Steps

1. Uncomment **staging** in the team targets file. Change its
   **CHANGE_ME** lines: the lead, the team's group, the bucket, and the
   SQL warehouse's id if a dataset has a **genie.yml**.
2. Switch to master, and pull.
3. List the staging tags. Pick the next number, e.g. **staging_v0.01**.
4. Tag master, and push the tag.
5. Switch to the tag.
6. Check the plan. It shows only what the release changes.
7. Deploy.
8. Check the plan again. All show unchanged.
9. On the first deploy, bind the catalogs, and turn on classification and monitoring.
10. For each dataset, run apply settings, then the pipeline.
11. Check each pipeline run is green, and its silver tables have records.
12. Switch back to master.
13. End.

```
edit targets/targets.team.local.yml
git switch master
git pull
git tag -l "staging_*"
git tag YOUR_TAG
git push origin YOUR_TAG
git switch --detach YOUR_TAG
py tools/bundle_plan.py staging
databricks bundle deploy -t staging
py tools/bundle_plan.py staging
./tools/govern_catalogs.ps1 -Target staging
databricks bundle run YOUR_DATASET_apply_settings -t staging
databricks bundle run YOUR_DATASET_pipeline -t staging
SELECT count(*) FROM YOUR_CATALOG.silver.YOUR_TABLE
git switch master
```
