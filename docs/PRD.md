# Lekturnik — Product Requirements Document

## Vision

Lekturnik is the first AI-native study companion purpose-built for Polish mandatory school literature (lektury). It replaces fragmented, static study tools with a single intelligent platform that verifies whether students actually read the book, helps them understand it deeply, and prepares them for high-stakes exams.

## Target Personas

| Persona | Age / School | Behavior | Pain | WTP |
|---------|-------------|----------|------|-----|
| **Kasia** — Stressed Maturzystka | 17-19, Liceum kl. 3 | Studies Mar-May, TikTok 3h/day, has Greg | Overwhelmed by 20+ lektury, can't remember quotes | High — 9.99/mo in matura season |
| **Bartek** — Last-Minute Cramper | 17-18, Technikum kl. 4 | Doesn't read, relies on streszczenia, uses ChatGPT | Needs to pass, not excel | Medium — pays if it saves time |
| **Zuzia** — Ambitious Osmoklasistka | 14-15, SP kl. 8 | Good student, reads most lektury | Unsure what detail level expected, no practice quizzes | Low (parents will pay) |
| **Pani Magda** — Polonistka | 35-50, Teacher | Assigns lektury, grades essays | Students don't read, hard to verify | B2B angle (future) |

## Success Metrics (KPIs)

| Timeframe | Metric | Target |
|-----------|--------|--------|
| Month 1 | App Store launch | iOS + Android live |
| Month 1 | Lektury coverage | 12 core lektury |
| Month 1 | Downloads | 200-500 |
| Month 3 | MAU | 1,000 |
| Month 3 | Conversion rate | >=3% |
| Month 3 | Monthly revenue | >=300 PLN |
| Month 3 | Avg session length | >=8 min |
| Month 3 | Day-7 retention | >=20% |
| Month 6 | MAU | 3,000-5,000 |
| Month 6 | Conversion rate | >=4% |
| Month 6 | Monthly revenue | >=500 PLN |
| Month 6 | Lektury coverage | 30+ |
| Month 6 | App Store rating | >=4.5 |
| Month 12 | MAU | 10,000-20,000 |
| Month 12 | Monthly revenue | 2,000-5,000 PLN |
| Month 12 | Lektury coverage | 50+ |

---

## MVP Feature Specifications

### F1: Lektura Catalog & Browser

**User Story:** As a student, I want to quickly find the lektura I need so I can start studying without wasting time navigating.

**Information Architecture:**
- Home screen: featured/recently studied lektury + search bar + filter chips
- Filters: school level (SP 7-8 / Liceum PP / Liceum PR), literary epoch, exam relevance ("czesto na maturze" badge), completion status
- Search: full-text across titles, authors, character names
- Card displays: cover image, title, author, epoch badge, school level tag, completion ring (0-100%), matura frequency indicator

**Acceptance Criteria:**
- [ ] Catalog loads in <1s on 4G
- [ ] Search returns results as user types (debounced 300ms)
- [ ] Filters persist across sessions
- [ ] Offline: cached lektury available without connection

### F2: Lektura Detail Page

**User Story:** As a student, I want to see all study materials for a lektura in one organized place.

**Content Blocks (tab layout):**

| Block | Content | Tier |
|-------|---------|------|
| Header | Title, author, epoch, school level, cover, matura badge | Free |
| Streszczenie | Chapter-by-chapter summary (500-1500 words) | Free (first 3 ch.), Premium (full) |
| Bohaterowie | Character cards: name, role, traits, relationships, arc, quotes | Free (top 3), Premium (all) |
| Motywy i tematy | Tagged themes/motifs with manifestation explanations | Free |
| Cytaty | 5-10 curated quotes with context, motif tags, essay tips | Premium |
| Kontekst | Historical context, author bio, epoch, philosophy | Free (summary), Premium (full) |
| Problematyka | Key interpretive questions and analytical frameworks | Premium |
| Pytania maturalne | CKE questions referencing this lektura, tagged by type/year | Premium |
| Sprawdzi sie (AI Quiz) | Button launching AI quiz chat | 3 free/day, Premium unlimited |

**Acceptance Criteria:**
- [ ] All content blocks render correctly offline
- [ ] Quote cards have "copy" button
- [ ] Matura question archive shows year, type, full text
- [ ] Premium content shows blurred preview + upgrade CTA

