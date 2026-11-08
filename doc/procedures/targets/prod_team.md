# Prod, Team

Deploys a tested release to prod. An admin tags the same commit staging
runs, and deploys it. Jobs and pipelines run as the service principal, not
as the admin. Prod catalogs have no prefix, e.g. **treasury**.

## Prerequisites

1. [setup.md](../setup.md): set up the computer and the CLI, with the
   **prod** profile
2. The release passed staging: [staging_team.md](staging_team.md)

## Steps

1. Uncomment **prod** in the team targets file. Change its **CHANGE_ME**
   lines: the service principal's application id, the admins' group, the
   team's group, and the bucket.
2. Tag the staging release you tested, e.g. **prod_v0.1**, and push the
   tag.
3. Switch to the tag.
4. Check the plan. It shows only what the release changes.
5. Deploy.
6. Check the plan again. All show unchanged.
7. On the first deploy, bind the catalogs, and turn on data classification.
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
./tools/bind_catalogs.ps1 -Target prod
git switch master
```
