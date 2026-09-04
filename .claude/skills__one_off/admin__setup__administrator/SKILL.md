## Structure

```text
|-- up-skill
|   +-- _system
|
|-- up-skill__users
|   |-- pc__leah                        # this is leah's machine
|   |   |-- projects
|   |   |   +-- leah_local_project
|   |   |
|   |   +-- up-skill__workspace
|   |   |   +-- up-skill__sharing
|   |   +-- up-skill__user-config.json  # defines which address book to use
|   |
|   +-- pc__myles
```

## Relationships

| A    | B                          | type        | Relationship | Reason                                                                                         |
|------|----------------------------|-------------|--------------|------------------------------------------------------------------------------------------------|
| User | Address Book               | git repo    | many to many | an advanced user can be in many teams, one setting in up-skill__user-config.json to swap teams |
| User | Workspace                  | root folder | 1 to 1       | one pc, one workspace                                                                          |
| User | up-skill__user-config.json |             | 1 to 1       | config allows a user to have an address book                                                   |

## Workflows

### Sharing
