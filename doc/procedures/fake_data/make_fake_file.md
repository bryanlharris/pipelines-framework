← none | [upload_fake.md](upload_fake.md) →

# Make a Fake File

Makes one table's fake file from the shape of the real ones. Genie Code
writes it, inside Databricks, so the real files never leave the workspace.
A person checks it before it goes in the repo.

## Prerequisites

1. Read access to prod's raw files, or to staging, which reads them

## Steps

1. Open Genie Code in staging or prod.
2. Ask it for a fake file, with the prompt below. It reads
   **YOUR_CATALOG.raw.files/YOUR_TABLE/** and writes the file.
3. Check its shape matches the real files: the header line, the XML tags,
   or the JSON keys and nesting.
4. Check every value looks fake. No real value slipped through.
5. Check the values pass the dataset's **expect_or_fail** rules, in
   **conf/bronze_expectations.yml** and **conf/silver_expectations/**.
6. Save it as **datasets/YOUR_DATASET/fake/YOUR_TABLE.YOUR_EXTENSION**,
   and commit it.
7. End.

```
edit datasets/YOUR_DATASET/fake/YOUR_TABLE.YOUR_EXTENSION
git add datasets/YOUR_DATASET/fake
git commit -m "YOUR_DATASET: fake YOUR_TABLE file"
```

## The Prompt

```
Read one file in /Volumes/YOUR_CATALOG/raw/files/YOUR_TABLE/. Write a fake
file with the same format and shape, and about 10 records. Make every value
look fake: dates from 1970-01-01, counting up; text like FAKE_NAME_1; small
round numbers; keys 1, 2, 3. Copy no real values.
```

← none | [upload_fake.md](upload_fake.md) →
