# Fix gaps and errors in docs/features.md (round 2)

**Status:** completed

## What is the issue

I checked `docs/features.md` against the actual app code. The document has a few
wrong claims and is missing a few real features. Details below.

## Files to change

- `docs/features.md` (only this file)

## Wrong claims to fix

1. **Section 2.3 (Annotation) — color count.** Doc says "5 customizable color
   presets (Yellow, Green, Blue, Pink, Orange)". Code has 7: Yellow, Green,
   Blue, Red, Purple, Orange, Black. There is no Pink.
2. **Section 2.3 — ink stroke width.** Doc says ink drawing has "customizable
   stroke color and stroke width". Only the color is user-choosable; stroke
   width is a fixed constant in code. Will remove "and stroke width".
3. **Section 2.3 — sticky note titles.** Doc says notes have "custom titles
   and editable note bodies". Code only stores a text body, no title field.
   Will remove "custom titles".
4. **Section 2.3 — bookmark labels.** Doc says bookmarks have "custom label
   editing". The data model has a label field, but no screen lets the user
   set or edit it. Will reword to say labels are stored but not yet
   editable in the UI.
5. **Section 2.7 — AATL trust list.** Doc says the app bundles both "EU EUTL
   and Adobe Approved Trust List (AATL)" certificates. Code has a comment
   explaining AATL is deliberately NOT bundled (licensing reasons). Will
   remove the AATL claim.
6. **Section 2.6 — ACTION_SEND_MULTIPLE scope.** Doc implies this intent
   filter covers PDFs/text broadly. In the Android manifest it is
   registered for images only. Will say "images only".

## Missing features to add

1. **Section 1 (stack list).** Add `go_router` (navigation), `shared_preferences`
   (settings storage), `package_info_plus` (About screen version),
   `crypto` (SHA-256 fingerprinting), `logger` to the open-source stack list.
2. **Section 2.1.** Add a bullet for the "Reset Zoom" button, and the
   auto-fallback to single-page mode (with a warning) for very large files.
3. **Section 2.3.** Add a bullet for "Clear All" — a bulk delete-all-annotations
   action, separate from the per-stroke Eraser tool.
4. **Section 2.4.** Add a note that Merge, Split, Organize, and Compress
   currently need an already-unencrypted PDF — they do not yet accept a
   password, so a password-protected file must be unlocked (Decrypt) first.
5. **Section 2.5.** Add export options (copy to clipboard / share as JSON)
   to the "Interactive Form Fields Reader" bullet. Also fix the DPI example
   text from "150 DPI, 300 DPI" to reflect the real 100–300 DPI slider range.
6. **Section 2.6.** Add a note that image-to-PDF import caps the number of
   images that can be imported at once.
7. **Section 2.7.** Add two bullets: certificate revocation status checking
   (offline only, no online lookup), and the document-level summary verdict
   that follows a "weakest signature wins" rule across all signatures in a
   file. Also expand the "Visual Signature Badges" bullet to mention the
   on-page overlay that is painted directly over a PDF viewer's own
   signature widget (showing trusted/invalid status, signer, and date).

## Plan for the fix

Edit `docs/features.md` section by section, making the six corrections and
adding the seven missing-feature bullets listed above. No other files change.
This is a documentation-only change; no app behavior changes.

## Why these were found

A read-only code audit compared each claim in `docs/features.md` against the
actual Flutter/Kotlin source (annotation controller, page ops service,
signature trust evaluator, Android manifest, pubspec.yaml, and related
screens).
