CREATE OR REPLACE VIEW edsm.silver.systems
COMMENT 'Current star systems: the latest version of each id from silver.systems_history.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM edsm.silver.systems_history
WHERE __END_AT IS NULL
