# admin__setup__user__claude_code

Make upskill **global** in Claude Code (CLI, IDE, and the Desktop Code tab) - not per project.
After this, provide/receive are available in every local Claude Code session.

## How it works

The two skills are installed as **personal (global) skills** in `~/.claude/skills`, which load in
every local session. The workspace stays at `~/.upskill__workspace` under the user profile; the
skills resolve that path by default (overridable via `UP_SKILL_WORKSPACE`).

## Steps

1. The user's workspace data (address book + members' skills repos + config) must exist at
   `~/.upskill__workspace` - create it once with the upskill installer (`upskill__install.sh`).
2. Install the global skills by running this skill's own script (source is this repo's l2 bundle) -
   the `.sh` with `bash` on mac / linux / WSL, the `.ps1` with PowerShell on native Windows:

   ```bash
   # mac / linux / WSL
   bash _system/l2_share_skills/.claude/skills__one_off/admin__setup__user__claude_code/scripts/admin__setup__user__claude_code__install_global.sh
   # native Windows
   powershell -NoProfile -ExecutionPolicy Bypass -File _system/l2_share_skills/.claude/skills__one_off/admin__setup__user__claude_code/scripts/admin__setup__user__claude_code__install_global.ps1
   ```

3. Start a new Claude Code session and say `use upskill to ...`.

## Result

`share this skill` / `get <owner>'s <skill>` work in any folder. No per-project `.claude/skills`
copies are needed.
