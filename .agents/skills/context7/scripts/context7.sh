#!/bin/bash
# Context7 REST API wrapper (fallback for when the Context7 MCP tool isn't connected)
# Based on netresearch/context7-skill (https://github.com/netresearch/context7-skill), MIT licensed.
# Usage: context7.sh <command> [args...]
# Commands:
#   search <query>                        - Search for library ID
#   docs <library-id> [topic] [mode]      - Fetch documentation

set -e

CONTEXT7_API_KEY="${CONTEXT7_API_KEY:-}"
BASE_URL="https://context7.com/api/v2"

search_library() {
  local query="$1"
  if [ -z "$query" ]; then
    echo "Usage: context7.sh search <query>"
    echo "Example: context7.sh search react"
    exit 1
  fi

  local encoded_query
  encoded_query=$(printf '%s' "$query" | jq -sRr @uri)
  local url="${BASE_URL}/search?query=${encoded_query}"

  echo "Searching for: $query"
  echo "---"

  local response
  if [ -n "$CONTEXT7_API_KEY" ]; then
    response=$(curl -s "$url" -H "Authorization: Bearer $CONTEXT7_API_KEY" -H "X-Context7-Source: agent-skill")
  else
    response=$(curl -s "$url" -H "X-Context7-Source: agent-skill")
  fi

  echo "$response" | jq -r '
    if .results then
      .results[] | "ID: \(.id)\nName: \(.title // "Unknown")\nSnippets: \(.totalSnippets // "N/A") | Score: \(.benchmarkScore // "N/A")\nDescription: \(.description // "No description")\n---"
    elif .error then
      "Error: \(.error)"
    else
      .
    end
  ' 2>/dev/null || echo "$response"
}

fetch_docs() {
  local library_id="$1"
  local topic="$2"
  local mode="${3:-code}"

  if [ -z "$library_id" ]; then
    echo "Usage: context7.sh docs <library-id> [topic] [mode]"
    echo ""
    echo "Arguments:"
    echo "  library-id  Format: /org/project or /org/project/version"
    echo "  topic       Optional: Focus area (e.g., 'hooks', 'routing')"
    echo "  mode        Optional: 'code' (default) or 'info'"
    echo ""
    echo "Examples:"
    echo "  context7.sh docs /facebook/react hooks"
    echo "  context7.sh docs /vercel/next.js routing code"
    echo "  context7.sh docs /vercel/next.js \"app router\" info"
    exit 1
  fi

  if [ "$mode" != "code" ] && [ "$mode" != "info" ]; then
    echo "Error: mode must be 'code' or 'info'"
    exit 1
  fi

  local cleaned_id="${library_id#/}"
  local url="${BASE_URL}/docs/${mode}/${cleaned_id}?type=txt"

  if [ -n "$topic" ]; then
    local encoded_topic
    encoded_topic=$(printf '%s' "$topic" | jq -sRr @uri)
    url="${url}&topic=${encoded_topic}"
  fi

  echo "Fetching docs: /$cleaned_id"
  echo "Mode: $mode${topic:+ | Topic: $topic}"
  echo "---"

  if [ -n "$CONTEXT7_API_KEY" ]; then
    curl -s "$url" -H "Authorization: Bearer $CONTEXT7_API_KEY" -H "X-Context7-Source: agent-skill"
  else
    curl -s "$url" -H "X-Context7-Source: agent-skill"
  fi
}

case "${1:-}" in
  search)
    shift
    search_library "$@"
    ;;
  docs)
    shift
    fetch_docs "$@"
    ;;
  -h|--help|help)
    echo "Context7 Documentation Lookup"
    echo ""
    echo "Usage: context7.sh <command> [args...]"
    echo ""
    echo "Commands:"
    echo "  search <query>                   Search for library ID"
    echo "  docs <library-id> [topic] [mode] Fetch documentation"
    echo ""
    echo "Modes:"
    echo "  code  API references and code examples (default)"
    echo "  info  Conceptual guides and tutorials"
    echo ""
    echo "Environment:"
    echo "  CONTEXT7_API_KEY  Optional API key for higher rate limits"
    echo "                    Get one at: https://context7.com/dashboard"
    exit 0
    ;;
  *)
    echo "Context7 Documentation Lookup"
    echo "Usage: context7.sh <command> [args...]"
    echo "Run 'context7.sh --help' for usage information"
    exit 1
    ;;
esac
