# admin__setup__user

A user is non-technical. After a one-time install they never see a command line or do any config.

Setup is **global**, not per project, and is per tool. See:
- `admin__setup__user__claude_code` - global in Claude Code (CLI / IDE / Code tab)
- `admin__setup__user__codex` - global in OpenAI Codex (mechanism pending)

## The user contract

| Touchpoint | What the user does | What happens |
|---|---|---|
| One-time install | run `upskill__install.sh` (admin guides), answer one question: where the workspace goes | builds a hidden `.upskill__workspace`: clones the team address book + every member's skills repo, installs the single `upskill` skill, writes the config |
| After install | open Claude **in** `.upskill__workspace` | the `upskill` skill is available |
| Everyday | say "use upskill to ..." | the skill shows the menu; Claude routes to its actions (address book / receive / provide) |

The user never looks inside `.upskill__workspace` and never touches git.

## What install.sh needs per user

- `--user <name>` - their name in the address book
- `--home <dir>` - where `.upskill__workspace` is created (the one choice they make)
- address book + core come from the repo defaults, or an admin points them at another team's address book

## Install script

`upskill__install.sh` lives at the repo root of the upskill project (`mingzilla/upskill`).

## In scope today

- Linux / WSL / macOS via the bash installer; native Windows via the PowerShell mirror
  (`upskill__install.ps1`). Claude Desktop plugin: removed.
