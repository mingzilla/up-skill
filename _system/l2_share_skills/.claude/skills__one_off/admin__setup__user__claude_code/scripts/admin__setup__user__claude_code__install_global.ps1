# admin__setup__user__claude_code__install_global.ps1 - install upskill as GLOBAL (personal)
# Claude Code skills, so provide/receive are available in every local session - not per project.
# PowerShell equivalent of admin__setup__user__claude_code__install_global.sh.
#
# The workspace stays at ~/.upskill__workspace; the skills resolve it by default.
# Source skills are copied from this repo's l2 bundle
# (_system/l2_share_skills/.claude/skills). Run after the workspace exists; re-run to refresh.
param()

$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    [Console]::Error.WriteLine('error: git is required')
    exit 1
}

# this script lives inside the upskill repo
$repoRoot = (& git rev-parse --show-toplevel).Trim()
if ($LASTEXITCODE -ne 0 -or -not $repoRoot) {
    [Console]::Error.WriteLine('error: this script must run inside the upskill repo (git rev-parse --show-toplevel failed)')
    exit 1
}
$src = Join-Path $repoRoot '_system/l2_share_skills/.claude/skills'

foreach ($s in @('upskill', 'upskill__sharing__provide-skills', 'upskill__sharing__receive-skills')) {
    if (-not (Test-Path -LiteralPath (Join-Path $src $s))) {
        [Console]::Error.WriteLine("error: source skill missing: $src/$s")
        exit 1
    }
}

$homeSkills = Join-Path $HOME '.claude/skills'
New-Item -ItemType Directory -Force -Path $homeSkills | Out-Null

foreach ($s in @('upskill', 'upskill__sharing__provide-skills', 'upskill__sharing__receive-skills')) {
    $gdir = Join-Path $homeSkills $s
    if (Test-Path -LiteralPath $gdir) { Remove-Item -LiteralPath $gdir -Recurse -Force }
    Copy-Item -LiteralPath (Join-Path $src $s) -Destination $gdir -Recurse -Force
}

Write-Output "installed global upskill skills into: $homeSkills"
Write-Output "workspace expected at: $HOME\.upskill__workspace"
Write-Output 'start a new Claude Code session, then say: use upskill to share / get / list skills'
