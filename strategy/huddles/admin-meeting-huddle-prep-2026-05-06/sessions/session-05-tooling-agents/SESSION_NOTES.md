# Session Notes — Session 5: Tooling & Agents

**Date started:** 2026-05-06  
**Attendees:** HitM  
**Topics:** TP5 (Automation Hardening), TP14 (Claude Inclusion), TP17 (Antigravity Integration), TP7 (Workspace Commands), TP19 (Skills/Rules Split), TP22 (Governance Export)  
**Status:** `decided`

## Why this is the pivotal session

From Session 1 and the TP16+Cluster C session, **one finding dominates**: HitM spends **5–12 hrs/day babysitting AI operations**. This single stressor caused the emergency pre-huddle and this huddle. If this session doesn't produce a concrete plan to reduce that to <1 hr/day, the post-baby operating model collapses.

## Decisions from prior sessions that constrain this discussion


| Decision                                         | Source | Impact here                                                           |
| ------------------------------------------------ | ------ | --------------------------------------------------------------------- |
| Engineering hire deferred to S1.C+               | S1-D03 | Automation must replace the engineering babysitting, not a human hire |
| Automation as engineering replacement            | S1-D03 | This session must validate or invalidate that assumption              |
| Conservative timeline (mid 2027)                 | C-D01  | Longer runway gives time to fix automation properly                   |
| One-feature-at-a-time is context, not structural | C-D13  | Concurrent features unlock IF handoffs are reliable                   |
| Manual verification = visual spec check          | C-D14  | Smoke tests automated; the gap is the prompt→review→correct loop      |
| 5–12 hrs/day babysitting = THE emergency         | C-D11  | This session's #1 objective                                           |


---

## Decisions made this session


