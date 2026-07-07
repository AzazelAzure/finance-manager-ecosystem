# Skill: hfm-invariants-check
Use when: api/web implementation PRs

Blocking findings:
- User-facing "Unknown" balance/transaction source
- Backwards-compat re-export shims for removed APIs
- PaymentSource stored as internal source_id in user models
- Generated status fields treated as authority

Warnings:
- Missing validator on new model field

Evidence required:
- golden_rule_static_scan Unknown/compat patterns
- Diff paths under finance_manager_api / finance_manager_web

Route to NEEDS_HITM when:
- Cross-repo contract change without paired PR note
