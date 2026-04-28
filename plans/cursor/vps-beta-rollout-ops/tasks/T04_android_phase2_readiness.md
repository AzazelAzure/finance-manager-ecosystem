# T04 Android Phase-2 Beta Readiness

## Objective
Start Android as a second-phase beta lane with clear contract/auth decisions and a runnable validation baseline.

## Scope Boundary
- Areas:
  - `finance_manager_android/`
  - API auth/contract docs and compatibility matrix
  - relevant roadmap docs
- Not a blocker for initial VPS beta launch.

## Required Checks
- Document Android beta auth decision (JWT-only vs OAuth/PKCE).
- Add Android rows to compatibility matrix for core APIs.
- Reconcile fixture contracts with live API payload expectations.
- Define minimal runnable Android baseline requirements for live smoke checks.

## Acceptance Criteria
- Android phase-2 execution packet is implementation-ready.
- Contract and auth ambiguity removed from docs.
- Live-validation checkpoints are defined (not fixture-only).

## Required Handoff
- Auth decision record.
- Matrix updates and contract diff notes.
- First implementation slice proposal (smallest runnable baseline).
