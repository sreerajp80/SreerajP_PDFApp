# Watermark: support Malayalam, Sanskrit and other non-Latin text

**Status:** in_progress

Approved by the user (hybrid approach). Code done and change log written
(`change_log/20261108_160554_watermark_unicode_text.md`); waiting for the device test.

Follows: `change_log/20261108_155917_guideline_audit_fixes.md` (item A6 was skipped because of
this bug).

## The issue

1. **Non-Latin watermark text fails.** `applyWatermark` in
   `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` always uses
   `PDType1Font.HELVETICA_BOLD`. That font only knows the Western (WinAnsi) characters.
   For Malayalam, Devanagari, `₹`, or an emoji, `font.getStringWidth(text)` throws, the
   `catch` returns an error, and the user sees a failure message. The app does not crash, but
   the feature does not work in two of the app's three languages (hard rule 6, "never a dead
   button").
2. **Hard-coded English in the dialog.** `lib/features/page_ops/presentation/widgets/watermark_dialog.dart`
   has the default text `'CONFIDENTIAL'` and five preset chips: `CONFIDENTIAL`, `DRAFT`, `COPY`,
   `SAMPLE`, `ORIGINAL`. They are not localized. (The audit missed the chips; my search only
   looked for phrases with spaces.)

### Why "just embed a Malayalam font in PDFBox" is not enough

PDFBox can embed a TrueType font (`PDType0Font`), but it does **not shape text**. Malayalam and
Devanagari need shaping: letters join into conjuncts, and some vowel signs move before the
consonant. Without it, `ക്ഷ` or `कि` are drawn as broken separate pieces. Android's own text
engine (`Canvas` / `TextPaint`, which uses HarfBuzz) does shape correctly — the PDF printer
feature already relies on it.

## The fix (recommended)

**Hybrid drawing in `applyWatermark`:**

1. **Latin-only text** (Helvetica can encode every character): keep today's vector text path
   exactly as it is. No change for existing users.
2. **Any other text:** draw the text once onto a transparent Android `Bitmap` with
   `Canvas` + `TextPaint` (bold, the chosen colour), using the right bundled font:
   - Malayalam → `NotoSansMalayalam-Bold.ttf`
   - Devanagari → `NotoSansDevanagari-Bold.ttf`
   - anything else → the system `sans-serif` bold (Android falls back to its own fonts).
   Turn the bitmap into one PDF image with `LosslessFactory.createFromImage` (keeps
   transparency), and place it with the **same** maths as today: centre or tiles, rotation,
   opacity (`ExtGState`), size so that the text height matches the chosen point size.
   The image is made once per document and reused on every page, so the file stays small.
3. **Sharpness and memory limits.** Draw at 4× the point size (about 288 DPI) so the text is
   crisp when printed. Cap the bitmap at 4096 px on its longest side (lower the scale if
   needed) and `recycle()` it after use. Also clamp `fontSize` to 6–200 pt and the text to 200
   characters on the native side, because platform-channel arguments are outside input
   (Security Baseline §15.1).
4. **Shared font loader.** Move the existing "load bundled font from `flutter_assets/…`, else
   `assets/…`, else system font" code (used by the text-to-PDF printer) into one small private
   helper, and use it from both places.
5. **Localize the dialog.** New ARB keys in all three languages:
   `labelWatermarkConfidential`, `labelWatermarkDraft`, `labelWatermarkCopy`,
   `labelWatermarkSample`, `labelWatermarkOriginal`. The default text becomes
   `l10n.labelWatermarkConfidential`. Because the controller is made in the `State`, it is
   filled once in `didChangeDependencies` (where `AppLocalizations` can be read), and only if
   the user has not typed yet.

**Side effect (good):** a non-Latin watermark becomes an image, so it does not mix into the
page's text layer. Search, copy and text-to-speech of the page are not disturbed. A Latin
watermark stays real text, as today.

## Other options considered

- **Always use the bitmap path, even for Latin.** Simpler (one path), but Latin watermarks
  would become slightly larger files and less crisp at huge zoom. It also changes behaviour that
  works today. Not chosen.
- **`PDType0Font` with the Noto fonts.** Small and searchable, but conjuncts and vowel signs come
  out broken, as explained above. Not chosen.

## Files to change

- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` — hybrid path, bitmap
  helper, shared font loader, argument limits.
- `lib/features/page_ops/presentation/widgets/watermark_dialog.dart` — localized default and
  presets.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated `app_localizations*.dart`).
- New: `test/features/page_ops/presentation/widgets/watermark_dialog_test.dart` — the default
  text and the chips come from `AppLocalizations` in `en`, `ml` and `sa`.
- `docs/features.md` — say that watermarks support Malayalam, Sanskrit and other scripts.
- `CHANGELOG.md` — one user-facing line.
- `plans/20261107_172942_guideline_audit_fixes.md` — note that A6 is done here.
- New: `change_log/<timestamp>_watermark_unicode_text.md`.

**Security impact:** native code (platform folder) changes. No new permission, no network, no
new dependency. Only bundled fonts are read. New limits on `fontSize`, text length and bitmap
size protect against very large memory use from bad channel arguments. The original PDF is
still never changed (copy-on-write).

## Testing

- `dart format .`, `flutter analyze`, `flutter test`.
- The Kotlin code needs a real Android `Bitmap`, so it cannot run in a plain unit test. Manual
  device test (you run it):
  - `flutter run --flavor dev`; watermark a sample PDF with `CONFIDENTIAL`, `രഹസ്യം`,
    `गोपनीयम्`, and `ക്ഷേത്രം` (conjunct test); centre and tiled; 0°, 45°, 90°; opacity 25 %.
  - Open the result in this app and one other viewer: letters joined correctly, colour and
    opacity right, original file untouched.
  - Afterwards: `android\gradlew --stop` and end any leftover `GradleDaemon` /
    `KotlinCompileDaemon` processes.

## Translations

The new preset words will be flagged "needs native-reader review" in the change log.
