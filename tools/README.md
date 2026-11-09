# Tools

Scripts you run from the repo's root folder.

- [bundle_plan.py](bundle_plan.py): shows what a deploy would do.
  `py tools/bundle_plan.py dev`
- [govern_catalogs.ps1](govern_catalogs.ps1): binds each catalog to the workspace, isolates it, turns on data classification, and turns on data quality monitoring for silver and gold. Skips what's already done.
  `./tools/govern_catalogs.ps1 -Target dev`
