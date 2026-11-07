# Templates

Files to copy when you add something. Each folder holds one kind of
thing. A procedure in [doc/procedures/](../procedures/README.md) says which template to copy,
where to, and what to fill in.

## Blanks

```
YOUR_DATASET   the dataset's name, e.g. treasury. Also its catalog.
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
- [catalog/](catalog/resources.yml): the start of a dataset's resources.yml, its catalog
- [schemas_and_volumes/](schemas_and_volumes/resources.yml): a dataset's schemas and volumes, added to resources.yml
- [upload/](upload/upload.ps1): a script that downloads a file and puts it in the inbox
- [ingest/](ingest/resources.yml): the job that moves new files from the inbox to files
- [settings/](settings/resources.yml): the job that applies a dataset's settings
- [bronze/](bronze/onboarding.yml): the start of a dataset's conf/onboarding.yml, one table's bronze entry
- [pipeline/](pipeline/resources.yml): a dataset's pipeline, plus [the ingest job's tasks](pipeline/ingest_tasks.yml) that run it
- [silver_scd2/](silver_scd2/onboarding.yml): one table's silver settings, plus [its selects](silver_scd2/silver_transformations.yml)
- [view/](view/current.sql): a current view, plus [the ingest job's task](view/ingest_task.yml) that remakes it
- [fetch/](fetch/fetch.yml): a dataset's fetch list, plus [the fetch job](fetch/resources.yml)
- [target/](target/target.yml): an enterprise target, plus [the catalog's targets section](target/catalog_targets.yml) and [the free target](target/free.local.yml)
