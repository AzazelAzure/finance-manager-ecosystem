# Skill: golden-rules-check
Use when: implementation, governance, chore modes

Blocking findings (diff-reviewable):
- GR8: CHANGELOG stub "(fill bullets)" or missing when required
- GR16: PaymentSource linkage via source_id/FK instead of display name convention
- GR17: Greenfield API logic in views only — no validators/services
- Source-of-truth: live code contradicts injected plan without note

Warnings (judgment):
- GR3 lean files, GR4 separation, GR10 root-cause quality

Evidence required:
- golden_rule_static_scan.sh output when injected
- changelog_check.sh output

Route to NEEDS_HITM when:
- Cannot assess GR without missing plan/design context
