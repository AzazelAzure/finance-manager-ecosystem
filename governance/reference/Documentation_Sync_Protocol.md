# Documentation Sync Protocol

## Purpose
Keep `design_docs` aligned with implementation work so architecture and technical state remain trustworthy.

## Boundary (post-2026-06-30 restructure)

`design_docs/` is now scoped to **active working system design only** — no governance,
planning, or strategy. Governance/ops contracts and release templates live in
`governance/`; roadmap, business, and planning artifacts live in `strategy/`.

| Area | Canonical home | design_docs role |
|------|----------------|------------------|
| Roadmap / phases / gates | `strategy/strategic-roadmap-reframe-53be/` (archive: `strategy/archive/design_docs/20_Roadmap/`) | None — moved out |
| Plan ops / deployment rules / release templates | `governance/` (`plan_registry.md`, `branching_guidelines.md`, `deployment_protocol.md`, handoff templates, `Runtime_Signup_Sheet.md`) | None — moved out |
| Living strategy state | `strategy/` (`current_status.md`, `anomalies/`, `research/`, `projections/`, `parking_lot/`, etc.) | Cross-link when sync touches sequencing |
| How the system works | `design_docs/` (this vault) | API/Web/CLI/Rust architecture + active `40_System_Design/` |
| VPS runtime checkout | `governance/deployment/Runtime_Signup_Sheet.md` | Human log; **live** VPS state comes from `scripts/ops/vps_state.sh` (not this file) |

## Trigger Conditions

Run documentation sync when any of the following occur:

- Django API endpoint or serializer contract changes (`finance_manager_api`)
- React/Vite component behavior or route changes (`finance_manager_web`)
- Celery task registration or beat schedule changes
- Phase scope, milestone order, or rollout assumptions change
- Cross-repo dependency or blocker status changes
- PR governance/protocol changes (agent roles, approval gates, mergeability rules)
- New governance doc added to `governance/` that supersedes a design_doc reference

## Sync Routine

1. **Capture Change Set**
   - What changed in code behavior
   - Which repo(s) changed
   - Which branch/PR(s) carry the change
   - What risks/assumptions shifted
2. **Map to Docs**
   - Architecture (active system design): `design_docs/40_System_Design/`, `design_docs/api_docs/`, `design_docs/cli_docs/`, `design_docs/rust_docs/`, `design_docs/00_*`
   - Roadmap and phases: **canonical** `strategy/strategic-roadmap-reframe-53be/`; archive `strategy/archive/design_docs/20_Roadmap/`
   - Release operations + ops contracts: `governance/` (signup sheet, handoff templates, runtime/relay/incident contracts)
3. **Apply Focused Edits**
   - Update existing files first.
   - Add new file only when no existing document is a good fit.
4. **Cross-Check**
   - Ensure docs describe current behavior, not intended behavior.
   - Ensure dependency order remains consistent with API-first rule.

## Required Output Template

```markdown
## Documentation Sync Report
- Change summary:
- Repos touched:
- Docs updated:
- Remaining doc gaps:
- Follow-up trigger:
```

## Run-Through Example (Legal Pages + Signup Clickwrap, 2026-06-27)

- Change summary: API adds `tos_version`/`tos_accepted_at` fields on `AppProfile` (migration `0011`); Web adds `/privacy`, `/terms`, `/cookies` routes and signup clickwrap checkbox; Celery confirmation email task added.
- Repos touched: `finance_manager_api` (PR #42), `finance_manager_web` (PRs #66, #67).
- Branch/PRs: `agy/s1b/feat/legal-pages`, `agy/s1b/feat/signup-clickwrap`.
- Docs updated:
  - `governance/deployment/Runtime_Signup_Sheet.md` — new session opened post-deploy
  - `governance/plans/plan_registry.md` — `PLAN_CROSS_LEGAL_PAGES_2026-06-27` and `PLAN_CROSS_SIGNUP_CLICKWRAP_2026-06-27` moved to Recently Completed
  - `strategy/current_status.md` §5 — status rows updated to ✅
- Remaining doc gaps:
  - API architecture doc for `AppProfile` model fields not updated.
- Follow-up trigger:
  - Run again if clickwrap version field (`tos_version` value) changes in production.
