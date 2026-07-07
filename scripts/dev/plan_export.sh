#!/usr/bin/env bash
# plan_export.sh — compact YAML plan summary for queue/review packets (OPS-REVAMP-T05)
#
# Usage:
#   ./scripts/dev/plan_export.sh --plan <PLAN_ID> [--task <TASK_ID>]
#   ./scripts/dev/plan_export.sh --plan OPS-REVAMP-2026-07-07 --print-path
#
# Writes: strategy/workspace/exports/<plan_id_sanitized>.yaml

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPORT_DIR="$REPO_ROOT/strategy/workspace/exports"

PLAN_ID=""
TASK_ID=""
PRINT_PATH=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --plan) PLAN_ID="$2"; shift 2 ;;
    --task) TASK_ID="$2"; shift 2 ;;
    --print-path) PRINT_PATH=1; shift ;;
    -h|--help)
      sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$PLAN_ID" ]] || { echo "Usage: plan_export.sh --plan <ID> [--task <TASK_ID>]" >&2; exit 1; }

mkdir -p "$EXPORT_DIR"
SAFE="$(printf '%s' "$PLAN_ID" | tr '/:' '__')"
OUT="$EXPORT_DIR/${SAFE}.yaml"

LOOKUP="$("$SCRIPT_DIR/plan_lookup.sh" "$PLAN_ID" 2>/dev/null || true)"
PLAN_ROOT="$(printf '%s' "$LOOKUP" | awk -F'path: ' '/path:/{print $2; exit}')"
TASK_FILE=""
if [[ -n "$TASK_ID" && -n "$PLAN_ROOT" ]]; then
  TASK_NUM="$(printf '%s' "$TASK_ID" | sed -n 's/.*\(T[0-9][0-9]*\).*/\1/p')"
  if [[ -n "$TASK_NUM" ]]; then
    TASK_FILE="$(find "$REPO_ROOT/$PLAN_ROOT/tasks" -maxdepth 1 -iname "*${TASK_NUM}*" 2>/dev/null | head -1 || true)"
  fi
fi

python3 - "$PLAN_ID" "$TASK_ID" "$PLAN_ROOT" "$TASK_FILE" "$OUT" <<'PY'
import sys
from pathlib import Path

plan_id, task_id, plan_root, task_file, out_path = sys.argv[1:6]
task_text = ""
if task_file and Path(task_file).is_file():
    task_text = Path(task_file).read_text(errors="replace")[:4000]

readme = ""
if plan_root:
    readme_path = Path(plan_root) if Path(plan_root).is_absolute() else Path.cwd() / plan_root
    readme_path = readme_path / "README.md"
    if readme_path.is_file():
        readme = readme_path.read_text(errors="replace")[:6000]

def grab(key: str, text: str) -> str:
    for line in text.splitlines():
        if line.lower().startswith(key.lower()):
            return line.split(":", 1)[-1].strip()
    return ""

yaml = f"""plan_id: {plan_id}
plan_root: {plan_root or 'unknown'}
status: {grab('status', readme) or 'unknown'}
target_repos: {grab('target_repos', readme) or 'unknown'}
task_id: {task_id or 'none'}
task_scope: |
  {task_text.replace(chr(10), chr(10) + '  ') if task_text else '  (no task file found)'}
out_of_scope: |
  (see plan README)
required_dod: |
  (see plan README and definition_of_done.md)
manual_gates: {grab('manual_gates', readme) or 'unknown'}
deployment_required: {grab('deployment', readme) or 'unknown'}
golden_rules_triggered: []
required_evidence: []
known_anomalies: []
export_sha256: pending
"""
Path(out_path).write_text(yaml)
print(out_path)
PY

if [[ "$PRINT_PATH" -eq 1 ]]; then
  printf '%s\n' "${OUT#$REPO_ROOT/}"
  exit 0
fi

sha="$(sha256sum "$OUT" | awk '{print $1}')"
python3 - "$OUT" "$sha" <<'PY'
from pathlib import Path
import sys
p, sha = Path(sys.argv[1]), sys.argv[2]
text = p.read_text()
text = text.replace("export_sha256: pending", f"export_sha256: {sha}")
p.write_text(text)
PY

printf 'Wrote %s (sha256=%s)\n' "${OUT#$REPO_ROOT/}" "$sha"
