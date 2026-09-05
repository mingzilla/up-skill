---
name: upskill
description: Top-level upskill entry - present the sharing options and act on the user's pick. Triggered by "upskill", "what can upskill do", "upskill menu", "show upskill options".
---

# upskill

When the user says "upskill" without a clear verb (or asks what upskill can do), show this numbered
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
| 1 | `upskill__action__provide-skills` | the skill to share (+ optional message) |
| 2 | `upskill__action__receive-skills` | list |
| 3 | `upskill__action__receive-skills` | add `<owner>` `<skill>` `<target-dir>` (ask for the project if not given) |
| 4 | `upskill__action__receive-skills` | install `<url>` [target] |

If the reply is not a clear pick, ask which option. Report the outcome in one line.
