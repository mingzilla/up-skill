#!/usr/bin/env bash
# up-skill__client__add.sh - copy a teammate's shared skill into a target project.
# usage: up-skill__client__add.sh <owner> <skill-name> <target-project-dir>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=up-skill__client__lib.sh
source "$SCRIPT_DIR/up-skill__client__lib.sh"

us_init "${UP_SKILL_WORKSPACE:-$PWD}"

owner="${1:-}"
skill="${2:-}"
target="${3:-}"
if [[ -z "$owner" || -z "$skill" || -z "$target" ]]; then
  echo "usage: up-skill__client__add.sh <owner> <skill-name> <target-project-dir>" >&2
  echo "  e.g. up-skill__client__add.sh myles text-cleaner /home/me/projects/site" >&2
  exit 1
fi
us_safe_name "$skill"

folder="$(us_folder_of "$owner")"
if [[ -z "$folder" ]]; then
  echo "error: '$owner' is not in the address book" >&2
  exit 1
fi
clone="$US_TEAM_DIR/$folder"
if [[ ! -d "$clone/.git" ]]; then
  echo "error: no local clone for '$owner' at $clone (run install.sh first)" >&2
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

dest="$target/.claude/skills/$skill"
rm -rf "$dest"
mkdir -p "$(dirname "$dest")"
cp -R "$srcskill" "$dest"

echo "added '$skill' (from $owner) to $dest"
echo "  open Claude in '$target' and the skill will be available."
