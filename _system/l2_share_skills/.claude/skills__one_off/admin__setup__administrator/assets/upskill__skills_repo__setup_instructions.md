# upskill sharing repo - setup instructions

**For:** a team member (non-technical) who already has a github account.
**Done by:** the technical person guides the member through github's website - no command line needed.

**What this repo is for:** the place where the member's shared skills are published. Later, when
the member tells Claude "use upskill to share X", Claude copies X into this repo and uploads it;
other team members pull from it.

## Steps - the member does these, the technical person helps

1. Open https://github.com and sign in with their account.
2. Click "+" (top right) -> **New repository**.
3. Repository name: `upskill__skills_repo__<yourname>` (lowercase, no spaces), e.g. `upskill__skills_repo__myles`.
4. Visibility:
   - **Public** - anyone can read it. Simplest.
   - **Private** - use this when skills must stay inside the team; the member must then add the
     other team members (or the team) as collaborators so they can read it. The technical person helps.
5. Click **Create repository**.
6. Copy the repository URL (the `https://github.com/<account>/<repo>` address) and send it to the technical person.

The member does not need to put anything in the repo now - the upskill "share" verb uploads to it
later, from the member's own machine (their github login).

## What the technical person does next

Add the member to the team address book. In `address_book.json`, under `users`, add:

```json
"<membername>": {
  "folder": "upskill__skills_repo__<membername>",
  "repo": "<the URL the member sent>"
}
```

Then give the member the installer (see `admin__setup__user`).
