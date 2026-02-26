# Phase 2B: Monetization

**Effort:** ~12 hours | **Tickets:** LEKT-010 | **Dependencies:** Phase 0

## Goal

Integrate RevenueCat for subscription management and build the paywall UI. This can be built in parallel with other Phase 1 work since it's relatively standalone.

## Deliverables

### 1. RevenueCat Setup (~3h)

- [ ] RevenueCat account and project created
- [ ] App configured in RevenueCat dashboard (iOS + Android)
- [ ] Products created:
  - `premium_monthly`: 9.99 PLN/month
  - `premium_annual`: 79.99 PLN/year (33% savings)
- [ ] 7-day free trial enabled on both products
- [ ] Offerings configured (single offering with both products)
- [ ] Webhook configured: RevenueCat -> Supabase Edge Function to update `users.premium_status`
- [ ] `purchases_flutter` SDK integrated in Flutter app

### 2. Subscription Provider (~2h)

- [ ] `subscriptionProvider` (Riverpod):
  - Exposes: `isPremium`, `subscriptionType`, `trialActive`, `expiresAt`
  - Initializes on app launch (checks RevenueCat customer info)
  - Listens for purchase/restore events
  - Updates local state immediately on purchase
- [ ] Premium check helper: `bool canAccess(FeatureGate gate)` used throughout app
- [ ] Feature gates enum: `unlimitedQuiz`, `fullSummaries`, `allCharacters`, `quotesBank`, `maturaQuestions`, `motifTracker`, `rozprawkaBuilder`, `noAds`, `fullOffline`, `audioSummaries`

### 3. Paywall Screen (~4h)

- [ ] Full-screen paywall with:
  - Hero section: app icon + "Odblokuj pelny dostep" headline
  - Feature comparison: Free vs Premium (checkmark table)
  - Price cards: Monthly (9.99 PLN/mies.) and Annual (79.99 PLN/rok, with "Oszczedzasz 33%" badge)
  - Annual card highlighted as recommended
  - "Rozpocznij 7-dniowy okres probny" CTA button
  - Terms: "Subskrypcja odnawia sie automatycznie. Mozesz anulowac w kazdej chwili."
  - "Przywroc zakupy" link at bottom
  - Close/dismiss button (X in top-right)
- [ ] Paywall animations: smooth slide-up presentation
- [ ] Polish copy throughout — no English leaking

### 4. Paywall Triggers (~2h)

- [ ] Integrate paywall display at trigger points:
  - 4th AI quiz attempt in a day
  - Scrolling past free content limits (chapters, characters)
  - Tapping any Premium-locked content badge
  - Tapping Premium features in navigation
- [ ] Trigger context: paywall can show source reason ("Odblokuj nielimitowane quizy" vs "Odblokuj pelne streszczenia")
- [ ] Don't show paywall more than 2x per session (anti-annoyance)

### 5. Webhook for Server-Side Validation (~1h)

- [ ] Supabase Edge Function: `POST /functions/v1/revenuecat-webhook`
- [ ] Validates RevenueCat webhook signature
- [ ] Updates `users.premium_status` and `users.premium_expires_at` on:
  - `INITIAL_PURCHASE`, `RENEWAL`, `PRODUCT_CHANGE` -> set premium
  - `CANCELLATION`, `EXPIRATION` -> set free
- [ ] Handles trial start/end events

### 6. Restore Purchases (~0.5h)

- [ ] "Przywroc zakupy" button in Profile screen
- [ ] Calls RevenueCat restore, updates local state
- [ ] Success/failure feedback to user

## Acceptance Criteria

- [ ] Can purchase subscription (test in sandbox)
- [ ] Premium status updates immediately in app
- [ ] Paywall appears at correct trigger points
- [ ] Annual plan shows savings badge
- [ ] 7-day trial works
- [ ] Restore purchases works
- [ ] Webhook updates server-side premium status
- [ ] Free users see appropriate limitations
- [ ] Premium users see no gates or ads

## Notes for Claude Session

- Test EVERYTHING in sandbox mode before going live.
- The paywall is a critical conversion point — design matters more than usual here.
- Don't show the paywall too aggressively. Users who feel pushed will leave.
- RevenueCat handles receipt validation — don't try to implement this yourself.
- Make sure the subscription terms are legally compliant (auto-renewal disclosure required by both stores).
