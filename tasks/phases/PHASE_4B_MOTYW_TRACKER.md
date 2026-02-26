# Phase 4B: Motyw Tracker

**Effort:** ~16 hours | **Tickets:** LEKT-015 | **Dependencies:** Phase 1A (motif data must exist)

## Goal

Build the interactive cross-lektura motif mapping matrix. Students currently build these tables by hand from Greg guides — we automate it.

## Deliverables

### 1. Motif Matrix Screen (~8h)

- [ ] Main view: scrollable matrix grid
  - Rows: 25 motifs (from master list)
  - Columns: lektury (scrollable horizontally)
  - Cells: filled (motif present in lektura) or empty
  - Filled cells colored by intensity/relevance
- [ ] Tap any filled cell -> bottom sheet:
  - Motif name + lektura title
  - Explanation: how the motif manifests in this work (100-200 words)
  - Relevant quote (if available)
  - "Sprawdz inne lektury z tym motywem" link
- [ ] Column headers: lektura title (truncated) + cover thumbnail
- [ ] Row headers: motif name + icon
- [ ] Sticky headers: first column and first row stay visible while scrolling

### 2. Filters & Views (~4h)

- [ ] Filter by school level: show only SP 7-8 / Liceum PP / Liceum PR lektury columns
- [ ] Filter by epoch: show only specific epoch lektury
- [ ] View modes:
  - Matrix view (default): the full grid
  - Motif detail view: select a motif -> list of all lektury where it appears
  - Lektura motif view: select a lektura -> list of all its motifs (this already exists in detail page)
- [ ] Search: type motif name to jump to it in the grid

### 3. Motif Detail Cards (~3h)

- [ ] When viewing a specific motif across lektury:
  - Motif description (general: what this motif means in Polish literature)
  - List of lektury cards, each showing: title, how motif manifests, key quote
  - "Jak pisac o tym motywie na maturze" — essay writing tip for this motif
  - Related CKE questions mentioning this motif (link to matura stats, if built)

### 4. Premium Gating (~1h)

- [ ] Free: can see the matrix (which cells are filled) but cannot tap to see explanations
- [ ] Premium: full access to all explanations, quotes, essay tips
- [ ] CTA on free tap: "Odblokuj Motyw Tracker"

## Acceptance Criteria

- [ ] Matrix renders all 25 motifs x all lektury without performance issues
- [ ] Cell taps show correct motif-lektura explanation
- [ ] Filters reduce columns correctly
- [ ] Sticky headers work during scroll
- [ ] Premium gating applied
- [ ] Works offline with cached data

## Notes for Claude Session

- The matrix can be large (25 rows x 30+ columns at scale). Performance matters — use lazy loading or virtualized grid.
- This is a highly visual feature. The color coding should make patterns obvious at a glance.
- The motif-lektura explanations are the real value — they need to be specific, not generic.
- This is one of the strongest matura prep tools. Students use motif tables constantly for comparative essays.
- Consider: students should be able to "favorite" motif-lektura pairs for quick reference during essay writing.
