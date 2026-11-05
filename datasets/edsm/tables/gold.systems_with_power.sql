-- Every current system, with its power when powerPlay lists it.
-- Runs inside pipeline "edsm - pipeline", after the two silver tables it reads:
-- SDP works out the order from the FROM and JOIN below.
CREATE MATERIALIZED VIEW edsm.gold.systems_with_power
COMMENT 'Current systems (silver.systems_history) with their power, allegiance and state from silver.powerPlay_history. Systems without a power have nulls there.'
AS SELECT
  s.id,
  s.id64,
  s.name,
  s.coords,
  s.date,
  p.power,
  p.powerState,
  p.allegiance,
  p.government,
  p.state
FROM edsm.silver.systems_history s
LEFT JOIN edsm.silver.powerPlay_history p
  ON p.id = s.id AND p.__END_AT IS NULL
WHERE s.__END_AT IS NULL
