# Plan: Name every tool's output after the original file

**Status:** completed

## The issue

Signing now names its output after the original
(`EliteHub_Invoice_signed_20261115_143205.pdf`). The other tools still use a word plus raw
milliseconds, so the Save dialog suggests names such as `merged_1794724698861.pdf` or
`watermarked_1794724698861.pdf`. The user can't tell which document a file came from.

Where the names come from today:

| Tool | Today's name | Where |
|---|---|---|
| Merge, organize, compress, protect, unlock, trim margins, booklet, watermark, N-up | `<word>_<ms>.pdf` | `PageOpsService._outputPath` |
| Split | `<ms>_<ascii name>_page_<n>.pdf` (the private copy's name: it has a time prefix, and Malayalam letters became `_`) | `PdfBoxHandler.kt` `splitPdf` |
| Batch: encrypt, trim, compress | same as the single tools | `PageOpsService.runBatchOperation` |
| Batch: extract text | `extracted_<name with .pdf>_<ms>.txt` (not cleaned) | `PageOpsService.runBatchOperation` |
| Export annotated copy | file `annotated_<ms>.pdf`; Save suggests `annotated_<name>.pdf` | `AnnotationRepository._outputPath`, `viewer_screen.dart` |
| Images / text → PDF (share into Folio) | `<ascii name>_<ms>.pdf` | `PdfBuilderService.outputPath` |

The services never get the original's name. They only get the private copy's path, and
that copy's name is changed (time prefix, non-English letters replaced).

## The fix

**1. One shared helper.** Move `SignedFileName` from `sign_document/domain/` to
`lib/core/files/output_file_name.dart` as `OutputFileName`:

- `baseOf(displayName)`: the same cleaning as today (remove `.pdf`, replace unsafe
  characters, trim, at most 100 characters, fall back to `document`).
- `build(displayName, now, {String? action, String extension = 'pdf', int copy = 1})`
  gives `<base>_<action>_<yyyyMMdd_HHmmss>[_<copy>].<extension>`. With no action it gives
  `<base>_<yyyyMMdd_HHmmss>`.
- `uniquePath(dir, displayName, now, {action, extension})`: the "add `_2`, `_3`" loop, now
  shared, so no tool overwrites an earlier output made in the same second.

**2. Pass the original's name to every tool.**

- `PageOpsService`: every method that writes a file takes `displayName`. Merge uses the
  open document's name (it always comes first).
- The viewer passes `docRef.displayName` to `showPageOpsSheet`. The sheet passes it on to
  `WatermarkDialog`, `NUpDialog`, `SmartTrimDialog`, `BookletDialog`,
  `OrganizePagesScreen`, `ProtectDialog` and `UnlockDialog`.
- The print sheet already has the name (`jobName`). It passes it to `NUpDialog` and the
  print service.
- Batch uses each document's own `displayName`.
- Annotation export: `exportAnnotatedCopy` takes `displayName`. The viewer's Save suggestion
  uses the new file's own name (one source of truth).
- Images / text → PDF: use the helper with no action word, so Malayalam names are kept
  too.

**3. Split (Kotlin).** `splitPdf` gets an optional `baseName` argument. Dart sends the
cleaned base, and Kotlin falls back to today's name when it is missing. Each split writes
into its own new subfolder, so `<base>_page_<n>.pdf` from two runs can't overwrite each
other. Page numbers get leading zeros (`_page_01`) when the document has 10 or more pages,
so the files sort in the right order.

**Action words** (one per tool, ASCII, English):
`merged`, `organized`, `compressed`, `protected`, `unlocked`, `trimmed`, `booklet`,
`watermarked`, `<n>up` (for example `4up`), `annotated`, `signed`, `text`.

## Decision for the user: should the action words be translated?

*Decided: keep them in English (user approved the plan as written).*

My suggestion: **keep them in English** in every app language.
- File names travel. They go to email, WhatsApp, PCs and cloud drives, where a fixed word
  is easier to recognise and search.
- Some storage places and old PCs still handle non-English file names badly. The
  document's own name stays as it is (Malayalam is kept); only the short added word is
  fixed.
- The downside: a Malayalam or Sanskrit user sees one English word in the file name.

The other choice is localized words from the ARB files (for example `ഒപ്പിട്ടത്`).

## Files to change

New:
- `lib/core/files/output_file_name.dart` (moved from
  `lib/features/sign_document/domain/signed_file_name.dart`, which is deleted)
- `test/core/files/output_file_name_test.dart` (moved from the sign test, plus action,
  extension and `uniquePath` cases)

Changed:
- `lib/features/sign_document/data/sign_document_service.dart`: uses the shared helper
- `lib/features/page_ops/data/page_ops_service.dart`: `displayName` on every writer, batch,
  extract text
- `lib/features/page_ops/presentation/page_ops_sheet.dart` and `widgets/booklet_dialog.dart`,
  `organize_pages_screen.dart`, `protect_dialog.dart`, `smart_trim_dialog.dart`,
  `unlock_dialog.dart`, `watermark_dialog.dart`
- `lib/features/printer/presentation/widgets/n_up_dialog.dart`, `print_sheet.dart`,
  `lib/features/printer/data/print_service.dart`, `pdf_builder_service.dart`
- `lib/features/annotation/data/annotation_repository.dart`,
  `presentation/annotation_controller.dart`
- `lib/features/viewer/presentation/viewer_screen.dart`: passes the name, and the
  annotated Save suggestion
- `lib/core/platform/pdfbox_channel.dart`: `splitPdf` takes `baseName`
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`: `splitPdf` takes
  `baseName`, writes into a per-run subfolder, adds leading zeros
- Tests: `page_ops_service_test.dart`, `page_ops_service_enhancements_test.dart`, the dialog
  tests (`booklet`, `organize_pages`, `smart_trim`, `watermark`), the printer and annotation
  tests that call these methods, and the sign service test
- `docs/features.md` (one line under copy-on-write), `CHANGELOG.md`

No new strings, so no ARB change (if the action words stay in English).

## Security impact

- No new permission, storage location or network use.
- The display name comes from outside the app, so it is always cleaned before use, and a
  name such as `../x.pdf` can't leave the output folder. This also cleans the batch text
  file name, which isn't cleaned today.
- Platform folder: `PdfBoxHandler.kt` changes (an optional argument and a subfolder only).

## Checks

- `dart format .`, `flutter analyze` (0 issues), `flutter test`.
- The Kotlin change is compiled when the user runs the dev build.
- On the phone: run each tool once on `EliteHub_Invoice.pdf` and check the name the Save
  dialog suggests, plus split on a file with 10 or more pages.
- After the Gradle build: `android\gradlew --stop` and check that no daemons are left.
