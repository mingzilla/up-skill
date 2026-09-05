# upskill__add.ps1 - copy a member's shared skill to a target: global, the current project, or a
# selected project. PowerShell mirror of upskill__add.sh.
# usage:
#   upskill__add.ps1 <owner> <skill> -Project global      -> ~/.claude/skills
#   upskill__add.ps1 <owner> <skill> -Project current     -> this project's .claude/skills
#   upskill__add.ps1 <owner> <skill> -Project <path>      -> that project's .claude/skills
param(
    [string]$Owner = '',
    [string]$Skill = '',
    [string]$Project = ''
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '../../../scripts/upskill__lib.ps1')

$start = $PWD.Path
if ($env:UP_SKILL_WORKSPACE) { $start = $env:UP_SKILL_WORKSPACE }
us_init -StartDir $start

if ([string]::IsNullOrWhiteSpace($Owner) -or [string]::IsNullOrWhiteSpace($Skill)) {
    [Console]::Error.WriteLine('usage: upskill__add.ps1 <owner> <skill> -Project <global|current|<path>>')
    exit 1
}
if (-not (us_safe_name $Skill)) { exit 1 }

if ([string]::IsNullOrWhiteSpace($Project)) {
    [Console]::Error.WriteLine("error: no target given - ask the user: add '$Skill' to global, the current project, or a path?")
    [Console]::Error.WriteLine("  then call again with: upskill__add.ps1 $Owner $Skill -Project <global|current|<path>>")
    exit 1
}

switch ($Project) {
    'global'  { $destRoot = Join-Path $HOME '.claude\skills' }
    'current' { $destRoot = Join-Path $PWD.Path '.claude\skills' }
    default {
        if (-not (Test-Path -LiteralPath $Project -PathType Container)) {
            [Console]::Error.WriteLine("error: target project not found: $Project")
            exit 1
        }
        $destRoot = Join-Path $Project '.claude\skills'
    }
}

$folder = us_folder_of $Owner
if ([string]::IsNullOrWhiteSpace($folder)) {
    [Console]::Error.WriteLine("error: '$Owner' is not in the address book")
    exit 1
}
$clone = Join-Path $script:US_TEAM_DIR $folder
if (-not (Test-Path -LiteralPath (Join-Path $clone '.git'))) {
    [Console]::Error.WriteLine("error: no local clone for '$Owner' at $clone (run the installer first)")
    exit 1
}
if ($folder -ne $script:US_ME_FOLDER) {
    & git -C $clone pull --ff-only --quiet 2>$null
    if ($LASTEXITCODE -ne 0) {
        [Console]::Error.WriteLine("note: could not pull '$Owner' - reading the local clone as-is")
    }
}

$srcskill = Join-Path $clone $Skill
if (-not (Test-Path -LiteralPath (Join-Path $srcskill 'SKILL.md'))) {
    [Console]::Error.WriteLine("error: '$Owner' has no shared skill '$Skill'. Available from $Owner:")
    foreach ($s in @(us_skill_names $clone)) { [Console]::Error.WriteLine('  ' + $s) }
    exit 1
}

$dest = Join-Path $destRoot $Skill
if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
Copy-Item -LiteralPath $srcskill -Destination $dest -Recurse -Force

Write-Output "added '$Skill' (from $Owner) to $dest"
switch ($Project) {
    'global'  { Write-Output '  it is now available in every Claude session.' }
    'current' { Write-Output "  open Claude in '$($PWD.Path)' and the skill will be available." }
    default   { Write-Output "  open Claude in '$Project' and the skill will be available." }
}
