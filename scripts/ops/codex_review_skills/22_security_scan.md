# Skill: security-scan
Use when: implementation, dependabot, any PR touching auth/secrets

Blocking findings:
- Hardcoded secrets, API keys, passwords in diff
- New AllowAny on privileged endpoints
- SQL string interpolation / raw queries without parameterization
- dangerouslySetInnerHTML without sanitization note
- CSP/security header weakening

Warnings:
- New dependency in security-sensitive area

Evidence required:
- golden_rule_static_scan.sh security hits
- Diff-only confidence — flag uncertain patterns as warning

Route to NEEDS_HITM when:
- Suspected credential leak requiring operator rotation decision
