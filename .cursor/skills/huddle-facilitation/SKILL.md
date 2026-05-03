Facilitate a structured strategic-planning huddle with the HitM. Use when HitM calls for a "huddle" or any multi-topic conversation that requires sequenced decisions, vocabulary grounding, and persistent decision tracking. Defaults to PH-first PFM project context but adaptable to any solo HitM + AI agent strategic planning context.

# Huddle Facilitation

## When to use this skill

- HitM explicitly says "let's huddle" / "huddle session" / "I want to do a structured planning conversation."
- Multi-topic strategic conversation that needs more than 2–3 exchanges.
- Decisions that will produce durable artifacts (Strategic Plan updates, governance changes, plan packets).
- Topics requiring vocabulary grounding before substance can be discussed.

## When NOT to use this skill

- Single-task conversations (use feature-implementation-loop, bugfix-investigation-loop, etc.).
- Code review or runtime triage (use respective skills).
- Quick clarifying-question exchanges.

## Operating principles

1. **Glossary first.** Before substance, ground vocabulary. Misunderstandings disguised as disagreements are the #1 derailer of strategic conversations. If terms are ambiguous, propose a glossary; lock with HitM signoff before proceeding.

2. **Topic list before deep-dive.** Build a structured agenda of topics with status (`pending` / `discussing` / `decided` / `deferred`). Walk topics in dependency order; let HitM re-order if their intuition differs.

3. **One topic at a time, locked before moving on.** Don't carry pending decisions across topic boundaries. If a topic's decision depends on later topics, defer it explicitly with a marker.

4. **Pushback is the value.** HitM has explicitly invited pushback throughout. Be candid. If HitM proposes something risky, name the risk concretely (with industry comparables when relevant) before accepting. Don't be sycophantic.

5. **Capture decisions in append-only log.** Every locked decision goes into `DECISIONS.md` (or equivalent persistent log) with: decision, rationale, affects, migration path, HitM signoff. Never modify prior entries; new decisions append.

6. **Parking lot for deferred items.** Substantial-but-not-now items go to `PARKING_LOT.md` with explicit revisit triggers. Prevents losing strategic context without polluting active plans.

7. **Quick-reference single-page docs help ADHD/scrolling.** When HitM is bouncing between topics or needs to refer back to questions in a long thread, generate a single-page reference (`TOPIC_N_QUESTIONS.md` style) with all open questions on one scrollable page.

8. **Close-out produces real artifacts.** Final topic of a huddle is "Lock and consolidate" — convert the huddle outputs into Strategic Plan updates, governance changes, plan packets, design doc syncs. The huddle isn't over until the artifacts exist on disk.

9. **Archive volatile huddle directory at close.** If the huddle used `plans/archived/volatile/<huddle-name>/`, move it to `plans/archived/<huddle-name>/` after Topic 11 close-out (same pattern as post-beta huddle 2026-04-30). Do **not** recreate removed top-level `plans/volatile/`; new governed work belongs under `plans/<Phase>/<Stage>/<sub-plan>/` per `governance/README.md` and `governance/branching_guidelines.md`.

## Standard huddle structure

```
plans/archived/volatile/<huddle-name>/         ← optional short-lived mirror during huddle (or use cursor/<stage>/ per governance)
├── README.md                                     ← agenda + exit criteria + scope guardrails
├── TALKING_POINTS.md                             ← per-topic status + discussion notes
├── DECISIONS.md                                  ← append-only locked decisions log
├── KNOWN_ISSUES.md                               ← bug/issue list if applicable
├── GLOSSARY.md                                   ← canonical vocabulary (migrates to governance/ at close)
├── PARKING_LOT.md                                ← deferred items with revisit triggers
└── TOPIC_N_QUESTIONS.md                          ← optional per-topic single-page reference for heavy topics
```

## Standard topic order (anchored on PH-first PFM project; adapt as needed)

Topics typically flow:

1. Current state / known issues sweep — including any critical blockers.
2. Architectural archival decisions (e.g. Reflex archived).
3. Recent pivots retro-formalization (e.g. JS pivot completion).
4. Phase definition overhaul — most load-bearing topic; establish vocabulary first.
5. Public launch milestone — usually merges into Topic 4.
6. Distribution readiness gap.
7. Wedge / brand audit + polish queue.
8. Velocity + cost management mechanisms (forcing functions for the HitM).
9. Drift cleanup queue ordering.
10. Family / personal cadence.
11. Lock, consolidate, seed next sprint — the close-out producing artifacts.

Adapt freely; the order above is one validated sequence, not prescriptive.

## Glossary categories to lock for PH-first PFM context

(Reuse for similar single-HitM + AI agents projects; adapt per project specifics.)

1. Phase / Stage / Sprint hierarchy (3-level addressing).
2. Per-product launch-state machine (Concept → Scaffold → Alpha → Tight Beta → Founding Beta → Soft Public Open → Public Launch → Full Public → Sunset → Archived).
3. Plan-type taxonomy (Strategic Plan / Execution Plan / Feature Roadmap / Implementation Guide / Branching Guideline).
4. Severity (S0–S3) vs Priority (P0–P2).
5. User vocabulary (HitM, end user, tester, founder, etc.).
6. Sprint vocabulary (Production / Maintenance / Research; Decompression).
7. Cycle vocabulary (CPPR / CPPR+D / CPPRD).

## Decision-locking format

```markdown
## YYYY-MM-DD — Topic <N>: <short title>

**Decision:** <one or two sentences>
**Rationale:** <why this, not alternatives>
**Affects:** <files / docs / plans that need updating>
**Migration:** <what must change as a consequence>
**HitM signoff:** <yes | yes-with-modifications | deferred>
```

Once logged, the decision is locked. Re-opening requires an explicit revisit.

## Slack gate awareness

Strategic decisions usually do NOT use Slack gates (they happen on desktop with full context). Tactical execution post-huddle uses Slack gates per `governance/execution_protocols.md`.

## Common HitM patterns to recognize

- **HitM reaches a conclusion ahead of agent.** Acknowledge convergence; don't re-derive. Capture and move on.
- **HitM rants in chat then says "you can delete that."** Don't delete — these are valuable thinking-out-loud signals. Capture in topic discussion notes.
- **HitM wants to defer mid-topic.** Honor it. Mark item as deferred to specific later topic; don't lose the thread.
- **HitM hits an ADHD parking-lot itch.** Suggest dropping the tangent into TALKING_POINTS topic notes or PARKING_LOT for later. Don't lose the current topic's flow.
- **HitM acknowledges learning ("I'm still figuring this out").** Don't be saccharine. Match their honesty with peer-level engagement; affirm the rep, not the comfort.

## Estimated effort

A full huddle covering 10–11 topics takes 3–6 hours of conversation + 2–4 hours of close-out artifact production. Typically split across 1–3 sessions. Plan accordingly with HitM's velocity ceiling (10hr/day, 55hr/week per `00_strategic_context.md` §7).

## References

- Glossary canonical: `governance/glossary.md`.
- Decision-locking template: `governance/plan_template.md` and worked examples in any volatile huddle's `DECISIONS.md`.
- Branching workflow: `governance/branching_guidelines.md`.
- Strategic Plan canonical: `strategy/strategic-roadmap-reframe-53be/`.

## Last validated

This skill was authored 2026-04-30 from the post-beta huddle (`plans/archived/post_beta_huddle_2026-04-30/`) which validated the pattern across 11 topics from vocabulary grounding through Strategic Plan revision through hierarchical plan creation.
