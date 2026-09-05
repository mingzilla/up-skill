#!/usr/bin/env bash
# upskill__list.sh - show shared skills.
#   no owner   -> every member and their skills (the team shelf view)
#   <owner>    -> one member's skills, numbered 1..n (so the user can say "Add <n> to <project>")
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../../scripts/upskill__lib.sh
source "$SCRIPT_DIR/../../../scripts/upskill__lib.sh"

us_init "${UP_SKILL_WORKSPACE:-$PWD}"

owner="${1:-}"

if [[ -z "$owner" ]]; then
  echo "Skills shared in team '$US_TEAM':"
  any=0
  while IFS=$'\t' read -r name folder _repo; do
    [[ -n "$name" && -n "$folder" ]] || continue
    clone="$US_TEAM_DIR/$folder"
    if [[ -d "$clone/.git" ]]; then
      git -C "$clone" pull --ff-only --quiet 2>/dev/null || true
    fi
    skills="$(us_skill_names "$clone")"
    if [[ -n "$skills" ]]; then
      printf '  %s:\n' "$name"
      while IFS= read -r s; do printf '    %s\n' "$s"; done <<< "$skills"
      any=1
    fi
  done < <(us_members)
  if [[ "$any" -eq 0 ]]; then
    echo "  (no skills shared yet)"
  fi
  exit 0
fi

folder="$(us_folder_of "$owner")"
if [[ -z "$folder" ]]; then
  echo "error: '$owner' is not in the address book" >&2
  exit 1
fi
clone="$US_TEAM_DIR/$folder"
if [[ -d "$clone/.git" ]]; then
  git -C "$clone" pull --ff-only --quiet 2>/dev/null || true
fi

skills="$(us_skill_names "$clone")"
if [[ -z "$skills" ]]; then
  echo "($owner has no skills shared yet)"
  exit 0
fi

echo "$owner's skills:"
i=0
while IFS= read -r s; do
  i=$((i + 1))
  printf '%3d  %s\n' "$i" "$s"
done <<< "$skills"
echo
echo "say:  Add <number> to <project>    e.g. \"Add 1 to my website project\""
