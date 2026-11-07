# sdp-framework

Loads files into Databricks delta tables, with
sdp-meta (Databricks Labs) pipelines. One bundle; each dataset has its own
folder (resources.yml, conf/, views/, upload script). Targets are in
targets/.

See: doc/README.md.

- doc/procedures/: step-by-step instructions, one file per task.
- doc/templates/: files to copy, one folder per kind of thing.
- doc/glossary.md: what sdp-meta calls things e.g. onboarding is like settings.
- tools/bundle_plan.py: shows what a deploy would do, by real name.
- tools/bind_catalogs.ps1: binds each catalog to the workspace and turns on data classification.
- AGENTS.md: instructions for AI assistants, e.g. Copilot. Ask one to add a dataset or a table.

Targets are ignored by git: copy doc/templates/target/targets.local.yml
to targets/, and uncomment the ones you use.
