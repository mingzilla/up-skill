#!/usr/bin/env bash
# upskill__uninstall.sh - remove upskill from this machine.
#
# Removes (nothing else):
#   - global Claude Code skill:   ~/.claude/skills/upskill  (+ any legacy upskill__* folders)
#   - the workspace:              ~/.upskill__workspace
# Your github repos and your projects are not touched.
#
# usage: upskill__uninstall.sh [--yes]
set -euo pipefail

if [[ "${1:-}" != "--yes" ]]; then
  echo "This will delete: $HOME/.claude/skills/upskill and $HOME/.upskill__workspace" >&2
  echo "Re-run with --yes to confirm. (Your github repos and projects are never touched.)" >&2
  exit 1
fi

HOME_SKILLS="$HOME/.claude/skills"
# rm_skill <dir> - delete only a real upskill skill under the global skills dir (guarded)
rm_skill() {
  local d="$1"
  [[ "$d" == "$HOME/.claude/skills/"* ]] || { echo "refusing to delete outside global skills dir: $d" >&2; exit 1; }
  [[ -e "$d" ]] || return 0
  [[ -d "$d" && "$(basename "$d")" == upskill* && -f "$d/SKILL.md" ]] || { echo "refusing to delete (not an upskill skill): $d" >&2; exit 1; }
  rm -rf "$d"
}
for s in upskill upskill__sharing__provide-skills upskill__sharing__receive-skills \
         upskill__action__provide-skills upskill__action__receive-skills; do
  rm_skill "$HOME_SKILLS/$s"
done
echo "removed global upskill skills from $HOME_SKILLS"

ws="$HOME/.upskill__workspace"
[[ "$(basename "$ws")" == ".upskill__workspace" ]] && rm -rf "$ws"
echo "removed workspace $ws"

echo "done."
