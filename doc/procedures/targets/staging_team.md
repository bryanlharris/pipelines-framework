# Staging, Team

Deploys a release to staging. The team lead tags master and deploys the
tag. Staging is one shared copy, e.g. **staging_treasury**; its state
lives in a shared folder, so only the lead can change it.

## Prerequisites

1. [setup.md](../setup.md): set up the computer and the CLI, with the
   **staging** profile
2. The change is merged into master, and tested in dev:
   [dev_team.md](dev_team.md)

## Steps

1. Uncomment **staging** in the team targets file. Change its
   **CHANGE_ME** lines: the lead, the team's group, and the bucket.
2. Switch to master, and pull.
3. List the staging tags. Pick the next number, e.g. **staging_v0.01**.
4. Tag master, and push the tag.
5. Switch to the tag.
6. Check the plan. It shows only what the release changes.
7. Deploy.
8. Check the plan again. All show unchanged.
9. On the first deploy, bind the catalogs, and turn on classification and monitoring.
10. Switch back to master.
11. End.

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
git switch master
```
