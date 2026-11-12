# Prod, Team

Deploys a tested release to prod. The team lead tags the same commit
staging runs, and deploys it. Jobs and pipelines run as the service
principal, not as the lead. Prod catalogs have no prefix, e.g. **treasury**.

## Prerequisites

1. [setup.md](../setup.md): set up the computer and the CLI, with the
   **prod** profile
2. An admin gives the lead the **Service Principal User** role on the
   service principal.
3. An admin gives the lead **CREATE CATALOG** on the metastore, and
   **CREATE MANAGED STORAGE** on the prod bucket's external location.
4. The release passed staging: [staging_team.md](staging_team.md). The
   first release skips this: see [First Release](#first-release).

## Steps

1. Uncomment **prod** in the team targets file. Change its **CHANGE_ME**
   lines: the service principal's application id, the lead, the team's
   group, the bucket, and the SQL warehouse's id if a dataset has a
   **genie.yml**.
2. Tag the staging release you tested, e.g. **prod_v0.1**, and push the
   tag.
3. Switch to the tag.
4. Check the plan. It shows only what the release changes.
5. Deploy.
6. Check the plan again. All show unchanged.
7. On the first deploy, and after each new dataset, bind the catalogs, and
   turn on classification and monitoring. Give it the staging workspace id,
   so staging can read each catalog's raw.files.
8. Start each fetch schedule you want: they deploy paused. See
   [admin.md](../admin.md#pause-or-start-the-fetch-schedule).
9. Switch back to master.
10. End.

```
edit targets/targets.team.local.yml
git tag YOUR_TAG YOUR_STAGING_TAG
git push origin YOUR_TAG
git switch --detach YOUR_TAG
py tools/bundle_plan.py prod
databricks bundle deploy -t prod
py tools/bundle_plan.py prod
./tools/govern_catalogs.ps1 -Target prod -StagingWorkspace YOUR_WORKSPACE_ID
git switch master
```

## First Release

Staging has nothing to read until prod has files. So the first release
goes to both at once, from one commit, and skips the staging test. The
next release follows the usual order.

1. Uncomment **staging** and **prod** in the team targets file, and change
   their **CHANGE_ME** lines.
2. Tag master for both, e.g. **staging_v0.01** and **prod_v0.1**, and push
   the tags.
3. Switch to the tag.
4. Check the plan, deploy staging, and check again.
5. Govern staging.
6. Check the plan, deploy prod, and check again.
7. Govern prod, with the staging workspace id.
8. For each dataset, run apply settings on prod, then the fetch job. The
   ingest job and the pipeline start when the files land.
9. Switch back to master.
10. End.

```
edit targets/targets.team.local.yml
git switch master
git pull
git tag YOUR_STAGING_TAG
git tag YOUR_TAG YOUR_STAGING_TAG
git push origin YOUR_STAGING_TAG YOUR_TAG
git switch --detach YOUR_TAG
py tools/bundle_plan.py staging
databricks bundle deploy -t staging
py tools/bundle_plan.py staging
./tools/govern_catalogs.ps1 -Target staging
py tools/bundle_plan.py prod
databricks bundle deploy -t prod
py tools/bundle_plan.py prod
./tools/govern_catalogs.ps1 -Target prod -StagingWorkspace YOUR_WORKSPACE_ID
databricks bundle run YOUR_DATASET_apply_settings -t prod
databricks bundle run YOUR_DATASET_fetch -t prod
git switch master
```

## Data Steward

Each catalog's grants live in its **resources.yml**. The service principal
writes. The lead manages and reads. The team reads. Nobody else writes.

Deploys reset the catalog's grants. Grants on schemas and tables stay.

A data steward can own each catalog, and needs no CLI. After the first
deploy, an admin makes the steward the owner in the GUI. The lead keeps
**MANAGE**, so deploys still work.

The steward grants and revokes on schemas and tables, in the GUI or Ontos.
A grant on the catalog itself goes in **resources.yml**.
