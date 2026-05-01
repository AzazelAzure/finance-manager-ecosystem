# Cross-agent coordination — Reflex dashboard UI regression

## Repo ownership
- **Reflex only:** `finance_manager_reflex/` — all tasks T01–T02.
- **Ecosystem / API:** Submodule bump and `api-green` promotion are **separate** workstreams; do not mix commits.

## Handoff to orchestration-manager
- **Plan root:** `plans/archived/fix/reflex-dashboard-ui-regression/`
- **Read first:** `README.md` (phases), `validation_gates.md`, then task packets under `tasks/`.
- **Runtime:** Single owner for VPS smoke per `container-testing-orchestration.mdc`.

## Slack / PR (when execution starts)
- Open Reflex PR from `fix/reflex-dashboard-ui-regression`; post to `#pull-requests` per workspace rules.
- If a **contract** issue is discovered (API returns empty series incorrectly), stop T02 and file a **handoff note** in API repo plan/issue—do not patch API inside this Reflex PR without explicit scope.

## Parallelism
- T01 and T02 may be parallel **only** after Gate V1 partial prototype confirms chart work does not depend on final nav order; default is **sequential: T01 → T02** to reduce CSS merge conflicts.
