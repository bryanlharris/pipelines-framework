-- Silver copy of gold.systems_with_power: SQL tables work in any schema.
-- Layer 1, from silver: every current Powerplay system, marked when it was
-- also updated in the last 7 days.
-- No catalog here: the pipeline's catalog is used, so every target runs this file.
-- The pipeline orders tables by what each one reads.
CREATE OR REFRESH MATERIALIZED VIEW silver.systems_with_power
COMMENT 'Current Powerplay systems with their power and state, and recently_updated = true when the system is also in systemsWithCoordinates7days.'
AS SELECT
  p.id,
  p.name,
  p.coords,
  p.power,
  p.powerState,
  p.allegiance,
  p.government,
  p.state,
  s.id IS NOT NULL AS recently_updated
FROM silver.powerPlay_history p
LEFT JOIN silver.systemsWithCoordinates7days_history s
  ON s.id = p.id AND s.__END_AT IS NULL
WHERE p.__END_AT IS NULL
