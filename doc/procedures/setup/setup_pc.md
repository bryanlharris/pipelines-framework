← none | [setup_cli.md](setup_cli.md) →

# Set Up PC

1. Install Git and Python.
2. Install scoop.
3. Add scoop extras bucket.
4. Install Vim, PowerShell, WezTerm and posh-git.
5. Install the GNU tools.
6. Install the Databricks CLI.
7. Open the new PowerShell, **pwsh**.
8. Clone your team's repo, or this one if you maintain it. It holds the templates.
9. Add the profile template to your PowerShell profile. It sets **edit** to
   vim; change it to code for VS Code.
10. Copy the WezTerm template to your home folder, unless you have one.
11. Copy the VS Code settings template, if you use VS Code. Warning: the
    copy overwrites your settings. If you have settings already, add the
    template's lines to yours instead.

```
winget install Git.Git Python.Python.3.13
irm get.scoop.sh | iex
scoop bucket add extras
scoop install vim pwsh wezterm posh-git
scoop install grep sed gawk uutils-coreutils
winget install Databricks.DatabricksCLI
pwsh
git clone YOUR_REPO_URL
cd YOUR_REPO
mkdir -Force (Split-Path $PROFILE)
cat doc/templates/pc/profile.ps1 >> $PROFILE
cp doc/templates/pc/wezterm.lua ~/.wezterm.lua
cp doc/templates/pc/vscode_settings.jsonc $env:APPDATA/Code/User/settings.json
```

---

← none | [setup_cli.md](setup_cli.md) →
