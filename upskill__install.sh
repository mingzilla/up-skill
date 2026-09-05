#!/usr/bin/env bash
# upskill__install.sh - build a machine's .upskill__workspace from scratch.
#
# ALWAYS deletes and recreates the whole workspace, so a run never leaves stale or partial
# state behind. The workspace holds: the upskill repo (at --branch, default prod), the team
# address book + every member's skills repo, the sharing skills (copied from the repo), config.
# After install the user only talks to Claude.
#
# usage: upskill__install.sh [--user <name>] [options]
#   --user <name>         member name (must be in the address book); prompted if omitted
#   --home <dir>          parent of the workspace; workspace = <home>/.upskill__workspace
#                         (default: $HOME - prompted interactively if on a terminal)
#   --address-book <url|path>   address book repo (default: sandbox team)
#   --core <url|path>     the upskill project repo (cloned into <ws>/upskill)
#                         (default: this repo when run from a clone; else https github)
#   --branch <name>       which branch of the upskill repo the workspace takes (default: prod)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"   # $0 when run as `curl | bash`

# core = this repo when it ships the sharing skills (a clone has them right here); else fetch github
DEFAULT_ADDRESS_BOOK="https://github.com/mingzilla/upskill__address_book__sandbox.git"
if [[ -d "$SCRIPT_DIR/_system/l2_share_skills/.claude/skills/upskill__sharing__receive-skills" ]]; then
  DEFAULT_CORE="$SCRIPT_DIR"
else
  DEFAULT_CORE="https://github.com/mingzilla/upskill.git"
fi

user=""
home=""
address_book="$DEFAULT_ADDRESS_BOOK"
core="$DEFAULT_CORE"
branch="prod"
install_global=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) user="${2:-}"; shift 2 ;;
    --home) home="${2:-}"; shift 2 ;;
    --address-book) address_book="${2:-}"; shift 2 ;;
    --core) core="${2:-}"; shift 2 ;;
    --branch) branch="${2:-}"; shift 2 ;;
    --skip-global) install_global=0; shift ;;
    *) echo "error: unknown option: $1" >&2; exit 1 ;;
  esac
done

command -v python3 >/dev/null 2>&1 || { echo "error: python3 is required" >&2; exit 1; }
command -v git    >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }

# prompt_default <question> <default> - non-interactive runs just use the default.
# When run as `curl ... | bash`, stdin is the script - so prompts read from /dev/tty.
prompt_default() {
  local question="$1" default="$2" answer=""
  if [[ -t 0 && -t 1 ]]; then
    read -r -p "$question [$default]: " answer
  elif [[ -e /dev/tty && -r /dev/tty && -w /dev/tty ]]; then
    read -r -p "$question [$default]: " answer < /dev/tty
  fi
  echo "${answer:-$default}"
}

if [[ -z "$user" ]]; then
  user="$(prompt_default "Your upskill user name (as in the team address book)" "${UP_SKILL_USER:-}")"
fi
[[ -n "$user" ]] || { echo "error: --user <name> is required (or set UP_SKILL_USER)" >&2; exit 1; }

if [[ -z "$home" ]]; then
  home="$(prompt_default "Where should the upskill workspace live? (a hidden .upskill__workspace folder)" "$HOME")"
fi
ws="$home/.upskill__workspace"

# team dir from address book repo basename: upskill__address_book__<team> -> team__<team>
team_dir_for() {
  local base
  base="$(basename "${1%%/}")"
  base="${base%.git}"
  case "$base" in
    upskill__address_book__*) echo "team__${base#upskill__address_book__}" ;;
    *) echo "$base" ;;
  esac
}

# clone <dir> <url-or-local-path> <label> - fresh clone into a dir that does not exist yet
clone() {
  local dir="$1" src="$2" label="$3"
  echo "  clone $label"
  git clone --quiet "$src" "$dir"
}

echo "== upskill install for '$user' =="
echo "workspace: $ws"

# always rebuild the whole workspace - never refresh, so no stale leftovers
[[ "$(basename "$ws")" == ".upskill__workspace" ]] || { echo "error: refusing to rebuild $ws" >&2; exit 1; }
echo "rebuilding (deletes $ws)"
rm -rf "$ws"
mkdir -p "$ws"

# 1. address book
ab_basename="$(basename "${address_book%%/}")"; ab_basename="${ab_basename%.git}"
team="$(team_dir_for "$address_book")"
ab_dir="$ws/address_books/$team/$ab_basename"
mkdir -p "$ws/address_books/$team"
echo "-- address book ($team): $address_book"
clone "$ab_dir" "$address_book" "address book"

ab_json="$ab_dir/address_book.json"
[[ -f "$ab_json" ]] || { echo "error: no address_book.json in $ab_dir" >&2; exit 1; }

# 2. every member's skills repo (address book is the definition)
echo "-- member skills repos:"
while IFS=$'\t' read -r m_name m_folder m_repo; do
  [[ -n "$m_folder" && -n "$m_repo" ]] || continue
  member_dir="$ws/address_books/$team/$m_folder"
  clone "$member_dir" "$m_repo" "skills repo of $m_name"
done < <(python3 -c 'import json,sys
ab = json.load(open(sys.argv[1]))
for n, m in ab.get("users", {}).items():
    print(n + "\t" + m.get("folder", "") + "\t" + m.get("repo", ""))' "$ab_json")

# 3. the upskill repo into the workspace (data anchor - its skills feed the global install)
echo "-- placing the upskill repo ($branch):"
if ! git ls-remote --heads "$core" "$branch" 2>/dev/null | grep -q .; then
  echo "error: branch '$branch' not found in upskill repo $core" >&2
  echo "  create it (e.g. git push origin main:prod) or pass --branch <existing>" >&2
  exit 1
fi
git clone --quiet -b "$branch" "$core" "$ws/upskill"
echo "  upskill repo cloned at $ws/upskill"

gskills="$ws/upskill/_system/l2_share_skills/.claude/skills"
[[ -d "$gskills/upskill__sharing__receive-skills" ]] \
  || { echo "error: branch '$branch' ships no upskill sharing skills at $gskills" >&2; exit 1; }

# 4. config
config="$ws/upskill__user-config.json"
python3 -c 'import json,sys
cfg = {"user": sys.argv[1], "team": sys.argv[2], "address_book": sys.argv[3]}
with open(sys.argv[4], "w") as f:
    json.dump(cfg, f, indent=2)
    f.write("\n")' "$user" "$team" "./address_books/$team/$ab_basename" "$config"
echo "  config written to $config"

# 5. global Claude Code install: copy the sharing skills into ~/.claude/skills so they are
#    available in every local session, not just inside this workspace.
if [[ "$install_global" -eq 1 ]]; then
  gsrc="$ws/upskill/_system/l2_share_skills/.claude/skills"
  gh="$HOME/.claude/skills"
  if [[ -d "$gsrc/upskill__sharing__receive-skills" ]]; then
    mkdir -p "$gh"
    for s in upskill upskill__sharing__provide-skills upskill__sharing__receive-skills; do
      rm -rf "$gh/$s"
      cp -R "$gsrc/$s" "$gh/$s"
    done
    echo "  global skills installed at $gh (every Claude Code session)"
  else
    echo "  warning: global skills source missing at $gsrc - skipped" >&2
  fi
fi

echo
echo "== done =="
echo "open Claude in: $ws"
echo "then say: use upskill to share (provide) or get/list skills (receive)"
