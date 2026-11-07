# Glossary

Our words, and what sdp-meta or Databricks calls the same thing.

```
our word          meaning                                   sdp-meta / Databricks word
----------------  ----------------------------------------  --------------------------
dataset           one source of data: a folder in           (none)
                  datasets/, its own catalog and pipeline
table             one kind of file in a dataset; becomes    (none)
                  bronze, silver SCD2 and a view
add a table       copy a dataset file's commented table     (none)
                  block, uncomment it, fill in the blanks
apply settings    copy a dataset's conf/ YAML into its      onboarding
                  settings tables; run after any deploy
                  that changes conf/
settings tables   YOUR_CATALOG.sdp_meta.bronze_dataflowspec dataflowspec tables
                  and silver_dataflowspec
inbox             volume raw.inbox; files land here         landing zone
files             volume raw.files; the router moves each   (none)
                  file here; nothing is deleted
router            the ingest job's first task; moves inbox  (none)
                  files to files/<table>/
fetch job         downloads what fetch.yml lists into the   (none)
                  inbox; enterprise only
upload script     does what the fetch job does, from your   (none)
                  computer; free only
bronze            every record from every file, as strings  bronze table
silver SCD2       one version per change to a record        SCD type 2, apply changes
                  (<table>_history)                         (AUTO CDC)
current view      the latest version of each record         (none)
                  (silver.<table>)
target            a place to deploy: free, dev, staging,    target
                  prod; set in targets/*.local.yml
prefix            put before each catalog name, e.g. dev_   (none)
bucket            the S3 bucket that holds a target's       storage root
                  catalogs, under catalogs/
release           a git tag that never moves, e.g.          (none)
                  dev_v0.001; deploy from it
procedure         step-by-step instructions in              (we never say runbook)
                  doc/procedures/
part              one file of a procedure that has a        (none)
                  folder; parts link prev and next
bootcamp          build_one_table_dataset.md: one small     (none)
                  step at a time, to learn the pieces
template          a file to copy, in doc/templates/         (none)
blank             a word to replace, e.g. YOUR_DATASET;     (none)
                  CHANGE_ME marks a line to write yourself
plan              what a deploy would do, by real name:     bundle plan
                  py tools/bundle_plan.py <target>
```
