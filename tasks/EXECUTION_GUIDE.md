# Lekturnik — Execution Guide for Claude Code Web Sessions

## How to Run Parallel Sessions on claude.ai

1. Go to **claude.ai** and open Claude Code
2. Open your project (Dopagen/lekturnik repo)
3. Each "session" is a separate Claude Code conversation
4. You can run **up to 5 sessions simultaneously** in separate browser tabs
5. Each session picks up the SessionStart hook automatically — Flutter SDK + Supabase CLI get installed

### Important Rules

- **Phase 0 goes first.** Everything depends on it. Don't start other sessions until Phase 0 is merged.
- **Pull before starting.** Every session prompt below includes `git pull` — this ensures it picks up work from completed phases.
- **One branch per session.** Each session works on its own feature branch and pushes when done.
- **Copy-paste the prompts below.** They're self-contained. Each tells Claude exactly what to read, build, and verify.

---

## Revised MVP Scope (Expert Review Applied)

Based on the expert review in `docs/EXPERT_REVIEW.md`, the MVP is cut to ~90 hours across 6 sessions:

| # | Session | Hours | Can Start After |
|---|---------|-------|-----------------|
| 1 | Phase 0: Foundation | 8-10h | Immediately |
| 2 | Phase 1A: Content Pipeline | 6h | Phase 0 |
| 3 | Phase 1C: Catalog + Detail UI | 14h | Phase 0 |
| 4 | Phase 2A+2B: AI Quiz + Monetization | 20h | Phase 0 + 1A |
| 5 | Phase 3: Content (6 lektury) | 30h | Phase 1A |
| 6 | Phase 5: Web Deploy + Polish | 4h | All above |

### Parallel Execution Timeline

```
DAY 1-2:  [Session 1: Phase 0 Foundation] ██████████
                                                    |
DAY 2-3:  [Session 2: Phase 1A Pipeline] ██████     |
          [Session 3: Phase 1C Catalog]  █████████████████
                                              |
DAY 3-5:  [Session 4: Quiz + Payments]  ██████████████████████████
          [Session 5a: Content Lalka+Dziady+PT]  ██████████████████
          [Session 5b: Content Wesele+Kamienie+MK] ████████████████
                                                               |
DAY 5-6:  [Session 6: Deploy + Polish]  ████████
```

**Sessions 2+3 run in parallel** (both only need Phase 0).
**Sessions 4+5 run in parallel** (4 needs 1A, 5 needs 1A — both can start once 1A is done).
**Session 5 can be split into 2 parallel sessions** (5a and 5b) for content generation.

---

## Session Prompts (Copy-Paste Ready)

### SESSION 1: Foundation (START HERE)

```
Read CLAUDE.md first, then read tasks/phases/PHASE_0_FOUNDATION.md and docs/TECHNICAL_ARCHITECTURE.md.

You are building the foundation for Lekturnik — an AI-powered Polish lektury study app.

IMPORTANT SCOPE CUTS (from expert review in docs/EXPERT_REVIEW.md):
- NO dark mode (light only for MVP)
- NO offline/SQLite/drift (online-only, skip drift entirely)
- NO push notifications/FCM
- NO freezed/build_runner (write models manually — faster iteration for solo dev)
- NO analytics (skip PostHog for now)
- NO Fastlane (manual store submission is fine for v1)

Your deliverables:
1. Initialize Flutter project with web+ios+android platforms
2. Set up folder structure per CLAUDE.md
3. Configure Riverpod + GoRouter with bottom tab navigation (Katalog, Szukaj, Profil — just 3 tabs)
4. Simple light theme with Polish education feel (blues/greens)
5. Add core dependencies: flutter_riverpod, go_router, supabase_flutter, shared_preferences, json_annotation (dev: json_serializable, build_runner for JSON only)
6. Platform abstraction: lib/services/platform_service.dart with kIsWeb checks for payments (disabled on web)
7. Web setup: index.html with Polish meta tags, PWA manifest, HTML renderer config
8. Supabase backend: Write ALL SQL migrations from docs/TECHNICAL_ARCHITECTURE.md. Apply the schema fixes from expert review:
   - Add index on lektury.epoch
   - Add GIN index on lektury.school_level
   - Add index on lektura_motifs.motif_id
   - Replace quotes.motif_ids UUID[] with a quote_motifs junction table
   - Add server-side quiz session counting (for rate limiting)
9. Edge Function skeleton: supabase/functions/ai-quiz/index.ts (basic structure, responds to test request)
10. Set up RLS policies (read-only public for content tables, user-owns-their-data for user tables)
11. Seed data: 1 test lektura with chapters, characters, quotes for testing
12. CI/CD: GitHub Actions workflow for lint + test + web build on PR
13. Placeholder screens for each tab so navigation is testable

Verify: flutter run -d chrome works, flutter analyze passes, flutter build web --web-renderer html succeeds, Supabase tables exist and are queryable.

Create feature branch, commit often, push when done.
```

