# Start a Repo

Done once per team. Makes the team's repo
from this one, e.g. **team-pipelines**. Everyone else then clones the team
repo and works on branches: [targets/dev_team.md](targets/dev_team.md).

This repo is upstream: it ships the framework and the examples, and deploys
nothing. The team repo pulls from it to get fixes.

## Prerequisites

1. [setup.md](setup.md): set up the computer and the CLI
2. An empty repo on GitHub for the team, with no README, e.g.
   **YOUR_TEAM-pipelines**

## Steps

1. Clone this repo into a folder named like the team repo.
2. Rename the remote to **upstream**, and add the team repo as **origin**.
3. In **databricks.yml**, change the bundle's name, **YOUR_TEAM**, to the
   team's name, e.g. **team**. The bundle name comes from this line, not
   from the repo name. It names the bundle's state folder. Don't change
   it after the first deploy: a new name means a destroy and a redeploy.
4. Copy the examples you want into **datasets/**, or add your own later
   with [build_many_table_dataset.md](build_many_table_dataset.md). To
   copy them all, skip **examples/README.md**, so it doesn't overwrite
   **datasets/README.md**.
5. Commit, and push to origin.
6. Later, to get upstream's fixes, pull from upstream.
7. Check the bundle's name in **databricks.yml**. A pull can set it back
   to **YOUR_TEAM**. Put the team's name back, or the plan shows create on
   everything.
8. Check the plan. Nothing shows create.
9. Commit, and push to origin. Everyone else gets the fixes with a plain
   pull.
10. End.

```
git clone YOUR_UPSTREAM_URL YOUR_TEAM-pipelines
cd YOUR_TEAM-pipelines
git remote rename origin upstream
git remote add origin YOUR_TEAM_REPO_URL
edit databricks.yml
cp -r examples/YOUR_DATASET datasets/
cp examples/* datasets/ -Recurse -Exclude README.md
git add -A
git commit -m "Start the YOUR_TEAM repo"
git push -u origin master
git pull upstream master
edit databricks.yml
py tools/bundle_plan.py dev
git commit -am "Keep the team's bundle name"
git push
```
