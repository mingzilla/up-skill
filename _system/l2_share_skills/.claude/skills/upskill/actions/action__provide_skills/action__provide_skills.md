# action__provide_skills

Share one of your skills so teammates can receive it (menu option 4, "share my <skill>").

Resolve the `<skill>`:
- a folder path that contains `SKILL.md`, or
- a skill name under the current project's `.claude/skills`.

Ask the user which skill if it is unclear, and for an optional short message. Then run the matching
script for the shell you are in - **do not improvise git**:

| Where you run | Command |
|---|---|
| mac / linux / WSL (bash) | `bash <this-skill>/actions/action__provide_skills/scripts/upskill__share.sh "<skill>" "<message>"` |
| native Windows (PowerShell) | `powershell -NoProfile -ExecutionPolicy Bypass -File <this-skill>/actions/action__provide_skills/scripts/upskill__share.ps1 "<skill>" "<message>"` |

`<this-skill>` is the folder holding the upskill SKILL.md. Run from the workspace, or with
`UP_SKILL_WORKSPACE` set to it.

If the script reports a missing skills repo, tell the user to run the installer first. Report the
result in one line.
