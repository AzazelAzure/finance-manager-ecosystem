# Strategy — index of living state

`strategy/` holds **living strategic state**: where we're going and how we're tracking it.
(Boundary vs other roots: `plans/` = what we'll build · `governance/` = how we operate ·
`design_docs/` = how the built system works. Canonical boundary: `AGENTS.md` §3 + the
Documentation Sync Protocol in `design_docs/10_Current_State/`.)

## Canonical roadmap (read first)

Multi-year phase map, locked decisions, validation gates, and kill gates live in
**`strategic-roadmap-reframe-53be/`** (plan ID `PLAN_STRATEGIC_ROADMAP_REFRAME_2026-04-28`).
Start at [`strategic-roadmap-reframe-53be/README.md`](strategic-roadmap-reframe-53be/README.md).
Tactical execution plans sit under `plans/<Phase>/<Stage>/<sub-plan>/`; authoring/registry in `governance/`.

## Homes (what lives where in `strategy/`)

| Dir / file | Purpose |
|---|---|
| `strategic-roadmap-reframe-53be/` | Canonical multi-year roadmap, gates, locked decisions |
| `meetings/` | Admin meeting notes (daily sync + seated sessions) |
| `daily_summaries/` | Automated daily summary output (Antigravity sweep) |
| `legal/` | Legal/compliance analysis and scope docs |
| `anomalies/` | **Detected** in-the-moment issues from agents mid-work; swept nightly |
| `risk_register.md` | **Anticipated** risks not yet occurred |
| `parking_lot/` | Postponed items (one file per item; not yet plans) |
| `projections/` | Forward projections + quarterly reviews (interconnected cluster) |
| `audits/` | Operational/process audits + improvement tracker |
| `security/` | Local security audit suite reports |
| `automations/` | Automation context, prompts, reports, specs |
| `research/` | Research briefs and discovery packets |
| `huddles/` | Admin huddle artifacts |
| `archived/`, `standby/` | Retired / on-hold artifacts |
| `current_status.md` | Admin daily snapshot (Antigravity-maintained; not in executor bootstrap) |

Meeting-artifact lifecycle (what gets saved / updated / archived): `governance/meeting_artifact_protocol.md`.

**Pending archival** (loose one-off files at `strategy/` top level — sweep to `archived/` per the
protocol once their moment passes): `priority_matrix_2026-06-28.md`, `cursor_vs_claude_max_cba.md`,
`active_vs_research_comparison.md`, `admin_overhaul_proposal_2026-06-26.md`, `UI_UX_research_brief.md`,
`Screenshot_*.png`, and resolved seed proposals (`doc_structure_consolidation_proposal_2026-06-29.md`
once the design-docs restructure closes).
