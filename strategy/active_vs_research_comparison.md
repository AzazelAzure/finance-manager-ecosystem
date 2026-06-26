# Active vs Research Comparison Brief

**Generated:** 2026-06-26  
**Purpose:** Factual gap analysis between **what is running in production** (VPS green stack) and **what strategy/research documents prescribe** for S1.B exit and beyond.  
**Baseline:** [`strategy/current_status.md`](./current_status.md) (SSH-verified 2026-06-26). VPS re-check: web `3e2b370` on `agy/s1b/feat/landing-page-ux-seo`; api `1833e74` on `main`; green containers healthy ~12 days.

**This file is a comparison artifact, not source of truth.** Authoritative strategy: [`strategy/strategic-roadmap-reframe-53be/`](./strategic-roadmap-reframe-53be/). Authoritative live runtime: VPS `dev@159.198.75.194` (`~/finance_manager`).

---

## Summary Table

| Dimension | Active / Live (VPS green `:8443`) | Research / Strategy Target | Gap Severity |
|-----------|-----------------------------------|----------------------------|--------------|
| **Product / feature surface** | S1.A tight-beta core (ledger, dashboard, upcoming expenses, bug report); partial F-011 landing on stale branch; **no F-007**, **no F-012/F-013**, **no F-001–F-006** | S1.B exit: wedge landing polish, F-007 shipped, **"worth paying for"** feature set (F-001+), founding backend, wedge audit, Android pull-forward to Alpha | **Critical** (live lags `main` by weeks; most S1.B feature work absent on VPS) |
| **PWA / offline** | Pre-Advanced PWA stack (no Dexie outbox, no `PwaWriteContractMiddleware`, no idempotency/`X-Client-Build` on API) | **Advanced tier** locked: offline read/write, outbox resync, forced upgrade, D0 Chrome matrix, D2/D3/D4 contracts; D4-exec **PASS** on `:8443` per docs | **Critical** (gate satisfied on `main`, **not on live**) |
| **Payments / monetization** | **None** — no SKUs, checkout, subscriptions, or wallet rails | PayMongo primary (~2.0% MDR), Pro **₱249**, Pro+ AI **₱349**, founding **≤100** @ **₱999–₱1,499**; GCash/Maya primary at S1.C | **Critical** (research locked; zero implementation) |
| **Entity / legal** | No PH or US entity registered; counsel not formally engaged | PH **spouse-led** MoR (DTI vs OPC TBD) + HitM **US LLC** as vendor; gates PSP KYB and S1.B exit | **Critical** (S1.B exit blocker) |
| **Infrastructure / runtime** | Podman blue-green on `:8443`; green active; ~$40 VPS; within **₱100/mo** cap; stable ~12 days | Same architecture assumed; script-driven deploy; one-feature-per-inactive-color | **Low–Medium** (design matches; **deploy sync** is the gap) |
| **Tooling / orchestration** | Cursor Pro+ **~$60/mo**; Antigravity for planning; Slack bridge scripts; **no shipped orchestrator**; 5–12 hr/day babysitting (huddle finding) | Session 5: orchestrator script, Slack monitoring-only, reviewer higher tier **deferred**; CBA: bottleneck is **human decisions**, not model tier | **Medium–High** (process/orchestration lag vs research) |
| **Security posture** | S1.A hardening live (JWT, CORS/CSRF, log redaction, env hygiene) | `governance/security_protocols.md`: axes lockout, Argon2, 12-char + complexity, HSTS 1yr, CSP; Session 4 infra/security **pending** | **High** (hardening exists **local-only**, uncommitted) |

---

## 1. Product / Feature Surface

### Active / Live

