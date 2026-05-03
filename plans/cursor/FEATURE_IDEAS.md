# Feature Ideas — Brain Dump (2026-05-03)

**Consolidated index (huddle + strategy + this file):** [`PRODUCT_FEATURE_BACKLOG_INDEX.md`](./PRODUCT_FEATURE_BACKLOG_INDEX.md)

Unstructured feature capture. No implementation plans yet. Each entry is a product idea to be slotted into sprint planning later.

**Format:** ID, title, what it does, why it matters, rough notes.

---

## F-001: Balance History & Trend Tracking

**What:** Track day-end balance snapshots per account. Store a daily closing balance record rather than per-transaction granularity. Surface this on the frontend as a line graph showing how each account's balance has changed over time.

**Current state:** System only tracks the balance as it currently stands — no historical record.

**Why it matters:** Core to the "safe to spend" wedge. Users can't understand their financial trajectory from a single number. A balance trend line shows whether they're slowly drowning or slowly recovering — that's the emotional hook that a notebook can't replicate.

**Rough notes:**

- Day-end snapshot approach keeps storage lean (1 row per account per day, not per transaction).
- Backend: likely a `BalanceSnapshot` model with `(account_id, date, closing_balance)`. Could be populated by a nightly batch job or calculated retroactively from transaction history.
- Frontend: line chart (per-account or all-accounts overlay). Date range selector (7d / 30d / 90d / all).
- Consider: backfill from existing transaction data for accounts that already have history.
- Consider: how this interacts with multi-account views and the safe-to-spend dashboard.

---

## F-002: Smart Tag Value Estimation

**What:** Use historical transaction data to estimate what proportion of a multi-tagged transaction each tag actually represents. Instead of attributing the full transaction amount to every tag, statistically apportion it based on patterns from the user's own data.

**Current state:** Each tag on a transaction shows the full transaction amount. A ₱2,000 grocery run tagged `food` + `household` shows ₱2,000 under both tags — misleading for budgeting.

**Why it matters:** Tags are the primary way users categorize spending, but the current "full amount on every tag" approach makes tag-level spending reports inaccurate. If the system can say "historically, your `food` tag represents ~60% of transactions also tagged `household`," users get a much clearer picture of where money actually goes — without manually splitting every transaction.

**Rough notes:**

- Core problem: statistical decomposition / proportional allocation across co-occurring tags.
- Approach candidates:
  - **Simple:** proportional split based on historical averages of single-tag transactions for each tag.
  - **Better:** regression or frequency-weighted allocation using tag co-occurrence matrix across all user transactions.
  - **Best:** Bayesian estimation that improves with more data — early guesses are rough, converges over time.
