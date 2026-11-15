# Change log: Name the signed PDF after the original file

**Plan:** [plans/20261115_121121_signed_file_name_from_original.md](../plans/20261115_121121_signed_file_name_from_original.md)

## What changed (user's view)

A signed copy used to be called `signed_1794724698861.pdf`. It is now named after the
original file with `_signed_` and the local date and time added:
`EliteHub_Invoice.pdf` → `EliteHub_Invoice_signed_20261115_143205.pdf`. The Save dialog
suggests this name.

## Files

New:
- `lib/features/sign_document/domain/signed_file_name.dart`: `SignedFileName`, a pure helper.
  It removes `.pdf` (any case), replaces characters not allowed in file names (and control
  characters) with `_`, trims spaces and dots at the ends, keeps at most 100 characters,
  falls back to `document`, and adds `_2`, `_3`, … for extra copies made in the same second.
- `test/features/sign_document/domain/signed_file_name_test.dart`

Changed:
- `lib/features/sign_document/data/sign_document_service.dart`: `sign()` takes
  `displayName` and uses the helper. If a file of that name already exists, it adds a copy
  number. It has an injectable clock for tests.
- `lib/features/sign_document/presentation/sign_flow.dart`,
  `sign_placement_screen.dart` (`SignRequest.displayName`),
  `lib/features/viewer/presentation/viewer_screen.dart`: pass the open document's display
  name down to the service.
- `test/features/sign_document/data/sign_document_service_test.dart`: checks the exact
  output name, plus a new test for the `_2` copy number.
- `docs/features.md` §2.7a and `CHANGELOG.md`: describe the new name. The Sign entry in
  the changelog is not released yet, so I edited it instead of adding a new line.

## Differences from the plan

- None in the code.
- "Save into the same PDF" was discussed and **dropped by the user**. The original file is
  never replaced (hard rule 5 stays as it is).

## Checks

- `dart format`: clean.
- `flutter analyze`: no issues.
- `flutter test`: all 657 tests pass.
- Not yet checked on a device: the name the Save dialog suggests.

## Security impact

None. No new permission, storage location or network use. The display name is cleaned
before it becomes a file name, so a name such as `../x.pdf` cannot point outside the
output folder.

## Possible follow-up

The other tools still use names like `merged_<ms>.pdf`, `organized_<ms>.pdf`,
`watermarked_<ms>.pdf` and `annotated_<ms>.pdf`. They could reuse the same naming idea.
