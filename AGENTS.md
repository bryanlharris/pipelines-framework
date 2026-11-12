# AGENTS.md

Instructions for AI assistants working in this repo: Genie Code, Claude,
Copilot and others. Read this first, then the procedure for the task.

Genie users: add the skill in doc/templates/genie/, which points here. See
doc/procedures/setup/setup_genie.md.

## What This Repo Is

One Databricks Asset Bundle that loads files into Delta tables with
sdp-meta (Databricks Labs). Each dataset is a folder under **datasets/**,
with its own catalog, jobs and pipeline. The same code deploys to free, dev,
staging and prod; the target sets the catalog prefix and the bucket.

This repo is upstream: it ships no datasets and deploys nothing. Each team
clones it, see doc/procedures/start_repo.md, and copies datasets from
**examples/** or builds its own.

How data flows, in each dataset:

1. A file lands in the inbox volume, **raw.inbox**. The fetch job downloads
   it from a URL in **fetch.yml**; on free, the upload script sends it; a
   file can also be copied in.
2. The ingest job's router moves it to **raw.files/YOUR_TABLE/**, adding a time
   stamp to its name. A file is named after its table. Files the router
   can't match go to **inbox/unknown_files**. Nothing in raw.files is ever
   deleted.
3. The pipeline, run by sdp-meta, reads raw.files into **bronze.YOUR_TABLE**,
   all strings, then **silver.YOUR_TABLE_history**, typed, with SCD2 history.
   Its settings come from **conf/**, loaded into tables by the apply
   settings job. On staging, it reads prod's raw.files instead.
4. The pipeline also runs the SQL files under **tables/**. Each
   **tables/silver.YOUR_TABLE.sql** makes the view **silver.YOUR_TABLE**, the
   current records. Other files build more tables, usually in **gold**,
   and may read those views.

```
databricks.yml                                 bundle and variables; includes targets/ and datasets/*/resources.yml
datasets/YOUR_DATASET/resources.yml            catalog, schemas, volumes, jobs, pipeline
datasets/YOUR_DATASET/conf/                    onboarding.yml, silver_transformations.yml,
                                               bronze_expectations.yml, silver_expectations/YOUR_TABLE.yml
datasets/YOUR_DATASET/fetch.yml                what the fetch job downloads
datasets/YOUR_DATASET/tables/                  SQL the pipeline runs: one silver.YOUR_TABLE.sql view per table,
                                               plus extra tables, e.g. edsm's gold layer
