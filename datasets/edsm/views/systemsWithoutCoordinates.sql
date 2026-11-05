CREATE OR REPLACE VIEW edsm.silver.systemsWithoutCoordinates
COMMENT 'Current star systems with estimated coordinates: the latest version of each id from silver.systemsWithoutCoordinates_history.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM edsm.silver.systemsWithoutCoordinates_history
WHERE __END_AT IS NULL
