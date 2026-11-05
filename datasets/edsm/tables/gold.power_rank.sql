-- Powers ranked by controlled systems, with each one's share.
-- Reads gold.power_summary, so SDP runs it after that table: gold -> gold.
CREATE MATERIALIZED VIEW edsm.gold.power_rank
COMMENT 'Powers ranked by controlled systems (1 = most), with share_pct = percent of all controlled systems. From gold.power_summary.'
AS SELECT
  rank() OVER (ORDER BY controlled DESC) AS rank,
  power,
  controlled,
  round(100 * controlled / sum(controlled) OVER (), 1) AS share_pct
FROM edsm.gold.power_summary
