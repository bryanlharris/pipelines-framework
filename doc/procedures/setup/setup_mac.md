← none | [setup_cli.md](setup_cli.md) →

# Set Up Mac

1. Install Homebrew.
2. Install Git, Python and Vim.
3. Install PowerShell. The upload scripts need it.
4. Install the Databricks CLI.
5. Clone your team's repo, or this one if you maintain it. It holds the templates.
6. Add the shell profile template to **~/.zshrc**, or to **~/.bash_profile**
   if you use bash. It sets **edit** to vim; change it to code for VS Code.
7. Open a new terminal.

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git python vim
brew install --cask powershell
brew tap databricks/tap
brew install databricks
git clone YOUR_REPO_URL
cd YOUR_REPO
cat doc/templates/mac/shell_profile >> ~/.zshrc
```

---

← none | [setup_cli.md](setup_cli.md) →