| Decision ID | Topic                               | Decision                                                                                                                                                                                                                                                                  | Rationale                                                                                                                                  | Migrates to                               |
| ----------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------- |
| T-D01       | Slack role in pipeline              | **Slack is for MONITORING and TASK INITIATION only.** Not for routing between coder and reviewer. Internal handoffs happen locally.                                                                                                                                       | Current design routed tasks through Slack channels, adding latency, fragility, and confusion. The goal was always monitoring, not routing. | Relay contract revision, pipeline scripts |
| T-D02       | Pipeline architecture               | **Option C (orchestrator script)** is the target model. PA picks up task → calls orchestrator → orchestrator manages coder→reviewer→coder loop internally → status pings to Slack outbox.                                                                                 | Matches HitM's description of intended flow. Centralized control, easy to add logging.                                                     | New orchestrator script, PA runner wiring |
| T-D03       | CursorPA status                     | **PA is functional.** The problem is the backend automation scripts, not PA itself. PA picks up messages, drops to inbox, calls agent-prompt. The scripts behind agent-prompt don't handle internal handoffs.                                                             | Misdiagnosis — prior analysis focused on PA stability when the gap was the missing orchestrator layer.                                     | Script refactoring priority               |
| T-D04       | P1+P2 this week                     | **DELIVERED 2026-05-21.** `governance/agent_context_delivery.md` (P1) and `governance/sprint_task_specification.md` (P2). Includes dual-track sprint model, biweekly QA sweeps, and worked example in `governance/examples/`. Governance README updated with Sequence G.   | Low effort, high impact. This is expected output of the huddle.                                                                            | Governance artifacts, skill files         |
| T-D05       | Cursor budget                       | Currently at **18% remaining** until May 28 reset. High model access exhausted. **Likely will move to $200/mo** eventually.                                                                                                                                               | Babysitting accelerates credit burn. Clean single-pass execution would use fewer credits.                                                  | Budget planning                           |
| T-D06       | Reviewer model tier                 | **Reviewer agent should use a higher model** (Claude or similar) for code review quality. Near-term: higher-model Cursor agent with $200/mo plan access. Future: Claude API as dedicated reviewer.                                                                        | Lower-model review produces low-quality catches; HitM ends up doing the review anyway.                                                     | Orchestrator config, P4                   |
| T-D07       | MCP browser for CLI                 | **CLI agents need MCP browser DOM tools** for visual verification. Not blocking now, but needed for V2 review tier to include visual checks.                                                                                                                              | CLI doesn't have inherent browser access; visual spec compliance needs DOM inspection.                                                     | Future MCP setup                          |
| T-D08       | Sprint pipeline bridge              | `sprint_slack_pipeline_bridge.py` is **deprecated for routing**. May retain as status aggregator.                                                                                                                                                                         | Routing belongs in the orchestrator, not in Slack channel polling.                                                                         | Script cleanup                            |
| T-D09       | Relay contract                      | `14_Inter_Agent_Message_Relay_and_Ownership_Contract.md` **must be revised** to reflect Slack-as-monitoring architecture. Channel roles change from routing to monitoring.                                                                                                | Current contract describes a design that doesn't match HitM's intent and adds unnecessary complexity.                                      | design_docs update                        |
| T-D10       | Orchestrator confirmed              | **Orchestrator approach confirmed.** Easier to watch, easier to log. Estimated a few days of creation + debugging. Must not break agent-daemon on local machine.                                                                                                          | Centralized logging and observability are key benefits.                                                                                    | End-of-huddle-week implementation         |
| T-D11       | New vs modify                       | **TBD** — whether to create a new orchestrator script or modify existing depends on effort analysis and impact on other running scripts. Decision deferred to implementation time.                                                                                        | Can't assess without looking at code interdependencies in detail.                                                                          | Implementation sprint                     |
| T-D12       | Slack channels                      | **Keep 3 channels** (`#sprint-queue`, `#review-queue`, `#hitm-gate`) as monitoring-only. Easier for HitM to organize notifications. Coding agents can use Slack MCP to notify, or orchestrator fires status pings — either approach acceptable.                           | Collapsing adds no benefit right now; 3 channels help organize what type of status update HitM is reading.                                 | No migration needed                       |
| T-D13       | Cursor upgrade timing               | **Deferred to next billing cycle** (after May 28). No funds available now. **Dev deadzone likely** until subscription renews.                                                                                                                                             | Hard budget constraint. Cannot upgrade mid-cycle.                                                                                          | Budget, velocity planning                 |
| T-D14       | Design docs + ecosystem restructure | **Relay contract and design docs must be updated.** Part of larger ecosystem concern: too many files in too many places need better organization and clear separation of concerns. Must not break GitHub links across subrepos. Connects to TP12 (ecosystem restructure). | File sprawl makes agent context loading and human navigation harder. GH link stability is a hard constraint for subrepo cross-references.  | TP12, post-huddle doc reorganization      |


## Parking lot


| Item                                            | Related TP | Reason deferred                                                                            | Target session/time           |
| ----------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------ | ----------------------------- |
| **Orchestrator script implementation**          | TP5        | Design locked; ~few days of work. Must not break agent-daemon.                             | **End of huddle week**        |
| New script vs modify existing — effort analysis | TP5        | Depends on code interdependency review                                                     | During implementation         |
| Cursor $200/mo upgrade                          | TP14       | No funds this cycle; dev deadzone until May 28 reset                                       | **June billing cycle**        |
| MCP browser DOM tools for CLI agents            | TP14       | Not blocking; needed for V2 visual review                                                  | Future (post-orchestrator)    |
| **Ecosystem file reorganization** (TP12)        | TP12, TP5  | Too many files in too many places. Must be done without breaking GH links across subrepos. | Post-huddle, dedicated effort |
| Relay contract revision                         | TP5        | Part of ecosystem restructure (T-D14)                                                      | With TP12 work                |
| TP17 Antigravity cross-business scope gates     | TP17       | Already clear (planning/strategy only); formal doc not urgent                              | Post-huddle                   |
| TP19 Engineering vs planning domain split       | TP19       | Incremental; can start after P1+P2 artifacts exist                                         | Post-huddle                   |
| TP22 Governance export for employees            | TP22       | No employees until S1.C+; document the need and move on                                    | S1.C timeframe                |


