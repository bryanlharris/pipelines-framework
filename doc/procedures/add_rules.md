# Add Rules

Adds a data quality rule: SQL that is true for a good record. The pipeline
checks every record against it.

Checks are done after transforms.

## Kinds of Rule

| Rule             | A bad record                | The pipeline     |
|------------------|-----------------------------|------------------|
| `expect`         | kept, and counted           | keeps going      |
| `expect_or_drop` | removed, and counted        | keeps going      |
| `expect_or_fail` | stops the update            | stops, and fails |

Use **expect** for odd records worth a look, **expect_or_drop** for records
you can't use, and **expect_or_fail** when the whole file is broken. A
failed update writes nothing from that batch; see
[remove_bad_file.md](remove_bad_file.md).

## Where Rules Live

Each table entry in **conf/onboarding.yml** names its rules files, one for
bronze and one for silver. Point them at any file you like.

```
  bronze_data_quality_expectations_json_all: "${workspace.file_path}/conf/bronze_expectations.yml"
  silver_data_quality_expectations_json_all: "${workspace.file_path}/conf/silver_expectations/YOUR_TABLE.yml"
```

The default:

- Bronze: **conf/bronze_expectations.yml**, one file per dataset. Columns
  are still strings, so cast with **try_cast**.
- Silver: **conf/silver_expectations/YOUR_TABLE.yml**, one file per table.
  Columns are typed, after the silver casts.

## Steps

1. Add the rule under its kind, with a short name.
2. Deploy.
3. Run the apply settings job.
4. Rules check new records only. To check every record, full refresh the
   pipeline; see [admin.md](admin.md).
5. Open the pipeline, click the table, and open the **Data quality** tab.
   The rule shows passed and failed records.
6. End.

```
edit datasets/YOUR_DATASET/conf/silver_expectations/YOUR_TABLE.yml
databricks bundle deploy -t YOUR_TARGET
databricks bundle run YOUR_DATASET_apply_settings -t YOUR_TARGET
```

```
expect_or_drop:
  has_id: "id IS NOT NULL"

expect:
  rate_in_range: "rate BETWEEN 0 AND 25"
```
