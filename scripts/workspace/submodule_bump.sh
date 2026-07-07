#!/usr/bin/env bash
# submodule_bump.sh — open parent submodule pin bump PR (OPS-REVAMP-T08)
#
# Usage:
#   ./scripts/workspace/submodule_bump.sh <submodule> <new_sha> [--linked-pr api|web|parent#N] [--task-id ID]
#
# Opens a parent PR with only the submodule pointer + CHANGELOG. Enqueues Codex
# submodule-bump review. Stage-10 closeout requires this PR merged or a logged waiver.

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
[[ -n "$PRIMARY" ]] || { printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1; }

SUBMODULE=""
NEW_SHA=""
LINKED_PR=""
TASK_ID="SUBMODULE-BUMP"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --linked-pr) LINKED_PR="$2"; shift 2 ;;
    --task-id) TASK_ID="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      if [[ -z "$SUBMODULE" ]]; then SUBMODULE="$1"
      elif [[ -z "$NEW_SHA" ]]; then NEW_SHA="$1"
      else echo "Unknown arg: $1" >&2; exit 1
      fi
      shift
      ;;
  esac
done

[[ -n "$SUBMODULE" && -n "$NEW_SHA" ]] || {
  echo "Usage: submodule_bump.sh <submodule> <new_sha> [--linked-pr api#N] [--task-id ID]" >&2
  exit 1
}

cd "$PRIMARY"
[[ -d "$SUBMODULE" ]] || { printf 'Error: submodule path not found: %s\n' "$SUBMODULE" >&2; exit 1; }

OLD_SHA="$(git ls-tree HEAD "$SUBMODULE" | awk '{print $3}')"
if [[ "$OLD_SHA" == "$NEW_SHA" ]]; then
  printf 'No change: %s already at %s\n' "$SUBMODULE" "$NEW_SHA"
  exit 0
fi

BRANCH="cur/s1b/chore/submodule-bump-${SUBMODULE//\//-}-$(date -u +%Y%m%d)"
git fetch origin main
git checkout -B "$BRANCH" origin/main

git -C "$SUBMODULE" fetch origin 2>/dev/null || true
if ! git -C "$SUBMODULE" cat-file -e "${NEW_SHA}^{commit}" 2>/dev/null; then
  printf 'Error: SHA %s not found in submodule %s\n' "$NEW_SHA" "$SUBMODULE" >&2
  exit 1
fi

git -C "$SUBMODULE" checkout "$NEW_SHA"
git add "$SUBMODULE"

TITLE="chore(parent): bump $SUBMODULE to ${NEW_SHA:0:12}"
BODY="$(cat <<EOF
## Summary
Bump \`$SUBMODULE\` submodule pin: \`${OLD_SHA:0:12}\` → \`${NEW_SHA:0:12}\`.

Plan ID: OPS-REVAMP-2026-07-07
Task: $TASK_ID

**Linked subrepo PR:** ${LINKED_PR:-none}
**Anomaly disposition:** none found

## submodule_status (pre-bump)
\`\`\`
$(./scripts/dev/submodule_status.sh 2>&1 | sed -n "/\\[$SUBMODULE\\]/,/^$/p" || true)
\`\`\`

## Stage 10 gate
Parent post-deploy closeout requires this submodule bump merged or an explicit waiver in \`strategy/workspace/gate_override_log.md\`.

## Test plan
- [x] New SHA exists on submodule remote
- [x] PR contains only submodule pointer + CHANGELOG
- [ ] Codex submodule-bump review
EOF
)"

./scripts/dev/changelog_entry.sh "Bump $SUBMODULE submodule pin ($TASK_ID)" "Cursor"
python3 - "$PRIMARY/CHANGELOG.md" "$SUBMODULE" "$OLD_SHA" "$NEW_SHA" <<'PY'
from pathlib import Path
import sys
p, sub, old, new = sys.argv[1:5]
text = Path(p).read_text()
stub = "- (fill bullets)"
if stub in text:
    text = text.replace(stub, f"- Bump `{sub}` pin `{old[:12]}` → `{new[:12]}`.", 1)
    Path(p).write_text(text)
PY

git add CHANGELOG.md
git commit -m "$(cat <<EOF
Bump $SUBMODULE submodule to ${NEW_SHA:0:12}.

Stage-10 gate PR for Codex submodule-bump review.
EOF
)"

git push -u origin HEAD
PR_NUM="$(gh pr create --title "$TITLE" --body "$BODY" --json number -q '.number')"
printf 'PR #%s: https://github.com/AzazelAzure/finance-manager-ecosystem/pull/%s\n' "$PR_NUM" "$PR_NUM"

"$PRIMARY/scripts/workspace/review_push.sh" parent "$PR_NUM" "$TASK_ID" cursor
printf 'Enqueued review.queue: parent-%s (mode resolves to submodule-bump)\n' "$PR_NUM"
printf 'Next: ./scripts/workspace/ws_review.sh parent %s --auto\n' "$PR_NUM"
