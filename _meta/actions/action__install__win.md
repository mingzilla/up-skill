---
name: action__install__win.md
usage: drop the url of this file to your AI harness
---

## Install

Windows PowerShell (no admin, no python needed):

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__install.ps1 | iex"
```

It clones the workspace to `%USERPROFILE%\.upskill__workspace` and installs the two sharing skills
globally at `%USERPROFILE%\.claude\skills` (every Claude Code session).

## Further Info

The installer asks one thing and does the rest:

| Prompt                 | Meaning                                                                          |
|------------------------|----------------------------------------------------------------------------------|
| Your upskill user name | the name you are listed under in the team address book, e.g. `myles`             |

For an unattended run, pass the answer instead:

```powershell
powershell -ExecutionPolicy Bypass -File upskill__install.ps1 -User myles
```

(The workspace stays under your profile; pass `-Dir <folder>` to place it elsewhere and
`-SkipGlobal` to skip the global Claude Code skill copy.)

> Requires [Git for Windows](https://git-scm.com/downloads/win) and a github login that can read
> the team's repos - the installer clones the address book and each member's sharing repo
> (`upskill` itself is public; those may stay private).

Then open Claude in `%USERPROFILE%\.upskill__workspace` and say `use upskill to ...`.
