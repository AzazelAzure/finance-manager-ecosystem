# Skill: verdict-routing
Use when: every review (final decision)

Blocking findings:
- Any blocking GOVERNANCE/SECURITY/DOD/CORRECTNESS finding → REQUEST_CHANGES
- Missing context or ambiguous deploy/governance risk → NEEDS_HITM

Warnings:
- Non-blocking warnings alone do not force REQUEST_CHANGES if author may defer

Evidence required:
- Aggregated findings from all loaded lens skills

Route to NEEDS_HITM when:
- Cannot determine fixability within PR scope
- Required evidence missing after wrapper pre-run
- Review mode mismatch (e.g. dependabot criteria on feature PR without escalation)

Route to APPROVE when:
- CONFIDENCE=high, all CONTEXT_LOADED=yes, zero blocking findings, checks acceptable

Output notes:
- Emit exactly one VERDICT line
