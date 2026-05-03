---
task_id: T07
status: pending
owner: unassigned
phase: P6
breakpoint: BP_SW_UPDATE
last_verification: null
---

# T07 — Service worker update lifecycle UX

## Objective

Implement explicit **update available** behavior when `registration.waiting` exists: product choice between user-triggered reload vs controlled `skipWaiting` — documented in repo per research README §6.

## Repo scope

- `finance_manager_web/`

## Dependencies

- T06 SW registration in place.

## Checklist

- [ ] Detect waiting worker; surface non-blocking UI (banner/toast).
- [ ] `skipWaiting` + `clients.claim()` only if policy chosen (document policy in README or `docs/`).
- [ ] Post blue/green deploy: operator note to verify update path (link T13).

## Definition of done

- **BP_SW_UPDATE** PASS; policy written in web repo.

## Verification

- Manual: deploy new build to inactive color or bump cache version locally; confirm UX.

## Risks

- Auto-skip without consent may lose unsynced state — align with D3/outbox before enabling aggressive auto-update.

## PR expectations

- Web PR only.
