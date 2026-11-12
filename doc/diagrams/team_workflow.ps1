# Draws the team workflow (dev, staging, prod, git) in Visio. Needs Visio. Saves ~/Downloads/team-workflow.vsdx.
$mono = "Consolas"   # font for the trees and the commit log
$v = New-Object -ComObject Visio.Application
$doc = $v.Documents.Add("")
$p = $doc.Pages.Item(1)
$p.AutoSize = $false   # keep the page from growing when a shape nears the edge
$p.PageSheet.CellsU("PageWidth").FormulaU = "12.4 in"
$p.PageSheet.CellsU("PageHeight").FormulaU = "10.3 in"

function Box($x, $y, $text, $fill, $line, $w = 1.4, $h = 0.7) {
    $s = $p.DrawRectangle($x - $w/2, $y - $h/2, $x + $w/2, $y + $h/2)
    $s.Text = $text
    $s.CellsU("FillForegnd").FormulaU = "RGB($fill)"
    $s.CellsU("LineColor").FormulaU = "RGB($line)"
    $s.CellsU("Char.Size").FormulaU = "12 pt"
    $s
}
function Panel($x1, $y1, $x2, $y2, $text, $fill, $line) {
    $s = $p.DrawRectangle($x1, $y1, $x2, $y2)
    $s.Text = $text
    $s.CellsU("FillForegnd").FormulaU = "RGB($fill)"
    $s.CellsU("LineColor").FormulaU = "RGB($line)"
    $s.CellsU("LineWeight").FormulaU = "2 pt"
    $s.CellsU("Rounding").FormulaU = "0.15 in"
    $s.CellsU("VerticalAlign").FormulaU = "0"
    $s.CellsU("Char.Size").FormulaU = "20 pt"
    $s.CellsU("Char.Style").FormulaU = "1"
    $s.CellsU("Char.Color").FormulaU = "RGB($line)"
    $s
}
function Tree($x1, $y1, $x2, $y2, $text, $line) {
    $s = $p.DrawRectangle($x1, $y1, $x2, $y2)
    $s.Text = $text
    $s.CellsU("LineColor").FormulaU = "RGB($line)"
    $s.CellsU("Rounding").FormulaU = "0.08 in"
    $s.CellsU("VerticalAlign").FormulaU = "0"
    $s.CellsU("Para.HorzAlign").FormulaU = "0"
    $s.CellsU("LeftMargin").FormulaU = "0.12 in"
    $s.CellsU("Char.Font").FormulaU = "FONT(`"$mono`")"
    $s.CellsU("Char.Size").FormulaU = "8 pt"
    $s
}
function Note($x, $y, $text, $color) {
    $s = $p.DrawRectangle($x - 1.3, $y - 0.22, $x + 1.3, $y + 0.22)
    $s.Text = $text
    $s.CellsU("LinePattern").FormulaU = "0"
    $s.CellsU("FillPattern").FormulaU = "0"
    $s.CellsU("Char.Size").FormulaU = "12 pt"
    $s.CellsU("Char.Color").FormulaU = "RGB($color)"
}
function Arrow($a, $b, $text, $both = $false) {
    $a.AutoConnect($b, 0)
    $c = $p.Shapes.Item($p.Shapes.Count)
    $c.CellsU("ShapeRouteStyle").FormulaU = "16"
    $c.CellsU("EndArrow").FormulaU = "4"
    $c.CellsU("LineWeight").FormulaU = "2.25 pt"
    if ($both) { $c.CellsU("BeginArrow").FormulaU = "4" }
    if ($text) {
        $x = ($a.CellsU("PinX").ResultIU + $b.CellsU("PinX").ResultIU) / 2
        $y = ($a.CellsU("PinY").ResultIU + $b.CellsU("PinY").ResultIU) / 2
        Tag $x $text $y "242,242,242"
    }
}
function Tag($x, $text, $y = 3.9, $fill = "255,255,255") {
    $w = $text.Length * 0.035 + 0.06
    $s = $p.DrawRectangle($x - $w, $y - 0.1, $x + $w, $y + 0.1)
    $s.Text = $text
    $s.CellsU("LinePattern").FormulaU = "0"
    $s.CellsU("FillForegnd").FormulaU = "RGB($fill)"
    foreach ($m in "TopMargin", "BottomMargin", "LeftMargin", "RightMargin") { $s.CellsU($m).FormulaU = "0" }
    $s.CellsU("Char.Size").FormulaU = "10 pt"
    $s.CellsU("Char.Style").FormulaU = "1"
    $s.CellsU("LeftMargin").FormulaU = "1 pt"; $s.CellsU("RightMargin").FormulaU = "1 pt"
    $s.CellsU("Width").FormulaU = "TEXTWIDTH(TheText)"
    $s.CellsU("Height").FormulaU = "TEXTHEIGHT(TheText,Width)"
}
function Jobs($pre) {
    $t = "Jobs"
    foreach ($d in "cpi", "gdp") { foreach ($j in "ingest", "apply settings", "fetch", "pipeline") {
        $t += "`n├── $pre$d - $j" } }
    $i = $t.LastIndexOf("├")
    $t.Substring(0, $i) + "└" + $t.Substring($i + 1)
}
function Catalog($pre) {
    "Unity Catalog`n${pre}cpi`n├── raw`n│   ├── inbox`n│   └── files`n├── bronze`n│   └── prices`n├── silver`n│   ├── prices_history`n│   └── prices`n└── sdp_meta`n    └── conf`n${pre}gdp`n├── raw`n├── bronze`n├── silver`n├── gold`n└── sdp_meta"
}

