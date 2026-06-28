---
research_id: RESEARCH_WASM_RUST_FINANCIAL_CALC_2026-06-26
status: draft
created: 2026-06-26
author: pproctor
phase: S1.B
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md
---

# WASM Rust Financial Calculations — Strategic Research Note

> **Not a feature plan.** This is a strategic architecture decision note for research and planning. Execution belongs in feature plans for F-001, F-003, F-005, and a dedicated `feat-wasm-rust-tools` plan when ready.

## Decision Context

HitM declared 2026-06-26: financial calculations in the PWA frontend should run through **WASM-compiled `finance_manager_rust_tools`** rather than JavaScript float math or third-party JS libraries (currency.js, Dinero.js). This is an architectural shift with two compounding benefits:

1. **Immediate:** correct, deterministic financial arithmetic (Rust's integer/fixed-point math vs JS float rounding errors)
2. **Long-term:** the calculation substrate that ZK proof generation requires is written in Rust — having calculations already in Rust/WASM is the natural predecessor to wrapping them in ZK circuits for S5

## Affected Feature Plans

| Feature | Current calc approach | WASM impact |
|---|---|---|
| F-001 Balance History | JS date math + float aggregation | Aggregate calculations move to Rust |
| F-003 Predictive Budgeting | JS projections | Projection engine in Rust |
| F-005 Savings Goals | JS progress math | Goal progress + timeline in Rust |
| F-002 Smart Tag Estimation | Already references rust_tools | Confirm WASM compilation path |
| UI/UX T01.SL3 (money audit) | "Install currency.js or Dinero.js" | **Override: prefer WASM rust_tools** — see note below |

### UI/UX T01.SL3 override note

The current plan at `plans/S1/S1.B/feat-ui-ux-design-system/tasks/T01_design_tokens.md` (SL3) says: *"install `currency.js` or `Dinero.js` if float math found."* This should be superseded by WASM rust_tools when the compilation path is established. Do not install currency.js as a permanent solution — it is acceptable as a **temporary bridge** only if WASM integration is not yet available during that sprint.

## `finance_manager_rust_tools` Submodule Status

Currently: `rust_tools:Tight Beta` @ `82d4994`. It exists as a submodule used for numerics but is not yet compiled to WASM or consumed by the web frontend. The WASM compilation path (`wasm-pack` or equivalent) needs to be established as a prerequisite before any feature plan can depend on it.

## Implementation Prerequisites (research questions)

1. **WASM compilation path:** Does `finance_manager_rust_tools` currently support `wasm-pack build`? What crate features are needed? Which functions are candidates for WASM export?
2. **Bundle size impact:** WASM modules add to the JS bundle. What is the expected size contribution, and does it fit within the ≤200KB initial JS target?
3. **Web worker isolation:** Financial calculations should ideally run off the main thread (Web Worker + WASM). Is this viable with the current Vite build setup?
4. **Shared type contract:** How do Rust types (fixed-point decimals) map to the TypeScript types used in the frontend? What serialization boundary is needed (e.g., JSON over the WASM boundary)?
5. **ZK alignment:** What ZK toolchain is anticipated for S5 (RISC Zero, sp1, Noir)? Ensure the Rust calculation code is compatible with whichever ZK circuit approach is chosen. **This choice should be validated before investing heavily in the WASM path.**

## ZK Alignment Rationale

ZK proof systems for financial computations (e.g., "prove my balance is above X without revealing the balance") require the computation to be expressed in a ZK-compatible form. Rust is the dominant language for ZK tooling (RISC Zero, sp1 both use Rust as the guest language). Having financial calculations already in Rust means:

- ZK wrapping is a **layer added around existing code**, not a rewrite
- The calculation logic is already auditable and deterministic (prerequisite for ZK)
- WASM and ZK guest code can share the same Rust crate, reducing maintenance surface

## Proposed Execution Path

When ready (likely after F-001/F-003/F-005 feature plans are written):

1. **Research spike:** Answer the 5 prerequisite questions above (1–2 day Cursor task)
2. **WASM scaffold plan:** `feat-wasm-rust-tools/` — establish `wasm-pack` compilation, Vite integration, TypeScript bindings, bundle size verification
3. **Feature integration:** F-001, F-003, F-005 plans updated to depend on WASM scaffold and call Rust calculation functions rather than JS implementations
4. **S5 alignment checkpoint:** Before S5 ZK work begins, verify the Rust calculation crate is compatible with chosen ZK toolchain

## Priority

**Late S1.B or S1.C.** The WASM scaffold is a prerequisite for F-001/F-003/F-005 if those features are to use Rust calculations. However, it is acceptable to ship F-001/F-003/F-005 with temporary JS float math (using currency.js as bridge) and migrate to WASM in a follow-on sprint, rather than blocking feature delivery on the WASM path. HitM to decide sequencing when those feature plans are written.