### SESSION 2: Content Pipeline (after Phase 0 is merged)

```
git pull origin main

Read CLAUDE.md, then read tasks/phases/PHASE_1A_CONTENT_PIPELINE.md and content/schema/lektura_schema.json.

You are building the content pipeline for Lekturnik. The Flutter project and Supabase are already set up from Phase 0.

IMPORTANT CHANGES from expert review:
- We are shipping 6 lektury (not 12): Lalka, Dziady III, Pan Tadeusz, Wesele, Kamienie na szaniec, Maly Ksiaze
- Free-tier quizzes will be MULTIPLE CHOICE (not free-text) — this is critical. Each quiz_question needs: question_text, answer_options (array of 4 strings), correct_answer_index, explanation, bloom_level, difficulty, is_anti_cheat
- No freezed — write Dart model classes manually with fromJson/toJson

Your deliverables:
1. Finalize content/schema/lektura_schema.json — update quiz_questions to include multiple-choice fields (answer_options array, correct_answer_index)
2. Update the Supabase quiz_questions table if needed (add answer_options JSONB column, correct_answer_index INTEGER)
3. Write import script (Dart CLI) that reads JSON, validates, upserts into Supabase (idempotent)
4. Write content generation prompts in content/prompts/ for Claude Sonnet:
   - Summary prompt, Characters prompt, Motifs prompt, Quotes prompt
   - Quiz questions prompt (MUST generate multiple-choice with 4 options per question, 50-100 per lektura)
   - System prompt for live AI quiz
5. Write validation script: checks missing fields, broken refs, empty strings
6. Create Flutter data models (manual, no freezed): Lektura, Chapter, Character, Motif, Quote, QuizQuestion
7. Create Supabase query service: lib/services/supabase_service.dart
8. Seed content for 1 test lektura (Lalka): basic summary, 5 characters, 5 motifs, 5 quotes, 20 quiz questions (MC)
9. Insert the 25 global motifs from content/motifs_seed.json

Verify: Import script loads test data, validation passes, Flutter models deserialize correctly from Supabase.

Create feature branch, commit often, push when done.
```

### SESSION 3: Catalog + Detail UI (after Phase 0 is merged, parallel with Session 2)

```
git pull origin main

Read CLAUDE.md, then read tasks/phases/PHASE_1C_CATALOG_UI.md and docs/PRD.md.

You are building the two main UI screens for Lekturnik: catalog browse and lektura detail page. The Flutter project is set up from Phase 0.

IMPORTANT SCOPE CUTS from expert review:
- NO offline caching (skip drift/SQLite entirely — online only)
- NO dark mode
- Simplified tabs on detail page: Streszczenie | Bohaterowie | Motywy | Cytaty (skip Kontekst and Matura tabs for MVP)
- Keep premium gating but make it simple (blurred overlay + "Odblokuj Premium" button)

Your deliverables:
1. Lektura Catalog Screen:
   - Grid view (2 columns phone, 3+ tablet/web)
   - Card: title, author, epoch badge (color-coded), school level tag
   - Search bar with debounced filtering (title, author)
   - Filter chips: school level (SP 7-8, Liceum), epoch
   - Shimmer loading state, empty state, pull-to-refresh
   - Riverpod providers for lektura list + filters
   - Must work in Chrome (web) AND mobile

2. Lektura Detail Screen:
   - Hero: title, author, epoch badge, school level
   - 4 tabs: Streszczenie | Bohaterowie | Motywy | Cytaty
   - Streszczenie: expandable chapter sections, free=first 3 chapters, rest blurred+locked
   - Bohaterowie: character cards with name, role, traits, one-liner. Free=top 3, rest locked
   - Motywy: motif chips, tap for explanation bottom sheet. All free.
   - Cytaty: quote cards with text, attribution, motif tags, copy button. Free=2, rest locked
   - FAB: "Sprawdz sie" button -> navigates to quiz (placeholder OK)

3. PremiumGate widget: reusable blurred overlay + lock icon + CTA button
4. All Polish UI strings (no English leaking)
5. Responsive: works at 360px phone through 1440px desktop browser
6. Test with realistic data amounts (Lalka: ~30 chapters, 15+ characters)

Verify: flutter run -d chrome shows catalog with test data, detail page all tabs work, premium gates show correctly, no layout overflow on any screen size, flutter analyze clean.

Create feature branch, commit often, push when done.
```

