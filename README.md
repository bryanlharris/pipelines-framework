# sdp-framework

Loads files into bronze and silver Delta tables in Databricks, with
sdp-meta (Databricks Labs) pipelines. One bundle; each dataset has its own
resource file in resources/ and its own folder.

- edsm/: Elite Dangerous Star Map dumps.
- shared/: file router, pipeline runner notebook, view runner.
- tools/bundle_plan.py: shows what a deploy would do, by real name.

Targets are machine-only: copy doc/examples/free.local.yml to
resources/free.local.yml (git-ignored) and set its profile.
