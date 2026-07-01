#!/usr/bin/env bash
# migrate_hfm_layout.sh — Consolidate HFM workspaces under ~/Hive_Financial_Manager/
#
# BEFORE RUNNING:
#   1. All three agent workspaces (W1/W2/W3) must be on clean origin/main
#      (Run: git -C <workspace> status && git -C <workspace> log --oneline -1)
#   2. Copy this script to ~/ and run it from there — NOT from inside the repo:
#        cp ~/Documents/python/finance_manager/scripts/local/migrate_hfm_layout.sh ~/
#        cd ~
#        bash migrate_hfm_layout.sh [--dry-run]
#   3. Close the Claude Code session before Phase 2 (the script will tell you when).
#
# PHASES:
#   Phase 1: Move W1/W2/W3 agent workspaces   (safe to run with Claude Code open)
#   Phase 2: Move HFM primary repo             (close Claude Code first)
#   Phase 3: Update crontab + create conf stubs + verify
#
# Usage:
#   bash migrate_hfm_layout.sh            # interactive with confirmations
#   bash migrate_hfm_layout.sh --dry-run  # preview only, no changes

set -uo pipefail

# ──────────────────────────────────────────────
# Config
# ──────────────────────────────────────────────
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

SRC_PRIMARY="$HOME/Documents/python/finance_manager"
SRC_W1_PARENT="$HOME/agent-workspaces/cursor-executor"
SRC_W2_PARENT="$HOME/agent-workspaces/antigravity-executor"
SRC_W3_PARENT="$HOME/agent-workspaces/antigravity-reviewer"
SRC_W1="$SRC_W1_PARENT/finance_manager"
SRC_W2="$SRC_W2_PARENT/finance_manager"
SRC_W3="$SRC_W3_PARENT/finance_manager"

TGT_ROOT="$HOME/Hive_Financial_Manager"
TGT_HFM="$TGT_ROOT/HFM"
TGT_W1="$TGT_ROOT/WS1"
TGT_W2="$TGT_ROOT/WS2"
TGT_W3="$TGT_ROOT/WS3"

OLD_PATH="/home/pproctor/Documents/python/finance_manager"
NEW_PATH="/home/pproctor/Hive_Financial_Manager/HFM"

# ──────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────
RED='\033[0;31m'; YLW='\033[1;33m'; GRN='\033[0;32m'; BLD='\033[1m'; RST='\033[0m'

log()    { echo -e "${GRN}[migrate]${RST} $*"; }
warn()   { echo -e "${YLW}[warn]${RST}    $*"; }
err()    { echo -e "${RED}[error]${RST}   $*" >&2; }
header() { echo -e "\n${BLD}════════════════════════════════════${RST}"; echo -e "${BLD}  $*${RST}"; echo -e "${BLD}════════════════════════════════════${RST}"; }
run() {
    if $DRY_RUN; then
        echo -e "  ${YLW}[dry-run]${RST} $*"
    else
        eval "$@"
    fi
}
confirm() {
    local prompt="$1"
    if $DRY_RUN; then
        echo -e "  ${YLW}[dry-run]${RST} Would prompt: $prompt"
        return 0
    fi
    echo -en "${YLW}$prompt [y/N] ${RST}"
    read -r answer
    [[ "$answer" =~ ^[Yy]$ ]]
}

