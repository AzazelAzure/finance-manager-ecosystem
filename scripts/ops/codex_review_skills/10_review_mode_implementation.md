# Skill: review-mode-implementation
Use when: mode=implementation

Blocking findings:
- Apply lenses: golden-rules, dod, security, scope, hfm-invariants, api/web/migration as applicable

Warnings:
- Judgment-only GR items without diff evidence → warning not blocking

Evidence required:
- All P1 lens skills for changed areas (api/web/migration classifiers)
- Static scan outputs when injected

Route to NEEDS_HITM when:
- Large diff truncated without chunk synthesis guidance satisfied

Output notes:
- Orchestration bundle — delegate detail to lens skills 20-32
