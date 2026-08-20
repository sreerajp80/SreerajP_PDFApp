# Implementation Plan: Fix Duplicate Localization Keys

**Status:** Proposed
**Date:** 2026-08-20

## 1. Overview
Static analysis identified duplicate keys in `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`:
1. `unlockAction`:
   - Line 96 in `lib/l10n/app_en.arb` / Line 54 in `lib/l10n/app_ml.arb`: Viewer password dialog confirmation ("Unlock" / "തുറക്കുക").
   - Line 368 in `lib/l10n/app_en.arb` / Line 190 in `lib/l10n/app_ml.arb`: Page operations action to remove password ("Remove password" / "പാസ്‌വേഡ് നീക്കുക").
   - **Fix**: Rename the page operations key to `removePasswordAction` and update references in `lib/features/page_ops/presentation/page_ops_sheet.dart` and `lib/features/page_ops/presentation/widgets/unlock_dialog.dart`.
2. Redundant duplicate signature keys:
   - `signatureSignerUnknown`: Defined in line 611 ("Unknown Signer" / "അജ്ഞാത ഒപ്പ് ദാതാവ്") and duplicated at line 1371 in `lib/l10n/app_en.arb` / line 630 in `lib/l10n/app_ml.arb`.
   - `signatureReasonLabel`: Defined in line 615 ("Reason" / "കാരണം") and duplicated at line 1373 in `lib/l10n/app_en.arb` / line 631 in `lib/l10n/app_ml.arb`.
   - `signatureLocationLabel`: Defined in line 617 ("Location" / "സ്ഥലം") and duplicated at line 1375 in `lib/l10n/app_en.arb` / line 632 in `lib/l10n/app_ml.arb`.
   - **Fix**: Remove the duplicate blocks at lines 1371–1376 in `lib/l10n/app_en.arb` and lines 630–632 in `lib/l10n/app_ml.arb`, while keeping their canonical definitions.

---

## 2. Files to Modify

### Modified Files
- `lib/l10n/app_en.arb`: Rename duplicate `unlockAction` to `removePasswordAction`; remove duplicate signature keys.
- `lib/l10n/app_ml.arb`: Rename duplicate `unlockAction` to `removePasswordAction`; remove duplicate signature keys.
- `lib/features/page_ops/presentation/page_ops_sheet.dart`: Update `l10n.unlockAction` reference to `l10n.removePasswordAction`.
- `lib/features/page_ops/presentation/widgets/unlock_dialog.dart`: Update `l10n.unlockAction` reference to `l10n.removePasswordAction`.

---

## 3. Verification Plan
- Run `flutter gen-l10n` to regenerate localization classes.
- Run `flutter analyze` to ensure 0 errors/warnings.
- Run `flutter test` to ensure all existing unit and widget tests pass.
