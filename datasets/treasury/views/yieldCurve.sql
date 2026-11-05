CREATE OR REPLACE VIEW treasury.silver.yieldCurve
COMMENT 'Current daily yield curve: the latest version of each NEW_DATE from silver.yieldCurve_history.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM treasury.silver.yieldCurve_history
WHERE __END_AT IS NULL
