---
task_id: T12
status: pending
owner: unassigned
phase: P11
breakpoint: BP_BGSYNC
last_verification: null
---

# T12 — Optional Background Sync (Chromium)

## Objective

Add **optional** `sync` event / Background Sync where available, with **mandatory fallback** replay path (online + visibility + manual “Sync now”) per research README §1.1 (Chromium-only enhancement).

## Repo scope

- `finance_manager_web/`

## Dependencies

- T10–T11 complete for baseline drain.

## Checklist

- [ ] Feature-detect Background Sync; register only when supported.
- [ ] Fallback path tested on every build (no BS dependency for correctness).
- [ ] Document **SKIPPED** in `validation_gates.md` if HitM defers this task entirely.

## Definition of done

- **BP_BGSYNC** PASS or explicit **SKIPPED** with rationale in `validation_gates.md`.

## Verification

- Chromium: trigger sync registration; verify drain.
- Non-Chromium: verify fallback only.

## Risks

- Unreliable sync timing — never use as sole durability mechanism.

## PR expectations

- Small incremental PR optional after core outbox ships.
