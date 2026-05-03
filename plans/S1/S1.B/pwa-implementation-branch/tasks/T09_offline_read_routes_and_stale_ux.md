---
task_id: T09
status: pending
owner: unassigned
phase: P8
breakpoint: BP_OFFLINE_READ
last_verification: null
---

# T09 — Offline read routes + stale UX

## Objective

Agreed routes read from local store when offline; **stale** state clearly indicated; online/offline inferred from **request outcomes** + outbox depth, not `navigator.onLine` alone (research README §3.1 point 5).

## Repo scope

- `finance_manager_web/`

## Dependencies

- T08 seed data available for reads.

## Checklist

- [ ] Route allowlist for offline read (dashboard, transactions list, etc. — align with product).
- [ ] Visual states: Live / Offline / Syncing / Blocked (auth) per research UX guidance.
- [ ] Reconcile stale local vs server after reconnect (version check or first contract failure → refresh prompt).

## Definition of done

- **BP_OFFLINE_READ** PASS.

## Verification

- Manual Chrome: offline mode in DevTools; walk primary flows.

## Risks

- Showing stale balances — copy and badges must be honest.

## PR expectations

- Web PR.
