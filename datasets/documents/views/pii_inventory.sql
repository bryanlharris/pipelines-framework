-- No catalog here. The views task picks it, so every target runs this file.
-- One row per PDF, no PII values: which kinds of PII ai_classify found,
-- counting only labels with confidence 0.8 or more.
CREATE OR REPLACE VIEW silver.pii_inventory
COMMENT 'One row per PDF: whether it holds PII, which kinds, and the highest confidence. No PII values.'
AS WITH findings AS (
  SELECT source_file, ingest_time, f.value AS label, f.confidence_score AS confidence
  FROM silver.documents
  LATERAL VIEW explode(
    from_json(classification, 'STRUCT<response: ARRAY<STRUCT<value: STRING, confidence_score: DOUBLE>>>').response
  ) AS f
)
SELECT
  source_file,
  size(array_sort(collect_set(CASE WHEN label <> 'none' AND confidence >= 0.8 THEN label END))) > 0 AS has_pii,
  array_sort(collect_set(CASE WHEN label <> 'none' AND confidence >= 0.8 THEN label END)) AS pii_types,
  max(CASE WHEN label <> 'none' AND confidence >= 0.8 THEN confidence END) AS max_confidence,
  ingest_time AS scanned_at
FROM findings
GROUP BY source_file, ingest_time
