# Lekturnik — Development Tickets

All tickets use effort estimates in hours for a solo developer. Priority: P0 = launch blocker, P1 = should have for launch, P2 = nice to have.

---

## Phase 1: MVP (~168 hours, target 4-5 weeks)

### LEKT-001: Project Scaffold & Navigation
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 8 hours |
| Phase | 0 (Foundation) |
| Dependencies | None |

**Scope:**
- Flutter project with folder structure: `lib/app`, `lib/features/*`, `lib/models`, `lib/services`, `lib/providers`, `lib/shared`
- Bottom tab navigation: Home (catalog), Search, Progress, Profile
- GoRouter for deep linking and named routes
- Riverpod state management setup
- Theme system: colors, typography, spacing tokens
- Dark mode support scaffolded

---

### LEKT-002: Supabase Backend Setup
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 6 hours |
| Phase | 0 (Foundation) |
| Dependencies | None |

**Scope:**
- Supabase project (EU region: Frankfurt)
- Full database schema migrated (all tables per TECHNICAL_ARCHITECTURE.md)
- Row Level Security policies
- Auth configured: email/password, Apple Sign-In, Google Sign-In
- Edge Function deployed: `/api/ai-quiz`
- Seed data: 1 test lektura

---

### LEKT-003: Lektura Data Model & Content Pipeline
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 12 hours |
| Phase | 1A (Content Pipeline) |
| Dependencies | LEKT-002 |

**Scope:**
- JSON schema for lektura content import (`content/schema/lektura_schema.json`)
- Import script: JSON -> Supabase upsert
- AI content generation prompts (summary, characters, motifs, quotes, quiz Qs)
- Validation script: missing fields, empty strings, broken references
- First 3 lektury generated and imported: Lalka, Dziady III, Pan Tadeusz

---

### LEKT-004: Lektura Catalog Screen
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 10 hours |
| Phase | 1C (Catalog UI) |
| Dependencies | LEKT-001, LEKT-003 |

**Scope:**
- Grid/list view of lektura cards (cover, title, author, epoch badge, completion ring)
- Search bar with real-time filtering (debounced 300ms)
- Filter chips: school level, epoch, exam relevance
- Sort: alphabetical, recently studied, matura frequency
- Shimmer loading, empty state, pull-to-refresh

---

### LEKT-005: Lektura Detail Screen
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 16 hours |
| Phase | 1C (Catalog UI) |
| Dependencies | LEKT-004 |

**Scope:**
- Hero section: cover, title, author, epoch, school level, matura badge
- Tabbed content: Streszczenie | Bohaterowie | Motywy | Cytaty | Kontekst | Matura
- Free/Premium gating per section with blurred preview + CTA
- Floating "Sprawdzi sie" button
- Offline rendering of cached content

---

### LEKT-006: AI Quiz Chat Interface
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 16 hours |
| Phase | 2A (AI Quiz) |
| Dependencies | LEKT-002, LEKT-003 |

**Scope:**
- Chat UI: message bubbles, typing indicator
- Difficulty selector: Latwy / Sredni / Trudny
- 5-8 questions per session with adaptive difficulty
- Free-text answer input
- AI evaluation display (score, explanation)
- End session -> scorecard summary
- Free tier: 3/day from pre-generated Qs, upgrade prompt on 4th

---

### LEKT-007: AI Backend Integration (Edge Function)
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 8 hours |
| Phase | 2A (AI Quiz) |
| Dependencies | LEKT-002 |

**Scope:**
- POST `/ai-quiz`: accepts lektura_id, difficulty, conversation_history
- Loads system prompt from DB
- Calls GPT-4o-mini with structured JSON response
- Rate limiting: 20 calls/user/hour
- Error handling: timeout (15s), API errors
- Request/user logging for cost monitoring

---

### LEKT-008: User Authentication
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 8 hours |
| Phase | 1B (Auth) |
| Dependencies | LEKT-001, LEKT-002 |

**Scope:**
- Sign up/in: email, Apple, Google
- Age gate: birth year, under-16 triggers parent email flow
- Profile screen: name, school level, account management, delete
- Anonymous mode: full app without account (local storage)
- Account linking: anonymous -> signed-in preserves progress

---

### LEKT-009: Progress Tracking & Dashboard
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 10 hours |
| Phase | 2C (Progress) |
| Dependencies | LEKT-006, LEKT-008 |

**Scope:**
- Dashboard: lektury studied, quiz sessions, average score, streak
- Per-lektura progress cards
- Streak counter (1 quiz/day minimum) with flame icon
- Streak freeze: 1x/week (Premium)
- Weekly bar chart
- Achievement badges

---

### LEKT-010: Paywall & Subscription
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 12 hours |
| Phase | 2B (Monetization) |
| Dependencies | LEKT-001 |

**Scope:**
- RevenueCat SDK (iOS + Android)
- Products: monthly 9.99 PLN, annual 79.99 PLN
- 7-day free trial
- Paywall screen: feature comparison, pricing, trial CTA
- Triggers: 4th quiz/day, locked content, Premium badge tap
- Restore purchases, receipt validation via webhook

---

### LEKT-011: Analytics Setup
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 4 hours |
| Phase | 0 (Foundation) |
| Dependencies | LEKT-001 |

