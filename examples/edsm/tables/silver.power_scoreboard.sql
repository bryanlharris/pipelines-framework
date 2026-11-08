-- Silver copy of gold.power_scoreboard: SQL tables work in any schema.
-- Layer 3, from two layer-2 silver tables: one line per power, everything together.
CREATE OR REFRESH MATERIALIZED VIEW silver.power_scoreboard
COMMENT 'One record per power: rank, controlled systems and share from silver.power_rank, plus bodies from silver.power_bodies.'
AS SELECT
  r.rank,
  r.power,
  r.controlled,
  r.share_pct,
  coalesce(b.bodies, 0) AS bodies,
  coalesce(b.landable, 0) AS landable,
  coalesce(b.terraformable, 0) AS terraformable,
  coalesce(b.earth_like, 0) AS earth_like
FROM silver.power_rank r
LEFT JOIN silver.power_bodies b ON b.power = r.power
