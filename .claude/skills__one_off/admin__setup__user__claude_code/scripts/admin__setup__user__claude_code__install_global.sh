#!/usr/bin/env bash
# admin__setup__user__claude_code__install_global.sh - install up-skill as GLOBAL (personal)
# Claude Code skills, so provide/receive are available in every local session - not per project.
#
# The workspace stays at ~/.up-skill__workspace; the skills resolve it by default.
# Usage: run this after the up-skill workspace exists. Re-run to refresh the skills.
set -euo pipefail

cd "$(dirname "$0")/../../../.."   # repo root (this script lives in .claude/skills__one_off/<skill>/scripts/)

for s in up-skill__sharing__provide-skills up-skill__sharing__receive-skills; do
  [[ -d ".claude/skills/$s" ]] || { echo "error: source skill missing: .claude/skills/$s" >&2; exit 1; }
done

HOME_SKILLS="$HOME/.claude/skills"
mkdir -p "$HOME_SKILLS"

for s in up-skill__sharing__provide-skills up-skill__sharing__receive-skills; do
  rm -rf "$HOME_SKILLS/$s"
  cp -R ".claude/skills/$s" "$HOME_SKILLS/$s"
done

echo "installed global up-skill skills into: $HOME_SKILLS"
echo "workspace expected at: $HOME/.up-skill__workspace"
echo "start a new Claude Code session, then say: use up-skill to share / get / list skills"
