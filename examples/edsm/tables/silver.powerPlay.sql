-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.powerPlay
COMMENT 'View.

powerPlay records: the latest version of each (id, power).'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.powerPlay_history
WHERE __END_AT IS NULL
