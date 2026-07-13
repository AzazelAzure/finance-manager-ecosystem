#!/usr/bin/env bash
# gemini_confer.sh — Dispatch a synchronous advisory query to Claude during meeting facilitation.
#
# Usage:
#   gemini_confer.sh claude "<question>" [meeting_dir]
#   gemini_confer.sh codex  "<question>"            (direct CLI call)
#   gemini_confer.sh cursor "<task>"                (prints async queue instruction)
#
# Returns: agent response on stdout
# Side effect: appends exchange to <meeting_dir>/confer_log.md
#
# Design notes:
# - Claude: --bare + --no-session-persistence avoids MCP approval hangs. Read-only constrained.
# - Codex: direct `codex` CLI call (synchronous for short questions).
# - Cursor: async only (ws_dispatch.sh); this tool prints the dispatch command instead.
# - This script is a Track 1 seed — governance/workflow system (2026-07-13 Three-Track Expansion).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

AGENT="${1:-}"
QUESTION="${2:-}"
MEETING_DIR="${3:-}"

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") <claude|codex|cursor> "<question>" [meeting_dir]

  claude   Synchronous advisory query. Returns answer to stdout. Read-only.
  codex    Synchronous question via codex CLI. Returns answer to stdout.
  cursor   Async only. Prints the ws_dispatch.sh command to run instead.

Examples:
  $(basename "$0") claude "What is the current status of OPS-REVAMP-T09?"
  $(basename "$0") codex "Does the three-track framing conflict with S1.B exit criteria?"
  $(basename "$0") cursor "implement gate_override_log.sh per OPS-REVAMP-T09 spec"
EOF
    exit 1
}

[[ -z "$AGENT" || -z "$QUESTION" ]] && usage

# Detect current meeting dir from most-recent MINUTES.md if not provided
if [[ -z "$MEETING_DIR" ]]; then
    MEETING_DIR=$(find "$REPO_ROOT/strategy/meetings" -name "MINUTES.md" 2>/dev/null \
        | sort | tail -1 | xargs -I{} dirname {} 2>/dev/null || echo "$REPO_ROOT")
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
LOG="$MEETING_DIR/confer_log.md"

# Initialize log on first use
if [[ ! -f "$LOG" ]]; then
    cat > "$LOG" <<EOF
# Confer Log — $(basename "$MEETING_DIR")

> Append-only. Written by gemini_confer.sh. One block per query.

EOF
fi

log_exchange() {
    local agent="$1" question="$2" response="$3"
    {
        printf '\n---\n\n'
        printf '## [%s] → %s\n\n' "$TIMESTAMP" "$agent"
        printf '**Q:** %s\n\n' "$question"
        printf '**A:**\n\n%s\n\n' "$response"
    } >> "$LOG"
}

case "$AGENT" in
    claude)
        SYSTEM_CONTEXT="You are Claude Code in read-only advisory mode for a meeting facilitation session. \
The meeting facilitator (Gemini) is asking for governance, admin, or planning input. \
Role: admin and governance only — no code implementation. \
Constraint: do not suggest modifying files during this query. Read files to look up facts; do not write. \
Respond in ≤ 200 words unless more detail is explicitly needed. \
Current meeting artifacts are under: $MEETING_DIR \
MINUTES.md in that directory has the live session state."

        FULL_PROMPT="[Meeting facilitation query — $TIMESTAMP]
Facilitator: Gemini
Repo: $REPO_ROOT

$QUESTION

Give your governance/admin/planning perspective. Be direct."

        RESPONSE=$(cd "$REPO_ROOT" && claude -p "$FULL_PROMPT" \
            --no-session-persistence \
            --append-system-prompt "$SYSTEM_CONTEXT" \
            --allowed-tools "Read" \
            2>/dev/null)
        ;;

    codex)
        RESPONSE=$(cd "$REPO_ROOT" && codex exec -s read-only "$QUESTION" 2>&1 || echo "[Codex error — see above]")
        ;;

    cursor)
        RESPONSE="[Cursor — async only] Queue a task with:
  bash scripts/workspace/ws_dispatch.sh cursor \"$QUESTION\"
Cursor does not support synchronous confer. Use ws_dispatch.sh for queue-based dispatch."
        echo "$RESPONSE" >&2
        ;;

    *)
        echo "Unknown agent: $AGENT. Use claude, codex, or cursor." >&2
        exit 1
        ;;
esac

# Print to stdout for Gemini to capture
echo "$RESPONSE"

# Append to session log
log_exchange "$AGENT" "$QUESTION" "$RESPONSE"