$white = "255,255,255"
$teal = "0,128,140";   $tealBg = "210,236,240"
$tan = "200,120,0";    $tanBg = "248,232,208"
$red = "170,20,40";    $redBg = "245,215,220"
$gray = "120,120,120"; $grayBg = "242,242,242"; $blue = "198,219,239"

$tt = $p.DrawRectangle(0.3, 9.6, 12.1, 10.2)
$tt.Text = "One repo, three workspaces"
$tt.CellsU("LinePattern").FormulaU = "0"; $tt.CellsU("FillPattern").FormulaU = "0"
$tt.CellsU("Char.Size").FormulaU = "28 pt"; $tt.CellsU("Char.Style").FormulaU = "1"
$tt.CellsU("Char.Color").FormulaU = "RGB(40,40,40)"
Panel 0.3 4.1 6.4 9.4 "dev" $tealBg $teal | Out-Null
Panel 6.75 4.1 9.35 9.4 "staging" $tanBg $tan | Out-Null
Panel 9.7 4.1 12.1 9.4 "prod" $redBg $red | Out-Null
Panel 0.3 0.3 12.1 3.7 "" $grayBg $gray | Out-Null
foreach ($t in @(,@(0.62, "GitHub Enterprise", "20 pt", "1"))) {
    $s = $p.DrawRectangle(0.45, $t[0] - 0.18, 3.6, $t[0] + 0.18)
    $s.Text = $t[1]
    $s.CellsU("LinePattern").FormulaU = "0"; $s.CellsU("FillPattern").FormulaU = "0"
    $s.CellsU("Para.HorzAlign").FormulaU = "0"; $s.CellsU("LeftMargin").FormulaU = "0"
    $s.CellsU("Char.Size").FormulaU = $t[2]; $s.CellsU("Char.Style").FormulaU = $t[3]
    $s.CellsU("Char.Color").FormulaU = "RGB($gray)"
}
Note 3.35 8.78 "many deploys, one per person`nsame bundle" $teal
Note 8.05 8.78 "one deploy`nruns as a designated deployer" $tan
Note 10.9 8.78 "one deploy`nruns as a service principal" $red

