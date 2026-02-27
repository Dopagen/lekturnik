# Phase 5: Polish & Launch

**Effort:** ~20 hours | **Tickets:** LEKT-012, LEKT-018, LEKT-019 | **Dependencies:** All previous phases

## Goal

Final polish, **web PWA deployment (launches first!)**, App Store submission, onboarding optimization, and launch readiness. The web version goes live immediately while app stores review the mobile builds.

## Launch Strategy: Web First, Then Stores

```
Day 1:  Web PWA deployed to lekturnik.pl (instant, no review)
Day 1:  Submit iOS to App Store review + Android to Google Play review
Day 1:  TikTok/social announcement with lekturnik.pl link
Day 3-7: Google Play approved (typically faster)
Day 7-14: iOS approved
Day 14+: All three platforms live, full marketing push
```

This means students can start using Lekturnik on web **immediately** while mobile reviews are pending.

## Deliverables

### 1. Web PWA Deployment (PRIORITY — do this first, ~4h)

- [ ] **Firebase Hosting setup:**
  - `firebase init hosting` in project root
  - Configure to serve `build/web/` directory
  - Custom domain: lekturnik.pl
  - HTTPS automatic via Firebase
- [ ] **Build and deploy:**
  - `flutter build web --release --web-renderer html`
  - `firebase deploy --only hosting`
- [ ] **PWA configuration:**
  - `web/manifest.json`: name, short_name, icons (192px, 512px), theme_color, background_color, display: standalone
  - Service worker for basic caching (Flutter generates one by default)
  - "Add to Home Screen" prompt after 2nd visit
- [ ] **Web-specific polish:**
  - Responsive layout: works on desktop (1200px+), tablet (768px), and mobile browser
  - Mouse hover states (web users use mouse, not touch)
  - Right-click disabled on content (basic anti-copy for premium content)
  - Loading screen with Lekturnik logo (replaces Flutter's default white screen)
  - Custom 404 page
- [ ] **SEO fundamentals:**
  - `web/index.html`: proper `<title>`, `<meta description>`, Open Graph tags
  - robots.txt allowing crawling
  - Note: Flutter web (HTML renderer) has limited SEO — the main landing page with static HTML can be added later for better SEO
- [ ] **Web "download app" banner:**
  - Sticky bottom banner on mobile browsers: "Lepsze doswiadczenie w aplikacji. Pobierz za darmo."
  - Links to App Store / Play Store (once live) or shows "Wkrotce w sklepach"
  - Dismissable (remember dismissal in localStorage)
- [ ] **Verify on browsers:** Chrome, Firefox, Safari, Edge (desktop + mobile)

### 2. App Store Submission Prep (LEKT-012, ~8h)

- [ ] **App icons:**
  - 1024x1024 master icon
  - All required sizes for iOS + Android + web (favicon, PWA icons)
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

### 3. Onboarding Flow (LEKT-018, ~5h)

- [ ] 3-screen intro (shown on first launch, all platforms):
  1. "Ucz sie lektur z AI" — app logo + key value prop
  2. "Sprawdzi czy przeczytales" — AI quiz demo visual
  3. "Zdaj mature z polskiego" — matura stats visual
- [ ] Each screen: illustration/screenshot, headline, 1-sentence subtext, dots pagination
- [ ] After onboarding:
  - School level selector (SP 7-8 / Liceum / Technikum)
  - "Czego sie teraz uczysz?" — select up to 5 lektury from catalog
  - Selected lektury appear on home screen as "Twoje lektury"
- [ ] Skip button visible on every screen
- [ ] Onboarding only shown once (SharedPreferences on mobile, localStorage on web)
- [ ] **Web-specific onboarding addition:** final screen shows "Pobierz aplikacje" for full features

### 4. Final QA & Polish (~3h)

- [ ] Test on physical devices + browsers:
  - [ ] iPhone (recent model)
  - [ ] iPhone SE (small screen)
  - [ ] Android mid-range (Samsung A54 class)
  - [ ] Android budget (older/smaller device)
  - [ ] **Chrome desktop (1920x1080)**
  - [ ] **Chrome mobile (iPhone/Android browser)**
  - [ ] **Safari desktop + mobile**
  - [ ] **Firefox desktop**
- [ ] QA checklist:
  - [ ] All navigation flows work end-to-end (mobile + web)
  - [ ] No text overflow on any screen
  - [ ] Dark mode renders correctly
  - [ ] Offline mode works on mobile (airplane mode test)
  - [ ] Premium purchase flow on mobile (sandbox)
  - [ ] **Web paywall shows "download app" CTA, not purchase buttons**
  - [ ] AI quiz completes full session (both platforms)
  - [ ] Streak increments correctly
  - [ ] Search returns correct results
  - [ ] Push notifications deliver (mobile only)
  - [ ] Account creation and deletion work (both platforms)
  - [ ] **Web: OAuth login redirects work correctly**
  - [ ] No crashes in Sentry
- [ ] Performance check:
  - [ ] Cold start <3s (mobile)
  - [ ] **Web initial load <5s on 4G** (HTML renderer + content on demand)
  - [ ] Catalog load <1s
  - [ ] AI response <3s
  - [ ] App size <50MB (mobile)
  - [ ] **Web bundle size <5MB** (HTML renderer)
- [ ] Polish language review: no English leaking in user-facing strings
- [ ] Accessibility basics: text scaling, screen reader labels on key buttons

### 5. CI/CD: Automated Web Deploy

- [ ] GitHub Actions workflow: on push to main -> build web -> deploy to Firebase Hosting
- [ ] Verify: merge to main automatically updates lekturnik.pl

### 6. Launch Day Checklist

- [ ] **Web PWA live at lekturnik.pl** (Day 1!)
- [ ] App submitted to iOS App Store
- [ ] App submitted to Google Play Store
- [ ] TikTok announcement post (link to lekturnik.pl — works immediately)
- [ ] Instagram announcement post
- [ ] Reddit/Facebook group posts
- [ ] Analytics verified: events flowing (web + mobile)
- [ ] Error tracking verified: Sentry connected (web + mobile)
- [ ] Monitor first 24h: crashes, ratings, web traffic
- [ ] When stores approve: update social posts with download links

## Acceptance Criteria

- [ ] **lekturnik.pl live and functional** (web PWA)
- [ ] App submitted to both stores (approval pending is OK)
- [ ] Onboarding shows once and collects school level (all platforms)
- [ ] No critical bugs on any tested device/browser
- [ ] Analytics collecting data from web + mobile
- [ ] First external users can use the web app immediately

## Notes for Claude Session

- **Web deployment is the #1 priority in this phase.** It's the fastest path to real users.
- The web version doesn't need to be perfect — it needs to be functional and bug-free for the free tier.
- App Store reviewers look at: content completeness, subscription clarity, privacy for minors, and functionality.
- Screenshots sell the app. Invest time in making them look polished.
- The onboarding school level selector is important for personalization.
- Don't forget: in-app review prompt after positive experiences (mobile only).
- Test the web build on slow connections (throttle in Chrome DevTools). Flutter web can be heavy — the HTML renderer helps but monitor bundle size.
