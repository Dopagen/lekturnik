# Lekturnik — Financial Model

## Cost Model at Scale

| Component | 100 MAU | 500 MAU | 1K MAU | 5K MAU | 10K MAU | 50K MAU |
|-----------|---------|---------|--------|--------|---------|---------|
| AI API (GPT-4o-mini) | ~5 PLN | ~25 PLN | ~60 PLN | ~300 PLN | ~600 PLN | ~3,000 PLN |
| Supabase | 0 (Free) | 0 (Free) | 0 (Free) | 100 PLN | 100 PLN | 400 PLN |
| Domain + misc | 20 PLN | 20 PLN | 20 PLN | 20 PLN | 20 PLN | 20 PLN |
| RevenueCat | 0 | 0 | 0 | 0 | 0 (<$2.5K) | ~800 PLN |
| Sentry / Analytics | 0 | 0 | 0 | 0 | 0 | ~200 PLN |
| Apple Dev Account | ~40 PLN/mo | ~40 PLN/mo | ~40 PLN/mo | ~40 PLN/mo | ~40 PLN/mo | ~40 PLN/mo |
| **TOTAL** | **~65 PLN** | **~85 PLN** | **~120 PLN** | **~460 PLN** | **~760 PLN** | **~4,460 PLN** |

**AI API assumptions:** 20% of MAU are premium, average 8 AI sessions/month per premium user, ~$0.003 per session. Free users use pre-generated questions (zero API cost). Content generation is one-time (~$50-150 for 50 lektury).

## Revenue Projections

Revenue model: 9.99 PLN/month or 79.99 PLN/year. Store commission: 15% (small business program year 1). Annual subscribers assumed at 60% of paying base.

| Scenario | M3 MAU | Conv% | M3 Rev | M6 MAU | M6 Rev | M12 MAU | M12 Rev |
|----------|--------|-------|--------|--------|--------|---------|---------|
| Pessimistic | 400 | 2% | 60 PLN | 1,000 | 150 PLN | 3,000 | 450 PLN |
| **Realistic** | **1,000** | **4%** | **300 PLN** | **3,000** | **900 PLN** | **10,000** | **3,000 PLN** |
| Optimistic | 2,000 | 5% | 750 PLN | 8,000 | 3,000 PLN | 25,000 | 9,375 PLN |

Net per subscriber: 9.99 x 0.85 = ~8.49 PLN/mo (monthly) or 79.99/12 x 0.85 = ~5.67 PLN/mo (annual). Blended: ~7.50 PLN/month.

## Break-Even Analysis

Break-even at ~Month 4-5: ~1,500 MAU with 4% conversion (~60 paying users, ~450 PLN) against ~150 PLN costs.

**500 PLN/month target: achievable around Month 5-6.**

## Unit Economics

| Metric | Value | Notes |
|--------|-------|-------|
| LTV | ~60-120 PLN | 6-12 month average subscription |
| CAC (Organic) | ~0-5 PLN | TikTok, ASO, word of mouth |
| CAC (Paid) | ~15-40 PLN | Facebook/Instagram/TikTok ads |
| LTV:CAC (Organic) | 12-24x | Excellent |
| LTV:CAC (Paid) | 1.5-8x | Scale-only channel |
| Monthly churn | 10-15% | Seasonal patterns |
| Payback period | <1 month | Subscription from day 1 |

## Content Creation Investment

| Task | Hours/Lektura | Total (12 MVP) |
|------|--------------|----------------|
| AI-generate base content | 2h | 24h |
| Quiz question bank (50-100 Qs) | 3h | 36h |
| Curated quotes + essay tips | 1h | 12h |
| Motif tagging + cross-references | 1h | 12h |
| Character relationship data | 0.5h | 6h |
| System prompt for AI quiz | 1.5h | 18h |
| QA and accuracy review | 1h | 12h |
| **TOTAL** | **~10h** | **~120h** |
