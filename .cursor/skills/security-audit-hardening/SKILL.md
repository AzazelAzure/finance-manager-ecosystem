---
name: security-audit-hardening
description: Audit code and configuration for security risks, prioritize exploitability, and propose concrete hardening fixes. Loaded imperatively by pr-review-and-merge — not auto-triggered broadly. Use for auth, secrets, input handling, dependency risk, or pre-release security readiness.
---

# Security Audit and Hardening

Tool-mechanism-adjacent skill — invoked imperatively by `pr-review-and-merge`, not broad auto-trigger.

## Doctrine

- `governance/incident/security_protocols.md`.

## Loads

None — other skills load this one.

## Tools

- `scripts/security/run_audit.sh` — preferred when T01 fix lands.
- Interim: direct `pip-audit` / `npm audit` per repo scope (TBV: confirm tool actually ran).

## Procedure

- [ ] Define audit scope (repo/path/feature, threat assumptions).
- [ ] Run audit tooling; **TBV the output** — confirm checks executed, not silent crash → "0 findings".
- [ ] Identify findings with severity and exploitability.
- [ ] Propose concrete fixes and minimum verification for High/Critical.
- [ ] Re-check high-severity findings after fixes.
- [ ] Report residual risks.

## Severity model

- **Critical** — likely exploit, high impact; block merge.
- **High** — meaningful exposure; fix or explicit accept-with-risk before merge.
- **Medium** — schedule near-term.
- **Low** — defense-in-depth.

## Required output

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

## Audit pass
pass | fail | partial — with TBV notes on tooling
```

## Handoff

When loaded by `pr-review-and-merge`, include in parent handoff:
`Skill(s) used: security-audit-hardening` plus pass/fail.

## Guardrails

- Do not log secrets in findings.
- Block release readiness on unresolved Critical findings.
