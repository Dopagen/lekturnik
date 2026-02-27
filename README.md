# Lekturnik — Lektury AI | Matura Polski

> The first AI-native study companion for Polish mandatory school literature (lektury).

## What is Lekturnik?

Lekturnik helps ~2 million Polish students (klasy 7-8, liceum, technikum) study mandatory school literature with AI-powered tools that no competitor offers:

- **AI "Sprawdzi sie" Quiz** — Tests whether you actually read the book, not just the summary
- **Motyw Tracker** — Cross-lektura motif mapping for comparative essays
- **Cytaty na Mature** — Curated quote bank with spaced repetition
- **Rozprawka Builder** — AI-powered essay outline scaffolding
- **Matura Statistics** — Which lektury appear most on exams, based on 20 years of CKE archives

## Why Lekturnik?

| Problem | Current Solutions | Lekturnik |
|---------|------------------|-----------|
| "Did the student actually read it?" | No verification exists | AI quiz catches summary-skimmers |
| ChatGPT hallucinates on Polish lit | Students get fabricated plots | Verified, curriculum-aligned content |
| No cross-lektura study tools | Students build motif tables by hand | Interactive motif matrix |
| Static content everywhere | Lekturowo, Bryk.pl — no AI | AI-powered adaptive learning |

## Tech Stack

- **Frontend:** Flutter (iOS + Android from single codebase)
- **Backend:** Supabase (PostgreSQL, Edge Functions, Auth)
- **AI:** GPT-4o-mini for live quiz, Claude Sonnet for content generation
- **Payments:** RevenueCat
- **Analytics:** PostHog

## Project Status

**Phase:** Pre-development (planning & documentation complete)

See `docs/` for full documentation and `tasks/phases/` for development roadmap.

## Documentation

| Document | Description |
|----------|-------------|
| [CLAUDE.md](CLAUDE.md) | Development guide & AI assistant instructions |
| [Business Blueprint](docs/BUSINESS_BLUEPRINT.md) | Market analysis, competition, legal |
| [PRD](docs/PRD.md) | Product requirements & feature specifications |
| [Technical Architecture](docs/TECHNICAL_ARCHITECTURE.md) | Stack, DB schema, AI integration |
| [Development Tickets](docs/DEVELOPMENT_TICKETS.md) | All LEKT-xxx tickets |
| [Financial Model](docs/FINANCIAL_MODEL.md) | Cost model, revenue projections, unit economics |
| [Go-to-Market](docs/GO_TO_MARKET.md) | Launch timing, channels, pricing strategy |
| [Risk Analysis](docs/RISK_ANALYSIS.md) | Risk matrix with mitigations |

## Development Phases

| Phase | Scope | Sessions | Depends On |
|-------|-------|----------|------------|
| **0** | Foundation (scaffold, Supabase, CI/CD) | 1 | — |
| **1A** | Content pipeline & data layer | 1 | Phase 0 |
| **1B** | Auth & user system | 1 | Phase 0 |
| **1C** | Catalog & browse UI | 1 | Phase 0 |
| **2A** | AI quiz engine | 1 | Phase 0 + 1A |
| **2B** | Monetization (RevenueCat, paywall) | 1 | Phase 0 |
| **2C** | Progress & gamification | 1 | Phase 1B + 2A |
| **3** | Content generation (12 lektury) | 3-4 parallel | Phase 1A |
| **4A** | Matura statistics engine | 1 | Phase 1A |
| **4B** | Motyw Tracker | 1 | Phase 1A |
| **4C** | SRS system | 1 | Phase 2C |
| **5** | Polish & launch | 1 | All above |

See `tasks/SESSION_GUIDE.md` for how to assign phases to separate Claude sessions.

## License

Proprietary. All rights reserved.
