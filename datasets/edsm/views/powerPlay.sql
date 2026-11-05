CREATE OR REPLACE VIEW edsm.silver.powerPlay
COMMENT 'Current powerPlay records: the latest version of each (id, power) from silver.powerPlay_history.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM edsm.silver.powerPlay_history
WHERE __END_AT IS NULL
