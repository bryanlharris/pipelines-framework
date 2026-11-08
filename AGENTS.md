# AGENTS.md

Instructions for AI assistants (Copilot, Claude and others) working in this repo.

## What This Repo Is

One Databricks Asset Bundle that loads files into Delta tables with
sdp-meta (Databricks Labs). Each dataset is a folder under **datasets/**.
Files arrive in a volume, a router files them, and one pipeline per dataset
builds bronze, silver SCD2 and a current view per table.

```
databricks.yml              bundle, variables; includes targets/ and datasets/*/resources.yml
datasets/<d>/resources.yml  catalog, schemas, volumes, jobs, pipeline
datasets/<d>/conf/          sdp-meta settings: onboarding.yml, silver_transformations.yml,
                            bronze_expectations.yml, silver_expectations/<table>.yml
datasets/<d>/views/         one <table>.sql per table; extra views too, e.g. pii_inventory
datasets/<d>/tables/        optional SQL tables the pipeline builds, e.g. edsm's gold layer
datasets/<d>/fetch.yml      what the fetch job downloads
shared/                     python the jobs run (router, fetch, views)
targets/*.local.yml         targets, git-ignored (bucket names)
doc/procedures/             step-by-step procedures
doc/templates/              files to copy
tools/                      bundle_plan.py (what a deploy would do), bind_catalogs.ps1, pack_for_ai.ps1
```

## Build From the Templates

- New dataset: follow doc/procedures/build_many_table_dataset.md. Copy
  doc/templates/dataset/, replace YOUR_DATASET, fill in CHANGE_ME lines.
- New table: follow doc/procedures/build_many_table_dataset/add_table.md.
  Each file keeps a commented block per table between copy markers. Copy the
  block below its **To here** line, uncomment the copy, fill it in. Leave
  the commented block for the next table. Per table:
  - conf/onboarding.yml: one entry, with the next data_flow_id
  - conf/silver_transformations.yml: one entry
  - fetch.yml: one entry; name the file after the table, e.g. powerPlay.json
  - resources.yml: one name in the router's --names list
  - views/<table>.sql: copied from doc/templates/dataset/views/YOUR_TABLE.sql
  - conf/silver_expectations/<table>.yml: copied from the template; the key rule
- Don't invent a new layout. Copy edsm (datasets/edsm/) when unsure: it has several tables, gunzip and a gold layer.
- Rules: doc/procedures/add_rules.md. Bronze rules are one file per dataset (strings, use try_cast); silver rules are one file per table (typed). expect counts, expect_or_drop removes, expect_or_fail stops the pipeline.
- Joins, group-bys and windows can't go in sdp-meta's YAML. They go in SQL files under tables/, as pipeline libraries, usually in a gold schema.
- Custom Python for one dataset: doc/procedures/add_custom_code.md (its own pipeline runner). Avoid unless YAML and SQL can't do it.

## Names

- Catalog: ${var.catalog_prefix}<dataset>, e.g. dev_treasury.
- Schemas: raw, bronze, silver, sdp_meta. Volumes: raw.inbox, raw.files, sdp_meta.conf.
- Jobs: "<dataset> - ingest", "<dataset> - apply settings", "<dataset> - fetch". Pipeline: "<dataset> - pipeline".
- Tables: bronze.<table>, silver.<table>_history (SCD2), view silver.<table>.
- Template blanks: YOUR_DATASET, YOUR_OWNER, YOUR_CATALOG, YOUR_TABLE, YOUR_FILE, YOUR_TARGET, CHANGE_ME.
- Every job and pipeline is tagged: dataset, role (ingest, apply_settings, fetch, pipeline), owner.

## Rules

- Check every change: `py tools/bundle_plan.py <target>`, deploy, plan again. The second plan shows all unchanged.
- Never commit bucket names or tokens. They live in targets/*.local.yml.
- Every compute task sets `disable_auto_optimization: true`, so it fails once with no retries. Pipeline tasks don't: they ignore it.
- Free, dev and staging set `presets: pipelines_development: true`. Don't use `mode: development` or `presets.name_prefix`: they rename the schemas and break the /Volumes paths.
- Comment every catalog, schema, volume and table. Catalog comments are markdown: blank lines between sentences, bullets for lists.
- Free Edition: no bucket; the catalog is made with SQL, then bound; files come from the upload script.
- Enterprise: the bundle makes the catalog in the target's bucket; files come from the fetch job. After deploy, run `./tools/bind_catalogs.ps1 -Target <t>`: it binds each catalog to the workspace, isolates it and turns on data classification (the bundle can't yet).
- A bad file: never delete it from raw/files. List it in the dataset's not_a_bad_file rule, then full refresh; see doc/procedures/remove_bad_file.md. The router puts files it can't match in inbox/unknown_files.
- conf/ changes need deploy, then the apply settings job. resources.yml changes need only deploy. Small tasks: doc/procedures/admin.md.
- `databricks bundle run` takes the key from resources.yml (edsm_pipeline), not the GUI name (edsm - pipeline).
- Windows: PowerShell (pwsh), `py` not `python3`, GNU grep and sed via scoop. Mac: pwsh too.

## Writing

- Short sentences, plain words, actor before action. Cut extra words.
- Procedures: numbered steps, then one code block of commands only, in step order. See doc/procedures/ for examples.
- Commits: short subject, blank line, short bullets.