**Scope:**
- PostHog/Mixpanel SDK
- Events: app_open, lektura_viewed, quiz_started, quiz_completed, paywall_shown, subscription_started
- User properties: school_level, premium_status
- Funnel: catalog -> detail -> quiz -> paywall -> subscribe
- Retention cohorts

---

### LEKT-012: App Store Submission Prep
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 8 hours |
| Phase | 5 (Launch) |
| Dependencies | All P0 |

**Scope:**
- App icons (all sizes)
- Screenshots (iPhone 6.7", 5.5", Android)
- Descriptions (PL + EN), keyword-rich
- Privacy policy URL live
- Age rating, privacy labels, data safety form
- TestFlight + Google Play internal testing

---

### LEKT-013: Content — First 12 Lektury
| Field | Value |
|-------|-------|
| Priority | P0 |
| Effort | 60 hours (across Phase 1) |
| Phase | 3 (Content) |
| Dependencies | LEKT-003 |

**Scope:** Per lektura (12 titles): full summary, 5-10 character cards, motif tags + explanations, 5-10 curated quotes, context, 50-100 quiz questions, system prompt for AI mode.

**Titles:** Lalka, Dziady III, Wesele, Pan Tadeusz, Zbrodnia i kara, Dzuma, Rok 1984, Ferdydurke, Tango, Przedwiosnie, Antygona, Makbet

---

## Phase 2: Growth Features (~92 hours, weeks 5-10)

### LEKT-014: Matura Statistics Engine
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 40 hours (30h data + 10h UI) |
| Phase | 4A (Matura Stats) |
| Dependencies | LEKT-002, LEKT-005 |

**Scope:** CKE papers (2005-2025), manual tagging ~1,500 questions, frequency badges, trend charts, motif heatmap.

---

### LEKT-015: Motyw Tracker
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 16 hours |
| Phase | 4B (Motyw Tracker) |
| Dependencies | LEKT-003 |

**Scope:** Interactive 25-motif x N-lektura matrix, tap-cell detail cards, filter by level/epoch.

---

### LEKT-016: SRS Flashcard System
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 16 hours |
| Phase | 4C (SRS) |
| Dependencies | LEKT-006, LEKT-009 |

**Scope:** SM-2 algorithm, card types (quote, character, motif, term), auto-generation from wrong answers, daily review screen, swipe UI.

---

### LEKT-017: Push Notification System
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 6 hours |
| Phase | 4C (SRS) |
| Dependencies | LEKT-008 |

**Scope:** FCM integration, notification types (study reminder, streak warning, digest, SRS), user preferences.

---

### LEKT-018: Onboarding Flow Optimization
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 8 hours |
| Phase | 5 (Launch) |
| Dependencies | LEKT-008, LEKT-004 |

**Scope:** 3-screen onboarding, school level + lektura picker, skip option, A/B test readiness.

---

### LEKT-019: A/B Testing Infrastructure
| Field | Value |
|-------|-------|
| Priority | P2 |
| Effort | 6 hours |
| Phase | 5 (Launch) |
| Dependencies | LEKT-011 |

**Scope:** Feature flag system, experiments for paywall/onboarding/free limits.

---

## Phase 3: Expansion (~126 hours, weeks 11-16)

### LEKT-020: Rozprawka Builder
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 12 hours |
| Phase | Post-MVP |
| Dependencies | LEKT-007 |

**Scope:** Essay topic input, AI generates thesis + 3 arguments + lektury + quotes. Premium only.

---

### LEKT-021: Audio Summaries
| Field | Value |
|-------|-------|
| Priority | P2 |
| Effort | 8 hours |
| Phase | Post-MVP |
| Dependencies | LEKT-005 |

**Scope:** Platform TTS, play/pause/skip, background playback, Premium offline download.

---

### LEKT-022: Porownanie Lektur
| Field | Value |
|-------|-------|
| Priority | P2 |
| Effort | 10 hours |
| Phase | Post-MVP |
| Dependencies | LEKT-005, LEKT-015 |

**Scope:** Side-by-side comparison, 10 pre-built pairs, AI-generated for any pair (Premium).

---

### LEKT-023: Referral System
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 8 hours |
| Phase | Post-MVP |
| Dependencies | LEKT-008, LEKT-010 |

**Scope:** Referral codes, share via messaging apps, 7-day Premium reward, deep linking.

---

### LEKT-024: Content Expansion (30+ Lektury)
| Field | Value |
|-------|-------|
| Priority | P1 |
| Effort | 80 hours (content, not code) |
| Phase | Post-MVP |
| Dependencies | LEKT-003 |

---

### LEKT-025: Literary Terms Glossary
| Field | Value |
|-------|-------|
| Priority | P2 |
| Effort | 8 hours |
| Phase | Post-MVP |
| Dependencies | LEKT-001 |

**Scope:** ~100 terms with definitions + examples from actual lektury, searchable, linked from detail pages.

---

## Effort Summary

| Phase | Tickets | Hours | Calendar |
|-------|---------|-------|----------|
| MVP | LEKT-001 to LEKT-013 | ~168h | 4-5 weeks |
| Growth | LEKT-014 to LEKT-019 | ~92h | 3-4 weeks |
| Expansion | LEKT-020 to LEKT-025 | ~126h | 4-5 weeks |
| **Total** | **25 tickets** | **~386h** | **~12-14 weeks** |
