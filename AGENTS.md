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

How data flows, in each dataset:

1. A file lands in the inbox volume, **raw.inbox**. The fetch job downloads
   it from a URL in **fetch.yml**; on free, the upload script sends it; a
   file can also be copied in.
2. The ingest job's router moves it to **raw.files/<table>/**, adding a time
   stamp to its name. A file is named after its table. Files the router
   can't match go to **inbox/unknown_files**. Nothing in raw.files is ever
   deleted.
3. The pipeline, run by sdp-meta, reads raw.files into **bronze.<table>**,
   all strings, then **silver.<table>_history**, typed, with SCD2 history.
   Its settings come from **conf/**, loaded into tables by the apply
   settings job.
4. The pipeline also runs the SQL files under **tables/**. Each
   **tables/silver.<table>.sql** makes the view **silver.<table>**, the
   current records. Other files build more tables, usually in **gold**,
   and may read those views.

```
databricks.yml              bundle and variables; includes targets/ and datasets/*/resources.yml
datasets/<d>/resources.yml  catalog, schemas, volumes, jobs, pipeline
datasets/<d>/conf/          onboarding.yml, silver_transformations.yml,
                            bronze_expectations.yml, silver_expectations/<table>.yml
datasets/<d>/fetch.yml      what the fetch job downloads
datasets/<d>/tables/        SQL the pipeline runs: one silver.<table>.sql view per table,
                            plus extra tables, e.g. edsm's gold layer
datasets/<d>/upload_<d>.ps1 free only: downloads the files and puts them in the inbox
shared/                     python the jobs run: router, fetch, the pipeline runner
targets/*.local.yml         targets, git-ignored, with the bucket names
doc/procedures/             step-by-step procedures
doc/templates/              files to copy
tools/                      bundle_plan.py, bind_catalogs.ps1
```

## Which Procedure

| Task                                    | Procedure                                              |
|-----------------------------------------|--------------------------------------------------------|
| Set up a computer and the CLI           | doc/procedures/setup.md                                |
| Add a dataset                           | doc/procedures/build_many_table_dataset/add_dataset.md |
| Add a table to an existing dataset      | doc/procedures/build_many_table_dataset/add_table.md   |
| Add a data quality rule                 | doc/procedures/add_rules.md                            |
| Skip a bad file                         | doc/procedures/remove_bad_file.md                      |
| Custom Python for one dataset           | doc/procedures/add_custom_code.md                      |
| Set up a target: free, dev, staging, prod | doc/procedures/targets/README.md                     |
| Apply settings, refresh, errors         | doc/procedures/admin.md                                |
| Learn how the pieces work; not for real work | doc/procedures/build_one_table_dataset.md         |

## Build From the Templates

- A new dataset is a copy of **doc/templates/dataset/**, with YOUR_DATASET
  and YOUR_OWNER replaced and the CHANGE_ME lines written.
- A new table is one block per file. Each file keeps a commented block
  between copy markers: copy it below its **To here** line, uncomment the
  copy, fill it in, and leave the commented block for the next table.
  - conf/onboarding.yml: one entry, with the next data_flow_id
  - conf/silver_transformations.yml: one entry, with the casts
  - conf/silver_expectations/<table>.yml: copied from the template
  - fetch.yml: one entry, with the file named after the table
  - resources.yml: one name in the router's **--names** list
  - tables/silver.<table>.sql: copied from the template, and listed in
    the pipeline's **libraries** in resources.yml
- Don't invent a layout. When unsure, copy **datasets/edsm/**: several
  tables, gzipped files, and a gold layer.
- Joins, group-bys and windows can't go in sdp-meta's YAML. Put them in SQL
  files under **tables/**, listed as pipeline libraries, in the gold schema.
- Custom Python is a last resort: a dataset gets its own pipeline runner.

## Names

- Catalog: `${var.catalog_prefix}<dataset>`, e.g. dev_treasury. On free, no prefix.
- Schemas: raw, bronze, silver, sdp_meta, and gold when there are SQL tables.
  Volumes: raw.inbox, raw.files, sdp_meta.conf.
- Jobs: "<dataset> - ingest", "<dataset> - apply settings", "<dataset> - fetch".
  Pipeline: "<dataset> - pipeline".
- Tables: bronze.<table>, silver.<table>_history, view silver.<table>.
- Blanks in templates: YOUR_DATASET, YOUR_OWNER, YOUR_CATALOG, YOUR_TABLE,
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
  file: copy **doc/templates/target/targets.local.yml** and fill it in.
- Deploy to free or dev. Staging and prod get releases, by tag; see doc/procedures/targets/.
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
  come from the fetch job. After the first deploy, and after each new
  dataset, run `./tools/bind_catalogs.ps1 -Target <t>`: it binds each
  catalog to the workspace, isolates it and turns on data classification.

## Commands

- The procedures' commands are PowerShell (pwsh), on Windows and Mac alike.
- Windows: `py`, not `python3`; GNU grep and sed from scoop; `edit` opens
  the editor.

## Writing

- Short sentences, plain words, actor before action. Cut extra words.
- Procedures: numbered steps, then one code block of commands only, in step
  order. Blanks in **bold**. See doc/procedures/ for examples.
- Commits: short subject, blank line, short bullets.
