# Risk and Retask Matrix

## Retask Routing

- Implementation defect -> `bugfix-investigation-loop`
- Contract mismatch (API/reflex/android) -> `multi-repo-orchestration`
- Runtime/test instability -> `ci-test-triage`
- Container/runtime operations issue -> `container-runtime-podman-triage`
- Missing ownership/context -> `repo-exploration-briefing`
- Doc drift after behavior changes -> `design-docs-sync`

## Key Risks

- P0 hosted-beta work slips while Android starts early.
  - Mitigation: cap Android to contract-first until Gate B.
- Localization scope balloons beyond v0.
  - Mitigation: enforce critical-path only (PH+US).
- Tagalog-readability is delayed because translation ownership/tooling is undefined.
  - Mitigation: choose one path now: (1) full critical-path translation pass, or (2) onboard translators with glossary + review workflow.
- Language switching is unavailable in beta and blocks locale validation quality.
  - Mitigation: define an interim language-selector approach or run a short research spike with explicit decision deadline.
- Play Store process unknowns delay rollout.
  - Mitigation: run P1 in parallel and gate evidence early.

## Rollback Rules

- If Gate A fails, pause A1/A2 and continue localization hardening.
- If Gate B fails, continue Android infra only; no feature expansion.
- If Gate C fails, remain on internal testing, do not expand cohort.
