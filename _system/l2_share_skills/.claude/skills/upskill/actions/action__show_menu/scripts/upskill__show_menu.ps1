# upskill__show_menu.ps1 - print the /upskill home screen (PowerShell mirror of upskill__show_menu.sh).
# Read-only. The upskill entry skill prints this output verbatim, then acts on the user's pick.
#
# usage: powershell -NoProfile -ExecutionPolicy Bypass -File upskill__show_menu.ps1
param()

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '../../../scripts/upskill__lib.ps1')

$start = $PWD.Path
if ($env:UP_SKILL_WORKSPACE) { $start = $env:UP_SKILL_WORKSPACE }
us_init -StartDir $start

$NAME_MAX = 17; $TOKEN_W = 14; $TEAM_W = 20; $PEOPLE_W = 2; $PER_ROW = 3
$rows = New-Object System.Collections.ArrayList

$base = Join-Path $script:US_WORKSPACE 'address_books'
if (Test-Path -LiteralPath $base -PathType Container) {
    foreach ($teamDir in @(Get-ChildItem -LiteralPath $base -Directory)) {
        $team = $teamDir.Name
        $ab = @(Get-ChildItem -LiteralPath $teamDir.FullName -Filter 'address_book.json' -Recurse -Depth 1 -ErrorAction SilentlyContinue)
        if ($ab.Count -eq 0) { continue }
        try { $users = ([System.IO.File]::ReadAllText($ab[0].FullName) | ConvertFrom-Json).users }
        catch { continue }
        $label = $team
        if ($label.StartsWith('team__')) { $label = $label.Substring('team__'.Length) }
        if ($label.Length -gt $NAME_MAX) { $label = $label.Substring(0, $NAME_MAX) }

        $tokens = New-Object System.Collections.ArrayList
        foreach ($p in $users.PSObject.Properties) {
            $name = $p.Name
            $m = $p.Value
            $folder = ''
            if ($null -ne $m -and $m.folder) { $folder = [string]$m.folder }
            $clone = ''
            if ($folder) { $clone = Join-Path $teamDir.FullName $folder }
            $count = 0
            $hasClone = $false
            if (Test-Path -LiteralPath $clone -PathType Container) {
                $hasClone = $true
                foreach ($d in @(Get-ChildItem -LiteralPath $clone -Directory -ErrorAction SilentlyContinue)) {
                    if (Test-Path -LiteralPath (Join-Path $d.FullName 'SKILL.md')) { $count++ }
                }
            }
            $token = if ($hasClone) { "$count`:$name" } else { $name }
            if ($token.Length -gt $TOKEN_W) { $token = $token.Substring(0, $TOKEN_W) }
            [void]$tokens.Add($token)
        }
        $cell = $label + (if ($team -eq $script:US_TEAM) { ' *' } else { '' })
        $isCur = if ($team -eq $script:US_TEAM) { 0 } else { 1 }
        [void]$rows.Add([pscustomobject]@{ Cur = $isCur; Alpha = $label.ToLower(); Cell = $cell; People = $users.PSObject.Properties.Count; Tokens = $tokens.ToArray() })
    }
}

Write-Output 'Your address book lists teammates for sharing skills. What would you like to do?'
Write-Output ''
Write-Output 'Address Books       NN  Members'
Write-Output ('-' * 70)
if ($rows.Count -eq 0) {
    Write-Output '(no address books installed - add one to get started)'
}
else {
    $rows = @($rows | Sort-Object Cur, Alpha)
    $cont = ' ' * ($TEAM_W + $PEOPLE_W + 2)
    foreach ($r in $rows) {
        $line = ('{0,-' + $TEAM_W + '}{1,' + $PEOPLE_W + '}  ') -f $r.Cell, $r.People
        $tokens = $r.Tokens
        $first = $true
        for ($i = 0; $i -lt $tokens.Count; $i += $PER_ROW) {
            $chunk = @($tokens[$i..([Math]::Min($i + $PER_ROW - 1, $tokens.Count - 1))])
            $seg = (($chunk | ForEach-Object { ('{0,-' + $TOKEN_W + '}') -f $_ }) -join ' ')
            if ($first) { Write-Output ($line + $seg); $first = $false }
            else { Write-Output ($cont + $seg) }
        }
        if ($first) { Write-Output $line.TrimEnd() }
    }
}

Write-Output ''
Write-Output 'What would you like to do?'
Write-Output '  1  Show a member''s skills          e.g. "show Andy''s skills"'
Write-Output '  2  Add a member''s skill            e.g. "add Andy''s say_hello skill"'
Write-Output '  3  Share your skill                e.g. "share my xxx skill"'
Write-Output ''
Write-Output 'To change address book, use option 4'
Write-Output '  4  Add or change address book      e.g. "add an address book"'