### SESSION 4: AI Quiz + Monetization (after Phase 1A is merged)

```
git pull origin main

Read CLAUDE.md, then read tasks/phases/PHASE_2A_AI_QUIZ.md, tasks/phases/PHASE_2B_MONETIZATION.md, and docs/EXPERT_REVIEW.md (critical findings section).

You are building the AI quiz engine AND monetization for Lekturnik. Content pipeline and data models exist from Phase 1A.

CRITICAL SECURITY FIXES from expert review (non-negotiable):
1. Daily quiz limit MUST be server-side (track in quiz_sessions table, Edge Function checks count) — NOT client-side SharedPreferences
2. Edge Function MUST check users.premium_status before calling OpenAI API
3. Cap user answer length at 500 characters in Edge Function
4. Add anti-prompt-injection instructions to system prompt

IMPORTANT DESIGN DECISIONS:
- Free tier = MULTIPLE CHOICE quizzes from pre-generated questions in DB (zero API cost)
- Premium tier = free-text answers evaluated by GPT-4o-mini via Edge Function
- Free limit: 3 MC quiz sessions/day (server-side enforced)
- Web paywall shows "Pobierz aplikacje" (download app) CTA, NOT purchase buttons

Your deliverables:

AI QUIZ:
1. Edge Function (supabase/functions/ai-quiz/index.ts):
   - Auth: validate Supabase JWT token
   - Premium check: query users.premium_status, reject free users
   - Rate limit: max 20 API calls/user/hour
   - Load system prompt from lektura_system_prompts
   - Call GPT-4o-mini with conversation history
   - Return structured JSON (question, evaluation, score, explanation)
   - Error handling: OpenAI timeout 15s, rate limit, malformed response
   - Log token usage for cost monitoring
   - Answer length validation (max 500 chars)
   - Anti-injection in system prompt

2. Quiz Chat UI:
   - Two modes detected automatically:
     a) FREE: Multiple choice UI — question + 4 answer buttons, instant feedback (correct/wrong + explanation), pull from quiz_questions table
     b) PREMIUM: Chat-style free-text — message bubbles, typing indicator, AI evaluation with score badges
   - Session start: difficulty selector (Latwy/Sredni/Trudny)
   - Running score in app bar
   - Session end: scorecard with percentage, per-question breakdown, "Sprobuj ponownie" button
   - Save session to quiz_sessions table
   - Server-side daily limit check: on 4th free attempt, show paywall

3. Difficulty adaptation: 2+ correct -> harder, 2+ wrong -> easier

MONETIZATION:
4. RevenueCat setup (mobile only, conditionally imported):
   - Products: premium_monthly 9.99 PLN, premium_annual 79.99 PLN
   - 7-day free trial
   - subscriptionProvider (Riverpod): isPremium, on web always false

5. Paywall screen (dual mode):
   - MOBILE: feature comparison + price cards + "Rozpocznij okres probny" CTA
   - WEB: same comparison + "Pobierz aplikacje Lekturnik" + App Store/Play Store badges
   - Platform detection automatic

6. Paywall triggers: 4th quiz attempt, premium-locked content tap, max 2 paywalls per session

7. RevenueCat webhook Edge Function: updates users.premium_status on purchase/cancel/expire

8. Shareable quiz result card (from expert review — high-priority acquisition feature):
   - After quiz completion, "Udostepnij wynik" button
   - Generates image/card: "Zdobylem 85% z Lalki — a Ty?" + app branding
   - Share via system share sheet (mobile) or copy link (web)

Verify: Free MC quiz works end-to-end, premium chat quiz works with Edge Function, daily limit enforced server-side, paywall shows correctly on mobile and web, sharecard generates.

Create feature branch, commit often, push when done.
```

