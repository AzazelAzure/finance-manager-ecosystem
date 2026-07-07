#!/usr/bin/env bash
# codex_review_t4_kb8_validate.sh — KB8 gate re-validation after T2A-REVISED (CODEX-REVIEW-T4)
#
# Usage:
#   ./scripts/ops/codex_review_t4_kb8_validate.sh [--live] [--known-bad-pr <N>]
#
# Default known-bad PR: parent #110 (T3 seed). Dry-run validates wrapper gate without Codex API.
# --live adds codex-review:pending label and runs full codex_review.sh (requires Codex CLI).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

KNOWN_BAD_PR=110
LIVE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --live) LIVE=1; shift ;;
    --known-bad-pr)
      [[ $# -ge 2 ]] || { echo "ERROR: --known-bad-pr requires value" >&2; exit 1; }
      KNOWN_BAD_PR="$2"
      shift 2
      ;;
    -h|--help)
      sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

LOG_DIR="$REPO_ROOT/logs"
RESULT_FILE="$LOG_DIR/t4_kb8_revalidation_$(date -u +%Y%m%dT%H%M%SZ).json"
mkdir -p "$LOG_DIR"

runfile="$(mktemp)"
stderrfile="$(mktemp)"
trap 'rm -f "$runfile" "$stderrfile"' EXIT

printf 'T4 KB8 revalidation: known-bad parent PR #%s live=%s\n' "$KNOWN_BAD_PR" "$LIVE"

if ! "$REPO_ROOT/scripts/ops/codex_review.sh" \
  --repo parent --pr "$KNOWN_BAD_PR" --mode governance --dry-run \
  >"$runfile" 2>"$stderrfile"; then
  printf 'FAIL: dry-run codex_review exited non-zero\n' >&2
  cat "$stderrfile" >&2
  exit 1
fi

if ! grep -q 'Known-bad KB8 seed' "$stderrfile"; then
  printf 'FAIL: expected Known-bad KB8 seed detection in stderr\n' >&2
  cat "$stderrfile" >&2
  exit 1
fi

if grep -qi 'would post REQUEST_CHANGES' "$stderrfile" "$runfile"; then
  printf 'FAIL: KB8 gate routed to REQUEST_CHANGES (expected NEEDS_HITM floor path)\n' >&2
  exit 1
fi

if ! grep -q 'DRY-RUN: temp dir preserved' "$runfile"; then
  printf 'FAIL: dry-run did not reach Codex prompt stage\n' >&2
  exit 1
fi

verdict="DRY_RUN_PASS"
live_note="skipped"

if [[ "$LIVE" -eq 1 ]]; then
  gh pr edit "$KNOWN_BAD_PR" \
    --repo AzazelAzure/finance-manager-ecosystem \
    --add-label "codex-review:pending" 2>/dev/null || true

  live_out="$(mktemp)"
  if ! "$REPO_ROOT/scripts/ops/codex_review.sh" \
    --repo parent --pr "$KNOWN_BAD_PR" --mode governance \
    >"$live_out" 2>&1; then
    printf 'FAIL: live codex_review exited non-zero\n' >&2
    cat "$live_out" >&2
    exit 1
  fi

  if ! grep -q 'NEEDS_HITM' "$live_out"; then
    printf 'FAIL: live run missing NEEDS_HITM verdict\n' >&2
    cat "$live_out" >&2
    exit 1
  fi
  verdict="NEEDS_HITM"
  live_note="executed"
  rm -f "$live_out"
fi

python3 - "$RESULT_FILE" "$KNOWN_BAD_PR" "$verdict" "$live_note" <<'PY'
import json, sys
from datetime import datetime, timezone

out, pr, verdict, live = sys.argv[1:5]
payload = {
    "task_id": "CODEX-REVIEW-T4-KB8-REVALIDATION",
    "ts": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "known_bad_pr": int(pr),
    "kb8_gate": "PASS",
    "verdict": verdict,
    "live_run": live,
    "notes": "T2A-REVISED merged; wrapper detects known-bad seed and floors NEEDS_HITM",
}
Path = __import__("pathlib").Path
Path(out).write_text(json.dumps(payload, indent=2) + "\n")
print(out)
PY

printf 'KB8 revalidation PASS (verdict=%s live=%s)\n' "$verdict" "$live_note"
printf 'Result: %s\n' "$RESULT_FILE"
