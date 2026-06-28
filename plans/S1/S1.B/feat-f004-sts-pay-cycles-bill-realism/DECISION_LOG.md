# F-004 Decision Log

Append-only. Check before design choices.

---

## 2026-06-28 — STS window defaults (T01)

**Decision:** Add `sts_window_mode` default `calendar_month` so legacy STS semantics unchanged until user configures pay cycle.

**Rationale:** Plan §6 verification requires regression for users with no new fields.

**Fields (v1):**
- `sts_window_mode`: `calendar_month` | `pay_cycle`
- `pay_cycle_frequency`: `weekly` | `biweekly` | `semimonthly` | `monthly` (required when `pay_cycle`)
- `pay_cycle_anchor_date`: next pay date anchor (required when `pay_cycle`)

**Deferred:** Multiple income sources per user; pay-cycle templates (PH presets).

---

## 2026-06-28 — Bill partial-pay storage (T02)

**Decision:** Store `planned_partial_amount`, `cycle_residual_amount`, `remainder_due_date` on `UpcomingExpense`; `bill_class` = `volatile` | `rigid`.

**Rationale:** Aligns with rulebook partial-payment state; avoids separate ledger table in v1.

**Deferred:** Forecast endpoint, audit history, volatile estimate bands (expansion annex).
