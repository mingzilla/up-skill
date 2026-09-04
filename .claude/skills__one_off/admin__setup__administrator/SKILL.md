# admin__setup__administrator

You are the technical person. Read this only when doing a one-off setup; it is not used at runtime.

Everything below is a github repo:
- `mingzilla/up-skill` - this project (installer + `provide-skills` / `receive-skills` skills)
- one **address book** repo per team
- one **skills repo** per member (`up-skill__skills_repo__<member>`)

To start a team:
1. Create an address book repo similar to https://github.com/mingzilla/up-skill__address_book__sandbox (public example) - a repo holding `address_book.json` that maps each member name -> `{folder, repo}`.
2. Help each member create their own skills repo on their github account - guide them through `assets/up-skill__skills_repo__setup_instructions.md`, then add the repo URL they send you to the address book.
3. Give each non-technical member the installer `up-skill__install.sh` (see `admin__setup__user`).

Full notes: `README.md` in this folder (admin's own).
