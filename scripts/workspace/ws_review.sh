#!/usr/bin/env bash
# WS3 PR reviewer — approve+merge or request-changes based on real diff inspection.
#
# Auto mode: passes the PR diff to a Claude Code sub-agent in WS3 for review.
# Manual flags bypass the agent.
#
# Usage:
#   ws_review.sh <repo> <pr_number> --auto
#   ws_review.sh <repo> <pr_number> --approve
#   ws_review.sh <repo> <pr_number> --reject "reason"
#   ws_review.sh --next [--auto|--approve|--reject "reason"]
#
# Repo map: api → finance-manager-api, web → finance-manager-web,
#           parent → finance-manager-ecosystem

set -euo pipefail

# ── resolve primary workspace ──────────────────────────────────────────────────
if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
[[ -z "$PRIMARY" ]] && { printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1; }

SCRIPTS_DIR="$PRIMARY/scripts/workspace"
ROOT_DIR="$(dirname "$PRIMARY")"
WS3_DIR="$ROOT_DIR/WS3"

resolve_gh_repo() {
  case "$1" in
    api) printf '%s' "AzazelAzure/finance-manager-api" ;;
    web) printf '%s' "AzazelAzure/finance-manager-web" ;;
    parent) printf '%s' "AzazelAzure/finance-manager-ecosystem" ;;
    *) printf 'Error: unknown repo %q. Expected: api | web | parent\n' "$1" >&2; return 1 ;;
  esac
}

FROM_QUEUE=0
REVIEW_KEY=""

# ── args ───────────────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--next" ]]; then
  FROM_QUEUE=1
  ACTION="${2:-}"
  REASON="${3:-}"
  if [[ -z "$ACTION" ]]; then
    ACTION="--auto"
  elif [[ "$ACTION" == "--reject" && -z "$REASON" && -n "${4:-}" ]]; then
    REASON="$4"
  fi
  if [[ "$ACTION" != --auto && "$ACTION" != --approve && "$ACTION" != --reject ]]; then
    printf 'Usage: ws_review.sh --next [--auto|--approve|--reject "reason"]\n' >&2
    exit 1
  fi
  if ! REVIEW_LINE="$("$SCRIPTS_DIR/review_pop.sh")"; then
    exit 1
  fi
  REPO="$(printf '%s' "$REVIEW_LINE" | cut -d'|' -f1)"
  PR_NUM="$(printf '%s' "$REVIEW_LINE" | cut -d'|' -f2)"
  REVIEW_KEY="${REPO}-${PR_NUM}"
