#!/usr/bin/env bash
# up-skill__client__list.sh - list the skills each team member has shared (read-only).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=up-skill__client__lib.sh
source "$SCRIPT_DIR/up-skill__client__lib.sh"

us_init "${UP_SKILL_WORKSPACE:-$PWD}"

echo "Skills shared in team '$US_TEAM':"
any=0
while IFS=$'\t' read -r name folder _repo; do
  [[ -n "$name" && -n "$folder" ]] || continue
  clone="$US_TEAM_DIR/$folder"
  # refresh so the list is current (an empty clone has no HEAD yet - ignore failures)
  if [[ -d "$clone/.git" ]]; then
    git -C "$clone" pull --ff-only --quiet 2>/dev/null || true
  fi
  skills="$(us_skill_names "$clone")"
  if [[ -n "$skills" ]]; then
    printf '  %s:\n' "$name"
    while IFS= read -r s; do
      printf '    %s\n' "$s"
    done <<< "$skills"
    any=1
  fi
done < <(us_members)

if [[ "$any" -eq 0 ]]; then
  echo "  (no skills shared yet)"
fi
