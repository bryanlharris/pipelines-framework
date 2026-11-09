# Doc

How to set up, build and release with this repo. Start with
[procedures/](procedures/README.md).

- [procedures/](procedures/README.md): step-by-step instructions, one file per task
- [templates/](templates/README.md): files to copy, which the procedures fill in
- [glossary.md](glossary.md): list of terms with their definitions
- [/tools/](../tools/README.md): scripts, e.g. bundle_plan.py, which shows what a deploy would do
- [/AGENTS.md](../AGENTS.md): instructions for AI assistants, e.g. Genie. Ask one to add a dataset or a table

## Folders

```
doc/
  procedures/
    setup/                     parts of setup.md: PC, Mac, CLI, Genie
    bootcamp/                  parts of bootcamp.md: learn one piece at a time
    build_many_table_dataset/  parts of build_many_table_dataset.md: dataset, table
    targets/                   one procedure per target; dev/ holds the parts of dev.md
  templates/
    dataset/                   a whole dataset, ready to copy
    bootcamp/                  one folder per bootcamp part
    bootcamp_sql/              gold table, gold schema and library, for bootcamp_sql.md
    target/                    the targets templates: free and team
    pc/, mac/                  shell profile, editor and terminal settings
    genie/                     the Genie Code skill
```

A procedure with parts is a file, plus a folder of the same name. The file
lists the parts in order; each part links to the one before and after.
