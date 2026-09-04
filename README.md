# Up Skill

Up skill non-tech people so that teams can make use of AI skills to improve their work experience.

## What this is

A way to share Claude Code skills between teammates over github:

- every member has their own skills repo (e.g. `up-skill__sharing__leah`)
- a team **address book** maps each member name to their repo
- the `up-skill__client` skill lists / shares / adds skills without touching git

A machine is set up once by `up-skill__install.sh`, which builds a hidden `.up-skill__workspace`
folder (the address book + each member's repo + the client skill) and writes
`up-skill__user-config.json` inside it. After that the user only talks to Claude - they never see
the folder again.

## Prerequisites (Linux / WSL)

- `git`
- `python3`
- Claude Code
- access to this repo and the team's `up-skill__sharing__*` repos

## Linux set up - one time

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/up-skill/main/up-skill__install.sh | bash
```

The installer asks two things and does the rest:

| Prompt | Meaning |
|---|---|
| Your up-skill user name | the name you are listed under in the team address book, e.g. `myles` |
| Where should the up-skill workspace live? | a folder on your machine; `.up-skill__workspace` is created inside it (default: your home) |

For an unattended run, pass the answers instead:

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/up-skill/main/up-skill__install.sh | bash -s -- --user myles --home ~
```

> Requires a github login that can read the team's repos - the installer clones the address book and
> each member's sharing repo (`up-skill` itself is public; those may stay private).
>
> Alternative if you keep a local copy: `git clone git@github.com:mingzilla/up-skill.git && cd up-skill && bash up-skill__install.sh`.

## Use it

Open Claude **in** the `.up-skill__workspace` folder (it is a normal Claude project) and say:

> use up-skill to ...

Claude offers the three verbs:

| Verb | Example |
|---|---|
| list | what skills does the team have |
| share | share my `my_nice_skill` |
| add | put `leah`'s `my_nice_skill` into my website project |

## Status

Prototype, sandbox team. Windows / Claude-Desktop users: a `ps1` mirror of the installer is planned.
