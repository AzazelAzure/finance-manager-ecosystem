#!/usr/bin/env bash
# codex_review_pack.sh — deterministic Codex review packet assembly (OPS-REVAMP-T05 / T7 MVP)
#
# Usage:
#   ./scripts/ops/codex_review_pack.sh --repo parent|api|web --pr <N> --mode <m> [--out <dir>]
#
# Collects PR metadata, diff, readiness, plan export, and static check outputs.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

REPO_SLUG=""
PR_NUM=""
REVIEW_MODE=""
OUT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_SLUG="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    --mode) REVIEW_MODE="$2"; shift 2 ;;
    --out) OUT_DIR="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" && -n "$REVIEW_MODE" ]] || {
  echo "Usage: codex_review_pack.sh --repo parent|api|web --pr <N> --mode <m> [--out <dir>]" >&2
  exit 1
}

if [[ -z "$OUT_DIR" ]]; then
  OUT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/codex_review_pack.XXXXXX")"
fi
mkdir -p "$OUT_DIR"

declare -A GH_REPOS=(
  [parent]="AzazelAzure/finance-manager-ecosystem"
  [api]="AzazelAzure/finance-manager-api"
  [web]="AzazelAzure/finance-manager-web"
)

GH="${GH_REPOS[$REPO_SLUG]}"
BODY="$(gh pr view "$PR_NUM" --repo "$GH" --json body,title,headRefName,baseRefName,state --jq '.')"
printf '%s' "$BODY" > "$OUT_DIR/metadata.json"
gh pr diff "$PR_NUM" --repo "$GH" > "$OUT_DIR/diff.patch" 2>/dev/null || true

"$REPO_ROOT/scripts/dev/pr_readiness.sh" --repo "$REPO_SLUG" --pr "$PR_NUM" \
  > "$OUT_DIR/pr_readiness.txt" 2>&1 || true

PLAN_ID="$(python3 -c 'import json,sys,re; b=json.load(open(sys.argv[1])).get("body") or ""; m=re.search(r"(?i)plan[ _-]*id\s*[:=]\s*([A-Z0-9_-]+)", b); print(m.group(1) if m else "")' "$OUT_DIR/metadata.json")"
HASH_MISMATCH=0
if [[ -n "$PLAN_ID" ]]; then
  "$REPO_ROOT/scripts/dev/plan_lookup.sh" "$PLAN_ID" > "$OUT_DIR/plan_lookup.txt" 2>&1 || true
  SAFE="$(printf '%s' "$PLAN_ID" | tr '/:' '__')"
  EXPORT_PATH="$REPO_ROOT/strategy/workspace/exports/${SAFE}.yaml"
  OLD_SHA=""
  if [[ -f "$EXPORT_PATH" ]]; then
    OLD_SHA="$(grep -E '^export_sha256:' "$EXPORT_PATH" 2>/dev/null | awk '{print $2}' || true)"
  fi
  "$REPO_ROOT/scripts/dev/plan_export.sh" --plan "$PLAN_ID" >/dev/null 2>&1 || true
  if [[ -f "$EXPORT_PATH" ]]; then
    cp "$EXPORT_PATH" "$OUT_DIR/plan_export.yaml"
    NEW_SHA="$(grep -E '^export_sha256:' "$EXPORT_PATH" 2>/dev/null | awk '{print $2}' || true)"
    if [[ -n "$OLD_SHA" && -n "$NEW_SHA" && "$OLD_SHA" != "$NEW_SHA" && "$OLD_SHA" != "pending" ]]; then
      HASH_MISMATCH=1
      printf 'NEEDS_HITM: plan export hash changed (%s -> %s)\n' "$OLD_SHA" "$NEW_SHA" \
        > "$OUT_DIR/plan_export_hash_mismatch.txt"
    fi
  fi
fi

"$REPO_ROOT/scripts/dev/pr_body_contract.sh" --repo "$REPO_SLUG" --pr "$PR_NUM" \
  > "$OUT_DIR/pr_body_contract.txt" 2>&1 || true
"$REPO_ROOT/scripts/dev/changelog_check.sh" --repo "$REPO_SLUG" --pr "$PR_NUM" \
  > "$OUT_DIR/changelog_check.txt" 2>&1 || true
"$REPO_ROOT/scripts/dev/changed_file_classify.sh" --repo "$REPO_SLUG" --pr "$PR_NUM" \
  > "$OUT_DIR/changed_file_classify.txt" 2>&1 || true

cat > "$OUT_DIR/packet_manifest.txt" <<EOF
repo=$REPO_SLUG
pr=$PR_NUM
mode=$REVIEW_MODE
plan_id=${PLAN_ID:-none}
hash_mismatch=${HASH_MISMATCH}
out_dir=$OUT_DIR
EOF

printf 'PACKET_DIR=%s\n' "$OUT_DIR"
ls -1 "$OUT_DIR"
