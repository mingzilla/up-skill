# upskill__uninstall.ps1 - remove upskill from this Windows machine.
# Removes (nothing else):
#   - global Claude Code skills:  %USERPROFILE%\.claude\skills\upskill__*
#   - the workspace:              %USERPROFILE%\.upskill__workspace
# usage: powershell -ExecutionPolicy Bypass -File upskill__uninstall.ps1 -Yes
param([switch]$Yes)

$ErrorActionPreference = "Stop"

if (-not $Yes) {
  Write-Output "This will delete %USERPROFILE%\.claude\skills\upskill__* and %USERPROFILE%\.upskill__workspace"
  Write-Output "Re-run with -Yes to confirm. Your github repos and projects are never touched."
  exit 1
}

$gh = Join-Path $env:USERPROFILE ".claude\skills"
foreach ($n in @("upskill", "upskill__action__provide-skills", "upskill__action__receive-skills")) {
  $p = Join-Path $gh $n
  if (Test-Path $p) { Remove-Item -Recurse -Force $p }
}
Write-Output "removed global upskill skills from $gh"

$ws = Join-Path $env:USERPROFILE ".upskill__workspace"
if (Test-Path $ws) { Remove-Item -Recurse -Force $ws }
Write-Output "removed workspace $ws"

Write-Output "done. If you installed the Claude Desktop plugin, remove it in the app's plugin manager."
