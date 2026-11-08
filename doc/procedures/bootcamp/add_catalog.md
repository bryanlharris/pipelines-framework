← none | [add_schemas_and_volumes.md](add_schemas_and_volumes.md) →

# Add a Catalog

## Enterprise Edition

The bundle creates the catalog itself.

Untested: if
the deploy fails, make the catalog by hand in Catalog Explorer (or ask
an admin), then bind it as in Free steps 6 and 7.

Each target puts its prefix on the catalog's name, and names its bucket
in your targets file, e.g. **targets/targets.team.local.yml**. See [setup_dev.md](../targets/dev/setup_dev.md).
The template's **targets:** section adds the storage path on dev,
staging and prod only.

1. Make the dataset's folder.
2. Copy the catalog template into it.
3. Replace **YOUR_DATASET**.
4. Change the **CHANGE_ME** lines. For the catalog's comment, give Claude
   the About link and ask for a draft.
5. Check the plan. The catalog must show create.
6. Deploy.
7. Check the plan again. The catalog shows unchanged.
8. Open the catalog in Catalog Explorer. It shows its comment.

```
mkdir datasets/YOUR_DATASET/
cp doc/templates/bootcamp/catalog/resources.yml datasets/YOUR_DATASET/
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
```

## Free Edition

Free can't create a catalog through the bundle. So you make it with
SQL, then bind it: the bundle takes over the catalog that already exists.

| Target | Prefix | Catalog      |
|--------|--------|--------------|
| free   | none   | YOUR_CATALOG |

1. Make the dataset's folder.
2. Copy the catalog template into it.
3. Replace **YOUR_DATASET**.
4. Change the **CHANGE_ME** lines. For the catalog's comment, give Claude
   the About link and ask for a draft.
5. Create the catalog in the SQL editor.
6. Bind it, so the bundle takes it over.
7. Check the plan. The catalog must show update, to add the comment.
   If it shows create, the bind failed.
8. Deploy.
9. Check the plan again. The catalog shows unchanged.
10. Open the catalog in Catalog Explorer. It shows its comment.

```
mkdir datasets/YOUR_DATASET/
cp doc/templates/bootcamp/catalog/resources.yml datasets/YOUR_DATASET/
edit datasets/YOUR_DATASET/resources.yml
CREATE CATALOG YOUR_DATASET
databricks bundle deployment bind YOUR_DATASET YOUR_DATASET -t free --auto-approve
py tools/bundle_plan.py free
databricks bundle deploy -t free
py tools/bundle_plan.py free
```

---

← none | [add_schemas_and_volumes.md](add_schemas_and_volumes.md) →
