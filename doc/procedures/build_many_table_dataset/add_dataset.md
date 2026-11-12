← none | [add_table.md](add_table.md) →

# Add a Dataset

Adds a dataset from the whole dataset template: catalog, schemas, volumes,
jobs and pipeline. Tables come next, in [add_table.md](add_table.md).

## Enterprise Edition

The bundle creates the catalog, in the bucket the targets file names.

1. Set **$d** to the dataset's name, and **$o** to its owner, e.g. a
   person or team to ask about the data. The commands below use them.
2. Copy the dataset template into **datasets/**.
3. Rename the upload script, and remove the view and silver rules
   templates. [add_table.md](add_table.md) adds one of each per table.
4. Replace **YOUR_DATASET** and **YOUR_OWNER** in every file. The owner
   goes in the catalog's comment and in each job's tags.
5. Change the **CHANGE_ME** lines in **resources.yml**: the top line and
   the catalog's comment. For the comment, give Genie the About link and
   ask for a draft.
6. Change the **CHANGE_ME** line in **conf/bronze_expectations.yml**: a
   rule every good record passes.
7. Check the plan. All show create.
8. Deploy. If the ingest job fails with **No volume is defined**, the new
   inbox isn't visible yet. Wait a few minutes, and deploy again.
9. Check the plan again. All show unchanged.
10. Bind the catalog, and turn on classification and monitoring.
11. End.

```
$d = "YOUR_DATASET"
$o = "YOUR_OWNER"
cp -r doc/templates/dataset datasets/$d
mv datasets/$d/upload_YOUR_DATASET.ps1 datasets/$d/upload_$d.ps1
rm datasets/$d/tables/silver.YOUR_TABLE.sql
rm datasets/$d/conf/silver_expectations/YOUR_TABLE.yml
sed -i "s/YOUR_DATASET/$d/g; s/YOUR_OWNER/$o/g" (grep -rlE "YOUR_DATASET|YOUR_OWNER" datasets/$d)
edit datasets/$d/resources.yml
edit datasets/$d/conf/bronze_expectations.yml
py tools/bundle_plan.py dev
databricks bundle deploy -t dev
py tools/bundle_plan.py dev
./tools/govern_catalogs.ps1 -Target dev
```

## Free Edition

Free can't create a catalog through the bundle. So you make it with SQL,
then bind it: the bundle takes over the catalog that already exists.

1. Set **$d** to the dataset's name, and **$o** to its owner, e.g. a
   person or team to ask about the data. The commands below use them.
2. Copy the dataset template into **datasets/**.
3. Rename the upload script, and remove the view and silver rules
   templates. [add_table.md](add_table.md) adds one of each per table.
4. Replace **YOUR_DATASET** and **YOUR_OWNER** in every file. The owner
   goes in the catalog's comment and in each job's tags.
5. Change the **CHANGE_ME** lines in **resources.yml**: the top line and
   the catalog's comment. For the comment, give Genie the About link and
   ask for a draft.
6. Change the **CHANGE_ME** line in **conf/bronze_expectations.yml**: a
   rule every good record passes.
7. Create the catalog in the SQL editor.
8. Bind it, so the bundle takes it over.
9. Check the plan. All show create, but the catalog shows change. If it
   shows create, the bind failed.
10. Deploy. If the ingest job fails with **No volume is defined**, the new
   inbox isn't visible yet. Wait a few minutes, and deploy again.
11. Check the plan again. All show unchanged.
12. End.

```
$d = "YOUR_DATASET"
$o = "YOUR_OWNER"
cp -r doc/templates/dataset datasets/$d
mv datasets/$d/upload_YOUR_DATASET.ps1 datasets/$d/upload_$d.ps1
rm datasets/$d/tables/silver.YOUR_TABLE.sql
rm datasets/$d/conf/silver_expectations/YOUR_TABLE.yml
sed -i "s/YOUR_DATASET/$d/g; s/YOUR_OWNER/$o/g" (grep -rlE "YOUR_DATASET|YOUR_OWNER" datasets/$d)
edit datasets/$d/resources.yml
edit datasets/$d/conf/bronze_expectations.yml
CREATE CATALOG YOUR_DATASET
databricks bundle deployment bind $d $d -t free --auto-approve
py tools/bundle_plan.py free
databricks bundle deploy -t free
py tools/bundle_plan.py free
```

---

← none | [add_table.md](add_table.md) →
