# Phase 5: Polish & Launch

**Effort:** ~16 hours | **Tickets:** LEKT-012, LEKT-018, LEKT-019 | **Dependencies:** All previous phases

## Goal

Final polish, App Store submission, onboarding optimization, and launch readiness. This is the last gate before users see the product.

## Deliverables

### 1. App Store Submission Prep (LEKT-012, ~8h)

- [ ] **App icons:**
  - 1024x1024 master icon
  - All required sizes for iOS + Android
  - Design: recognizable at small sizes, includes book/AI visual element
- [ ] **Screenshots (per device):**
  - iPhone 6.7" (iPhone 15 Pro Max): 5 screenshots
  - iPhone 5.5" (iPhone 8 Plus): 5 screenshots
  - Android phone: 5 screenshots
  - Screenshot content:
    1. Hero: "Ucz sie lektur z AI" + catalog view
    2. AI Quiz in action (chat bubbles)
    3. Lektura detail page (Lalka)
    4. Motyw Tracker matrix
    5. Progress dashboard with streak
  - Polish text on all screenshots
  - Consider: framed screenshots with captions
- [ ] **App Store descriptions:**
  - Short description (80 chars): "Lektury szkolne z AI. Quizy, streszczenia, motywy."
  - Full description (4000 chars, PL): keyword-rich, mentions specific lektury
  - English description (for international visibility)
- [ ] **Privacy policy:** live at lekturnik.pl/polityka-prywatnosci (Polish + English)
- [ ] **Terms of service:** live at lekturnik.pl/regulamin
- [ ] **Apple:** App Privacy labels, age rating (4+, education), review notes
- [ ] **Google:** Data safety form, content rating, target audience declaration
- [ ] **TestFlight:** distribute to 10-20 beta testers
- [ ] **Google Play:** internal testing track live
- [ ] Submit to both stores, respond to reviewer feedback

### 2. Onboarding Flow (LEKT-018, ~5h)

- [ ] 3-screen intro (shown on first launch):
  1. "Ucz sie lektur z AI" — app logo + key value prop
  2. "Sprawdzi czy przeczytales" — AI quiz demo visual
  3. "Zdaj mature z polskiego" — matura stats visual
- [ ] Each screen: illustration/screenshot, headline, 1-sentence subtext, dots pagination
- [ ] After onboarding:
  - School level selector (SP 7-8 / Liceum / Technikum)
  - "Czego sie teraz uczysz?" — select up to 5 lektury from catalog
  - Selected lektury appear on home screen as "Twoje lektury"
- [ ] Skip button visible on every screen
- [ ] Onboarding only shown once (flag in SharedPreferences)

### 3. Final QA & Polish (~3h)

- [ ] Test on physical devices:
  - [ ] iPhone (recent model)
  - [ ] iPhone SE (small screen)
  - [ ] Android mid-range (Samsung A54 class)
  - [ ] Android budget (older/smaller device)
- [ ] QA checklist:
  - [ ] All navigation flows work end-to-end
  - [ ] No text overflow on any screen
  - [ ] Dark mode renders correctly
  - [ ] Offline mode works (airplane mode test)
  - [ ] Premium purchase flow (sandbox)
  - [ ] AI quiz completes full session
  - [ ] Streak increments correctly
  - [ ] Search returns correct results
  - [ ] Push notifications deliver
  - [ ] Account creation and deletion work
  - [ ] No crashes in Sentry
- [ ] Performance check:
  - [ ] Cold start <3s
  - [ ] Catalog load <1s
  - [ ] AI response <3s
  - [ ] App size <50MB
- [ ] Polish language review: no English leaking in user-facing strings
- [ ] Accessibility basics: text scaling, screen reader labels on key buttons

### 4. Landing Page / Web Presence

- [ ] lekturnik.pl live with:
  - Hero section: app name, value prop, download buttons
  - Feature highlights (3-4 key features)
  - Screenshots carousel
  - App Store + Google Play badges
  - Privacy policy link
  - Contact email
- [ ] SEO: meta tags, Open Graph for social sharing
- [ ] Google Search Console + Analytics connected

### 5. Launch Day Checklist

- [ ] App live on iOS App Store
- [ ] App live on Google Play Store
- [ ] TikTok announcement post
- [ ] Instagram announcement post
- [ ] Reddit/Facebook group posts
- [ ] Analytics verified: events flowing
- [ ] Error tracking verified: Sentry connected
- [ ] Monitor first 24h: crashes, ratings, reviews

## Acceptance Criteria

- [ ] App approved on both stores
- [ ] Onboarding shows once and collects school level
- [ ] No critical bugs on any tested device
- [ ] Landing page live and linking to stores
- [ ] Analytics collecting data
- [ ] First external users can install and use the app

## Notes for Claude Session

- This is the final gate. Quality matters more than speed.
- App Store reviewers look at: content completeness (need real data for 12 lektury), subscription clarity (terms visible), privacy for minors (age gate must work), and functionality (everything must work, not just look right).
- Screenshots sell the app. Invest time in making them look polished.
- The onboarding school level selector is important for personalization — it determines which lektury appear first.
- Don't forget: in-app review prompt after positive experiences (high quiz scores, streak milestones).
