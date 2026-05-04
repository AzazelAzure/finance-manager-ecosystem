# Decisions — 2026-05-04 Emergency Orchestration Huddle

Append-only. Do not edit locked items.

## Locked Decisions

### D1: Verification Tiers in Task Slices (2026-05-04)

Every slice checklist item must declare a verification tier. Agents cannot mark PASS without meeting the tier requirement.

| Tier | Name | What counts | When to use |
|------|------|-------------|-------------|
| `V0` | Code audit | Agent reads source, confirms logic. | Pure docs, governance, plan authoring |
| `V1` | Local build | `npm run build` / `pytest` passes locally. | API logic, type-safety, unit tests |
| `V2` | Staging deploy | Deployed to inactive color; script smoke passes. | Any user-visible behavior change |
| `V3` | Browser verify | Agent/HitM confirms in browser with screenshot evidence. | Interactive UI, tours, offline, forms |

**Governance change:** `plan_template.md` §1a updated.

### D2: Sprint Automation Script (Phased) (2026-05-04)

- Phase 2a: Deployment script audit (folded into huddle action items)
- Phase 2b: `scripts/sprint_verify.sh` skeleton on fixed foundation
- Phase 2c: Full automation (branch creation, PR opening, Slack gates) — later

### D3: Agent Identity Separation (2026-05-04)

HitM-approved. Three identities: HitM (existing), `cursor-agent`, `antigravity-agent`.
Two new Slack accounts. GitHub identity deferred (commit `--author` flag sufficient).
HitM-owned action item.

### D4: Huddles as First-Class Artifacts (2026-05-04)

Location: `strategy/huddles/<date>-<topic>/`
Cadence: Stage transitions (scheduled), emergency (HitM-triggered), sprint retro (brief).
Template: README.md, TALKING_POINTS.md, DECISIONS.md, ACTIONS.md.

### D5: Task Generation Protocol — Separation of Concerns (2026-05-04)

One agent must not create tasks AND execute AND self-verify.
Four roles: Orchestrator (strong model), Executor (efficient model), Reviewer (strong model), HitM Gate.
Full four-role pipeline targets S1.B (not S1.C).
Pragmatic phasing: two-role → three-role → four-role as Slack runners validated.

### D6: Slice-Based Branching — Deferred (2026-05-04)

Deferred until V-tiers and `sprint_verify.sh` are proven. V0/V1 slices stay on feature branch; V2+ branching evaluated later.

### D7: Task Migration (2026-05-04)

Retrofit ALL F-001–F-013 plan slice files to new V-tier format. Each feature = its own sprint.

### D8: Slack Channel Architecture (2026-05-04)

Three new channels: `#sprint-queue`, `#review-queue`, `#hitm-gate`. HitM creates and invites bots.
FIFO processing order. Retry tasks tagged with `RETRY_OF: <original_ts>`.

### D9: Huddle Location (2026-05-04)

`strategy/huddles/` is the permanent home. Decisions propagate to `governance/` at exit, but huddle artifacts stay in `strategy/`.

### D10: Antigravity Slack Runner (2026-05-04)

Basic `antigravity chat` bridge is an exit condition for this huddle. Skeleton exists at `antigravity_cli.readme`.
