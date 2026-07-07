# Skill: output-contract-strictness
Use when: every review (output formatting)

Blocking findings:
- (wrapper rejects malformed output before merge)

Warnings:
- Medium/low confidence must not pair with APPROVE

Evidence required:
- CODEX.md output format section

Route to NEEDS_HITM when:
- Cannot produce parseable VERDICT/CONFIDENCE/CONTEXT_LOADED block

Output notes:
Required lines:
VERDICT: APPROVE|REQUEST_CHANGES|NEEDS_HITM
CONFIDENCE: high|medium|low
REVIEW_MODE: <mode>
CONTEXT_LOADED: diff=yes|no pr_metadata=yes|no plan_context=yes|no pr_readiness=yes|no
SKILLS_LOADED: <comma-separated skill basenames>
FINDINGS: one line per defect or "none"
SUMMARY: 2-3 sentences max
Finding format: CATEGORY | severity | path:line | summary
