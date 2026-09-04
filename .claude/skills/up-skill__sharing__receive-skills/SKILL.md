---
name: up-skill__sharing__receive-skills
description: Bring skills in - inbound. Triggered by "get <owner>'s <skill>", "add <owner>'s <skill> into <project>", "what skills does the team have", "show me users and skills", "install <github-url>". Run when the user wants to RECEIVE/list skills, not share one.
---

# up-skill__sharing__receive-skills

Bring teammates' shared skills into this machine, and see what is available.

Scripts live at `.claude/skills/_up-skill__sharing/scripts/` (run from the up-skill workspace).

## Verbs

| Verb | User says | Script |
|---|---|---|
| list | "what skills does the team have", "show me users and skills" | `up-skill__sharing__list.sh` |
| add | "get myles' `xxx`", "put leah's `xxx` into my site project" | `up-skill__sharing__add.sh "<owner>" "<skill>" "<target-dir>"` |
| install | "install `https://github.com/...` into this project" | `up-skill__sharing__install.sh "<url>" ["<target-dir>"]` |

Full path: `bash .claude/skills/_up-skill__sharing/scripts/<script> <args>`.

Resolution rules:
- `list` - no args; shows each member and their shared skills.
- `add` - `<owner>` is a name `list` printed; `<target-dir>` is where the skill should become usable:
  a project's folder (its `.claude/skills` is created there) or the user-level skills dir. If the user
  does not say, ask - do not guess a path.
- `install` - any github repo; no address book needed. Copies its `.claude/skills/*` into the target.

Do not improvise git. Report the result in one or two lines.