### F3: AI "Sprawdzi Sie" Quiz Mode

**User Story:** As a student, I want to test whether I actually read and understood the book through an AI conversation.

**Flow:**
1. Student taps "Sprawdzi sie" on detail page
2. Difficulty selector: Latwy / Sredni / Trudny
3. AI generates first question
4. Student types free-text answer (1-3 sentences typical)
5. AI evaluates: Correct / Partially Correct / Incorrect + explanation
6. AI generates next question, adapting difficulty
7. After 5-8 questions (or manual end): summary scorecard

**Scoring:**
- Per question: 0 (wrong), 1 (partially — gist only), 2 (correct but shallow), 3 (correct with depth)
- Session score: percentage + 1-5 star rating
- Adaptive: 2+ correct in row -> harder; 2+ wrong -> easier
- Results saved to user progress

**Question Types by Bloom's Level:**

| Level | Example | Difficulty |
|-------|---------|-----------|
| Remember | "Co stalo sie z Wokulskim po powrocie z Bulgarii?" | Latwy |
| Understand | "Dlaczego Wokulski postanowil otworzyc sklep?" | Latwy |
| Apply | "Jak zachowanie Izabeli na balu wplynelo na Wokulskiego?" | Sredni |
| Analyze | "Porownaj motywacje Wokulskiego i Rzeckiego wobec idealow." | Sredni |
| Evaluate | "Czy uwazasz, ze Wokulski ponosi odpowiedzialnosc za swoj los?" | Trudny |
| Create | "Jaka rozprawke napisalbys na temat idealizmu w Lalce?" | Trudny |

**Anti-Cheat Design:**
- Questions about specific scene details absent from standard summaries
- Temporal sequencing: "What happens directly before/after X?"
- Character motivations requiring passage-level knowledge
- Plausible wrong answers drawn from summary-level knowledge

**Technical Architecture:**
- System prompt per lektura: ~2,000-4,000 tokens (verified plot, characters, quotes, motifs, misconceptions, calibration)
- Free tier: cycles through pre-generated questions from DB (zero API cost)
- Premium: Supabase Edge Function -> GPT-4o-mini (~$0.002-0.005/session)
- Conversation history in local state, not persisted to DB

**Acceptance Criteria:**
- [ ] Chat UI with message bubbles (AI left, student right)
- [ ] Difficulty selector at session start
- [ ] 5-8 questions per session with adaptive difficulty
- [ ] Typing indicator while AI processes
- [ ] End session -> scorecard with per-question breakdown
- [ ] Free tier: 3 sessions/day using pre-generated Qs
- [ ] Premium gate on 4th attempt

### F4: User Authentication & Progress Tracking

**User Story:** As a student, I want my progress saved so I can track what I've studied.

**Auth Methods:** Email/password, Apple Sign-In, Google Sign-In

**Age Gate:** Birth year at registration. Under 16 -> parent email -> verification link -> limited until confirmed.

**Progress Dashboard:**
- Lektury studied count, total quiz sessions, average score, current streak
- Per-lektura: completion %, best quiz score, last studied date
- Streak counter (1 quiz session/day minimum)
- Achievement badges

**Offline/Anonymous Mode:**
- App fully functional without account (local storage)
- Account linking: anonymous -> signed-in preserves progress

**Acceptance Criteria:**
- [ ] All 3 auth methods work
- [ ] Under-16 parental consent flow complete
- [ ] Anonymous mode with local storage
- [ ] Account linking preserves data
- [ ] One-tap account deletion (GDPR)

### F5: Freemium Paywall & Subscription

| Feature | Free | Premium (9.99 PLN/mo) |
|---------|------|-----------------------|
| Summaries | First 3 chapters | Full |
| Characters | Top 3 | All |
| AI Quiz | 3/day (pre-generated) | Unlimited (live AI) |
| Quotes | Preview (2/book) | Full + SRS |
| Matura questions | Locked | Full access |
| Motyw Tracker | Preview | Full |
| Rozprawka Builder | Locked | Full |
| Ads | Banner ads | No ads |
| Offline | 3 cached lektury | Full offline |
| Audio summaries | Locked | Full |

**Paywall triggers:** 4th AI quiz/day, scrolling past free limits, tapping Premium badge.

**Paywall screen:** Price, feature comparison, 7-day free trial, annual discount (79.99 PLN/year).

