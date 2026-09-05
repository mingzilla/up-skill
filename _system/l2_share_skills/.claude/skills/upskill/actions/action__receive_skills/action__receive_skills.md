# action__receive_skills

Bring a member's shared skill into a machine, and see what is available. Run the `.sh` with `bash`
(mac / linux / WSL) or the `.ps1` with PowerShell (native Windows). `<this-skill>` is the folder
holding the upskill SKILL.md; scripts live under `<this-skill>/actions/action__receive_skills/scripts/`.

## Verbs

| Verb | User says | Run |
|---|---|---|
| show skills | "show Andy's skills" | `upskill__list.sh "<owner>"` |
| add | "add Andy's say_hello skill" | `upskill__add.sh "<owner>" "<skill>" --project <scope>` |
| install | "install `<github-url>` into ..." | `upskill__install.sh "<url>" ["<target-dir>"]` |

### show a member's skills (menu option 2 - the wizard)

Run `upskill__list.sh "<owner>"` (ask which member if the user only says "show skills"). It prints
their skills numbered, e.g.:

```text
ming's skills:
  1  system__knowledge_map
  2  weather

say:  Add <number> to <project>    e.g. "Add 1 to my website project"
```

The user can then reply "Add <n> ...". Resolve `<n>` to the skill name by re-running the same list,
then do the **add** flow below.

### add a skill (menu option 3 - direct)

`upskill__add.sh "<owner>" "<skill>" --project <scope>` where `<scope>` is one of:

| `--project` | Copies the skill to |
|---|---|
| `global` | `~/.claude/skills/<skill>` - available in every session |
| `current` | this project's `.claude/skills/<skill>` |
| `<path>` | that project's `.claude/skills/<skill>` |

If the user did not name a target, **ask them** (global / this project / which project) - never guess
a path. `<owner>` must be a member the show/list output printed.

### install (no address book needed)

`upskill__install.sh "<url>" ["<target-dir>"]` - clones any github repo and copies its
`.claude/skills/*` (and top-level `SKILL.md` folders) into the target.

Do not improvise git. Report the result in one or two lines.
