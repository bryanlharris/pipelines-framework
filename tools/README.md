# Tools

Scripts you run from the repo's root folder.

- [bundle_plan.py](bundle_plan.py): shows what a deploy would do.
  `py tools/bundle_plan.py dev`
- [bind_catalogs.ps1](bind_catalogs.ps1): binds controlled catalogs to the workspace and turns on data classification.
  `./tools/bind_catalogs.ps1 -Target dev`
- [pack_for_ai.ps1](pack_for_ai.ps1): packs the rules, templates and an example dataset into one file, for an AI that can't read the repo.
  `./tools/pack_for_ai.ps1`
