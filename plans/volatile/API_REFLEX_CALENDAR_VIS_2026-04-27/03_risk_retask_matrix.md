# Risk and Retask Matrix

## Key Risks

- Contract drift between API and Reflex calendar implementation.
- Visualization scope creep before core calendar flow stabilizes.
- Performance assumptions made without high-volume evidence.
- Premature Rust integration distracting from near-term feature delivery.

## Mitigations

- Enforce API -> CLI -> Reflex gate order.
- Time-box calendar MVP before visualization expansion.
- Require PERF_3 evidence before Rust candidate commitments.
- Keep Rust work in planning/prototype lane until Track B gate opens.

## Retask Routing

- Implementation defect -> `bugfix-investigation-loop`
- Contract mismatch -> `multi-repo-orchestration`
- Runtime/test instability -> `ci-test-triage`
- Container/runtime issue -> `container-runtime-podman-triage`
- Documentation drift -> `design-docs-sync`
