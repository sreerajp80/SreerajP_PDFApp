# Change Log: Fix Duplicate Localization Keys

**Date:** 2026-08-20
**Plan Reference:** `plans/20260820_202600_fix_duplicate_l10n_keys.md`

## 1. Summary of Changes
- Resolved duplicate `unlockAction` key conflict between PDF viewer password prompt ("Unlock" / "തുറക്കുക") and page operations ("Remove password" / "പാസ്‌വേഡ് നീക്കുക").
- Renamed the page operations key to `removePasswordAction` and updated references in `lib/features/page_ops/presentation/page_ops_sheet.dart` and `lib/features/page_ops/presentation/widgets/unlock_dialog.dart`.
- Removed redundant duplicate keys for `signatureSignerUnknown`, `signatureReasonLabel`, and `signatureLocationLabel` from `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`.
- Regenerated localizations with `flutter gen-l10n`.

---

## 2. Files Modified
- `lib/l10n/app_en.arb`: Renamed page ops `unlockAction` to `removePasswordAction`; removed duplicate signature keys.
- `lib/l10n/app_ml.arb`: Renamed page ops `unlockAction` to `removePasswordAction`; removed duplicate signature keys.
- `lib/features/page_ops/presentation/page_ops_sheet.dart`: Updated `l10n.unlockAction` to `l10n.removePasswordAction`.
- `lib/features/page_ops/presentation/widgets/unlock_dialog.dart`: Updated `l10n.unlockAction` to `l10n.removePasswordAction`.

---

## 3. Verification
- Regenerated localization files (`flutter gen-l10n`).
- `flutter analyze` completed with 0 errors / warnings.
- `flutter test` passed with all 390 unit and widget tests passing.
