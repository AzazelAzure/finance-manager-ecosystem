# T01 — Help mode → guide without extra annoyance

**Surfaces:** `TourProvider.tsx`, `HelpModeWrapper` usage on dashboard/transactions/upcoming as touched by this task.

## Slices

### T01.SL1 — Audit current flow

- [V0] Map state machine: help-mode click → spotlight → which user action currently starts Joyride; list files and handlers.

### T01.SL2 — Implement streamlined flow

- [V1] Implement UX so that **either** Joyride auto-starts when the guided target is activated in help mode **or** a single consolidated control (not a second mystery button) starts the linear tour; document choice in PR/body.
- [V1] `cd finance_manager_web && npm run build` — attach log to `evidence/T01.SL2_web_build.log`.

### T01.SL3 — Staging + smoke

- [V2] Run `./scripts/sprint_verify.sh` (non-dry) for inactive color with `--repos web` on branch; attach `evidence/sprint_verify_*.log` path here and in plan `runtime_handoff.md`.

### T01.SL4 — Browser verify

- [V3] On jsdevtesting, record short flow (screenshot or HitM signoff) showing help-mode → tour without the removed extra step; store under `evidence/T01.SL4_help_flow.png` (or `.webp`).

## Evidence table


| Slice   | Required artifact                                          |
| ------- | ---------------------------------------------------------- |
| T01.SL2 | `evidence/T01.SL2_web_build.log`                           |
| T01.SL3 | `evidence/sprint_verify_<ts>.log` (from sprint_verify run) |
| T01.SL4 | `evidence/T01.SL4_help_flow.png`                           |
