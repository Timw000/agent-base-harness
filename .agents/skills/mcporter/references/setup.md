# mcporter setup

Follow every step in order. When all steps pass, mcporter is ready to use in the repository.

Work from the repository root:

```bash
cd "$(git rev-parse --show-toplevel)"
```

## 1. Install mcporter globally

```bash
node --version      # mcporter 0.9 requires Node >= 20.11
mcporter --version  # skip installation if this already works
npm install -g mcporter
mcporter --version
```

If the global install fails because of permissions, stop and tell the user. Do not use `sudo`.

## 2. Understand how mcporter finds config

Facts to keep in mind for the remaining steps:

- The project config must be exactly `config/mcporter.json`, relative to the working directory. A `.jsonc` file is not read for the project.
- The personal config is `~/.mcporter/mcporter.json` (or `.jsonc`). It applies to every repository.
- Both files are merged: home first, then project. Project entries win on name clashes.
- Each config file without an `"imports"` key also merges the MCP configs of Cursor, Claude Code/Desktop, Codex, Windsurf, OpenCode and VS Code. `"imports": []` turns that off for that file only. A home config without `"imports": []` therefore still pulls in editor servers, even if the project config sets `"imports": []`.
- Stdio servers run with the directory of the config file as working directory. In the project config that is `config/`, so repository scripts are referenced as `../path/to/script.sh`.
- `${VAR}` and `${VAR:-default}` are expanded in `env` and `headers` values only, not in `command` or `args`.

## 3. Inventory existing MCP servers

```bash
mcporter config list
```

This prints a summary of editor config files that mcporter can see, with server names. To look at one source:

```bash
mcporter config import cursor
mcporter config import claude-code
mcporter config import codex
```

Also look for MCP config files inside the repository, for example `.mcp.json`, `.cursor/mcp.json`, `.vscode/mcp.json` and `.claude/settings.json`, and for project scripts that start an MCP server.

Only note server names, transport, URL or command, and the names of required environment variables or headers. Editor configs often contain tokens in plain text: do not print or copy env or header values.

## 4. Decide which servers belong to the project

A server belongs in `config/mcporter.json` when everyone working in the repository needs it, for example a server built in this repository, the repository's issue tracker, or its Git host project. Personal or cross-project servers belong in `~/.mcporter/mcporter.json` or nowhere.

If it is unclear which servers to include, ask the user, one question at a time, and propose a list.

## 5. Create `config/mcporter.json`

Write strict JSON without comments. Template:

```json
{
  "mcpServers": {
    "remote-server": {
      "description": "What it is and what it needs",
      "baseUrl": "https://example.com/mcp"
    },
    "oauth-server": {
      "description": "Requires a one-time `mcporter auth oauth-server`",
      "baseUrl": "https://example.com/mcp",
      "auth": "oauth"
    },
    "token-server": {
      "description": "Requires EXAMPLE_TOKEN in the environment",
      "command": "npx",
      "args": ["-y", "example-mcp@latest"],
      "env": {
        "EXAMPLE_TOKEN": "${EXAMPLE_TOKEN}",
        "npm_config_loglevel": "error"
      }
    },
    "local-server": {
      "description": "Built from this repository",
      "command": "../scripts/start-mcp.sh",
      "args": [],
      "lifecycle": "keep-alive"
    }
  },
  "imports": []
}
```

Guidelines:

- Set `"imports": []` so the project config is explicit and does not depend on each developer's editor setup.
- Secrets always go in as `${VAR}`. Never write a literal token, and do not use `mcporter config import --copy` for entries that contain secrets, because it copies values verbatim.
- Use `"auth": "oauth"` for hosted servers that require a browser login.
- Use `"lifecycle": "keep-alive"` for stdio servers that are slow to start (JVM, builds, browsers) so the daemon keeps them warm.
- Add `"npm_config_loglevel": "error"` to `npx`-based servers to keep npm noise out of stdio.
- A `description` that names the requirement (env var or auth) makes `mcporter list` self-explanatory.

`mcporter config add --scope project` can also write entries, for example:

```bash
mcporter config add my-server --url https://example.com/mcp --auth oauth --description "..." --scope project
mcporter config add my-server --command npx --arg -y --arg example-mcp@latest --env 'EXAMPLE_TOKEN=${EXAMPLE_TOKEN}' --scope project --dry-run
```

Use `--dry-run` first, and add `"imports": []` by hand afterwards.

## 6. Make sure the config is committed

```bash
git check-ignore -v config/mcporter.json
```

No output means the file is not ignored. If a pattern ignores it, add `!config/mcporter.json` to `.gitignore` after that pattern. Confirm the file contains no secrets before it is committed. Do not commit unless the user asks.

## 7. Environment variables

List every `${VAR}` used in `config/mcporter.json`. For each variable that is not set, tell the user to export it in their shell profile (for example `~/.zshrc`). Do not read, look up, copy or print the value yourself.

To check whether a variable is available without printing it:

```bash
zsh -lic 'test -n "$EXAMPLE_TOKEN" && echo set || echo missing'
```

## 8. OAuth

For every server with `"auth": "oauth"`, tell the user to run once:

```bash
mcporter auth <server>
```

Tokens are cached under `~/.mcporter/`. The agent cannot complete this step.

## 9. Verify

```bash
mcporter config doctor
mcporter list
```

`config doctor` should report the project config and `Config looks good.` For each server in `mcporter list`:

| Status            | Action                                                                                                   |
|-------------------|----------------------------------------------------------------------------------------------------------|
| `N tools`         | Healthy. Run one read-only call to confirm, for example a list or search tool.                            |
| `auth required`   | Step 8.                                                                                                  |
| `offline`         | Usually a missing env var (step 7, retry with `zsh -lic`) or a wrong `command` path (relative to `config/`). |
| HTTP/SSE error    | Check the URL. Some servers redirect `/mcp` to `/mcp/`; try with a trailing slash.                         |
| Timeout           | Slow start. Retry with `MCPORTER_LIST_TIMEOUT=120000`, and consider `"lifecycle": "keep-alive"`.         |

Use `--log-level debug` only for servers without secrets, and redirect stderr for those that have them.

## 10. Tell agents about it

If the repository has an agent instruction file (`AGENTS.md`, `CLAUDE.md` or similar), add a short note that MCP servers are configured in `config/mcporter.json` and called through the `mcporter` skill. Ask the user before creating such a file if none exists.

## 11. Report to the user

Summarize:

- Whether mcporter was installed or already present, and its version.
- The servers in `config/mcporter.json` and their status from `mcporter list`.
- Environment variables the user must export.
- `mcporter auth` commands the user must run.
- Files that were created or changed (not committed).
