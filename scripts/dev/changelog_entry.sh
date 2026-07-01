#!/usr/bin/env bash
# changelog_entry.sh — insert an [Unreleased] changelog block (parent repo)
#
# Usage:
#   ./scripts/dev/changelog_entry.sh "Short title" "Cursor"
#   ./scripts/dev/changelog_entry.sh "Short title" "Claude Code" --repo api

set -euo pipefail

[[ $# -lt 2 ]] && {
  echo "Usage: changelog_entry.sh <title> <agent> [--repo parent|api|web]" >&2
  exit 1
}

TITLE="$1"
AGENT="$2"
TARGET="parent"
shift 2
while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) TARGET="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DATE="$(date +%Y-%m-%d)"

case "$TARGET" in
  parent) CL="$REPO_ROOT/CHANGELOG.md" ;;
  api) CL="$REPO_ROOT/finance_manager_api/CHANGELOG.md" ;;
  web) CL="$REPO_ROOT/finance_manager_web/CHANGELOG.md" ;;
  *) echo "Unknown --repo: $TARGET" >&2; exit 1 ;;
esac

[[ -f "$CL" ]] || { echo "Missing: $CL" >&2; exit 1; }

export CL TITLE AGENT DATE
python3 <<'PY'
from pathlib import Path
import os
path = Path(os.environ["CL"])
title = os.environ["TITLE"]
agent = os.environ["AGENT"]
date = os.environ["DATE"]
text = path.read_text()
needle = "## [Unreleased]"
if needle not in text:
    raise SystemExit(f"Could not find {needle!r} in {path}")
head, tail = text.split(needle, 1)
block = f"### {date} — {title} ({agent})"
insert = f"\n{block}\n\n- (fill bullets)\n"
lines = tail.splitlines(keepends=True)
if lines and lines[0].strip() == "":
    new_tail = insert + "".join(lines[1:])
else:
    new_tail = insert + "".join(lines)
path.write_text(head + needle + new_tail)
print(f"Inserted block in {path}")
PY
