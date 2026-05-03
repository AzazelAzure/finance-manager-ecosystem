# Payment Provider Research Notes & Justification (May 2026)

**Purpose:** This document captures the raw research, findings, and justifications that led to the locking of PayMongo as the PM1 Primary PSP, the GCash invoice workaround, and the deferral of Stripe. 

## 1. Recurring Subscriptions: GCash vs. Maya

The primary constraint for the S1.B wedge is offering a seamless Pro subscription using Philippine mobile wallets (GCash and Maya) as the primary payment method.

**Findings:**
*   **Maya:** Both PayMongo and Xendit fully support Maya for **native recurring billing** (Auto-Debit). Once a user links their Maya wallet, the PSP can automatically pull funds on a weekly/monthly/yearly schedule without manual user intervention.
*   **GCash:** While GCash is universally supported for *one-time* checkouts, **native Auto-Debit for recurring subscriptions is heavily restricted**. Standard API access from PayMongo and Xendit currently forces GCash into a one-time checkout flow. Some third-party enterprise integrations (e.g., Ezypay) or high-volume negotiations might unlock GCash auto-debit on Xendit, but it is not available out-of-the-box for standard SMEs.
*   **Conclusion:** We cannot rely on a "set it and forget it" auto-debit for GCash users out of the gate. 
*   **Resulting Strategy:** Maya users will get true recurring subscriptions. GCash users will be sent an automated monthly invoice/checkout link (manual renewal) until our transaction volume unlocks direct enterprise-level GCash auto-debit.

## 2. MDR Pricing Comparison (PayMongo vs. Xendit)

Both PayMongo and Xendit support DTI Sole Proprietorship KYB and have no monthly setup fees (pay-as-you-go). The decision came down to Merchant Discount Rates (MDR).

**PayMongo Rates:**
*   **Maya:** 1.79%
*   **GCash:** 2.23%
*   **Credit/Debit Cards:** 3.125% + ₱13.39 fixed fee

**Xendit Rates:**
*   **Maya:** 1.8%
*   **GCash:** 2.3%
*   **Credit/Debit Cards:** Typically ~3.0-3.5% + fixed fee

**Conclusion:** PayMongo offers slightly better rates on the critical e-wallet infrastructure (Maya and GCash). While PayMongo has a fixed ₱13.39 fee on cards, credit card penetration is low enough in the target PH market that optimizing for the e-wallet MDR yields better blended unit economics.
*   **Resulting Strategy:** PayMongo is selected as `PM1: PRIMARY_CANDIDATE`. Xendit is retained as a hot standby/secondary contingency.

## 3. The Stripe Deferral

**Findings:**
*   Stripe does not support local business registration in the Philippines.
*   If we route through the US LLC to get a Stripe account, Stripe *still* does not offer native support for GCash or Maya recurring subscriptions. It relies heavily on international card rails.
*   **Conclusion:** Since the strategic lock dictates a mobile wallet-first approach for PH users, Stripe is incompatible with the Phase 1 wedge. 
*   **Resulting Strategy:** Stripe is completely deferred until US-market acquisition (Phase 2) is triggered.

---
*Research conducted via public PSP documentation and pricing pages as of May 2026. Models assume a blended e-wallet MDR of ~2.0% for unit economics planning.*
