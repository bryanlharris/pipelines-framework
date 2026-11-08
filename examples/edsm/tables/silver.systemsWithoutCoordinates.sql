-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.systemsWithoutCoordinates
COMMENT 'View.

Star systems with estimated coordinates: the latest version of each id.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.systemsWithoutCoordinates_history
WHERE __END_AT IS NULL
