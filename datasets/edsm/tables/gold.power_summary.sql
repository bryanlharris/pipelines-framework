-- Layer 1, from silver: one record per power, counting its systems by state.
CREATE OR REFRESH MATERIALIZED VIEW gold.power_summary
COMMENT 'One record per power: count of current systems by powerState, and controlled = stronghold + fortified + exploited.'
AS SELECT
  power,
  count_if(powerState = 'Stronghold') AS stronghold,
  count_if(powerState = 'Fortified')  AS fortified,
  count_if(powerState = 'Exploited')  AS exploited,
  count_if(powerState = 'Unoccupied') AS unoccupied,
  count_if(powerState IN ('Stronghold', 'Fortified', 'Exploited')) AS controlled
FROM silver.powerPlay_history
WHERE __END_AT IS NULL
GROUP BY power
