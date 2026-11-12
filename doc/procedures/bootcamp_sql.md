# SQL Bootcamp

Build on top of silver with **.sql** files. The pipeline runs them in the
right order.

## How It Works

- Read from anything in silver or gold.
- Your file makes a materialized view in **gold**: a table the pipeline
  refreshes on every run.
- Don't put a catalog in your SQL. The pipeline supplies it, so the same
  file runs on free, dev, staging and prod.
- Your file can read other gold tables. The pipeline works out the order.
- You can build **.sql** tables in silver or gold. This bootcamp uses gold.
- Joins, group-bys and windows all work. See **examples/edsm/tables/**.
- The pipeline sees a new or changed **.sql** file only after a deploy.
  Then run the pipeline to build the table.

## Prerequisites

1. [setup.md](setup.md): set up the computer and the CLI
2. Your target, e.g. [dev_team.md](targets/dev_team.md) steps 1–3, or
   [free.md](targets/free.md) at home
3. The dataset is loaded into silver

## Practice on Treasury

Build **gold.yieldCurve_monthly**: the average 2-year and 10-year rates per
month.

| Blank        | Free                 | Dev                   |
|--------------|----------------------|-----------------------|
| YOUR_DATASET | treasury             | treasury              |
| YOUR_CATALOG | treasury             | dev_jim_treasury      |
| YOUR_TABLE   | yieldCurve_monthly   | yieldCurve_monthly    |
| YOUR_VIEW    | yieldCurve           | yieldCurve            |
| YOUR_TARGET  | free                 | dev                   |
| YOUR_BRANCH  | add-monthly          | jim/add-monthly       |

The query:

```
SELECT
  date_trunc('month', NEW_DATE) AS month,
  round(avg(BC_2YEAR), 2)  AS avg_2year,
  round(avg(BC_10YEAR), 2) AS avg_10year
FROM silver.yieldCurve
GROUP BY 1
```

## Steps

1. Switch to master, and pull, so you start from the latest code. Then
   make a branch for your table.
2. Look at the silver view's columns.
3. Write your query in the SQL editor, against
   **YOUR_CATALOG.silver.YOUR_VIEW**. Run it until it's right.
4. Copy the gold template into **tables/**, as **gold.YOUR_TABLE**.sql.
5. Open it. Replace **YOUR_TABLE**, and change the **CHANGE_ME** lines:
   the comment, and your query. Drop the catalog from the query's names:
   **silver.YOUR_VIEW**, not **YOUR_CATALOG.silver.YOUR_VIEW**.
6. In **resources.yml**, if the schemas have no **gold**, add the gold
   schema template below the silver schema.
   - vim: type **:r doc/templates/bootcamp_sql/gold_schema.yml**
   - VS Code: open the template, press **Ctrl+A** and **Ctrl+C**. Click
     the very start of the next line, and press **Ctrl+V**.
   - Then, in the lines you added, replace **YOUR_DATASET**.
7. In **resources.yml**, add the library template below the pipeline's
   last library.
   - vim: type **:r doc/templates/bootcamp_sql/pipeline_library.yml**
   - VS Code: open the template, press **Ctrl+A** and **Ctrl+C**. Click
     the very start of the next line, and press **Ctrl+V**.
   - Then, in the lines you added, replace **YOUR_TABLE**.
8. Check the plan. The pipeline shows change. The first time, the gold
   schema shows create.
9. Deploy.
10. Check the plan again. All show unchanged.
11. Run the pipeline. It refreshes silver, then your table.
12. Query your table.
13. Commit your two files.
14. Merge your branch into master, and push.
15. End.

```
git switch master
git pull
git switch -c YOUR_BRANCH
DESCRIBE YOUR_CATALOG.silver.YOUR_VIEW
cp doc/templates/bootcamp_sql/gold.YOUR_TABLE.sql datasets/YOUR_DATASET/tables/gold.YOUR_TABLE.sql
edit datasets/YOUR_DATASET/tables/gold.YOUR_TABLE.sql
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
databricks bundle run YOUR_DATASET_pipeline -t YOUR_TARGET
SELECT * FROM YOUR_CATALOG.gold.YOUR_TABLE
git add datasets/YOUR_DATASET
git commit -m "Add gold.YOUR_TABLE"
git switch master
git pull
git merge YOUR_BRANCH
git push
```

## Build a Chain

A gold table can read another gold table. Each step is its own file, and
the pipeline runs them in order. Add two more steps on top of the first:

```
silver.yieldCurve
└── gold.yieldCurve_monthly             step 1: average 2-year and 10-year rates per month
    └── gold.yieldCurve_spread          step 2: 10-year minus 2-year, and inverted yes or no
        └── gold.yieldCurve_inversions  step 3: per year, how many months were inverted
```

The yield curve is inverted when the 2-year rate is above the 10-year.

1. Copy the gold template again, as **gold.yieldCurve_spread**.sql, with
   the step 2 query.
2. List it in the pipeline's libraries.
3. Do the same for **gold.yieldCurve_inversions**, with the step 3 query.
4. Check the plan, deploy, and check the plan again.
5. Run the pipeline. Its graph shows the three gold tables in order.
6. Run only the steps you changed. A long chain then reruns only what it
   must.
7. End.

```
cp doc/templates/bootcamp_sql/gold.YOUR_TABLE.sql datasets/treasury/tables/gold.yieldCurve_spread.sql
edit datasets/treasury/tables/gold.yieldCurve_spread.sql
edit datasets/treasury/resources.yml
cp doc/templates/bootcamp_sql/gold.YOUR_TABLE.sql datasets/treasury/tables/gold.yieldCurve_inversions.sql
edit datasets/treasury/tables/gold.yieldCurve_inversions.sql
edit datasets/treasury/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
py tools/bundle_plan.py YOUR_TARGET
databricks bundle run treasury_pipeline -t YOUR_TARGET
databricks bundle run treasury_pipeline -t YOUR_TARGET --refresh gold.yieldCurve_spread,gold.yieldCurve_inversions
```

Step 2:

```
SELECT
  month,
  round(avg_10year - avg_2year, 2) AS spread,
  avg_10year < avg_2year           AS inverted
FROM gold.yieldCurve_monthly
```

Step 3:

```
SELECT
  year(month)        AS year,
  count(*)           AS months,
  count_if(inverted) AS inverted_months
FROM gold.yieldCurve_spread
GROUP BY 1
```
