-- One gold table: tables/gold.<table>.sql, listed in the pipeline's libraries.
-- No catalog here: the pipeline's catalog, so every target runs this file.
-- Read silver by plain names, e.g. silver.yieldCurve.
CREATE OR REFRESH MATERIALIZED VIEW gold.YOUR_TABLE
COMMENT 'CHANGE_ME → what one record is, e.g. One record per month: the average 2-year and 10-year rates.'
AS SELECT
  CHANGE_ME
FROM silver.CHANGE_ME