elif [[ $# -lt 3 ]]; then
  printf 'Usage: ws_review.sh <repo> <pr_number> --auto|--approve|--reject "reason"\n' >&2
  printf '       ws_review.sh --next [--auto|--approve|--reject "reason"]\n' >&2
  exit 1
else
  REPO="$1"; PR_NUM="$2"; ACTION="$3"; REASON="${4:-}"
fi

GH_REPO="$(resolve_gh_repo "$REPO")" || exit 1

# ── claim WS3 ──────────────────────────────────────────────────────────────────
"$SCRIPTS_DIR/ws_claim.sh" WS3 "claude-ws3" "PR-REVIEW" "pr/${PR_NUM}" >&2

REVIEW_RESULT=""

merge_pr() {
  local pr="$1" repo="$2" subject="$3"
  gh pr merge "$pr" --repo "$repo" --squash --delete-branch \
    --subject "$subject"
}

comment_pr() {
  local pr="$1" repo="$2" body="$3"
  gh pr comment "$pr" --repo "$repo" --body "$body"
}

do_review() {
  case "$ACTION" in

    # ── manual approve ─────────────────────────────────────────────────────────
    # Note: gh pr review --approve fails on own PRs (GitHub restriction).
    # Instead: comment LGTM + merge directly.
    --approve)
      comment_pr "$PR_NUM" "$GH_REPO" \
        "LGTM ✓ — Approved by ws_review.sh (manual --approve). Merging."
      merge_pr "$PR_NUM" "$GH_REPO" "[SMOKE] PR #${PR_NUM}: merged"
      REVIEW_RESULT="APPROVED_AND_MERGED"
      ;;

    # ── manual reject ─────────────────────────────────────────────────────────
    # Note: gh pr review --request-changes fails on own PRs.
    # Instead: comment with reason and leave PR open for fix.
    --reject)
      [[ -z "$REASON" ]] && { printf 'Error: --reject requires a reason string.\n' >&2; exit 1; }
      comment_pr "$PR_NUM" "$GH_REPO" \
        "❌ Changes requested by ws_review.sh: ${REASON}"
      REVIEW_RESULT="CHANGES_REQUESTED"
      ;;

    # ── auto: inspect diff, decide, act ───────────────────────────────────────
    --auto)
      PR_META=$(gh pr view "$PR_NUM" --repo "$GH_REPO" --json title,headRefName)
      PR_TITLE=$(printf '%s' "$PR_META" | python3 -c 'import json,sys; print(json.load(sys.stdin)["title"])')
      PR_HEAD=$(printf '%s' "$PR_META" | python3 -c 'import json,sys; print(json.load(sys.stdin)["headRefName"])')
      PR_DIFF=$(gh pr diff "$PR_NUM" --repo "$GH_REPO" 2>/dev/null || printf '(no diff)')

      # Dependabot three-tier chain (T5): tier-1 script → Codex dependabot mode → NEEDS_HITM
      if [[ "$PR_HEAD" == dependabot/* ]]; then
        DEP_CHECK="$PRIMARY/scripts/ops/dependabot_check.sh"
        if [[ -x "$DEP_CHECK" ]]; then
          set +e
          DEP_OUT="$("$DEP_CHECK" --repo "$REPO" --pr "$PR_NUM" 2>&1)"
          DEP_CODE=$?
          set -e
          DEP_VERDICT="$(printf '%s' "$DEP_OUT" | awk -F': ' '/^VERDICT:/{print $2; exit}')"
          DEP_REASON="$(printf '%s' "$DEP_OUT" | awk -F': ' '/^REASON:/{sub(/^REASON: /,""); print; exit}')"
          printf 'Dependabot tier-1: %s (%s)\n' "${DEP_VERDICT:-unknown}" "${DEP_REASON:-}" >&2

          case "${DEP_VERDICT:-}" in
            APPROVE)
              if "$PRIMARY/scripts/dev/pr_readiness.sh" --repo "$REPO" --pr "$PR_NUM" 2>&1 | grep -qE 'Check\s*:\s*.+=\s*(FAILURE|FAILED)'; then
                comment_pr "$PR_NUM" "$GH_REPO" \
                  "❌ Dependabot tier-1 APPROVE blocked: failing CI checks. Fix or escalate."
                REVIEW_RESULT="CHANGES_REQUESTED"
                return 0
              fi
              comment_pr "$PR_NUM" "$GH_REPO" \
                "✓ Dependabot tier-1: APPROVE — ${DEP_REASON}. Merging."
              merge_pr "$PR_NUM" "$GH_REPO" "chore(deps): dependabot tier-1 merge PR #${PR_NUM}"
              REVIEW_RESULT="APPROVED_AND_MERGED"
              return 0
              ;;
            ESCALATE_CODEX)
              CODEX_REVIEW="$PRIMARY/scripts/ops/codex_review.sh"
              if [[ -x "$CODEX_REVIEW" ]]; then
                printf 'Dependabot tier-2: invoking codex_review.sh --mode dependabot\n' >&2
                if "$CODEX_REVIEW" --repo "$REPO" --pr "$PR_NUM" --mode dependabot; then
                  REVIEW_RESULT="APPROVED_AND_MERGED"
                else
                  REVIEW_RESULT="CHANGES_REQUESTED"
                fi
                return 0
              fi
              comment_pr "$PR_NUM" "$GH_REPO" \
                "⚠ Dependabot tier-1 ESCALATE_CODEX but codex_review.sh unavailable — ${DEP_REASON}"
              REVIEW_RESULT="CHANGES_REQUESTED"
              return 0
              ;;
            NEEDS_HITM)
              comment_pr "$PR_NUM" "$GH_REPO" \
                "⚠ Dependabot tier-1: NEEDS_HITM — ${DEP_REASON}. Operator review required."
              REVIEW_RESULT="CHANGES_REQUESTED"
              return 0
              ;;
            *)
              printf 'Warning: dependabot_check unexpected exit %s; falling through to standard review.\n' "$DEP_CODE" >&2
              ;;
          esac
        else
          printf 'Warning: dependabot_check.sh not executable; falling through to standard review.\n' >&2
        fi
      fi

      # Real signal: reject if diff contains FIXME marker
      if printf '%s' "$PR_DIFF" | grep -q "FIXME"; then
        comment_pr "$PR_NUM" "$GH_REPO" \
          "❌ Automated review (ws_review --auto): FIXME marker found in diff. Resolve before merge."
        REVIEW_RESULT="CHANGES_REQUESTED"
        printf 'AUTO REVIEW: FIXME detected → changes requested on PR #%s\n' "$PR_NUM" >&2
        return 0
      fi

      # No blocking issues — run WS3 agent for deeper review
      if [[ -d "$WS3_DIR" ]] && command -v claude &>/dev/null; then
        BRIEF="$(cat <<ENDBRIEF
# WS3 PR Review Task

You are a PR reviewer for the Hive Financial Manager project. Review the
following GitHub PR and decide: APPROVE (safe to merge) or REQUEST_CHANGES
(needs fixes). Respond with exactly one of:
  REVIEW_DECISION: APPROVE
  REVIEW_DECISION: REQUEST_CHANGES <one-line reason>

## PR Details
- Repo : ${GH_REPO}
- PR # : ${PR_NUM}
- Title: ${PR_TITLE}

## Diff
\`\`\`diff
${PR_DIFF}
\`\`\`

## Review criteria
- No FIXME/TODO/HACK markers (hard reject)
- File changes are coherent with the PR title
- No secrets, credentials, or keys in the diff
- Smoke test files should contain "status: PASS" (not FAIL or FIXME)

Output ONLY the REVIEW_DECISION line. No other text.
ENDBRIEF
)"
        AGENT_OUTPUT=$(cd "$WS3_DIR" && claude --print "$BRIEF")
        printf 'WS3 agent output: %s\n' "$AGENT_OUTPUT" >&2

        if printf '%s' "$AGENT_OUTPUT" | grep -q "REVIEW_DECISION: APPROVE"; then
          comment_pr "$PR_NUM" "$GH_REPO" \
            "✓ WS3 agent review: APPROVE — no blocking issues found. Merging."
          merge_pr "$PR_NUM" "$GH_REPO" "[SMOKE] PR #${PR_NUM}: merged"
          REVIEW_RESULT="APPROVED_AND_MERGED"
        else
          AGENT_REASON=$(printf '%s' "$AGENT_OUTPUT" | grep "REVIEW_DECISION:" | sed 's/REVIEW_DECISION: REQUEST_CHANGES //')
          comment_pr "$PR_NUM" "$GH_REPO" \
            "❌ WS3 agent review: changes required — ${AGENT_REASON:-see above}"
          REVIEW_RESULT="CHANGES_REQUESTED"
        fi
      else
        # Fallback: no WS3 dir or no claude binary — heuristics only
        printf 'Warning: WS3 dir or claude CLI not available; approving via heuristics.\n' >&2
        comment_pr "$PR_NUM" "$GH_REPO" \
          "✓ Heuristic review (WS3 unavailable): no FIXME found. Merging."
        merge_pr "$PR_NUM" "$GH_REPO" "[SMOKE] PR #${PR_NUM}: merged"
        REVIEW_RESULT="APPROVED_AND_MERGED"
      fi
      ;;

    *)
      printf 'Error: unknown action %q. Use --auto | --approve | --reject\n' "$ACTION" >&2
      exit 1
      ;;
  esac
}

do_review

# ── release WS3 ───────────────────────────────────────────────────────────────
"$SCRIPTS_DIR/ws_release.sh" WS3 >&2

if [[ "$FROM_QUEUE" -eq 1 && -n "$REVIEW_KEY" ]]; then
  case "$REVIEW_RESULT" in
    APPROVED_AND_MERGED)
      "$SCRIPTS_DIR/review_done.sh" "$REVIEW_KEY"
      ;;
    CHANGES_REQUESTED)
      "$SCRIPTS_DIR/review_done.sh" "$REVIEW_KEY" --failed
      ;;
  esac
fi

printf 'Review complete: PR #%s → %s\n' "$PR_NUM" "$REVIEW_RESULT"