Tree 0.45 7.1 2.8 8.45 (Jobs "dev_jim_") $teal | Out-Null
$djim = Tree 0.45 4.45 2.8 7.0 (Catalog "dev_jim_") $teal
Tree 2.9 7.1 5.25 8.45 (Jobs "dev_sue_") $teal | Out-Null
$dsue = Tree 2.9 4.45 5.25 7.0 (Catalog "dev_sue_") $teal
$dmore = Box 5.8 6.45 "… more`ndeploys" $white $teal 0.9 4.0
$dmore.CellsU("LinePattern").FormulaU = "2"
Tree 6.9 7.1 9.2 8.45 (Jobs "staging_") $tan | Out-Null
$stg = Tree 6.9 4.45 9.2 7.0 (Catalog "staging_") $tan
Tree 9.85 7.1 11.95 8.45 (Jobs "") $red | Out-Null
$prd = Tree 9.85 4.45 11.95 7.0 (Catalog "") $red

$jim  = Box 1.625 3.25 "jim/add-table" $blue $gray 1.5 0.6
$sue  = Box 4.075 3.25 "sue/fix-rules" $blue $gray 1.5 0.6
$more = Box 5.8 3.25 "… more`nbranches" $blue $gray 0.9 0.6
$more.CellsU("LinePattern").FormulaU = "2"

