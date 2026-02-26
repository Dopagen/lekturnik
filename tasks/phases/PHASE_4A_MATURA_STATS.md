# Phase 4A: Matura Statistics Engine

**Effort:** ~40 hours (30h data entry, 10h UI) | **Tickets:** LEKT-014 | **Dependencies:** Phase 1A

## Goal

Build a searchable, tagged database of all CKE matura Polish language questions (2005-2025) and the UI to visualize frequency and trends. This is a unique selling point no competitor has.

## Deliverables

### 1. CKE Data Collection (~10h)

- [ ] Download all matura Polish papers from cke.gov.pl (2005-2025)
- [ ] Extract all questions: rozprawka topics, interpretacja prompts, porownanie tasks
- [ ] Both poziom podstawowy (PP) and rozszerzony (PR)
- [ ] Estimate: ~1,000-2,000 questions total across ~20 years

### 2. Question Tagging (~20h)

- [ ] Per question, tag:
  - `year` (2005-2025)
  - `level` (PP / PR)
  - `question_type` (rozprawka / interpretacja / porownanie / analiza_tekstu / inne)
  - `lektura_ids[]` — which lektury are referenced (direct or applicable)
  - `motif_ids[]` — which motifs are relevant
  - `difficulty` (estimated: latwy / sredni / trudny)
  - `source_url` — link to original CKE PDF
- [ ] Store in `matura_questions`, `matura_question_lektury`, `matura_question_motifs` tables
- [ ] Create import script (similar to content pipeline) for batch loading

### 3. Matura Statistics UI (~10h)

- [ ] **Per-lektura view** (in Matura tab of detail page):
  - "Lalka pojawila sie w 23 egzaminach od 2005" headline stat
  - List of questions referencing this lektura, sorted by year (newest first)
  - Each question card: year badge, level badge, type badge, question text
- [ ] **Global matura stats screen** (accessible from home or dedicated tab):
  - Lektura frequency bar chart (horizontal bars, sorted by count)
  - Motif frequency bar chart
  - Year-over-year trend: how many times each lektura appeared per year
  - "Top 5 lektur na maturze" highlight section
  - "Najczestsze motywy" highlight section
- [ ] **Motif heatmap** (optional, nice-to-have):
  - Grid: motifs x years, color intensity = frequency
  - Shows which themes CKE favors in which periods
- [ ] All charts: use `fl_chart` or similar Flutter charting library

### 4. Search & Filter (~2h)

- [ ] Search matura questions by keyword
- [ ] Filter by: year range, level (PP/PR), question type, lektura, motif
- [ ] Results sortable by year, relevance

## Acceptance Criteria

- [ ] All available CKE questions from 2005-2025 are in the database
- [ ] Tagging is accurate (spot-check 20 random questions)
- [ ] Per-lektura frequency matches manual count
- [ ] Charts render correctly with real data
- [ ] Search and filter work across all dimensions
- [ ] Premium gate: entire matura section is Premium-only

## Notes for Claude Session

- Data entry is the bottleneck here, not code. Consider semi-automating with AI to extract questions from PDFs, then manually verify tags.
- CKE papers are publicly available PDFs — some may need OCR.
- The frequency data ("Lalka appears in 85% of exams") is the headline stat that will appear in marketing.
- Literary texts embedded within CKE papers retain their own copyright — only use the question text, not the stimulus passages.
- This feature is Premium-locked. It's a strong conversion driver for serious matura students.
