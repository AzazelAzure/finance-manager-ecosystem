---
plan_id: PLAN_CROSS_EMAIL_COMMS_2026-06-27
status: draft
priority: P1
created: 2026-06-27
updated: 2026-06-27
owner: pproctor

plan_root: plans/S1/S1.B/feat-email-comms/
intended_branch: cur/s1b/feat/email-comms
target_repos:
  - finance_manager_api

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_CROSS_LEGAL_PAGES_2026-06-27
  - PLAN_CROSS_SIGNUP_CLICKWRAP_2026-06-27
  - PLAN_CROSS_UI_UX_TEST_SEED_2026-06-27
conflicts_with:
  - PLAN_CROSS_API_SECURITY_HARDENING_2026-06-26

manual_gates:
  pre_execution: optional
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api]
  bundle_required: false
  rollback_plan_id: null
  smoke_targets:
    - POST /api/support/bug-report/ (sends confirmation email + operator notification; no duplicate within 5min)
    - POST /api/support/feature-request/ (same behavior)
    - Proton inbox receives operator notification; user inbox receives confirmation
  notes: >-
    Requires working SMTP (Proton Bridge or configured email backend on VPS).
    No migration required. All changes are in Django views/tasks and email templates.
    Conflicts with API security hardening: both touch the support/signals area of the
    finance app. Sequence after security hardening sprint closes to avoid merge conflicts.

standalone: true
standalone_notes: ""

legal_impact:
  tos: false
  privacy_policy: true
  cookie_policy: false
  notes: >-
    Privacy Policy §4 (how we use data) mentions email for "communicating service changes
    or security notices." Confirmation emails fall within this scope. When this deploys,
    confirm §4 table is accurate (it already covers operator contact + security notices;
    user-initiated support confirmation is within "providing the service"). No policy
    text update required, but confirm with legal_workflow_coordination.md.
---

## 0) Strategic Inheritance

- Wedge respected: yes — user trust is a core wedge value; confirmation emails close the UX gap where users don't know if their submission was received
- Locked decisions touched: none
- Cost cap impact: minimal — Proton SMTP is already configured; these are low-volume transactional emails
- Validation gates affected: none directly; VPS smoke adds email send verification

## 1) Objective

Send a user-facing confirmation email when a bug report or feature request is successfully submitted. Emails go to the user's authenticated (server-stored) email address — NOT a user-provided input field. A 5-minute cooldown per user per submission type prevents accidental duplicate sends when the UI has lag. Operator still receives the existing notification email.

Also ensures `support@thehivemanager.com` and `privacy@thehivemanager.com` are correctly wired in the Django email backend (verified as a manual gate, not code change).

## 2) Scope

### In scope
- Add `send_user_support_confirmation` Celery task in `finance/api_tools/notify.py` (or a new `support_notify.py`)
- Email templates: `templates/email/bug_report_received_subject.txt`, `bug_report_received_body.txt`, `feature_request_received_subject.txt`, `feature_request_received_body.txt`
- Wire the task to fire after a `SupportTicket` is created successfully (in the view or signal that creates the ticket)
- 5-minute cooldown: before queuing, check `SupportTicket.objects.filter(uid=user_uuid, report_type=ticket_type, created_at__gte=now()-timedelta(minutes=5)).count() > 1`; if so, skip confirmation email for this submission (ticket is still saved; only the confirmation email is skipped)
- Cooldown applies ONLY to the confirmation email — operator notification still fires on every submission
- Confirmation email: plain text + HTML; uses user's `User.email` (server-stored, not user-editable in this flow); references ticket `report_type` and `nature` field; brief friendly message
- Manual gate check: confirm `support@` and `privacy@` are reachable and correctly aliased in Proton

### Out of scope
- Allowing users to provide a DIFFERENT contact email in the support form (this would require spam protection; deferred)
- Rich HTML email templates with branding/logos — plain-text first; styling is a follow-up
- Email reply threading (no reply-to user mechanism yet)
- Privacy@ contact form — the policy links to `privacy@thehivemanager.com` directly; no in-app form needed
- Spam protection beyond the cooldown (rate limiting, CAPTCHA) — out of scope for MVP

## 3) Source Evidence

- `finance_manager_api/finance/api_tools/notify.py` — existing Celery task for operator notifications
- `finance_manager_api/finance/migrations/0008_supportticket.py` — SupportTicket model (uid, report_type BUG/FEATURE, nature, comment, created_at, emailed boolean)
- `strategy/meetings/admin_meeting_2026-06-27.md` — decision: confirmation emails sent to user's server-stored email; 5-minute cooldown on confirmation (not on ticket creation)
- `strategy/legal/drafts/privacy_policy_v1.md §4` — confirms email for "communicating service changes or security notices" is in scope

## 4) Phase Plan — Task List

| Task | Title | Slices | V-tier |
|---|---|---|---|
| T01 | Email templates | T01.SL1 Bug report template; T01.SL2 Feature request template | V0 |
| T02 | Celery task + wiring | T02.SL1 Confirmation task; T02.SL2 Cooldown logic; T02.SL3 Wire to support view | V1, V2 |

## 5) Execution Order

T01 (templates) first — task in T02 references them. T02 slices are sequential.

1. `tasks/T01_email_templates.md`
2. `tasks/T02_task_and_wiring.md` — T02.SL1 → T02.SL2 → T02.SL3

## 6) Verification Gates

- [V0] Email template files exist and contain correct variable references (`{{ username }}`, `{{ ticket_type }}`, `{{ nature }}`)
- [V1] Celery task imports cleanly; no circular imports
- [V1] `pytest` passes for support view (existing tests) + new test: submit bug report → confirmation task queued; submit again within 5min → confirmation task NOT queued (ticket still created)
- [V2] VPS smoke: submit bug report on staging blue → operator receives notification email in Proton; user email (test account) receives confirmation
- [V2] VPS smoke: submit same type twice within 5min → only ONE confirmation email received; second ticket saved (operator still notified)

## 7) Documentation Sync Required

- `strategy/legal/legal_workflow_coordination.md`: note that confirmation emails are live (within Privacy §4 scope; no update needed to policy text itself)
- `governance/plan_registry.md`: move to Completed

## 8) Strategic Phase Impact

When closing:
- [ ] Confirm `support@` and `privacy@` aliases verified working (manual gate)
- [ ] Update `governance/plan_registry.md` status to `completed`
- [ ] Post completion summary to IDE Chat

## 9) Completion Criteria

- V0/V1/V2 gates met
- HitM manually confirms email received in Proton (pre_merge gate)
- PR merged
- §8 actions complete

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| SMTP not configured on VPS | Emails silently fail | Confirm `EMAIL_HOST`, `EMAIL_PORT`, `EMAIL_HOST_USER`, `EMAIL_HOST_PASSWORD` env vars are set before deploy | HitM |
| Cooldown check reads wrong uid | UUID mismatch; cooldown not applied | Use `User.appprofile.user_id` (UUID) consistently with rest of support flow | Cursor |
| Email queued but Celery worker not running | Email never sends | Existing Celery health check on VPS; confirm worker is running before smoke | HitM |
| Confirmation email reveals ticket content to wrong user | User's stored email is wrong (rare) | No mitigation beyond auth — authenticated user's email is authoritative | n/a |
