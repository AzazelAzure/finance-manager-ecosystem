# Skill: review-mode-dependabot
Use when: mode=dependabot

Blocking findings:
- Critical/high CVE in advisory without HitM path
- Major semver bump without breaking-change assessment
- Security-sensitive package (auth, crypto, DB driver, HTTP parsing) with risky jump

Warnings:
- Minor/patch with green CI and lockfile-only diff may APPROVE

Evidence required:
- dependabot_pr_context.sh output
- dependabot_check.sh tier-1 result if injected

Route to NEEDS_HITM when:
- Tier-1 escalated serious CVE or unclear advisory severity
