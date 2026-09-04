# admin__setup__user

A user is non-technical. After a one-time install they never see a command line or do any config.

## The user contract

| Touchpoint | What the user does | What happens |
|---|---|---|
| One-time install | run `up-skill__install.sh` (admin guides), answer one question: where the workspace goes | builds `up-skill__workspace`: clones the team address book + every member's sharing repo, installs `up-skill__client`, writes the config |
| After install | open Claude **in** `up-skill__workspace` | the `up-skill__client` skill is available |
| Everyday | say "use up-skill to ..." | client offers: 1 list / 2 share / 3 add |

The user never looks inside `up-skill__workspace` and never touches git.

## What install.sh needs per user

- `--user <name>` - their name in the address book
- `--home <dir>` - where `up-skill__workspace` is created (the one choice they make)
- address book + core come from the repo defaults, or an admin points them at another team's address book

## Install script

`up-skill__install.sh` lives at the repo root of the up-skill project (`mingzilla/up-skill`).

## In scope today

- WSL / bash only. Windows-no-WSL users get a mirror `ps1` installer later; they will then run the
  skill from Claude Desktop instead of a workspace folder.
