#!/usr/bin/env bash
# Start the HFM MCP server (stdio). Used by Cursor / Claude Code MCP config.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

export FM_PRIMARY_WORKSPACE="${FM_PRIMARY_WORKSPACE:-$REPO_ROOT}"
export PATH="${HOME}/.local/bin:/usr/bin:/bin:${PATH}"

cd "$SCRIPT_DIR"
exec uv run --quiet hfm-mcp
