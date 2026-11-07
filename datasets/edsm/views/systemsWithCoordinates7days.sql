-- One view per table, named after it: views/<table>.sql.
-- No catalog here. The views task picks it, so every target runs this file.
CREATE OR REPLACE VIEW silver.systemsWithCoordinates7days
COMMENT 'Current star systems: the latest version of each id.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.systemsWithCoordinates7days_history
WHERE __END_AT IS NULL
