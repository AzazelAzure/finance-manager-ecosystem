# Skill: migration-review
Use when: api PR touches migrations/

Blocking findings:
- Non-reversible migration without data backup note
- Add non-null without default on large table
- Duplicate index/constraint risk

Warnings:
- Missing RunPython reverse when data migration present

Evidence required:
- migration_summary.sh output

Route to NEEDS_HITM when:
- Blue-green deploy constraint violated (long lock, destructive rename)
