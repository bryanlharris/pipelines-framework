-- One view per table, named after it: views/<table>.sql.
-- No catalog here. The views task picks it, so every target runs this file.
CREATE OR REPLACE VIEW silver.fedfunds
COMMENT 'Current effective federal funds rate: the latest version of each month.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.fedfunds_history
WHERE __END_AT IS NULL
