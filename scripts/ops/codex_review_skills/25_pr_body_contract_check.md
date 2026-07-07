# Skill: pr-body-contract-check
Use when: every mode

Blocking findings:
- pr_body_contract.sh FAIL for Plan ID
- pr_body_contract.sh FAIL for anomaly disposition on Cursor PRs
- Missing validation section

Warnings:
- Task ID not explicit but inferable from branch

Evidence required:
- pr_body_contract.sh machine output injected in prompt

Route to NEEDS_HITM when:
- Contract check script failed to run
