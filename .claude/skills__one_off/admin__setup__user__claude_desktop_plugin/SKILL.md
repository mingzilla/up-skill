# admin__setup__user__claude_desktop_plugin

Make up-skill available in the Claude Desktop app's Code tab (local sessions) via the up-skill
plugin. The plugin package (marketplace + plugin) lives in this skill's `assets/`:

```text
assets/.claude-plugin/marketplace.json
assets/plugins/up-skill-sharing/        # plugin.json + the two skills
```

## To distribute / install

1. (Admin) publish the plugin so users can install it from a marketplace: push the contents of
   `assets/` as the root of a github repo - `marketplace.json` must be at the repo root - then
   give users `owner/repo`.
2. (User) in Claude Desktop **Code** tab (local session), install at user scope:

   ```text
   /plugin marketplace add <owner>/<repo>
   /plugin install up-skill-sharing@<marketplace>
   ```

3. Workspace path is read from the plugin data config (`${CLAUDE_PLUGIN_DATA}/config.json`).

## Caveats

- Desktop **WSL sessions** do not support plugins - use the terminal CLI inside WSL for those.
- The Chat/Cowork tabs read claude.ai account skills, not this plugin (separate route).

## Result

`share this skill` / `get <owner>'s <skill>` work in Desktop Code-tab local sessions.
