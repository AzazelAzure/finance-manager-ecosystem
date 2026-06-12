# Talking Points - Admin Meeting Huddle Prep (Planned)

Per-topic record for the planned admin meeting. Initial state is pre-commencement; all topics begin as `pending`.

---

## TP1: Known issues

**Status:** `pending`  
**Notes seed:**

- Known issues list is not complete and will be a continuous working point.

---

## TP2: Balance inquiry of potential SMM hiring

**Status:** `pending`  
**Notes seed:**

- Jun/Jul hire dates.
- Gated by birth costs.

---

## TP3: Feature rollout scheduling

**Status:** `decided`  
**Session:** TP16 + Cluster C combined  
**Deep-dive:** `sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md`  
**Outcome:** Conservative timeline (mid 2027) adopted. Priority: PWA fix → F-007 → F-011 (expanded) → wedge features. New DoD doctrine locked.

---

## TP4: Infrastructure hardening

**Status:** `pending`

---

## TP5: Automation hardening

**Status:** `decided`  
**Session:** Session 5 (Tooling & Agents)  
**Deep-dive:** `sessions/session-05-tooling-agents/SESSION5_AUTOMATION_AND_TOOLING.md`  
**Outcome:** Slack is monitoring+initiation only (not routing). Orchestrator script manages internal coder→reviewer→coder loop. PA is functional; backend scripts are the gap. P1+P2 (context delivery, task spec) this week. Orchestrator implementation end-of-week.

---

## TP6: Glossary updates for admin terms

**Status:** `pending`

---

## TP7: Workspace subagent commands alignment

**Status:** `decided`  
**Session:** Session 5 (Tooling & Agents)  
**Deep-dive:** `sessions/session-05-tooling-agents/SESSION5_AUTOMATION_AND_TOOLING.md`  
**Outcome:** Most commands already work. VPS deploy stays manual. Agents handle code→test→push→READY. Orchestrator handles agent-to-agent handoffs internally.  
**Notes seed:**

- Align commands with automation workflows.

---

## TP8: HitM scheduling/task automation workflow repairs

**Status:** `pending`

---

## TP9: Efficiency improvement avenues

**Status:** `decided`  
**Session:** TP16 + Cluster C combined  
**Deep-dive:** `sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md`  
**Outcome:** Biggest efficiency bet is automation pipeline hardening (→ Session 5). Process simplifications parked for post-Session 5.

---

## TP10: Business scalability in PH markets

**Status:** `pending`

---

## TP11: Business expansion gates

**Status:** `discussing`  
**Session:** 1 (Legal & Entity)  
**Deep-dive:** `[sessions/session-01-legal-entity/TP11_EXPANSION_GATES.md](./sessions/session-01-legal-entity/TP11_EXPANSION_GATES.md)`  
**Notes seed:**

- New hire gates.
- Training vs out-of-school hires.
- Legality research.
- Lawyer retainer gates.

---

## TP12: Ecosystem potential restructure

**Status:** `pending`

---

## TP13: Continual improvement meetings

**Status:** `pending`

---

## TP14: Potential Claude inclusion into workflows

**Status:** `decided`  
**Session:** Session 5 (Tooling & Agents)  
**Deep-dive:** `sessions/session-05-tooling-agents/SESSION5_AUTOMATION_AND_TOOLING.md`  
**Outcome:** $200/mo Cursor upgrade deferred to June billing cycle (no funds now). Dev deadzone likely until May 28 reset. Reviewer should use higher model; near-term via $200 plan, future via Claude API. MCP browser tools needed for CLI visual verification (not blocking).  
**Notes seed:**

- Pros/cons.
- Overhead changes.
- Economics changes for success metrics.
- Cost model options:
  - Cursor increase to 200/mo.
  - Cursor 60/mo + Claude 100/mo max.
- Automation tie-ins:
  - Code execution vs code review role split.
  - DOM/browser verification routes for automation tests passed back to code executors.
  - Tie back into automation fix discussions.

---

## TP15: Slack fixes

**Status:** `pending`  
**Notes seed:**

- May tie back to other talking points.

---

## TP16: Human relief points

**Status:** `decided`  
**Session:** TP16 + Cluster C combined session  
**Deep-dive:** `sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md`  
**Outcome:** 5–12 hrs/day babysitting AI is THE emergency. Automation pipeline hardening is #1 priority (→ Session 5). SMM onboarding requirements locked. Concurrent features possible when automation governance solidifies.

---

## TP17: Current Antigravity integration

**Status:** `decided`  
**Session:** Session 5 (Tooling & Agents)  
**Deep-dive:** `sessions/session-05-tooling-agents/SESSION5_AUTOMATION_AND_TOOLING.md`  
**Outcome:** Antigravity stays for planning/strategy/synthesis (like this huddle). Deprecated for code execution. Cost absorbed by HitM. Formal scope gates parked for post-huddle.  
**Notes seed:**

- Antigravity has context window superiority; coding quality is weak.
- Costs are absorbed by HitM, not the businesses; define where/when usage is allowed via gates.
- Mitigate issues between agentic organizations across business scopes.

---

## TP18: Entity creation timelines

**Status:** `decided` (cascading from TP11 deferrals)  
**Session:** 1 (Legal & Entity)  
**Deep-dive:** `[sessions/session-01-legal-entity/TP18_ENTITY_TIMELINES.md](./sessions/session-01-legal-entity/TP18_ENTITY_TIMELINES.md)`  
**Outcome:** All entity timelines deferred post-baby. Realistic first revenue ~Q1 2027. Product work proceeds in parallel.

