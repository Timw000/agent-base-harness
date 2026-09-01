---
name: context7
description: Look up current library/framework/API documentation and code examples via Context7 (React, Next.js, Vue, Django, Laravel, etc.). Use when the user asks how to use a library, requests API docs, framework patterns, or version-specific behavior for any package. Prefer the Context7 MCP tool if it's connected; otherwise use the bundled REST script fallback.
---

# Context7 Documentation Lookup

Fetch current, version-accurate library documentation and code examples instead of relying on training data, which may be outdated.

## When to use

- "How do I use `<library>`?", "`<library>` API docs", "`<library>` patterns"
- Import statements referencing a specific library
- Framework-specific topics: hooks, routing, middleware, ORM queries, schema definitions

Do NOT use for general programming concepts, code review, refactoring, or debugging business logic unrelated to a specific library's API.

## Step 1: Check for the Context7 MCP tool

Look for a dynamic tool namespace matching `context7` (e.g. `user-context7`) via `GetDynamicTools`. If it's connected, use its `resolve-library-id` and `query-docs` tools directly — do not use the script fallback below.

## Step 2: Fallback — REST script

If no Context7 MCP tool is connected, use the bundled script instead:

1. **Search** for the library ID:

   ```bash
   .agents/skills/context7/scripts/context7.sh search "library-name"
   ```

   Pick the best result: highest score, most relevant description, prefer official sources (e.g. `/vercel/next.js` over community forks).

2. **Fetch docs** with a focused topic extracted from the user's question (e.g. for "How does React Suspense work with server components?" use topic `suspense server components`):

   ```bash
   .agents/skills/context7/scripts/context7.sh docs "<library-id>" "<topic>" "<mode>"
   ```

   | Parameter | Required | Description |
   |-----------|----------|-------------|
   | `library-id` | Yes | From search results, format `/vendor/library` (or `/vendor/library/version`) |
   | `topic` | No | Focus area extracted from the user's question |
   | `mode` | No | `code` (default) for API references; `info` for conceptual guides |

### Examples

```bash
.agents/skills/context7/scripts/context7.sh search "react"
.agents/skills/context7/scripts/context7.sh docs "/facebook/react" "hooks" "code"

.agents/skills/context7/scripts/context7.sh search "nextjs"
.agents/skills/context7/scripts/context7.sh docs "/vercel/next.js" "app router" "info"

.agents/skills/context7/scripts/context7.sh search "laravel"
.agents/skills/context7/scripts/context7.sh docs "/laravel/framework" "eloquent relationships" "code"
```

### Requirements

`curl` and `jq` must be installed.

### Optional: higher rate limits

```bash
export CONTEXT7_API_KEY="your-api-key"
```

Get a key at https://context7.com/dashboard.

## Attribution

Script adapted from [netresearch/context7-skill](https://github.com/netresearch/context7-skill) (MIT).
