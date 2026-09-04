#!/usr/bin/env bash
# up-skill__uninstall.sh - remove up-skill from this machine.
#
# Removes (nothing else):
#   - global Claude Code skills:  ~/.claude/skills/up-skill__sharing__*
#   - the workspace:              ~/.up-skill__workspace
# Your github repos and your projects are not touched.
#
# usage: up-skill__uninstall.sh [--yes]
set -euo pipefail

if [[ "${1:-}" != "--yes" ]]; then
  echo "This will delete: $HOME/.claude/skills/up-skill__sharing__* and $HOME/.up-skill__workspace" >&2
  echo "Re-run with --yes to confirm. (Your github repos and projects are never touched.)" >&2
  exit 1
fi

HOME_SKILLS="$HOME/.claude/skills"
rm -rf "$HOME_SKILLS/up-skill__sharing__provide-skills" \
       "$HOME_SKILLS/up-skill__sharing__receive-skills"
echo "removed global up-skill skills from $HOME_SKILLS"

ws="$HOME/.up-skill__workspace"
[[ "$(basename "$ws")" == ".up-skill__workspace" ]] && rm -rf "$ws"
echo "removed workspace $ws"

echo "done. If you installed the Claude Desktop plugin, remove it there: /plugin (Code tab)."
