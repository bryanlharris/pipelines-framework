-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.YOUR_TABLE
COMMENT 'View.

CHANGE_ME → what one record is, e.g. Daily yield curve: the latest version of each NEW_DATE.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.YOUR_TABLE_history
WHERE __END_AT IS NULL
