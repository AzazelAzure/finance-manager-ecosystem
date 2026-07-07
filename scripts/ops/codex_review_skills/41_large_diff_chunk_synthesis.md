# Skill: large-diff-chunk-synthesis
Use when: diff exceeds wrapper chunk threshold

Blocking findings:
- Omitted chunks may hide blocking defects → cannot APPROVE

Warnings:
- Aggregate chunk findings; highest severity wins

Evidence required:
- Chunk manifest with byte ranges and coverage %

Route to NEEDS_HITM when:
- Any security/governance chunk skipped or truncated
- Coverage below wrapper minimum
