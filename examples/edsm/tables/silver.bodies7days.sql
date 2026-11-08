-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.bodies7days
COMMENT 'View.

Bodies: the latest version of each id.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.bodies7days_history
WHERE __END_AT IS NULL