### SESSION 5a: Content Generation — Batch 1 (after Phase 1A is merged, parallel with Session 4)

```
git pull origin main

Read CLAUDE.md, then read tasks/phases/PHASE_3_CONTENT_GENERATION.md and content/schema/lektura_schema.json. Also read the content generation prompts in content/prompts/.

You are generating study content for 3 lektury: LALKA (Prus), DZIADY CZ. III (Mickiewicz), PAN TADEUSZ (Mickiewicz).

For EACH lektura, generate:

1. Summary (Streszczenie): chapter-by-chapter, 500-1500 words total, clear engaging Polish for teens. First 3 chapters is_free: true.

2. Characters (Bohaterowie): 5-10 per book. Each: name, role (glowny/drugoplanowy/epizodyczny), description 200-400 words, traits (3-5), arc_description, one_liner (witty, memorable — like "Wokulski: pierwszy polski simp"). Top 3 is_free: true.

3. Motif Mappings: map relevant motifs from the 25 master list. Per mapping: explanation 100-200 words. Typically 8-15 motifs per lektura.

4. Quotes (Cytaty): 5-10 per book. Exact text with attribution, chapter ref, motif tags, essay_usage_tip. First 2 is_free: true. For copyrighted works: short excerpts only under prawo cytatu.

5. Quiz Questions: 50-100 MULTIPLE CHOICE per lektura.
   - Each question: question_text, answer_options (array of 4 strings), correct_answer_index (0-3), explanation, bloom_level, difficulty, is_anti_cheat
   - Distribution: 30% latwy, 40% sredni, 30% trudny
   - Distribution: 20% remember, 20% understand, 20% apply, 20% analyze, 10% evaluate, 10% create
   - At least 15-20% anti-cheat (test details only in full text, not summaries)
   - CRITICAL: Distractors (wrong options) must be plausible but clearly wrong to someone who read the book

6. System Prompt for AI quiz: 4-8K tokens (Lalka especially needs 6-8K). Verified plot, character database, key quotes, scoring rubric, anti-hallucination instructions, anti-injection instructions.

Output each as JSON matching the schema. Save to:
- content/lektury/lalka.json
- content/lektury/dziady-iii.json
- content/lektury/pan-tadeusz.json

Run the import script and validation script for each.

ACCURACY IS EXISTENTIAL. Cross-check every fact. If unsure about a detail, omit it rather than risk inaccuracy. This is what differentiates us from ChatGPT.

Create feature branch, commit often, push when done.
```

### SESSION 5b: Content Generation — Batch 2 (parallel with 5a)

```
git pull origin main

Read CLAUDE.md, then read tasks/phases/PHASE_3_CONTENT_GENERATION.md and content/schema/lektura_schema.json. Also read the content generation prompts in content/prompts/.

You are generating study content for 3 lektury: WESELE (Wyspianski), KAMIENIE NA SZANIEC (Kaminski), MALY KSIAZE (Saint-Exupery).

For EACH lektura, generate:

1. Summary (Streszczenie): chapter/act-by-chapter, 500-1500 words total, clear engaging Polish for teens. First 3 chapters/acts is_free: true.

2. Characters (Bohaterowie): 5-10 per book. Each: name, role (glowny/drugoplanowy/epizodyczny), description 200-400 words, traits (3-5), arc_description, one_liner (witty, memorable). Top 3 is_free: true.

3. Motif Mappings: map relevant motifs from the 25 master list. Per mapping: explanation 100-200 words. Typically 8-15 motifs per lektura.

4. Quotes (Cytaty): 5-10 per book. Exact text with attribution, act/chapter ref, motif tags, essay_usage_tip. First 2 is_free: true. For copyrighted works (Kaminski, Saint-Exupery translation): short excerpts only under prawo cytatu.

5. Quiz Questions: 50-100 MULTIPLE CHOICE per lektura.
   - Each question: question_text, answer_options (array of 4 strings), correct_answer_index (0-3), explanation, bloom_level, difficulty, is_anti_cheat
   - Distribution: 30% latwy, 40% sredni, 30% trudny
   - At least 15-20% anti-cheat questions
   - Distractors must be plausible but clearly wrong to someone who read the book
   - NOTE: Kamienie na szaniec and Maly Ksiaze target klasy 7-8 (ages 13-15), so language should be slightly simpler

6. System Prompt for AI quiz: 4-6K tokens per lektura.

Output each as JSON matching the schema. Save to:
- content/lektury/wesele.json
- content/lektury/kamienie-na-szaniec.json
- content/lektury/maly-ksiaze.json

Run the import script and validation script for each.

ACCURACY IS EXISTENTIAL. Cross-check every fact. Kamienie na szaniec is based on real events — historical accuracy matters. Maly Ksiaze has specific philosophical content — don't simplify the allegories.

Create feature branch, commit often, push when done.
```