# master as a short commit log, newest on top, with tag pills
$main = $p.DrawRectangle(3.3, 0.45, 7.825, 2.22)
$main.CellsU("FillForegnd").FormulaU = "RGB($blue)"
$main.CellsU("LineColor").FormulaU = "RGB($gray)"
function Line($y, $text, $size = "9 pt", $bold = "0") {
    $s = $p.DrawRectangle(3.4, $y - 0.08, 5.6, $y + 0.08)
    $s.Text = $text
    $s.CellsU("LinePattern").FormulaU = "0"; $s.CellsU("FillPattern").FormulaU = "0"
    $s.CellsU("Para.HorzAlign").FormulaU = "0"
    foreach ($m in "TopMargin", "BottomMargin", "LeftMargin", "RightMargin") { $s.CellsU($m).FormulaU = "0" }
    $s.CellsU("Char.Font").FormulaU = "FONT(`"$mono`")"
    $s.CellsU("Char.Size").FormulaU = $size; $s.CellsU("Char.Style").FormulaU = $bold
}
function Pill($x, $y, $text, $fill, $line, $textColor = "0,0,0") {
    $s = $p.DrawRectangle($x - 0.5, $y - 0.075, $x + 0.5, $y + 0.075)
    $s.Text = $text
    $s.CellsU("FillForegnd").FormulaU = "RGB($fill)"
    $s.CellsU("LineColor").FormulaU = "RGB($line)"
    $s.CellsU("Rounding").FormulaU = "0.07 in"
    foreach ($m in "TopMargin", "BottomMargin") { $s.CellsU($m).FormulaU = "0" }
    $s.CellsU("Char.Size").FormulaU = "9 pt"; $s.CellsU("Char.Style").FormulaU = "1"
    $s.CellsU("Char.Color").FormulaU = "RGB($textColor)"
    $s
}
Line 2.06 "master" "11 pt" "1"
$log = @(
    @("b72e19f  Add gdp to gold views", "staging_v0.04", ""),
    @("a41c7d2  Add gdp gold table", "", ""),
    @("3a9e0b2  Fix cpi rules", "staging_v0.03", "prod_v0.3"),
    @("7c2d1e4  Add gdp dataset", "", ""),
    @("e9f1b98  Rename cpi columns", "staging_v0.02", "prod_v0.2"),
    @("c09e5b1  Add prices to cpi", "", ""),
    @("5be1a7c  Add cpi fetch", "staging_v0.01", "prod_v0.1"),
    @("1b33b74  Pause dev fetch", "", ""),
    @("8f9ada1  Start the repo", "", ""))
$y = 1.88; $sTop = $true; $pTop = $true
foreach ($c in $log) {
    Line $y $c[0]
    if ($c[1]) { if ($sTop) { $tstg = Pill 6.15 $y $c[1] $tan $tan "255,255,255"; $sTop = $false }
                 else { Pill 6.15 $y $c[1] $tanBg $tan "150,150,150" | Out-Null } }
    if ($c[2]) { if ($pTop) { $tprd = Pill 7.25 $y $c[2] $red $red "255,255,255"; $pTop = $false }
                 else { Pill 7.25 $y $c[2] $redBg $red "150,150,150" | Out-Null } }
    $y -= 0.16
}

Arrow $jim $djim ""
Arrow $sue $dsue ""
Arrow $more $dmore ""
$p.Shapes.Item($p.Shapes.Count).CellsU("LinePattern").FormulaU = "9"
Arrow $main $jim "" $true
Arrow $main $sue "" $true
Tag 4.59 "branch / merge" 2.585 $grayBg
Tag 2.99 "branch / merge" 2.585 $grayBg
$l = $p.DrawLine(5.8, 2.22, 5.8, 2.95)
$l.CellsU("LineWeight").FormulaU = "2.25 pt"; $l.CellsU("LinePattern").FormulaU = "9"
$l.CellsU("BeginArrow").FormulaU = "4"; $l.CellsU("EndArrow").FormulaU = "4"
# right-angle arrows from each tag pill up into its panel
foreach ($t in @(@(6.65, 1.88, 8.05), @(7.75, 1.56, 10.9))) {
    $l = $p.DrawPolyline([double[]]($t[0], $t[1], $t[2], $t[1], $t[2], 4.45), 0)
    $l.CellsU("LineWeight").FormulaU = "2.25 pt"
    $l.CellsU("EndArrow").FormulaU = "4"
}

# who does what: role pill in the color of what they touch, then the actions
$hd = $p.DrawRectangle(8.75, 0.96, 11.95, 1.16)
$hd.Text = "Who does what"
$hd.CellsU("LinePattern").FormulaU = "0"; $hd.CellsU("FillPattern").FormulaU = "0"
$hd.CellsU("Para.HorzAlign").FormulaU = "0"; $hd.CellsU("LeftMargin").FormulaU = "0"
$hd.CellsU("Char.Size").FormulaU = "11 pt"; $hd.CellsU("Char.Style").FormulaU = "1"
$hd.CellsU("Char.Color").FormulaU = "RGB($gray)"
$ry = 0.82
foreach ($r in @(@("Everyone", $blue, $gray, "0,0,0", "dev: branch, merge, deploy"),
                 @("Lead", $tan, $tan, "255,255,255", "staging/prod: tag, deploy"))) {
    $pl = $p.DrawRectangle(8.75, $ry - 0.1, 9.55, $ry + 0.1)
    $pl.Text = $r[0]
    $pl.CellsU("FillForegnd").FormulaU = "RGB($($r[1]))"; $pl.CellsU("LineColor").FormulaU = "RGB($($r[2]))"
    $pl.CellsU("Rounding").FormulaU = "0.09 in"
    $pl.CellsU("TopMargin").FormulaU = "0"; $pl.CellsU("BottomMargin").FormulaU = "0"
    $pl.CellsU("Char.Size").FormulaU = "10 pt"; $pl.CellsU("Char.Style").FormulaU = "1"
    $pl.CellsU("Char.Color").FormulaU = "RGB($($r[3]))"
    $tx = $p.DrawRectangle(9.65, $ry - 0.1, 11.95, $ry + 0.1)
    $tx.Text = $r[4]
    $tx.CellsU("LinePattern").FormulaU = "0"; $tx.CellsU("FillPattern").FormulaU = "0"
    $tx.CellsU("Para.HorzAlign").FormulaU = "0"; $tx.CellsU("LeftMargin").FormulaU = "0"
    $tx.CellsU("TopMargin").FormulaU = "0"; $tx.CellsU("BottomMargin").FormulaU = "0"
    $tx.CellsU("Char.Size").FormulaU = "11 pt"
    $ch = $tx.Characters; $ch.Begin = 0; $ch.End = $r[4].IndexOf(":") + 1
    $ch.CharProps(2) = 1   # bold the part before the colon
    $ry -= 0.27
}

foreach ($x in 1.625, 4.075, 5.8, 8.05, 10.9) { Tag $x "deploy" }

$out = "$HOME\Downloads\team-workflow.vsdx"
$doc.SaveAs($out)
if ($args[0]) { $p.Export($args[0]) }   # optional preview PNG
$doc.Close(); $v.Quit()
Invoke-Item $out
