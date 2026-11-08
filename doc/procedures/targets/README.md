# Targets

A target is a place to deploy. Targets live in git-ignored files in
**targets/**, copied from one of two templates in **doc/templates/target/**:

- **targets.free.local.yml**: the free target, Free Edition at home.
- **targets.team.local.yml**: dev, staging and prod, for a team at work.

Copy the ones you use, and uncomment the targets in them.

```
pipelines-framework (today: sdp-framework)
└── team-pipelines                    bundle team
    ├── jim/add-fred      →  dev      dev_team_jim_treasury
    ├── sue/fix-rules     →  dev      dev_team_sue_treasury
    ├── bob/new-table     →  dev      dev_team_bob_treasury
    └── master
        └── staging_v0.01 →  staging  staging_treasury
            └── prod_v0.1 →  prod     treasury
```

| Target  | Prefix            | Deploys from  | Who              | Procedure                            |
|---------|-------------------|---------------|------------------|--------------------------------------|
| free    | none              | any branch    | you, at home     | [free.md](free.md)                   |
| dev     | `dev_team_jim_`   | a branch      | each person      | [dev_team.md](dev_team.md)           |
| staging | `staging_`        | a tag         | the team lead    | [staging_team.md](staging_team.md)   |
| prod    | none              | a tag         | an admin, as sp  | [prod_team.md](prod_team.md)         |

Free uses default storage and the upload scripts. Dev, staging and prod keep
each catalog in **s3://bucket/catalogs/**, and get files from the fetch job.

## Old Setup

[dev.md](dev.md), [staging.md](staging.md) and [prod.md](prod.md) set up
one shared dev, with the prefix **dev_**. They stay until the team setup
replaces them.
