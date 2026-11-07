-- Layer 1, from silver: every current body, with its system's coordinates.
CREATE OR REFRESH MATERIALIZED VIEW gold.bodies_with_system
COMMENT 'Current bodies updated in the last 7 days, with their system''s coordinates when that system was also updated in the last 7 days.'
AS SELECT
  b.id,
  b.name,
  b.type,
  b.subType,
  b.isLandable,
  b.terraformingState,
  b.systemId,
  b.systemName,
  s.coords
FROM silver.bodies7days_history b
LEFT JOIN silver.systemsWithCoordinates7days_history s
  ON s.id = b.systemId AND s.__END_AT IS NULL
WHERE b.__END_AT IS NULL
