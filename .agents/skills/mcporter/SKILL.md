---
name: mcporter
description: Sets up and uses the mcporter CLI to list and call MCP servers from the shell. Use when a repository should start using mcporter, when an MCP tool is needed but not connected as a native tool, when scripting several MCP calls, or when the user mentions mcporter.
---

# mcporter

[mcporter](https://github.com/openclaw/mcporter) is a CLI for listing and calling MCP servers (HTTP, SSE and stdio) from the shell.

## Step 1: Make sure the repository is set up

From the repository root, check:

```bash
mcporter --version
test -f config/mcporter.json && echo "project config exists"
```

If either check fails, follow [references/setup.md](references/setup.md) completely before doing anything else. Do not call MCP tools through mcporter until setup is verified.

## Step 2: Use mcporter

Always run mcporter from the repository root. It only finds the project config at `./config/mcporter.json` relative to the working directory.

```bash
mcporter list                                   # all servers with status
mcporter list <server>                          # tool signatures for one server
mcporter list <server> --all-parameters         # include optional parameters
mcporter call <server>.<tool> key=value key2=value2
mcporter call '<server>.<tool>(key: "value", nested: {a: 1})'
mcporter call <server>.<tool> --args '{"key":"value"}'
mcporter call <server>.<tool> key=value --output json
```

- Run `mcporter list <server>` before the first call to a server to confirm tool names and required parameters.
- Use the function-call syntax or `--args` for objects and arrays.
- Use `--output json` when the result is parsed further.
- Servers with `"lifecycle": "keep-alive"` run in a background daemon: `mcporter daemon status|start|stop|restart`.

## Rules

- Prefer native MCP tools when the agent has them connected. Use mcporter when they are not, or when scripting many calls.
- Treat tool calls with side effects (create, update, delete, approve, comment, retry) as changes: describe them and get the user's confirmation first unless the user already asked for exactly that action.
- `auth required`: ask the user to run `mcporter auth <server>`. It opens a browser and cannot be completed by the agent.
- `offline` for a server that needs an environment variable: tell the user which variable is missing. Never search for, read, print or copy secrets yourself.
- Environment variables exported in the user's shell profile may be missing in a non-login agent shell. Retry with `zsh -lic '<command>'` or `bash -lc '<command>'` before concluding that a variable is missing.
- Stdio servers can dump their environment to stderr on failure. Redirect stderr (`2>/dev/null`) when a server holds secrets, and never paste such output into the conversation.
- Do not put secrets in `config/mcporter.json`. Reference them as `${VAR}`.
- Keep `config/mcporter.json` strict JSON without comments.
