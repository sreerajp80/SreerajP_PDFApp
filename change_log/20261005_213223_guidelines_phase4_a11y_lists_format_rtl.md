# Change log — Guidelines Phase 4: lists, accessibility, number formatting, right-to-left

Implements Phase 4 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(findings F10 outline part, F11, S1, S2, S6).

## What changed

### Lists (§10.3)
- `lib/features/viewer/presentation/widgets/outline_drawer.dart` — the PDF outline (which can be
  very long) is now a `ListView.builder` instead of an eager `ListView`.

### Accessibility (§7.1, §7.2, §7.3, §7.8)
- `lib/features/page_ops/presentation/widgets/watermark_dialog.dart` — the five color swatches
  were 24×24 dp with no name. They are now a new `_ColorSwatch` widget: 48×48 dp tap target,
  a localized `Tooltip` and `Semantics` label (the color name), `selected` state, and a check mark
  so the choice is not shown by color alone. The swatches moved under the label in a `Wrap`, so
  they no longer risk overflowing a narrow dialog.
- `lib/features/settings/presentation/accent_color_screen.dart` — the custom-painted color wheel
  now has `Semantics` with a label, hint, current value (hex), and increase / decrease actions
  (15° hue steps), so screen-reader users can change the color without dragging.
- New ARB keys (en, ml, sa): `colorGrey`, `labelAccentColorWheel`, `helpAccentColorWheelHint`.

### Locale-aware numbers (§8.3.2, §8.9)
- `lib/core/format/display_format.dart` — new `DisplayFormat.formattingLocale()` (the helper
  `CLAUDE.md` refers to; it did not exist yet) and `DisplayFormat.decimal()`, built on `intl`
  `NumberFormat`. `DisplayFormat.bytes()` now takes the locale too.
- `CacheService.formatBytes()` and the private `_readableSize()` in `import_screen.dart` were
  duplicates of `DisplayFormat.bytes()`; both were removed and their callers
  (`printer_settings_screen.dart`, `storage_settings_screen.dart`, `import_screen.dart`) use
  `DisplayFormat.bytes()`.
- `tts_settings_screen.dart` — speech rate, pitch and pause values use `DisplayFormat.decimal()`
  instead of `toStringAsFixed()`.

### Right-to-left readiness (§8.8)
- 27 files: `EdgeInsets.fromLTRB` → `EdgeInsetsDirectional.fromSTEB`, and
  `Alignment.topLeft/bottomRight/...` → `AlignmentDirectional.topStart/bottomEnd/...`.
- `organize_pages_screen.dart` — thumbnail badges use `PositionedDirectional` /
  `Positioned.directional`.
- Kept on purpose: `page_annotation_layer.dart` places notes at PDF page coordinates with
  `Positioned(left: …)`. A PDF page is not mirrored in right-to-left, so this must stay physical.

## Tests

- New `test/helpers/tooltip_checks.dart` — `expectAllIconButtonsHaveTooltips()` (§7.8). It is now
  called in the pump step of 13 screen tests (home, settings, signatures, about, help, accent
  color, permissions, reader search bar, print sheet, features, theme, typography, appearance), so
  every test in those files also checks tooltips. All passed — no missing tooltips were found.
- `test/core/format/display_format_test.dart` — `decimal()`, `formattingLocale()` (Sanskrit and
  unknown locales fall back to English), and `bytes()` with a locale.
- `test/features/settings/presentation/features_screen_test.dart` — right-to-left layout smoke
  test.
- `test/features/settings/presentation/accent_color_screen_test.dart` — the color wheel has its
  label, hint, value, and increase / decrease actions.
- `dart format`: clean. `flutter analyze`: no issues. `flutter test`: 443 passed.

## Needs native-reader review

- `colorGrey` — ml "ചാരനിറം" · sa "धूसरः"
- `labelAccentColorWheel` — ml "നിറചക്രം" · sa "वर्णचक्रम्"
- `helpAccentColorWheelHint` — ml "പ്രധാന നിറം തിരഞ്ഞെടുക്കാൻ ചക്രത്തിൽ വലിക്കുക." ·
  sa "प्रधानवर्णचयनाय चक्रे अङ्गुलिः चाल्यताम्।"
- Seen in passing, not changed: the existing Sanskrit `colorPurple` is "धूम्रः", which usually
  means smoke-grey. A reviewer may prefer "नीललोहितः" or "जाम्बवः" for purple.

## To verify on a device

- TalkBack on the accent color screen: the wheel reads its name and current color, and volume /
  swipe up-down changes the hue.
