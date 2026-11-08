-- One view per table: tables/silver.<table>.sql. The pipeline makes it.
-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.documents
COMMENT 'View.

AI labels for each PDF. Holds PII: the rationales quote what was found.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.documents_history
WHERE __END_AT IS NULL
