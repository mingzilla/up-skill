# up-skill__uninstall.ps1 - remove up-skill from this Windows machine.
# Removes (nothing else):
#   - global Claude Code skills:  %USERPROFILE%\.claude\skills\up-skill__*
#   - the workspace:              %USERPROFILE%\.up-skill__workspace
# usage: powershell -ExecutionPolicy Bypass -File up-skill__uninstall.ps1 -Yes
param([switch]$Yes)

$ErrorActionPreference = "Stop"

if (-not $Yes) {
  Write-Output "This will delete %USERPROFILE%\.claude\skills\up-skill__* and %USERPROFILE%\.up-skill__workspace"
  Write-Output "Re-run with -Yes to confirm. Your github repos and projects are never touched."
  exit 1
}

$gh = Join-Path $env:USERPROFILE ".claude\skills"
foreach ($n in @("upskill", "up-skill__sharing__provide-skills", "up-skill__sharing__receive-skills")) {
  $p = Join-Path $gh $n
  if (Test-Path $p) { Remove-Item -Recurse -Force $p }
}
Write-Output "removed global up-skill skills from $gh"

$ws = Join-Path $env:USERPROFILE ".up-skill__workspace"
if (Test-Path $ws) { Remove-Item -Recurse -Force $ws }
Write-Output "removed workspace $ws"

Write-Output "done. If you installed the Claude Desktop plugin, remove it in the app's plugin manager."
