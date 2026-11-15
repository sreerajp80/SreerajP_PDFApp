# Change log: Name every tool's output after the original file

**Plan:** [plans/20261115_140452_output_file_names_from_original.md](../plans/20261115_140452_output_file_names_from_original.md)

## What changed (user's view)

New files are named after the document they came from, plus a short word for the tool and
the local date and time:

| Tool | Before | Now |
|---|---|---|
| Merge | `merged_1794724698861.pdf` | `Invoice_merged_20261115_143205.pdf` |
| Organize, compress, protect, unlock, trim, booklet, watermark | `<word>_<ms>.pdf` | `Invoice_<word>_<date_time>.pdf` |
| N-up | `nup_<ms>.pdf` | `Invoice_4up_<date_time>.pdf` |
| Split | `1794724698861_Invoice_page_1.pdf` | `Invoice_page_01.pdf` … (in a folder for this run) |
| Batch extract text | `extracted_Invoice.pdf_<ms>.txt` | `Invoice_text_<date_time>.txt` |
| Export annotated copy | `annotated_<ms>.pdf` (Save suggested `annotated_Invoice.pdf`) | `Invoice_annotated_<date_time>.pdf` |
| Images / text → PDF | `<ascii name>_<ms>.pdf` | `<name>_<date_time>.pdf` |
| Sign | (already done) | `Invoice_signed_<date_time>.pdf` |

Malayalam document names are now kept instead of turning into underscores. The added words
stay in English in every language (user's decision).

## Files

New:
- `lib/core/files/output_file_name.dart`: `OutputFileName` (`baseOf`, `stampOf`, `build`,
  `uniquePath`). It replaces `lib/features/sign_document/domain/signed_file_name.dart`,
  which is deleted.
- `test/core/files/output_file_name_test.dart`: replaces the sign-only test, and adds
  action, extension and `uniquePath` cases.

Changed:
- `lib/features/page_ops/data/page_ops_service.dart`: every writer takes `displayName`.
  Split writes into its own `split_<time>/` subfolder and sends `baseName`. Batch passes
  each document's name. Extract text uses the helper (the name was not cleaned before).
- `lib/features/page_ops/presentation/page_ops_sheet.dart` and the dialogs
  (`booklet_dialog`, `organize_pages_screen`, `protect_dialog`, `smart_trim_dialog`,
  `unlock_dialog`, `watermark_dialog`): carry `displayName`.
- `lib/features/printer/presentation/widgets/n_up_dialog.dart`: uses `jobName` (the
  document's name) for the file. The page tools sheet used to pass `'document_nup'`.
- `lib/features/printer/data/print_service.dart`: passes `jobName`.
  `lib/features/printer/data/pdf_builder_service.dart`: uses the helper.
- `lib/features/annotation/data/annotation_repository.dart`,
  `presentation/annotation_controller.dart`: `displayName` for the export.
- `lib/features/viewer/presentation/viewer_screen.dart`: passes the name to page tools and
  the export. The annotated Save suggestion is now the new file's own name.
- `lib/features/sign_document/data/sign_document_service.dart`: uses the shared helper.
- `lib/core/platform/pdfbox_channel.dart`: `splitPdf` takes an optional `baseName`.
- `android/.../PdfBoxHandler.kt`: `splitPdf` takes `baseName` and cleans it again (so a bad
  name can't leave the output folder). It falls back to the old name when `baseName` is
  missing, and pads page numbers with zeros when the document has 10 or more pages.
- Tests: `page_ops_service_test.dart`, `page_ops_service_enhancements_test.dart`,
  `booklet_dialog_test.dart`, `smart_trim_dialog_test.dart`,
  `organize_pages_screen_test.dart`, `watermark_dialog_test.dart`,
  `pdf_builder_service_test.dart` (spaces in shared names are now kept).
- `docs/features.md` (copy-on-write line), `CHANGELOG.md`.

## Differences from the plan

- None in scope.
- The plan said the sign service test would change. It needed no change, because the
  service still produces the same name through the shared helper.

## Checks

- `dart format`: clean.
- `flutter analyze`: no issues.
- `flutter test`: all 659 tests pass.
- Kotlin was **not compiled** (no Gradle build was run). The change uses only standard
  Kotlin (`padStart`, `Regex`, `trim`).
- Not yet checked on a device: the suggested names in the Save dialog for each tool, and
  split on a document with 10 or more pages.

## Security impact

No new permission, storage location or network use. The display name comes from outside
the app, so it is cleaned in Dart and cleaned again in Kotlin for split. The batch text
file name, which was not cleaned before, now is.
