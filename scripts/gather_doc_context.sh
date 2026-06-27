#!/usr/bin/env bash
# gather_doc_context.sh
#
# Gathers raw data for the Antigravity daily_doc_sweep automation.
# Run this before the daily doc sweep so Antigravity reads facts
# rather than inferring them.
#
# Usage:
#   ./scripts/gather_doc_context.sh
#
# Cron (run 15 min before Antigravity daily sweep fires):
#   45 4 * * * GH_TOKEN="$(cat ~/.config/fm_gh_token 2>/dev/null)" /home/pproctor/Documents/python/finance_manager/scripts/gather_doc_context.sh >> /tmp/gather_doc_context.log 2>&1
#
# gh auth one-time setup for cron (run once interactively):
#   gh auth token > ~/.config/fm_gh_token && chmod 600 ~/.config/fm_gh_token
#
# Output: strategy/automations/context/daily_context.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# gh auth: resolve token for cron environments where keyring is unavailable.
# Interactive runs use the keyring directly; cron reads from ~/.config/fm_gh_token.
if [[ -z "${GH_TOKEN:-}" ]]; then
  TOKEN_FILE="$HOME/.config/fm_gh_token"
  if [[ -f "$TOKEN_FILE" ]]; then
    export GH_TOKEN
    GH_TOKEN="$(cat "$TOKEN_FILE")"
  fi
fi
CONTEXT_DIR="$REPO_ROOT/strategy/automations/context"
OUTPUT="$CONTEXT_DIR/daily_context.md"

mkdir -p "$CONTEXT_DIR"

TIMESTAMP=$(date -Iseconds)
DATE=$(date +%Y-%m-%d)

{
  echo "# Daily Doc Context — $DATE"
  echo "Generated: $TIMESTAMP"
  echo "Source: scripts/gather_doc_context.sh"
  echo ""
  echo "---"
  echo ""

  echo "## Git Log — Parent (last 24h)"
  (cd "$REPO_ROOT" && git log --since="24 hours ago" --oneline 2>/dev/null) || echo "(no commits)"
  echo ""

  echo "## Git Log — API (last 24h)"
  (cd "$REPO_ROOT/finance_manager_api" && git log --since="24 hours ago" --oneline 2>/dev/null) || echo "(submodule not available)"
  echo ""

  echo "## Git Log — Web (last 24h)"
  (cd "$REPO_ROOT/finance_manager_web" && git log --since="24 hours ago" --oneline 2>/dev/null) || echo "(submodule not available)"
  echo ""

  echo "## Open PRs — Parent"
  (cd "$REPO_ROOT" && gh pr list --state open 2>/dev/null) || echo "(gh CLI not available)"
  echo ""

  echo "## Merged PRs — Parent (last 30)"
  (cd "$REPO_ROOT" && gh pr list --state merged --limit 30 2>/dev/null) || echo "(gh CLI not available)"
  echo ""

  echo "## Merged PRs — API (last 20)"
  (cd "$REPO_ROOT/finance_manager_api" && gh pr list --state merged --limit 20 2>/dev/null) || echo "(not available)"
  echo ""

  echo "## Merged PRs — Web (last 20)"
  (cd "$REPO_ROOT/finance_manager_web" && gh pr list --state merged --limit 20 2>/dev/null) || echo "(not available)"
  echo ""

  echo "## Plan Registry — Draft/Planning Section"
  awk '/^## Draft \/ Planning/,/^## Paused/' "$REPO_ROOT/governance/plan_registry.md" 2>/dev/null \
    || echo "(plan_registry.md not found)"
  echo ""

  echo "## Plan Registry — In Progress Section"
  awk '/^## In Progress/,/^## Ready for Execution/' "$REPO_ROOT/governance/plan_registry.md" 2>/dev/null \
    || echo "(not found)"
  echo ""

  echo "## Runtime Signup Sheet — Current VPS State"
  head -60 "$REPO_ROOT/design_docs/30_Releases/Runtime_Signup_Sheet.md" 2>/dev/null \
    || echo "(Runtime_Signup_Sheet.md not found)"
  echo ""

  echo "## Stale Pattern Scan — design_docs/"
  echo ""

  echo "### Reflex referenced as active (excludes _historical/, .trash/)"
  MATCHES="$(grep -rn "Reflex" "$REPO_ROOT/design_docs" --include="*.md" \
    | grep -v "_historical\|\.trash\|[Aa]rchiv\|reflex:Archived\|Reflex archived\|history" \
    | grep -v "^Binary" | head -25 || true)"
  if [[ -n "$MATCHES" ]]; then printf '%s\n' "$MATCHES"; else echo "(none found)"; fi
  echo ""

  echo "### Old branch prefix cursor/s1b"
  MATCHES="$(grep -rn "cursor/s1b" "$REPO_ROOT/design_docs" --include="*.md" | head -10 || true)"
  if [[ -n "$MATCHES" ]]; then printf '%s\n' "$MATCHES"; else echo "(none found)"; fi
  echo ""

  echo "### Slack bridge references"
  MATCHES="$(grep -rn -i "slack.bridge\|slack_bridge" "$REPO_ROOT/design_docs" --include="*.md" | head -10 || true)"
  if [[ -n "$MATCHES" ]]; then printf '%s\n' "$MATCHES"; else echo "(none found)"; fi
  echo ""

  echo "### orchestrator.py as active tool"
  MATCHES="$(grep -rn "orchestrator" "$REPO_ROOT/design_docs" --include="*.md" \
    | grep -v "_historical" | head -10 || true)"
  if [[ -n "$MATCHES" ]]; then printf '%s\n' "$MATCHES"; else echo "(none found)"; fi
  echo ""

  echo "### fm_docker.sh references (deprecated — now fm_server_beta.sh)"
  MATCHES="$(grep -rn "fm_docker" "$REPO_ROOT/design_docs" --include="*.md" | head -10 || true)"
  if [[ -n "$MATCHES" ]]; then printf '%s\n' "$MATCHES"; else echo "(none found)"; fi
  echo ""

  echo "## current_status.md — Header (last-updated check)"
  head -5 "$REPO_ROOT/strategy/current_status.md" 2>/dev/null || echo "(not found)"
  echo ""

} > "$OUTPUT"

LINE_COUNT=$(wc -l < "$OUTPUT")
echo "[gather_doc_context] Written: $OUTPUT ($LINE_COUNT lines) at $TIMESTAMP"
