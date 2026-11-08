# Dev

> **Old setup:** one shared dev, with the prefix **dev_**. The team setup replaces it: see [README.md](README.md). Its template is gone; copy **targets.team.local.yml** and set the prefixes this page shows.

Sets up the dev target, tests it with a dataset, then releases master to it.

## Prerequisites

1. [setup.md](../setup.md): set up the computer and CLI

## Steps

1. [setup_dev.md](dev/setup_dev.md): add the dev target, and deploy
2. [bind_catalogs.md](dev/bind_catalogs.md): bind the catalogs, and turn on data classification
3. [test_dev.md](dev/test_dev.md): run a dataset end to end
4. [release_dev.md](dev/release_dev.md): tag master, and deploy the tag
5. End.

Later releases need only [release_dev.md](dev/release_dev.md).
