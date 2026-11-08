-- No catalog here: the pipeline's catalog, so every target runs this file.
CREATE VIEW silver.yieldCurve
COMMENT 'View.

Daily yield curve: the latest version of each NEW_DATE.'
AS SELECT * EXCEPT (__START_AT, __END_AT)
FROM silver.yieldCurve_history
WHERE __END_AT IS NULL
