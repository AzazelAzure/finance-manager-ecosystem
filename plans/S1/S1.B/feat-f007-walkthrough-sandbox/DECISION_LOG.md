# Decision Log

## D01: Help Mode Tooltips
**Context:** User wants Help Mode to provide non-blocking hover context over the entire page.
**Decision:** Modify `HelpModeWrapper` to render an absolute positioned native/css tooltip on hover, rather than launching a 1-step Joyride tour on click. No new dependencies allowed.

## D02: Sandbox Overlay
**Context:** Multi-page Joyride tours in SPAs are brittle, and tours are less effective when the user has zero data to show.
**Decision:** Create `OnboardingSandbox.tsx`, a full-screen overlay mimicking the app, pre-populated with seeded dummy data. The Joyride tour will run against this sandbox.

## D03: Financial Literacy
**Context:** The tour must cater to financially illiterate users.
**Decision:** Joyride step contents must include explicit financial guidance (e.g., explaining why Safe-to-Spend is important) alongside the mechanical "click here" instructions.
