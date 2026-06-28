# Hive Finance Manager — Business Structure Briefing for Spouse (v2)

*Updated May 7, 2026. Replaces v1. Written in plain language — no technical jargon.*

> [!NOTE]
> **What changed since the first briefing:** We have decided to completely shut down US operations. No US customers, no US business entity. This simplifies a lot — but also raises new questions about how HitM gets paid and how we protect what belongs to whom. This version covers the updated plan.

---

## Quick recap: What is HFM?

A **personal finance app** for Filipino households on tight budgets — helps track cash, GCash/Maya balances, bills, and answers "how much can I safely spend before payday?" Works on phones and computers through a web browser, eventually offline too.

**Current status:** Working app, small invite-only test group (PH family members), ₱0 revenue, no registered business, no employees. HitM does everything with AI tools helping.

---

## The two roles in this business

This is the most important thing to understand. There are **two separate things** happening, and they belong to **two separate people**:

### Role 1: Technology Owner (HitM)

| What | Details |
|------|---------|
| **What HitM owns** | All the software code, all the designs, all the technical architecture, every piece of the technology |
| **What this means** | HitM created this product from nothing — it's years of work. The code is HitM's personal intellectual property, the same way an author owns their book or a musician owns their songs |
| **This does not change** | Under any arrangement. Whether we're married or not. Whether the business succeeds or fails. **The technology belongs to HitM, period.** |

### Role 2: Business Operator / Merchant of Record (You)

| What | Details |
|------|---------|
| **What you would do** | Register a Philippine business, handle payments from customers, manage PH taxes, be the official face of the business to the government and customers |
| **What this means** | You are the person who receives the money, issues receipts, files BIR returns, and handles the PayMongo (or GCash) merchant account |
| **What you own** | The registered PH business entity and its business assets (bank account, merchant account, customer relationships). **Not** the technology. |

### How these two roles connect

```
  HitM (Tech Owner)              You (MoR / Business Operator)
  ┌──────────────────┐           ┌──────────────────────────┐
  │                  │           │                          │
  │  Owns the code,  │──────────│  Uses the technology to  │
  │  the app, the    │ LICENSE   │  run a PH business.      │
  │  technology.     │ AGREEMENT │  Collects payments.      │
  │                  │──────────│  Handles PH taxes/BIR.   │
  │  Gets paid for   │           │  Employs any PH staff.   │
  │  providing the   │◄─────────│  Pays HitM for tech      │
  │  technology.     │  PAYMENT  │  services (when legal).  │
  │                  │           │                          │
  └──────────────────┘           └──────────────────────────┘
```

