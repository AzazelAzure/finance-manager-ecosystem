#!/usr/bin/env bash
# transcript_pattern_scan.sh — count recurring patterns in Cursor agent transcripts.
#
# Usage:
#   ./scripts/dev/transcript_pattern_scan.sh
#   ./scripts/dev/transcript_pattern_scan.sh --days 7
#   ./scripts/dev/transcript_pattern_scan.sh --patterns 'git status|gh pr|queue_push'
#   ./scripts/dev/transcript_pattern_scan.sh --out strategy/automations/reports/pattern_scan.md
#
# Transcript root (override):
#   CURSOR_TRANSCRIPT_DIR=~/.cursor/projects/<project>/agent-transcripts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
DAYS=14
OUT=""
PATTERNS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --days) DAYS="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --patterns) PATTERNS="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; exit 1 ;;
  esac
done

TRANSCRIPT_DIR="${CURSOR_TRANSCRIPT_DIR:-$HOME/.cursor/projects/home-pproctor-Hive-Financial-Manager-HFM/agent-transcripts}"

if [[ ! -d "$TRANSCRIPT_DIR" ]]; then
  printf 'Error: transcript dir not found: %s\n' "$TRANSCRIPT_DIR" >&2
  exit 1
fi

export TRANSCRIPT_DIR DAYS PATTERNS BASE_DIR
python3 <<'PY'
import json
import os
import re
from collections import Counter
from datetime import datetime, timedelta, timezone
from pathlib import Path

transcript_dir = Path(os.environ["TRANSCRIPT_DIR"])
days = int(os.environ["DAYS"])
custom = os.environ.get("PATTERNS", "").strip()
base_dir = Path(os.environ["BASE_DIR"])

cutoff = datetime.now(timezone.utc) - timedelta(days=days)

default_patterns = [
    ("git status / diff", r"git status|git diff"),
    ("gh pr ops", r"gh pr"),
    ("session_brief.sh direct", r"session_brief\.sh"),
    ("MCP CallMcpTool", r"CallMcpTool|call_mcp"),
    ("queue_push / ws_dispatch", r"queue_push|ws_dispatch"),
    ("ws_review", r"ws_review"),
    ("changelog_entry", r"changelog_entry"),
    ("plan_lookup / find plans", r"plan_lookup|find .*/plans/"),
    ("test_api env boilerplate", r"SECRET_KEY=.*pytest|SECRET_KEY=.*manage\.py"),
    ("uv run pytest direct", r"uv run pytest"),
    ("npm test / build direct", r"npm (run )?(test|build)"),
    ("anomaly_new / anomalies/", r"anomaly_new|strategy/anomalies/"),
    ("skill-gap-detection", r"skill-gap-detection"),
    ("inline PYEOF parser", r"python3 <<.?PY"),
]

if custom:
    patterns = [("custom", custom)]
else:
    patterns = default_patterns

compiled = [(label, re.compile(pat, re.I)) for label, pat in patterns]

session_files = []
for root, _dirs, files in os.walk(transcript_dir):
    if "subagents" in root.split(os.sep):
        continue
    for name in files:
        if not name.endswith(".jsonl"):
            continue
        path = Path(root) / name
        try:
            mtime = datetime.fromtimestamp(path.stat().st_mtime, tz=timezone.utc)
        except OSError:
            continue
        if mtime >= cutoff:
            session_files.append((mtime, path))

session_files.sort(key=lambda x: x[0], reverse=True)
counts = Counter()
session_hits = Counter()
lines_scanned = 0

for _mtime, path in session_files:
    sid = path.parent.name
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        continue
    lines_scanned += text.count("\n")
    for label, rx in compiled:
        n = len(rx.findall(text))
        if n:
            counts[label] += n
            session_hits[label] += 1

gen = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
lines = [
    f"# Transcript pattern scan",
    "",
    f"**Generated (UTC):** {gen}",
    f"**Window:** last {days} days (mtime filter)",
    f"**Transcript dir:** `{transcript_dir}`",
    f"**Sessions scanned:** {len(session_files)}",
    f"**Lines scanned (approx):** {lines_scanned}",
    "",
    "## Pattern counts",
    "",
    "| Pattern | Total hits | Sessions with ≥1 hit |",
    "| --- | ---: | ---: |",
]
for label, _rx in compiled:
    lines.append(f"| {label} | {counts[label]} | {session_hits[label]} |")

lines.extend([
    "",
    "## Recent sessions",
    "",
])
for mtime, path in session_files[:15]:
    lines.append(f"- `{path.parent.name}` — {mtime.strftime('%Y-%m-%d %H:%M UTC')}")

report = "\n".join(lines) + "\n"
print(report)

out = os.environ.get("OUT", "").strip()
if out:
    out_path = Path(out)
    if not out_path.is_absolute():
        out_path = base_dir / out_path
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(report, encoding="utf-8")
    print(f"Wrote {out_path}", flush=True)
PY
