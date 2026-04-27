# Risk and Retask Matrix

- Contract mismatch -> `multi-repo-orchestration`
- Implementation defect -> `bugfix-investigation-loop`
- Runtime/test instability -> `ci-test-triage`
- Container/runtime issue -> `container-runtime-podman-triage`
- Documentation drift -> `design-docs-sync`

Primary guardrail: no Rust production-offload work before PERF_3 evidence and gate approval.