**In simple terms:** You run the PH business. HitM provides the technology. There's a written agreement between you that says HitM licenses (lends for use, not gives away) the technology to your business. This is not unusual — it's how companies like franchise restaurants work (McDonald's Philippines doesn't own the McDonald's recipes or brand; they license them from the US company).

---

## Why it's structured this way

### 1. Philippine law requires it (for now)

HitM is a US citizen who is **not yet a legal resident** of the Philippines. Philippine law restricts how foreigners can own and operate businesses:

- The **Anti-Dummy Law** (Republic Act 108) says a foreigner cannot use a Filipino as a "front" to secretly control a business that should be Filipino-owned
- A foreigner registering a sole proprietorship needs a minimum capital of **US$200,000** (about ₱11 million) — which is not realistic for a startup
- Payment processors (PayMongo, GCash) require a **Philippine-registered business** for merchant accounts

So the most practical path is: **you register the business, HitM provides the technology under a license agreement.**

### 2. It protects both of us

| What could go wrong | How the structure helps |
|--------------------|-----------------------|
| Business fails | The technology still belongs to HitM. Business debts are the business entity's problem, not the technology's. |
| Relationship issues | Clear ownership from day one — no argument about who built what. The code is HitM's. The business operations are yours. |
| Legal trouble | A proper licensing agreement shows the government this is a **real** arrangement, not a dummy. HitM genuinely provides tech services; you genuinely run the business. |
| HitM gains residency | The structure can evolve — HitM could become a partner, employee, or co-owner of the PH entity. But the IP ownership doesn't change. |

---

## What "genuine involvement" means for you

The Anti-Dummy Law means your role must be **real**, not just a name on paper. But it doesn't mean you need to do technical work or work full-time:

### What you WOULD do

| Responsibility | What it looks like |
|---------------|-------------------|
| **Sign business registration** | One-time: go to DTI, file the paperwork with your name |
| **Have access to business finances** | See the PayMongo dashboard, know how much money comes in |
| **Make business decisions** | Have a real say in pricing, marketing approach, customer-facing policies |
| **Sign tax filings** | Quarterly/annual BIR filings for the business |
| **Be aware of what the business does** | General understanding — you don't need to know how the code works, just what the app does and who it serves |
| **Manage any PH employees** | If we hire a social media person, they're technically your employee |

### What you would NOT do

- ❌ Write code or understand programming
- ❌ Work full-time on this
- ❌ Make technical decisions about the app
- ❌ Be responsible for server outages or technical bugs
- ❌ Manage AI tools or engineering processes

---

## The entity: DTI Sole Proprietorship (not OPC)

We previously discussed two options: **DTI Sole Proprietorship** vs. **OPC (One Person Corporation)**. The decision is **DTI Sole Proprietorship** because:

| Factor | DTI Sole Prop | OPC |
|--------|--------------|-----|
| **Cost to register** | ~₱1,000–5,000 | ~₱15,000–30,000+ |
| **Annual compliance** | Simpler | More paperwork (corporate secretary, audited financials) |
| **Personal liability** | You are personally liable for business debts | Limited liability (only what's invested) |
| **Speed** | Can register in days | Takes weeks to months |
| **Why we chose this** | Lower cost, faster, appropriate for a startup with near-zero revenue | Too expensive and complex for current scale |

> **About the liability concern:** Since the business has near-zero expenses (₱5,700/month server costs, all paid by HitM personally), and we're not taking on any debt or loans, the personal liability risk of a sole prop is very low right now. If the business grows significantly, we can convert to a corporation later for better protection.

---

## How HitM gets paid (this is the complicated part)

With no US company in the picture, the question is: how does money flow from your PH business to HitM?

### Right now: No payment needed

The business makes ₱0. HitM is building this on personal time with personal funds. No payment flow is necessary yet.

### When revenue starts: Options (counsel must confirm)

| Option | How it works | When it's possible |
|--------|-------------|-------------------|
| **A — Foreign contractor** | Your business pays HitM as a "foreign service provider" for software development and technology licensing. A written contract governs the fee. PH withholding tax applies. | Possibly now, but needs counsel confirmation on tax/visa implications |
| **B — Household income** | Your business pays you as owner. You share household income as a couple. | Now, but informal — no clean paper trail for HitM's US tax obligations |
| **C — Employment** | HitM gets a work permit and is employed by your business | Only after marriage + 13(a) visa + ACR I-Card + possibly AEP from DOLE |
| **D — Defer income** | Business accumulates revenue. Nobody draws income until legal structure is sorted. | Now — cleanest option while things are uncertain |

**Most likely path:** **Option D now** (defer income while the business is tiny and legal status is pending), transitioning to **Option A or C** once marriage, visa, and counsel sort the proper structure.

---

## The marriage question (and why it matters for business)

This isn't romantic advice — it's a legal reality that affects the business structure.

### Philippine marriage and property

Under Philippine law, when you get married, the **default** property arrangement is called **Absolute Community of Property (ACP)**:

| Under ACP (default) | What it means |
|---------------------|---------------|
| **All property becomes shared** | Everything either person owns before AND during marriage becomes joint property |
| **This would include the software** | If no prenup, HitM's code/IP could become shared marital property |
| **This is a problem** | Not because of trust — but because it creates legal ambiguity about who owns the technology |

### The solution: Prenuptial Agreement

A **prenuptial agreement** (executed BEFORE the marriage) can specify a different property arrangement. The recommended option:

| Property regime | What it means | Why it works |
|----------------|---------------|-------------|
| **Complete Separation of Property** | Each person keeps what they brought in and what they earn during marriage. No automatic sharing. | HitM's IP stays HitM's. Your business stays yours. Clean. |

**OR** at minimum:

| Property regime | What it means | Why it works |
|----------------|---------------|-------------|
| **Conjugal Partnership of Gains** | Only what's EARNED during marriage is shared. Things owned before marriage stay separate. | HitM's pre-marriage code stays HitM's. Revenue earned during marriage is shared. |

> **This is not about distrust.** This is about having clean legal documentation that protects both of us and makes it crystal clear to the government, to counsel, and to any future business partner that the technology has a defined owner. It actually **protects the business too** — if the IP ownership is murky, PayMongo, investors, or partners might get nervous.

### What the prenup would say about the business

In plain terms:

1. **HitM's intellectual property** (all software code, architecture, designs, trade secrets for HFM and any other projects) **remains HitM's exclusive property** — before, during, and after marriage.
2. **Your business entity** (DTI sole prop, bank accounts, merchant relationships) **remains your property**.
3. **The licensing agreement** between HitM and your business entity continues regardless of marital status.
4. **Revenue earned by the business** during marriage — this is negotiable. Under Complete Separation, it stays yours (as business owner). Under Conjugal Partnership, it's shared.

---

## What changes when HitM becomes a legal resident

Once HitM has legal residency in PH (through marriage + 13(a) visa), new options open up:

### The 13(a) Visa (Spouse of Filipino Citizen)

| What | Details |
|------|---------|
| **What it is** | Permanent resident visa for foreign spouses of Filipino citizens |
| **Process** | Marriage → Apply to Bureau of Immigration → 1-year probationary visa → Permanent status |
| **What it allows** | Live in PH indefinitely, work legally, invest in/establish businesses |
| **Work rights** | Allowed to engage in lawful employment (may still need Alien Employment Permit from DOLE — counsel must confirm) |
| **Business rights** | Can invest in businesses, subject to Foreign Investment Negative List restrictions |

### How the business structure could evolve

| Phase | HitM's status | Structure |
|-------|--------------|-----------|
| **Now** | Tourist/non-resident | HitM = foreign tech licensor. You = sole prop MoR. No employment. |
| **Post-marriage, pre-visa** | Married, visa pending | Same structure. Marriage doesn't change visa status. Prenup in place. |
| **Post-13(a) probationary** | 1-year probationary resident | HitM could potentially be employed by your business (counsel must confirm AEP requirement). OR continue as foreign contractor with better tax position. |
| **Post-13(a) permanent** | Permanent resident | Full options: employment, co-ownership, partnership. Could convert sole prop to partnership or corporation with HitM as minority/majority owner (depending on FINL restrictions for the industry). |

### What does NOT change regardless of residency

- ✅ **HitM owns the IP. Always.** The prenup locks this.
- ✅ **The licensing agreement stays in force.** HitM licenses tech to the business regardless of employment/residency status.
- ✅ **You are the MoR.** Even if HitM becomes a resident and takes a more active role, the merchant relationship and PH business operations can stay under your name.

---

## The money picture (updated, no US entity)

### Current costs

| Expense | Monthly | Paid by |
|---------|---------|---------|
| Coding tools (Cursor) | ~₱1,100 ($20) | HitM personal |
| Server hosting | ~₱2,200 ($40) | HitM personal |
| Domain + security | ~₱110 ($2) | HitM personal |
| **Total** | **~₱3,400/month** | **HitM personal** |

*Note: costs are lower than v1 because we dropped to a cheaper Cursor plan and are currently not paying for the $200/mo plan.*

### Startup costs (one-time, estimated)

| Item | Cost | When |
|------|------|------|
| DTI sole prop registration | ₱1,000–5,000 | When we register |
| Barangay + Mayor's permit | ₱2,000–10,000 | Same time |
| BIR registration | ₱500–1,000 | Same time |
| PH counsel (initial consultation) | ₱10,000–30,000 | Post-baby |
| Prenuptial agreement drafting | ₱15,000–50,000 | Before marriage |
| Licensing agreement drafting | ₱10,000–30,000 | With counsel |
| **Total estimated startup** | **₱38,500–126,000** | Spread over 6+ months |

### What we're NOT paying for (savings from US shutdown)

| Eliminated cost | Savings |
|----------------|---------|
| US LLC formation | ~₱28,000–56,000 |
| US LLC annual fees | ~₱11,000–28,000/yr |
| US tax advisor | ~₱28,000–112,000/yr |
| US-PH intercompany agreement | ~₱56,000–168,000 |
| **Total first-year savings** | **~₱123,000–364,000** |

---

## Timeline (revised, realistic)

| When | What | Who needs to act |
|------|------|-----------------|
| **Now (May 2026)** | Huddle decisions locked | Both |
| **June 2026** | Baby born | Both |
| **Jul–Sep 2026** | Recovery; budget stabilizes; informal PH counsel conversations | Both |
| **Sep–Nov 2026** | Prenuptial agreement drafted and signed (BEFORE marriage) | Both + counsel |
| **When ready** | Marriage + 13(a) visa application | Both |
| **Post-counsel** | DTI registration, business permits, licensing agreement | You (with HitM support) |
| **Post-registration** | PayMongo merchant account application | You |
| **Post-PayMongo** | First paid customers possible | Business |

> [!IMPORTANT]
> **The prenuptial agreement MUST be executed before the marriage.** Under Philippine law, a prenup signed after marriage is void. This is non-negotiable for IP protection.

---

## What we're deciding together

1. **Are you comfortable being the MoR** (the registered business owner) with the understanding that the technology belongs to HitM?
2. **Are you comfortable with a prenuptial agreement** that keeps IP ownership separate? (This protects both of us — your business assets stay yours too.)
3. **Which property regime** do you prefer? Complete Separation (nothing shared automatically) or Conjugal Partnership (pre-marriage stays separate, earnings during marriage are shared)?
4. **When should we engage counsel?** The warm contact (landlord's property owner who is a lawyer) is available. Budget is the constraint.
5. **Are you comfortable with deferred income for HitM** until the legal structure is properly set up?

---

## Questions you might have

**"If I'm the registered owner, am I on the hook if something goes wrong?"**
With a DTI sole prop: technically yes for business debts. But the business has no debts, no loans, and runs on ~₱3,400/month from HitM's personal funds. The risk is near zero right now. If it ever becomes a concern, we convert to a corporation.

**"What if we break up?"**
The prenup protects both sides. HitM keeps the technology. You keep the business entity and its assets. The licensing agreement either continues (if the business continues) or terminates. Neither person loses what they built.

**"What if I don't want to do this anymore?"**
You can close the DTI sole prop at any time. HitM can license the technology to a different entity (or wait until residency allows direct ownership). The business depends on your willingness, but the technology does not.

**"Does this make me liable for HitM's work?"**
No. The licensing agreement makes clear that HitM provides technology "as-is" to your business. You're not responsible for bugs, outages, or technical failures. You're responsible for the business operations side: payments, taxes, customer communication.

**"Why can't HitM just register the business?"**
Foreign sole proprietors need US$200,000 (₱11M) minimum capital. We don't have that. Once HitM has residency via the 13(a) visa, more options open up — but that's months or years away.

**"Is this legal?"**
This is the entire point of getting counsel. A **legitimate** licensing arrangement between a foreign IP owner and a Filipino business is legal. A **fake** arrangement where the Filipino is just a front is illegal (Anti-Dummy). Our arrangement needs to be real — which means your involvement must be genuine. Counsel will confirm the specifics.

---

*This document is a plain-language summary for discussion purposes. It is not legal or financial advice. All specific decisions about entity registration, prenuptial agreements, tax obligations, and legal compliance require qualified professionals in Philippine law.*
