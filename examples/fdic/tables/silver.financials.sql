-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.financials
COMMENT 'View.

Bank quarterly financials: the latest version of each bank and quarter.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.financials_history
WHERE __END_AT IS NULL