- Likely Rust candidate: the matrix math / statistical computation across large transaction histories could be heavy. Fits `finance_manager_rust_tools` or future `rust_middleware` scope.
- Doesn't need to be 100% accurate — "close enough to be useful" is the bar. Show confidence/certainty indicator to user.
- Consider: let users manually override the split on individual transactions to improve the model (feedback loop).
- Consider: minimum data threshold before estimates are shown (don't guess from 3 transactions).

---

## F-003: Predictive Budgeting & Spending Projections

**What:** Two layers. First, the standard "set a budget amount per category" that every app has — table stakes. Second (the differentiator): a projection engine that uses historical spending patterns, planned/upcoming expenses, and savings goals to forecast what the user can realistically expect to spend and where they'll land by end of pay period or month.

**Current state:** No budgeting tools. Users see balances and transactions but have no forward-looking view of where their money is going.

**Why it matters:** This is the "safe to spend" wedge made concrete. The wedge sentence says "what's actually safe to spend before payday" — that's literally a projection. A static budget says "you planned ₱5,000 for food." A projection says "based on your habits, you're on track to spend ₱6,200 on food, which will leave you ₱800 short on rent." That second thing is what thin-margin households actually need.

**Rough notes:**

- **Layer 1 (table stakes):** set budget per tag/category, track actual vs budget, show remaining. Every PFM has this. Must exist. Not the differentiator.
- **Layer 2 (differentiator):** projection engine that combines:
  - Historical spending velocity per tag (how fast you burn through categories)
  - Known upcoming/recurring expenses (from upcoming expenses feature)
  - Savings goals (F-XXX, future feature)
  - Pay cycle timing (when does income arrive?)
  - → Outputs: "at current pace, here's where you'll be on [date]" with scenario modeling
- Likely a "power user" / Pro tier feature for the full projection engine. Basic budget tracking could be free tier.
- Needs extensive design work on UX — projections are complex to display without overwhelming the "living thin" persona. Must be simple at a glance, detailed on drill-down.
- Ties directly into F-002 (smart tag calculations) for more accurate per-category spending estimates.
- Ties into F-001 (balance history) for the historical data feeding projections.
- Consider: "what if" scenario mode — "if I skip eating out this week, how does my month-end look?"
- Consider: confidence bands on projections (wider early in month, tighter as more data accumulates).
- Consider: how this relates to the existing safe-to-spend calculation — this may be the evolution of that core feature, not a separate tool.

---

## F-004: Configurable Safe-to-Spend Periods & Bill Juggling Projections

**What:** Two interrelated pieces. First: let the user define what their STS calculation window is — daily, weekly, bi-weekly, monthly — anchored to their actual pay cycle, not a fixed calendar month. Second: support partial bill payments ("bill juggling") in projections, so users who make promissory minimum payments to keep services active can model exactly what they need to spend and save to survive until next payday.

**Current state:** STS calculation exists and is accurate for what it does, but it's locked to a single period definition. Expenses that technically fall in "this month" but are really obligations against "next month's" income aren't distinguished. No support for partial bill payment strategies.

**Why it matters:** This IS the wedge. "What's actually safe to spend before payday" means nothing if the system doesn't understand *when* payday is, or that the user deliberately pays 60% of electric to keep the lights on while covering 100% of rent. Bill juggling isn't irresponsibility — it's survival math that thin-margin households do every single month. No Western PFM acknowledges this reality, let alone helps optimize it.

**Rough notes:**

- **Configurable STS period:**
  - User sets: pay cycle (monthly on 30th, bi-weekly on Fridays, etc.)
  - STS calculates against "money available until next income arrives," not against a calendar boundary
  - Allows multiple income sources with different cycles (freelance + part-time + GCash receive)
  - Expenses auto-attribute to the correct pay period based on when they actually drain funds, not when they're "due"
- **Bill juggling support:**
  - Mark an upcoming expense as "partial payment planned" with the intended payment amount
  - System tracks: full bill amount, planned partial payment, remaining balance, and when the remainder comes due
  - Projection shows: "if you pay ₱X on electric now and ₱Y next period, here's your STS in each period"
  - Ties into existing upcoming/recurring expenses feature
- **Cross-cycle attribution:**
  - Some expenses this month are really next cycle's burden (e.g., paid on the 28th but income arrives on the 30th — those 2 days matter)
  - User or system tags which pay cycle an expense "belongs to"
- Ties heavily into F-003 (predictive budgeting) — the projection engine needs to understand pay cycles and partial payments to be accurate
- Ties into volatile bills (already noted as existing feature need) — utility bills that fluctuate need both the partial payment AND the volatility estimate
- UX challenge: must not feel like a spreadsheet. The "living thin" persona needs this to be simple and reassuring, not anxiety-inducing. "You can make it if you do X" tone, not "you're ₱2,000 short" panic.
- Consider: pre-built templates for common PH pay patterns (monthly salary, freelance variable, OFW remittance schedules)
- Consider: this could be the single most important Pro tier justification — "the app that tells you HOW to juggle, not just that you should"

---

## F-005: Savings Goals with Target Dates & Dynamic Recalculation

**What:** Users set a savings goal with a target amount and target date. The system calculates what they need to save per pay cycle to hit that goal. As the user saves more or less than the required amount, the system recalculates the remaining per-cycle requirement in real time. Visual progress widget shows goal vs reality with projected completion date.

**Current state:** No savings goal tracking. Users could theoretically create a "savings" expense to budget for it, but that's a workaround — no target date, no recalculation, no visual progress.

**Why it matters:** For the "living thin" persona, savings feels impossible. Showing that "₱50/week for 6 months = that ₱1,300 school supply fund" makes it tangible. The recalculation is key — if they miss a week, the app doesn't guilt them, it just says "now it's ₱58/week, you're still on track for August." That's hopeful, not punishing.

**Rough notes:**

- **Goal definition:**
  - Target amount (₱)
  - Target date
  - Optional: linked account (where savings are held)
  - Optional: auto-calculate contribution from pay cycle (ties into F-004 STS period config)
- **Calculation engine:**
  - Required per-period = (target amount - current saved) / (remaining periods until target date)
  - Recalculates on every savings contribution (manual entry or tagged transaction)
  - If user oversaves: shows accelerated completion date
  - If user undersaves: adjusts required rate up, never shows "you failed" — shows "new pace needed"
- **Progress widget:**
  - Visual progress bar or thermometer (classic but effective)
  - Line chart showing planned trajectory vs actual trajectory (like F-001 balance history but goal-specific)
  - Milestone markers (25% / 50% / 75% / done)
  - Projected completion date based on current pace (may differ from target date)
- **Multiple goals:** users should be able to have multiple concurrent goals with independent tracking
- Ties into F-003 (predictive budgeting) — savings contributions are a planned "expense" that projections must account for
- Ties into F-004 (STS periods) — savings contributions per pay cycle need to be STS-aware
- Consider: goal templates for common PH needs (school enrollment, Christmas fund, emergency fund, balikbayan box)
- Consider: celebration UX when milestones hit — dopamine reinforcement matters here (same principle as F-001 balance trend going up)
- Consider: what happens when a goal is missed entirely? Graceful "extend" or "adjust" flow, never shame

---

## F-006: Customizable Dashboard Widgets (Select / Resize / Rearrange)

**What:** Make dashboard widgets user-configurable — selectable (show/hide), resizable, and drag-to-rearrange. Users should be able to build the dashboard view that matters to them.

**Current state:** Dashboard layout is fixed. Users see what we decided to show, in the order we decided.

**Why it matters:** Different users care about different things. The "living thin" persona wants STS front and center. A power user wants balance trends and tag breakdowns. Letting users customize reduces the "this doesn't feel like my app" friction and increases daily engagement. Also critical for mobile viewport — small screens need the most important widget on top.

**Rough notes:**

- Drag-and-drop reordering (react-grid-layout or similar)
- Show/hide toggle per widget
- Resize handles (small / medium / large per widget)
- Layout persisted per user (API-backed, not just localStorage — survives device switches)
- Consider: default layouts per persona or tier (free gets a simpler default, Pro gets more widgets available)
- Consider: mobile vs desktop layouts stored separately

---

## F-007: Guided Page Walkthroughs (Not Just a Popup)

**What:** Replace the current single-popup guide with a full interactive walkthrough per page and per widget. Step-by-step tour that highlights each element, explains what it does, and shows how to use it.

**Current state:** Single popup guide — easy to dismiss, easy to forget, doesn't cover individual widgets or page-specific features.

**Why it matters:** The "living thin" persona is not a finance app power user. They need hand-holding through what STS means, how to read a balance trend, what tags do, how upcoming expenses work. A single popup doesn't teach — a step-by-step walkthrough does. Also critical for reducing support burden (founding members asking "what does this number mean?").

**Rough notes:**

- Library candidate: react-joyride, intro.js, or similar step-by-step tour library
- Per-page tour (dashboard, transactions, accounts, upcoming expenses, etc.)
- Per-widget mini-tours accessible from a "?" icon on each widget
- First-time user gets auto-triggered walkthrough; returning users can re-access from help menu
- Tour completion state tracked per user (don't re-show tours they've completed)
- Consider: video snippets embedded in tour steps for complex features (savings goals, projections)
- Consider: localized tour content (Tagalog/English) when localization ships

---

## Known Bugs & Onboarding Fixes (from HitM sticky notes)

*Not new features — existing issues to be triaged into sprint slots. Captured here so they don't stay on sticky notes.*

### B-001: Cash Account Creation Defaults to Wrong Currency

**Issue:** When creating accounts during onboarding, the default "Cash" account doesn't default to the user's base currency.
**Expected:** Cash account should auto-set to whatever base currency the user selected in step 1/4 of onboarding.

### B-002: First Onboarding Source Currency Mismatch

**Issue:** The first onboarding source (account) doesn't default to the user's base currency as described in step 1/4 of the onboarding flow.
**Expected:** Should inherit the base currency choice made earlier in onboarding.

### B-003: Upcoming Expense Monthly Rollover Bug

**Issue:** When an upcoming expense is marked as "paid" but not tagged in a transaction, it does not properly roll over to the next month. The rollover logic apparently depends on transaction tagging to trigger the month advance.
**Expected:** Marking as paid should be sufficient to trigger rollover to next month, regardless of whether it's linked to a specific transaction.

---