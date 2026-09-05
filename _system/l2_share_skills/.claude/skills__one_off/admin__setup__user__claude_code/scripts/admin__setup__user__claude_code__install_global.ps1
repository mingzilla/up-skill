# admin__setup__user__claude_code__install_global.ps1 - install upskill as GLOBAL (personal)
# Claude Code skill. PowerShell mirror of admin__setup__user__claude_code__install_global.sh.
# usage: powershell -ExecutionPolicy Bypass -File admin__setup__user__claude_code__install_global.ps1
param()

$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    [Console]::Error.WriteLine('error: git is required')
    exit 1
}

$repoRoot = (& git rev-parse --show-toplevel).Trim()
if ($LASTEXITCODE -ne 0 -or -not $repoRoot) {
    [Console]::Error.WriteLine('error: this script must run inside the upskill repo (git rev-parse --show-toplevel failed)')
    exit 1
}
$src = Join-Path $repoRoot '_system/l2_share_skills/.claude/skills/upskill'
if (-not (Test-Path -LiteralPath (Join-Path $src 'SKILL.md'))) {
    [Console]::Error.WriteLine("error: source skill missing: $src")
    exit 1
}

$gh = Join-Path $HOME '.claude/skills'
New-Item -ItemType Directory -Force -Path $gh | Out-Null
function Remove-SkillDir {
    param([string]$Dir)
    if (-not $Dir.StartsWith((Join-Path $HOME '.claude/skills') + [IO.Path]::DirectorySeparatorChar)) {
        [Console]::Error.WriteLine("refusing to delete outside global skills dir: $Dir")
        return $false
    }
    if (-not (Test-Path -LiteralPath $Dir)) { return $true }
    if (-not (Test-Path -LiteralPath (Join-Path $Dir 'SKILL.md')) -or -not (Split-Path -Leaf $Dir).StartsWith('upskill')) {
        [Console]::Error.WriteLine("refusing to delete (not an upskill skill): $Dir")
        return $false
    }
    Remove-Item -LiteralPath $Dir -Recurse -Force
    return $true
}
foreach ($s in @('upskill__sharing__provide-skills', 'upskill__sharing__receive-skills', 'upskill__action__provide-skills', 'upskill__action__receive-skills')) {
    if (-not (Remove-SkillDir (Join-Path $gh $s))) { exit 1 }
}
$dst = Join-Path $gh 'upskill'
if (-not (Remove-SkillDir $dst)) { exit 1 }
Copy-Item -LiteralPath $src -Destination $dst -Recurse -Force

Write-Output "installed global upskill skill into: $dst"
Write-Output "workspace expected at: $HOME\.upskill__workspace"
Write-Output 'start a new Claude Code session, then say: use upskill to share / get / list skills'