### SESSION 6: Web Deploy + Polish (after all above are merged)

```
git pull origin main

Read CLAUDE.md, then read tasks/phases/PHASE_5_POLISH_LAUNCH.md and docs/EXPERT_REVIEW.md.

You are doing the final polish and web deployment for Lekturnik. All features and content are built.

Your deliverables:

1. Web-to-App Install CTAs (5 conversion points):
   - Smart app banner in web/index.html (iOS + Android)
   - Post-quiz prompt: "Chcesz wiecej? Pobierz aplikacje!"
   - Paywall CTA: app store badges instead of purchase buttons (should already exist from Session 4)
   - Floating "Pobierz aplikacje" banner on catalog screen (web only, dismissible)
   - PWA "Add to Home Screen" prompt after 2nd visit

2. Static SEO landing pages (Flutter web has no SEO):
   - Create static HTML pages for top lektury at /lalka, /dziady, /wesele etc.
   - Each page: title, meta description, h1, brief summary, "Sprawdz sie z quizu" CTA linking to app
   - These are simple HTML files in web/ directory, served alongside Flutter app
   - Critical for Google indexing "streszczenie Lalka" searches

3. "Zglos brak lektury" (Request missing lektura):
   - When search returns no results: "Nie znaleziono. Zglos, a dodamy!" + email input
   - Store requests in Supabase (simple table: email, requested_title, created_at)

4. Final QA checklist:
   - All 6 lektury load correctly in catalog
   - Detail page tabs work for all 6
   - Free MC quiz works end-to-end
   - Paywall triggers correctly
   - Web version works in Chrome, Safari, Firefox
   - Mobile version works on iOS + Android
   - No English strings in UI
   - No console errors
   - flutter analyze clean
   - flutter test passes

5. Firebase Hosting deployment:
   - firebase.json config
   - Deploy web build
   - Verify lekturnik.pl loads (or whatever domain is configured)

6. App store preparation:
   - Screenshots (can be placeholder)
   - Polish app store descriptions
   - Privacy policy page (basic, covers RODO)

Verify: Web version loads at deployment URL, all 6 lektury accessible, quiz works, no crashes.

Create feature branch, commit often, push when done.
```

---

## Quick Reference: What Goes Where

| Session | Branch Name | Key Files Created/Modified |
|---------|-------------|---------------------------|
| 1 Foundation | feature/LEKT-001-foundation | lib/*, pubspec.yaml, supabase/migrations/*, web/* |
| 2 Pipeline | feature/LEKT-003-content-pipeline | content/schema/*, lib/models/*, lib/services/supabase_service.dart |
| 3 Catalog UI | feature/LEKT-004-005-catalog | lib/features/catalog/*, lib/features/detail/*, lib/shared/* |
| 4 Quiz+Pay | feature/LEKT-006-010-quiz-monetization | lib/features/quiz/*, lib/features/paywall/*, supabase/functions/* |
| 5a Content 1 | feature/LEKT-013-content-batch-1 | content/lektury/lalka.json, dziady-iii.json, pan-tadeusz.json |
| 5b Content 2 | feature/LEKT-013-content-batch-2 | content/lektury/wesele.json, kamienie-na-szaniec.json, maly-ksiaze.json |
| 6 Deploy | feature/LEKT-025-deploy | web/*.html, firebase.json, lib/features/catalog/* (CTA additions) |

## Merge Order

```
1. Foundation (Session 1)     -> merge to main
2. Pipeline (Session 2)       -> merge to main  (Session 3 can merge independently)
3. Catalog UI (Session 3)     -> merge to main
4. Quiz+Pay (Session 4)       -> merge to main  (Sessions 5a/5b can merge independently)
5. Content (Sessions 5a, 5b)  -> merge to main
6. Deploy (Session 6)         -> merge to main -> SHIP IT
```
