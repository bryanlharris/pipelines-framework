# sdp-framework

Loads files into Databricks delta tables, with
sdp-meta (Databricks Labs) pipelines. One bundle; each dataset has its own
folder (resources.yml, conf/, views/, upload script). Targets are in
targets/.

See: doc/procedures/.

- doc/procedures/: step-by-step instructions, one file per task.
- doc/templates/: files to copy, one folder per kind of thing.
- doc/glossary.md: what sdp-meta calls things e.g. onboarding is like settings.
- tools/bundle_plan.py: shows what a deploy would do, by real name.

Personal targets like free are special i.e. ignored by git: copy
doc/templates/target/free.local.yml to targets/free.local.yml (git-ignored)
and set its profile.
