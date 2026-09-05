# Up Skill

Up skill non-tech people so that teams can make use of AI skills to improve their work experience.

## To the Devs

> Your skill is only useful if you can share it

## Usage in Your AI Tools (Codex, Claude Desktop, Claude Code)

- Use upskill to share `<skill-name>` skill
- Use upskill to check `<user-name>` has
- Use upskill to download `<skill-name>` from `<user-name>`

## What this is

A way for non-technical people to share skills between teammates over github:

- sharer: *"share this skill"* - Claude uploads it to your sharing repo
- receiver: *"get the xxx skill myles shared"* - Claude pulls it into your project

The sharing repo is transport only - each member curates their own shelf, and receiving a skill is
a one-way copy (the sharer's later renames/updates do not touch what you already have).

> Curating a high-quality team skill *library* is a different task and is out of scope here.

- every member has their own skills repo (e.g. `upskill__skills_repo__leah`)
- a team **address book** maps each member name to their repo
- two skills do the work, no git for the user: `upskill__sharing__provide-skills` (share one of
  yours) and `upskill__sharing__receive-skills` (list / get / install)

## Set up

A machine is set up once by the installer. It builds a hidden `.upskill__workspace` folder (the team
address book + each member's skills repo + the upskill repo) and installs the two sharing skills
**globally** (`~/.claude/skills`, Windows: `%USERPROFILE%\.claude\skills`) so they work in every
Claude Code session. After that the user only talks to Claude.

Give your AI tool the action file for your machine - it has the exact one-line install:

| Machine | Action file |
|---|---|
| Linux / WSL / macOS | [_meta/actions/action__install__linux.md](_meta/actions/action__install__linux.md) |
| Windows | [_meta/actions/action__install__win.md](_meta/actions/action__install__win.md) |

## Use it

Open Claude **in** the `.upskill__workspace` folder (it is a normal Claude project) and say:

> use upskill to ...

Claude offers these verbs:

| Verb    | Example                                                          |
|---------|------------------------------------------------------------------|
| list    | what skills does the team have                                   |
| share   | share my `my_nice_skill`                                         |
| add     | put `leah`'s `my_nice_skill` into my website project             |
| install | install `https://github.com/mingzilla/upskill` into this project |

## Uninstall

Linux / WSL / macOS:

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__uninstall.sh | bash
```

Windows (PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__uninstall.ps1 | iex"
```

Removes the global skills and the workspace; never touches your github repos or projects.

## Status

Prototype, sandbox team. Linux / WSL / macOS use the bash installer (`upskill__install.sh`);
Windows uses the PowerShell mirror (`upskill__install.ps1`).
