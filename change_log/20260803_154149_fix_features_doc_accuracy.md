# Fixed accuracy of docs/features.md

Implements: `plans/20260803_154149_fix_features_doc_accuracy.md`

## What changed

Corrected `docs/features.md` so it matches the real app code. No code changed — only
this one documentation file.

**Added features that were missing from the doc:**
- Book (two-page, side-by-side) viewer mode, alongside Single Page and Continuous
  (section 2.1).
- "Invert Colors" display toggle in the viewer menu (section 2.1).
- The app can open a PDF shared straight from another app (`ACTION_SEND` for
  `application/pdf`), separate from the image/text-to-PDF conversion path (section 2.6).

**Corrected claims that did not match the code:**
- Text-to-speech: now says play / pause / stop only, with language chosen automatically
  (no rate, pitch, manual language picker, or background-audio claims) (section 2.2).
- Organize Pages: removed "duplicate pages" — that action does not exist (section 2.4).
- Split PDF: now says it splits into one file per page only; points to Export Page
  Ranges (section 2.5) for range-based output, instead of claiming Split itself supports
  ranges (section 2.4).
- Images-to-PDF: removed "customizable margins and page layout" — the app uses a fixed
  one-image-per-page layout (section 2.6).
- Material 3 UI: removed "dynamic color support" — the app uses one fixed brand seed
  color, not Android's wallpaper-based dynamic color (section 2.8).
- App Settings: now lists only what exists (Theme, Malayalam TTS toggle, Trust Store
  management) and notes recent files are removed one at a time, not via a bulk "clear
  history" option that does not exist (section 2.8).
- Removed "duplicate" from the copy-on-write operations list in section 1, since that
  operation does not exist.

## How this was checked

Compared the doc section by section against the Dart source under `lib/features/`, the
native Kotlin handlers, `pubspec.yaml`, and `android/app/src/main/AndroidManifest.xml`.
