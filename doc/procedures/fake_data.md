# Fake Data

Dev gets only made-up files, never real data. Free and prod get real data.

Each dataset keeps about 10 fake records per table in **fake/**. They have
the real files' shape, with values that look fake on sight: dates from
1970-01-01, text like **FAKE_BANK_1**, small round numbers. Keys count 1,
2, 3 in every table, so joins still work.

## Prerequisites

1. [targets/dev_team.md](targets/dev_team.md): your dev copy is deployed

## Steps

1. [make_fake_file.md](fake_data/make_fake_file.md): make a table's fake file, once per table
2. [upload_fake.md](fake_data/upload_fake.md): send the fake files to dev
3. [wipe_dev.md](fake_data/wipe_dev.md): empty your dev copy, to start over
4. End.

The examples already have their fake files. documents makes fake PDFs, so
it has no **fake/**.