---

## TP19: Potential agentic skills/rules split by domain

**Status:** `decided`  
**Session:** Session 5 (Tooling & Agents)  
**Deep-dive:** `sessions/session-05-tooling-agents/SESSION5_AUTOMATION_AND_TOOLING.md`  
**Outcome:** Engineering vs planning domain split is incremental work, starts after P1+P2 artifacts exist. SMM assistant scope deferred. AI content generation limits noted but not blocking.  
**Notes seed:**

- Separate skill/rule scopes for admin vs engineering vs social media.
- Requires ecosystem restructuring (TP12) for subfile scope separation.
- Requires Antigravity/Gemini integrations (TP17) for social media rollouts.
  - HitM to define usage limits on AI videos and other content generation.

---

## TP20: Avenues for increasing success changes

**Status:** `decided`  
**Session:** TP16 + Cluster C combined  
**Deep-dive:** `sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md`  
**Outcome:** Nail wedge features + Facebook-first distribution. Don't spread thin.

---

## TP21: Beta expansion protocols

**Status:** `decided`  
**Session:** TP16 + Cluster C combined  
**Deep-dive:** `sessions/session-tp16-cluster-c/TP16_AND_CLUSTER_C.md`  
**Outcome:** Beta expansion = S1.B→S1.C gate. No intermediate expansion step. Pre-expansion actions (feedback form, tester check-ins) can start now.

---

## TP22: Governance export as installable Cursor doctrine

**Status:** `decided`  
**Session:** Session 5 (Tooling & Agents)  
**Deep-dive:** `sessions/session-05-tooling-agents/SESSION5_AUTOMATION_AND_TOOLING.md`  
**Outcome:** Deferred — no employees until S1.C+. Document the need, revisit when hiring is imminent. Bigger investment is the TP19 domain split which serves HitM's own needs now.  
**Notes seed:**

- Expansion subnote: define how governance can be exported into installable assets for employee Cursor instances.
- Target doctrine surfaces:
  - skills
  - MCP configurations/integration scaffolds
  - rules
  - related reusable agent scaffolding
- Define packaging/distribution model for employee onboarding and environment consistency.
- Evaluate where governance docs can be condensed into doctrine artifacts without losing critical operational intent.
- Define what must remain as canonical docs vs what can be doctrine-layer abstractions.

---

## TP23: Slack vs Discord for business interfaces

**Status:** `pending`  
**Notes seed:**

- Compare Slack vs Discord capabilities for business-facing operations and expansion readiness.
- Research requirement: full Slack capability mapping vs Discord baseline (including bot/automation depth).
- Working context: stronger direct historical experience with Discord bots; validate whether that still aligns with business expansion needs.
- Investigate regional/business-structure fit risks to avoid expansion blockers or region-specific operational issues.
- Define implications for future bug reports and feature-request intake channels.
- Evaluate whether Slack MCP integrations from VPS posting back into Slack should be the default direction.
- Run explicit CBA (cost/benefit analysis) across:
  - platform costs
  - technical debt
  - time costs for restructuring automation pipelines
  - migration/switching overhead and lock-in risk

---

## TP24: Reasonable hirable positions and PH wage ranges

**Status:** `pending`  
**Notes seed:**

- Define realistic near-term hires by function (engineering, admin ops, SMM, hybrid roles).
- Establish PH-market wage bands by role seniority and scope.
- Separate full-time, part-time, and contract structures for affordability planning.
- Map wage bands to expected output and onboarding/training burden.
- Tie hiring feasibility to current budget gates and expansion triggers.

---

## TP25: Entity registration fallback options if spouse backs out

**Status:** `pending`  
**Notes seed:**

- Define fallback legal/entity paths if spouse-led registration does not proceed.
- Map immediate operational continuity plan (billing, contracts, compliance ownership).
- Identify time, cost, and legal-risk deltas between fallback options.
- Define trigger point for switching to fallback path vs waiting.
- Clarify what decisions can be pre-drafted now to reduce disruption risk.

---

## TP26: Security hardening protocols (proactive and defensive coding)

**Status:** `pending`  
**Notes seed:**

- Define security coding baseline to reduce exploit surface before incidents occur.
- Decide proactive controls vs reactive controls for current stage affordability.
- Establish defensive coding protocols for auth, input handling, permissions, and sensitive data paths.
- Define security review requirements for high-risk changes (PII/auth/money-math flows).
- Align hardening priorities against likely attacker paths and breach-impact severity.
- Map implementation cost/time vs risk-reduction value to avoid security theater.

---

## TP27: HitM birth support notes and June schedule investigation

**Status:** `pending`  
**Notes seed:**

- Investigate spouse sister schedule for June against expected birthing window.
- Identify required assistance coverage before, during, and immediately after birth window.
- Map likely support gaps that could affect HitM execution capacity.
- Define contingency options if preferred assistance schedule is unavailable.

---

## TP28: Potential business management software creation (interlinked with production flows)

**Status:** `pending`  
**Notes seed:**

- Evaluate whether to build internal business-management software that connects directly to current production workflows.
- Define which operational domains should be included first (admin, finance ops, hiring, project orchestration, reporting).
- Identify integration points with existing automation, governance artifacts, and runtime workflows.
- Compare build-vs-buy feasibility, including maintenance burden and technical-debt risk.
- Determine minimum viable scope that provides measurable coordination gains without derailing core product delivery.