# Phase 1A: Content Pipeline & Data Layer

**Effort:** ~12 hours | **Tickets:** LEKT-003 | **Dependencies:** Phase 0

## Goal

Build the tooling to generate, validate, and import lektura study content into the database. Generate seed content for first 3 lektury.

## Deliverables

### 1. Content JSON Schema (~2h)

- [ ] Finalize `content/schema/lektura_schema.json` (JSON Schema draft-07)
- [ ] Schema covers: lektura metadata, chapters, characters, motifs, quotes, quiz_questions, system_prompt
- [ ] Document the schema with examples

### 2. Import Script (~3h)

- [ ] Script (Dart CLI or Node.js) that reads a JSON file matching the schema
- [ ] Validates JSON against schema before import
- [ ] Upserts into Supabase (idempotent — safe to re-run)
- [ ] Handles relationships: creates lektura first, then related records
- [ ] Logs: records created/updated/skipped
- [ ] Error handling: rolls back on partial failure

### 3. Content Generation Prompts (~3h)

- [ ] Write Claude Sonnet prompts for generating each content type:
  - Summary (chapter-by-chapter, 500-1500 words per lektura)
  - Characters (name, role, traits, arc, one-liner, relationships)
  - Motif mappings (how each of 25 motifs manifests in this work)
  - Quotes (5-10 per book with context, motif tags, essay tips)
  - Quiz questions (50-100 per book across Bloom's levels)
  - System prompt (2-4K tokens for AI quiz context)
- [ ] Store prompts in `content/prompts/` directory
- [ ] Include quality criteria in each prompt (accuracy requirements, format spec)

### 4. Validation Script (~1h)

- [ ] Script checks imported data for:
  - Missing required fields
  - Empty strings where content expected
  - Broken foreign key references
  - Quiz questions without expected_answer
  - Motif references to non-existent motifs
  - Character references in quotes to non-existent characters
- [ ] Outputs report: pass/fail per check

### 5. Seed Content — First 3 Lektury (~3h)

- [ ] Generate content for: **Lalka, Dziady III, Pan Tadeusz**
- [ ] Run through import pipeline
- [ ] Run validation
- [ ] Manual spot-check against original texts for accuracy
- [ ] Commit JSON files to `content/lektury/` directory

### 6. Flutter Data Models (~2h)

- [ ] Create freezed models matching DB schema:
  - `Lektura`, `Chapter`, `Character`, `Motif`, `LekturaMotif`
  - `Quote`, `QuizQuestion`, `MaturaQuestion`
- [ ] JSON serialization configured
- [ ] Supabase query helpers in `lib/services/supabase_service.dart`

## Acceptance Criteria

- [ ] JSON schema validates correct content and rejects malformed
- [ ] Import script successfully loads 3 lektury into Supabase
- [ ] Validation script passes on all 3 lektury
- [ ] Flutter models deserialize from Supabase queries correctly
- [ ] Content prompts are documented and reproducible

## Notes for Claude Session

- Accuracy is critical. Every quiz question, every character description must be verifiable against the original text.
- The import script will be used repeatedly — make it robust and idempotent.
- Include motif seed data (the 25 global motifs) as part of this phase.
- Quiz questions should include anti-cheat questions (testing details only in full text, not summaries).
