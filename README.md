# Up Skill

Up skill non-tech people so that teams can make use of AI skills to improve their work experience.

## To the Devs

> Your skill is only useful if you can share it

## What this is

A way for non-technical people to share Claude Code skills between teammates over github:

- sharer: *"share this skill"* - Claude uploads it to your sharing repo
- receiver: *"get the xxx skill myles shared"* - Claude pulls it into your project

The sharing repo is transport only - each member curates their own shelf, and receiving a skill is
a one-way copy (the sharer's later renames/updates do not touch what you already have).

> Curating a high-quality team skill *library* is a different task and is out of scope here.

- every member has their own skills repo (e.g. `upskill__skills_repo__leah`)
- a team **address book** maps each member name to their repo
- two skills do the work, no git for the user: `upskill__sharing__provide-skills` (share one of
  yours) and `upskill__sharing__receive-skills` (list / get / install)

A machine is set up once by `upskill__install.sh`: it builds a hidden `.upskill__workspace`
folder (team data: the address book + each member's skills repo + the upskill repo) and writes
`upskill__user-config.json` inside it, then installs the two sharing skills **globally** in
`~/.claude/skills` so they work in every Claude Code session. After that the user only talks to
Claude - they never see the workspace folder again.

## Prerequisites (Linux / WSL)

- `git`
- `python3`
- Claude Code
- access to this repo and the team's `upskill__skills_repo__*` repos

## Linux set up - one time

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__install.sh | bash
```

The installer asks two things and does the rest:

| Prompt | Meaning |
|---|---|
| Your upskill user name | the name you are listed under in the team address book, e.g. `myles` |
| Where should the upskill workspace live? | a folder on your machine; `.upskill__workspace` is created inside it (default: your home) |

For an unattended run, pass the answers instead:

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__install.sh | bash -s -- --user myles --home ~
```

> Requires a github login that can read the team's repos - the installer clones the address book and
> each member's sharing repo (`upskill` itself is public; those may stay private).
>
> Alternative if you keep a local copy: `git clone git@github.com:mingzilla/upskill.git && cd upskill && bash upskill__install.sh`.

## Use it

Open Claude **in** the `.upskill__workspace` folder (it is a normal Claude project) and say:

> use upskill to ...

Claude offers these verbs:

| Verb | Example |
|---|---|
| list | what skills does the team have |
| share | share my `my_nice_skill` |
| add | put `leah`'s `my_nice_skill` into my website project |
| install | install `https://github.com/mingzilla/upskill` into this project |

## For Claude: how to install on a new machine

This section is a direct instruction to Claude Code. If a user asks you to
"install https://github.com/mingzilla/upskill" (or any upskill repo), do exactly this:

1. Check the machine has `git` and `python3`.
2. Ask the user for their upskill user name (the name they are listed under in the team address book).
3. Run the installer with those params:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__install.sh \
     | bash -s -- --user "<their name>" --home "$HOME"
   ```

4. Confirm it finished, then tell the user:
   "Open Claude in `$HOME/.upskill__workspace` and say `use upskill to ...`."

Do not improvise other commands - the installer owns the workspace layout.

## Install targets

The installer runs everywhere and installs what applies to this machine. Skills are shared and
received from whichever surfaces are set up.

| OS | Claude Code (global) | Claude Desktop | Codex |
|---|---|---|---|
| Linux / macOS / WSL | installed by the installer (skills in `~/.claude/skills`) | n/a here | pending |
| Windows | installed by the installer | via the upskill plugin (marketplace) | pending |

- The one-line installer above builds the workspace and installs the **global Claude Code** skills
  automatically. Use `--skip-global` to skip that.
- **Windows**: run the PowerShell mirror (same layout under `%USERPROFILE%`):

  ```powershell
  powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__install.ps1 | iex"
  ```
- **Claude Desktop** (Windows): install the plugin - see the one-off setup skill
  `_system/l2_share_skills/.claude/skills__one_off/admin__setup__user__claude_desktop_plugin`.
- **Codex**: not yet supported (mechanism under research).

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__uninstall.sh | bash
```

On Windows:

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__uninstall.ps1 | iex"
```

Removes the global skills and the workspace; never touches your github repos or projects. If you
installed the Claude Desktop plugin, remove it in the app's plugin manager.

## Status

Prototype, sandbox team. Windows uses the PowerShell mirror (`upskill__install.ps1`).
