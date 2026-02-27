# Lekturnik — Session Guide for Parallel Development

## How This Works

Each phase is designed to be given to a **separate Claude Code session** for parallel development. This guide explains the dependency graph, what each session needs to know, and how to hand off work between sessions.

**Key change: Web PWA is a first-class target.** All UI phases must verify their output works in Chrome (web) in addition to mobile simulators. The web version launches first (no store review), so web compatibility is not optional.

## Dependency Graph

```
Phase 0: Foundation (Flutter iOS+Android+Web, Supabase, CI/CD)
    |
    +---> Phase 1A: Content Pipeline
    |         |
    |         +---> Phase 2A: AI Quiz Engine
    |         |         |
    |         |         +---> Phase 2C: Progress & Gamification
    |         |                    |
    |         |                    +---> Phase 4C: SRS System
    |         |
    |         +---> Phase 3: Content Generation (parallel sessions)
    |         +---> Phase 4A: Matura Statistics
    |         +---> Phase 4B: Motyw Tracker
    |
    +---> Phase 1B: Auth & Users ---+---> Phase 2C (also depends on 2A)
    |
    +---> Phase 1C: Catalog UI
    |
    +---> Phase 2B: Monetization (RevenueCat mobile + web paywall variant)
    |
    +----> All above ---> Phase 5: Polish & Launch
                              |
                              +---> Web PWA deploys FIRST (Day 1)
                              +---> Mobile submits to stores (Day 1, approval Day 7-14)
```

## Parallel Execution Windows

### Window 1: Foundation (must be first, sequential)
- **Phase 0** — 1 session, ~18 hours (includes web platform setup)

### Window 2: Core Features (after Phase 0, run in parallel)
- **Phase 1A** — 1 session, ~12 hours
- **Phase 1B** — 1 session, ~8 hours
- **Phase 1C** — 1 session, ~26 hours
- **Phase 2B** — 1 session, ~14 hours

### Window 3: Integration Features (after Window 2 dependencies met)
- **Phase 2A** — 1 session, ~24 hours (needs Phase 0 + 1A)
- **Phase 2C** — 1 session, ~10 hours (needs Phase 1B + 2A)

### Window 4: Content & Growth (can start during Window 3)
- **Phase 3** — 3-4 parallel sessions, ~60 hours total (needs Phase 1A)
- **Phase 4A** — 1 session, ~40 hours (needs Phase 1A)
- **Phase 4B** — 1 session, ~16 hours (needs Phase 1A)
- **Phase 4C** — 1 session, ~22 hours (needs Phase 2C)

### Window 5: Launch (after all above)
- **Phase 5** — 1 session, ~20 hours (web deploy + store submission + onboarding)

## Session Setup Instructions

When starting a new Claude session for a specific phase:

1. **Point Claude to CLAUDE.md first:** "Read CLAUDE.md and the phase file at tasks/phases/PHASE_X_*.md"
2. **Ensure prerequisite phases are complete:** Check git log for commits from prerequisite phases
3. **Pull latest:** `git pull origin <branch>` before starting
4. **Create feature branch:** `git checkout -b feature/LEKT-XXX-description`
5. **Track progress:** Update tasks/todo.md as work completes
6. **Commit often:** One logical change per commit
7. **Test on web too:** Run `flutter run -d chrome` to verify web compatibility
8. **Push and merge:** Push feature branch, merge to main dev branch

## Per-Session Context

### Phase 0 Session
**Give Claude:** "Set up the Flutter project scaffold (iOS + Android + Web), Supabase backend, and CI/CD pipeline including web deployment. Read CLAUDE.md and tasks/phases/PHASE_0_FOUNDATION.md for full details. Web is a first-class target."

### Phase 1A Session
**Give Claude:** "Build the content pipeline and data layer. Read CLAUDE.md and tasks/phases/PHASE_1A_CONTENT_PIPELINE.md. The Flutter project and Supabase are already set up from Phase 0."

### Phase 1B Session
**Give Claude:** "Build the auth system and user management. Read CLAUDE.md and tasks/phases/PHASE_1B_AUTH_USERS.md. The Flutter project and Supabase are set up. Auth must work on web too (Supabase OAuth redirect flow)."

### Phase 1C Session
**Give Claude:** "Build the catalog browse screen and lektura detail page. Read CLAUDE.md and tasks/phases/PHASE_1C_CATALOG_UI.md. Flutter project is set up. All screens must work in Chrome (web) and mobile. No offline storage on web — use Supabase queries directly."

### Phase 2A Session
**Give Claude:** "Build the AI quiz chat engine. Read CLAUDE.md and tasks/phases/PHASE_2A_AI_QUIZ.md. Content pipeline and Edge Function skeleton exist. Quiz must work on web (free tier pre-generated questions only, no live AI on web)."

### Phase 2B Session
**Give Claude:** "Integrate RevenueCat (mobile only) and build the paywall with dual mode: purchase buttons on mobile, 'download app' CTA on web. Read CLAUDE.md and tasks/phases/PHASE_2B_MONETIZATION.md. The purchases_flutter package must NOT be imported on web."

### Phase 2C Session
**Give Claude:** "Build progress tracking, streaks, and gamification. Read CLAUDE.md and tasks/phases/PHASE_2C_PROGRESS_GAMIFICATION.md. Auth system and quiz engine are built. Progress works on web via Supabase (no local SQLite on web)."

### Phase 3 Sessions (Content)
**Give Claude:** "Generate content for [Lalka/Dziady III/etc.]. Read CLAUDE.md, content/schema/lektura_schema.json, and tasks/phases/PHASE_3_CONTENT_GENERATION.md. Import pipeline is ready."

### Phase 4A/4B/4C Sessions
**Give Claude:** Reference the specific phase file. All depend on earlier data layer work being done.

### Phase 5 Session
**Give Claude:** "Deploy web PWA to lekturnik.pl (FIRST PRIORITY), then prepare mobile app store submissions. Read CLAUDE.md and tasks/phases/PHASE_5_POLISH_LAUNCH.md. All features are built. Web launches Day 1, stores follow."

## Web-Specific Reminders for All Sessions

Every session that touches UI must verify:
- [ ] Screen renders correctly in Chrome (`flutter run -d chrome`)
- [ ] No `dart:io` imports in shared code (breaks web build)
- [ ] Mobile-only packages (RevenueCat, FCM) use conditional imports
- [ ] No offline-dependent features on web (use Supabase directly)
- [ ] Mouse hover states work (web users use mouse)
- [ ] Responsive layout: works at 360px (phone) through 1440px (desktop)

## Merge Strategy

- Each phase works on a feature branch: `feature/phase-X-description`
- Merge into the main dev branch after phase completion
- Resolve conflicts immediately — don't let them accumulate
- Run `flutter analyze` and `flutter test` before merging
- Run `flutter build web --web-renderer html` to verify web build doesn't break