**Acceptance Criteria:**
- [ ] RevenueCat integrated (iOS + Android)
- [ ] Monthly + annual subscriptions configured
- [ ] 7-day free trial
- [ ] Restore purchases in profile
- [ ] Premium status checked at launch and on gated actions

---

## Post-MVP Features

### v1.1 (Weeks 5-10)

**Matura Statistics Engine** — Database of all CKE matura Polish questions (2005-2025), tagged by lektura, motif, question type, difficulty, year. Visualizations: frequency bar charts, motif heatmaps, trends.

**Motyw Tracker** — Interactive matrix: 25 motifs x all lektury. Tap cell -> mini-card explaining manifestation + quote.

**SRS Flashcard System** — SM-2 spaced repetition. Card types: quote recall, character facts, motif associations, literary terms. Auto-cards from incorrect quiz answers.

**Push Notifications** — Daily study reminder, streak warning, weekly digest, SRS reminder. FCM integration.

### v1.2 (Weeks 11-16)

**Rozprawka Builder** — AI essay outline: topic input -> thesis, 3 arguments, recommended lektury, relevant quotes. Scaffolding only, student writes content.

**Porownanie Lektur** — Side-by-side comparison: epoch, themes, characters, style, philosophy. Pre-built for popular matura pairs.

**Audio Summaries** — Platform TTS initially (zero cost), upgradeable to ElevenLabs.

**Literary Terms Glossary** — ~100 terms with definitions + examples from actual lektury.

### v2.0+

**Oral Exam Practice** — Simulates matura ustna. Record voice -> AI feedback. Requires Whisper API.

**B2B Teacher Dashboard** — Class progress, reading verification, assignment tools. Deferred until PMF validated.

---

## Key Motifs for Motyw Tracker (25)

| # | Motif (PL) | English | Key Lektury |
|---|-----------|---------|-------------|
| 1 | Milosc | Love | Lalka, Dziady, Pan Tadeusz, Zbrodnia i kara |
| 2 | Bunt | Rebellion | Dziady III, Ferdydurke, Tango, Antygona, Rok 1984 |
| 3 | Patriotyzm / Ojczyzna | Patriotism | Pan Tadeusz, Dziady III, Wesele, Przedwiosnie |
| 4 | Samotnosc | Loneliness | Lalka, Maly Ksiaze, Zbrodnia i kara, Latarnik |
| 5 | Cierpienie | Suffering | Zbrodnia i kara, Dziady III, Dzuma |
| 6 | Wladza | Power | Makbet, Rok 1984, Tango, Antygona |
| 7 | Wolnosc | Freedom | Dziady III, Rok 1984, Dzuma, Ferdydurke, Antygona |
| 8 | Przemiana / Dojrzewanie | Transformation | Ferdydurke, Zbrodnia i kara, Lalka |
| 9 | Vanitas / Przemijanie | Transience | Makbet, Lalka |
| 10 | Natura | Nature | Pan Tadeusz, Sonety krymskie |
| 11 | Miasto | The City | Lalka, Zbrodnia i kara, Przedwiosnie |
| 12 | Rodzina | Family | Zemsta, Tango, Pan Tadeusz |
| 13 | Bog / Wiara | God / Faith | Dziady III, Dzuma, Zbrodnia i kara, Antygona |
| 14 | Sztuka | Art | Wesele, Lalka, Ferdydurke |
| 15 | Pieniadz / Materializm | Money | Lalka, Skapiec, Zemsta |
| 16 | Honor | Honor | Pan Tadeusz, Antygona |
| 17 | Zemsta | Revenge | Zemsta, Makbet, Antygona |
| 18 | Wina i kara | Guilt & Punishment | Zbrodnia i kara, Makbet, Dziady II |
| 19 | Utopia / Dystopia | Utopia/Dystopia | Rok 1984, Przedwiosnie, Dzuma |
| 20 | Tesknota | Longing | Pan Tadeusz, Latarnik |
| 21 | Obowiazek | Duty | Antygona, Wesele |
| 22 | Mlodosc | Youth | Ferdydurke, Tango, Przedwiosnie |
| 23 | Smierc | Death | Makbet, Dziady II, Dzuma |
| 24 | Theatrum mundi | World as Theater | Makbet, Wesele, Tango |
| 25 | Homo viator | Man as Traveler | Odyseja, Maly Ksiaze, Pan Tadeusz |
