# up-skill__install.ps1 - build a machine's .up-skill__workspace and install up-skill globally.
# Windows mirror of up-skill__install.sh. Workspace default: <Home>\.up-skill__workspace
# Global skills go to:  %USERPROFILE%\.claude\skills
#
# usage:
#   powershell -ExecutionPolicy Bypass -File up-skill__install.ps1 -User myles
#   or (one-line): powershell -c "irm https://raw.githubusercontent.com/mingzilla/up-skill/main/up-skill__install.ps1 | iex"
param(
  [string]$User,
  [string]$Dir,
  [string]$AddressBook = "https://github.com/mingzilla/up-skill__address_book__sandbox.git",
  [string]$Core = "https://github.com/mingzilla/up-skill.git",
  [string]$Branch = "prod",
  [switch]$SkipGlobal
)

$ErrorActionPreference = "Stop"

if (-not $Dir) { $Dir = $env:USERPROFILE }
if (-not $User) {
  if ([Console]::IsInputRedirected) { throw "error: -User is required" }
  $User = Read-Host "Your up-skill user name (as in the team address book)"
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "error: git is required" }

function Invoke-Git {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)
  & git @GitArgs
  if ($LASTEXITCODE -ne 0) { throw "git failed: git $GitArgs" }
}

$ws = Join-Path $Dir ".up-skill__workspace"

Write-Output "== up-skill install for '$User' =="
Write-Output "workspace: $ws"

# always rebuild the whole workspace
if (Test-Path $ws) { Remove-Item -Recurse -Force $ws }
New-Item -ItemType Directory -Force -Path $ws | Out-Null

# team dir from address book basename: up-skill__address_book__<team> -> team__<team>
$abBase = [System.IO.Path]::GetFileNameWithoutExtension(($AddressBook.TrimEnd('/')))
if ($abBase -like "up-skill__address_book__*") { $team = "team__" + $abBase.Substring("up-skill__address_book__".Length) }
else { $team = $abBase }
$abDir = Join-Path $ws ("address_books\" + $team + "\" + $abBase)
New-Item -ItemType Directory -Force -Path (Split-Path $abDir) | Out-Null

Write-Output "-- address book ($team)"
Invoke-Git clone --quiet $AddressBook $abDir

$abJson = Join-Path $abDir "address_book.json"
if (-not (Test-Path $abJson)) { throw "error: no address_book.json in $abDir" }
$users = (Get-Content -Raw $abJson | ConvertFrom-Json).users

Write-Output "-- member skills repos"
foreach ($prop in $users.PSObject.Properties) {
  $folder = $prop.Value.folder
  $repo   = $prop.Value.repo
  if (-not $folder -or -not $repo) { continue }
  $memberDir = Join-Path $ws ("address_books\" + $team + "\" + $folder)
  Invoke-Git clone --quiet $repo $memberDir
}

Write-Output "-- placing the up-skill repo ($Branch)"
$heads = & git ls-remote --heads $Core $Branch 2>$null
if ($LASTEXITCODE -ne 0 -or -not $heads) { throw "error: branch '$Branch' not found in up-skill repo $Core" }
$coreDir = Join-Path $ws "up-skill"
Invoke-Git clone --quiet -b $Branch $Core $coreDir

$gskills = Join-Path $coreDir "_system\l2_share_skills\.claude\skills"
$names = @("upskill", "up-skill__sharing__provide-skills", "up-skill__sharing__receive-skills")
foreach ($n in $names) {
  if (-not (Test-Path (Join-Path $gskills $n))) { throw "error: skill missing at $gskills\$n" }
}

if (-not $SkipGlobal) {
  $gh = Join-Path $env:USERPROFILE ".claude\skills"
  New-Item -ItemType Directory -Force -Path $gh | Out-Null
  foreach ($n in $names) {
    $dst = Join-Path $gh $n
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse (Join-Path $gskills $n) $dst
  }
  Write-Output "global skills installed at $gh (every Claude Code session)"
}

# config
$config = Join-Path $ws "up-skill__user-config.json"
@{ user = $User; team = $team; address_book = ".\address_books\$team\$abBase" } |
  ConvertTo-Json | Set-Content -Path $config -Encoding UTF8
Write-Output "config written to $config"

Write-Output ""
Write-Output "== done =="
Write-Output "open Claude in: $ws"
Write-Output "then say: up-skill"
