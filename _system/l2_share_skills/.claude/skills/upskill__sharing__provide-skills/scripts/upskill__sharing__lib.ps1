# upskill__sharing__lib.ps1 - shared helpers for the upskill client scripts (PowerShell).
# Dot-sourced (never run): `. <path>/upskill__sharing__lib.ps1`, then call `us_init`.
#
# Resolves the .upskill__workspace (nearest ancestor holding upskill__user-config.json,
# or $env:UP_SKILL_WORKSPACE) and loads the user config + team address book into US_* variables.
#
# PowerShell equivalent of upskill__sharing__lib.sh. No python needed here: JSON is read with
# the built-in .NET/JSON support, so the ps1 path only requires git.

$ErrorActionPreference = 'Stop'

# US_* state lives in the script scope of whichever command script dot-sources this file.
$script:US_WORKSPACE = ''       # root of this machine's upskill__workspace
$script:US_USER = ''            # this member's name (matches the address book)
$script:US_TEAM = ''            # e.g. team__sandbox
$script:US_ADDRESS_BOOK = ''    # dir of the cloned address-book repo
$script:US_AB_JSON = ''         # path to address_book.json
$script:US_TEAM_DIR = ''        # dir holding the address book + every member's sharing clone
$script:US_ME_FOLDER = ''       # my skills-repo clone folder name, e.g. upskill__skills_repo__leah
$script:US_ME_DIR = ''          # absolute path of my sharing clone

# us_err <message> - write a line to stderr (mirrors bash `>&2`).
function us_err {
    param([string]$Message)
    [Console]::Error.WriteLine($Message)
}

# us_exit <message> <code> - print an error to stderr and exit.
function us_exit {
    param([string]$Message, [int]$Code = 1)
    us_err $Message
    exit $Code
}

# us_require <tool> - abort when a required tool is not on PATH.
function us_require {
    param([string]$Tool)
    if (-not (Get-Command $Tool -ErrorAction SilentlyContinue)) {
        us_exit "error: required tool not found: $Tool"
    }
}

# Read-UpSkillJson <path> - parse a JSON file (.NET auto-detects the encoding/BOM).
function Read-UpSkillJson {
    param([string]$Path)
    return [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json
}

# us_locate_workspace <start-dir> - nearest ancestor holding upskill__user-config.json; $null if none.
function us_locate_workspace {
    param([string]$Dir)
    $d = $Dir
    if (-not (Test-Path -LiteralPath $d -PathType Container)) { $d = Split-Path -Parent $d }
    while ($d) {
        if (Test-Path -LiteralPath (Join-Path $d 'upskill__user-config.json')) { return $d }
        $parent = Split-Path -Parent $d
        if (-not $parent -or $parent -eq $d) { break }   # drive root reached
        $d = $parent
    }
    return $null
}

# us_load_config - fill the US_* variables from upskill__user-config.json; $true on success.
function us_load_config {
    $cfgPath = Join-Path $script:US_WORKSPACE 'upskill__user-config.json'
    if (-not (Test-Path -LiteralPath $cfgPath)) { return $false }
    $cfg = Read-UpSkillJson $cfgPath
    $script:US_USER = [string]$cfg.user
    if ($null -ne $cfg.team) { $script:US_TEAM = [string]$cfg.team } else { $script:US_TEAM = '' }
    $script:US_ADDRESS_BOOK = Join-Path $script:US_WORKSPACE ([string]$cfg.address_book)
    $script:US_AB_JSON = Join-Path $script:US_ADDRESS_BOOK 'address_book.json'
    $script:US_TEAM_DIR = Split-Path -Parent $script:US_ADDRESS_BOOK
    return $true
}

# us_members - return address-book rows as "name<TAB>folder<TAB>repo" strings.
function us_members {
    $ab = Read-UpSkillJson $script:US_AB_JSON
    $rows = @()
    if ($ab.users) {
        foreach ($p in $ab.users.PSObject.Properties) {
            $rows += [string]::Join("`t", @($p.Name, $p.Value.folder, $p.Value.repo))
        }
    }
    return $rows
}

# us_folder_of <member-name> - that member's sharing-clone folder name; '' when absent.
function us_folder_of {
    param([string]$Member)
    $ab = Read-UpSkillJson $script:US_AB_JSON
    if ($ab.users) {
        $prop = $ab.users.PSObject.Properties | Where-Object { $_.Name -eq $Member }
        if ($prop) { return [string]$prop.Value.folder }
    }
    return ''
}

# us_skill_names <sharing-clone-dir> - immediate child names that contain SKILL.md.
function us_skill_names {
    param([string]$Root)
    $names = @()
    if (Test-Path -LiteralPath $Root -PathType Container) {
        foreach ($d in @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue)) {
            if (Test-Path -LiteralPath (Join-Path $d.FullName 'SKILL.md')) { $names += $d.Name }
        }
    }
    return $names
}

