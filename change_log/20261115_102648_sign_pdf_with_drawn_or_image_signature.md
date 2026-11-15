# Change log: Sign a PDF with a drawn or imported signature

**Plan:** [plans/20261115_100454_sign_pdf_with_drawn_or_image_signature.md](../plans/20261115_100454_sign_pdf_with_drawn_or_image_signature.md)

## What changed (user's view)

- New **Sign** item in the viewer menu. It opens **My signatures**: saved signatures, plus
  **Draw new** and **Import image**. A note says this adds a picture of a signature, not a
  digital (certificate) signature.
- **Draw new**: a signature pad with three dark inks, three pen sizes, Undo and Clear.
- **Import image**: PNG / JPEG / WebP through the system picker, with a **Remove background**
  switch (on by default) that makes light paper see-through.
- **Place signature**: drag to move, drag the corner to resize (shape kept, box stays on the
  page), page arrows, **Add here** for more copies, **Done** writes a new signed PDF and shows
  the usual Open / Save / Share dialog. The original file is never changed.
- If the PDF already has digital signatures, a warning explains the new copy will show them
  as broken. Locked PDFs ask for the password when needed.

## Files

New:
- `lib/features/sign_document/domain/` — `saved_signature.dart`, `signature_placement.dart`,
  `placement_geometry.dart`, `signature_image_tools.dart`
- `lib/features/sign_document/data/` — `saved_signature_dao.dart`,
  `saved_signature_repository.dart`, `signature_image_codec.dart`, `sign_document_service.dart`
- `lib/features/sign_document/presentation/` — `providers.dart`, `my_signatures_sheet.dart`,
  `sign_flow.dart`, `signature_pad_screen.dart`, `import_signature_screen.dart`,
  `sign_placement_screen.dart`, `widgets/placement_box.dart`, `widgets/checkerboard.dart`
- Tests: `test/core/storage/migration_v5_test.dart`,
  `test/features/sign_document/domain/{placement_geometry,signature_image_tools,saved_signature}_test.dart`,
  `test/features/sign_document/data/{saved_signature_repository,sign_document_service}_test.dart`,
  `test/features/sign_document/presentation/sign_document_widgets_test.dart`

Changed:
- `lib/core/storage/migrations.dart` — migration **v5** `saved_signatures` (append-only).
- `lib/core/constants/app_constants.dart` — `databaseVersion = 5`, table and folder names.
- `lib/core/errors/app_exception.dart` — new `ImageReadException`.
- `lib/core/storage/app_data_purge_service.dart` — clears `saved_signatures` and runs
  private-file clean-ups (the signature folder) on "Delete all data".
- `lib/core/storage/cache_service.dart` — `signed/` added to the working folders cleaned up.
- `lib/core/platform/pdfbox_channel.dart` — `stampImages`.
- `lib/core/platform/open_document_channel.dart` — `pickImage`.
- `android/.../PdfBoxHandler.kt` — `stampImages`: draws the PNG into page content with
  `LosslessFactory` (keeps see-through parts), using the crop box and `/Rotate` so the box
  lands where it was placed and reads upright. Each picture is decoded once per run.
- `android/.../MainActivity.kt` — `pickImage` (`ACTION_OPEN_DOCUMENT`, images only, read-only,
  no persistable permission).
- `lib/features/viewer/presentation/viewer_screen.dart` — **Sign** menu item.
- `lib/features/settings/presentation/providers.dart` — passes the signature folder clean-up
  to the purge service.
- `lib/app/routing/app_router.dart` — routes `signaturePad`, `importSignature`, `signPlacement`.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — 38 new keys in all three languages.
- `test/core/storage/migration_v4_test.dart` — version check now uses `databaseVersion`.
- `test/core/storage/app_data_purge_service_test.dart` — seeds `saved_signatures`; new test
  for the private-file clean-ups.
- `docs/features.md` (§2.7a), `docs/architecture.md` (folder, schema v5, models),
  `docs/security.md` (sensitive data inventory, SAF note), `CHANGELOG.md`.

## Differences from the plan

- **Placement screen widget test not written.** `PdfPageView` needs the native pdfium library,
  which is not available in widget tests. The placement math is fully covered by
  `placement_geometry_test.dart`, and widget tests cover the My signatures sheet and the
  drawing pad (all three languages, phone size, tooltips). The placement screen must be checked
  by hand on a device.
- **Help screen not changed.** The help screens are topic pages, not a feature list; a short
  note lives in the My signatures sheet itself. A help topic can be added later.
- **Pixel format detail found while building.** Flutter reads raw pixels as *premultiplied*
  alpha, so the codec reads straight alpha and premultiplies before PNG encoding. Without this,
  soft pen edges would get light halos.
- The English warning title is "Digital signatures" (the first wording was over the 20
  character label limit).

## Checks

- `flutter gen-l10n` — done.
- `dart format` — clean.
- `flutter analyze` — no issues.
- `flutter test` — all 648 tests pass.
- Kotlin was **not compiled** in this change (no Gradle build was run). The PdfBox-Android
  2.0.27.0 methods used (`drawImage(PDImageXObject, Matrix)`, `Matrix(6 floats)`,
  `getCropBox`, `getRotation`) were checked in the library's class list.
- Not yet tested on a device: drawing, importing a photo, placing on a rotated page, a locked
  PDF, a PDF that already has a digital signature, and a damaged picture file.

## Security impact

No new permission, no network, no new dependency. Signature pictures are personal data: kept
only in app-private files, never logged, not backed up, not sent by Device sync, removed by
"Delete all data". Picked pictures are untrusted input with size and pixel limits.

## Translations to review

New Malayalam and Sanskrit strings should be read by a native reader, especially:
- Sanskrit `descSignNotDigital` / `bodyExistingSignatures` / `titleExistingSignatures`
  (`अङ्कीयहस्ताक्षर` for "digital signature"), `descRemoveBackground` (`मसी` for ink),
  `actionDrawSignature` (`लिख्यताम्` for "draw").
- Malayalam `descRemoveBackground`, `bodyExistingSignatures`, and `descSignaturePreview`
  (uses the loanword `പ്രിവ്യൂ`).

## Possible follow-ups

- The older **Export annotated copy** uses the media box and ignores `/Rotate`, so marks on a
  rotated or cropped page may land in the wrong place. The new stamping code shows the fix.
- Optional name / date text next to the signature; "put on every page" in one tap.
