---
name: up-skill__sharing__provide-skills
description: Share one of your skills with your team - publish it to your own skills repo. Triggered by "share this skill", "share my <skill>", "publish my <skill>". Outbound only.
---

# up-skill__sharing__provide-skills

Publish one skill (the user's choice) to their own skills repo so teammates can receive it.

## Find the workspace

The workspace path is stored in `${CLAUDE_PLUGIN_DATA}/config.json`, as JSON with a `workspace` key.
Read that file first.

- If it exists, use its `workspace` value as the workspace path below.
- If it is missing, the plugin has not been configured for this machine yet: tell the user to run
  the up-skill installer/setup (which sets the workspace) and stop.

## Resolve the skill

- `<skill>` may be a folder path that contains `SKILL.md`, or a skill name under a project's
  `.claude/skills`. Ask the user which skill and for an optional short message if unclear.

## Run it

Run the script from this skill, passing the workspace path as the environment:

```bash
UP_SKILL_WORKSPACE="<workspace path from config>" bash ${CLAUDE_SKILL_DIR}/scripts/up-skill__sharing__share.sh "<skill>" "<message>"
```

Do not improvise git. If the script says the skills repo is missing, tell the user to run the
installer. Report the result in one line.
