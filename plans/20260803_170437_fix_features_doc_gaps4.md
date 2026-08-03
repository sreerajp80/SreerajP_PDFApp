# Fix features.md — add missing features, fix two inaccurate claims

**Status:** approval_pending

## Files to change

- `docs/features.md`

## What is wrong

I checked `docs/features.md` against the real code (screens, native Android code, routes).
The doc calls itself an "Exhaustive Feature Catalog" but is missing a few real features, and
has two claims that don't match the code.

### Missing features (found in code, not in doc)

1. **"Save to device" button on every generated file.** Merge, Split, Organize, Compress,
   Protect, Unlock, Images-to-PDF, Text-to-PDF, and annotation export all let the user save
   the new file to a folder they pick (SAF), not just share it. The doc only mentions this
   for text extraction.
2. **Undo after deleting a page** in the Organize Pages screen (a Snackbar with an Undo
   button).
3. **Visible search options menu.** The search bar has a small settings icon with two
   checkboxes, "Strict" and "Ignore Accents" — this is how the user actually turns on the
   joiner-matching and accent-stripping behaviors described in section 2.2.
4. **Expired certificates stay visible in the Trust Store,** marked with a red "expired"
   warning, instead of being removed automatically.
5. **Export/Flatten Annotations also writes bookmarks into the PDF's own outline/table of
   contents,** not just markup/notes/ink.

### Inaccurate claims

1. **Sanskrit accent stripping is written as if it always happens.** In the code it is an
   off-by-default toggle the user turns on ("Ignore Accents"), the same as "Strict Joiner
   Mode" right above it in the doc. The wording should match.
2. **"SHA-1 / SHA-256 / SHA-512" hash claim for signature integrity checks is too specific.**
   The code only names SHA-1 and SHA-256 directly; SHA-512 is never mentioned anywhere in the
   code. The verifier does auto-detect whatever hash algorithm a signature used, so SHA-512
   signatures would likely still verify, but the doc should not state SHA-512 as a confirmed,
   named check.

## Plan for the fix

Edit `docs/features.md` only, in place:

1. In section 2.4 (Page Operations), add one bullet: generated files can be saved to a
   user-picked location (SAF) as well as shared, and this applies to Merge, Split, Organize,
   Compress, Protect, and Unlock outputs. Also add "Undo" to the Organize Pages bullet.
2. In section 2.6 (Printer & Content Importer), note that Images-to-PDF and Text-to-PDF
   outputs can also be saved to device, not just shared.
3. In section 2.3 (Annotation), add that saving/exporting flattened output also supports
   "save to device", and that Export/Flatten Annotations bakes bookmarks into the PDF's
   outline/TOC as well as markup.
4. In section 2.2 (Search/TTS), add a short line noting the search bar has a visible options
   menu (Strict / Ignore Accents checkboxes), and reword the Sanskrit accent-stripping bullet
   to say it is an off-by-default "Ignore Accents" toggle, matching the Strict Joiner Mode
   bullet's phrasing.
5. In section 2.7 (Digital Signature), soften the hash-list claim to say SHA-1 and SHA-256
   are used directly, and the verifier follows whatever digest algorithm the signature itself
   declares (so other standard hash algorithms are supported by extension, not hard-coded as
   a fixed list). Also add a line noting expired trusted certificates are kept and shown with
   a warning icon rather than removed automatically.

No code changes, no behavior changes — documentation only.

## Do you approve this plan?
