# T05 — Recurring Expense Edit `is_recurring=true` Fix (Issue #1)

## Objective

Fix Issue #1 from huddle Topic 1: editing an existing upcoming expense whose `is_recurring=true` flag fails. Either form binding is wrong or save handler rejects the payload. Severity S1 — every user with a recurring bill hits this on first edit.

## Scope Boundary

- Repos: `finance_manager_api/` (likely serializer fix) + `finance_manager_web/` (likely form-binding fix)
- Branch: `cursor/s1b/drift-cleanup/t05-recurring-expense-edit-fix`
- Multi-repo coordination per `_governance/branching_guidelines.md` §8.2.

## Current Evidence

Per `KNOWN_ISSUES.md`:

- `finance_manager_web/CHANGELOG.md` shows recent fix for `is_recurring` field mapping in the **list** view. The **edit** path likely has parallel mismatch (API serializes `is_recurring`, web edit path may use `recurring_flag` or similar).
- Surface: web edit modal + API upcoming expenses serializer.

## Investigation Steps (do first)

1. Reproduce: open an existing upcoming expense with `is_recurring=true`, attempt to edit (e.g. change amount).
2. Check browser DevTools network tab for the PUT/PATCH request — what payload does web send? Is `is_recurring` included? As what key?
3. Check API response — 400? 500? 200 with silently-stripped field?
4. Identify whether this is web → API payload mapping issue or API serializer issue.

## Likely Fixes (depends on investigation)

### If web payload mismatch

- Web edit form sends `recurring_flag` instead of `is_recurring`, or sends nothing because field not bound to form.
- Fix: align web payload to API contract (`is_recurring`).

### If API serializer issue

- Serializer accepts `is_recurring` on POST but not on PUT/PATCH (e.g. read_only_fields misconfigured).
- Fix: ensure `is_recurring` is writable on both create and update.

### If both

- Fix both; ship together.

## Acceptance Criteria

- Editing an upcoming expense with `is_recurring=true` succeeds (PUT/PATCH 200; field preserved post-edit).
- Editing an upcoming expense with `is_recurring=false` still works (regression check).
- Edit to set `is_recurring` from `false → true` works.
- Edit to set `is_recurring` from `true → false` works.
- Existing tests still pass.
- New regression test added for each of the 4 paths above.

## Verification Commands

```bash
# API tests
cd finance_manager_api && uv run pytest finance/tests/ -v -k "upcoming"

# Web edit-flow smoke (manual)
# 1. Login at https://thehivemanager.com/
# 2. Navigate to /upcoming-expenses
# 3. Edit a recurring bill
# 4. Confirm successful save
```

## Risks / Rollback

| Risk | Trigger | Rollback |
|---|---|---|
| Fix breaks creation flow (which currently works) | Existing creation tests fail | Revert; investigate; sub-Sprint adds creation regression test before re-attempting |
| API contract change requires web update that's missed | Edit works but creates new bug elsewhere | Multi-repo coordination per `branching_guidelines.md` §8.2; ship API + web together |

## Slack Gates

- `pre_execution`: required.
- `pre_deploy`: required.
- `pre_cutover`: required.
- `pre_close`: optional.

## Estimated Effort

1–3 hours (depends on investigation; could be 30 minutes if it's a single field-name mismatch).
