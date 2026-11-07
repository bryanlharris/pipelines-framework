-- Layer 2, from two gold tables: what each power's systems hold.
CREATE OR REFRESH MATERIALIZED VIEW gold.power_bodies
COMMENT 'One record per power: bodies seen in the last 7 days in its systems, and how many are landable, terraformable or Earth-like. Joins gold.bodies_with_system to gold.systems_with_power.'
AS SELECT
  s.power,
  count(*) AS bodies,
  count_if(b.isLandable) AS landable,
  count_if(b.terraformingState = 'Candidate for terraforming') AS terraformable,
  count_if(b.subType = 'Earth-like world') AS earth_like
FROM gold.bodies_with_system b
JOIN gold.systems_with_power s ON s.id = b.systemId
GROUP BY s.power
