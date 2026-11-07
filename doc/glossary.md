# Glossary

Our words, and what sdp-meta or Databricks calls the same thing.

```
our word          meaning                                   sdp-meta / Databricks word
----------------  ----------------------------------------  --------------------------
add a table       make a new table from scratch: copy the   (none)
                  templates, fill in the blanks
apply settings    copy a dataset's conf/ YAML into its      onboarding
                  settings tables; run after any deploy
                  that changes conf/
settings tables   YOUR_DATASET.sdp_meta.bronze_dataflowspec    dataflowspec tables
                  and silver_dataflowspec
procedure         step-by-step instructions in              (we never say runbook)
                  doc/procedures/
template          a file to copy, in doc/templates/         (none)
```
