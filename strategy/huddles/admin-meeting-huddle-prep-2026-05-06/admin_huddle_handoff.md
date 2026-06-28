# Admin Huddle & Production Status Handoff

**Date Generated:** 2026-06-03
**Phase/Stage:** S1.B (Distribution readiness)
**Flagship Product:** `web` (Tight Beta)

## 1. Governance & Orchestration Updates (Admin Session)
The local governance structure has been fully updated to support **Antigravity** as the primary orchestration engine, removing legacy dependencies on Slack and Cursor-PA.

**Key Changes:**
- **Antigravity CLI (`agy`) Standardized:** All automated sprints and agent delegations now use Antigravity tools, plugins, and skills instead of the deprecated `#sprint-queue` and Slack bridges.
- **Manual Gates:** Replaced all "Slack gates" with "Manual gates" executed via IDE Chat.
- **Branch Prefix Update:** New plans and branches will use the `agy/` prefix instead of `cursor/`.
- **Documentation Purged:** Legacy Slack and Cursor references were removed from `AGENTS.md` and all files within `governance/` (including `glossary.md`, `orchestration.md`, `plan_lifecycle.md`, `plan_registry.md`, `plan_template.md`, `skill_*`, etc.).

## 2. Current Production Status (VPS)
- **Host:** `dev@159.198.75.194`
- **Active Blue-Green Color:** **Green** (Up and Healthy for ~3 weeks). Inactive Blue is also Up and Healthy for ~4 weeks.
- **Git Sync:** Both `finance_manager_api` and `finance_manager_web` submodules are currently synced to `cursor/s1b/feat/f007-guided-walkthroughs`. The working trees are clean.

## 3. Active & Paused Workstreams
- **Active Task:** F-007 Guided Walkthroughs (`cursor/s1b/feat/f007-guided-walkthroughs`). The VPS is actively running this code.
- **Paused Task:** PWA implementation sprint is paused (pending human verification due to an online tx network error and an offline shell bug).

## 4. Next Steps for New Context
- Resume feature development or orchestration using the newly updated Antigravity guidelines.
- Any future plans or feature branches should adopt the `agy/s1b/...` prefix and utilize manual IDE Chat gates for approvals.
