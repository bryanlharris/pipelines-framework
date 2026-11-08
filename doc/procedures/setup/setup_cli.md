← [setup_pc.md](setup_pc.md) or [setup_mac.md](setup_mac.md) | [setup_genie.md](setup_genie.md) →

# Set Up the Databricks CLI

## Enterprise Edition

1. Add the dev, staging and prod profiles to the config file, each with its host.
2. Log in to each. Each time your browser opens to sign in.
3. Check each profile. It prints your user.

```
edit ~/.databrickscfg
databricks auth login --profile dev
databricks auth login --profile staging
databricks auth login --profile prod
databricks current-user me --profile dev
databricks current-user me --profile staging
databricks current-user me --profile prod
```

```
[dev]
host      = https://foobar-dev.cloud.databricks.com
auth_type = databricks-cli

[staging]
host      = https://foobar-staging.cloud.databricks.com
auth_type = databricks-cli

[prod]
host      = https://foobar-prod.cloud.databricks.com
auth_type = databricks-cli
```

## Free Edition

The free target is for home use only, so git ignores it.

1. Make a token in your workspace: Settings, Developer, Access tokens
   ([how](https://docs.databricks.com/aws/en/dev-tools/auth/pat)).
2. Add the free profile to the config file, with your host and token.
3. Check the profile. It prints your user.
4. Copy the targets template into **targets/**.
5. Uncomment **free**.

```
edit ~/.databrickscfg
databricks current-user me --profile free
cp doc/templates/target/targets.local.yml targets/
edit targets/targets.local.yml
```

```
[free]
host  = https://foobar-free.cloud.databricks.com
token = YOUR_TOKEN

[__settings__]
default_profile = free
```

---

← [setup_pc.md](setup_pc.md) or [setup_mac.md](setup_mac.md) | [setup_genie.md](setup_genie.md) →
