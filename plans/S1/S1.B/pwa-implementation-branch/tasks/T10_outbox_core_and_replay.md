---
task_id: T10
status: pending
owner: unassigned
phase: P9
breakpoint: BP_OUTBOX
last_verification: null
---

# T10 — Outbox core + idempotent replay

## Objective

Implement **IndexedDB outbox** for v1 mutators (transactions + upcoming expenses): enqueue offline, drain online with **idempotent** replay per D2; handle 409/force-upgrade mid-drain.

## Repo scope

- `finance_manager_web/` (primary), depends on `finance_manager_api/` T01–T02

## Dependencies

- **BP_API_D2_CORE** + **BP_API_D2_BUILD** + **BP_WEB_BUILD** PASS.
- T08–T09 for local read/write coherence.

## Checklist

- [ ] Outbox record shape: method, url, body, idempotency key, ordering.
- [ ] Replay scheduler: single-flight; backoff on transient errors.
- [ ] Respect 409 → stop drain; surface upgrade UX (T03).
- [ ] DELETE semantics aligned with API.

## Definition of done

- **BP_OUTBOX** PASS; end-to-end proof against staging or prod-like env.

## Verification

- Manual: create/edit offline → online → data correct in API/UI.
- Unit tests for queue operations.

## Risks

- Duplicate submissions — rely on T01 idempotency; add client-side dedupe keys per D2.

## PR expectations

- May span multiple PRs; keep orchestration notes in PR bodies.
