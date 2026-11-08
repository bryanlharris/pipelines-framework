# Targets

A target is a place to deploy. Every target lives in one git-ignored file,
**targets/targets.local.yml**, copied from
**doc/templates/target/targets.local.yml**. Uncomment the targets you use.

- [free.md](free.md): Free Edition, at home. Sets up every dataset at once.
- [dev.md](dev.md): enterprise dev. Set up, bind, test, release.
- [staging.md](staging.md): enterprise staging, from release tags.
- [prod.md](prod.md): enterprise prod, from release tags.

| Target  | Catalog prefix | Storage                     | Files from    | Pipelines         |
|---------|----------------|-----------------------------|---------------|-------------------|
| free    | none           | default storage             | upload script | development mode  |
| dev     | dev_           | s3://bucket/catalogs/       | fetch job     | development mode  |
| staging | staging_       | s3://bucket/catalogs/       | fetch job     | development mode  |
| prod    | none           | s3://bucket/catalogs/       | fetch job     | retries on errors |
