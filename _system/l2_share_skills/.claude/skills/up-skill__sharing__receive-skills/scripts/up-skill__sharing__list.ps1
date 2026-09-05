# up-skill__sharing__list.ps1 - list the skills each team member has shared (read-only).
# PowerShell equivalent of up-skill__sharing__list.sh.
param()

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'up-skill__sharing__lib.ps1')

$start = $PWD.Path
if ($env:UP_SKILL_WORKSPACE) { $start = $env:UP_SKILL_WORKSPACE }
us_init -StartDir $start

Write-Output ("Skills shared in team '{0}':" -f $script:US_TEAM)
$any = 0
foreach ($row in @(us_members)) {
    $cols = $row -split "`t"
    if ($cols.Count -lt 2) { continue }
    $name = $cols[0]
    $folder = $cols[1]
    if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($folder)) { continue }
    $clone = Join-Path $script:US_TEAM_DIR $folder
    # refresh so the list is current (an empty clone has no HEAD yet - ignore failures)
    if (Test-Path -LiteralPath (Join-Path $clone '.git')) {
        & git -C $clone pull --ff-only --quiet 2>$null
    }
    $skills = @(us_skill_names $clone)
    if ($skills.Count -gt 0) {
        Write-Output ('  {0}:' -f $name)
        foreach ($s in $skills) {
            Write-Output ('    {0}' -f $s)
        }
        $any = 1
    }
}
if ($any -eq 0) {
    Write-Output '  (no skills shared yet)'
}
