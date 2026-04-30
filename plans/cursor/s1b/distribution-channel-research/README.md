---
plan_id: PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30
status: draft
priority: P1
created: 2026-04-30
updated: 2026-04-30
owner: pproctor

plan_root: plans/cursor/s1b/distribution-channel-research/
intended_branch: cursor/s1b/distribution-channel-research
parent_plan: plans/cursor/s1b/
target_repos: []

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
  - PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
  - PLAN_RESEARCH_AI_ECONOMICS_2026-04-30
conflicts_with: []

slack_gates:
  pre_execution: optional
  pre_merge: none
  pre_close: required

deployment:
  required: false

standalone: true
standalone_notes: ""
---

# S1.B Sub-Plan — Distribution Channel Research

## 0) Strategic Inheritance

- **Wedge respected:** yes — channel research targets thin-margin PH households via channels they actually use.
- **Locked decisions touched:**
  - `00_strategic_context.md` §3.8 (PH-first market focus)
  - `00_strategic_context.md` §9 (Distribution Theory)
  - `PARKING_LOT.md` P-7 (AI video story content format)
  - HitM huddle answer Q6.1: AI knowledge of PH markets has Western bias; Facebook is the primary PH digital vector; AI video stories are a candidate format.
- **Cost cap impact:** no infra cost; HitM time investment.
- **Validation gates affected:** S1.B exit requires distribution channel research complete; founder content cadence defined.

## 1) Objective

Research and lock PH-local distribution channels + founder content cadence. Specifically: which Facebook groups, subreddits, OFW communities, micro-influencer audiences are real-PH-engagement-rich and persona-appropriate. Define cadence: how often, what shape, where.

This is **HitM-led research** with strong cultural-context judgment required. Agent role is to compile candidates + structured pros/cons; HitM picks.

## 2) Scope

### In scope

- PH-relevant Facebook groups (size, engagement, moderation rules).
- PH-relevant subreddits (r/phinvest, r/Philippines, r/buhaymayaman, etc.).
- OFW community spaces (where do PH expats hang out online?).
- PH micro-influencer landscape: TikTok, YouTube, FB Reels personal-finance creators.
- AI video story format viability test (per PARKING_LOT P-7).
- Founder content cadence design (monthly AI video + weekly educational + ad-hoc personal narrative as default; revise per outcome).

### Out of scope

- Paid ads (formally rejected per `PARKING_LOT.md` P-3).
- Specific creator outreach (that's S2 W3 work; this plan just identifies candidate creators).

## 3) Source Evidence

- HitM personal knowledge of PH digital habits.
- Family/friend PH WOM seed (3 PH testers; useful for "what would they actually click on?").
- AI Western-bias caveat: validate any AI-supplied PH channel claims with HitM before locking.

## 4) Deliverables

Research document with:

- Channel inventory: 10–20 candidate channels with engagement assessment.
- Top 3–5 channels selected for S1.C posting cadence.
- AI video story format decision: framing 1 (product-integrated) vs framing 2 (founder/trust) vs framing 3 (skip AI video). HitM signoff.
- Cadence locked: how often, what shape, where, who.
- First-post drafts for top 1–2 channels (HitM voice; ready for S1.C).

## 5) Verification Gates

- HitM has read and signed off on channel selection.
- AI video story framing decision locked.
- Cadence locked in `00_strategic_context.md` §9 if revised from default.

## 6) Documentation Sync Required

- `00_strategic_context.md` §9 updated with locked cadence + top channel list.
- `PARKING_LOT.md` P-7 updated with AI video framing decision (Promoted / Lifted / Discarded per protocol).

## 7) Strategic Phase Impact

- S1.B exit: distribution channel research complete ✅
- S1.C entry: channel + cadence ready; first PH-local post can launch on Founding Beta opening.

## 8) Risks

| Risk | Trigger | Mitigation |
|---|---|---|
| AI-suggested channels are inauthentic / spam-saturated | HitM PH context check fails on candidates | Ignore AI suggestions; use only HitM-validated channels |
| Top channel has hostile moderation / "no promotion" rules | First-post attempt gets removed | Have backup channels; engage organically before promoting |
| AI video format doesn't resonate with persona | First test post gets low engagement | Pivot to text/educational content; AI video deferred |

## Estimated Effort

HitM: 4–8 hours.
Agent: 2–4 hours compiling candidate inventory + first-post drafts.
