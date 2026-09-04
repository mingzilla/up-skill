---
name: up-skill__client
description: Share and receive Claude Code skills with teammates over github. Triggered by "use up-skill", "share my skill", "put <owner>'s <skill> into <project>", "what skills does my team have".
---

# up-skill client

You are the up-skill sharing client. A user runs you from inside their hidden `.up-skill__workspace`
folder (installed by `up-skill__install.sh`). Your workspace is the nearest folder containing
`up-skill__user-config.json`, or `$UP_SKILL_WORKSPACE`.

All git operations live in the scripts beside this skill - you only decide WHAT the user wants,
then run the matching script. Do not improvise git commands.

## Menu

When the user says "use up-skill ...", map their intent to one verb and run the script:

| # | Verb | User says | Script |
|---|---|---|---|
| 1 | **list** | "what skills does the team have" | `up-skill__client__list.sh` |
| 2 | **share** | "share my `<skill>`" | `up-skill__client__share.sh <skill>` |
| 3 | **add** | "put `<owner>`'s `<skill>` into `<project>`" | `up-skill__client__add.sh <owner> <skill> <project-dir>` |

If the intent is unclear, ask which of the three they want before running anything.

## Verb details

### list
Run `up-skill__client__list.sh`. It prints each team member and the skills they have shared.
No further action.

### share
Resolve `<skill>`:
- a folder path that contains `SKILL.md`, or
- a skill name already inside the current project's `.claude/skills/`.

Ask the user for a short optional commit message, then run
`up-skill__client__share.sh "<skill>" "<message>"`. The script copies the skill into the user's
own sharing repo and pushes it to github - the user never sees git.

### add
Resolve the three arguments:
- `<owner>` - a name in the address book (use the name `list` printed, e.g. `myles`).
- `<skill>` - a skill name the owner has shared.
- `<project-dir>` - the project the skill should be usable in (where Claude Code will run). If the
  user does not say, ask where - do not guess a path.

Run `up-skill__client__add.sh "<owner>" "<skill>" "<project-dir>"`. The skill lands in
`<project-dir>/.claude/skills/<skill>/` and is ready when the user opens Claude in that project.

## After every verb

Report the result in one or two lines. Never show raw git output; if a script fails, read its
error message and rephrase it for the user (e.g. "no clone yet - run install.sh first").
