# Start a Repo

Makes your own repo from this one, for your team's datasets. This repo is
upstream: it ships the framework and the examples, and deploys nothing.
Pull from it when you want its fixes.

## Prerequisites

1. [setup.md](setup.md): set up the computer and the CLI

## Steps

1. Clone this repo into a folder named for your team.
2. Rename the remote to **upstream**.
3. Change the bundle's name in **databricks.yml**, **YOUR_TEAM**, e.g. **sdp_edsm**.
   The name sets where the bundle keeps its state, so each repo needs its
   own.
4. Copy the examples you want into **datasets/**, or add your own with
   [build_many_table_dataset.md](build_many_table_dataset.md).
5. Commit.
6. Set up a target: [targets/](targets/README.md).
7. Later, to get upstream's fixes, pull from upstream.
8. Later, to back up your repo, create an empty repo on GitHub, add it as
   **origin**, and push.
9. End.

```
git clone YOUR_UPSTREAM_URL YOUR_TEAM
cd YOUR_TEAM
git remote rename origin upstream
edit databricks.yml
cp -r examples/YOUR_DATASET datasets/
git add -A
git commit -m "Start the YOUR_TEAM repo"
git pull upstream master
git remote add origin YOUR_REPO_URL
git push -u origin master
```
