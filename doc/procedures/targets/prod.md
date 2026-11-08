# Set Up Prod

> **Old setup:** one shared dev, with the prefix **dev_**. The team setup replaces it: see [README.md](README.md). Its template is gone; copy **targets.team.local.yml** and set the prefixes this page shows.

Deploys a release to prod. Prod runs tags, never your working files, so it
gets only what passed staging. Prod catalogs have no prefix, and prod
pipelines retry on errors.

## Prerequisites

1. [staging.md](staging.md): the release is tested on staging

## Steps

1. Uncomment **prod** in **targets/targets.team.local.yml**, and change its
   **CHANGE_ME** line to the prod bucket.
2. Tag the staging release you tested for prod, e.g. **prod_v0.1**, and push
   the tag.
3. Switch to the tag.
4. Check the plan.
5. Deploy.
6. Check the plan again. All show unchanged.
7. Bind the catalogs, and turn on data classification.
8. Switch back to master.
9. End.

```
edit targets/targets.team.local.yml
git tag YOUR_TAG YOUR_STAGING_TAG
git push origin YOUR_TAG
git switch --detach YOUR_TAG
py tools/bundle_plan.py prod
databricks bundle deploy -t prod
py tools/bundle_plan.py prod
./tools/bind_catalogs.ps1 -Target prod
git switch master
```
