# Lekturnik — Risk Analysis

## Risk Matrix

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| **Lekturowo adds AI** | Low-Med (20-30%) | High | Move fast. Build features hard to replicate: SRS, motif tracker, matura stats. Solo dev hasn't added AI in 6 years — significant pivot required. |
| **Knowunity deepens Polish lektury** | Low (10-15%) | High | Knowunity is horizontal across Europe. Deep curriculum-specific coverage needs dedicated Polish team. Our advantage: depth in narrow niche. |
| **Students just use ChatGPT** | High (60-70%) | Medium | ChatGPT hallucinates on Polish lit. Position as "verified AI" with progress tracking, gamification, exam focus. Structured tool vs unstructured chatbot. |
| **MEN changes lektura list** | High (80-90%) by 2028 | Medium | Already planned: new podstawa programowa Sep 2026 (SP) and 2028 (LO). Modular content architecture. AI regeneration faster than print publishers. |
| **API cost spike** | Low (10-15%) | Medium | Pricing trending down consistently. Pre-generated question cache = structural hedge. Worst case: switch to cheaper/open-source models. |
| **Low conversion (<2%)** | Med (30-40%) | High | A/B test paywall aggressively. Adjust gate timing, extend trials, seasonal promos. Fallback: ad-supported model. |
| **Content quality errors** | Med (25-35%) | High | Manual review against original texts + Greg guides. Community error reporting. Version control. Accuracy is our moat vs ChatGPT. |
| **GDPR/RODO compliance** | Low-Med (15-25%) | Very High | Budget 2-5K PLN for legal review. Minimal-data architecture. Core features without accounts. Under-16 consent flow. EU infrastructure. Non-negotiable. |
| **App Store rejection** | Low-Med (20-30%) | Medium | Common reasons: incomplete content, unclear subscriptions, privacy for minors. Address proactively. Budget 1-2 weeks for iterations. |
| **Seasonal revenue** | High (70-80%) | Medium | Annual subscriptions lock revenue. Spread demand: osmoklasisty (May), first-semester tests (Oct-Nov), back-to-school (Sep). |
| **Solo dev burnout** | High (50-60%) | Very High | Scope MVP to 12 lektury only. Batch content with AI. Hard limit: if not revenue-positive by month 8, reassess. Consider content co-creator. |

## Critical Path Risks

1. **Legal compliance must precede launch.** Privacy policy + copyright opinion = ~2,500-5,000 PLN. Non-negotiable.
2. **Content quality is existential.** One viral TikTok showing Lekturnik hallucinating = brand death. Triple-check all content.
3. **Matura timing is everything.** Missing May 2026 exam peak means waiting an entire year for next opportunity.

## Risk Response Decision Tree

```
Content error reported
  -> Immediately flag in DB (hide from users)
  -> Fix within 24h
  -> Push corrected content
  -> Log in tasks/lessons.md

API costs exceeding budget
  -> Check: are free users somehow hitting live API?
  -> Reduce pre-generated question refresh rate
  -> Switch to cheaper model (Gemini Flash as fallback)
  -> Increase free-tier question cache size

App Store rejection
  -> Read rejection reason carefully
  -> Fix exact issue (don't guess)
  -> Resubmit with detailed reviewer notes
  -> Use App Review appeal if rejection seems wrong

Low conversion after 3 months
  -> A/B test: paywall timing, pricing, trial length
  -> Survey churned users (in-app or email)
  -> Consider: is free tier too generous?
  -> Consider: is Premium value unclear?
  -> Nuclear option: switch to ad-supported with Premium ad-free
```
