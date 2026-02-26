# Phase 2A: AI Quiz Engine

**Effort:** ~24 hours | **Tickets:** LEKT-006, LEKT-007 | **Dependencies:** Phase 0, Phase 1A

## Goal

Build the core differentiator: the AI-powered conversational quiz that tests whether students actually read the book. Includes the chat UI, scoring system, difficulty adaptation, and the Edge Function backend.

## Deliverables

### 1. Edge Function: AI Quiz Backend (LEKT-007, ~8h)

- [ ] `supabase/functions/ai-quiz/index.ts` — full implementation
- [ ] Request schema:
  ```json
  {
    "lektura_id": "uuid",
    "difficulty": "latwy|sredni|trudny",
    "conversation_history": [
      { "role": "assistant", "content": "..." },
      { "role": "user", "content": "..." }
    ],
    "session_question_count": 3
  }
  ```
- [ ] Function flow:
  1. Validate request (lektura_id exists, difficulty valid, history <= 20 messages)
  2. Load system prompt from `lektura_system_prompts` table
  3. Construct GPT-4o-mini API call with: system prompt + scoring rubric + conversation history
  4. Parse structured JSON response
  5. Return to client
- [ ] Response schema:
  ```json
  {
    "question": "Next question text",
    "evaluation": "correct|partially_correct|incorrect|null",
    "score": 0-3,
    "explanation": "Why right/wrong",
    "session_complete": false,
    "questions_remaining": 4
  }
  ```
- [ ] Rate limiting: max 20 API calls per user per hour (check via Supabase auth token)
- [ ] Error handling: OpenAI timeout (15s), rate limit, malformed response, invalid JSON
- [ ] Cost logging: log token usage per request for monitoring
- [ ] API key in Supabase Vault (never in client)

### 2. Quiz Chat UI (LEKT-006, ~10h)

- [ ] Chat-style interface:
  - Message bubbles: AI (left, app accent color), student (right, neutral)
  - Typing indicator (animated dots) while AI responds
  - Auto-scroll to latest message
  - Input field with send button (+ enter key submit)
- [ ] Session start flow:
  - Screen title: lektura name
  - Difficulty selector: 3 buttons (Latwy / Sredni / Trudny) with descriptions
  - Selecting difficulty -> first question appears
- [ ] During session:
  - AI asks question
  - Student types answer (free-text, multiline)
  - AI evaluates: shows score badge (0-3), explanation, then next question
  - Score badge colors: 0=red, 1=orange, 2=green, 3=gold
  - Running score visible in app bar
  - "Zakoncz" (End) button in app bar
- [ ] Session end:
  - Automatic after 5-8 questions (configurable)
  - Or manual via "Zakoncz" button
  - Scorecard screen:
    - Overall percentage + star rating (1-5)
    - Per-question breakdown: question text, student answer (truncated), score, correct answer hint
    - "Sprobuj ponownie" (Try again) button
    - "Wroc do lektury" (Back to lektura) button
  - Save session to `quiz_sessions` table

### 3. Free Tier Question Cycling (~3h)

- [ ] Quiz service that switches between modes:
  - **Free mode:** loads pre-generated questions from `quiz_questions` table
  - **Premium mode:** calls Edge Function for live AI
- [ ] Free mode logic:
  - Select questions matching lektura + difficulty
  - Randomize order, avoid repeats within session
  - For evaluation: compare student answer against `expected_answer` using simple keyword matching (not AI)
  - OR: use pre-generated evaluation hints stored with each question
- [ ] Daily limit tracking: 3 free sessions per day (stored in SharedPreferences with date)
- [ ] On 4th attempt: show paywall screen with clear message ("Odblokuj nielimitowane quizy AI")

### 4. Difficulty Adaptation (~2h)

- [ ] Track correctness within session: running tally of scores
- [ ] Adaptation rules:
  - 2+ consecutive scores >= 2 -> increase difficulty (latwy->sredni->trudny)
  - 2+ consecutive scores <= 1 -> decrease difficulty (trudny->sredni->latwy)
- [ ] For pre-generated questions: filter by difficulty tag from DB
- [ ] For live AI: include difficulty level in API request + conversation context

### 5. Session Persistence (~1h)

- [ ] Active quiz session survives app backgrounding (up to 5 minutes)
- [ ] On app kill: lose active session (acceptable — sessions are short)
- [ ] Completed sessions saved to Supabase (or locally if offline, sync later)
- [ ] Update `user_progress` record with new best score if applicable

## Acceptance Criteria

- [ ] Edge Function deploys and responds correctly to test requests
- [ ] Chat UI is smooth, responsive, no layout issues
- [ ] Difficulty adaptation works visibly (questions get harder/easier)
- [ ] Free tier: 3 sessions/day with pre-generated questions
- [ ] 4th attempt triggers paywall
- [ ] Scorecard displays correctly after session
- [ ] Session data persists to database
- [ ] AI responses come back in <3 seconds
- [ ] Rate limiting prevents abuse

## Notes for Claude Session

- The quiz is THE differentiator. UX must be polished — this is what users will demo to friends.
- The typing indicator is important — it reassures users the AI is working, not broken.
- Free mode should feel nearly as good as Premium (same UI, just pre-generated Qs).
- Anti-cheat questions are critical — include them in the question selection logic.
- Test with real-ish Polish text to catch any encoding issues.
