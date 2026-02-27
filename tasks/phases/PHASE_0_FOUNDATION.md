# Phase 0: Foundation

**Effort:** ~18 hours | **Tickets:** LEKT-001, LEKT-002, LEKT-011 | **Dependencies:** None (must be first)

## Goal

Set up the Flutter project (**iOS + Android + Web**), Supabase backend, CI/CD pipeline, and analytics foundation. The web build is a first-class target — it launches before mobile apps to capture traffic immediately.

## Deliverables

### 1. Flutter Project Scaffold (LEKT-001, ~10h)

- [ ] Initialize Flutter project (3.19+) with proper package name
- [ ] **Enable web platform:** `flutter create --platforms=web,ios,android .` (or add web to existing)
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
  - `drift` + `sqlite3_flutter_libs` (offline storage — mobile only)
  - `purchases_flutter` (RevenueCat — mobile only, conditionally imported)
  - `firebase_messaging`, `firebase_core` (mobile only)
  - `sentry_flutter`
  - `shared_preferences` (cross-platform key-value storage)
- [ ] **Platform abstraction layer:**
  - Create `lib/services/platform_service.dart` with `kIsWeb` checks
  - Abstract storage: SQLite via drift (mobile) vs Supabase queries + SharedPreferences (web)
  - Abstract payments: RevenueCat (mobile) vs disabled (web)
  - Abstract push: FCM (mobile) vs disabled (web)
- [ ] **Web-specific setup:**
  - Configure `web/index.html`: title "Lekturnik — Lektury AI", meta tags, theme color, favicon
  - Add PWA manifest (`web/manifest.json`): app name "Lekturnik", icons, `display: standalone`, `theme_color`
  - Use HTML renderer for web builds (better for text-heavy content, smaller than CanvasKit)
  - Test: `flutter run -d chrome` works with tabs and navigation
- [ ] Create placeholder screens for each feature area
- [ ] Ensure `flutter analyze` passes with zero warnings
- [ ] Ensure `flutter test` runs (even if no tests yet)
- [ ] Verify build works on all 3 targets: `flutter build web`, `flutter build apk`, `flutter build ios`

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
- [ ] **Configure OAuth redirect URLs for web** (Supabase Auth supports web redirects natively)
- [ ] Create Edge Function skeleton: `supabase/functions/ai-quiz/index.ts`
- [ ] Insert seed data: at least 1 test lektura with all related records
- [ ] Verify Supabase client connects from Flutter app (test on both Chrome and mobile)

### 3. Analytics Foundation (LEKT-011 partial, ~2h — optional, can defer)

- [ ] Integrate PostHog or Mixpanel Flutter SDK
- [ ] Create analytics service wrapper (`lib/services/analytics_service.dart`)
- [ ] Define core events: `app_open`, `lektura_viewed`, `quiz_started`, `quiz_completed`, `paywall_shown`
- [ ] Add `platform` property to all events (`web`, `ios`, `android`) for segmentation
- [ ] Verify events fire in debug mode (both Chrome and mobile)

### 4. CI/CD Setup

- [ ] GitHub Actions workflow: lint + test on PR
- [ ] **GitHub Actions: web build + deploy** (`flutter build web --web-renderer html` -> deploy to Firebase Hosting)
- [ ] Fastlane setup for iOS + Android (basic lane definitions)
- [ ] `.gitignore` properly configured (no API keys, no build artifacts, include `build/web/`)

## Acceptance Criteria

- [ ] `flutter run` launches app with bottom tabs and navigation (mobile)
- [ ] `flutter run -d chrome` launches web version in browser with same navigation
- [ ] `flutter build web --web-renderer html` builds successfully
- [ ] Supabase tables exist and can be queried from Flutter (web + mobile)
- [ ] Edge Function deploys and responds to test request
- [ ] `flutter analyze` clean
- [ ] CI runs on push (includes web build step)
- [ ] Platform checks work: `kIsWeb` correctly gates mobile-only features

## Key Decisions for This Phase

1. **Package name:** `pl.lekturnik.app` (or similar)
2. **Minimum Flutter SDK:** 3.19
3. **Minimum Android API:** 21 (Android 5.0)
4. **Minimum iOS:** 15.0
5. **Supabase region:** eu-central-1 (Frankfurt)
6. **Web renderer:** HTML (not CanvasKit) — smaller download, better for text-heavy content
7. **Web hosting:** Firebase Hosting (free tier: 10 GB storage, 360 MB/day transfer, custom domain)
8. **Web domain:** lekturnik.pl (PWA app served from root)

## Notes for Claude Session

- This phase creates the foundation everything else builds on. Be thorough.
- **Web is a first-class target.** Every screen must render in Chrome, not just on mobile simulators.
- Don't over-engineer the theme — just define tokens that can evolve.
- Placeholder screens should have screen name displayed so navigation is testable.
- Seed data should be realistic enough for later phases to build on.
- For the platform abstraction, keep it simple: a single service with `if (kIsWeb)` checks. Don't build elaborate abstractions — just isolate the 3 divergent areas (storage, payments, push).
- Test the web build early and often. Flutter web can have subtle differences (fonts, scrolling, touch vs mouse). Catch them now.
- The PWA manifest enables "Add to Home Screen" on mobile browsers — this is a free install path that bypasses app stores.
