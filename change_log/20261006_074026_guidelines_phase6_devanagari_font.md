# Change log — Guidelines Phase 6: Devanagari script coverage

Implements Phase 6 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(finding F7), with the user's choice A1 (bundle the font). The user approved the download.

## What changed

- New font files in `assets/fonts/`: `NotoSansDevanagari-Regular.ttf` (about 243 KB) and
  `NotoSansDevanagari-Bold.ttf` (about 250 KB), the hinted TTF build from the official Noto
  repository, plus its license `OFL-NotoSansDevanagari.txt` (SIL OFL 1.1). Checked as valid
  TrueType files with the Noto copyright line.
- `pubspec.yaml` — new font family `Noto Sans Devanagari` (regular + bold).
- `lib/app/theme/tokens.dart` — new `AppTokens.scriptFontFallback`
  (`Noto Sans Malayalam`, `Noto Sans Devanagari`).
- `lib/app/theme/app_theme.dart` — every theme (light, dark, OLED, sepia) sets
  `fontFamilyFallback: AppTokens.scriptFontFallback`, so Malayalam and Sanskrit text never
  renders as boxes, whatever font the user picks (engineering standard §8.3.3, language pack §2).
- `docs/dependencies.md` — new §4A "Bundled Fonts": every bundled font with its files, script,
  license and source (engineering standard §17.4).

## Tests

- `test/app/theme/theme_test.dart` — every theme, including one with a chosen font, falls back to
  both bundled script fonts.
- `flutter analyze`: no issues. `flutter test`: 448 passed.
  `flutter build apk --flavor dev --debug`: built.

## Notes

- App size grows by about 0.5 MB. The font is not subset: Sanskrit text in PDFs and in the app
  can use any Devanagari letter, so a subset could drop needed glyphs.

## To verify on a device

- Switch the app to Sanskrit on a clean device (or one without a system Devanagari font) and open
  every screen: no boxes, no clipped tops or bottoms of letters, no overflow (language pack §2).
