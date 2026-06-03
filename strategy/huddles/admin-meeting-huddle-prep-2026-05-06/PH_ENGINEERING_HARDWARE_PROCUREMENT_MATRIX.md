# PH Engineering Hardware Procurement Matrix (Pre-Huddle Artifact)

Purpose: provide a repeatable procurement decision framework for engineering laptops in PH, including landed costs and setup effort beyond sticker price.

Date seeded: 2026-05-05  
Status: planning artifact only (not procurement approval).

## Operating assumption

- Default form factor: **laptop-first** due to PH market availability and infrastructure constraints.
- Desktop exceptions should be role-based and explicitly approved.

## Decision gates (use in sequence)

1. **Role fit gate:** map candidate role to compute breakpoint (`BP1`, `BP2`, `BP3`).
2. **Market availability gate:** shortlist only models with verifiable PH supply.
3. **Landed-cost gate:** include all logistics + setup labor costs (not hardware price only).
4. **Policy compliance gate:** Linux business image and work-use controls feasible on chosen hardware.
5. **Operational readiness gate:** setup and handoff can be completed within hiring timeline.

## Weighted scoring matrix (100 points)

Use this matrix for each shortlisted model.

- **Compute adequacy (25)**
  - meets target breakpoint spec
  - RAM headroom and SSD performance under orchestration load
- **Upgradeability and serviceability (15)**
  - RAM/SSD upgrade path
  - battery and parts availability
- **Linux compatibility and stability (20)**
  - driver reliability (Wi-Fi, BT, suspend, external displays)
  - feasibility of managed business kernel/profile
- **Procurement and logistics reliability (15)**
  - seller credibility, lead time consistency, return policy
  - shipping reliability to HitM and onward to employee
- **Total landed cost (15)**
  - sticker price plus all shipping/setup/troubleshooting cost layers
- **Warranty and repair turnaround (10)**
  - local warranty coverage, expected downtime windows

Recommended pass threshold: **75+** with no zero-score category.

## Landed cost model (what must be included)

Do not approve hardware from base price alone. Compute total landed cost:

`Total Landed Cost = Device Cost + Ship to HitM + HitM Setup Labor + Kernel/Hardening Labor + Troubleshooting Buffer + Ship to Employee + Contingency`

### Required cost lines

- **Device cost** (PHP)
- **Shipping to HitM** (PHP)
- **Time cost: base work setup**
  - OS install/imaging, accounts, baseline tools, validation
  - convert hours to PHP using internal labor-rate assumption
- **Time cost: custom kernel/profile work**
  - build/tuning/testing cycle
  - include potential rework after first boot/patch cycle
- **Troubleshooting reserve**
  - compatibility issues, driver regressions, update breakage
  - include possible outsource cost if internal capacity is constrained
- **Shipping to employee** (PHP)
  - include packaging, courier, insurance assumptions
- **Contingency**
  - suggested planning reserve: 10-15%

## Setup workload planning (time budget checkpoints)

Use these checkpoints per device to estimate effort:

1. **Baseline provisioning**
   - install and patch OS, encryption, account controls
2. **Engineering environment**
   - repo/toolchain/container/runtime setup and smoke tests
3. **Business-kernel/profile hardening**
   - managed kernel/profile install, policy enforcement checks
4. **Stability validation**
   - reboot cycles, suspend/resume, network, external display, browser automation
5. **Handoff packaging**
   - documentation, credentials transfer protocol, shipping prep

If projected setup effort exceeds internal capacity, create one of:
- outsource workstream
- internal task packet with explicit work points and ownership

## Risk flags to track during evaluation

- soldered RAM below target headroom
- weak Linux driver support for key components
- poor after-sales or uncertain warranty servicing
- long lead times that collide with hire start date
- hidden logistics costs eroding budget viability

## Candidate comparison template (copy per model)

Use this block for each candidate device:

- **Model:**  
- **Target breakpoint:** `BP1` / `BP2` / `BP3`  
- **Base price (PHP):**  
- **Ship to HitM (PHP):**  
- **Setup labor (hours):**  
- **Kernel/hardening labor (hours):**  
- **Troubleshooting reserve (PHP or hours):**  
- **Ship to employee (PHP):**  
- **Contingency (PHP):**  
- **Total landed cost (PHP):**  
- **Matrix score (/100):**  
- **Pass/Fail:**  
- **Notes/risk flags:**  

## Policy note for work-use enforcement

Company engineering laptops should be treated as work-first assets with limited personal-use allowances.  
Business Linux baseline and policy enforcement must be part of procurement acceptance, not a post-purchase afterthought.

## Discussion prompts for huddle linkage

1. What internal labor-rate assumption should convert setup hours into budget cost?
2. What is acceptable max setup lead time from purchase to employee-ready handoff?
3. At what threshold do we outsource kernel/hardening support vs keep in-house?
4. What minimum warranty/repair SLA is required for approval?
