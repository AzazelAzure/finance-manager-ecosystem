---
plan_id: PLAN_CHORE_DESIGN_DOCS_RESTRUCTURE_2026-06-29
status: ready
priority: P2
created: 2026-06-29
updated: 2026-06-29
owner: pproctor

plan_root: plans/S1/S1.B/chore-design-docs-restructure/
intended_branch: cur/s1b/chore/design-docs-restructure
parent_plan: plans/S1/S1.B/

target_repos:
  - design_docs

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

manual_gates:
  pre_execution: none
  pre_merge: required
  pre_close: required

deployment:
  required: false
  notes: Docs-only. Operates inside the design_docs submodule; Cursor commits there and the parent bumps the submodule pointer (CPPR). No VPS deploy.

standalone: true
standalone_notes: "design_docs is its own git submodule (Obsidian vault). All moves happen on the submodule's own branch; admin (Claude Code) does not touch the submodule working tree."
---

# Design Docs Restructure (D6 execution — submodule side)

**Context:** Approved in `strategy/doc_structure_consolidation_proposal_2026-06-29.md` (D6). The
`design_docs/` vault drifted: roadmap/release-ops material overlaps `strategy/` and `governance/`,
archived-product (`reflex_docs/`) and alpha-era files present themselves as current, and
`00_Dashboard.md` links to folders/files that don't exist. This chore makes design_docs purely
**"how the built system actually works"** — the worst-case manual-resume reference.

## Boundary (already decided — do not re-litigate)

- `design_docs/` = durable technical truth (architecture + current technical state).
- Roadmap truth = `strategy/strategic-roadmap-reframe-53be/`. Plan ops = `governance/`.
- `Runtime_Signup_Sheet.md` **stays** (VPS checkout sheet; kept current per AGENTS.md doc-maintenance tenet).

## Tasks

| Task | Slug | Scope |
|---|---|---|
| T01 | archive-deprecated | `reflex_docs/` → archive; alpha-era `10_Current_State` files (`00_Alpha_Overview`, `03_Resume_Checkpoint_2026-04-27`) → archive |
| T02 | retire-roadmap-releases | `20_Roadmap/` active-sounding files → `_historical/`; pull out `30_Releases/` versioning-summary material (retire); keep `Runtime_Signup_Sheet.md` + handoff templates; git/workflow rules already canonical in `governance/` — retire the design_docs copies or mark historical |
| T03 | fix-index-and-protocol | Fix `00_Dashboard.md` to match reality (remove dead `30_Security/` + nonexistent file links); update `10_Current_State/02_Documentation_Sync_Protocol.md` to the new boundary; triage loose top-level files (`50_Research_Backlog` → note pointer to `strategy/research/`; keep durable specs) |

**Execution order:** T01 → T02 → T03 (T03's Dashboard fix must reflect the moves from T01/T02).

## Verification Gates

- [V1] `reflex_docs/` and alpha-era files no longer appear as current (moved under an archive/`_historical` path per vault convention).
- [V1] `00_Dashboard.md` contains no links to nonexistent files/folders.
- [V1] `Runtime_Signup_Sheet.md` is retained and reachable.
- [V1] Documentation Sync Protocol describes the post-restructure boundary.
- [V3] HitM spot-checks the vault index renders cleanly in Obsidian.

## Completion Criteria

- design_docs holds only durable "how it works" + retained release ops (signup sheet/handoff templates); roadmap/versioning material retired or historical.
- Submodule committed on its own branch; parent pointer bumped (CPPR).
- Proposal `doc_structure_consolidation_proposal_2026-06-29.md` execution-split item for Cursor checked off.

## Notes

- This is **docs-only** but lives in a submodule — Cursor owns it (admin does not edit the submodule working tree). CPPR, not CPPRD-deploy.
- Do not delete; use the vault's `_historical/` / `.trash` convention so the audit trail survives.
- Downstream (separate, not this plan): the design-doc **sweep automation prompt**, authored against this settled boundary.
