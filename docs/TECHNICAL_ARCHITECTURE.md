# Lekturnik — Technical Architecture

## Tech Stack

| Component | Technology | Justification |
|-----------|-----------|---------------|
| Frontend | Flutter (Dart) 3.19+ — **iOS + Android + Web** | Single codebase, three platforms |
| State management | Riverpod | Compile-safe, testable, well-documented |
| Routing | GoRouter | Deep linking, named routes |
| Code generation | freezed + json_serializable | Immutable models, JSON parsing |
| Local DB (mobile) | drift (sqflite) | SQLite abstraction for offline cache |
| Local storage (web) | SharedPreferences + Supabase queries | No SQLite on web; use browser storage |
| Backend | Supabase (PostgreSQL + Edge Functions) | Free tier 50K MAU, built-in auth, EU hosting |
| AI (live quiz) | GPT-4o-mini via OpenAI API | $0.15/$0.60 per MTok |
| AI (content gen) | Claude Sonnet via Anthropic API | Higher quality for batch generation |
| Payments (mobile) | RevenueCat (purchases_flutter) | Free <$2.5K MTR, handles receipt validation |
| Payments (web) | None — free tier only | Web = funnel to app stores |
| Web hosting | Firebase Hosting | Free tier, CDN, custom domain, HTTPS |
| Analytics | PostHog or Mixpanel | PostHog free tier generous |
| Push (mobile) | Firebase Cloud Messaging (FCM) | Free, cross-platform |
| Error tracking | Sentry (Flutter SDK) | Free tier sufficient |
| CI/CD | GitHub Actions + Fastlane | Automates store + web deployment |
| Storage/CDN | Supabase Storage | Included in plan |

## Web Platform Architecture

### Strategy: Web as Launch Vehicle + Install Driver

The web PWA deploys instantly to lekturnik.pl — no store review needed. It serves three roles:

1. **Instant launch** — go live while app stores review mobile builds
2. **Install driver** — every web user is a potential app install. All marketing links go to lekturnik.pl (zero friction), then convert to app installs via smart banners, post-quiz prompts, and paywall CTAs
3. **SEO surface** — Google indexes lekturnik.pl, capturing high-intent queries ("streszczenie Lalka") that convert to installs

Web-to-install conversion points are integrated at: smart banner (persistent), post-quiz prompt (after 3rd free quiz), paywall CTA (when hitting premium gate), post-session nudge (after good quiz score).

### Platform Differences

| Concern | Mobile | Web |
|---------|--------|-----|
| **Payments** | RevenueCat | Disabled — "download app" CTA |
| **Offline storage** | drift (SQLite) | Supabase cache + SharedPreferences |
| **Push notifications** | FCM native | Not supported (defer) |
| **OAuth** | Native Apple/Google Sign-In | Supabase OAuth redirect flow |
| **Install** | App Store / Play Store | PWA "Add to Home Screen" |
| **AI Quiz** | Free (pre-gen) + Premium (live API) | Free (pre-gen) only |
| **Renderer** | N/A (native) | HTML renderer (smaller, text-optimized) |
| **Bundle size** | <50 MB | Target <5 MB |

### Platform Abstraction Pattern

```dart
// lib/services/platform_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformService {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb;
  static bool get supportsPayments => !kIsWeb;
  static bool get supportsPush => !kIsWeb;
  static bool get supportsOffline => !kIsWeb;
}
```

Use conditional imports for mobile-only packages:
```dart
// lib/services/payment_service.dart
import 'payment_service_stub.dart'
    if (dart.library.io) 'payment_service_mobile.dart';
```

### Web Build & Deploy

```bash
# Build
flutter build web --release --web-renderer html

# Deploy (Firebase Hosting)
firebase deploy --only hosting

# CI/CD: GitHub Actions deploys on push to main
```

### Web Performance Targets

| Metric | Target |
|--------|--------|
| Initial load (4G) | <5s |
| Time to interactive | <3s |
| Bundle size | <5 MB |
| Lighthouse score | >80 |

## Flutter Project Structure

