# sdp-framework

Loads files into bronze and silver Delta tables in Databricks, with
sdp-meta (Databricks Labs) pipelines. One bundle; each dataset has its own
folder (resources.yml, conf/, views/, upload script). Targets are in
targets/.

- datasets/edsm/: Elite Dangerous Star Map dumps.
- datasets/treasury/: US Treasury daily yield curve rates.
- datasets/documents/: PDFs scanned for PII with AI functions.
- shared/: file router, pipeline runner notebook, view runner.
- tools/bundle_plan.py: shows what a deploy would do, by real name.
- doc/onboarding.md: how a dataset's conf/ files work, and how to add a table.

Targets are machine-only: copy doc/examples/free.local.yml to
targets/free.local.yml (git-ignored) and set its profile.
