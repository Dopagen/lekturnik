# Phase 3: Content Generation (12 Lektury)

**Effort:** ~60 hours total | **Tickets:** LEKT-013 | **Dependencies:** Phase 1A (Content Pipeline)

## Goal

Generate comprehensive study content for all 12 MVP lektury. This phase can be split across 3-4 parallel Claude sessions, each handling 3-4 lektury.

## Parallel Session Breakdown

| Session | Lektury | Hours |
|---------|---------|-------|
| 3A | Lalka, Dziady III, Pan Tadeusz | ~15h |
| 3B | Zbrodnia i kara, Dzuma, Rok 1984 | ~15h |
| 3C | Ferdydurke, Tango, Przedwiosnie | ~15h |
| 3D | Wesele, Antygona, Makbet | ~15h |

## Per-Lektura Deliverables (~10h each)

### 1. Summary (Streszczenie) — ~1.5h
- [ ] Chapter-by-chapter (or act-by-act for plays)
- [ ] 500-1500 words total depending on work length
- [ ] Written in clear, engaging Polish suitable for teens
- [ ] Each chapter: title, 100-300 word summary covering key events
- [ ] Mark first 3 chapters as `is_free: true`

### 2. Characters (Bohaterowie) — ~1.5h
- [ ] 5-10 characters per lektura (depends on work)
- [ ] Per character: name, role (main/supporting/minor), description (200-400 words), traits (array of 3-5), arc_description, one_liner (witty/memorable)
- [ ] Top 3 by importance marked `is_free: true`
- [ ] Relationships noted in descriptions

### 3. Motif Mappings (Motywy) — ~1h
- [ ] Map relevant motifs from the 25 master list
- [ ] Per motif-lektura pair: explanation (100-200 words) of how the motif manifests
- [ ] Link to a relevant quote where applicable
- [ ] Typically 8-15 motifs per lektura

### 4. Curated Quotes (Cytaty) — ~1h
- [ ] 5-10 quotes per lektura
- [ ] Per quote: exact text, character attribution, chapter/act reference, motif tags, essay_usage_tip (1-2 sentences on when to use in an essay)
- [ ] First 2 quotes marked `is_free: true`
- [ ] Prioritize quotes useful for matura essays

### 5. Context (Kontekst) — ~0.5h
- [ ] Short context (200 words, free): era, author background, literary significance
- [ ] Full context (500-800 words, premium): historical setting, philosophical background, literary epoch detail, reception history

### 6. Quiz Questions — ~3h (THE MOST TIME-INTENSIVE PART)
- [ ] 50-100 questions per lektura
- [ ] Distribution by Bloom's level:
  - Remember: 20% (basic recall)
  - Understand: 20% (comprehension)
  - Apply: 20% (application to scenarios)
  - Analyze: 20% (comparison, cause-effect)
  - Evaluate: 10% (judgment, critique)
  - Create: 10% (synthesis, essay-type)
- [ ] Distribution by difficulty:
  - Latwy: 30%
  - Sredni: 40%
  - Trudny: 30%
- [ ] Anti-cheat questions (mark `is_anti_cheat: true`):
  - At least 15-20% should test details only present in full text
  - Temporal sequencing questions
  - Minor character/scene details
- [ ] Each question has: question_text, expected_answer (2-4 sentences), bloom_level, difficulty, tags

### 7. System Prompt for AI Quiz — ~1.5h
- [ ] 2,000-4,000 tokens per lektura
- [ ] Contains: verified chapter-level plot, character database, key quotes, motif map, common misconceptions, difficulty calibration
- [ ] Includes anti-hallucination instructions
- [ ] Includes scoring rubric
- [ ] Test the prompt with GPT-4o-mini to verify quality

## Quality Assurance Checklist (per lektura)

- [ ] Summary cross-checked against original text (or trusted Greg guide)
- [ ] No factual errors in character descriptions
- [ ] Quotes are exact (verified against WolneLektury.pl for public domain works)
- [ ] Quiz questions have unambiguous correct answers
- [ ] Anti-cheat questions actually test full-text knowledge
- [ ] System prompt produces sensible AI quiz behavior
- [ ] JSON validates against schema
- [ ] Import script runs successfully
- [ ] Validation script passes

## Content Generation Process

1. Use Claude Sonnet with prompts from `content/prompts/`
2. Generate each content type separately (summary, characters, etc.)
3. Review and edit output for accuracy
4. Format as JSON matching `content/schema/lektura_schema.json`
5. Run import script
6. Run validation script
7. Manual spot-check in Supabase dashboard

## Important Notes

- **Accuracy is existential.** Every claim must be verifiable against the original text.
- **Copyright awareness:** For copyrighted works (Camus, Gombrowicz, Mrozek, Orwell translations), quotes must be short excerpts with attribution under prawo cytatu.
- **Quiz questions are the moat.** Spend extra time making them good. Bad questions = bad product.
- **Anti-cheat questions are critical.** This is what makes us different from Lekturowo.
- **Test system prompts.** A system prompt that causes hallucinations is worse than no AI at all.

## Output Format

All content committed to `content/lektury/` as individual JSON files:
- `content/lektury/lalka.json`
- `content/lektury/dziady-iii.json`
- etc.
