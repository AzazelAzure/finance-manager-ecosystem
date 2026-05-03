# Distribution Channel Research Notes (May 2026)

**Purpose**: This document captures the strategic research regarding Facebook automation, AI Video monetization, and Paid Ad benchmarks for the Philippine market to support the S1.B distribution strategy.

## 1. Facebook API & Automation Strategy

**Findings:**
*   **Facebook Pages**: Fully supported by the Facebook Graph API. You can programmatically schedule, publish, and drip-feed content (text, photos, videos) to a Business Page without manual intervention, subject to standard API rate limits.
*   **Facebook Groups**: As of April 2024, Meta completely deprecated the Facebook Groups API. There is **no legitimate third-party API support** to automate posting to groups.
*   **Strategic Implication**: The automated "drip feed" for roadmaps and product updates must be routed exclusively to the **Facebook Business Page**. The Facebook Group should be reserved for high-touch, organic community building, where posts are either done manually or scheduled natively using Facebook's internal admin tools.

## 2. AI Video Monetization Potential (Philippines)

Treating AI videos as an independent revenue stream to offset development costs requires understanding platform-specific monetization rules in the PH.

**Findings by Platform:**
*   **TikTok**: The official "Creator Rewards Program" (which pays directly for video views) is **NOT available in the Philippines**. Filipino creators monetize via TikTok Shop/Affiliates or live gifting, making direct video monetization for a SaaS brand very difficult.
*   **YouTube Shorts**: To qualify for full ad revenue, you need 1,000 subscribers and 10 million Shorts views in 90 days. Furthermore, the RPM (Revenue Per Mille) for Shorts in the Philippines is extremely low, averaging **$0.01 to $0.03 per 1,000 views**.
*   **Facebook Reels**: Meta offers "Ads on Reels" and "Performance Bonuses" in the Philippines (often invite-only via the Professional Dashboard). Given Facebook's absolute dominance in PH internet usage, this is the most viable path, though exact RPMs vary wildly based on engagement.
*   **Strategic Implication**: Direct ad revenue from AI videos in the PH is likely too low to significantly fund business development early on (e.g., 1 million YT views = ~$10-$30). The primary ROI of AI videos must remain **user acquisition and brand trust**, with platform payouts treated as a minor bonus. Facebook Reels should be the primary focus.

## 3. Paid Visibility & SEO (Cost Benchmarks)

Understanding the cost of acquiring a user (CAC) via paid channels to evaluate against the ₱249/mo Pro subscription.

**Findings:**
*   **Google Search Ads**: Finance is one of the most expensive niches. The average CPC (Cost Per Click) for finance/insurance keywords in the PH is roughly **$3.44 (₱190–₱195)**.
*   **Facebook Ads**: The average Cost Per Install (CPI) for apps in the PH is around **₱260**.
*   **Strategic Implication**: At ~₱195 per *click* on Google, and a Pro subscription yielding ~₱249/mo, paid Google Ads are **highly unprofitable** for early acquisition unless the conversion rate and Lifetime Value (LTV) are incredibly high. Paid ads should be strictly deferred. **SEO is critical**—foundational SEO work must begin immediately to capture organic search intent without the crippling CPC costs.

## 4. Recommended Marketing Timeline & Gating

To prevent promoting a product that isn't public-ready (6-12 month horizon), marketing must be gated:

*   **T-12 to T-6 Months (Alpha/Core Dev)**: 
    *   **Action**: Foundational SEO (building content around keyword intent). 
    *   **Action**: Experimental AI Videos on FB Reels/TikTok focused purely on general financial literacy/founder story (building an audience, no hard product sell).
*   **T-6 to T-3 Months (Private Beta)**: 
    *   **Action**: Launch FB Business Page and Group. 
    *   **Action**: Begin API drip-feeding development updates and UI teasers to the Page to build algorithmic momentum.
*   **T-3 to T-0 Months (Public Beta Prep)**: 
    *   **Action**: Shift AI Video CTA (Call to Action) to "Join the Waitlist/Beta." Activate the community group for feedback.
