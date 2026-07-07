# Skill: review-mode-governance
Use when: mode=governance (parent/Claude docs)

Blocking findings:
- Governance doc change without parent CHANGELOG (CPPRD)
- Plan registry inconsistency when plan files touched
- Resurrection of archived Slack/legacy workflow references
- Missing anomaly disposition in PR body

Warnings:
- Stale cross-references to moved paths
- Runtime signup sheet updated without verified event note

Evidence required:
- changed_file_classify governance bucket
- changelog_check output
- pr_body_contract output

Route to NEEDS_HITM when:
- Ambiguous governance impact across repos
