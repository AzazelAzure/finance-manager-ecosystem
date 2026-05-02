# Payment Service Provider (PSP) comparison matrix

**Status:** Research draft — **not** a HitM lock. MDR figures and product rules **change**; confirm on each provider’s **current** pricing and API documentation before modeling margin.

**Scenario focus:** One column of investigation is **PH DTI sole proprietorship** (e.g. spouse-led operating entity) because wallet-first PSP KYB often assumes a **local** merchant. Other entity columns remain in [`README.md`](./README.md) §0.6.

## 1. High-level comparison

| Feature | PayMongo | Xendit |
| :--- | :--- | :--- |
| **Market focus** | Philippines-native SME onboarding | Regional APIs (PH among markets) |
| **DTI sole prop support** | Commonly used path for local SMEs — confirm current KYB checklist | Supported — confirm website/catalog requirements |
| **GCash** | Verify current: one-time vs recurring in **your** integration | Verify current |
| **Maya** | Verify **Subscriptions API** coverage vs one-time checkout | Verify recurring / tokenization limits |
| **Recurring billing** | Compare native subscription + wallet support vs card-only | Compare subscription APIs vs wallet tokenization |
| **MDR (e-wallets / cards)** | **Verify** on [PayMongo pricing](https://www.paymongo.com/pricing) (or current URL) | **Verify** on [Xendit pricing](https://www.xendit.co/en/pricing/) (PH) |

## 2. KYB (know your business) — typical requirements (verify with PSP)

Expect (non-exhaustive):

1. **DTI** or SEC registration matching the legal merchant name.
2. **BIR** Certificate of Registration where applicable.
3. **IDs** for the registered owner / authorized signers.
4. **Proof of business** (live app, site, or store) per PSP risk rules.
5. **Payout bank** in the merchant’s legal name.

**Anti-Dummy / control:** PSP records should reflect **actual** ownership and authority as advised by counsel; do not route KYB through a non-owner entity to “pass” checks.

## 3. Subscriptions and wallets (product research)

- Map **Maya** vs **GCash** for **automated** renewal vs **manual** top-up UX.
- If wallet recurring is unavailable or gated, document **fallback** (e.g. periodic authorization, dunning).

## 4. Recommendation slot (post–HitM signoff)

Leave **blank** until §5 verification in [`README.md`](./README.md) — then record primary + secondary PSP and date.
