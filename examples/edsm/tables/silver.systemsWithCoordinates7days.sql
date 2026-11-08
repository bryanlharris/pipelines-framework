-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.systemsWithCoordinates7days
COMMENT 'View.

Star systems: the latest version of each id.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.systemsWithCoordinates7days_history
WHERE __END_AT IS NULL
