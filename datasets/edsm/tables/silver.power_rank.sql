-- Silver copy of gold.power_rank: SQL tables work in any schema.
-- Layer 2, from silver: powers ranked by controlled systems.
CREATE OR REFRESH MATERIALIZED VIEW silver.power_rank
COMMENT 'Powers ranked by controlled systems (1 = most), with share_pct = percent of all controlled systems. From silver.power_summary.'
AS SELECT
  rank() OVER (ORDER BY controlled DESC) AS rank,
  power,
  controlled,
  round(100 * controlled / sum(controlled) OVER (), 1) AS share_pct
FROM silver.power_summary
