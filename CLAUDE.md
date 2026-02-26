# CLAUDE.md — Lekturnik Development Guide

## Project Overview

**Lekturnik** is an AI-powered Polish lektury (mandatory school literature) study app. It targets ~2 million Polish students (klasy 7-8, liceum, technikum) who need lektury knowledge for high-stakes exams (matura, egzamin osmoklasisty).

**Core value prop:** The first app combining verified, curriculum-aligned Polish literary content with AI-powered interactive assessment. Generic AI hallucinates on Polish literature — Lekturnik doesn't.

**Business model:** Freemium. Free tier: basic summaries + 3 AI quizzes/day (pre-generated). Premium: 9.99 PLN/month or 79.99 PLN/year — unlimited AI, full content, SRS, offline, no ads.

**Revenue target:** 500 PLN/month within 6 months (~60 paying users at 4% conversion from 1,500 MAU).

## Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Frontend | **Flutter** (Dart) | Single codebase iOS+Android, strong perf |
| Backend | **Supabase** (PostgreSQL + Edge Functions) | Free tier 50K MAU, built-in auth, EU hosting |
| AI (live quiz) | **GPT-4o-mini** via OpenAI API | $0.15/$0.60 per MTok, sufficient for lit Q&A |
| AI (content gen) | **Claude Sonnet** via Anthropic API | Higher quality for one-time batch content |
| Payments | **RevenueCat** | Handles subscription logic, free <$2.5K MTR |
| Analytics | **PostHog** or **Mixpanel** | PostHog free tier generous |
| Push | **FCM** (Firebase Cloud Messaging) | Free, cross-platform |
| CI/CD | **GitHub Actions + Fastlane** | Automates store submission |
| Error tracking | **Sentry** (Flutter SDK) | Free tier sufficient early |

## Project Structure

```
lekturnik/
├── CLAUDE.md                          # This file — development guide
├── README.md                          # Project overview
├── docs/
│   ├── BUSINESS_BLUEPRINT.md          # Market, competition, content strategy, legal
│   ├── PRD.md                         # Product requirements & feature specs
│   ├── TECHNICAL_ARCHITECTURE.md      # Stack, DB schema, AI integration
│   ├── DEVELOPMENT_TICKETS.md         # All LEKT-xxx tickets
│   ├── FINANCIAL_MODEL.md             # Costs, revenue, unit economics
│   ├── GO_TO_MARKET.md                # Launch timing, channels, pricing
│   └── RISK_ANALYSIS.md               # Risk matrix with mitigations
├── tasks/
│   ├── todo.md                        # Current task tracking (checkable items)
│   ├── lessons.md                     # Lessons learned from mistakes
│   ├── SESSION_GUIDE.md               # How to run parallel Claude sessions
│   └── phases/                        # Phase-by-phase work breakdown
│       ├── PHASE_0_FOUNDATION.md      # Project scaffold, Supabase, CI/CD
│       ├── PHASE_1A_CONTENT_PIPELINE.md
│       ├── PHASE_1B_AUTH_USERS.md
│       ├── PHASE_1C_CATALOG_UI.md
│       ├── PHASE_2A_AI_QUIZ.md
│       ├── PHASE_2B_MONETIZATION.md
│       ├── PHASE_2C_PROGRESS_GAMIFICATION.md
│       ├── PHASE_3_CONTENT_GENERATION.md
│       ├── PHASE_4A_MATURA_STATS.md
│       ├── PHASE_4B_MOTYW_TRACKER.md
│       ├── PHASE_4C_SRS_SYSTEM.md
│       └── PHASE_5_POLISH_LAUNCH.md
├── content/
│   └── schema/
│       └── lektura_schema.json        # JSON schema for lektura content import
├── lib/                               # Flutter app source (created in Phase 0)
│   ├── main.dart
│   ├── app/                           # App-level config, routing, themes
│   ├── features/                      # Feature modules
│   │   ├── catalog/                   # Lektura browsing & search
│   │   ├── detail/                    # Lektura detail page
│   │   ├── quiz/                      # AI quiz chat
│   │   ├── auth/                      # Authentication & onboarding
│   │   ├── progress/                  # Progress dashboard & streaks
│   │   ├── paywall/                   # Subscription & paywall
│   │   ├── motifs/                    # Motyw Tracker
│   │   ├── srs/                       # Spaced repetition
│   │   ├── matura/                    # Matura statistics
│   │   └── rozprawka/                 # Essay builder
│   ├── models/                        # Data models (freezed)
│   ├── services/                      # API clients, AI service, storage
│   ├── providers/                     # Riverpod providers
│   └── shared/                        # Shared widgets, utils, constants
├── supabase/                          # Supabase project files
│   ├── migrations/                    # SQL migration files
│   ├── functions/                     # Edge Functions (Deno/TypeScript)
│   │   └── ai-quiz/                   # AI quiz proxy function
│   └── seed.sql                       # Seed data for development
├── test/                              # Flutter tests
├── ios/                               # iOS native config
├── android/                           # Android native config
└── .github/
    └── workflows/                     # CI/CD pipelines
```

## Key Documentation

Read these before starting any work:

