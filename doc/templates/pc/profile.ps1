
Import-Module posh-git
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -ViModeIndicator None
Set-PSReadLineOption -ExtraPromptLineCount 0
Set-PSReadLineOption -EnableScreenReaderMode:$false
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
# No beep when Tab finds nothing
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key Shift+Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Alt+f -Function ForwardWord
Set-PSReadLineKeyHandler -Key Alt+b -Function BackwardWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Key Ctrl+d -Function ViExit
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine

Set-Alias which Get-Command
Set-Alias vi vim
# The procedures open files with edit. For VS Code: Set-Alias edit code
# (This hides Windows' own edit command in PowerShell.)
Set-Alias edit vim
# Tab stops at "databricks", not "databricks." (databricks.yml also matches)
Set-Alias databricks databricks.exe

# Linux-style commands
function df { Get-PSDrive -PSProvider FileSystem }
function export($kv) { $k, $v = $kv -split '=', 2; Set-Item "env:$k" $v }

# GNU versions of commands PowerShell or Windows already use (uutils-coreutils)
foreach ($c in "cat", "ls", "cp", "rm", "mv", "sort") { Set-Alias "g$c" "$HOME\scoop\shims\$c.exe" }

# When Tab offers commands, hide files that can't run (like databricks.yml)
# Save the builtin once, so sourcing the profile again does not loop forever
if (-not $global:BuiltinTabExpansion2) { $global:BuiltinTabExpansion2 = ${function:TabExpansion2} }
function TabExpansion2 {
    [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
    param(
        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory, Position = 0)]
        [string] $inputScript,
        [Parameter(ParameterSetName = 'ScriptInputSet', Position = 1)]
        [int] $cursorColumn = $inputScript.Length,
        [Parameter(ParameterSetName = 'AstInputSet', Mandatory, Position = 0)]
        [System.Management.Automation.Language.Ast] $ast,
        [Parameter(ParameterSetName = 'AstInputSet', Mandatory, Position = 1)]
        [System.Management.Automation.Language.Token[]] $tokens,
        [Parameter(ParameterSetName = 'AstInputSet', Mandatory, Position = 2)]
        [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,
        [Parameter(Position = 2)]
        [Hashtable] $options = $null
    )
    $result = & $global:BuiltinTabExpansion2 @PSBoundParameters
    $found = $result.CompletionMatches
    if ($found | Where-Object ResultType -eq 'Command') {
        $runnable = ($env:PATHEXT -split ';') + '.PS1'
        $keep = @($found | Where-Object {
            -not ($_.ResultType -eq 'ProviderItem' -and
                  [IO.Path]::GetExtension($_.ListItemText) -notin $runnable)
        })
        $found.Clear()
        foreach ($m in $keep) { $found.Add($m) }
    }
    $result
}
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function prompt {
    # Line 1: current directory
    $path = (Get-Location).Path

    # Line 2: git info with no leading space
    $git = ""
    if (Get-Module posh-git) {
        try {
            $git = (Write-VcsStatus).TrimStart()
        } catch {}
    }

    # Tell WezTerm the cwd (OSC 7) so new tabs open here
    $osc7 = ""
    $loc = $executionContext.SessionState.Path.CurrentLocation
    if ($loc.Provider.Name -eq "FileSystem") {
        $osc7 = "`e]7;file://$env:COMPUTERNAME/$($loc.ProviderPath -replace '\\', '/')`e\"
    }

    # Final 3-line prompt
    "$osc7`n$path`n$git`n> "
}

function vdir {
    Get-ChildItem |
    Sort-Object -Property @{Expression='PSIsContainer';Descending=$true}, Name |
    ForEach-Object {
        $size =
            if ($_.PSIsContainer) { '<DIR>' }
            elseif ($_.Length -ge 1GB) { '{0:N1}G' -f ($_.Length/1GB) }
            elseif ($_.Length -ge 1MB) { '{0:N1}M' -f ($_.Length/1MB) }
            elseif ($_.Length -ge 1KB) { '{0:N1}K' -f ($_.Length/1KB) }
            else { "$($_.Length)B" }

        "{0,-5} {1,8} {2,-16} {3}" -f `
            $_.Mode,
            $size,
            $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm'),
            $_.Name
    }
}
