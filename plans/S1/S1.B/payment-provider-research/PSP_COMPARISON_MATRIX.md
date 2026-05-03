# Payment Service Provider (PSP) comparison matrix

**Strategic choice + HitM-only locks:** [DECISION_MATRIX.md](./DECISION_MATRIX.md) (Matrix 1–3, **PM1–PM5**).

**Status:** Research-backed product comparison. **HitM payment locks (PM1–PM4)** live in [`DECISION_MATRIX.md`](./DECISION_MATRIX.md); MDR and wallet rules **change** — re-check each provider’s current pricing and API docs before integration.

**Scenario focus:** Default KYB column is the **PH spouse-led settlement entity** (DTI vs OPC per counsel) per [`../entity-formation-research/README.md`](../entity-formation-research/README.md) §0.2 and [`../entity-formation-research/DECISION_MATRIX.md`](../entity-formation-research/DECISION_MATRIX.md) L2–L4. Contingency columns only as needed — see [`README.md`](./README.md) §0.6.

## 1. High-level comparison


| Feature                   | PayMongo                                                        | Xendit                                                       |
| ------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------ |
| **Market focus**          | Philippines-native SME onboarding                               | Regional APIs (PH among markets)                             |
| **DTI sole prop support** | Fully Supported — standard DTI Certificate, BIR COR, Valid ID   | Fully Supported — standard local business documents          |
| **GCash**                 | Native API supports **one-time** only (2.23%)                   | Native auto-debit often restricted/on-hold (2.3%)            |
| **Maya**                  | Fully supported for **recurring/auto-debit** (1.79%)            | Instantly available for auto-debit (1.8%)                    |
| **Recurring billing**     | Subscriptions API supports Maya & Cards (Fixed ₱13.39 card fee) | Subscriptions API supports Maya & Cards                      |
| **MDR (e-wallets)**       | Maya: 1.79%, GCash: 2.23%                                       | Maya: 1.8%, GCash: 2.3%                                      |
| **MDR (Cards)**           | 3.125% + ₱13.39                                                 | Typically ~3.0-3.5% + fixed fee (less relevant for PH wedge) |


## 2. KYB (know your business) — typical requirements (verify with PSP)

Expect (non-exhaustive):

1. **DTI** or SEC registration matching the legal merchant name.
2. **BIR** Certificate of Registration where applicable.
3. **IDs** for the registered owner / authorized signers.
4. **Proof of business** (live app, site, or store) per PSP risk rules.
5. **Payout bank** in the merchant’s legal name.

**Anti-Dummy / control:** PSP records should reflect **actual** ownership and authority as advised by counsel; do not route KYB through a non-owner entity to “pass” checks.

## 3. Subscriptions and wallets (product research)

- **Maya:** Seamless automated recurring billing (auto-debit) is natively supported by both PayMongo and Xendit.
- **GCash:** Native auto-debit is largely restricted. **Workaround strategy:** System will generate and send automated monthly invoices / checkout links (manual renewal) until transaction volume unlocks direct enterprise-level GCash auto-debit or alternative integrations.

## 4. Recommendation slot (post–HitM signoff)

Record primary + secondary + date in [`README.md`](./README.md) §5 after each release that changes PSP posture — **PM1–PM4** in [`DECISION_MATRIX.md`](./DECISION_MATRIX.md) are the authoritative lock rows (HitM CPPRd **2026-05-05**).
