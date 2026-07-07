# Skill: review-mode-submodule-bump
Use when: mode=submodule-bump (parent PR)

Blocking findings:
- Submodule pin to SHA not on subrepo main
- Pin bump without linked merged subrepo PR reference
- Unrelated parent file changes without explicit mixed-mode note

Warnings:
- Drift between pin and actual submodule HEAD in local status

Evidence required:
- submodule_status.sh output
- Diff showing submodule pointer lines only (+ expected parent CHANGELOG)

Route to NEEDS_HITM when:
- Cannot verify SHA exists on remote
