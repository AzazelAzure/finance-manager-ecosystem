# T02 — Web: Signup Clickwrap + Login Footnote

## Context

`SignupPage.tsx` must have an affirmative consent checkbox before the submit button. `LoginPage.tsx` needs a passive informational footnote linking to ToS and Privacy Policy. Both pages already have SEO meta via react-helmet-async.

## End State

- Signup form: required checkbox gating submit; sends `tos_version` + `tos_accepted_at` to API
- Login page: footnote with ToS and Privacy links (no checkbox, informational only)

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T02.SL1 | Signup clickwrap | V3 |
| T02.SL2 | Login footnote | V3 |

## T02.SL1 — Signup Clickwrap

In `SignupPage.tsx`, add before the submit button:

```tsx
// Checkbox state (uncontrolled or hook-form field)
// Label text: "I agree to the Terms of Service and Privacy Policy"
// "Terms of Service" is a <Link to="/terms">
// "Privacy Policy" is a <Link to="/privacy">
// Submit button disabled until checkbox is checked

// On form submit, include in the payload:
const tosVersion = "1.0"; // Hard-coded for now; update when ToS version bumps
const tosAcceptedAt = new Date().toISOString();
// Send: { ...existingFields, tos_version: tosVersion, tos_accepted_at: tosAcceptedAt }
```

**Hard-coded ToS version:** Use `"1.0"` until a version management system exists. When the ToS is updated in the future, bump this string manually in this component and open a re-consent plan if required.

**Form integration:** If using react-hook-form, add the checkbox as a required boolean field with validation: `{ validate: v => v === true || "You must accept the Terms of Service" }`.

**Acceptance criteria:**
- [V3] Browser: Signup form renders checkbox with correct label text and working links
- [V3] Browser: Submit button is disabled (or shows validation error) when checkbox is unchecked
- [V3] Browser: Submit button becomes enabled after checking the box
- [V3] Browser: Successful signup with checkbox checked; no 400 error from API
- [V3] Browser: "Terms of Service" link in checkbox navigates to `/terms`
- [V3] Browser: "Privacy Policy" link in checkbox navigates to `/privacy`

## T02.SL2 — Login Footnote

In `LoginPage.tsx`, add below the login form:

```tsx
<p className="login-legal-footnote">
  By logging in, you agree to our{" "}
  <Link to="/terms">Terms of Service</Link>{" "}
  and acknowledge our{" "}
  <Link to="/privacy">Privacy Policy</Link>.
</p>
```

Style: small, muted text (use design token for secondary text color). No checkbox — this is passive disclosure, not a gate.

**Acceptance criteria:**
- [V3] Browser: Login page shows footnote with both links
- [V3] Browser: Links navigate to correct legal pages
- [V3] Browser: Footnote is readable but visually secondary (not dominating the login form)

## Evidence

- `evidence/T02.SL1_signup_screenshot.png` — signup form with checkbox
- `evidence/T02.SL1_submit_disabled.png` — submit button disabled state (box unchecked)
- `evidence/T02.SL2_login_footnote.png` — login page with footnote
