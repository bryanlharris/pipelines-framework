---
name: sdp-framework
description: Build, change and deploy the sdp-framework repo. Use when asked to set up a target (free, dev, staging, prod), add a dataset or a table, add rules, skip a bad file, check the plan, or deploy.
---

Find the sdp-framework Git folder in this workspace. Read its AGENTS.md
before any change. Then open the procedure AGENTS.md names for the task,
under doc/procedures/, and follow its steps.

Before you start:

- Switch the Git folder to master, and pull. Make a new branch from master.
- Find out which workspace this is. A catalog named like a dataset with no
  prefix, e.g. treasury, means free or prod. dev_team_jim_treasury means
  Jim's dev.
  Check the user's answer against it.
- Make sure a targets file exists in targets/. If not, copy
  doc/templates/target/targets.free.local.yml on free, or
  targets.team.local.yml at work. Uncomment the right target, and ask for
  any CHANGE_ME values, e.g. the user's first name. Never commit it.
- Ask for everything at once: the dataset's name and owner, and for each
  table its name, file name, download URL, format and key.

While you work:

- Copy template files whole, then edit the copy. Never retype a template:
  spacing and spelling get lost.
- A dataset isn't done until each table is added. Do add_dataset.md, then
  add_table.md for every table, in one pass.
- Each file says how to fill it in, in its comments. Copy the block between
  the copy markers below its "To here" line, uncomment the copy, and fill it
  in. Leave the commented block for the next table.
- Per table, fill all of these: conf/onboarding.yml,
  conf/silver_transformations.yml, conf/silver_expectations/YOUR_TABLE.yml,
  tables/silver.YOUR_TABLE.sql, the router's --names and the pipeline's
  libraries in resources.yml, fetch.yml, and on free the upload script.
- When unsure, copy what examples/edsm/ does.

Before you finish:

- Search for YOUR_ and CHANGE_ME outside comments. Nothing should show.
- Show the plan, `py tools/bundle_plan.py <target>`. Ask before any deploy
  or full refresh.
- Commit on the branch, and say what's left: deploy, apply settings, files,
  ingest, checks.
