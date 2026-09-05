---
name: upskill
description: On-demand entry to share and receive skills over a team address book. Invoke ONLY when the user explicitly says "use upskill", "/upskill", or "upskill ...". Do not pick this up unprompted - trigger words: "use upskill to <verb>", "/upskill", "upskill".
---

# upskill

An on-demand menu. When the user invokes upskill (they say "use upskill ...", "/upskill", or ask what
upskill can do), do exactly this - no improvising:

1. Run this skill's show-menu script and print its output **verbatim**:

   - bash (mac / linux / WSL): `bash <this-skill>/actions/action__show_menu/scripts/upskill__show_menu.sh`
   - PowerShell (native Windows): `powershell -NoProfile -ExecutionPolicy Bypass -File <this-skill>/actions/action__show_menu/scripts/upskill__show_menu.ps1`

   `<this-skill>` is the folder holding this SKILL.md.

2. The menu lists the address book + four options. Take the user's next message as their pick and
   route it (do not re-run git yourself):

   | Pick / phrase | Route to |
   |---|---|
   | menu, help, repeat | print the menu again (step 1) |
   | 1 - add or change address book | read `actions/action__manage_address_book/actions.md` and follow it |
   | 2 - "show <member>'s skills" | run `upskill__list.sh <member>` (ask which member if none named); the numbered list maps to "Add <n> to <target>" |
   | 3 - "add <member>'s <skill>" | read `actions/action__receive_skills/actions.md` (add with `--project`) |
   | 4 - "share my <skill>" | read `actions/action__provide_skills/actions.md` |
   | "install <github-url>" | read `actions/action__receive_skills/actions.md` (install) |

3. If the reply is not a clear pick, ask which option. Report the outcome in one line.
