# Validation gates (orchestration checkpoints)

Use these before declaring each phase done.

| Gate | Check |
|------|--------|
| **A — Compile** | `uv run reflex export` or project-standard compile in `finance_manager_reflex` passes. |
| **B — i18n** | With `ProfileState.current_locale` set to `tl-PH`, affected strings are not English fallback for keys added in that phase. |
| **C — Nav smoke** | Click every protected sidebar item; active state + labels OK. |
| **D — Editor** | Open Add expense/income/transfer from dashboard; modal chrome localized. |
| **E — Calendar** | Load current month; month grid shows correct number of days; heat visible per day cell; drill-through still works if previously supported. |

Post-merge: optional cross-repo PR to `design_docs` for reflex i18n/calendar UX notes.
