# Add missing "select and copy text" feature to docs/features.md

**Status:** completed

## What files change

- `docs/features.md`

## What is the issue

I checked `docs/features.md` against the actual app code (`lib/features/**`) to see if
every real feature is listed, and if the App Description (section 1) covers everything.

I found the code implements **text selection and copy** on the PDF viewer page
(`lib/features/viewer/presentation/viewer_screen.dart:937`, `enableTextSelection:
_textUsable && !_annotateMode` on the `pdfrx` viewer — turned on only where a real text
layer exists, turned off while drawing an annotation). This matches the app idea doc
(`docs/PDF-Idea.md`: "Select and copy text from pages (needs a text layer)"), but
`docs/features.md` never mentions it. Section 2.2 documents search, but not
select-and-copy.

Everything else I checked — viewing/navigation, annotations, page operations, extraction,
printer/import, signature verification, settings — matches the code. No other missing or
made-up features found.

I also noticed the App Description (section 1, opening paragraph) lists what the app does
for a document ("viewing, navigating, annotating, reorganizing, extracting from,
verifying digital signatures of, and printing") but leaves out **searching**,
**text-to-speech (listening)**, and **selecting/copying text** — all real, documented
features later in the same file. The README's one-line description already includes
these ("opening, reading, searching, listening ... annotating, extracting, reorganizing,
printing, and verifying digital signatures"), so features.md's own summary should match.

## The plan

1. In section 2.2 ("Search, Indic Phonetic & Sandhi Engine, and Text-to-Speech (TTS)"),
   add one bullet for **Select & Copy Text**: text selection is available wherever the
   page has a real text layer, and is turned off automatically while an annotation
   drawing gesture is active.
2. In section 1 (App Overview & Description), rewrite the opening sentence to also
   mention searching, listening (text-to-speech), and selecting/copying text, so the
   description matches the full feature list below it.

No code changes. Documentation only.
