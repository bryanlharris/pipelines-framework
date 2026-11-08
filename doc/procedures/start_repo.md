# Start a Repo

Done once per team, by one person, usually the lead. Makes the team's repo
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
   from the repo name. It starts every dev catalog, e.g.
   **dev_team_jim_treasury**, and it never changes after this.
4. Copy the examples you want into **datasets/**, or add your own later
   with [build_many_table_dataset.md](build_many_table_dataset.md).
5. Commit, and push to origin.
6. Later, to get upstream's fixes, pull from upstream, then push to origin.
   Everyone else gets them with a plain pull.
7. End.

```
git clone YOUR_UPSTREAM_URL YOUR_TEAM-pipelines
cd YOUR_TEAM-pipelines
git remote rename origin upstream
git remote add origin YOUR_TEAM_REPO_URL
edit databricks.yml
cp -r examples/YOUR_DATASET datasets/
git add -A
git commit -m "Start the YOUR_TEAM repo"
git push -u origin master
git pull upstream master
git push
```