```
lib/
├── main.dart                          # App entry, Riverpod scope
├── app/
│   ├── app.dart                       # MaterialApp.router
│   ├── router.dart                    # GoRouter configuration
│   ├── theme.dart                     # Light + dark theme data
│   └── constants.dart                 # App-wide constants
├── features/
│   ├── catalog/
│   │   ├── screens/                   # CatalogScreen
│   │   ├── widgets/                   # LekturaCard, FilterChips, SearchBar
│   │   └── providers/                 # catalogProvider, searchProvider
│   ├── detail/
│   │   ├── screens/                   # LekturaDetailScreen
│   │   ├── widgets/                   # SummaryTab, CharactersTab, MotifsTab, etc.
│   │   └── providers/
│   ├── quiz/
│   │   ├── screens/                   # QuizChatScreen, QuizScorecard
│   │   ├── widgets/                   # ChatBubble, DifficultySelector
│   │   ├── providers/                 # quizSessionProvider
│   │   └── services/                  # quiz_service.dart (API + local Q switching)
│   ├── auth/
│   │   ├── screens/                   # LoginScreen, RegisterScreen, ProfileScreen
│   │   ├── widgets/                   # AgeGate, ParentalConsent
│   │   └── providers/                 # authProvider, userProvider
│   ├── progress/
│   │   ├── screens/                   # ProgressDashboard
│   │   ├── widgets/                   # StreakWidget, AchievementBadge, ProgressCard
│   │   └── providers/
│   ├── paywall/
│   │   ├── screens/                   # PaywallScreen
│   │   ├── widgets/                   # FeatureComparison, PricingCard
│   │   └── providers/                 # subscriptionProvider
│   ├── motifs/                        # Motyw Tracker (v1.1)
│   ├── srs/                           # SRS flashcards (v1.1)
│   ├── matura/                        # Matura Statistics (v1.1)
│   └── rozprawka/                     # Essay Builder (v1.2)
├── models/
│   ├── lektura.dart                   # Lektura, Chapter, Character
│   ├── quiz.dart                      # QuizQuestion, QuizSession, QuizScore
│   ├── user.dart                      # User, UserProgress
│   ├── motif.dart                     # Motif, LekturaMotif
│   ├── quote.dart                     # Quote
│   ├── matura_question.dart           # MaturaQuestion
│   └── srs_card.dart                  # SrsCard
├── services/
│   ├── supabase_service.dart          # Supabase client initialization
│   ├── ai_service.dart                # AI quiz API calls via Edge Function
│   ├── storage_service.dart           # Local SQLite for offline
│   ├── analytics_service.dart         # PostHog/Mixpanel wrapper
│   └── notification_service.dart      # FCM setup and scheduling
├── providers/
│   └── app_providers.dart             # Global providers (supabase, connectivity)
└── shared/
    ├── widgets/                       # SharedButton, LoadingIndicator, etc.
    ├── utils/                         # formatters, validators
    └── extensions/                    # Dart extension methods
```

## Database Schema

### Core Tables

