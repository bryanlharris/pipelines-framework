CREATE OR REPLACE VIEW documents.silver.pii_inventory
COMMENT 'One record per PDF, no PII values: has_pii, the PII types found (confidence 0.8 or more), and the highest confidence. From silver.pii_scans.'
AS
WITH findings AS (
  SELECT source_file, ingest_time, f.value AS label, f.confidence_score AS confidence
  FROM documents.silver.pii_scans
  LATERAL VIEW OUTER explode(
    from_json(
      CAST(classification AS STRING),
      'STRUCT<response: ARRAY<STRUCT<value: STRING, confidence_score: DOUBLE>>>'
    ).response
  ) AS f
)
SELECT
  source_file,
  size(array_sort(collect_set(CASE WHEN label <> 'none' AND confidence >= 0.8 THEN label END))) > 0 AS has_pii,
  array_sort(collect_set(CASE WHEN label <> 'none' AND confidence >= 0.8 THEN label END)) AS pii_types,
  max(CASE WHEN label <> 'none' AND confidence >= 0.8 THEN confidence END) AS max_confidence,
  max(ingest_time) AS scanned_at
FROM findings
GROUP BY source_file
