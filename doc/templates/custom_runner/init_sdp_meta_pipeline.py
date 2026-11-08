# Databricks notebook source
# Runner notebook for YOUR_DATASET's pipeline, with custom code.
# Copied from doc/templates/custom_runner/; see doc/procedures/add_custom_code.md.
# The pipeline's configuration says which layer and settings tables to use.
#
# Keep cell 1 SHORT (variable read + %pip install only): any multi-line Python
# before %pip in the same cell makes SDP fail with "SyntaxError: incomplete input".
# Serverless pipelines can't install wheels from libraries:, so it happens here.
sdp_meta_dependency = spark.conf.get("sdp_meta_dependency")
%pip install $sdp_meta_dependency  # noqa: E999

# COMMAND ----------

# Validate + invoke. By the time we reach this cell, sdp-meta is importable.
dep = spark.conf.get("sdp_meta_dependency", "")
if dep == "__SET_ME__" or not dep:
    raise ValueError(
        "sdp_meta_dependency is still set to the placeholder `__SET_ME__`. "
        "Replace it in databricks.yml with either a PyPI coordinate "
        "(e.g. `databricks-labs-sdp-meta==0.1.0`) or a UC-volume wheel path "
        "(e.g. `/Volumes/<catalog>/<schema>/<volume>/databricks_labs_sdp_meta-"
        "<version>-py3-none-any.whl`). For the volume path, run "
        "`databricks labs sdp-meta bundle-prepare-wheel` to build and upload "
        "the wheel and copy the printed path."
    )

layer = spark.conf.get("layer", None)
from databricks.labs.sdp_meta.dataflow_pipeline import DataflowPipeline
from pyspark.sql import functions as F

# The tables this code runs on. Every other table passes through untouched.
TABLES = ("YOUR_TABLE",)


def drop_repeats_within_file(df, dataflow_spec):
    """Example custom code: drop exact repeat records inside one file.

    sdp-meta calls this for each bronze table, with that table's settings.
    Every column counts, source_file included, so the same record in two
    different files is kept. The metadata structs are left out: a big file
    is read in blocks, and file_block_start differs between blocks.

    A file always lands in one micro-batch. The batch time column gives a
    watermark that never sees late data, so dedupe state is cleared after
    10 minutes instead of growing forever.
    """
    if dataflow_spec.targetDetails["table"] not in TABLES:
        return df
    if dataflow_spec.sourceFormat != "cloudFiles":
        return df
    columns = [c for c in df.columns if c not in ("_metadata", "source_metadata")]
    return (
        df.withColumn("_batch_time", F.current_timestamp())
        .withWatermark("_batch_time", "10 minutes")
        .dropDuplicatesWithinWatermark(columns)
        .drop("_batch_time")
    )


DataflowPipeline.invoke_dlt_pipeline(
    spark, layer, bronze_custom_transform_func=drop_repeats_within_file
)
