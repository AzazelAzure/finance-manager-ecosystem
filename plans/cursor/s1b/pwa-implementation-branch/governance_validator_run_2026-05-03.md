# Plan template validator — `plan_template.md` §6 (manual run)

**Plan:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`  
**Date:** 2026-05-03  
**Result:** Passes structural checks; **`status` remains `draft`** until `depends_on` research plan is `completed` in `plan_registry.md` (per plan README ready-rule and template §6 depends_on rule).

## Checklist

| # | Rule | Result |
|---|------|--------|
| 1 | YAML header parses | OK |
| 2 | All required fields present | OK |
| 3 | Enum fields use canonical values (`S1`, `P0`, `slack_gates`, `deployment.target_services` = `api` + `js`) | OK |
| 4 | `plan_id` format `PLAN_<DOMAIN>_<TOPIC>_<YYYY-MM-DD>` | OK — domain `CROSS` |
| 5 | `DOMAIN` is canonical prefix | OK — `CROSS` |
| 6 | `strategic_link` file exists | OK — `phases/S1_public_beta_position.md` |
| 7 | `strategic_link` points to phase doc, not strategic README | OK |
| 8 | All `depends_on` plan_ids exist in `plan_registry.md` | OK — `PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01` |
| 9 | All `depends_on` plans `completed` for `draft → ready` | **FAIL until research plan completed** — intentional; keep `draft` |
| 10 | No cycle in `depends_on` | OK |
| 11 | `standalone: false` implies `standalone_notes` | N/A (`standalone: true`) |
| 12 | `deployment.required: true` implies `target_services`, `bundle_required`, `smoke_targets` | OK |
| 13 | `deployment.target_services` ⊆ `{api, reflex, js, infra}` | OK |
| 14 | Body §0 Strategic Inheritance — four bullets | OK |
| 15 | Body §2 Out of scope non-empty | OK |
| 16 | Body §6 Verification Gates testable | OK |
| 17 | Registered in `plan_registry.md` | OK (Draft / Planning row) |

## Orchestration-manager handoff

- **Plan root:** `plans/cursor/s1b/pwa-implementation-branch/`
- **Read order:** `README.md` → `validation_gates.md` → `CROSS_AGENT_COORDINATION.md` → `tasks/T*.md` → `runtime_handoff.md`
- **Next action:** Execute T00 branch setup; advance API lane T01–T02 before outbox-heavy web work; keep T16 blocked until **BP_SPRINT_CLOSE**.
