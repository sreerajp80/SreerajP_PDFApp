# Change log — Guidelines Phase 2: user-safe error messages

Implements Phase 2 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(finding F3).

## What changed

While doing this phase I found a second form of the same problem: 12 places showed
`AppException.message` to the user. That text is English developer text written in the data
layer, so it also broke "services must not decide UI copy" (§4.2) and "no English under another
language" (§8.7). Both forms are fixed here.

- New `lib/core/errors/user_error_message.dart` — `userErrorMessage(l10n, error, fallback:)`
  maps known error types (locked, damaged, empty PDF; unsupported letters; print; signature check;
  bad certificate) to their localized message. Anything else gets the `fallback`, which names the
  action that failed. Raw exception text never reaches the screen (§11.2).
- Raw `'${l10n.opFailed}: $e'` style text removed from: `extraction_dialog.dart`,
  `page_ops_sheet.dart`, `booklet_dialog.dart`, `organize_pages_screen.dart`,
  `page_ops_result_dialog.dart`, `protect_dialog.dart`, `smart_trim_dialog.dart`,
  `unlock_dialog.dart`, `watermark_dialog.dart`, `n_up_dialog.dart`. Each catch now logs the
  detail with `AppLogger.error` (with stack trace) and shows only the safe message.
- `e.message` / `error.message` no longer shown in: `import_screen.dart`, `print_sheet.dart`,
  `trust_store_screen.dart`, `signature_detail_sheet.dart`, `home_screen.dart`,
  `watermark_dialog.dart`, `n_up_dialog.dart`.
- In `watermark_dialog.dart` and `n_up_dialog.dart` the two duplicate catch blocks were merged
  into one.
- "Try again" SnackBar actions added where the action can simply be run again (§11.4): page-op
  runner, organize save, result-dialog save, watermark, N-up (save and print), import save,
  certificate export (one, all, and from the signature sheet).
- New ARB keys (en, ml, sa): `errorInvalidCertificate`, `errorCertificateExport`,
  `errorTrustStoreLoad`, `errorImportBuild`. The trust-store load error now says it could not
  load the list, instead of the "no certificates yet" empty text.
- Imports sorted in the edited files.

## Tests

- New: `test/core/errors/user_error_message_test.dart` — every known type in en, ml, sa; unknown
  errors and `StorageException` never leak their raw text.
- Changed: `test/features/printer/presentation/import_screen_test.dart` — the build-failure test
  used to expect the raw platform text ("disk full") on screen. It now expects the friendly detail
  and checks the raw text is **not** shown.
- `dart format`: clean. `flutter analyze`: no issues. `flutter test`: 433 passed.

## Needs native-reader review

- `errorInvalidCertificate` — ml "ഈ ഫയൽ ആപ്പിന് വായിക്കാൻ കഴിയുന്ന ഒരു സർട്ടിഫിക്കറ്റ് അല്ല." ·
  sa "इयं सञ्चिका अनेन अनुप्रयोगेन पठनीयं प्रमाणपत्रं नास्ति।"
- `errorCertificateExport` — ml "സർട്ടിഫിക്കറ്റ് എക്സ്പോർട്ട് ചെയ്യാൻ കഴിഞ്ഞില്ല." · sa "प्रमाणपत्रं निर्यातयितुं न शक्तम्।"
- `errorTrustStoreLoad` — ml "വിശ്വസിച്ച സർട്ടിഫിക്കറ്റുകൾ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല." · sa "विश्वस्तानि प्रमाणपत्राणि आनेतुं न शक्तानि।"
- `errorImportBuild` — ml "PDF ഉണ്ടാക്കുന്നതിനിടെ ഒരു പിശക് സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക." ·
  sa "PDF निर्माणकाले दोषः सञ्जातः। पुनः प्रयत्यताम्।"
