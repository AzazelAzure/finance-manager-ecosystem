#!/usr/bin/env bash
# anomaly_new.sh — scaffold a strategy/anomalies log from the template
#
# Usage:
#   ./scripts/dev/anomaly_new.sh <plan-slug> <short-desc>
# Example:
#   ./scripts/dev/anomaly_new.sh tp-scripts-org vps-freshness-placeholder

set -euo pipefail

[[ $# -lt 2 ]] && {
  echo "Usage: anomaly_new.sh <plan-slug> <short-desc>" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLAN_SLUG="$1"
SHORT_DESC="$2"
DATE="$(date +%Y-%m-%d)"
SAFE_DESC="${SHORT_DESC// /-}"
SAFE_DESC="${SAFE_DESC//[^a-zA-Z0-9_-]/}"
OUT="$REPO_ROOT/strategy/anomalies/${DATE}_${PLAN_SLUG}_${SAFE_DESC}.md"
TEMPLATE="$REPO_ROOT/strategy/anomalies/anomaly_template.md"

[[ -f "$TEMPLATE" ]] || { echo "Missing template: $TEMPLATE" >&2; exit 1; }
[[ -e "$OUT" ]] && { echo "Already exists: $OUT" >&2; exit 1; }

mkdir -p "$(dirname "$OUT")"
cp "$TEMPLATE" "$OUT"
sed -i "s/^logged: .*/logged: $DATE/" "$OUT"
sed -i "s/^plan_context: .*/plan_context: $PLAN_SLUG/" "$OUT"

echo "Created: $OUT"
echo "Edit the file, then leave status: unreviewed for nightly sweep."