```sql
-- Lektury (books)
CREATE TABLE lektury (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    epoch TEXT NOT NULL,              -- e.g., 'romantyzm', 'pozytywizm'
    school_level TEXT[] NOT NULL,     -- e.g., ['liceum_pp', 'liceum_pr']
    is_mandatory BOOLEAN DEFAULT true,
    reading_type TEXT NOT NULL,       -- 'full' or 'fragments'
    cover_url TEXT,
    matura_frequency_score INT,      -- 1-10 scale
    context_summary TEXT,            -- Historical/literary context (short, free)
    context_full TEXT,               -- Full context (premium)
    problematyka TEXT,               -- Key interpretive questions (premium)
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Chapters
CREATE TABLE chapters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    number INT NOT NULL,
    title TEXT,
    summary_text TEXT NOT NULL,      -- Chapter summary
    is_free BOOLEAN DEFAULT false,   -- First 3 chapters free
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Characters
CREATE TABLE characters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    role TEXT NOT NULL,              -- 'main', 'supporting', 'minor'
    description TEXT NOT NULL,
    traits TEXT[],
    arc_description TEXT,
    one_liner TEXT,                  -- "Wokulski: pierwszy polski simp"
    is_free BOOLEAN DEFAULT false,   -- Top 3 per lektura free
    display_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Motifs (global)
CREATE TABLE motifs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,       -- e.g., 'milosc', 'bunt'
    display_name TEXT NOT NULL,      -- e.g., 'Milosc'
    english_name TEXT,
    description TEXT NOT NULL,
    icon TEXT,                       -- Icon identifier
    display_order INT DEFAULT 0
);

-- Lektura-Motif junction (with explanation)
CREATE TABLE lektura_motifs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    motif_id UUID REFERENCES motifs(id) ON DELETE CASCADE,
    explanation TEXT NOT NULL,        -- How this motif manifests in this work
    relevant_quote_id UUID,          -- Optional link to a key quote
    UNIQUE(lektura_id, motif_id)
);

-- Quotes
CREATE TABLE quotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    character_id UUID REFERENCES characters(id),
    text TEXT NOT NULL,
    chapter_ref TEXT,                -- e.g., "Tom I, Rozdzial 3"
    motif_ids UUID[],               -- Array of motif IDs this quote relates to
    essay_usage_tip TEXT,            -- How to use this quote in an essay
    is_free BOOLEAN DEFAULT false,   -- 2 per book free
    display_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Quiz Questions (pre-generated)
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    expected_answer TEXT NOT NULL,    -- For AI evaluation context
    bloom_level TEXT NOT NULL,       -- 'remember', 'understand', 'apply', 'analyze', 'evaluate', 'create'
    difficulty TEXT NOT NULL,        -- 'latwy', 'sredni', 'trudny'
    tags TEXT[],
    is_anti_cheat BOOLEAN DEFAULT false,  -- True = designed to catch summary-skimmers
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Matura Questions (CKE archive)
CREATE TABLE matura_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    year INT NOT NULL,
    level TEXT NOT NULL,             -- 'pp' (podstawowy), 'pr' (rozszerzony)
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL,     -- 'rozprawka', 'interpretacja', 'porownanie', etc.
    source_url TEXT,                 -- Link to original CKE paper
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Matura Question <-> Lektura junction
CREATE TABLE matura_question_lektury (
    matura_question_id UUID REFERENCES matura_questions(id) ON DELETE CASCADE,
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    PRIMARY KEY (matura_question_id, lektura_id)
);

-- Matura Question <-> Motif junction
CREATE TABLE matura_question_motifs (
    matura_question_id UUID REFERENCES matura_questions(id) ON DELETE CASCADE,
    motif_id UUID REFERENCES motifs(id) ON DELETE CASCADE,
    PRIMARY KEY (matura_question_id, motif_id)
);

-- Users
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT,
    display_name TEXT,
    school_level TEXT,               -- 'sp_7_8', 'liceum', 'technikum'
    birth_year INT,                  -- For age-range gating only
    parent_email TEXT,               -- For under-16 consent
    parent_consent_verified BOOLEAN DEFAULT false,
    premium_status TEXT DEFAULT 'free',  -- 'free', 'trial', 'premium'
    premium_expires_at TIMESTAMPTZ,
    streak_count INT DEFAULT 0,
    streak_last_date DATE,
    streak_freezes_remaining INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- User Progress (per lektura)
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    completion_pct REAL DEFAULT 0,
    quiz_best_score REAL,
    quiz_sessions_count INT DEFAULT 0,
    last_studied_at TIMESTAMPTZ,
    content_blocks_viewed TEXT[],    -- Track which tabs user has opened
    UNIQUE(user_id, lektura_id)
);

-- Quiz Sessions
CREATE TABLE quiz_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE,
    difficulty TEXT NOT NULL,
    score REAL,                      -- Percentage
    questions_count INT,
    correct_count INT,
    started_at TIMESTAMPTZ DEFAULT now(),
    ended_at TIMESTAMPTZ
);

-- SRS Cards (v1.1)
CREATE TABLE srs_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    card_type TEXT NOT NULL,         -- 'quote', 'character_fact', 'motif_association', 'literary_term'
    front_text TEXT NOT NULL,
    back_text TEXT NOT NULL,
    content_ref_id UUID,            -- Reference to source (quote, question, etc.)
    interval_days REAL DEFAULT 1,
    ease_factor REAL DEFAULT 2.5,
    repetitions INT DEFAULT 0,
    next_review_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- AI Quiz System Prompts (per lektura)
CREATE TABLE lektura_system_prompts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lektura_id UUID REFERENCES lektury(id) ON DELETE CASCADE UNIQUE,
    system_prompt TEXT NOT NULL,     -- Full system prompt for AI quiz
    version INT DEFAULT 1,
    updated_at TIMESTAMPTZ DEFAULT now()
);
```

### Row Level Security (RLS)

