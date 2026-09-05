#!/usr/bin/env bash
# upskill__add.sh - copy a member's shared skill to a target: global, the current project, or a
# selected project.
# usage:
#   upskill__add.sh <owner> <skill> --project global     -> ~/.claude/skills  (every session)
#   upskill__add.sh <owner> <skill> --project current    -> this project's .claude/skills
#   upskill__add.sh <owner> <skill> --project <path>     -> that project's .claude/skills
#
# If --project is missing, ASK the user which target (global / this project / a path), then call
# again. Never guess.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../../scripts/upskill__lib.sh
source "$SCRIPT_DIR/../../../scripts/upskill__lib.sh"

us_init "${UP_SKILL_WORKSPACE:-$PWD}"

owner="${1:-}"
skill="${2:-}"
target=""

# parse --project <value>
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) target="${2:-}"; shift 2 ;;
    *) shift ;;
  esac
done

if [[ -z "$owner" || -z "$skill" ]]; then
  echo "usage: upskill__add.sh <owner> <skill> --project <global|current|<path>>" >&2
  exit 1
fi
us_safe_name "$skill"

if [[ -z "$target" ]]; then
  echo "error: no target given - ask the user: add '$skill' to global, the current project, or a path?" >&2
  echo "  then call again with: upskill__add.sh $owner $skill --project <global|current|<path>>" >&2
  exit 1
fi

# resolve the destination skills dir for the three target kinds
case "$target" in
  global)  dest_root="$HOME/.claude/skills" ;;
  current) dest_root="$PWD/.claude/skills" ;;
  *)
    if [[ ! -d "$target" ]]; then
      echo "error: target project not found: $target" >&2
      exit 1
    fi
    dest_root="$target/.claude/skills"
    ;;
esac

folder="$(us_folder_of "$owner")"
if [[ -z "$folder" ]]; then
  echo "error: '$owner' is not in the address book" >&2
  exit 1
fi
clone="$US_TEAM_DIR/$folder"
if [[ ! -d "$clone/.git" ]]; then
  echo "error: no local clone for '$owner' at $clone (run the installer first)" >&2
  exit 1
fi

# refresh the owner's clone when it is not me (best effort - an empty repo has no HEAD yet)
if [[ "$folder" != "$US_ME_FOLDER" ]]; then
  git -C "$clone" pull --ff-only --quiet 2>/dev/null \
    || echo "note: could not pull '$owner' - reading the local clone as-is" >&2
fi

srcskill="$clone/$skill"
if [[ ! -f "$srcskill/SKILL.md" ]]; then
  echo "error: '$owner' has no shared skill '$skill'. Available from $owner:" >&2
  while IFS= read -r s; do echo "  $s" >&2; done < <(us_skill_names "$clone")
  exit 1
fi

dest="$dest_root/$skill"
rm -rf "$dest"
mkdir -p "$(dirname "$dest")"
cp -R "$srcskill" "$dest"

echo "added '$skill' (from $owner) to $dest"
case "$target" in
  global)  echo "  it is now available in every Claude session." ;;
  current) echo "  open Claude in '$PWD' and the skill will be available." ;;
  *)       echo "  open Claude in '$target' and the skill will be available." ;;
esac
