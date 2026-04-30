# T06 — Heatmap + Calendar Daily-Active Joint Fix (Issues #4 + #7)

## Objective

Fix Issues #4 (heatmap days don't light up by spending intensity) and #7 (calendar daily active does not populate correctly) jointly. Both touch calendar/heatmap rendering and likely share root cause (date-binding, timezone, or aggregation-payload mismatch).

## Scope Boundary

- Repo: `finance_manager_web/` (primary) + `finance_manager_api/` (possible aggregate endpoint fix)
- Branch: `cursor/s1b/drift-cleanup/t06-heatmap-calendar-joint-fix`
- Investigated jointly per huddle Topic 1 / Topic 9 recommendation.

## Current Evidence

- Issue #4 (heatmap intensity): days don't visually encode spending magnitude.
- Issue #7 (calendar daily active): daily activity indicators don't populate.
- BP7 polish list per `plans/feat/web-reflex-parity-sweep-1/runtime_handoff.md` flagged calendar heatmap intensity as a follow-up.
- HitM hypothesis: shared root cause likely.

## Investigation Steps (do BEFORE implementation)

**The investigation is half the work.** Do not write code until root cause is identified.

### 1. Reproduce both issues

- Login; navigate to calendar view.
- Verify: do daily indicators populate? At all? With wrong values? In wrong cells?
- Verify: does heatmap intensity coloring fire? At all? With wrong colors?

### 2. Inspect API payload

- DevTools network tab: what does the calendar endpoint return?
- Specifically: are dates ISO 8601 with TZ? Are aggregations correct?

### 3. Inspect web rendering

- Are the calendar dates correctly mapped to grid cells?
- Is timezone handled correctly (UTC vs PH local)?
- Is the heatmap intensity calc using the right per-day total?

### 4. Identify shared root

Common candidates:

- **Timezone bug:** API serializes UTC, web treats as local; transactions appear on wrong day.
- **Date-binding bug:** API returns `{ date: ..., total: ... }` keyed differently than web expects.
- **Aggregation bug:** API returns transactions but not the per-day totals; web has no per-day data to color by.
- **Range bug:** API returns wrong date range; days outside the calendar view are populated, days inside are empty.

### 5. Document findings before fixing

Add findings to PR description so the joint nature is verifiable post-fix.

## Implementation (after investigation)

Depends on root cause. Two scenarios:

### Scenario A: Single root cause

One fix resolves both. Ship one PR.

### Scenario B: Two distinct issues

Fix #7 first (likely more user-impacting — calendar indicators); fix #4 second (heatmap intensity) as a follow-up sub-task. May require splitting this task into T06.1 and T06.2.

## Acceptance Criteria

- Calendar daily indicators populate correctly for all transaction types and all dates within the visible range.
- Heatmap days with spending light up with intensity proportional to spending magnitude (≥1 visible color step per ~₱1,000 spend, or similar — finalize during implementation).
- Days with no spending render empty (no false positives).
- Timezone handling explicit and tested (PH local, not UTC).
- New regression tests cover the joint behavior.

## Verification Commands

```bash
# API aggregation smoke
ssh dev@159.198.75.194 'curl -kfsS https://api.thehivemanager.com/api/transactions/aggregations/calendar/?month=2026-04 \
  -H "Authorization: Bearer $TOKEN"'

# Web build + manual smoke
# 1. Login at https://thehivemanager.com/
# 2. Navigate to /transactions/calendar
# 3. Verify: heatmap shows intensity; days with transactions have indicators
```

## Risks / Rollback

| Risk | Trigger | Rollback |
|---|---|---|
| Joint fix turns out to fix one issue but break the other | Smoke shows one improved, one regressed | Color flip rollback; re-investigate as two separate issues |
| Timezone fix breaks other date handling elsewhere | Other parts of UI show wrong dates | Color flip rollback; isolate the fix to calendar path only |
| API aggregation change breaks calendar list view | List view (different surface) regresses | Color flip rollback; investigate scope creep |

## Slack Gates

- `pre_execution`: required.
- `pre_deploy`: required.
- `pre_cutover`: required.
- `pre_close`: optional but recommended (visual regression possible; HitM smoke recommended).

## Estimated Effort

3–6 hours (investigation + fix + verification). Could be 1–2 hours if shared root cause is obvious; longer if Scenario B and they diverge.
