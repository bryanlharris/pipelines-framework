← [setup_dev.md](setup_dev.md) | [test_dev.md](test_dev.md) →

# Bind Catalogs

Binds each of the bundle's catalogs to this workspace, and turns on data
classification. The bundle can't do either yet. Run it after the first
deploy to a target, and after each new dataset. Running it again is safe.

1. Run the bind tool for the target. For each catalog, it binds it,
   isolates it, and turns on data classification. Classification says
   **already exists** for a catalog that has it, and **not available** on
   free.
2. Open a catalog in Catalog Explorer. The **Workspaces** tab lists only
   this workspace. The **Details** tab shows Data Classification on.
3. End.

```
./tools/bind_catalogs.ps1 -Target dev
```

---

← [setup_dev.md](setup_dev.md) | [test_dev.md](test_dev.md) →
