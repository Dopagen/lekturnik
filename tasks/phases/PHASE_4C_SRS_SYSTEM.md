# Phase 4C: SRS System

**Effort:** ~22 hours | **Tickets:** LEKT-016, LEKT-017 | **Dependencies:** Phase 2C (Progress)

## Goal

Build a spaced repetition flashcard system for memorizing quotes, character facts, motif associations, and literary terms. Plus push notifications for study reminders.

## Deliverables

### 1. SM-2 Algorithm Implementation (~3h)

- [ ] Implement SM-2 (SuperMemo 2) algorithm:
  - Input: quality rating (0-5, mapped from user's "know" / "hard" / "don't know")
  - Output: next_review_at, updated interval_days, updated ease_factor
  - Initial interval: 1 day
  - Quality mapping: "Don't know" = 0, "Hard" = 3, "Know" = 5
  - Ease factor: min 1.3, default 2.5
- [ ] Service class: `SrsService` with methods:
  - `getCardsForReview(userId)` -> cards where next_review_at <= now
  - `reviewCard(cardId, quality)` -> updates card with new schedule
  - `createCard(userId, type, front, back, refId)` -> creates new card
  - `getCardCount(userId)` -> total cards, due today count

### 2. Card Types & Generation (~4h)

- [ ] Card types:
  - **Quote recall:** Front: motif/context hint, Back: full quote + attribution
  - **Character fact:** Front: "Kto w Lalce jest..." + trait/action, Back: character name + explanation
  - **Motif association:** Front: motif name, Back: which lektury + brief manifestation
  - **Literary term:** Front: term name, Back: definition + example from lektura
- [ ] Auto-generation:
  - From incorrect quiz answers: create card for the missed knowledge
  - From viewed quotes: offer "Dodaj do powtórek" button on quote cards
  - Pre-built decks per lektura (generated during content phase)
- [ ] Deck management:
  - Per-lektura decks (auto-populated from content)
  - Custom cards (user can create their own, text input)
  - "All cards" combined view

### 3. Review UI (~6h)

- [ ] Daily review screen:
  - Card count badge: "12 kart do powtorki"
  - Estimated time: "~5 minut"
  - Card display: front text, tap to reveal back
  - Rating buttons: "Nie wiem" (red) / "Trudne" (yellow) / "Wiem" (green)
  - Swipe gestures: left = don't know, right = know, up = hard
  - Progress bar: X of Y cards reviewed
  - Session summary: cards reviewed, accuracy percentage
- [ ] Card flip animation (3D flip effect)
- [ ] Streak integration: completing daily review counts toward streak

### 4. Push Notifications (LEKT-017, ~6h)

- [ ] Firebase Cloud Messaging setup:
  - FCM token registration on app launch
  - Token stored in user profile (Supabase)
- [ ] Notification types:
  - **Daily study reminder:** "Czas na nauke! Masz 8 kart do powtorki." (configurable time, default 18:00)
  - **Streak warning:** "Nie strac swojej serii 7 dni! Zrob chociaz jeden quiz." (sent at 20:00 if no activity)
  - **Weekly digest:** "Ten tydzien: 3 lektury, 82% srednia. Tak trzymaj!" (sent Sunday evening)
  - **SRS reminder:** "Masz zaległe karty do powtorki!" (if cards overdue by 2+ days)
- [ ] User notification preferences (settings screen):
  - Toggle each notification type on/off
  - Set daily reminder time
  - Stored in user profile
- [ ] Local notifications for time-based reminders (flutter_local_notifications)
- [ ] Server-push for digests (Supabase scheduled function)

### 5. SRS Data & Sync (~3h)

- [ ] `srs_cards` table operations via Supabase
- [ ] Offline support: cards cached locally, review results sync when online
- [ ] Conflict resolution: if reviewed offline and online, keep the most recent review
- [ ] Card creation: immediate sync to server, available on other devices

## Acceptance Criteria

- [ ] SM-2 algorithm correctly schedules cards (test with known inputs)
- [ ] Cards appear for review at correct intervals
- [ ] All 4 card types display correctly
- [ ] Auto-generation from quiz errors works
- [ ] Review session UX is smooth (flip, swipe, rate)
- [ ] Push notifications delivered at correct times
- [ ] Notification preferences respected
- [ ] Offline review works and syncs
- [ ] SRS activity counts toward daily streak

## Notes for Claude Session

- SRS is proven: 6-13% score improvement on objective tests. Get the algorithm right.
- The review UI should feel fast. No delays between cards.
- Card flip animation is satisfying — worth the implementation time.
- Push notifications must be respectful. Too many = uninstall. Let users control everything.
- Test SM-2 with edge cases: card rated 0 repeatedly, card rated 5 repeatedly, card with very low ease factor.
