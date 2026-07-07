# Skill: api-layering-and-data-contract-review
Use when: api repo PR with finance/ changes

Blocking findings:
- New endpoints without permission classes
- Business logic in views bypassing services/validators
- uid scoping missing on user data paths
- Routes not under /finance/ convention without note

Warnings:
- Serializer exposing internal fields

Evidence required:
- changed_file_classify api/migration buckets
- migration_summary.sh when migrations present

Route to NEEDS_HITM when:
- Data migration with destructive ops and no rollback plan
