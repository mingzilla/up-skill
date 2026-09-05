# action__show_menu

Print the `/upskill` home screen (address books + the four options). Read-only - nothing else.

Run this action's script, then print its stdout **verbatim as the whole reply** - no bullet point,
no heading, no added summary before or after. The script's output already ends with the options.

- bash (mac / linux / WSL): `bash <this-skill>/actions/action__show_menu/scripts/upskill__show_menu.sh`
- PowerShell (native Windows): `powershell -NoProfile -ExecutionPolicy Bypass -File <this-skill>/actions/action__show_menu/scripts/upskill__show_menu.ps1`

`<this-skill>` is the folder holding the upskill SKILL.md. Run from the workspace, or with
`UP_SKILL_WORKSPACE` set to it.
