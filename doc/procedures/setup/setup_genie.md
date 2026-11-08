← [setup_cli.md](setup_cli.md) | none →

# Set Up Genie

Gives Genie, the AI in the Databricks workspace, the repo's rules. The
skill is one short file in the repo: it tells Genie to read **AGENTS.md**,
then the procedure for the task. Each person adds it once per workspace.

## With the GUI

1. Clone the repo as a Git folder in your workspace:
   **Workspace** → **Create** → **Git folder** → with the repo's URL.
2. Open Genie → **⋮** menu → **Customizations** → **Skills**.
3. If Genie has no skills folder yet, click the button to create one. It
   lives in your home folder, at **.assistant/skills**.
4. In the workspace browser, open the Git folder → **doc** → **templates** →
   **genie**.
5. Clone the **sdp-framework** folder into **.assistant/skills**: its **⋮**
   menu → **Clone**, and pick **.assistant/skills** as the place. Keep the
   name **sdp-framework**.
6. Back in **Skills**, the skill shows in the list as **sdp-framework**,
   switched on. If it doesn't, refresh the page.
7. Click the skill → **Try in new chat**. Genie types "Use the sdp-framework
   skill." by itself.
8. Genie asks what you want in small forms, with choices and text fields.
   Fill them in, and click **Submit All**.
9. End.

When the skill template changes in the repo, copy the folder again.

## With the CLI

Steps 2–5 in one go, from the repo on your computer. The skills folder is
made if it is missing. Then carry on from step 6.

```
$me = (databricks current-user me -p YOUR_TARGET -o json | ConvertFrom-Json).userName
databricks workspace import-dir doc/templates/genie/sdp-framework /Workspace/Users/$me/.assistant/skills/sdp-framework -p YOUR_TARGET --overwrite
```

---

← [setup_cli.md](setup_cli.md) | none →
