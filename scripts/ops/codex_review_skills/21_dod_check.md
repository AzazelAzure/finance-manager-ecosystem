# Skill: dod-check
Use when: all modes except dependabot-only lockfile

Blocking findings:
- Missing Plan ID or task ID in PR body
- Missing anomaly disposition line
- Missing validation/test evidence for non-trivial diff
- User-facing web change without PWA/tour/i18n rationale

Warnings:
- Deferred i18n tracked as follow-up slice (must be explicit)

Evidence required:
- pr_body_contract.sh output
- i18n_pwa_tour_scan.sh for web PRs

Route to NEEDS_HITM when:
- DoD criteria conflict with ambiguous plan scope
