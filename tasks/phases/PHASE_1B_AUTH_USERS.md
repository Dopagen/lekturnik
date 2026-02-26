# Phase 1B: Auth & User System

**Effort:** ~8 hours | **Tickets:** LEKT-008 | **Dependencies:** Phase 0

## Goal

Build the complete authentication flow including age gating, parental consent for minors, profile management, and anonymous-to-authenticated account linking.

## Deliverables

### 1. Auth Screens (~3h)

- [ ] Login screen: email/password, Apple Sign-In button, Google Sign-In button
- [ ] Register screen: email, password, confirm password
- [ ] Forgot password screen with email reset flow
- [ ] All screens follow app theme, with Polish UI strings
- [ ] Form validation: email format, password strength (min 8 chars)
- [ ] Loading states, error handling with user-friendly Polish messages

### 2. Age Gate & Parental Consent (~2h)

- [ ] After registration: birth year selector (dropdown or scroll picker)
- [ ] If birth year indicates <16: show parental consent screen
- [ ] Parent email input -> verification email sent to parent
- [ ] Account created but limited until parent clicks verification link
- [ ] Supabase: `parent_email` and `parent_consent_verified` fields on user record
- [ ] Edge Function or trigger: sends consent email via Supabase Auth email templates

### 3. Profile Screen (~1.5h)

- [ ] Display: name, email, school level, account type (free/premium)
- [ ] Edit: display name, school level
- [ ] School level selector: SP 7-8 / Liceum / Technikum
- [ ] Account deletion button with confirmation dialog (GDPR right to erasure)
- [ ] Logout button
- [ ] Link to privacy policy (external URL)

### 4. Anonymous Mode & Account Linking (~1.5h)

- [ ] App fully functional without sign-in (anonymous Supabase auth)
- [ ] Progress stored locally via drift/SQLite
- [ ] When user decides to register: link anonymous session to new account
- [ ] Local progress merged into cloud progress on linking
- [ ] No data loss during transition

### 5. Auth Provider (Riverpod) (~1h)

- [ ] `authProvider`: exposes current auth state (signed in / anonymous / signed out)
- [ ] `userProvider`: exposes User model with premium status, school level, streak
- [ ] Auto-refresh on app resume
- [ ] Premium status check integrated (reads from user record, updated by RevenueCat webhook)

## Acceptance Criteria

- [ ] Can register with email, Apple, Google
- [ ] Under-16 flow triggers parental consent correctly
- [ ] Profile displays and edits work
- [ ] Account deletion removes all user data
- [ ] Anonymous users can use core features
- [ ] Anonymous -> registered preserves progress
- [ ] Auth state persists across app restarts

## Notes for Claude Session

- GDPR compliance is non-negotiable. Test the deletion flow thoroughly.
- Polish strings for all user-facing text. Error messages should be helpful, not technical.
- The parental consent email should be clear and non-threatening — parents need to understand what the app does.
- Don't store precise age — only birth year for range gating.
