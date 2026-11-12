# Guideline audit — remaining gaps and fixes

**Status:** partial_completion

Done except A6 (watermark default text) — see `change_log/20261108_155917_guideline_audit_fixes.md`.
A6 is done in `plans/20261108_160059_watermark_unicode_text.md`.

Approved by the user with option A5-a (localize the signature overlay text).

## What was checked (read-only)

- `flutter analyze` — no issues. `dart format` — 0 files changed. `flutter test` — 452 passed.
- No `package:flutter/material.dart` / `cupertino.dart` imports; `flutter_localizations` used
  only with `show GlobalWidgetsLocalizations` (plus the generated file).
- No `print` / `debugPrint`; no relative imports; no `Random()`; no SQL built from strings.
- Production manifest: no `INTERNET`, no storage permissions, `allowBackup="false"`,
  `FileProvider` not exported. `INTERNET` is only in the `debug` and `profile` manifests
  (Flutter's default, needed for hot reload — allowed).
- `enableSplit = false`, `compilerOptions` (not `kotlinOptions`), `minSdk = 26`.
- `pubspec.yaml`: `material_ui` / `cupertino_ui` with `^`; no banned packages.
- Every `IconButton` / `FloatingActionButton` has a `tooltip:` (or `label:`).
- `.gitignore` covers `key.properties`, `*.jks`, `*.keystore`, `build/`, `.env`; only
  `key.properties.example` is tracked.
- `kReleaseMode` in `lib/main.dart` is only used for error display, not as a flavor — allowed.
- CI (`.github/workflows/ci.yml`) runs checks only.

## Issues found

### A. Hard-coded user-visible text (CLAUDE.md localization rules, standard §8.2)

| # | File | Text |
|---|---|---|
| A1 | `lib/features/settings/presentation/language_screen.dart` | Subtitle `'Auto'` under "System default". (The endonyms `English`, `മലയാളം`, `संस्कृतम्` are correct as they are — by rule they are shown in their own language.) |
| A2 | `lib/features/settings/presentation/printer_settings_screen.dart` | `'A4 (210 × 297 mm)'`, `'US Letter (8.5 × 11 in)'`, `'Legal (8.5 × 14 in)'` |
| A3 | `lib/features/extraction/presentation/widgets/extraction_dialog.dart` | `'Standard'` / `'High Quality'` (DPI hint) |
| A4 | `lib/features/extraction/presentation/widgets/text_preview_dialog.dart` | `'No text found.'` |
| A5 | `lib/features/viewer/presentation/viewer_screen.dart` | Signature overlay painted on the page: `'Signature valid'`, `'Signature valid, untrusted'`, `'Signature invalid'`, `'Signature could not be verified'`. The code comment says "always in English for document compliance", but the same overlay already uses a localized string for an unknown signer, so it is mixed. |
| A6 | `lib/features/page_ops/presentation/widgets/watermark_dialog.dart` | Default watermark text `'CONFIDENTIAL'` |

### B. Plan files with wrong or stale `Status:` values (workflow rule 1)

The allowed values are `draft`, `approval_pending`, `in_progress`, `completed`, `dropped`,
`partial_completion`. These plans use other words, and each already has a change log:

| Plan | Now | Change log that implements it | Fix |
|---|---|---|---|
| `plans/20260920_102000_adhere_project_structure_guidelines.md` | `Pending Approval` | `change_log/20260920_102600_adhere_project_structure_guidelines.md` | `completed` |
| `plans/20260920_110200_enforce_sanskrit_and_localized_app_config.md` | `Pending Approval` | `change_log/20260920_110200_enforce_sanskrit_and_localized_app_config.md` | `completed` |
| `plans/20260920_113500_adhere_to_guidelines.md` | `Proposed` | `change_log/20260920_115500_adhere_to_guidelines.md` | `completed` |
| `plans/20260920_133200_permissions_screen_accuracy.md` | `Proposed` | `change_log/20260920_133600_permissions_screen_accuracy.md` | `completed` |

I will open each change log first and confirm it really covers the whole plan. If not, I use
`partial_completion`.

### C. Absolute local path in a committed plan (workflow rule 3, standard §21.1.1)

`plans/20260919_235800_align_docs_with_guidelines.md` line 68 quotes a full drive-letter path
from this computer. Replace it with the relative name only (`myapps.md`). Line 12 also says
`L:\...`; change it to "a drive-letter path".

### D. `docs/workflow_rules.md` is behind `CLAUDE.md`

It lacks workflow rule 4 (guidelines submodule is read-only), rule 5 (CI is checks only) and the
"Security impact" line rule. Add them, in the same words as `CLAUDE.md`.

### E. Already known and still open — NOT part of this plan

- `docs/security.md` has no §1.1 Security Baseline table and no §3.1 Entry Points table
  (needed for the "ready for the stores" gate). This is the job of
  `plans/20261107_170947_security_baseline_and_kotlin_review.md` (still `draft`).
- Toolchain upgrade: `plans/20261107_171200_toolchain_upgrade_agp9_gradle9.md` is
  `in_progress` (files already show AGP 9.4.1, Gradle 9.8.0, Kotlin 2.4.10; device build not
  yet confirmed).
- Malayalam / Sanskrit print-service help texts that keep the English app name — follow-up from
  `change_log/20261107_172152_strict_guideline_compliance.md`.
- Privacy policy URL — `TODO` before the first Google Play release (`docs/PROJECT_PROFILE.md`).
- Minor, not fixed now: page numbers in `thumbnail_grid.dart` and the signature date are not
  formatted through `DisplayFormat` (standard §8.9). Both use Western digits, which is normal
  for Malayalam and Sanskrit UI today. I suggest leaving them.

## The fix

1. **A1–A4, A6:** add new ARB keys to `app_en.arb` (with `@key` descriptions), `app_ml.arb`
   and `app_sa.arb`, with real translations; run `flutter gen-l10n`; use them in the widgets.
   Proposed keys: `labelLanguageAuto`, `labelPaperA4`, `labelPaperLetter`, `labelPaperLegal`,
   `labelQualityStandard`, `labelQualityHigh`, `emptyExtractedText`, `labelWatermarkDefault`.
   Short labels stay inside the length budget (20 / 22).
   The paper-size internal values (`'A4'`, `'Letter'`, `'Legal'`) stay as they are — they are
   stored keys, not UI text.
2. **A5 (needs your decision):** either
   - (a) localize the four overlay strings (new keys `labelSigOverlayValid`,
     `labelSigOverlayUntrusted`, `labelSigOverlayInvalid`, `labelSigOverlayUnknown`) — my
     recommendation, because the rule allows no exception and the overlay is only drawn on screen,
     not written into the PDF; or
   - (b) keep English on purpose, and record the exception and its reason in
     `docs/architecture.md`.
3. **B:** update the four `Status:` lines.
4. **C:** remove the absolute path from the old plan.
5. **D:** add the missing rules to `docs/workflow_rules.md`.
6. Run `dart format .`, `flutter analyze`, `flutter test` (parity and label-length tests
   included). Then write the change log.

## Files to change

- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` (and the generated
  `lib/l10n/app_localizations*.dart`)
- `lib/features/settings/presentation/language_screen.dart`
- `lib/features/settings/presentation/printer_settings_screen.dart`
- `lib/features/extraction/presentation/widgets/extraction_dialog.dart`
- `lib/features/extraction/presentation/widgets/text_preview_dialog.dart`
- `lib/features/page_ops/presentation/widgets/watermark_dialog.dart`
- `lib/features/viewer/presentation/viewer_screen.dart` (only if option A5-a)
- `docs/architecture.md` (only if option A5-b)
- `plans/20260920_102000_adhere_project_structure_guidelines.md`,
  `plans/20260920_110200_enforce_sanskrit_and_localized_app_config.md`,
  `plans/20260920_113500_adhere_to_guidelines.md`,
  `plans/20260920_133200_permissions_screen_accuracy.md` (status line only)
- `plans/20260919_235800_align_docs_with_guidelines.md` (remove local path)
- `docs/workflow_rules.md`
- New: `change_log/<timestamp>_guideline_audit_fixes.md`

**Security impact:** none. No permissions, storage, network, platform or dependency change.

## Translations

All new Malayalam and Sanskrit strings will be flagged "needs native-reader review" in the
change log.
