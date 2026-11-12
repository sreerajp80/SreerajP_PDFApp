# Change log: watermark supports Malayalam, Sanskrit and other scripts

Implements: `plans/20261108_160059_watermark_unicode_text.md` (approved, hybrid approach).
Also closes item A6 of `plans/20261107_172942_guideline_audit_fixes.md`.

## What changed

| File | Change |
|---|---|
| `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` | `applyWatermark` is now hybrid. Text that Helvetica can encode is drawn as vector text, exactly as before. Any other text goes through the new `renderTextStamp`: Android `Canvas` + `TextPaint` (correct shaping), bold Noto Malayalam / Noto Devanagari / system sans-serif, drawn at 4× (about 288 DPI) onto a transparent bitmap, turned into one `LosslessFactory` image per document, and placed with `drawStamp` (same centre / tile / rotation / opacity maths). The bitmap is capped at about 4096 px and recycled. New limits on channel input: font size 6–200 pt, text up to 200 characters. A new `loadBundledTypeface` helper is shared with `textToPdf`. |
| `lib/features/page_ops/presentation/widgets/watermark_dialog.dart` | The default text (set once in `didChangeDependencies`, never over typed text) and the five preset chips now come from `AppLocalizations`. |
| `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated) | 5 new keys: `labelWatermarkConfidential`, `labelWatermarkDraft`, `labelWatermarkCopy`, `labelWatermarkSample`, `labelWatermarkOriginal`. |
| New `test/features/page_ops/presentation/watermark_dialog_test.dart` | In `en`, `ml` and `sa`, the default text and every chip are the localized words, and tapping a chip fills the field. |
| `docs/features.md`, `CHANGELOG.md` | Describe the fix (new `[Unreleased]` section in `CHANGELOG.md`). |
| `plans/20261107_172942_guideline_audit_fixes.md` | Note that A6 is now done here. |

## Changes from the plan

- The test is in `test/features/page_ops/presentation/`, not `…/presentation/widgets/`,
  because the other page-ops dialog tests already live there.
- A small side margin was added to the stamp bitmap, so wide bold glyphs are not cut at the
  edge.

## Checks

- `dart format .` — 0 files changed. `flutter analyze` — no issues.
- `flutter test` — all 455 tests passed (452 + 3 new).
- **Not done yet — the Kotlin code has not been compiled or run.** The device test from the
  plan is with the user (build with `--flavor dev`, watermark Latin, Malayalam, Sanskrit and a
  conjunct word, centre and tiled, several angles; then stop the Gradle daemons). The plan
  stays `in_progress` until that passes.

## Needs native-reader review

- Malayalam: `രഹസ്യം`, `കരട്`, `പകർപ്പ്`, `മാതൃക`, `മൂലപ്രതി`.
- Sanskrit: `गोपनीयम्`, `प्रारूपम्`, `प्रतिलिपिः`, `निदर्शनम्`, `मूलप्रतिः`.

## Found in passing (not changed)

- `test/l10n/sa_material_localizations_test.dart` has a test named "loads Hindi fallback", but
  the delegate (correctly) loads English. Only the test name is wrong; it should be renamed.
