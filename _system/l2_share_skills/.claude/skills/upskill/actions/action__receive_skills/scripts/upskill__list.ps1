# upskill__list.ps1 - show shared skills (PowerShell mirror of upskill__list.sh).
#   no owner  -> every member and their skills
#   <owner>   -> one member's skills, numbered 1..n (so the user can say "Add <n> to <target>")
param([string]$Owner = '')

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '../../../scripts/upskill__lib.ps1')

$start = $PWD.Path
if ($env:UP_SKILL_WORKSPACE) { $start = $env:UP_SKILL_WORKSPACE }
us_init -StartDir $start

if ([string]::IsNullOrWhiteSpace($Owner)) {
    Write-Output "Skills shared in team '$script:US_TEAM':"
    $any = 0
    foreach ($row in @(us_members)) {
        $cols = $row -split "`t"
        if ($cols.Count -lt 2) { continue }
        $name = $cols[0]; $folder = $cols[1]
        if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($folder)) { continue }
        $clone = Join-Path $script:US_TEAM_DIR $folder
        if (Test-Path -LiteralPath (Join-Path $clone '.git')) { & git -C $clone pull --ff-only --quiet 2>$null }
        $skills = @(us_skill_names $clone)
        if ($skills.Count -gt 0) {
            Write-Output ('  {0}:' -f $name)
            foreach ($s in $skills) { Write-Output ('    {0}' -f $s) }
            $any = 1
        }
    }
    if ($any -eq 0) { Write-Output '  (no skills shared yet)' }
    exit 0
}

$folder = us_folder_of $Owner
if ([string]::IsNullOrWhiteSpace($folder)) {
    [Console]::Error.WriteLine("error: '$Owner' is not in the address book")
    exit 1
}
$clone = Join-Path $script:US_TEAM_DIR $folder
if (Test-Path -LiteralPath (Join-Path $clone '.git')) { & git -C $clone pull --ff-only --quiet 2>$null }

$skills = @(us_skill_names $clone)
if ($skills.Count -eq 0) {
    Write-Output "($Owner has no skills shared yet)"
    exit 0
}

Write-Output "$Owner's skills:"
$n = 0
foreach ($s in $skills) {
    $n++
    Write-Output ('{0,3}  {1}' -f $n, $s)
}
Write-Output ''
Write-Output 'say:  Add <number> to <target>    e.g. "Add 1 to my website project"'
