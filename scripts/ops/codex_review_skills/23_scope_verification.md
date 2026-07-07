# Skill: scope-verification
Use when: every mode with plan context

Blocking findings:
- Files changed outside plan task target repo/domain without anomaly note
- Opportunistic refactors bundled into scoped task PR
- New routes/API surface not in task scope

Warnings:
- Changelog-only or docs-only additions tangential to task

Evidence required:
- plan_lookup / plan_export task_scope
- changed_file_classify.sh buckets
- PR title/body task statement

Route to NEEDS_HITM when:
- plan_id missing on governed work — cannot verify scope
