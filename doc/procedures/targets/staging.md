# Set Up Staging

> **Old setup:** one shared dev, with the prefix **dev_**. The team setup replaces it: see [README.md](README.md). Its template is gone; copy **targets.team.local.yml** and set the prefixes this page shows.

Deploys a release to staging. Staging runs tags, never your working files,
so it gets only what was tested on dev.

## Prerequisites

1. [dev.md](dev.md): dev is set up, and the release is tested there

## Steps

1. Uncomment **staging** in **targets/targets.team.local.yml**, and change its
   **CHANGE_ME** line to the staging bucket.
2. Tag the dev release you tested for staging, e.g. **staging_v0.01**, and
   push the tag.
3. Switch to the tag.
4. Check the plan.
5. Deploy.
6. Check the plan again. All show unchanged.
7. Bind the catalogs, and turn on data classification.
8. Switch back to master.
9. End.

```
edit targets/targets.team.local.yml
git tag YOUR_TAG YOUR_DEV_TAG
git push origin YOUR_TAG
git switch --detach YOUR_TAG
py tools/bundle_plan.py staging
databricks bundle deploy -t staging
py tools/bundle_plan.py staging
./tools/govern_catalogs.ps1 -Target staging
git switch master
```
