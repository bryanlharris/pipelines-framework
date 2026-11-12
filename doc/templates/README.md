# Templates

Files to copy when you add something. Each folder holds one kind of
thing. A procedure in [doc/procedures/](../procedures/README.md) says which template to copy,
where to, and what to fill in.

## Blanks

```
YOUR_DATASET   the dataset's name, e.g. treasury.
YOUR_CATALOG   the dataset's catalog, e.g. treasury on free and prod, dev_jim_treasury on dev.
YOUR_OWNER     who to ask about a dataset, e.g. Bryan Harris.
YOUR_TABLE     the table's name, e.g. yieldCurve. Also its file in the inbox.
YOUR_TARGET    the target: free, dev, staging or prod.
YOUR_FILE      a file's name, e.g. yieldCurve.xml.
CHANGE_ME      a line to write yourself. Replace CHANGE_ME and its
               hint with your own words.
```

After filling in a template, search the new file for `YOUR_` and `CHANGE_ME`.
Nothing should be left.

## Folders

Each new kind of thing adds a folder here, and a line to this list
saying what it is for.

- [pc/](pc/profile.ps1): PowerShell profile lines, plus [a WezTerm config](pc/wezterm.lua) and [VS Code settings](pc/vscode_settings.jsonc)
- [mac/](mac/shell_profile): shell profile lines, for zsh or bash
- [genie/](genie/pipelines-framework/SKILL.md): a Genie Code skill that points at AGENTS.md
- [target/](target/): targets.free.local.yml for free, targets.team.local.yml for dev, staging and prod, plus [the catalog's targets section](target/catalog_targets.yml)
- [dataset/](dataset/resources.yml): a whole dataset, ready to copy, with [bronze rules](dataset/conf/bronze_expectations.yml). Per-table blocks are commented out; copy one for each table
- [custom_runner/](custom_runner/init_sdp_meta_pipeline.py): a pipeline runner with custom code, for one dataset
- [bootcamp/](bootcamp/): the teaching parts, one folder per part of [bootcamp.md](../procedures/bootcamp.md)
  - [catalog/](bootcamp/catalog/resources.yml): the start of a dataset's resources.yml, its catalog
  - [schemas_and_volumes/](bootcamp/schemas_and_volumes/resources.yml): a dataset's schemas and volumes, added to resources.yml
  - [upload/](bootcamp/upload/upload.ps1): a script that downloads a file and puts it in the inbox
  - [ingest/](bootcamp/ingest/resources.yml): the job that moves new files from the inbox to files
  - [settings/](bootcamp/settings/resources.yml): the job that applies a dataset's settings
  - [bronze/](bootcamp/bronze/onboarding.yml): the start of a dataset's conf/onboarding.yml, one table's bronze entry
  - [pipeline/](bootcamp/pipeline/resources.yml): a dataset's pipeline, plus [the ingest job's tasks](bootcamp/pipeline/ingest_tasks.yml) that run it
  - [silver_scd2/](bootcamp/silver_scd2/onboarding.yml): one table's silver settings, plus [its selects](bootcamp/silver_scd2/silver_transformations.yml)
  - [view/](bootcamp/view/current.sql): a current view, plus [the ingest job's task](bootcamp/view/ingest_task.yml) that remakes it
  - [fetch/](bootcamp/fetch/fetch.yml): a dataset's fetch list, plus [the fetch job](bootcamp/fetch/resources.yml)
