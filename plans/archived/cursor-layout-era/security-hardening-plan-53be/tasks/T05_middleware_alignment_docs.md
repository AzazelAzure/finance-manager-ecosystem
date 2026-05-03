# T05 Middleware Alignment Docs

## Objective
Create a low-rebuild security contract note that separates current beta security posture from future Rust/ZK middleware assumptions.

## Scope Boundary
- Primary repo/path: `design_docs/`
- Related repos for references only:
  - `finance_manager_api/`
  - `finance_manager_reflex/`
  - `finance_manager_rust_middleware/`
- Do not implement crypto, rolling keys, or Rust services in this task.

## Current Evidence
- Current beta path is JWT/OAuth plus plaintext JSON finance payloads.
- Long-term docs describe client-side ZK encryption, rolling keys, Rust/WASM/middleware integration, and global peppers:
  - `design_docs/00_Encryption_Strategy.md`
  - `design_docs/40_System_Design/Authentication.md`
  - `design_docs/rust_docs/00_Rust_Overview.md`
- Rust repos are starter shells with no crate/contracts yet.

## Requested Change
Add or update docs to explicitly define:
- Current beta posture:
  - JWT/OAuth over HTTPS.
  - Finance payloads are plaintext inside trusted API/runtime boundary.
  - ZK/rolling keys are not beta blockers unless explicitly scheduled.
- Future middleware extension seams:
  - reserved rolling-key header names or ADR placeholder
  - versioned opaque encrypted payload envelope
  - feature flag naming
  - redaction rule for key-adjacent/ciphertext metadata
  - Rust integration mode decision needed: gateway vs sidecar vs FFI
- `Cargo.lock` policy for future shipped Rust binaries/services.

## Acceptance Criteria
- Docs prevent confusion between beta readiness and future ZK requirements.
- Docs name `finance_manager_rust_middleware` as the planned repo instead of TBD-only naming.
- Docs state that future encrypted payloads should be versioned/opaque so API code does not hard-code plaintext-only assumptions.
- No docs claim zero-knowledge is implemented today.

## Verification
Read changed docs for consistency with:
- `design_docs/api_docs/05_Authentication_and_Security.md`
- `design_docs/20_Roadmap/Beta_Contract_Compatibility_Matrix.md`
- `design_docs/rust_docs/00_Rust_Overview.md`
- `docs/DEPENDENCY_LOCKFILES.md`

## Handoff Output
Use shared handoff format and include:
- Docs changed.
- Any open architectural decisions.
- Branch/PR status.
