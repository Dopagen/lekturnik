# Phase 0: Foundation

**Effort:** ~14 hours | **Tickets:** LEKT-001, LEKT-002, LEKT-011 | **Dependencies:** None (must be first)

## Goal

Set up the Flutter project, Supabase backend, CI/CD pipeline, and analytics foundation. Everything else depends on this.

## Deliverables

### 1. Flutter Project Scaffold (LEKT-001, ~8h)

- [ ] Initialize Flutter project (3.19+) with proper package name
- [ ] Set up folder structure per CLAUDE.md (`lib/app`, `lib/features/*`, `lib/models`, `lib/services`, `lib/providers`, `lib/shared`)
- [ ] Configure Riverpod (flutter_riverpod + riverpod_annotation)
- [ ] Configure GoRouter with route definitions for all planned screens (placeholder screens OK)
- [ ] Bottom tab navigation: Home (catalog), Search, Progress, Profile
- [ ] Theme system: define `AppTheme` with light + dark mode, color palette, typography scale, spacing tokens
- [ ] Add core dependencies to pubspec.yaml:
  - `flutter_riverpod`, `riverpod_annotation`
  - `go_router`
  - `freezed_annotation`, `json_annotation` (+ build_runner, freezed, json_serializable as dev deps)
  - `supabase_flutter`
  - `drift` + `sqlite3_flutter_libs` (offline storage)
  - `purchases_flutter` (RevenueCat)
  - `firebase_messaging`, `firebase_core`
  - `sentry_flutter`
- [ ] Create placeholder screens for each feature area
- [ ] Ensure `flutter analyze` passes with zero warnings
- [ ] Ensure `flutter test` runs (even if no tests yet)

### 2. Supabase Backend Setup (LEKT-002, ~6h)

- [ ] Create Supabase project (EU region: Frankfurt)
- [ ] Write and apply all SQL migrations (full schema from `docs/TECHNICAL_ARCHITECTURE.md`):
  - `lektury`, `chapters`, `characters`, `motifs`, `lektura_motifs`, `quotes`
  - `quiz_questions`, `matura_questions`, `matura_question_lektury`, `matura_question_motifs`
  - `users`, `user_progress`, `quiz_sessions`, `srs_cards`
  - `lektura_system_prompts`
  - All indexes
- [ ] Configure Row Level Security policies
- [ ] Set up Auth: email/password, Apple Sign-In, Google Sign-In providers
- [ ] Create Edge Function skeleton: `supabase/functions/ai-quiz/index.ts`
- [ ] Insert seed data: at least 1 test lektura with all related records
- [ ] Verify Supabase client connects from Flutter app

### 3. Analytics Foundation (LEKT-011 partial, ~2h — optional, can defer)

- [ ] Integrate PostHog or Mixpanel Flutter SDK
- [ ] Create analytics service wrapper (`lib/services/analytics_service.dart`)
- [ ] Define core events: `app_open`, `lektura_viewed`, `quiz_started`, `quiz_completed`, `paywall_shown`
- [ ] Verify events fire in debug mode

### 4. CI/CD Setup

- [ ] GitHub Actions workflow: lint + test on PR
- [ ] Fastlane setup for iOS + Android (basic lane definitions)
- [ ] `.gitignore` properly configured (no API keys, no build artifacts)

## Acceptance Criteria

- [ ] `flutter run` launches app with bottom tabs and navigation
- [ ] Supabase tables exist and can be queried from Flutter
- [ ] Edge Function deploys and responds to test request
- [ ] `flutter analyze` clean
- [ ] CI runs on push

## Key Decisions for This Phase

1. **Package name:** `pl.lekturnik.app` (or similar)
2. **Minimum Flutter SDK:** 3.19
3. **Minimum Android API:** 21 (Android 5.0)
4. **Minimum iOS:** 15.0
5. **Supabase region:** eu-central-1 (Frankfurt)

## Notes for Claude Session

- This phase creates the foundation everything else builds on. Be thorough.
- Don't over-engineer the theme — just define tokens that can evolve.
- Placeholder screens should have screen name displayed so navigation is testable.
- Seed data should be realistic enough for later phases to build on.
