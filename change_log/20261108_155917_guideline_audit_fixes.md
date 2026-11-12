# Change log: guideline audit fixes

Implements: `plans/20261107_172942_guideline_audit_fixes.md` (approved with option A5-a).

## What changed

| # | File(s) | Change |
|---|---|---|
| A1 | `lib/features/settings/presentation/language_screen.dart` | `'Auto'` → `l10n.labelLanguageAuto`. |
| A2 | `lib/features/settings/presentation/printer_settings_screen.dart` | Paper-size tiles now show a short name (`labelPaperA4/Letter/Legal`) with the size as a subtitle (`descPaperA4/Letter/Legal`). `_optionTile` takes an optional `subtitle`. Stored values `A4` / `Letter` / `Legal` are unchanged. |
| A3 | `lib/features/extraction/presentation/widgets/extraction_dialog.dart` | `'Standard'` / `'High Quality'` → `labelQualityStandard` / `labelQualityHigh`. |
| A4 | `lib/features/extraction/presentation/widgets/text_preview_dialog.dart` | `'No text found.'` → `emptyExtractedText`. |
| A5 | `lib/features/viewer/presentation/viewer_screen.dart` | The signature overlay status line now uses the app language. It reuses the existing signature-panel keys (`labelSignatureStatusTrusted`, `descSignatureStatusValidNotTrusted`, `descSignatureStatusInvalid`, `descSignatureStatusUnknown`) instead of adding four new keys. The old "always in English" comment was replaced. |
| — | `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated `app_localizations*.dart`) | 10 new keys with `@` descriptions in English and translations in Malayalam and Sanskrit. |
| — | `test/l10n/translation_parity_test.dart` | `labelPaperA4` added to the "same as English allowed" list (a standard symbol, like the existing `labelNUpSheetA4`). |
| B | `plans/20260920_102000_…`, `plans/20260920_110200_…`, `plans/20260920_113500_…`, `plans/20260920_133200_…` | `Status:` `Pending Approval` / `Proposed` → `completed` (each has a change log that implements it, with nothing reported as skipped). |
| B | `plans/20260920_144300_readme_accuracy_and_screenshots.md` | `Completed` → `completed` (allowed values are lowercase). Not listed in the plan; same rule. |
| C | `plans/20260919_235800_align_docs_with_guidelines.md` | Removed the absolute drive-letter path; only the relative name `myapps.md` remains. |
| D | `docs/workflow_rules.md` | Added the "Security impact" line rule, §4 (submodule read-only) and §5 (CI is checks only), matching `CLAUDE.md`. |

## Changes from the plan

- **A6 not done (watermark default `'CONFIDENTIAL'`).** The native watermark code
  (`PdfBoxHandler.kt`) draws text with `PDType1Font.HELVETICA_BOLD`, which has no Malayalam or
  Devanagari glyphs. A translated default would make the watermark fail in those two languages.
  The literal stays for now. **Follow-up bug:** any non-Latin watermark text a user types fails
  today too; the fix is to embed a Unicode font (the printer feature already does this).
- **A5 wording.** Reusing the panel keys changes the English overlay words slightly, for example
  "Signature valid" → "Signed and trusted". The overlay and the panel now say the same thing.
- **Paper names.** Split into name + size so the names stay within the 20/22 character label
  budget ("US Letter (8.5 × 11 in)" was 23 characters).

## Checks

- `dart format .` — 0 files changed.
- `flutter analyze` — no issues.
- `flutter test` — all 452 tests passed. The first run failed the parity test (Sanskrit paper
  names were left in Latin script); fixed as described above.
- **Not done:** checking the changed screens on a device in all three languages.

## Needs native-reader review

- Malayalam: `സ്വയം`, `US ലെറ്റർ`, `ലീഗൽ`, `210 × 297 മി.മീ.`, `… ഇഞ്ച്`, `സാധാരണം`,
  `ഉയർന്ന നിലവാരം`, `വാചകമൊന്നും കണ്ടെത്തിയില്ല.`
- Sanskrit: `स्वयम्`, `US लेटर्`, `लीगल्` (paper names written in Devanagari), `मि.मी.`,
  `इञ्च्`, `सामान्यम्`, `उत्कृष्टम्` (for "High Quality"), `पाठः न लब्धः।`

## Still open (not in this plan)

- `plans/20261107_170947_security_baseline_and_kotlin_review.md` (`draft`) — `docs/security.md`
  §1.1 and §3.1.
- `plans/20261107_171200_toolchain_upgrade_agp9_gradle9.md` (`in_progress`).
- Watermark font bug (above).
- Print-service help texts and the privacy policy URL (from earlier change logs).
