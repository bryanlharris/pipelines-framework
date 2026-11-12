# Targets

A target is a place to deploy. Targets live in git-ignored files in
**targets/**, copied from one of two templates in **doc/templates/target/**:

- **targets.free.local.yml**: the free target, Free Edition at home.
- **targets.team.local.yml**: dev, staging and prod, for a team at work.

Copy the ones you use, and uncomment the targets in them.

```
pipelines-framework
└── team-pipelines                    (bundle name: team)
    ├── jim/add-fred      →  dev      dev_jim_treasury
    ├── sue/fix-rules     →  dev      dev_sue_treasury
    ├── bob/new-table     →  dev      dev_bob_treasury
    └── master
        └── staging_v0.01 →  staging  staging_treasury
            └── prod_v0.1 →  prod     treasury
```

| Target  | Prefix            | Deploys from  | Who              | Procedure                            |
|---------|-------------------|---------------|------------------|--------------------------------------|
| free    | none              | any branch    | you, at home     | [free.md](free.md)                   |
| dev     | `dev_jim_`        | a branch      | each person      | [dev_team.md](dev_team.md)           |
| staging | `staging_`        | a tag         | the team lead    | [staging_team.md](staging_team.md)   |
| prod    | none              | a tag         | the lead, as sp  | [prod_team.md](prod_team.md)         |

Free uses default storage and the upload scripts. Dev, staging and prod keep
each catalog in **s3://bucket/catalogs/**.

Dev and prod get files from the fetch job. Staging's pipelines read prod's
raw.files, and staging's own stay empty.
