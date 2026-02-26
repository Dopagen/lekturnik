# Phase 1C: Catalog & Browse UI

**Effort:** ~26 hours | **Tickets:** LEKT-004, LEKT-005 | **Dependencies:** Phase 0 (Phase 1A helpful but not blocking)

## Goal

Build the two most important screens: the lektura catalog (browse/search) and the lektura detail page (study hub). These are the primary navigation surfaces of the app.

## Deliverables

### 1. Lektura Catalog Screen (LEKT-004, ~10h)

- [ ] Grid view of lektura cards (2 columns on phone, 3+ on tablet)
- [ ] Card design: cover image placeholder, title, author, epoch badge (color-coded), school level tag, completion ring (0-100%), matura frequency indicator (if high)
- [ ] Search bar at top with real-time filtering (debounced 300ms)
- [ ] Search across: titles, authors, character names
- [ ] Filter chips row (horizontally scrollable):
  - School level: SP 7-8 / Liceum PP / Liceum PR
  - Epoch: Antyk, Sredniowiecze, Renesans, Barok, Oswiecenie, Romantyzm, Pozytywizm, Mloda Polska, Miedzywojennie, Wspolczesnosc
  - Exam relevance: "Czesto na maturze"
  - Completion: Nieukonczone / Ukonczone
- [ ] Sort options (dropdown or bottom sheet): Alfabetycznie, Ostatnio uczone, Czestotliwosc na maturze
- [ ] Filters persist across sessions (SharedPreferences)
- [ ] Shimmer loading state while data loads
- [ ] Empty state for no search results ("Nie znaleziono lektury. Sprobuj inne wyszukiwanie.")
- [ ] Pull-to-refresh
- [ ] Riverpod providers for: lektura list, search query, active filters

### 2. Lektura Detail Screen (LEKT-005, ~16h)

- [ ] Hero section: cover image (or placeholder), title, author, epoch badge, school level tags, matura frequency badge, completion ring
- [ ] Tab bar: Streszczenie | Bohaterowie | Motywy | Cytaty | Kontekst | Matura
- [ ] **Streszczenie tab:**
  - Chapter-by-chapter expandable sections (ExpansionTile or custom)
  - Chapter title + summary text
  - Free users: first 3 chapters visible, rest show blurred preview + Premium CTA
  - Smooth expand/collapse animations
- [ ] **Bohaterowie tab:**
  - Character cards in a list
  - Each card: name, role badge (glowny/drugoplanowy), one-liner (italic), traits as chips
  - Tap card -> expanded view with full description, arc, key quotes
  - Free: top 3 characters by display_order, rest Premium-locked
- [ ] **Motywy tab:**
  - Motif chips/tags (using motif display_name)
  - Tap chip -> bottom sheet or card showing: motif name, how it manifests in this work, relevant quote
  - Free (all motifs visible for this lektura)
- [ ] **Cytaty tab:**
  - Quote cards: quote text (stylized), attribution, chapter reference, motif tags, essay usage tip
  - "Copy" button on each quote (copies to clipboard with attribution)
  - Free: 2 quotes visible, rest Premium-locked
- [ ] **Kontekst tab:**
  - Context summary (free, ~200 words)
  - Full context (Premium): historical background, author bio, epoch, philosophy
  - Problematyka section (Premium): interpretive questions
- [ ] **Matura tab:**
  - List of CKE questions referencing this lektura
  - Each shows: year, level (PP/PR), question type badge, question text
  - Premium-locked entirely
- [ ] **Floating Action Button:** "Sprawdzi sie" (AI Quiz) — always visible, positioned bottom-right
  - Tap -> navigates to quiz screen (or placeholder for now)
  - Badge showing best score if previously attempted

### 3. Offline Caching (~2h)

- [ ] Recently viewed lektury cached locally (drift/SQLite)
- [ ] Free tier: 3 most recent lektury cached
- [ ] Cache includes: lektura record + chapters + characters + motifs + quotes
- [ ] Offline indicator: show cached content with "Tryb offline" banner
- [ ] Background sync: update cache when connectivity returns

### 4. Premium Content Gating (~2h)

- [ ] Reusable `PremiumGate` widget: shows blurred preview + lock icon + "Odblokuj Premium" button
- [ ] Consistent behavior across all gated sections
- [ ] Tapping gate -> navigates to paywall screen (or placeholder)
- [ ] Premium users: all content visible, no gates

## Acceptance Criteria

- [ ] Catalog loads in <1s with test data
- [ ] Search filters results in real-time
- [ ] All filter combinations work correctly
- [ ] Detail page renders all 6 tabs with correct free/premium gating
- [ ] Offline mode shows cached content
- [ ] "Sprawdzi sie" button navigates correctly
- [ ] No layout overflow on any screen size (test on small phone + tablet)

## Notes for Claude Session

- These are the screens users will spend 80% of their time on. Polish the UX.
- Use consistent epoch color coding throughout (define in theme).
- The Premium gate should feel inviting, not frustrating. Blurred preview lets users see what they're missing.
- Test with realistic amounts of content (Lalka has ~30 chapters, 15+ characters).
- Character one-liners should be displayed prominently — they're a hook ("Wokulski: pierwszy polski simp").