```sql
-- Users can only read/write their own data
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users read own data" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users update own data" ON users FOR UPDATE USING (auth.uid() = id);

-- Public read access to content tables
ALTER TABLE lektury ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read lektury" ON lektury FOR SELECT TO authenticated, anon USING (true);
-- Same pattern for: chapters, characters, motifs, lektura_motifs, quotes, quiz_questions, matura_questions

-- User progress: own data only
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own progress" ON user_progress FOR ALL USING (auth.uid() = user_id);
-- Same pattern for: quiz_sessions, srs_cards
```

### Indexes

```sql
CREATE INDEX idx_chapters_lektura ON chapters(lektura_id, number);
CREATE INDEX idx_characters_lektura ON characters(lektura_id, display_order);
CREATE INDEX idx_quotes_lektura ON quotes(lektura_id, display_order);
CREATE INDEX idx_quiz_questions_lektura_difficulty ON quiz_questions(lektura_id, difficulty);
CREATE INDEX idx_matura_questions_year ON matura_questions(year, level);
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_quiz_sessions_user ON quiz_sessions(user_id, lektura_id);
CREATE INDEX idx_srs_cards_review ON srs_cards(user_id, next_review_at);
```

## AI Integration Architecture

### Cost-Minimization Strategy

The architecture is designed to minimize live API calls:

1. **Content Generation (one-time):** Claude Sonnet generates study materials per lektura. Stored as structured data in Supabase. Cost: ~$5-15 per lektura.

2. **Quiz Pre-Generation:** 50-100 questions per lektura stored in DB. Free-tier users get only these.

3. **Live AI Chat (Premium only):** GPT-4o-mini via Edge Function. Average session cost: ~$0.002-0.005.

4. **Answer Evaluation:** AI evaluates free-text answers against expected knowledge. Returns score + explanation + follow-up.

### Edge Function: AI Quiz Proxy

```
POST /functions/v1/ai-quiz

Request:
{
    "lektura_id": "uuid",
    "difficulty": "latwy|sredni|trudny",
    "conversation_history": [
        { "role": "assistant", "content": "..." },
        { "role": "user", "content": "..." }
    ]
}

Response:
{
    "question": "Next question text",
    "evaluation": "correct|partially_correct|incorrect",
    "score": 0-3,
    "explanation": "Why the answer was right/wrong",
    "session_complete": false,
    "questions_remaining": 4
}
```

**Security:**
- API keys stored in Supabase Vault, never in client
- Rate limiting: max 20 AI calls per user per hour
- Request validation: lektura_id must exist, conversation_history max 20 messages
- Timeout: 15s per API call

### System Prompt Template

Each lektura gets a ~2,000-4,000 token system prompt containing:
- Verified plot summary (chapter-level detail)
- Complete character database
- Key quotes with page/chapter references
- Motif mappings
- Common student misconceptions
- Difficulty calibration instructions
- Scoring rubric
- Anti-hallucination guardrails ("Only state facts present in the source text")

## Offline Architecture

### Mobile
- **Free tier:** 3 most recently viewed lektury cached (SQLite via drift)
- **Premium:** full library cached, background sync on WiFi
- **AI quiz:** pre-generated questions work offline; live AI requires connection
- **Progress:** local-first, synced to Supabase on connectivity
- **Conflict resolution:** last-write-wins with timestamps

### Web
- **No true offline mode.** Web version requires internet connection.
- **Browser caching:** Flutter service worker caches app shell and assets
- **Data caching:** Supabase client caches recent queries; SharedPreferences stores user preferences and quiz daily count
- **Graceful degradation:** Show "Brak polaczenia" message if network unavailable

## Performance Requirements

| Metric | Mobile Target | Web Target |
|--------|--------------|------------|
| Cold start | <3s (Samsung A54 class) | <5s initial load (4G) |
| Catalog load | <1s | <1s |
| AI quiz response | <3s | <3s |
| Offline content | <500ms | N/A (requires connection) |
| App/bundle size | <50MB | <5MB |
| Lighthouse score | N/A | >80 |

## Data Privacy Architecture

- Minimal data: email, display name (optional), school level, birth year range
- Under-16: parent email + verification flow
- All personal data in EU (Supabase Frankfurt region)
- Data deletion: one-tap in settings
- AI conversations: session summaries stored, raw text deleted after 24h
- Privacy policy: Polish + English, plain language
