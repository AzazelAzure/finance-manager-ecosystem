# T01 — Email Templates

## Context

Django supports plain-text and HTML email templates. This task creates the minimal set needed for support confirmation emails. Plain text first; HTML enhancement is a follow-up.

## End State

Four template files (subject + body for bug report and feature request):
- `finance/templates/email/bug_report_received_subject.txt`
- `finance/templates/email/bug_report_received_body.txt`
- `finance/templates/email/feature_request_received_subject.txt`
- `finance/templates/email/feature_request_received_body.txt`

## T01.SL1 — Bug Report Template

**`bug_report_received_subject.txt`:**
```
We received your bug report — The Hive
```

**`bug_report_received_body.txt`:**
```
Hi {{ username }},

We received your bug report about "{{ nature }}". Thank you for taking the time to let us know.

Our team will review it and follow up if we need more information. We appreciate your help making The Hive better.

— The Hive Team
support@thehivemanager.com
```

Template variables: `{{ username }}`, `{{ nature }}`

## T01.SL2 — Feature Request Template

**`feature_request_received_subject.txt`:**
```
We received your feature request — The Hive
```

**`feature_request_received_body.txt`:**
```
Hi {{ username }},

We received your feature request: "{{ nature }}". Thank you — user feedback is how we decide what to build next.

We review all requests and prioritize based on impact. We can't respond to every request individually, but we do read them all.

— The Hive Team
support@thehivemanager.com
```

Template variables: `{{ username }}`, `{{ nature }}`

## Acceptance Criteria

- [V0] All four template files exist under `finance/templates/email/`
- [V0] Subject files contain no newlines (Django send_mail expects single-line subjects)
- [V0] Body files reference only `{{ username }}` and `{{ nature }}` — no other context variables that might be missing at render time
- [V0] Templates are in plain text (UTF-8); no HTML tags

## Evidence

- No evidence artifact needed for V0 — code review is sufficient
