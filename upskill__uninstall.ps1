# upskill__uninstall.ps1 - remove upskill from this Windows machine.
# Removes (nothing else):
#   - global Claude Code skill:   %USERPROFILE%\.claude\skills\upskill (+ any legacy upskill__*)
#   - the workspace:              %USERPROFILE%\.upskill__workspace
# usage: powershell -ExecutionPolicy Bypass -File upskill__uninstall.ps1 -Yes
param([switch]$Yes)

$ErrorActionPreference = "Stop"

if (-not $Yes) {
  Write-Output "This will delete %USERPROFILE%\.claude\skills\upskill and %USERPROFILE%\.upskill__workspace"
  Write-Output "Re-run with -Yes to confirm. Your github repos and projects are never touched."
  exit 1
}

$gh = Join-Path $env:USERPROFILE ".claude\skills"
function Remove-SkillDir {
  param([string]$Dir)
  if (-not $Dir.StartsWith((Join-Path $env:USERPROFILE ".claude\skills") + '\')) {
    [Console]::Error.WriteLine("refusing to delete outside global skills dir: $Dir")
    exit 1
  }
  if (-not (Test-Path $Dir)) { return }
  if (-not (Test-Path (Join-Path $Dir "SKILL.md")) -or -not (Split-Path -Leaf $Dir).StartsWith("upskill")) {
    [Console]::Error.WriteLine("refusing to delete (not an upskill skill): $Dir")
    exit 1
  }
  Remove-Item -Recurse -Force $Dir
}
foreach ($n in @("upskill", "upskill__sharing__provide-skills", "upskill__sharing__receive-skills", "upskill__action__provide-skills", "upskill__action__receive-skills")) {
  Remove-SkillDir (Join-Path $gh $n)
}
Write-Output "removed global upskill skills from $gh"

$ws = Join-Path $env:USERPROFILE ".upskill__workspace"
if (Test-Path $ws) { Remove-Item -Recurse -Force $ws }
Write-Output "removed workspace $ws"

Write-Output "done."