# ──────────────────────────────────────────────
# Pre-flight
# ──────────────────────────────────────────────
preflight() {
    header "Pre-flight checks"
    local ok=true

    # Must not be running from inside any workspace being moved
    local cwd
    cwd="$(pwd)"
    for path in "$SRC_PRIMARY" "$SRC_W1" "$SRC_W2" "$SRC_W3"; do
        if [[ "$cwd" == "$path"* ]]; then
            err "You are running this script from inside a workspace being moved: $cwd"
            err "Copy the script to ~/ and run: cd ~ && bash migrate_hfm_layout.sh"
            exit 1
        fi
    done
    log "cwd is safe ($cwd)"

    # Target must not already exist
    if [[ -e "$TGT_ROOT" ]]; then
        err "$TGT_ROOT already exists. Remove it or run --dry-run to inspect."
        ok=false
    else
        log "Target $TGT_ROOT does not exist — will be created"
    fi

    # Source paths must exist
    for ws in "$SRC_W1" "$SRC_W2" "$SRC_W3"; do
        if [[ -d "$ws" ]]; then
            log "Found: $ws"
        else
            warn "Missing: $ws (will skip this workspace)"
        fi
    done
    if [[ ! -d "$SRC_PRIMARY" ]]; then
        err "Primary repo not found: $SRC_PRIMARY"
        ok=false
    else
        log "Found primary: $SRC_PRIMARY"
    fi

    # Check each workspace is on a clean main
    for ws_label in "W1:$SRC_W1" "W2:$SRC_W2" "W3:$SRC_W3"; do
        local label="${ws_label%%:*}"
        local ws="${ws_label#*:}"
        if [[ ! -d "$ws" ]]; then continue; fi

        local branch dirty
        branch=$(git -C "$ws" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        dirty=$(git -C "$ws" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

        if [[ "$branch" != "main" ]]; then
            warn "$label is on branch '$branch' (not main)"
        fi
        if [[ "$dirty" != "0" ]]; then
            warn "$label has $dirty uncommitted change(s) — clean before moving"
        fi
        if [[ "$branch" == "main" && "$dirty" == "0" ]]; then
            log "$label: clean on main ✓"
        fi
    done

    # Check for git worktrees (move would break them)
    for ws_label in "primary:$SRC_PRIMARY" "W1:$SRC_W1" "W2:$SRC_W2" "W3:$SRC_W3"; do
        local label="${ws_label%%:*}"
        local ws="${ws_label#*:}"
        if [[ ! -d "$ws" ]]; then continue; fi
        local worktrees
        worktrees=$(git -C "$ws" worktree list 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
        if [[ "$worktrees" != "0" ]]; then
            warn "$label has $worktrees linked worktree(s) — these will need path updates after move"
        fi
    done

    # Extra files in cursor-executor parent
    local extra_files
    extra_files=$(find "$SRC_W1_PARENT" -maxdepth 1 -not -name "finance_manager" -not -path "$SRC_W1_PARENT" 2>/dev/null || true)
    if [[ -n "$extra_files" ]]; then
        warn "cursor-executor/ contains files other than finance_manager/:"
        echo "$extra_files" | sed 's/^/    /'
        warn "These will NOT be moved automatically. Handle manually after the migration."
    fi

    $ok || { err "Pre-flight failed. Fix the above errors and re-run."; exit 1; }
    echo ""
    log "Pre-flight complete."
}

# ──────────────────────────────────────────────
# Phase 1: Move W1 / W2 / W3
# ──────────────────────────────────────────────
phase1_move_workspaces() {
    header "Phase 1 — Move agent workspaces (W1 / W2 / W3)"

    run "mkdir -p \"$TGT_ROOT\""
    log "Created $TGT_ROOT"

    # W1
    if [[ -d "$SRC_W1" ]]; then
        log "Moving W1: $SRC_W1 → $TGT_W1"
        run "mv \"$SRC_W1\" \"$TGT_W1\""
        # Clean up parent if now empty (other than known extra files)
        local remaining
        remaining=$(find "$SRC_W1_PARENT" -maxdepth 1 -not -path "$SRC_W1_PARENT" 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$remaining" == "0" ]]; then
            run "rmdir \"$SRC_W1_PARENT\""
            log "Removed empty: $SRC_W1_PARENT"
        else
            warn "$SRC_W1_PARENT still has contents — not removed:"
            find "$SRC_W1_PARENT" -maxdepth 1 -not -path "$SRC_W1_PARENT" 2>/dev/null | sed 's/^/    /'
        fi
    else
        warn "W1 source not found — skipping: $SRC_W1"
    fi

    # W2
    if [[ -d "$SRC_W2" ]]; then
        log "Moving W2: $SRC_W2 → $TGT_W2"
        run "mv \"$SRC_W2\" \"$TGT_W2\""
        run "rmdir \"$SRC_W2_PARENT\" 2>/dev/null || true"
        log "Removed empty: $SRC_W2_PARENT"
    else
        warn "W2 source not found — skipping: $SRC_W2"
    fi

    # W3
    if [[ -d "$SRC_W3" ]]; then
        log "Moving W3: $SRC_W3 → $TGT_W3"
        run "mv \"$SRC_W3\" \"$TGT_W3\""
        run "rmdir \"$SRC_W3_PARENT\" 2>/dev/null || true"
        log "Removed empty: $SRC_W3_PARENT"
    else
        warn "W3 source not found — skipping: $SRC_W3"
    fi

    # Clean up ~/agent-workspaces if now empty
    if [[ -d "$HOME/agent-workspaces" ]]; then
        local remaining
        remaining=$(find "$HOME/agent-workspaces" -maxdepth 1 -not -path "$HOME/agent-workspaces" 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$remaining" == "0" ]]; then
            run "rmdir \"$HOME/agent-workspaces\""
            log "Removed empty: ~/agent-workspaces"
        else
            warn "~/agent-workspaces still has contents — not removed:"
            find "$HOME/agent-workspaces" -maxdepth 1 -not -path "$HOME/agent-workspaces" | sed 's/^/    /'
        fi
    fi

    log "Phase 1 complete."
}

# ──────────────────────────────────────────────
# Phase 2: Move HFM primary repo
# ──────────────────────────────────────────────
phase2_move_primary() {
    header "Phase 2 — Move primary repo (HFM)"

    echo ""
    echo -e "${YLW}  ┌─────────────────────────────────────────────────────────────┐${RST}"
    echo -e "${YLW}  │  STOP — Close Claude Code before continuing.                │${RST}"
    echo -e "${YLW}  │                                                             │${RST}"
    echo -e "${YLW}  │  Moving the primary repo while a Claude Code session is     │${RST}"
    echo -e "${YLW}  │  open inside it will invalidate the session's working dir.  │${RST}"
    echo -e "${YLW}  │                                                             │${RST}"
    echo -e "${YLW}  │  Steps:                                                     │${RST}"
    echo -e "${YLW}  │  1. Save any open work in Claude Code                       │${RST}"
    echo -e "${YLW}  │  2. Close the Claude Code session                           │${RST}"
    echo -e "${YLW}  │  3. Return here and press Y to continue                     │${RST}"
    echo -e "${YLW}  └─────────────────────────────────────────────────────────────┘${RST}"
    echo ""

    confirm "Claude Code is closed. Ready to move primary repo?" || {
        echo "Aborted at Phase 2. Re-run the script when ready."
        echo "W1/W2/W3 have already been moved — you can resume from Phase 2 with:"
        echo "  bash ~/migrate_hfm_layout.sh --skip-phase1"
        exit 0
    }

    log "Moving primary: $SRC_PRIMARY → $TGT_HFM"
    run "mv \"$SRC_PRIMARY\" \"$TGT_HFM\""

    # Clean up now-empty parent dirs if applicable
    run "rmdir \"$HOME/Documents/python\" 2>/dev/null || true"
    # (Don't touch ~/Documents/ — other things may live there)

    log "Phase 2 complete."
}

# ──────────────────────────────────────────────
# Phase 3: Conf files + crontab + verification
# ──────────────────────────────────────────────
phase3_post_move() {
    header "Phase 3 — Conf stubs, crontab, verification"

    # .fm_workspace.conf stubs at each workspace root (gitignored)
    log "Creating .fm_workspace.conf stubs..."
    local workspaces=("HFM:$TGT_HFM" "WS1:$TGT_W1" "WS2:$TGT_W2" "WS3:$TGT_W3")
    for entry in "${workspaces[@]}"; do
        local ws_id="${entry%%:*}"
        local ws_path="${entry#*:}"
        if [[ -d "$ws_path" ]]; then
            local conf="$ws_path/.fm_workspace.conf"
            run "cat > \"$conf\" <<'CONF'
# HFM workspace configuration — DO NOT COMMIT (gitignored)
export FM_PRIMARY_WORKSPACE=\"$TGT_HFM\"
export FM_THIS_WORKSPACE=\"$ws_id\"
CONF"
            log "  Created: $conf"
        else
            warn "  Workspace path not found — skipping conf: $ws_path"
        fi
    done

    # Add .fm_workspace.conf to .gitignore (if not already there)
    local gitignore="$TGT_HFM/.gitignore"
    if [[ -f "$gitignore" ]]; then
        if ! grep -q "\.fm_workspace\.conf" "$gitignore" 2>/dev/null; then
            run "echo '.fm_workspace.conf' >> \"$gitignore\""
            log "Added .fm_workspace.conf to .gitignore"
        else
            log ".fm_workspace.conf already in .gitignore"
        fi
    fi

    # Crontab update
    header "Crontab update"
    log "Backing up current crontab → ~/crontab_backup_pre_hfm_migrate.txt"
    if $DRY_RUN; then
        echo -e "  ${YLW}[dry-run]${RST} crontab -l > ~/crontab_backup_pre_hfm_migrate.txt"
        echo -e "  ${YLW}[dry-run]${RST} sed s|$OLD_PATH|$NEW_PATH|g"
    else
        crontab -l 2>/dev/null > ~/crontab_backup_pre_hfm_migrate.txt || true
        if grep -q "$OLD_PATH" ~/crontab_backup_pre_hfm_migrate.txt 2>/dev/null; then
            sed "s|$OLD_PATH|$NEW_PATH|g" ~/crontab_backup_pre_hfm_migrate.txt | crontab -
            log "Updated crontab — old path replaced with new path"
            log "Entries updated:"
            grep "$NEW_PATH" <(crontab -l 2>/dev/null) | sed 's/^/    /'
        else
            log "No crontab entries referenced the old path — no changes needed"
        fi
    fi

    # Grep scripts for any remaining hardcoded old path references
    header "Hardcoded path audit"
    log "Scanning $TGT_HFM/scripts/ for remaining old-path references..."
    if $DRY_RUN; then
        echo -e "  ${YLW}[dry-run]${RST} grep -r \"Documents/python/finance_manager\" $TGT_HFM/scripts/"
    else
        local hits
        hits=$(grep -rn "Documents/python/finance_manager" "$TGT_HFM/scripts/" 2>/dev/null || true)
        if [[ -n "$hits" ]]; then
            warn "Hardcoded old paths found — update manually:"
            echo "$hits" | sed 's/^/    /'
        else
            log "No hardcoded old paths found in scripts/ ✓"
        fi
    fi

    # Verify: git status of HFM from new location
    header "Verification"
    if [[ -d "$TGT_HFM/.git" ]]; then
        log "git status in new HFM location:"
        git -C "$TGT_HFM" status --short 2>&1 | head -10 | sed 's/^/    /'
        local branch
        branch=$(git -C "$TGT_HFM" rev-parse --abbrev-ref HEAD 2>/dev/null)
        log "HFM is on branch: $branch"
    fi
    for ws_label in "WS1:$TGT_W1" "WS2:$TGT_W2" "WS3:$TGT_W3"; do
        local label="${ws_label%%:*}"
        local ws="${ws_label#*:}"
        if [[ -d "$ws/.git" ]]; then
            local branch
            branch=$(git -C "$ws" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
            log "$label: git OK, branch=$branch"
        else
            warn "$label: .git not found at $ws"
        fi
    done

    log "Phase 3 complete."
}

# ──────────────────────────────────────────────
# Manual follow-up summary
# ──────────────────────────────────────────────
print_followup() {
    header "Manual follow-up required"

    cat <<'EOF'

These items cannot be handled automatically. Complete them after the script finishes:

[ ] 1. Cursor workspace settings (WS1 and WS2)
       Check: ~/Hive_Financial_Manager/WS1/.cursor/settings.json (if exists)
              ~/Hive_Financial_Manager/WS2/.cursor/settings.json (if exists)
       Update any paths that reference the old workspace root.

[ ] 2. Antigravity orchestrator.py
       Audit for hardcoded paths:
         grep -n "Documents/python\|agent-workspaces" \
           ~/Hive_Financial_Manager/HFM/scripts/orchestrator.py 2>/dev/null
       Update any found paths.

[ ] 3. Cursor PA / headless agent workspace binding
       ~/CursorAgent/headless-cursor-agent/ — if any config references old workspace paths,
       update to ~/Hive_Financial_Manager/WS1 or HFM as appropriate.
       Check: grep -r "Documents/python\|agent-workspaces" ~/CursorAgent/ 2>/dev/null

[ ] 4. cursor-executor/ leftover files
       ~/agent-workspaces/cursor-executor/sprint_pipeline_local_inbox.jsonl
       Decide: move to ~/Hive_Financial_Manager/WS1/ or archive/delete.

[ ] 5. Open Claude Code from the new primary path
       cd ~/Hive_Financial_Manager/HFM
       claude    (or re-open via IDE extension)
       Verify session context is correct.

[ ] 6. Verify cron fires correctly on next scheduled run
       Check: crontab -l
       Test manually if needed: bash ~/Hive_Financial_Manager/HFM/scripts/server/pull_backup.sh

[ ] 7. design_docs submodule fetch error (pre-existing in WS1)
       This existed before the move and should be fixed in the W1 cleanup chore.
       After move: git -C ~/Hive_Financial_Manager/WS1 submodule update --init --recursive

EOF
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
main() {
    echo ""
    echo -e "${BLD}HFM Filesystem Migration${RST}"
    echo -e "Source:  ~/Documents/python/finance_manager + ~/agent-workspaces/"
    echo -e "Target:  ~/Hive_Financial_Manager/"
    $DRY_RUN && echo -e "${YLW}DRY RUN — no changes will be made${RST}"
    echo ""

    preflight
    echo ""
    confirm "Pre-flight passed. Begin Phase 1 (move W1/W2/W3)?" || { echo "Aborted."; exit 0; }

    phase1_move_workspaces
    echo ""
    phase2_move_primary
    phase3_post_move
    print_followup

    echo ""
    log "Migration complete. Run 'git -C ~/Hive_Financial_Manager/HFM status' to verify."
}

main "$@"
