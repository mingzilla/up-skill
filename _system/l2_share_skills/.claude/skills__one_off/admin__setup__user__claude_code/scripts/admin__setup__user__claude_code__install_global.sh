#!/usr/bin/env bash
# admin__setup__user__claude_code__install_global.sh - install upskill as GLOBAL (personal)
# Claude Code skill, so it is available in every local session - not per project.
#
# The workspace stays at ~/.upskill__workspace; the skill resolves it by default.
# The source skill is copied from this repo's l2 bundle
# (_system/l2_share_skills/.claude/skills/upskill). Run after the workspace exists; re-run to refresh.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"   # this script lives inside the upskill repo
SRC="$REPO_ROOT/_system/l2_share_skills/.claude/skills/upskill"
[[ -f "$SRC/SKILL.md" ]] || { echo "error: source skill missing: $SRC" >&2; exit 1; }

HOME_SKILLS="$HOME/.claude/skills"
mkdir -p "$HOME_SKILLS"

# rm_skill <dir> - delete only a real upskill skill under the global skills dir (guarded)
rm_skill() {
  local d="$1"
  [[ "$d" == "$HOME/.claude/skills/"* ]] || { echo "refusing to delete outside global skills dir: $d" >&2; return 1; }
  [[ -e "$d" ]] || return 0
  [[ -d "$d" && "$(basename "$d")" == upskill* && -f "$d/SKILL.md" ]] || { echo "refusing to delete (not an upskill skill): $d" >&2; return 1; }
  rm -rf "$d"
}
# refresh `upskill` (delete-target-first) and sweep legacy global skill names
for s in upskill__sharing__provide-skills upskill__sharing__receive-skills \
         upskill__action__provide-skills upskill__action__receive-skills; do
  rm_skill "$HOME_SKILLS/$s" || exit 1
done
rm_skill "$HOME_SKILLS/upskill" || exit 1
cp -R "$SRC" "$HOME_SKILLS/upskill"

echo "installed global upskill skill into: $HOME_SKILLS/upskill"
echo "workspace expected at: $HOME/.upskill__workspace"
echo "start a new Claude Code session, then say: use upskill to share / get / list skills"
