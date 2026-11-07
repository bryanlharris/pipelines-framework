-- One view per table, named after it: views/<table>.sql.
-- No catalog here. The views task picks it, so every target runs this file.
CREATE OR REPLACE VIEW silver.powerPlay
COMMENT 'Current powerPlay records: the latest version of each (id, power).'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.powerPlay_history
WHERE __END_AT IS NULL
