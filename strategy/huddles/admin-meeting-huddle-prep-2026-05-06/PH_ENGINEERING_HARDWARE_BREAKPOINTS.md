# PH Engineering Hardware Breakpoints (Pre-Huddle Research)

Purpose: provide realistic compute breakpoints and PH-market budget bands for a potential engineering hire, assuming company-provided hardware.

Date seeded: 2026-05-05  
Scope: planning estimates for huddle discussion (not procurement authorization).

## Workload assumption

Target workload is orchestration-heavy engineering:
- Cursor + multi-agent sessions
- multi-repo indexing and edits
- containerized services and local verification
- browser/DOM automation checks

In this workload, RAM and SSD performance are the primary friction points before CPU.

## Breakpoints (compute + budget, PH market)

### BP1 - Minimum viable (friction expected)

- **Spec:** 6-core CPU, 16 GB RAM, 512 GB NVMe SSD
- **Use case:** light coding, remote-heavy execution, limited local parallelism
- **Risk:** memory pressure during concurrent agent + container + browser runs
- **Budget band (PH):**
  - laptop: **PHP 35,000-60,000**
  - desktop: **PHP 45,000-70,000**

### BP2 - Recommended baseline (hire target)

- **Spec:** 8-core CPU, 32 GB RAM, 1 TB NVMe SSD
- **Use case:** stable day-to-day orchestration work with fewer bottlenecks
- **Why this is baseline:** avoids recurring swap-thrash and reduces flow breaks
- **Budget band (PH):**
  - laptop: **PHP 80,000-120,000**
  - desktop: **PHP 75,000-120,000**

### BP3 - High-confidence / future-proof

- **Spec:** 12+ core CPU, 64 GB RAM, 1-2 TB NVMe SSD
- **Use case:** heavy parallel sessions, multiple containers, extended automation cycles
- **When justified:** lead engineer / automation-heavy role / multi-stack ownership
- **Budget band (PH):**
  - laptop: **PHP 130,000-220,000**
  - desktop: **PHP 120,000-200,000**

## Price anchor notes (PH listings reviewed)

Observed market anchors used for the bands:
- 16 GB / 512 GB Ryzen 7 laptops around **PHP 30k-57k**
- 32 GB / 1 TB performance laptops around **PHP 95k+**
- 32 GB / 1 TB Ryzen 7 desktop builds around **PHP 90k-125k**

These are range anchors for planning. Brand/model mix, promos, and bundled GPU tiers cause meaningful variance.

## Business ownership assumption

Hardware cost is treated as a business-borne operating cost under HitM budget constraints.  
Discussion tie-ins: `TP2`, `TP11`, `TP16`, `TP18`, `TP20`.

## Policy subnote - Linux business-kernel and work-use restrictions

For company-owned engineering machines, apply a Linux-first managed baseline so hardware remains primarily a work PC, not a play PC.

Seed policy controls:
- dedicated business Linux distro image for all company devices
- business-managed kernel/profile baseline and mandatory update cadence
- enforced company user profile + endpoint controls
- separate personal user allowance with strict resource/time caps
- blocked gaming/non-work install classes by default, exception-based allowlist
- auditable policy docs for acceptable use and exception handling

Intent: allow limited personal use without compromising primary business availability, security posture, or productivity.

## Huddle decision prompts

1. Which breakpoint becomes the default hiring gate (`BP1`, `BP2`, or `BP3`)?
2. Laptop-first, desktop-first, or role-based mixed policy?
3. What monthly/quarterly hardware budget cap is acceptable vs current cash constraints?
4. What exact personal-use allowances are acceptable under company policy?
