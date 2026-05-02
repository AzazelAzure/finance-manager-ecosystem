# US entity — primarily serving customers in the Philippines

**Purpose:** Research scaffold for **Branch B** and for **US sister company** options. **Not tax or legal advice.**

## Why this file exists

If PH local ownership is delayed, HitM may still need to **contract, invoice, or receive settlement** for SaaS revenue from users in the Philippines. A **US-formed entity** (commonly LLC or Delaware/Wyoming LLC, or US corporation if investors dictate) is one bridge — feasibility depends on **cost, tax, and PSP KYB**, not formation filing fees alone.

## Cost buckets to model (evidence to fill)

1. **One-time US formation** — state fee, registered agent, operating agreement, EIN (if applicable).
2. **Annual US compliance** — franchise tax, annual report, registered agent renewal.
3. **Bookkeeping and filings** — US federal (and possibly state) obligations on foreign-sourced vs US-sourced income; **Form 1116 / treaty** questions if relevant.
4. **Philippines-side exposure** — whether **revenue from PH customers** creates:
   - withholding on payments **from PH residents to foreign suppliers**,
   - need for **local withholding agent** status by payor,
   - **permanent establishment** or **branch profit remittance** concepts if activities cross a threshold (highly fact-specific — advisor memo target).
5. **Payment rails** — US entity + PH payment methods: PSP acceptance, settlement currency, MDR, **beneficial ownership** disclosure.

## Feasibility criteria (HitM-defined)

Align with `01_unit_economics_and_costs.md` and ₱100/mo **runtime** cap distinction: entity compliance is **not** the same budget line as VPS, but **total drag** (cash + time) must stay survivable for pre-revenue and early-revenue phases.

| Criterion | Target evidence |
| --------- | ---------------- |
| All-in Year 1 cash cost | Itemized table |
| HitM hours / quarter for compliance | Advisor scope or DIY boundary |
| PSP can onboard entity + pay out | Screenshot of KYB checklist or sales engineer answer |
| No surprise PH registration triggered at MRR &lt; X | Written advisor threshold or “unknown” explicitly |

## Research outputs (deliverable checklist)

- [ ] Primary source or advisor summary on **PH withholding on cross-border SaaS/B2C** (if any at low revenue).
- [ ] US structure shortlist (LLC vs C-Corp) with **why** for solo founder + possible future US investors.
- [ ] Explicit **“not feasible if…”** lines (e.g. if PSP requires PH SEC registration for wallet settlement).

## Links

- [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) — may force US entity earlier than immigration.
- [DECISION_MATRIX.md](./DECISION_MATRIX.md) — lock row for “US bridge entity yes/no.”
- Payment plan: `plans/cursor/s1b/payment-provider-research/README.md`
