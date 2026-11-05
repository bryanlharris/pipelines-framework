-- One record per power: how many current systems it holds in each state.
-- Reads silver.powerPlay_history; gold.power_rank reads this.
CREATE MATERIALIZED VIEW edsm.gold.power_summary
COMMENT 'One record per power: count of current systems by powerState (stronghold, fortified, exploited, unoccupied), and controlled = the first three. From silver.powerPlay_history.'
AS SELECT
  power,
  count_if(powerState = 'Stronghold') AS stronghold,
  count_if(powerState = 'Fortified')  AS fortified,
  count_if(powerState = 'Exploited')  AS exploited,
  count_if(powerState = 'Unoccupied') AS unoccupied,
  count_if(powerState IN ('Stronghold', 'Fortified', 'Exploited')) AS controlled
FROM edsm.silver.powerPlay_history
WHERE __END_AT IS NULL
GROUP BY power
