← none | [test_dev.md](test_dev.md) →

# Set Up Dev

Adds the dev target. Its catalogs get the prefix **dev_**, e.g. **dev_treasury**,
and live in the dev bucket.

## Targets

| Target  | Prefix       | Catalog              | Storage                                      |
|---------|--------------|----------------------|----------------------------------------------|
| free    | `""`         | YOUR_DATASET         | free managed storage                         |
| dev     | `"dev_"`     | dev_YOUR_DATASET     | s3://foobar/catalogs/dev_YOUR_DATASET/       |
| staging | `"staging_"` | staging_YOUR_DATASET | s3://foobar/catalogs/staging_YOUR_DATASET/   |
| prod    | `""`         | YOUR_DATASET         | s3://foobar/catalogs/YOUR_DATASET/           |

## How It Works

If **targets/targets.local.yml** sets these two lines for dev:

```
catalog_prefix: dev_
catalog_bucket: foobar
```

Then the **treasury** dataset deploys to dev as:

| What         | Name                                   |
|--------------|----------------------------------------|
| Catalog      | dev_treasury                           |
| Storage root | s3://foobar/catalogs/dev_treasury/     |
| Inbox        | /Volumes/dev_treasury/raw/inbox        |
| Files        | /Volumes/dev_treasury/raw/files        |
| Bronze table | dev_treasury.bronze.yieldCurve         |
| Silver SCD2  | dev_treasury.silver.yieldCurve_history |
| Silver View  | dev_treasury.silver.yieldCurve         |

Nothing else changes. This repo will deploy to staging and prod, each
with its own prefix and bucket.

## Steps

1. Copy the targets template into **targets/**, unless you have it.
   Git ignores it, so the bucket name stays out of the repo.
2. Uncomment **dev**.
3. Change its **CHANGE_ME** line to the dev bucket.
4. Check each dataset's **resources.yml** for a **targets:** section. Datasets
   built on free may lack it.
5. Read the catalog targets template into each one that lacks it. Go to
   the blank line above **resources:**, and add the template's lines below
   it. In vim, type
   :r doc/templates/target/catalog_targets.yml
6. Replace **YOUR_DATASET** in it.
7. Check the plan. Each catalog shows create, with the prefix.
8. Deploy.
9. Check the plan again. All show unchanged.
10. Open a catalog in Catalog Explorer. Its storage root is in the bucket,
    under **catalogs/**.
11. Bind each catalog to this workspace. In Catalog Explorer, open the
    catalog, then the **Workspaces** tab. Clear **All workspaces have
    access**. Click **Assign to workspaces**, and add this workspace if it
    is missing.
12. Turn on data classification for each catalog. Open the catalog, then the
    **Details** tab. Next to **Data Classification**, click **Enable**, then
    **Save**.
13. End.

```
cp doc/templates/target/targets.local.yml targets/
edit targets/targets.local.yml
git grep -L "^targets:" -- "datasets/*/resources.yml"
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py dev
databricks bundle deploy -t dev
py tools/bundle_plan.py dev
```

---

← none | [test_dev.md](test_dev.md) →
