# Change log: Add missing "select and copy text" feature to docs/features.md

Implements: `plans/20260803_160000_add_missing_text_selection_feature.md`

## What changed

- `docs/features.md`:
  - Section 1 (App Overview & Description): opening sentence now also mentions
    searching, listening (text-to-speech), and selecting/copying text — it only listed
    viewing, navigating, annotating, reorganizing, extracting, verifying signatures, and
    printing before.
  - Section 2.2: added a new bullet, **Select & Copy Text**, documenting the real
    text-selection feature on the viewer (`lib/features/viewer/presentation/viewer_screen.dart`,
    `enableTextSelection`), which was implemented in the code but missing from the doc.

No code changes — documentation only.
