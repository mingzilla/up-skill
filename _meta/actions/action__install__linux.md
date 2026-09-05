---
name: action__install__linux.md
usage: drop the url of this file to your AI harness
---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__install.sh | bash
```

## Further Info

The installer asks two things and does the rest:

| Prompt                                   | Meaning                                                                                   |
|------------------------------------------|-------------------------------------------------------------------------------------------|
| Your upskill user name                   | the name you are listed under in the team address book, e.g. `myles`                      |
| Where should the upskill workspace live? | a folder on your machine; `.upskill__workspace` is created inside it (default: your home) |

For an unattended run, pass the answers instead:

```bash
curl -fsSL https://raw.githubusercontent.com/mingzilla/upskill/main/upskill__install.sh | bash -s -- --user myles --home ~
```

> Requires a github login that can read the team's repos - the installer clones the address book and
> each member's sharing repo (`upskill` itself is public; those may stay private).
>
> Alternative if you keep a local copy: `git clone git@github.com:mingzilla/upskill.git && cd upskill && bash upskill__install.sh`.
