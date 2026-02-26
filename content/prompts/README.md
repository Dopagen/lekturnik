# Content Generation Prompts

This directory contains the prompts used with Claude Sonnet to generate lektura study content.

## Files

- `summary_prompt.md` — Generates chapter-by-chapter summaries
- `characters_prompt.md` — Generates character cards
- `motifs_prompt.md` — Generates motif mappings
- `quotes_prompt.md` — Generates curated quote selections
- `quiz_questions_prompt.md` — Generates quiz question banks
- `system_prompt_prompt.md` — Generates the AI quiz system prompt

## Usage

1. Open the prompt file for the content type you want to generate
2. Replace `{LEKTURA_TITLE}` and `{LEKTURA_AUTHOR}` with the actual values
3. Send to Claude Sonnet via API or web interface
4. Review output for accuracy against original text
5. Format as JSON matching `content/schema/lektura_schema.json`
6. Run import script

## Quality Standards

- Every factual claim must be verifiable against the original text
- Quotes must be exact (verify against WolneLektury.pl for public domain works)
- Quiz questions must have unambiguous correct answers
- Anti-cheat questions must genuinely test full-text knowledge
- Polish language should be clear and accessible for 14-19 year old students
