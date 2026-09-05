#!/usr/bin/env bash
# admin__setup__user__claude_code__install_global.sh - install up-skill as GLOBAL (personal)
# Claude Code skills, so provide/receive are available in every local session - not per project.
#
# The workspace stays at ~/.up-skill__workspace; the skills resolve it by default.
# Source skills are copied from this repo's l2 bundle
# (_system/l2_share_skills/.claude/skills). Run after the workspace exists; re-run to refresh.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"   # this script lives inside the up-skill repo
SRC="$REPO_ROOT/_system/l2_share_skills/.claude/skills"

for s in upskill up-skill__sharing__provide-skills up-skill__sharing__receive-skills; do
  [[ -d "$SRC/$s" ]] || { echo "error: source skill missing: $SRC/$s" >&2; exit 1; }
done

HOME_SKILLS="$HOME/.claude/skills"
mkdir -p "$HOME_SKILLS"

for s in upskill up-skill__sharing__provide-skills up-skill__sharing__receive-skills; do
  rm -rf "$HOME_SKILLS/$s"
  cp -R "$SRC/$s" "$HOME_SKILLS/$s"
done

echo "installed global up-skill skills into: $HOME_SKILLS"
echo "workspace expected at: $HOME/.up-skill__workspace"
echo "start a new Claude Code session, then say: use up-skill to share / get / list skills"