- **Runtime:** Invite-only beta at `thehivemanager.com:8443` (green stack).
- **Web** @ `3e2b370` (`agy/s1b/feat/landing-page-ux-seo`, 2026-06-13): S1.A flagship surfaces — transactions, dashboard, upcoming expenses, sources, settings; landing-page UX work from F-011 branch; **missing** merged F-007 walkthroughs, post-merge PWA fixes, HFM icon fixes on `main` @ `c855791`.
- **API** @ `1833e74` (`main`, 2026-05-04): ~6 weeks behind pinned `49dd0ff` — no `completed_tours`, no offline exchange rates endpoint, no PWA write middleware.
- **Shipped on `main` but not live:** F-007 (guided tours + help mode), F-011 final merge, PWA Advanced implementation (`pwa-implementation-branch/` completed per [`plans/S1/S1.B/README.md`](../plans/S1/S1.B/README.md)).
- **Not started on live or `main`:** F-001–F-006 ("worth paying for" wedge features), F-008–F-010 (draft), F-012/F-013 (open PRs #60–#61), Android (`android:Scaffold`), founding member program backend, wedge consistency audit execution, ToS/Privacy/Refund policies.

### Research / Strategy Target

- **S1.B scope** per [`strategy/strategic-roadmap-reframe-53be/validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md) and [`plans/S1/S1.B/README.md`](../plans/S1/S1.B/README.md): distribution readiness — research complete, **feature work** that proves Pro tier worth ₱200/mo, landing/wedge polish, founding backend, Android pull-forward to **Alpha**.
- **Feature plans** F-001–F-013 indexed in [`plans/S1/S1.B/README.md`](../plans/S1/S1.B/README.md); sprint execution order still **draft** ([`strategy/huddles/2026-05-22-feature-rollout-sprint-order/`](../strategy/huddles/)).
- **Wedge** locked in [`00_strategic_context.md`](./strategic-roadmap-reframe-53be/00_strategic_context.md) §1 — safe-to-spend hero must appear on dashboard, landing, and marketing surfaces.

### Gap & Implication

| Gap | Implication |
|-----|-------------|
| VPS **12+ days** without promote of `main` | Testers see **pre-June** product; undermines trust for distribution and wedge messaging. |
| F-001–F-006 still **draft** | **"Worth paying for"** S1.B exit criterion cannot be met without execution + deploy. |
| F-012/F-013 unmerged | Support intake and per-UUID diagnostic logs (F-013) not in production pipeline. |
| Android still **Scaffold** | Violates [`00_strategic_context.md`](./strategic-roadmap-reframe-53be/00_strategic_context.md) §3.3 pull-forward intent for S1.B. |

**Severity: Critical** — largest immediate gap is **deploy drift**; structural gap is **unfinished feature portfolio** for S1.B exit.

---

## 2. PWA / Offline

### Active / Live

- Green web/API pair predates **Advanced tier** implementation (API lacks `PwaWriteContractMiddleware`, idempotency storage, `GET /finance/exchange_rates/` for offline FX).
- Installability may exist from earlier S1.A work, but **offline write queue, outbox FIFO replay, 409 force-upgrade, 3-month seed, logout outbox warning** are absent on live SHAs.

### Research / Strategy Target

- **Tier lock:** Advanced per [`plans/S1/S1.B/pwa-install-offline-sync-research/README.md`](../plans/S1/S1.B/pwa-install-offline-sync-research/README.md) §1.1 — offline read/write, IndexedDB outbox, resync, forced client upgrade.
- **D0:** Chrome desktop + Chrome Android certified ([`D0_BROWSER_MATRIX.md`](../plans/S1/S1.B/pwa-install-offline-sync-research/D0_BROWSER_MATRIX.md)).
- **D2:** Idempotency + mutating allowlist + `X-Client-Build` + 409 ([`D2_API_OUTBOX_CONTRACT.md`](../plans/S1/S1.B/pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md)).
- **D3:** Refresh-first replay, logout confirm ([`D3_AUTH_OFFLINE_SESSION.md`](../plans/S1/S1.B/pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md)).
- **D4-exec:** Smoke on deployed `:8443` — documented **PASS** 2026-06-16 in parent `main` / [`validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md) (validated against **code on `main`**, not current VPS SHAs).

### Gap & Implication

| Gap | Implication |
|-----|-------------|
| Live stack ≠ `main` PWA code | **D4-exec PASS does not describe production** today; S1.B PWA exit bullet is **true in git, false on VPS**. |
| PH persona needs offline-first ([`00_strategic_context.md`](./strategic-roadmap-reframe-53be/00_strategic_context.md) §2) | Live testers cannot exercise offline writes/resync the research mandates. |
| Re-promote required after pull | Blue-green inactive-color rebuild + smoke per [`governance/deployment_protocol.md`](../governance/deployment_protocol.md). |

**Severity: Critical** — documentation/research says done; **live reality is not**.

---

## 3. Payments / Monetization

### Active / Live

- **No billing infrastructure:** no PayMongo/Xendit integration, no subscription SKUs, no founding-seat checkout, no entitlement gating in API or web.
- Beta is **free invite-only**; no pricing surfaces beyond informational copy on landing (if present on stale branch).

### Research / Strategy Target

- **Pricing locks** (2026-05-01): Pro **₱249/mo**, Pro+ AI **₱349/mo**, PAYG floor **₱99 → 100 credits**, founding **≤100** seats @ **₱999–₱1,499** — [`01_unit_economics_and_costs.md`](./strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md) §2.
- **PSP locks** (2026-05-05): **PayMongo** primary, **Xendit** contingency, **~2.0%** blended wallet MDR — [`plans/S1/S1.B/payment-provider-research/DECISION_MATRIX.md`](../plans/S1/S1.B/payment-provider-research/DECISION_MATRIX.md).
- **Mobile wallet primary** (GCash/Maya) — hard constraint [`00_strategic_context.md`](./strategic-roadmap-reframe-53be/00_strategic_context.md) §3.9; required functional at **S1.C entry** per [`validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md).
- **S1.B exit:** payment provider **decision** made (research done); **S1.C entry:** billing infra **live**.
- **AI economics deep-dive** shelved until entity + PSP path clear — [`plans/S1/S1.B/ai-economics-deep-dive/`](../plans/S1/S1.B/ai-economics-deep-dive/).

### Gap & Implication

| Gap | Implication |
|-----|-------------|
| Zero revenue rails | S1.C (founding beta) **blocked** regardless of product polish. |
| PSP KYB blocked on entity | Research chose PayMongo but **cannot onboard** without PH merchant vehicle. |
| Break-even math assumes ~27 Pro subs @ current overhead | [`cursor_vs_claude_max_cba.md`](./cursor_vs_claude_max_cba.md) — **0 paying users** today. |

**Severity: Critical** for S1.C; **expected** for current S1.B sub-stage (research-first), but entity delay extends monetization timeline to **late 2026 – early 2027** per huddle projection.

---

## 4. Entity / Legal

### Active / Live

- **No registered PH business entity** and **no US LLC** in operation for the product.
- PH counsel contact warm but **not formally engaged** (Session 1 S1-D02 deferred post-baby).
- Spouse-led operating intent **not yet legalized**.

### Research / Strategy Target

- **Operating pipeline lock** (2026-05-03): PH **spouse-led** merchant of record (DTI sole prop preferred over OPC pending counsel) + HitM **US LLC** as contracted IP/vendor — [`plans/S1/S1.B/entity-formation-research/README.md`](../plans/S1/S1.B/entity-formation-research/README.md) §0.2.
- **Session 1 decisions:** no business loans (S1-D05); timeline extended post-baby (S1-D08) — [`sessions/session-01-legal-entity/SESSION_NOTES.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-01-legal-entity/SESSION_NOTES.md).
- **S1.B exit gate:** entity formation **decision made** — [`validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md).
- **Cross-border tax topology** must be mapped before first revenue — Session 1 parking lot.

### Gap & Implication

| Gap | Implication |
|-----|-------------|
| Research **locked structure**, live **no entity** | PSP KYB, ToS counsel review, and founding program legality **cannot complete**. |
| Counsel engagement deferred | DTI vs OPC, Anti-Dummy substance, intercompany agreement **unresolved**. |
| Blocks payment-provider integration | [`payment-provider-research/README.md`](../plans/S1/S1.B/payment-provider-research/README.md) `depends_on` entity formation. |

**Severity: Critical** — explicit S1.B exit blocker; cascades to payments and S1.C.

---

## 5. Infrastructure / Runtime

### Active / Live

- **Podman** blue-green on VPS; **green** active (`fm-beta_web-green_1`, `fm-beta_api-green_1` healthy ~12 days).
- **Proxy** `fm-beta_proxy_1` on host **`:8443`** HTTPS.
- Supporting: `fm-beta_db_1`, `fm-beta_redis_1`; inactive blue pair healthy.
- **Cost:** ~$40 VPS + domain within **₱100/mo** runtime cap — [`01_unit_economics_and_costs.md`](./strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md) §1.
- **Drift:** web on feature branch, api on stale `main`; no promote since ~2026-06-13.

### Research / Strategy Target

- Blue-green Docker/Podman on `:8443` — **matches** S1.A outcome and [`governance/deployment_protocol.md`](../governance/deployment_protocol.md).
- **One feature at a time on inactive color** — [`governance/branching_guidelines.md`](../governance/branching_guidelines.md).
- Single production API; no Redis HTTP version routing — locked 2026-05-01.
- Script-first lifecycle: `scripts/fm_docker.sh`, `scripts/fm_server_beta.sh`.

### Gap & Implication

| Gap | Implication |
|-----|-------------|
| Infra **design** aligned | Runtime mode, cost cap, and topology match roadmap. |
| **Deploy hygiene** misaligned | Live SHAs diverge from parent submodule pins — operational process gap, not architecture gap. |
| 12-day uptime without refresh | Stable but **stale**; increases risk that validation docs overstate production. |

**Severity: Low–Medium** — fix is operational (sync + rebuild inactive color + promote), not architectural.

---

## 6. Tooling / Orchestration

### Active / Live

- **Cursor Pro+** ~**$60/mo** — primary coding agent ([`current_status.md`](./current_status.md) §16).
- **Antigravity (Gemini)** — planning/research; deprecated for code per Session 5 TP17.
- **Slack bridge scripts** exist; governance still references PA/Slack routing — drift vs local [`admin_huddle_handoff.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/admin_huddle_handoff.md).
- **`scripts/orchestrator.py`** — present locally, **untracked**, not canonical in committed governance.
- **Branch prefix drift:** `agy/s1b/*` on recent PRs vs `cursor/s1b/*` in committed rules.
- **Operator cadence:** decompression **6 hr/day, 30 hr/week** post-baby.

### Research / Strategy Target

- **Session 5** ([`SESSION5_AUTOMATION_AND_TOOLING.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-05-tooling-agents/SESSION5_AUTOMATION_AND_TOOLING.md), [`SESSION_NOTES.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-05-tooling-agents/SESSION_NOTES.md)):
  - **T-D02:** Orchestrator script manages coder→reviewer loop; Slack **monitoring only**.
  - **T-D05/T-D13:** Cursor **$200/mo** upgrade **deferred** — no funds.
  - **T-D06:** Higher-model reviewer — deferred.
  - **P1+P2 delivered:** `governance/agent_context_delivery.md`, `governance/sprint_task_specification.md` (local/untracked in places).
- **CBA** ([`cursor_vs_claude_max_cba.md`](./cursor_vs_claude_max_cba.md), 2026-06-19):
  - Primary bottleneck: **human decisions**, entity, sprint order — not model choice.
  - **Stay on Pro+ ($60)** unless revenue justifies $200 tier.
  - 5–12 hr/day babysitting — tooling alone cannot fix orchestrator gap.
- **Cluster C** ([`TP16_AND_CLUSTER_C.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md)): conservative **30–40 week** S1.B feature timeline (late 2026 – early 2027).

### Gap & Implication

| Gap | Implication |
|-----|-------------|
| Orchestrator **designed, not shipped** | Babysitting hours remain; Session 5 #1 objective unmet. |
| Governance **drift** (Antigravity-first handoff vs committed Cursor/Slack docs) | Agents get conflicting instructions; wastes context-loading time. |
| Tooling spend matches CBA **status quo** | Aligned with research recommendation; **not** aligned with Session 5 automation end-state. |

**Severity: Medium–High** — does not block deploy, but **extends calendar** to S1.B exit per TP16 math.

---

## 7. Security Posture

### Active / Live

- **S1.A shipped:** HSTS (baseline), log redaction, CORS/CSRF hardening, JWT handling — [`current_status.md`](./current_status.md) §4.
- **Not on VPS:** django-axes account lockout, Argon2 default hasher, 12-char + `ComplexPasswordValidator`, extended HSTS defaults, `SECURE_CONTENT_TYPE_NOSNIFF`, web CSP meta — exist as **local uncommitted** API/web edits ([`current_status.md`](./current_status.md) §8).
- **`governance/security_protocols.md`** — documents axes/Argon2/CSP requirements; **untracked** in parent repo.

### Research / Strategy Target

- Security protocols doc mandates axes, Argon2, password policy, HSTS, CSP — [`governance/security_protocols.md`](../governance/security_protocols.md).
- **Session 4 — Infra & Security** (TP1, TP4, TP26, TP15, TP8): **`pending`** — not yet held ([`current_status.md`](./current_status.md) §13).
- S1.A API hardening was baseline; S1.B expects **production-grade** auth hardening before public-adjacent distribution scales.

### Gap & Implication

| Gap | Implication |
|-----|-------------|
| Hardening **written locally, not CPPRD** | Production remains on weaker password hashing and **no** brute-force lockout. |
| CSP only in local `index.html` WIP | XSS/CSP policy not enforced for live users. |
| Session 4 undecided | No locked infra/security decisions beyond scattered local edits. |

**Severity: High** — exploitable gap between **documented intent** and **live + committed** state.

---

## Gaps That Block S1.B Exit (Prioritized)

1. **VPS deploy drift** — Live web/API do not run `main` PWA + F-007 code; D4-exec PASS is **non-transferable** until promote. *Action class: deploy (inactive-color rebuild + smoke + switch).*
2. **Entity formation decision + registration** — Research pipeline locked; **no legal vehicle**. Gates PSP KYB, ToS, founding program. *Action class: counsel engagement (human).*
3. **Payment provider integration prep** — Decision locked (PayMongo); **zero implementation**; blocked on entity. *Action class: post-entity engineering.*
4. **"Worth paying for" feature work** — F-001–F-006 (and sprint order) still draft; Pro tier not demonstrable. *Action class: product execution.*
5. **Founding member program backend** — Not live. *Action class: API + web feature.*
6. **Android pull-forward to Alpha** — Still `android:Scaffold`. *Action class: mobile execution.*
7. **Wedge consistency audit** — Plan draft; execution not started. *Action class: audit + fixes.*
8. **ToS + Privacy + Refund policies** — Not drafted/live. *Action class: legal/content.*
9. **AI Economics Deep-Dive** — Shelved; 16 decisions unresolved; blocks clean Pro+ AI launch planning. *Action class: research (post-entity/PSP).*
10. **Distribution channel research completion** — Draft. *Action class: research + content cadence.*
11. **Security hardening CPPRD** — Local axes/Argon2/CSP not committed or deployed. *Action class: API/web PR + deploy.*
12. **F-012/F-013 merge + deploy** — Support intake and diagnostic logs in open PRs only.

**Already satisfied on `main` (verify on VPS after deploy):** email uniqueness S0, Reflex archival, KNOWN_ISSUES #1/#4/#7, PWA Advanced implementation, F-007/F-011 merges.

---

## Live-vs-Strategy Drift Risks

| Risk | Description | Mitigation |
|------|-------------|------------|
| **Validation doc false positive** | `validation_gates.md` PWA bullet marked PASS while VPS lacks Advanced code | Re-run D4-exec smoke **after** promote; annotate gate with deploy SHA |
| **Tester experience ≠ roadmap story** | Invitees on 2026-05-04 API see product that contradicts June research/sign-off | Treat VPS sync as **P0** before new invites or distribution |
| **Governance fork** | Untracked Antigravity/orchestrator handoff vs committed Cursor/Slack governance | CPPRD reconcile: pick canonical orchestration doc |
| **Research "locked" ≠ live** | Pricing, PSP, entity structure locked on paper; **no runtime expression** | Do not open S1.C messaging until entity + billing infra live |
| **Security protocols ahead of code** | `security_protocols.md` describes axes/Argon2 not in production | Commit + deploy hardening before widening beta |
| **Calendar optimism** | Parent `main` 10-day commit gap; decompression cadence; 5 open PRs | Use Cluster C **likely** timeline (late 2026 – early 2027), not original May–Jul S1.B window |
| **Quarterly self-review** | Due **2026-06-30** ([`kill_commit_gates.md`](./strategic-roadmap-reframe-53be/kill_commit_gates.md) §6) | Complete before scope creep on tooling upgrades |

---

## Sources Cited

| Path | Use |
|------|-----|
| [`strategy/current_status.md`](./current_status.md) | VPS SHAs, containers, open PRs, local diffs (primary live baseline) |
| [`strategy/strategic-roadmap-reframe-53be/README.md`](./strategic-roadmap-reframe-53be/README.md) | Phase/stage map |
| [`strategy/strategic-roadmap-reframe-53be/00_strategic_context.md`](./strategic-roadmap-reframe-53be/00_strategic_context.md) | Wedge, locked decisions, Android, payments |
| [`strategy/strategic-roadmap-reframe-53be/validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md) | S1.B exit checklist |
| [`strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`](./strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md) | Pricing, overhead, break-even |
| [`strategy/cursor_vs_claude_max_cba.md`](./cursor_vs_claude_max_cba.md) | Tooling CBA |
| [`plans/S1/S1.B/README.md`](../plans/S1/S1.B/README.md) | Sub-plan and F-id index |
| [`plans/S1/S1.B/pwa-install-offline-sync-research/README.md`](../plans/S1/S1.B/pwa-install-offline-sync-research/README.md) | PWA Advanced, D0–D4 |
| [`plans/S1/S1.B/payment-provider-research/README.md`](../plans/S1/S1.B/payment-provider-research/README.md) | PSP locks |
| [`plans/S1/S1.B/entity-formation-research/README.md`](../plans/S1/S1.B/entity-formation-research/README.md) | Entity pipeline |
| [`strategy/huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-01-legal-entity/SESSION_NOTES.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-01-legal-entity/SESSION_NOTES.md) | Entity session decisions |
| [`strategy/huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-05-tooling-agents/SESSION_NOTES.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-05-tooling-agents/SESSION_NOTES.md) | Tooling session decisions |
| [`strategy/huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md) | Velocity / timeline projection |
| [`governance/security_protocols.md`](../governance/security_protocols.md) | Security target state |

**VPS verification (read-only, 2026-06-26):** `ssh dev@159.198.75.194` — confirmed web `3e2b370`, api `1833e74`, green containers Up/healthy.

---

*Next refresh trigger: after VPS promote to `main` pins, entity counsel engagement, or quarterly self-review (2026-06-30).*
