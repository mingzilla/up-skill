# up-skill__sharing__add.ps1 - copy a teammate's shared skill into a target project.
# PowerShell equivalent of up-skill__sharing__add.sh.
# usage: up-skill__sharing__add.ps1 <owner> <skill-name> <target-project-dir>
param(
    [string]$Owner = '',
    [string]$Skill = '',
    [string]$Target = ''
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'up-skill__sharing__lib.ps1')

$start = $PWD.Path
if ($env:UP_SKILL_WORKSPACE) { $start = $env:UP_SKILL_WORKSPACE }
us_init -StartDir $start

if ([string]::IsNullOrWhiteSpace($Owner) -or [string]::IsNullOrWhiteSpace($Skill) -or [string]::IsNullOrWhiteSpace($Target)) {
    us_err 'usage: up-skill__sharing__add.ps1 <owner> <skill-name> <target-project-dir>'
    us_err '  e.g. up-skill__sharing__add.ps1 myles text-cleaner C:\work\site'
    exit 1
}
if (-not (us_safe_name $Skill)) { exit 1 }

$folder = us_folder_of $Owner
if ([string]::IsNullOrWhiteSpace($folder)) {
    us_err "error: '$Owner' is not in the address book"
    exit 1
}
$clone = Join-Path $script:US_TEAM_DIR $folder
if (-not (Test-Path -LiteralPath (Join-Path $clone '.git'))) {
    us_err "error: no local clone for '$Owner' at $clone (run the installer first)"
    exit 1
}

# refresh the owner's clone when it is not me (best effort - an empty repo has no HEAD yet)
if ($folder -ne $script:US_ME_FOLDER) {
    & git -C $clone pull --ff-only --quiet 2>$null
    if ($LASTEXITCODE -ne 0) {
        us_err "note: could not pull '$Owner' - reading the local clone as-is"
    }
}

$srcskill = Join-Path $clone $Skill
if (-not (Test-Path -LiteralPath (Join-Path $srcskill 'SKILL.md'))) {
    us_err "error: '$Owner' has no shared skill '$Skill'. Available from $Owner:"
    foreach ($s in @(us_skill_names $clone)) { us_err ('  ' + $s) }
    exit 1
}

$dest = Join-Path $Target (Join-Path '.claude/skills' $Skill)
if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
Copy-Item -LiteralPath $srcskill -Destination $dest -Recurse -Force

Write-Output "added '$Skill' (from $Owner) to $dest"
Write-Output '  open Claude in the target and the skill will be available.'
