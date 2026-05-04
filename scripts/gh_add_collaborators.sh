#!/usr/bin/env bash
# Add GitHub collaborators to all finance-manager repos.
# Run as HitM (AzazelAzure) after creating the agent GitHub accounts.
#
# Usage:
#   bash scripts/gh_add_collaborators.sh
#   bash scripts/gh_add_collaborators.sh --dry-run
#
# Prerequisites:
#   - gh auth status shows AzazelAzure logged in
#   - Agent accounts exist: Proctor-Cursor-Agents, Proctor-Gemini-Agent, Proctor-Gemini-Executor

set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

OWNER="AzazelAzure"
CURSOR_AGENT="Proctor-Cursor-Agents"
GEMINI_REVIEWER="Proctor-Gemini-Agent"
GEMINI_EXECUTOR="Proctor-Gemini-Executor"
PERMISSION="push"  # read+write; no admin

# All repos that agents need write access to
REPOS=(
  finance-manager-ecosystem
  finance-manager-api
  finance-manager-web
  finance-manager-cli
  finance-manager-design-docs
  finance-manager-rust-tools
  finance-manager-rust-middleware
  finance-manager-andriod
)

log() { printf '%s\n' "$*"; }

add_collaborator() {
  local repo="$1" user="$2"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] Would add $user to $OWNER/$repo (permission: $PERMISSION)"
    return 0
  fi
  log "Adding $user to $OWNER/$repo..."
  if gh api "repos/$OWNER/$repo/collaborators/$user" \
    -X PUT -f permission="$PERMISSION" --silent 2>/dev/null; then
    log "  ✓ Invitation sent (or already collaborator)"
  else
    log "  ✗ Failed — check repo name and account existence"
  fi
}

log "=== GitHub Collaborator Setup ==="
log "Owner: $OWNER"
log "Agents: $CURSOR_AGENT, $GEMINI_REVIEWER, $GEMINI_EXECUTOR"
log "Permission: $PERMISSION"
log ""

for repo in "${REPOS[@]}"; do
  add_collaborator "$repo" "$CURSOR_AGENT"
  add_collaborator "$repo" "$GEMINI_REVIEWER"
  add_collaborator "$repo" "$GEMINI_EXECUTOR"
  log ""
done

log "=== Done ==="
if [[ "$DRY_RUN" -eq 0 ]]; then
  log ""
  log "Invitations sent. Accept them from each agent account:"
  log ""
  log "  # From Cursor agent's gh CLI (logged in as $CURSOR_AGENT):"
  log "  gh api user/repository_invitations --jq '.[].id' | xargs -I{} gh api user/repository_invitations/{} -X PATCH"
  log ""
  log "  # From Gemini reviewer's gh CLI (logged in as $GEMINI_REVIEWER):"
  log "  gh api user/repository_invitations --jq '.[].id' | xargs -I{} gh api user/repository_invitations/{} -X PATCH"
  log ""
  log "  # From Gemini executor's gh CLI (logged in as $GEMINI_EXECUTOR):"
  log "  gh api user/repository_invitations --jq '.[].id' | xargs -I{} gh api user/repository_invitations/{} -X PATCH"
fi
