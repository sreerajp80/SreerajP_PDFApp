# Change log: fix features.md gaps (round 4)

Implements plan: `plans/20260803_170437_fix_features_doc_gaps4.md`

## What changed

Only `docs/features.md` was edited. No app code changed.

Added missing features:
- Save-to-device (not just share) is now documented for page operations (2.4), annotation
  export (2.3), and images/text-to-PDF import (2.6) — it was previously only mentioned for
  text extraction.
- Undo after deleting a page in Organize Pages (2.4).
- The search bar's visible options menu with "Strict" and "Ignore Accents" checkboxes (2.2).
- Export/Flatten Annotations also writes bookmarks into the exported PDF's outline/TOC (2.3).
- Trust Store keeps expired certificates visible with a warning instead of removing them (2.7).

Fixed inaccurate claims:
- Sanskrit Cantillation Accent Stripping was described as always-on; it is really an
  off-by-default "Ignore Accents" toggle. Reworded to match the Strict Joiner Mode bullet's
  phrasing (2.2).
- The signature-check hash list named SHA-1/SHA-256/SHA-512; SHA-512 isn't referenced
  anywhere in the code. Reworded to name only the two hashes actually used directly, and to
  note the verifier follows whatever digest algorithm the signature declares (2.7).
- Noted that the 100-image import cap silently drops extra images rather than erroring (2.6).

These came from a code audit (screens, native Android/Kotlin code, routes, dependencies)
against the doc's claims.
