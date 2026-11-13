-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.institutions
COMMENT 'View.

Active banks: the latest name, city and state of each CERT.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.institutions_history
WHERE __END_AT IS NULL