1. **`docs/PRD.md`** — Feature specs, user stories, acceptance criteria
2. **`docs/TECHNICAL_ARCHITECTURE.md`** — DB schema, AI integration details, performance requirements
3. **`docs/DEVELOPMENT_TICKETS.md`** — All tickets with effort estimates and dependencies
4. **`tasks/SESSION_GUIDE.md`** — How each phase is scoped for parallel sessions
5. **`tasks/phases/PHASE_X_*.md`** — Detailed work breakdown per phase

## Database Schema (Quick Reference)

Core entities: `lektury`, `chapters`, `characters`, `motifs`, `quotes`, `quiz_questions`, `matura_questions`, `users`, `user_progress`, `quiz_sessions`, `srs_cards`

Junction tables: `lektura_motifs` (with explanation field), `matura_question_lektury`, `matura_question_motifs`

Full schema in `docs/TECHNICAL_ARCHITECTURE.md`.

## Content Pipeline

Lektura study content follows this flow:
1. AI generates base content via Claude Sonnet (one-time batch)
2. Output formatted as JSON matching `content/schema/lektura_schema.json`
3. Manual review against original texts for accuracy
4. Import script upserts into Supabase
5. Quiz questions pre-generated (50-100 per lektura) and stored in DB
6. System prompts per lektura stored alongside content

## AI Architecture (Cost-Critical)

- **Free tier:** Zero API cost. Pre-generated questions served from DB.
- **Premium live chat:** GPT-4o-mini via Supabase Edge Function. ~$0.002-0.005/session.
- **Content generation:** Claude Sonnet batch. ~$5-15 per lektura (one-time).
- **NEVER** expose API keys in client code. All AI calls route through Edge Functions.

---

## Workflow Orchestration

### 1. Plan Mode Default

Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions).

If something goes sideways, **STOP and re-plan immediately** — don't keep pushing.

Use plan mode for verification steps, not just building.

Write detailed specs upfront to reduce ambiguity.

### 2. Subagent Strategy

Use subagents liberally to keep main context window clean.

Offload research, exploration, and parallel analysis to subagents.

For complex problems, throw more compute at it via subagents.

One task per subagent for focused execution.

### 3. Self-Improvement Loop

After ANY correction from the user: update `tasks/lessons.md` with the pattern.

Write rules for yourself that prevent the same mistake.

Ruthlessly iterate on these lessons until mistake rate drops.

Review lessons at session start for relevant project.

### 4. Verification Before Done

Never mark a task complete without proving it works.

Diff behavior between main and your changes when relevant.

Ask yourself: "Would a staff engineer approve this?"

Run tests, check logs, demonstrate correctness.

### 5. Demand Elegance (Balanced)

For non-trivial changes: pause and ask "is there a more elegant way?"

If a fix feels hacky: "Knowing everything I know now, implement the elegant solution."

Skip this for simple, obvious fixes — don't over-engineer.

Challenge your own work before presenting it.

### 6. Autonomous Bug Fixing

When given a bug report: just fix it. Don't ask for hand-holding.

Point at logs, errors, failing tests — then resolve them.

Zero context switching required from the user.

Go fix failing CI tests without being told how.

## Task Management

- **Plan First:** Write plan to `tasks/todo.md` with checkable items
- **Verify Plan:** Check in before starting implementation
- **Track Progress:** Mark items complete as you go
- **Explain Changes:** High-level summary at each step
- **Document Results:** Add review section to `tasks/todo.md`
- **Capture Lessons:** Update `tasks/lessons.md` after corrections

## Core Principles

- **Simplicity First:** Make every change as simple as possible. Impact minimal code.
- **No Laziness:** Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact:** Changes should only touch what's necessary. Avoid introducing bugs.
- **Polish language in UI:** All user-facing strings in Polish. Code, comments, commits in English.
- **Accuracy is the moat:** Every piece of literary content must be verified against original texts. This is what differentiates us from ChatGPT.

## Common Commands

```bash
# Flutter
flutter run                    # Run app in debug mode
flutter test                   # Run all tests
flutter build apk              # Build Android APK
flutter build ios              # Build iOS app
flutter analyze                # Static analysis

# Supabase
supabase start                 # Start local Supabase
supabase db push               # Push migrations to remote
supabase functions serve        # Serve Edge Functions locally
supabase functions deploy       # Deploy Edge Functions

# Code generation
dart run build_runner build     # Generate freezed/json_serializable code

# Testing
flutter test --coverage        # Tests with coverage
flutter test test/features/quiz/  # Test specific feature
```

## Git Conventions

- Branch naming: `feature/LEKT-XXX-short-description`
- Commit messages: `feat(LEKT-XXX): short description` / `fix(LEKT-XXX): ...` / `docs: ...`
- One logical change per commit
- Never push directly to main — use feature branches + PR

## Environment Variables (Never Commit)

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
OPENAI_API_KEY=          # Only in Edge Functions
ANTHROPIC_API_KEY=        # Only for content generation scripts
REVENUECAT_API_KEY=
SENTRY_DSN=
```

## Priority Lektury (MVP 12)

1. Lalka (Prus) — appears in ~85% of matura exams
2. Dziady cz. III (Mickiewicz)
3. Wesele (Wyspianski)
4. Pan Tadeusz (Mickiewicz)
5. Zbrodnia i kara (Dostojewski)
6. Dzuma (Camus)
7. Rok 1984 (Orwell)
8. Ferdydurke (Gombrowicz)
9. Tango (Mrozek)
10. Przedwiosnie (Zeromski)
11. Antygona (Sofokles)
12. Makbet (Szekspir)
