-- One view per table, named after it: views/<table>.sql.
-- No catalog here. The views task picks it, so every target runs this file.
CREATE OR REPLACE VIEW silver.YOUR_TABLE
COMMENT 'CHANGE_ME → what one record is, e.g. Current daily yield curve: the latest version of each NEW_DATE.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.YOUR_TABLE_history
WHERE __END_AT IS NULL
