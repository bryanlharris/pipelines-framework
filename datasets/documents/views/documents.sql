-- One view per table, named after it: views/<table>.sql.
-- No catalog here. The views task picks it, so every target runs this file.
CREATE OR REPLACE VIEW silver.documents
COMMENT 'Current AI labels for each PDF. Holds PII: the rationales quote what was found.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.documents_history
WHERE __END_AT IS NULL
