## Structure

```text
|-- up-skill
|   |-- README.md
|   +-- _system
|
|-- up-skill__address_books
|   |-- up-skill__address_book__sandbox
|   +-- <other address books>
|
|-- up-skill__users
|   |-- README.md
|   |-- config.json                 # defines which address book to use
|   |-- pc__leah                    # this is leah's machine
|   |   |-- projects
|   |   |   |-- leah_local_project
|   |   |-- up-skill__workspace
|   |     |-- up-skill__sharing
|   +-- pc__myles
```

## Relationships

| A    | B            | Relationship | Reason                                                                          |
|------|--------------|--------------|---------------------------------------------------------------------------------|
| User | Address Book | many to many | an advanced user can be in many teams, one setting in config.json to swap teams |
| User | Workspace    | 1 to 1       | one pc, one workspace                                                           |
| User | config.json  | 1 to 1       | config allows a user to have an address book                                    |

## Workflows

### Sharing
