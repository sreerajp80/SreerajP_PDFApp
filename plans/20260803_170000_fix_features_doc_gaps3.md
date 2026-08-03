# Fix gaps and errors in docs/features.md (round 3)

**Status:** completed

## Files to be changed

- `docs/features.md` only. No app code changes.

## The issue

A fresh code audit (Explore agent comparing `docs/features.md` against
`pubspec.yaml`, the Android manifest, and the Flutter/Kotlin source) found
two claims that no longer match the code, plus several real behaviors and
one dependency group missing from the doc.

### Wrong claims found

1. **Compress PDF** (`docs/features.md:84`) says it downsamples embedded
   images. It does not. `PdfBoxHandler.kt` (`compressPdf`) only strips
   document-info and XMP metadata and re-saves the file. Its own code
   comment says "It will not shrink an already-optimized file much."
2. **Encrypt PDF** (`docs/features.md:85`) says it uses "AES/RC4" security
   handlers. The code hard-codes AES-256 only (`encryptionKeyLength = 256`,
   `setPreferAES(true)`); there is no RC4 path.

### Missing items found

- `flutter_riverpod` (state management, used in ~30 files) is missing from
  the "100% Open Source Stack" list in section 1 — the most load-bearing
  omitted package.
- `path_provider`, `path`, `intl`, and `flutter_localizations` are also used
  in the app but not listed in that same stack section.
- Recent Files Dashboard bullet (`docs/features.md:51`) doesn't mention the
  30-item cap on stored recent files.
- Custom Trust Store bullet (`docs/features.md:121`) doesn't mention the
  512 KB certificate import size cap.
- Images-to-PDF bullet (`docs/features.md:103`) says "a maximum image count
  is enforced" without giving the number (100).
- `cupertino_icons` is a declared dependency but unused anywhere in `lib/`
  (dead default-template leftover) — flag for cleanup, not a doc addition.

## The plan

Edit `docs/features.md` only:

1. Fix the Compress PDF bullet (section 2.4) to say it strips metadata and
   re-saves, and does not downsample images or recompress streams.
2. Fix the Encrypt PDF bullet (section 2.4) to say AES-256 only (drop the
   "RC4" claim).
3. Add `flutter_riverpod`, `path_provider`, `intl`, and
   `flutter_localizations` to the open-source stack list in section 1
   (skip `path`, since it's a minor helper alongside `path_provider`).
4. Add the 30-item cap to the Recent Files Dashboard bullet.
5. Add the 512 KB cap to the Custom Trust Store bullet.
6. Add the number "100" to the Images-to-PDF max-count bullet.
7. Leave `cupertino_icons` out of the doc (it's unused, not a real
   dependency of any feature) — no action needed there.

App description (section 1, paragraph 1) already mentions viewing,
navigating, searching, TTS, select/copy, annotating, reorganizing,
extracting, verifying signatures, and printing. It does not explicitly
mention **encrypting/decrypting (protecting) or compressing** PDFs, which
are real, separate features in section 2.4. I will add those two verbs to
the overview sentence so the description stays inclusive of all major
feature areas.

No behavior changes, no code changes — text-only fixes to keep the doc
accurate.
