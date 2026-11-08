# Templates

Files to copy when you add something. Each folder holds one kind of
thing. A procedure in [doc/procedures/](../procedures/README.md) says which template to copy,
where to, and what to fill in.

## Blanks

```
YOUR_DATASET   the dataset's name, e.g. treasury.
YOUR_CATALOG   the dataset's catalog, e.g. treasury on free, dev_treasury on dev.
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

- [pc/](pc/profile.ps1): PowerShell profile lines, plus [a WezTerm config](pc/wezterm.lua) and [VS Code settings](pc/vscode_settings.json)
- [mac/](mac/shell_profile): shell profile lines, for zsh or bash
- [genie/](genie/sdp-framework/SKILL.md): a Genie Code skill that points at AGENTS.md
- [target/](target/targets.local.yml): every target, commented out, plus [the catalog's targets section](target/catalog_targets.yml)
- [dataset/](dataset/resources.yml): a whole dataset, ready to copy, with [bronze rules](dataset/conf/bronze_expectations.yml). Per-table blocks are commented out; copy one for each table
- [custom_runner/](custom_runner/init_sdp_meta_pipeline.py): a pipeline runner with custom code, for one dataset
- [build_one_table_dataset/](build_one_table_dataset/): the teaching parts, one folder per part of [build_one_table_dataset.md](../procedures/build_one_table_dataset.md)
  - [catalog/](build_one_table_dataset/catalog/resources.yml): the start of a dataset's resources.yml, its catalog
  - [schemas_and_volumes/](build_one_table_dataset/schemas_and_volumes/resources.yml): a dataset's schemas and volumes, added to resources.yml
  - [upload/](build_one_table_dataset/upload/upload.ps1): a script that downloads a file and puts it in the inbox
  - [ingest/](build_one_table_dataset/ingest/resources.yml): the job that moves new files from the inbox to files
  - [settings/](build_one_table_dataset/settings/resources.yml): the job that applies a dataset's settings
  - [bronze/](build_one_table_dataset/bronze/onboarding.yml): the start of a dataset's conf/onboarding.yml, one table's bronze entry
  - [pipeline/](build_one_table_dataset/pipeline/resources.yml): a dataset's pipeline, plus [the ingest job's tasks](build_one_table_dataset/pipeline/ingest_tasks.yml) that run it
  - [silver_scd2/](build_one_table_dataset/silver_scd2/onboarding.yml): one table's silver settings, plus [its selects](build_one_table_dataset/silver_scd2/silver_transformations.yml)
  - [view/](build_one_table_dataset/view/current.sql): a current view, plus [the ingest job's task](build_one_table_dataset/view/ingest_task.yml) that remakes it
  - [fetch/](build_one_table_dataset/fetch/fetch.yml): a dataset's fetch list, plus [the fetch job](build_one_table_dataset/fetch/resources.yml)
