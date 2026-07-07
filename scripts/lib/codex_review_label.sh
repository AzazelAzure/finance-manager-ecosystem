#!/usr/bin/env bash
# codex_review_label.sh — shared helpers for D1 codex-review:pending label (OPS-REVAMP-T01)

CODEX_REVIEW_LABEL='codex-review:pending'

codex_review_resolve_gh_repo() {
  case "$1" in
    api) printf '%s' "AzazelAzure/finance-manager-api" ;;
    web) printf '%s' "AzazelAzure/finance-manager-web" ;;
    parent) printf '%s' "AzazelAzure/finance-manager-ecosystem" ;;
    *) return 1 ;;
  esac
}

codex_review_ensure_label() {
  local gh_repo="$1"
  gh label create "$CODEX_REVIEW_LABEL" \
    --repo "$gh_repo" \
    --color "FBCA04" \
    --description "Codex review pending — do not merge manually while present" \
    2>/dev/null || true
}

codex_review_add_pending_label() {
  local repo_slug="$1" pr_num="$2"
  local gh_repo
  gh_repo="$(codex_review_resolve_gh_repo "$repo_slug")" || return 1
  codex_review_ensure_label "$gh_repo"
  gh pr edit "$pr_num" --repo "$gh_repo" --add-label "$CODEX_REVIEW_LABEL" 2>/dev/null || true
}

codex_review_remove_pending_label() {
  local repo_slug="$1" pr_num="$2"
  local gh_repo
  gh_repo="$(codex_review_resolve_gh_repo "$repo_slug")" || return 1
  gh pr edit "$pr_num" --repo "$gh_repo" --remove-label "$CODEX_REVIEW_LABEL" 2>/dev/null || true
}

codex_review_has_pending_label() {
  local repo_slug="$1" pr_num="$2"
  local gh_repo
  gh_repo="$(codex_review_resolve_gh_repo "$repo_slug")" || return 1
  gh pr view "$pr_num" --repo "$gh_repo" --json labels \
    --jq '.labels[].name' 2>/dev/null | grep -Fxq "$CODEX_REVIEW_LABEL"
}
