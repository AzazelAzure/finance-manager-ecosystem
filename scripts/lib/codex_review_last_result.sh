#!/usr/bin/env bash
# codex_review_last_result.sh — read latest codex_review_log.jsonl entry for repo/pr
#
# Usage:
#   ./scripts/lib/codex_review_last_result.sh --repo parent|api|web --pr <N>
#
# Prints one JSON object to stdout (verdict, merged, confidence, ...).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_FILE="$REPO_ROOT/logs/codex_review_log.jsonl"

REPO_SLUG=""
PR_NUM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_SLUG="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  echo "Usage: codex_review_last_result.sh --repo parent|api|web --pr <N>" >&2
  exit 1
}

[[ -f "$LOG_FILE" ]] || {
  printf '{"verdict":"NEEDS_HITM","merged":false,"error":"log_missing"}\n'
  exit 0
}

python3 - "$LOG_FILE" "$REPO_SLUG" "$PR_NUM" <<'PY'
import json, sys
from pathlib import Path

log_path, repo, pr = sys.argv[1:4]
pr = int(pr)
last = None
for line in Path(log_path).read_text(errors="replace").splitlines():
    line = line.strip()
    if not line:
        continue
    try:
        row = json.loads(line)
    except json.JSONDecodeError:
        continue
    if row.get("repo") == repo and int(row.get("pr", -1)) == pr:
        last = row
if last is None:
    print(json.dumps({"verdict": "NEEDS_HITM", "merged": False, "error": "no_log_entry"}))
else:
    print(json.dumps(last))
PY
