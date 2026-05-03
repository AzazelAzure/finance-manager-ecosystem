---
task_id: T01
status: pending
owner: unassigned
phase: P1
breakpoint: BP_API_D2_CORE
last_verification: null
---

# T01 — API: D2 idempotency storage + mutating allowlist

## Objective

Implement server-side idempotency and **mutating-route allowlist** per [`../../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md`](../../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md) for v1 scope (transactions + upcoming expenses).

## Repo scope

- `finance_manager_api/`

## Dependencies

- T00 complete.
- Spec: D2 doc (read before coding).

## Checklist

- [ ] Persist idempotency records for mutating requests on allowlisted paths (design per D2).
- [ ] Enforce allowlist: reject or no-op off-scope mutators until explicitly expanded.
- [ ] **DELETE** idempotent success semantics per D2.
- [ ] Optional `Idempotency-Key` backward-compatible behavior per D2.
- [ ] Unit/integration tests for happy path + duplicate replay.
- [ ] `finance_manager_api/CHANGELOG.md` entry (CPPRD).

## Definition of done

- **BP_API_D2_CORE** criteria in plan `validation_gates.md` satisfied.
- API CI (tests/lint) green for touched scope.

## Verification

```bash
cd finance_manager_api && pytest  # or project-standard test command
```

## Risks

- Migration ordering — coordinate with any parallel API work; declare `conflicts_with` in PR if needed.

## PR expectations

- Feature branch from `cursor/s1b/pwa-implementation-branch` or direct host branch; target `main` after review; post PR URL in Cursor chat.
