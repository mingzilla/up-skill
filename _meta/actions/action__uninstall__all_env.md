---
name: action__uninstall__all_env.md
usage: drop the url of this file to your AI harness
---

## Uninstall

Removes the global Claude Code skills and the workspace. Your github repos and projects are never touched.

Linux / WSL / macOS (bash):

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__uninstall.sh | bash -s -- --yes
```

Windows (PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -c "& ([scriptblock]::Create((irm https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__uninstall.ps1))) -Yes"
```

What it removes:

| Removed | Path |
|---|---|
| Global skill | `~/.claude/skills/upskill` (legacy `upskill__sharing__*` / `upskill__action__*` folders are also swept) |
| Workspace | `~/.upskill__workspace` (Windows: `%USERPROFILE%\.upskill__workspace`) |

> If the machine was installed with a custom location (`--home` / `-Dir`), delete that
> `.upskill__workspace` folder yourself - the uninstaller only touches the default profile location.