# us_safe_name <name> - reject empty / pathy / dot-dot names before they reach a filesystem path.
function us_safe_name {
    param([string]$Name)
    if ([string]::IsNullOrWhiteSpace($Name) -or $Name.Contains('/') -or $Name.Contains('\') -or $Name.Contains('..')) {
        us_err "error: not a valid name: '$Name'"
        return $false
    }
    return $true
}

# us_init [start-dir] - resolve the workspace, load config, validate address book + membership.
function us_init {
    param([string]$StartDir = $PWD.Path)
    us_require 'git'
    if ($env:UP_SKILL_WORKSPACE -and (Test-Path -LiteralPath $env:UP_SKILL_WORKSPACE -PathType Container)) {
        $script:US_WORKSPACE = $env:UP_SKILL_WORKSPACE
    }
    else {
        $found = us_locate_workspace $StartDir
        if ($found) {
            $script:US_WORKSPACE = $found
        }
        elseif (Test-Path -LiteralPath (Join-Path $HOME '.upskill__workspace') -PathType Container) {
            $script:US_WORKSPACE = Join-Path $HOME '.upskill__workspace'   # global default under the user profile
        }
        else {
            us_exit "error: no .upskill__workspace found from '$StartDir' (looked upward for upskill__user-config.json)`n  run inside your .upskill__workspace, or set UP_SKILL_WORKSPACE=<path>"
        }
    }
    if (-not (us_load_config)) { us_exit "error: cannot read config in $script:US_WORKSPACE" }
    if (-not (Test-Path -LiteralPath $script:US_AB_JSON)) {
        us_exit "error: address book not found at $script:US_AB_JSON (run the installer first)"
    }
    $script:US_ME_FOLDER = us_folder_of $script:US_USER
    if ([string]::IsNullOrWhiteSpace($script:US_ME_FOLDER)) {
        us_exit "error: '$script:US_USER' is not in the address book ($script:US_AB_JSON)"
    }
    $script:US_ME_DIR = Join-Path $script:US_TEAM_DIR $script:US_ME_FOLDER

    # self-update: pull the workspace solution (prod) and refresh the global skills - quiet, best-effort
    us_self_update
}

# us_self_update - the user never reruns the installer; on use, pull prod + refresh ~/.claude/skills.
function us_self_update {
    $sol = Join-Path $script:US_WORKSPACE 'upskill'
    if (-not (Test-Path -LiteralPath (Join-Path $sol '.git'))) { return }
    & git -C $sol pull --ff-only --quiet 2>$null
    $src = Join-Path $sol '_system/l2_share_skills/.claude/skills'
    if (-not (Test-Path -LiteralPath (Join-Path $src 'upskill__sharing__receive-skills'))) { return }
    $gh = Join-Path $HOME '.claude/skills'
    New-Item -ItemType Directory -Force -Path $gh | Out-Null
    foreach ($s in @('upskill', 'upskill__sharing__provide-skills', 'upskill__sharing__receive-skills')) {
        $sdir = Join-Path $src $s
        if (-not (Test-Path -LiteralPath $sdir)) { continue }
        $gdir = Join-Path $gh $s
        if (Test-Path -LiteralPath $gdir) { Remove-Item -LiteralPath $gdir -Recurse -Force }
        Copy-Item -LiteralPath $sdir -Destination $gdir -Recurse -Force
    }
}
