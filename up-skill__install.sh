#!/usr/bin/env bash
# up-skill__install.sh - build a machine's .up-skill__workspace from scratch.
#
# ALWAYS deletes and recreates the whole workspace, so a run never leaves stale or partial
# state behind. It builds the workspace (address book + every member's skills repo + the
# up-skill sharing skills + config). After install the user only talks to Claude.
#
# usage: up-skill__install.sh [--user <name>] [options]
#   --user <name>         member name (must be in the address book); prompted if omitted
#   --home <dir>          parent of the workspace; workspace = <home>/.up-skill__workspace
#                         (default: $HOME - prompted interactively if on a terminal)
#   --address-book <url|path>   address book repo (default: sandbox team)
#   --core <url|path>     the up-skill project repo that ships the sharing skills
#                         (default: this repo when run from a clone; else https github)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"   # $0 when run as `curl | bash`

# core = this repo when it ships the sharing skills (a clone has them right here); else fetch github
DEFAULT_ADDRESS_BOOK="https://github.com/mingzilla/up-skill__address_book__sandbox.git"
if [[ -d "$SCRIPT_DIR/.claude/skills/up-skill__sharing__receive-skills" ]]; then
  DEFAULT_CORE="$SCRIPT_DIR"
else
  DEFAULT_CORE="https://github.com/mingzilla/up-skill.git"
fi

user=""
home=""
address_book="$DEFAULT_ADDRESS_BOOK"
core="$DEFAULT_CORE"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) user="${2:-}"; shift 2 ;;
    --home) home="${2:-}"; shift 2 ;;
    --address-book) address_book="${2:-}"; shift 2 ;;
    --core) core="${2:-}"; shift 2 ;;
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
  user="$(prompt_default "Your up-skill user name (as in the team address book)" "${UP_SKILL_USER:-}")"
fi
[[ -n "$user" ]] || { echo "error: --user <name> is required (or set UP_SKILL_USER)" >&2; exit 1; }

if [[ -z "$home" ]]; then
  home="$(prompt_default "Where should the up-skill workspace live? (a hidden .up-skill__workspace folder)" "$HOME")"
fi
ws="$home/.up-skill__workspace"

# team dir from address book repo basename: up-skill__address_book__<team> -> team__<team>
team_dir_for() {
  local base
  base="$(basename "${1%%/}")"
  base="${base%.git}"
  case "$base" in
    up-skill__address_book__*) echo "team__${base#up-skill__address_book__}" ;;
    *) echo "$base" ;;
  esac
}

# clone <dir> <url-or-local-path> <label> - fresh clone into a dir that does not exist yet
clone() {
  local dir="$1" src="$2" label="$3"
  echo "  clone $label"
  git clone --quiet "$src" "$dir"
}

echo "== up-skill install for '$user' =="
echo "workspace: $ws"

# always rebuild the whole workspace - never refresh, so no stale leftovers
[[ "$(basename "$ws")" == ".up-skill__workspace" ]] || { echo "error: refusing to rebuild $ws" >&2; exit 1; }
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

# 3. operational sharing skills from the core: everything under .claude/skills
#    (local dir = in-dev copy; url = clone then copy)
echo "-- installing up-skill sharing skills:"
skills_src=""
if [[ -d "$core/.claude/skills" && -d "$core/.claude/skills/up-skill__sharing__receive-skills" ]]; then
  skills_src="$core/.claude/skills"            # core is a local dir / clone that ships them
  echo "  core: local $core"
else
  core_dir="$ws/up-skill__core"
  clone "$core_dir" "$core" "up-skill core"
  skills_src="$core_dir/.claude/skills"
fi
[[ -d "$skills_src/up-skill__sharing__receive-skills" ]] \
  || { echo "error: core ships no up-skill sharing skills at $skills_src" >&2; exit 1; }
mkdir -p "$ws/.claude/skills"
cp -R "$skills_src/." "$ws/.claude/skills/"
echo "  skills installed at $ws/.claude/skills"

# 4. config
config="$ws/up-skill__user-config.json"
python3 -c 'import json,sys
cfg = {"user": sys.argv[1], "team": sys.argv[2], "address_book": sys.argv[3]}
with open(sys.argv[4], "w") as f:
    json.dump(cfg, f, indent=2)
    f.write("\n")' "$user" "$team" "./address_books/$team/$ab_basename" "$config"
echo "  config written to $config"

echo
echo "== done =="
echo "open Claude in: $ws"
echo "then say: use up-skill to share (provide) or get/list skills (receive)"
