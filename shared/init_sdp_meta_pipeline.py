# Databricks notebook source
# Runner notebook for every sdp-meta pipeline in this bundle.
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

# Custom code for one dataset: see doc/procedures/add_custom_code.md.
DataflowPipeline.invoke_dlt_pipeline(spark, layer)
