---
name: upskill__action__receive-skills
description: Bring skills in - inbound. Triggered by "get <owner>'s <skill>", "add <owner>'s <skill> into <project>", "what skills does the team have", "show me users and skills", "install <github-url>". Run when the user wants to RECEIVE/list skills, not share one.
---

# upskill__action__receive-skills

Bring teammates' shared skills into this machine, and see what is available.

This skill is self-contained: its scripts live in its own `scripts/` folder
(`.claude/skills/upskill__action__receive-skills/scripts/`, run from the upskill workspace).

## Verbs

| Verb | User says | Script (run the `.sh` or `.ps1` for your shell) |
|---|---|---|
| list | "what skills does the team have", "show me users and skills" | `upskill__sharing__list.sh` / `upskill__sharing__list.ps1` |
| add | "get myles' `xxx`", "put leah's `xxx` into my site project" | `upskill__sharing__add.sh` / `.ps1` `"<owner>" "<skill>" "<target-dir>"` |
| install | "install `https://github.com/...` into this project" | `upskill__sharing__install.sh` / `.ps1` `"<url>" ["<target-dir>"]` |

Scripts live in `.claude/skills/upskill__action__receive-skills/scripts/`. Run the `.sh` with `bash`
on mac / linux / WSL, or the `.ps1` with `powershell -NoProfile -ExecutionPolicy Bypass -File` on
native Windows.

Resolution rules:
- `list` - no args; shows each member and their shared skills.
- `add` - `<owner>` is a name `list` printed; `<target-dir>` is where the skill should become usable:
  a project's folder (its `.claude/skills` is created there) or the user-level skills dir. If the user
  does not say, ask - do not guess a path.
- `install` - any github repo; no address book needed. Copies its `.claude/skills/*` into the target.

Do not improvise git. Report the result in one or two lines.
