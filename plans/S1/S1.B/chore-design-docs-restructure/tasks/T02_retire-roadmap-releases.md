# T02 — Retire Roadmap + Releases Overlap

## End State

`20_Roadmap/` is unambiguously historical (canonical roadmap is `strategy/strategic-roadmap-reframe`).
`30_Releases/` versioning-summary material is pulled out; the VPS checkout sheet and handoff
templates are retained.

## Acceptance Criteria

1. [V1] Active-sounding `20_Roadmap/` files moved under `20_Roadmap/_historical/` (finish the demotion the banner already implies); roadmap deep-context/feature lists may stay but headed as historical.
2. [V1] `30_Releases/` versioning-summary docs (per-version summary material) retired to historical/archive — the versioning system is deferred (`strategy/parking_lot/versioning-system-rework.md`).
3. [V1] **Retained in `30_Releases/`:** `Runtime_Signup_Sheet.md`, `Runtime_Owner_Handoff_Template.md`, `Git_Owner_Handoff_Template.md`.
4. [V1] Git/workflow *rules* docs (`Git_and_Workflow_Strategy.md`, `Git_Policy_Quickstart.md`) — canonical equivalents already live in `governance/branching_guidelines.md` / `deployment_protocol.md`; retire the design_docs copies or mark them historical with a pointer to governance.
5. [V1] `git mv` only — nothing deleted.

## Scope Lock

- **Repo:** `design_docs` submodule, own branch.
- **Keep:** `Runtime_Signup_Sheet.md` and handoff templates — these are live ops artifacts.

## Notes

- Per D6 Q3: versioning is broken-as-practiced (many small fixes, not discrete versions). Pulling the summary material out is intentional; revisit post-S1.B if at all.
- Do not migrate rule *content* into `governance/` in this task — governance already has the canonical versions. This task only retires/marks the design_docs duplicates.
