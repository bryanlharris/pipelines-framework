# Add Custom Code

Gives one dataset its own pipeline runner, with Python that sdp-meta's YAML
can't do. The other datasets keep the shared runner.

The example drops exact repeat records inside one file. sdp-meta calls the
code for each bronze table; a list at the top says which tables it changes.

1. Copy the custom runner template into the dataset's folder.
2. Replace **YOUR_DATASET**, and **YOUR_TABLE** in the **TABLES** list. Add
   one name for each table the code should change.
3. Change the code, or keep the example.
4. Point the dataset's pipeline at its own runner: in **resources.yml**,
   under **libraries:**, change the notebook path to
   **init_sdp_meta_pipeline.py**.
5. Check the plan. The pipeline shows change, for its notebook path.
6. Deploy.
7. Run the pipeline. The run is green.
8. End.

```
cp doc/templates/custom_runner/init_sdp_meta_pipeline.py datasets/YOUR_DATASET/
edit datasets/YOUR_DATASET/init_sdp_meta_pipeline.py
edit datasets/YOUR_DATASET/resources.yml
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
databricks bundle run YOUR_DATASET_pipeline -t YOUR_TARGET
```

```
      libraries:
        - notebook:
            path: init_sdp_meta_pipeline.py
```
