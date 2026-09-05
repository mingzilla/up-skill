#!/usr/bin/env bash
# upskill__uninstall.sh - remove upskill from this machine.
#
# Removes (nothing else):
#   - global Claude Code skills:  ~/.claude/skills/upskill__sharing__*
#   - the workspace:              ~/.upskill__workspace
# Your github repos and your projects are not touched.
#
# usage: upskill__uninstall.sh [--yes]
set -euo pipefail

if [[ "${1:-}" != "--yes" ]]; then
  echo "This will delete: $HOME/.claude/skills/upskill__sharing__* and $HOME/.upskill__workspace" >&2
  echo "Re-run with --yes to confirm. (Your github repos and projects are never touched.)" >&2
  exit 1
fi

HOME_SKILLS="$HOME/.claude/skills"
rm -rf "$HOME_SKILLS/upskill__action__provide-skills" \
       "$HOME_SKILLS/upskill__action__receive-skills"
echo "removed global upskill skills from $HOME_SKILLS"

ws="$HOME/.upskill__workspace"
[[ "$(basename "$ws")" == ".upskill__workspace" ]] && rm -rf "$ws"
echo "removed workspace $ws"

echo "done. If you installed the Claude Desktop plugin, remove it there: /plugin (Code tab)."
