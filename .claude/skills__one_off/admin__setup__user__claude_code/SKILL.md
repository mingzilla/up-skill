# admin__setup__user__claude_code

Make up-skill **global** in Claude Code (CLI, IDE, and the Desktop Code tab) - not per project.
After this, provide/receive are available in every local Claude Code session.

## How it works

The two skills are installed as **personal (global) skills** in `~/.claude/skills`, which load in
every local session. The workspace stays at `~/.up-skill__workspace` under the user profile; the
skills resolve that path by default (overridable via `UP_SKILL_WORKSPACE`).

## Steps

1. The user's workspace data (address book + members' skills repos + config) must exist at
   `~/.up-skill__workspace` - create it once with the up-skill installer (`up-skill__install.sh`).
2. Install the global skills by running this skill's own script:

   ```bash
   bash .claude/skills__one_off/admin__setup__user__claude_code/scripts/admin__setup__user__claude_code__install_global.sh
   ```

3. Start a new Claude Code session and say `use up-skill to ...`.

## Result

`share this skill` / `get <owner>'s <skill>` work in any folder. No per-project `.claude/skills`
copies are needed.
