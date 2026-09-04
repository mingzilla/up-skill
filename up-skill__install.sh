#!/usr/bin/env bash
# up-skill__install.sh - set up a machine's up-skill__workspace from a team definition.
#
# A user runs this once. It builds the workspace, clones the team address book and every
# member's sharing repo, installs the up-skill__client skill, and writes the config. The user
# never needs to look inside the workspace again - they just open Claude there.
#
# usage: up-skill__install.sh --user <name> [options]
#   --user <name>         member name (must be in the address book)
#   --home <dir>          parent of the workspace; workspace = <home>/up-skill__workspace
#                         (default: $HOME - prompted interactively if on a terminal)
#   --address-book <url|path>   address book repo (default: sandbox team)
#   --core <url|path>     the up-skill project repo that ships up-skill__client
#                         (default: https github; pass a local dir to use in-dev code)
#   --reset               empty the workspace first, then rebuild from the definition
set -euo pipefail

DEFAULT_ADDRESS_BOOK="https://github.com/mingzilla/up-skill__address_book__sandbox.git"
DEFAULT_CORE="https://github.com/mingzilla/up-skill.git"

user=""
home=""
address_book="$DEFAULT_ADDRESS_BOOK"
core="$DEFAULT_CORE"
reset=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) user="${2:-}"; shift 2 ;;
    --home) home="${2:-}"; shift 2 ;;
    --address-book) address_book="${2:-}"; shift 2 ;;
    --core) core="${2:-}"; shift 2 ;;
    --reset) reset=1; shift ;;
    *) echo "error: unknown option: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$user" ]] || { echo "error: --user <name> is required" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "error: python3 is required" >&2; exit 1; }
command -v git    >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }

# prompt_default <question> <default> - non-interactive runs just use the default
prompt_default() {
  local question="$1" default="$2" answer
  if [[ -t 0 && -t 1 ]]; then
    read -r -p "$question [$default]: " answer
    echo "${answer:-$default}"
  else
    echo "$default"
  fi
}

if [[ -z "$home" ]]; then
  home="$(prompt_default "Where should up-skill__workspace live?" "$HOME")"
fi
ws="$home/up-skill__workspace"

# clone_or_pull <dir> <url-or-local-path> <label>
clone_or_pull() {
  local dir="$1" src="$2" label="$3"
  if [[ -d "$dir/.git" ]]; then
    if git -C "$dir" rev-parse --verify -q HEAD >/dev/null 2>&1; then
      echo "  refresh $label: pull"
      git -C "$dir" pull --ff-only --quiet
    else
      echo "  refresh $label: (empty clone, nothing to pull)"
    fi
  else
    if [[ -e "$dir" ]]; then
      echo "  remove stale '$label' ($dir) and re-clone"
      rm -rf "$dir"
    fi
    echo "  clone $label"
    git clone --quiet "$src" "$dir"
  fi
}

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

echo "== up-skill install for '$user' =="
echo "workspace: $ws"

if [[ "$reset" -eq 1 ]]; then
  [[ "$(basename "$ws")" == "up-skill__workspace" ]] || { echo "error: refusing to reset $ws" >&2; exit 1; }
  echo "--reset: emptying $ws"
  rm -rf "$ws"
fi
mkdir -p "$ws"

# 1. address book
ab_basename="$(basename "${address_book%%/}")"; ab_basename="${ab_basename%.git}"
team="$(team_dir_for "$address_book")"
ab_dir="$ws/address_books/$team/$ab_basename"
mkdir -p "$ws/address_books/$team"
echo "-- address book ($team): $address_book"
clone_or_pull "$ab_dir" "$address_book" "address book"

ab_json="$ab_dir/address_book.json"
[[ -f "$ab_json" ]] || { echo "error: no address_book.json in $ab_dir" >&2; exit 1; }

# 2. every member's sharing repo (address book is the definition)
echo "-- member sharing repos:"
while IFS=$'\t' read -r m_name m_folder m_repo; do
  [[ -n "$m_folder" && -n "$m_repo" ]] || continue
  member_dir="$ws/address_books/$team/$m_folder"
  clone_or_pull "$member_dir" "$m_repo" "sharing repo of $m_name"
done < <(python3 -c 'import json,sys
ab = json.load(open(sys.argv[1]))
for n, m in ab.get("users", {}).items():
    print(n + "\t" + m.get("folder", "") + "\t" + m.get("repo", ""))' "$ab_json")

# 3. up-skill__client from the core (local path = in-dev copy; url = clone then copy)
echo "-- installing up-skill__client:"
client_src=""
if [[ -d "$core/.claude/skills/up-skill__client" ]]; then
  client_src="$core/.claude/skills/up-skill__client"          # core is a local dir
  echo "  core: local $core"
else
  core_dir="$ws/up-skill__core"
  clone_or_pull "$core_dir" "$core" "up-skill core"
  client_src="$core_dir/.claude/skills/up-skill__client"
fi
[[ -d "$client_src" ]] || { echo "error: core has no .claude/skills/up-skill__client ($client_src)" >&2; exit 1; }
client_dest="$ws/.claude/skills/up-skill__client"
rm -rf "$client_dest"
mkdir -p "$ws/.claude/skills"
cp -R "$client_src" "$client_dest"
echo "  client installed at $client_dest"

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
echo "then say: use up-skill to share / add / list skills"
