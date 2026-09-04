---
name: up-skill__sharing__receive-skills
description: Bring skills in - list what the team shared, get a teammate's skill into a Claude skills dir, install skills from any github repo. Triggered by "get <owner>'s <skill>", "add <owner>'s <skill> into <project>", "what skills does the team have", "show me users and skills", "install <github-url>". Inbound only.
---

# up-skill__sharing__receive-skills

Bring teammates' shared skills into this machine. This skill is self-contained - its scripts are in
its own `scripts/` folder (`${CLAUDE_SKILL_DIR}/scripts/`).

## Find the workspace

`list` and `add` act on the up-skill workspace. Its path is stored in
`${CLAUDE_PLUGIN_DATA}/config.json` (JSON with a `workspace` key). Read that file.

- If present, export it for the script calls below.
- If missing, tell the user to run the up-skill installer/setup first, and stop.

`install` does not need the workspace.

## Verbs

| Verb | What to run |
|---|---|
| list | `UP_SKILL_WORKSPACE="<ws>" bash ${CLAUDE_SKILL_DIR}/scripts/up-skill__sharing__list.sh` |
| add | `UP_SKILL_WORKSPACE="<ws>" bash ${CLAUDE_SKILL_DIR}/scripts/up-skill__sharing__add.sh "<owner>" "<skill>" "<target-dir>"` |
| install | `bash ${CLAUDE_SKILL_DIR}/scripts/up-skill__sharing__install.sh "<url>" ["<target-dir>"]` |

Resolution rules:
- `list` - no args; shows each member and their shared skills.
- `add` - `<owner>` is a name `list` printed; `<target-dir>` is where the skill becomes usable: a
  project folder (its `.claude/skills` is created there) or the user-level skills dir. Ask the user
  if they do not say; do not guess a path.
- `install` - any github repo; no address book needed.

Do not improvise git. Report the result in one or two lines.
