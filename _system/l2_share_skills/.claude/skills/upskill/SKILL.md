---
name: upskill
description: Top-level up-skill entry - present the sharing options and act on the user's pick. Triggered by "up-skill", "what can up-skill do", "up-skill menu", "show up-skill options".
---

# upskill

When the user says "up-skill" without a clear verb (or asks what up-skill can do), show this numbered
menu, then take their next message as the selection:

```text
1  share a skill   - publish one of your skills to your own repo
2  list skills     - what has the team shared
3  get a skill     - add <owner>'s <skill> into a project
4  install         - bring skills from any github repo
```

Then act on their reply. A reply may be a number plus details - e.g. `3 from leah, beautiful_skill`
means "option 3: add leah's beautiful_skill". Map and delegate to the owning skill (do not re-run
git yourself):

| Pick | Delegate to | With |
|---|---|---|
| 1 | `up-skill__sharing__provide-skills` | the skill to share (+ optional message) |
| 2 | `up-skill__sharing__receive-skills` | list |
| 3 | `up-skill__sharing__receive-skills` | add `<owner>` `<skill>` `<target-dir>` (ask for the project if not given) |
| 4 | `up-skill__sharing__receive-skills` | install `<url>` [target] |

If the reply is not a clear pick, ask which option. Report the outcome in one line.
