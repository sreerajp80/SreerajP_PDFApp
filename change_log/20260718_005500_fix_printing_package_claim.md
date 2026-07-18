# Change log — fix a false claim about the `printing` package

**Date:** 2026-07-17
**Implements:** `plans/20260717_134828_fix_printing_package_claim.md`
**Relates to:** Phase 6 (`change_log/20260717_121500_phase6_pdf_printer.md`)

---

## What was wrong

While planning Phase 6 I wrote that the `printing` package "bundles a second copy of PDFium and
would clash with `pdfrx`", and gave that as the reason for hand-writing our own print bridge. I
stated it as a checked fact. **It was false.** It then spread into four documents.

The user questioned it, which is the only reason it was caught.

**What the source actually says.** `printing` 5.14.3, from the local pub cache:

- Its Android side is five Java files. No PDFium, no `.so` files, no native libraries.
- No third-party dependencies in `android/build.gradle`.
- It prints with `PrintManager` / `PrintDocumentAdapter` and renders with
  `android.graphics.pdf.PdfRenderer` — the same OS APIs `PrintHandler.kt` uses.

**Where the mistake came from.** `printing` *does* link PDFium in its Windows and Linux desktop
builds. I generalised that to Android without checking. This app is Android-only, so it never
applied.

**The plain answer.** The app has exactly one copy of PDFium, from `pdfrx`. Adding `printing`
would not have added a second.

---

## What changed

Documentation only. No code, no tests, no `pubspec` changes. `PrintHandler.kt` and the whole
Phase 6 feature stay exactly as built.

- **`docs/architecture.md`** — §3 package table cell shortened to point at §6; the honest
  comparison now lives in the §6 "PDF printer" bullet. The PDFium claim is gone.
- **`docs/pdf-app-implementation-progress.md`** — the Phase 6 "No new package" note rewritten
  with the true reason.
- **`plans/20260717_114932_phase6_pdf_printer.md`** — §4 corrected, plus a `Correction` note under
  the Status block recording what was wrong and why.
- **`change_log/20260717_121500_phase6_pdf_printer.md`** — the "Decisions worth knowing" bullet
  corrected, plus a `Correction` section recording the error.

The plan and the Phase 6 change log are historical records, so the mistake was **marked**, not
quietly overwritten. A decision record that hides its own corrections is what made this expensive
in the first place.

## The true reason, now recorded everywhere

> Android's print framework is an OS API, and PdfBox was already in the build, so nothing new was
> needed. The `printing` package (Apache 2.0) would also have worked — on Android it wraps the
> same `PrintManager` / `PrintDocumentAdapter` we use, with no native code of its own. We wrote
> our own because the app already owns a native-channel path (PdfBox, TTS, SAF) and this fits it,
> not because `printing` was unusable.

This is a preference, not a constraint, and the docs now say so. Had the real trade-off been
recorded at the time, using `printing` would have been a live option worth weighing — it would
have done the same job on Android for roughly 150 fewer lines of Kotlin. The decision to keep our
own still stands; it is just no longer propped up by a reason that was never true.

## Why this mattered enough to fix

A wrong *reason* in the decision record is worse than a debatable *decision*. The decision can be
argued with; a fabricated technical constraint cannot, because the next reader — me included —
takes it as verified and never re-checks it. It would have quietly ruled `printing` out of every
future discussion of the print path.

---

## Checks

- `flutter analyze` — clean (documentation-only change; run as a sanity check).
- No test or build re-run needed: no code changed.
