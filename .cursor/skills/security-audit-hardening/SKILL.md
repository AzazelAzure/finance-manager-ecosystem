---
name: security-audit-hardening
description: Audit code and configuration for security risks, prioritize exploitability, and propose concrete hardening fixes. Use when reviewing auth, secrets, input handling, permissions, API exposure, dependency risk, or pre-release security readiness.
---

# Security Audit and Hardening

## Mission

Identify security weaknesses early, rank them by real risk, and drive actionable fixes without breaking product velocity.

## Focus Areas

- Authentication/session/token handling
- Authorization and access control checks
- Input validation and injection surfaces
- Sensitive data handling (PII, secrets, logs)
- API/proxy exposure and transport security
- Dependency and supply-chain risk
- Container/runtime hardening baseline
- Future crypto boundary readiness (for Rust/ZK integration)

## Audit Workflow

- [ ] Define audit scope (repo/path/feature and threat assumptions).
- [ ] Gather evidence from code, config, and runtime behavior.
- [ ] Identify findings with severity and exploitability context.
- [ ] Propose concrete fixes and minimum verification tests.
- [ ] Re-check high-severity findings after fixes.
- [ ] Publish residual risks and next hardening actions.

## Severity Model

- `Critical`: likely exploit path with high impact; must fix before release.
- `High`: meaningful exposure; prioritize in current execution wave.
- `Medium`: important hardening gap; schedule in near-term backlog.
- `Low`: low-impact/defense-in-depth improvement.

## Required Output Format

```markdown
## Security Findings
- Severity:
- Category:
- Location:
- Risk:
- Evidence:
- Recommended fix:
- Verification:

## Residual Risk
- ...

## Next Hardening Slice
- ...
```

## Delegation Defaults

- Use `explore` subagent for broad discovery and threat-surface mapping.
- Use `generalPurpose` subagent for targeted code-level remediation planning.
- Use `shell` subagent for dependency/runtime/security command checks.
- Use `design-docs-sync` when security behavior/policy expectations change.

## Guardrails

- Prioritize exploitability and impact over style concerns.
- Do not log secrets or sensitive tokens in findings.
- Keep recommendations reproducible and verification-oriented.
- For release readiness, block completion on unresolved Critical findings.
