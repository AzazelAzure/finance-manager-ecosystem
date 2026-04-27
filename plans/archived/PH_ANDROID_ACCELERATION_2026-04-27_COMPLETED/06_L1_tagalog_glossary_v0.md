# L1 Tagalog Glossary v0 (Critical Path)

## Purpose

Provide stable finance-domain terminology for `tl-PH` copy across critical-path UI surfaces while keeping backend contracts and logic in English.

## Scope

- Auth
- Profile
- Dashboard
- Transactions
- Upcoming expenses

## Terms

- **Dashboard** -> `Dashboard` (kept as product term)
- **Transaction** -> `Transaksyon`
- **Expense** -> `Gastos`
- **Income** -> `Kita`
- **Transfer** -> `Paglilipat`
- **Balance** -> `Balanse`
- **Pending** -> `Naghihintay`
- **Recurring** -> `Paulit-ulit`
- **Due Date** -> `Petsa ng Takdang Bayad`
- **Source** -> `Source` (kept for product consistency)
- **Category** -> `Kategorya`
- **Tag** -> `Tag`
- **Snapshot** -> `Snapshot` (kept as product term)
- **Profile Settings** -> `Mga Setting ng Profile`

## Review Protocol (v0)

1. Engineer proposes key/value pair in `core/i18n.py`.
2. Translator validates wording against glossary and UI context.
3. Reviewer checks consistency across critical pages.
4. Approved term is locked for this beta wave.

## Review Status

- Status: `v0 approved for critical-path execution`
- Owner: `orchestration-manager`
- Timestamp: `2026-04-27T11:43:00+08:00`
- Note: non-critical screens may still contain mixed-language copy and are queued post-gate.
