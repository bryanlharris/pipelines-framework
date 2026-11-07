-- No catalog here. The views task picks it, so every target runs this file.
CREATE OR REPLACE VIEW silver.yieldCurve
COMMENT 'Current daily yield curve: the latest version of each NEW_DATE.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.yieldCurve_history
WHERE __END_AT IS NULL
