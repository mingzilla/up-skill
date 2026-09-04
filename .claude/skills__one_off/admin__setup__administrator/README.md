## Structure

```text
├── up-skill
│   ├── README.md
│   └── _system
└── up-skill__users
    ├── pc__leah                        # this is leah's machine
    │   ├── projects                    # leah's local projects
    │   │   └── leah_local_project
    │   └── up-skill__workspace
    │       ├── address_books
    │       │   └── team__sandbox       # each dir inside is a git repo connects to github
    │       │       ├── up-skill__address_book__sandbox/address_book.json  # allows discovery to maintain this list - currently has real repos
    │       │       ├── up-skill__sharing__leah          # synced with address book definition
    │       │       └── up-skill__sharing__myles         # synced with address book definition
    │       └── up-skill__user-config.json   # defines e.g. which address book to use
    └── pc__myles
```

## Relationships

| A    | B                          | type        | Relationship | Reason                                                                                         |
|------|----------------------------|-------------|--------------|------------------------------------------------------------------------------------------------|
| User | Address Book               | git repo    | many to many | an advanced user can be in many teams, one setting in up-skill__user-config.json to swap teams |
| User | Workspace                  | root folder | 1 to 1       | one pc, one workspace                                                                          |
| User | up-skill__user-config.json |             | 1 to 1       | config allows a user to have an address book                                                   |

## Workflows

### The user journey for sharing

As an administrator, my workspace is up-skill__admin_workspace, my address_books is exactly like any user's address book.
The difference is, I make changes to e.g. address book, and a user pulls it.

```text
- [leah] - "myles says he has a text-cleaner skill to share"
- [ming] - "let me get myles on the team and let you know"
- [ming] - updates address_book.json to include myles
- [ming] - gives myles up-skill__install.sh to run
- [myles] - runs up-skill__install.sh under ming's technical guiding
- [ming] - "myles, open claude and say `can you use up-skill to share the text-cleaner skill`"
- [myles] - claude: "can you use up-skill to share the text-cleaner skill"
- [up-skill] - copy skill to up-skill__sharing__myles -> commit "share text-cleaner" -> push
- [ming] - to leah: "leah, open claude and say `use up-skill to add myles' text-cleaner to claude desktop`"
- [leah] - claude: "use up-skill to add myles' text-cleaner to claude desktop"
- [leah] - her machine now has the text-cleaner skill to use
```

### Admin sharing skill

```text
  i'll need to think about how to share skills after we do this
  we need to allow registering a few places for skill lookup
  you should be able to share global skills and project skills
  also, an up-skill skill (i still have not decided the name) should be added or symblinked
  into e.g. a claude code launch directory, e.g.,
  _teamwork_system/.claude/skills__up-skill should symblink to somewhere, so that i can say
  use up-skill to share the coding__general skill
  what would you suggest?
```

### User sharing skill

what do we do?

```text

```

### Default

```text
if someone in claude runs an  up-skill ... (i don't know what name to use yet maybe up-skill__client or up-skill__user), it should list options: 
1) list available skills from our team address book, 
2) share a skill, 
3) add a skill from a team mate's shared skills

 - What should install.sh target for now?
   → let's get wsl to work for now. i will give this to windows user that have no wsl, but
   we can make a mirror ps1 installation script later
 - Where must Claude find the client skill after install, so the user can run 'use
   up-skill ...' from any project?
   → for easiness, you and myles will just use up-skill__workspace for now. once we prove
   that everything works, i will need to: 1) run one script using ps1, 2) use my windows
   claude desktop to get a skill from myles
```