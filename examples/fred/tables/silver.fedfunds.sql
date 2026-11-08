-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.fedfunds
COMMENT 'View.

Effective federal funds rate: the latest version of each month.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.fedfunds_history
WHERE __END_AT IS NULL