datasets/YOUR_DATASET/upload_YOUR_DATASET.ps1  free only: downloads the files and puts them in the inbox
datasets/YOUR_DATASET/genie.yml                optional Genie agent over silver and gold, e.g. edsm's
examples/                                      finished datasets to copy into datasets/; never deployed
shared/                                        python the jobs run: router, fetch, the pipeline runner
targets/*.local.yml                            targets, git-ignored, with the bucket names
doc/procedures/                                step-by-step procedures
doc/templates/                                 files to copy
tools/                                         bundle_plan.py, govern_catalogs.ps1
```

## Which Procedure

| Task                                    | Procedure                                              |
|-----------------------------------------|--------------------------------------------------------|
| Set up a computer and the CLI           | doc/procedures/setup.md                                |
| Start a team's repo from this one       | doc/procedures/start_repo.md                           |
| Add a dataset                           | doc/procedures/build_many_table_dataset/add_dataset.md |
| Add a table to an existing dataset      | doc/procedures/build_many_table_dataset/add_table.md   |
| Add a data quality rule                 | doc/procedures/add_rules.md                            |
| Skip a bad file                         | doc/procedures/remove_bad_file.md                      |
| Custom Python for one dataset           | doc/procedures/add_custom_code.md                      |
| Set up a target: free, dev, staging, prod | doc/procedures/targets/README.md                     |
| Apply settings, refresh, errors         | doc/procedures/admin.md                                |
| Learn how the pieces work; not for real work | doc/procedures/bootcamp.md            |
| Add a gold SQL table, for SQL people    | doc/procedures/bootcamp_sql.md                         |

## Build From the Templates

- A new dataset is a copy of **doc/templates/dataset/**, with YOUR_DATASET
  and YOUR_OWNER replaced and the CHANGE_ME lines written.
- A new table is one block per file. Each file keeps a commented block
  between copy markers: copy it below its **To here** line, uncomment the
  copy, fill it in, and leave the commented block for the next table.
  - conf/onboarding.yml: one entry, with the next data_flow_id
  - conf/silver_transformations.yml: one entry, with the casts
  - conf/silver_expectations/YOUR_TABLE.yml: copied from the template
  - fetch.yml: one entry, with the file named after the table
  - resources.yml: one name in the router's **--names** list
  - tables/silver.YOUR_TABLE.sql: copied from the template, and listed in
    the pipeline's **libraries** in resources.yml
- Don't invent a layout. When unsure, copy **examples/edsm/**: several
  tables, gzipped files, and a gold layer.
- Joins, group-bys and windows can't go in sdp-meta's YAML. Put them in SQL
  files under **tables/**, listed as pipeline libraries, in the gold schema.
- Custom Python is a last resort: a dataset gets its own pipeline runner.

## Names

- Catalog: `${var.catalog_prefix}YOUR_DATASET`. On free and prod, no prefix:
  treasury. Dev adds a first name: dev_jim_treasury.
  Staging: staging_treasury.
- Schemas: raw, bronze, silver, sdp_meta, and gold when there are SQL tables.
  Volumes: raw.inbox, raw.files, sdp_meta.conf.
- Jobs: "${var.catalog_prefix}YOUR_DATASET - ingest", "- apply settings", "- fetch".
  Pipeline: "${var.catalog_prefix}YOUR_DATASET - pipeline". On free and prod the prefix is
  empty, e.g. "treasury - ingest"; on dev, "dev_jim_treasury - ingest".
- Tables: bronze.YOUR_TABLE, silver.YOUR_TABLE_history, view silver.YOUR_TABLE.
- Blanks in templates: YOUR_TEAM (the bundle name), YOUR_DATASET, YOUR_OWNER, YOUR_CATALOG, YOUR_TABLE,
  YOUR_FILE, YOUR_TARGET. CHANGE_ME marks a line to write yourself.
- Tags on every job and pipeline: dataset, role (ingest, apply_settings,
  fetch, pipeline), owner.
- `databricks bundle run` takes the key from resources.yml, e.g.
  edsm_pipeline, not the name the GUI shows.

## Rules

Checking:

- After every change: `py tools/bundle_plan.py <target>`, deploy, plan
  again. The second plan shows all unchanged.
- A change to **conf/** needs a deploy, then the apply settings job. A change
  to **resources.yml** needs only a deploy.
- A full refresh rebuilds every table from raw.files. It costs compute, and
  edsm has over a million records. Ask before running one on a big dataset.

Safety:

- Never commit bucket names, hosts or tokens. They live in
  **targets/*.local.yml**, which git ignores. A fresh clone has no targets
  file: copy **doc/templates/target/targets.free.local.yml** or
  **targets.team.local.yml**, and fill it in.
- Deploy to free or your own dev. Staging and prod get releases, by tag, from
  the team lead; see doc/procedures/targets/.
- Never delete a file from raw.files. To skip a bad file, list it in the
  dataset's **not_a_bad_file** rule, then full refresh.
- Free Edition has a daily serverless limit. RESOURCE_EXHAUSTED means wait.

Jobs and pipelines:

- Every compute task sets `disable_auto_optimization: true`, so it fails
  once with no retries. Pipeline tasks ignore it, so they don't set it.
- Free, dev and staging set `presets: pipelines_development: true`, so a
  failed update stops. Never use `mode: development` or
  `presets.name_prefix`: they rename the schemas and break the volume paths.
- Comment every catalog, schema, volume and table. Catalog comments are
  markdown: blank lines between sentences, bullets for lists.

Data quality rules:

- Bronze rules: one file per dataset, on string columns, so cast with
  try_cast. Silver rules: one file per table, on typed columns.
- `expect` counts a bad record, `expect_or_drop` removes it,
  `expect_or_fail` stops the pipeline. Fail only when the whole file is
  broken.

Targets:

- Free: no bucket. The catalog is made with SQL, then bound. Files come from
  the upload script.
- Enterprise: the bundle makes the catalog in the target's bucket. Files
  come from the fetch job.
- Staging: its pipelines read prod's raw.files, e.g. treasury.raw.files.
  Staging sets **files_prefix** to "", and the apply settings job's
  point_files task writes prod's path into the settings. Staging's own
  inbox and raw.files stay empty, so the lead runs its pipelines by hand.
- Every target: after the first deploy, and after each new dataset, run
  `./tools/govern_catalogs.ps1 -Target <t>`. It binds each catalog to the
  workspace, isolates it, turns on data classification (not on free), and
  turns on data quality monitoring for silver and gold. On prod, add
  `-StagingWorkspace`, so staging can read each catalog's raw.files.
- Grants: each catalog's **grants** in resources.yml give run_as
  ALL_PRIVILEGES, the deployer MANAGE and read, **team_group** read, and
  account users USE_CATALOG. On prod, run_as is the sp, so only it writes.
  Deploys reset catalog grants. The data steward grants on schemas and
  tables, in the GUI or Ontos.

## Commands

- The procedures' commands are PowerShell (pwsh), on Windows and Mac alike.
- Windows: `py`, not `python3`; GNU grep and sed from scoop; `edit` opens
  the editor.

## Writing

- Short sentences, plain words, actor before action. Cut extra words.
- Procedures: numbered steps, then one code block of commands only, in step
  order. Blanks in **bold**. See doc/procedures/ for examples.
- Commits: short subject, blank line, short bullets.
