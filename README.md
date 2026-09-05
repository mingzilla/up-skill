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

## Action files

Each action is one link - drop it into your AI tool (Claude Code, Claude Desktop, Codex) and the
tool runs it:

| What you need | Action file |
|---|---|
| Install on Linux / WSL / macOS | [_meta/actions/action__install__linux.md](_meta/actions/action__install__linux.md) |
| Install on Windows | [_meta/actions/action__install__win.md](_meta/actions/action__install__win.md) |
| Uninstall (any OS) | [_meta/actions/action__uninstall__all_env.md](_meta/actions/action__uninstall__all_env.md) |
| Check or fix an install | [_meta/actions/action__technical_diagnose.md](_meta/actions/action__technical_diagnose.md) |
