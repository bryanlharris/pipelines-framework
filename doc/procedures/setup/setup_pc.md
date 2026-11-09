← none | [setup_cli.md](setup_cli.md) →

# Set Up PC

## Choose an Editor

The procedures open files with **edit**. Your profile decides which editor
that is. Pick one:

- **VS Code:** the easiest for most people. Installs with scoop.
- **Notepad:** already on Windows. Nothing to install.
- **Vim:** for people who know it. Installs with scoop.

## Steps

1. Install Git and Python.
2. Install scoop.
3. Add scoop extras bucket.
4. Install PowerShell, WezTerm and posh-git.
5. Install your editor, unless it's Notepad.
6. Install the GNU tools.
7. Install the Databricks CLI.
8. Open the new PowerShell (pwsh).
9. Clone your team's repo, or this one if you maintain it. It holds the templates.
10. Add the profile template to your PowerShell profile.
11. In the profile, uncomment the **edit** line for your editor, and leave
    the others commented. Then reload the profile.
12. Copy the WezTerm template to your home folder, unless you have one.
13. Copy the VS Code settings template, if you use VS Code. Warning: the
    copy overwrites your settings. If you have settings already, add the
    template's lines to yours instead.
14. End.

```
winget install Git.Git Python.Python.3.13
irm get.scoop.sh | iex
scoop bucket add extras
scoop install pwsh wezterm posh-git
scoop install vscode
scoop install vim
scoop install grep sed gawk uutils-coreutils
winget install Databricks.DatabricksCLI
pwsh
git clone YOUR_REPO_URL
cd YOUR_REPO
mkdir -Force (Split-Path $PROFILE)
cat doc/templates/pc/profile.ps1 >> $PROFILE
notepad $PROFILE
. $PROFILE
cp doc/templates/pc/wezterm.lua ~/.wezterm.lua
cp doc/templates/pc/vscode_settings.jsonc $env:APPDATA/Code/User/settings.json
```

---

← none | [setup_cli.md](setup_cli.md) →
