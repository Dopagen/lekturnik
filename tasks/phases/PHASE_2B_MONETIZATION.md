# Phase 2B: Monetization

**Effort:** ~14 hours | **Tickets:** LEKT-010 | **Dependencies:** Phase 0

## Goal

Integrate RevenueCat for mobile subscription management, build the paywall UI, and handle the web platform where payments are disabled (web = free funnel to app stores).

## Platform Strategy

- **Mobile (iOS + Android):** Full RevenueCat integration with monthly/annual subscriptions
- **Web:** No payments. Paywall shows "Pobierz aplikacje" CTA linking to App Store / Play Store instead of purchase buttons. Web is a free-tier funnel.

## Deliverables

### 1. RevenueCat Setup — Mobile Only (~3h)

- [ ] RevenueCat account and project created
- [ ] App configured in RevenueCat dashboard (iOS + Android)
- [ ] Products created:
  - `premium_monthly`: 9.99 PLN/month
  - `premium_annual`: 79.99 PLN/year (33% savings)
- [ ] 7-day free trial enabled on both products
- [ ] Offerings configured (single offering with both products)
- [ ] Webhook configured: RevenueCat -> Supabase Edge Function to update `users.premium_status`
- [ ] `purchases_flutter` SDK integrated — **conditionally imported, only on mobile**

### 2. Subscription Provider (~3h)

- [ ] `subscriptionProvider` (Riverpod):
  - Exposes: `isPremium`, `subscriptionType`, `trialActive`, `expiresAt`
  - **Mobile:** initializes from RevenueCat customer info
  - **Web:** always returns `isPremium: false` (free tier only)
  - Listens for purchase/restore events (mobile only)
  - Updates local state immediately on purchase
- [ ] Premium check helper: `bool canAccess(FeatureGate gate)` used throughout app
- [ ] Feature gates enum: `unlimitedQuiz`, `fullSummaries`, `allCharacters`, `quotesBank`, `maturaQuestions`, `motifTracker`, `rozprawkaBuilder`, `noAds`, `fullOffline`, `audioSummaries`
- [ ] Platform-aware gating: `if (kIsWeb) return false;` for all premium checks

### 3. Paywall Screen — Dual Mode (~4h)

- [ ] **Mobile paywall** (full-screen):
  - Hero section: app icon + "Odblokuj pelny dostep" headline
  - Feature comparison: Free vs Premium (checkmark table)
  - Price cards: Monthly (9.99 PLN/mies.) and Annual (79.99 PLN/rok, "Oszczedzasz 33%" badge)
  - Annual card highlighted as recommended
  - "Rozpocznij 7-dniowy okres probny" CTA button
  - Terms: "Subskrypcja odnawia sie automatycznie. Mozesz anulowac w kazdej chwili."
  - "Przywroc zakupy" link at bottom
  - Close/dismiss button (X in top-right)
- [ ] **Web paywall** (different CTA):
  - Same feature comparison layout
  - Instead of price cards: "Pobierz aplikacje Lekturnik"
  - App Store badge + Google Play badge (linking to stores)
  - QR code for easy mobile download (optional)
  - Message: "Premium dostepne w aplikacji mobilnej"
  - Close/dismiss button
- [ ] Paywall detects platform and shows correct variant
- [ ] Paywall animations: smooth slide-up presentation
- [ ] Polish copy throughout — no English leaking

### 4. Paywall Triggers (~2h)

- [ ] Integrate paywall display at trigger points:
  - 4th AI quiz attempt in a day
  - Scrolling past free content limits (chapters, characters)
  - Tapping any Premium-locked content badge
  - Tapping Premium features in navigation
- [ ] Trigger context: paywall shows source reason ("Odblokuj nielimitowane quizy" vs "Odblokuj pelne streszczenia")
- [ ] Don't show paywall more than 2x per session (anti-annoyance)
- [ ] **On web:** paywall triggers still fire (same UX), but CTA is "download app" instead of "buy"

### 5. Webhook for Server-Side Validation (~1h)

- [ ] Supabase Edge Function: `POST /functions/v1/revenuecat-webhook`
- [ ] Validates RevenueCat webhook signature
- [ ] Updates `users.premium_status` and `users.premium_expires_at` on:
  - `INITIAL_PURCHASE`, `RENEWAL`, `PRODUCT_CHANGE` -> set premium
  - `CANCELLATION`, `EXPIRATION` -> set free
- [ ] Handles trial start/end events

### 6. Restore Purchases — Mobile Only (~0.5h)

- [ ] "Przywroc zakupy" button in Profile screen (hidden on web)
- [ ] Calls RevenueCat restore, updates local state
- [ ] Success/failure feedback to user

### 7. Cross-Platform Premium Status (~0.5h)

- [ ] If a user subscribes on mobile and later visits web: premium status synced via Supabase `users.premium_status`
- [ ] Web checks Supabase user record for premium, not RevenueCat
- [ ] Mobile users who open web version see their Premium content unlocked

## Acceptance Criteria

- [ ] Can purchase subscription on mobile (test in sandbox)
- [ ] Premium status updates immediately in app
- [ ] Paywall appears at correct trigger points (both platforms)
- [ ] **Mobile paywall:** shows prices and purchase buttons
- [ ] **Web paywall:** shows app store download links instead of prices
- [ ] Annual plan shows savings badge
- [ ] 7-day trial works (mobile)
- [ ] Restore purchases works (mobile)
- [ ] Webhook updates server-side premium status
- [ ] Free users see appropriate limitations on both platforms
- [ ] Premium users see no gates (works on web too if subscribed via mobile)

## Notes for Claude Session

- Test EVERYTHING in sandbox mode before going live.
- The paywall is a critical conversion point — design matters more than usual here.
- **The web paywall is a conversion point too** — it converts web users to mobile app users. Make the download CTA prominent and easy.
- Don't show the paywall too aggressively. Users who feel pushed will leave.
- RevenueCat handles receipt validation — don't try to implement this yourself.
- The `purchases_flutter` package must NOT be imported on web — it will cause build failures. Use conditional imports or a platform service abstraction.
- Make sure the subscription terms are legally compliant (auto-renewal disclosure required by both stores).
