# Onboarding

"Onboarding" is sdp-meta's word for loading a dataset's settings. It
does not load data.

## What It Does

The pipeline does not read the YAML files in **datasets/<dataset>/conf/**. It reads
two settings tables. The onboarding job copies the YAML into them.

```
datasets/<dataset>/conf/onboarding.yml              one entry per file type
datasets/<dataset>/conf/silver_transformations.yml  silver selects
datasets/<dataset>/conf/bronze_expectations.yml     bronze rules
        |
        |  job "<dataset> - onboarding"
        |    stage_conf: copy conf/ to the volume sdp_meta.conf
        |    onboard:    write the settings tables
        v
<dataset>.sdp_meta.bronze_dataflowspec      one record per bronze table
<dataset>.sdp_meta.silver_dataflowspec      one record per silver table
        |
        |  pipeline "<dataset>" reads them on every run
        v
bronze and silver tables
```

Run the onboarding job after any deploy that changes **conf/**. Not
after each data load.

## The Three Files

**onboarding.yml**: one entry per file type. Each entry makes one bronze
table and one silver table. Copy **doc/examples/onboarding_entry.yml**;
its CHANGE lines are the only ones that differ per table:

```
data_flow_id                 next number: "1", "2", ...
source_path_free             /Volumes/<dataset>/raw/files/<name>/
bronze_table                 <name>
bronze_reader_options        by file format (see below)
silver_table                 <name>_history (SCD2) or <name> (append)
silver_cdc_apply_changes     keys and SCD type; delete it for append
two table comments
```

**silver_transformations.yml**: one entry per silver table. Its
target_table must equal the silver_table in onboarding.yml. select_exp
is a list of Spark SQL expressions: casts, and AI functions such as
ai_parse_document.

**bronze_expectations.yml**: rules for every bronze table in the dataset.
expect_or_drop drops a record that fails the rule.

## Reader Options by Format

```
format   lines                                       example
-------  ------------------------------------------  ---------
json     cloudFiles.format: json                     edsm
         cloudFiles.inferColumnTypes: "false"
xml      cloudFiles.format: xml                      treasury
         rowTag, ignoreNamespace, excludeAttribute
pdf      cloudFiles.format: binaryFile               documents
         pathGlobFilter: "*.pdf"
```

inferColumnTypes "false" keeps bronze as strings; silver casts them.

## Silver: History or Append

```
kind     when                           settings
-------  -----------------------------  ------------------------------
SCD2     records have a key             silver_cdc_apply_changes block,
         (edsm, treasury)               a view in views/ for current
append   one record per file, no key    no silver_cdc_apply_changes
         (documents)
```

For SCD2, track_history_except_column_list lists the columns whose
changes don't start a new version (ingest_time, source_file). Then a
file that repeats old records adds no versions.

## Keys Ending in _free

Keys like source_path_free belong to the free target. The onboarding
job picks the keys that end in its target name. Dev will need _dev
copies of those keys.

## Gotchas

- In a double-quoted YAML line, a backslash must be doubled: write
  `\\.` for a regex dot. One backslash fails onboarding with "unknown
  escape character".
- The pipeline fails as a whole if any onboarded table's files folder
  is empty. Upload the first file before you onboard (see below).

## Add a Table

1. Add the name to the router
   In **datasets/<dataset>/resources.yml**, add the name to the router's --names.

2. Add the entry
   Copy **doc/examples/onboarding_entry.yml** into
   **datasets/<dataset>/conf/onboarding.yml**. Fill in the CHANGE lines.

3. Add the silver select
   Add a target_table entry to **datasets/<dataset>/conf/silver_transformations.yml**.

4. Add the view (SCD2 only)
   Copy **datasets/<dataset>/views/** of another table. Point it at the new
   history table.

5. Deploy
   `databricks bundle deploy -t free`

6. Upload one file first
   Upload one file of the new type. The job moves it to
   files/<name>/. Its pipeline run skips the new table: not onboarded yet.

7. Onboard
   `databricks bundle run <dataset>_onboarding -t free`

8. Run the pipeline
   `databricks bundle run <dataset>_pipeline -t free`
   The view appears on the job's next run.
