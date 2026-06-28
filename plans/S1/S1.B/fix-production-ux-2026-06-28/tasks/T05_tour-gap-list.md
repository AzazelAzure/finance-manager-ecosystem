# T05.SL3 — Tour form coverage gaps

**Plan:** `PLAN_CROSS_PRODUCTION_UX_FIX_2026-06-28`  
**Date:** 2026-06-28  
**Scope:** Documentation only (no tour code in this plan)

## Forms with incomplete or missing guided tour coverage

| Form / surface | Route / entry | Current tour coverage | Gap |
|---|---|---|---|
| Quick Add (income / expense / transfer) | Dashboard modal | Partial — dashboard tour points at quick actions; modal form fields have Help Mode wrappers but no Joyride step-through | No linear tour walks field-by-field through quick add submit |
| Transaction create / edit modal | `/app/transactions` | Partial — page tour + Help Mode on fields | No end-to-end tour for save flow, bill link, tags |
| Upcoming expense editor | `/app/upcoming-expenses` modal | Partial — list + add button tour; Help Mode on bill form fields | No tour through save / recurring / date window |
| Payment source create / edit | Data Hub modal | Help Mode on sources section only | No dedicated tour for source form fields |
| Profile / Settings forms | `/app/settings/profile` | Help Mode on overview + settings + security | No tour for spend accounts, timezone, password change |
| Data Hub category / tag forms | `/app/data` modals | Help Mode on section headers | No field-level tour for category/tag CRUD |
| Support bug / feature forms | `/app/support` | None observed | No tour or Help Mode on support ticket forms |
| Onboarding wizard (2-step) | `/app/onboarding` | N/A — wizard is setup, not discovery | Tours should not duplicate wizard; OK as-is |

## Recommended follow-up plan

- **Owner:** `PLAN_CROSS_GUIDED_TOURS_F007` extension or new `feat-tour-form-completion` slice under S1.B
- **Priority surfaces:** Quick Add → Transaction edit → Upcoming expense editor (matches production UX feedback)
- **Acceptance:** Each listed form has at least one Joyride tour (or explicit Help Mode parity decision) covering every required field before submit

## Notes

- Onboarding wizard re-enabled as **Option C** (currency + first source only); tours remain the discovery path for ledger forms.
- Profile **Run setup wizard again** button (`onboarding.restart`) is the return touchpoint for wizard re-entry.
