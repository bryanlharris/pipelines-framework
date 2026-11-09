# Dev, Team

Deploys your branch to your own copy in dev. Everyone on the team has a
copy, kept apart by the first name in their prefix, e.g.
**dev_jim_treasury**. Nobody else's copy changes.

## Prerequisites

1. [setup.md](../setup.md): set up the computer and the CLI, with the
   **dev** profile
2. The team repo exists: [start_repo.md](../start_repo.md), done once per
   team

## Steps

1. Clone the team repo, unless you have it.
2. Copy the team targets template into **targets/**, unless you have it.
3. Uncomment **dev**. Change its **CHANGE_ME** lines: your first name in
   the prefix, and the bucket.
4. Make a branch for your change.
5. Make the change, e.g. with
   [build_many_table_dataset.md](../build_many_table_dataset.md).
6. Check the plan. On your first deploy, all show create, with your prefix.
7. Deploy.
8. Check the plan again. All show unchanged.
9. Bind your catalogs, and turn on classification and monitoring.
10. For each dataset, run apply settings, then the fetch job. The ingest
    job starts when the files land; if it doesn't, run it by hand.
11. When it works, merge your branch into master and push. If the team
    uses pull requests, push the branch and open one instead.
12. End.

```
git clone YOUR_TEAM_REPO_URL
cp doc/templates/target/targets.team.local.yml targets/
edit targets/targets.team.local.yml
git switch -c YOUR_BRANCH
py tools/bundle_plan.py dev
databricks bundle deploy -t dev
py tools/bundle_plan.py dev
./tools/govern_catalogs.ps1 -Target dev
databricks bundle run YOUR_DATASET_apply_settings -t dev
databricks bundle run YOUR_DATASET_fetch -t dev
databricks bundle run YOUR_DATASET_ingest -t dev
git switch master
git merge YOUR_BRANCH
git push
```

To require pull requests, a GitHub admin turns on branch protection for
master: **Settings** → **Branches** → **Add rule**.
