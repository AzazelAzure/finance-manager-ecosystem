# Validation Gates

## Gate A: Auth and secret baseline
- Anonymous requests to finance data routes return `401 Unauthorized`.
- Explicitly public routes are documented and tested.
- `finance_manager_api/.env.bak` is removed from tracked files.
- API `.gitignore` prevents future `.env*` / backup secret commits.
- Rotation note exists for any exposed secret-like values.

## Gate B: Browser token and deployment policy
- Reflex token storage decision is documented for beta and future middleware.
- If cookie strategy changes, browser `Set-Cookie` output confirms `Secure`, `SameSite`, and `HttpOnly` where applicable.
- API CSRF/CORS deployment stance is explicit: same-origin reverse proxy or cross-origin allowlist.
- `manage.py check --deploy` runs with production-like env and residual warnings are intentional.

## Gate C: Logging and payload redaction
- Invalid transaction or finance payload logs do not include raw request bodies.
- Auth-adjacent logs do not print tokens, rolling-key candidates, passphrases, or ciphertext bodies.
- User log context uses pseudonymous identifiers unless debug-only behavior is explicitly enabled.

## Gate D: Future Rust/ZK alignment
- Design docs distinguish current beta security posture from post-beta ZK/Rust middleware posture.
- A versioned crypto envelope draft exists, even if feature-flagged and unimplemented.
- Rolling-key/header names are reserved or documented as pending.
- Rust middleware repo policy resolves `Cargo.lock` behavior before first shipped crate.

## Final Gate
- Each touched repo has a focused PR.
- PRs are posted to `#pull-requests`.
- Slack authorization and GitHub mergeability/check state are reconciled.
- Remaining security risks are explicitly marked accepted, blocked, or assigned to follow-up task packets.
