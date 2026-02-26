# Phase 2C: Progress & Gamification

**Effort:** ~10 hours | **Tickets:** LEKT-009 | **Dependencies:** Phase 1B (Auth), Phase 2A (Quiz)

## Goal

Build the progress dashboard, streak system, and achievement badges. This drives retention — streaks are 3.6x engagement multipliers (Duolingo data).

## Deliverables

### 1. Progress Dashboard Screen (~4h)

- [ ] Overall stats section:
  - Lektury studied (count)
  - Total quiz sessions completed
  - Average quiz score (percentage)
  - Current streak (with flame icon)
- [ ] Per-lektura progress cards (scrollable list):
  - Lektura title + author
  - Completion ring (0-100%)
  - Best quiz score (star rating)
  - Last studied date ("2 dni temu")
  - Tap -> navigates to lektura detail
- [ ] Weekly activity chart:
  - Bar chart showing daily quiz sessions for last 7 days
  - Days with activity highlighted, inactive days dimmed
- [ ] Empty state for new users: "Zacznij ucze sie! Wybierz swoja pierwsza lekture."

### 2. Streak System (~3h)

- [ ] Streak rules:
  - At least 1 completed quiz session per day counts
  - Streak increments at first quiz completion each day
  - Streak resets to 0 if no quiz on a calendar day (midnight reset, user's timezone)
  - Streak freeze: prevents reset for 1 day (Premium only, 1 per week)
- [ ] Streak widget:
  - Flame icon with count
  - Color intensifies: 1-3 (orange), 4-7 (bright orange), 7+ (red/gold)
  - Displayed in: progress dashboard header, home screen top bar
- [ ] Streak freeze:
  - Icon in streak widget when active
  - "Uzyj zamrozenia" prompt when streak about to break (push notification at 20:00 if no activity)
  - Premium check before allowing freeze
- [ ] Database: `users.streak_count`, `users.streak_last_date`, `users.streak_freezes_remaining`
- [ ] Streak calculation: server-side on quiz completion, client-side for display

### 3. Achievement Badges (~2h)

- [ ] Badge system with unlock conditions:
  | Badge | Condition | Icon concept |
  |-------|-----------|-------------|
  | Pierwszy krok | Complete first quiz | Footprint |
  | Czytelnik | Study 3 different lektury | Open book |
  | Mol ksiazkowy | Study 10 different lektury | Bookworm |
  | Perfekcjonista | Score 100% on any quiz | Star |
  | Seria 3 | 3-day streak | Flame x3 |
  | Seria 7 | 7-day streak | Flame x7 |
  | Seria 30 | 30-day streak | Flame x30 |
  | Znawca Lalki | Complete all Lalka quizzes with 80%+ | Book-specific |
  | Maturzysta | Study all 12 MVP lektury | Graduation cap |
- [ ] Badge display: grid in profile/progress, with locked (gray) and unlocked (color) states
- [ ] Unlock notification: bottom toast/snackbar when badge earned ("Odblokowano: Pierwszy krok!")
- [ ] Badge data stored in user_progress or separate badges table

### 4. Completion Percentage Logic (~1h)

- [ ] Per-lektura completion calculated from:
  - Viewed content blocks (streszczenie, bohaterowie, motywy, etc.) — each tab viewed = points
  - Quiz completed — adds percentage based on score
  - Weighting: content viewed (40%), quiz attempted (30%), quiz score 80%+ (30%)
- [ ] Completion ring: animated circular progress indicator
- [ ] 100% triggers confetti animation (subtle)

## Acceptance Criteria

- [ ] Dashboard shows accurate stats from real quiz data
- [ ] Streak increments on quiz completion
- [ ] Streak resets correctly on missed day
- [ ] Streak freeze works for Premium users only
- [ ] Badges unlock at correct thresholds
- [ ] Completion percentage updates in real-time
- [ ] Weekly chart shows correct data
- [ ] All works offline (syncs when online)

## Notes for Claude Session

- Streaks are the #1 retention driver. Get this right.
- The streak freeze is a Premium-only feature — make it feel valuable.
- Don't over-gamify. Badges should feel earned, not awarded for breathing.
- Completion percentage should encourage depth, not just opening tabs.
- Test timezone handling for streak midnight reset.
