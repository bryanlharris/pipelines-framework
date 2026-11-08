← [setup_cli.md](setup_cli.md) | none →

# Set Up Genie Code

Gives Genie Code, the AI in the Databricks workspace, the repo's rules. The
skill is one short file in the repo: it tells Genie to read **AGENTS.md**,
then the procedure for the task. Each person adds it once per workspace.

1. Clone the repo as a Git folder in your workspace, unless it is there:
   **Workspace** → **Create** → **Git folder** → with the repo's URL.
2. In the workspace browser, open the Git folder → **doc** → **templates** →
   **genie**. On the **sdp-framework** folder, open its **⋮** menu →
   **Copy path**.
3. Open Genie Code → its settings → **Skills** → **Add skill**, and paste
   the path.
4. The skill shows in the list as **sdp-framework**, switched on. It reads
   the file from the Git folder, so a pull updates it.
5. Try it in a new chat: "Use the sdp-framework skill. Which procedure adds
   a table?" It names **add_table.md**.
6. End.

---

← [setup_cli.md](setup_cli.md) | none →
