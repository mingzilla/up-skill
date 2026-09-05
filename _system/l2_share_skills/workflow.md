## Structure

```text
├── upskill
│   ├── README.md
│   └── _system
└── upskill__users
    ├── pc__leah                        # this is leah's machine
    │   ├── projects                    # leah's local projects
    │   │   └── leah_local_project
    │   └── upskill__workspace
    │       ├── address_books
    │       │   └── team__sandbox       # each dir inside is a git repo connects to github
    │       │       ├── upskill__address_book__sandbox/address_book.json  # allows discovery to maintain this list - currently has real repos
    │       │       ├── upskill__skills_repo__leah          # synced with address book definition
    │       │       └── upskill__skills_repo__myles         # synced with address book definition
    │       └── upskill__user-config.json   # defines e.g. which address book to use
    └── pc__myles
```

## Relationships

| A    | B                          | type        | Relationship | Reason                                                                                         |
|------|----------------------------|-------------|--------------|------------------------------------------------------------------------------------------------|
| User | Address Book               | git repo    | many to many | an advanced user can be in many teams, one setting in upskill__user-config.json to swap teams |
| User | Workspace                  | root folder | 1 to 1       | one pc, one workspace                                                                          |
| User | upskill__user-config.json |             | 1 to 1       | config allows a user to have an address book                                                   |

## Workflows

### The user journey for sharing

As an administrator, my workspace is upskill__admin_workspace, my address_books is exactly like any user's address book.
The difference is, I make changes to e.g. address book, and a user pulls it.

```text
- [leah] - "myles says he has a text-cleaner skill to share"
- [ming] - "let me get myles on the team and let you know"
- [ming] - updates address_book.json to include myles
- [ming] - gives myles upskill__install.sh to run
- [myles] - runs upskill__install.sh under ming's technical guiding
- [ming] - "myles, open claude and say `can you use upskill to share the text-cleaner skill`"
- [myles] - claude: "can you use upskill to share the text-cleaner skill"
- [upskill] - copy skill to upskill__skills_repo__myles -> commit "share text-cleaner" -> push
- [ming] - to leah: "leah, open claude and say `use upskill to add myles' text-cleaner to claude desktop`"
- [leah] - claude: "use upskill to add myles' text-cleaner to claude desktop"
- [leah] - her machine now has the text-cleaner skill to use
```

### Admin sharing skill

```text
  i'll need to think about how to share skills after we do this
  we need to allow registering a few places for skill lookup
  you should be able to share global skills and project skills
  also, an upskill skill (i still have not decided the name) should be added or symblinked
  into e.g. a claude code launch directory, e.g.,
  _teamwork_system/.claude/skills__upskill should symblink to somewhere, so that i can say
  use upskill to share the coding__general skill
  what would you suggest?
```

### User sharing skill

what do we do?

```text

```

### Default

```text
  i think the problem is more related to how do we know where upskill__admin_workspace is.
  at set up time, something needs to keep the path. otherwise we can't find it.
  if we can find it, then upskill__admin_workspace/ and its upskill__user-config.json
  already have everything needed to derive the correct info
  
 it cannot be at a fixed path e.g. ~/.upskill, think about
  E:\code\harness__upskill\upskill__users\pc__leah\.upskill__workspace

  i don't have to use symlink. symblink does not work in windows so it's not a good
  solution anyway.
  we copy the skill to the desired location, and add a config file in the skill directory
  to describe where the workspace is

  this means,
  whenever setting up a project or claude root, non-tech user will need some support.
  this is because a new project does not know where the workspace is
  a project that knows where the workspace is can pull the new version of the workspace and
  resolve the rest

```

```text
if someone in claude runs an  upskill ... (i don't know what name to use yet maybe upskill__client or upskill__user), it should list options: 
1) list available skills from our team address book, 
2) share a skill, 
3) add a skill from a team mate's shared skills

 - What should install.sh target for now?
   → let's get wsl to work for now. i will give this to windows user that have no wsl, but
   we can make a mirror ps1 installation script later
 - Where must Claude find the client skill after install, so the user can run 'use
   upskill ...' from any project?
   → for easiness, you and myles will just use upskill__workspace for now. once we prove
   that everything works, i will need to: 1) run one script using ps1, 2) use my windows
   claude desktop to get a skill from myles
```

### Feature Updates

```text
- [leah] - "ming, can we make sure we display user skills in a table"
- [ming] - "no problem, wait"
- [ming] - update upskill core solution
- [ming] - to leah "leah, give it a go"
- [leah] - to claude "use upskill to show me users and skills" (and since upskill__action__receive-skills pulls from the repo first to update itself)
- [claude] - shows result in expected format
```