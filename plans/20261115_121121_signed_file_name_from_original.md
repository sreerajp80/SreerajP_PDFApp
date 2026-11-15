# Plan: Name the signed PDF after the original file

**Status:** completed

## The issue

After signing `EliteHub_Invoice.pdf`, the Save dialog suggests `signed_1794724698861.pdf`.
The number is a raw millisecond time stamp, and the original name is lost, so the user
cannot tell which document the signed copy belongs to.

Cause: `SignDocumentService.sign()` builds the output name as
`signed_<milliseconds>.pdf`. The Save dialog (`PageOpsResultDialog`) suggests the last
part of the output path as the file name. The sign flow never receives the original
file's display name.

## The fix

Name the output `<original name>_signed_<yyyyMMdd_HHmmss>.pdf`, for example
`EliteHub_Invoice_signed_20261115_143205.pdf`.

- `_signed` shows which copy is signed. The readable local time keeps every copy unique and
  sorts well in a file manager.
- New pure helper `SignedFileName.build(displayName, now)` in the domain layer:
  - removes a trailing `.pdf` (any case),
  - replaces characters that are not safe in file names (`\ / : * ? " < > |` and control
    characters) with `_`, and trims spaces and dots,
  - limits the base to 100 characters (Android file names max out at 255 bytes, and
    Malayalam letters take 3 bytes each),
  - falls back to `document` when nothing is left.
- If a file with that name already exists in the temp `signed/` folder (two signs in the
  same second), add `_2`, `_3`, and so on.
- Pass the original display name from the viewer: `startSignFlow(..., displayName:)` →
  `SignRequest.displayName` → `service.sign(..., displayName:)`.

No change to the Save dialog. It already suggests the output file's name.

## Files to change

- `lib/features/sign_document/domain/signed_file_name.dart` (new): the pure helper
- `lib/features/sign_document/data/sign_document_service.dart`: use the helper, takes
  `displayName`
- `lib/features/sign_document/presentation/sign_flow.dart`: new `displayName` parameter
- `lib/features/sign_document/presentation/sign_placement_screen.dart`:
  `SignRequest.displayName`, passed on to `sign()`
- `lib/features/viewer/presentation/viewer_screen.dart`: passes
  `widget.docRef.displayName`
- `test/features/sign_document/domain/signed_file_name_test.dart` (new): plain name,
  `.PDF` case, unsafe characters, Malayalam name, very long name, empty name
- `test/features/sign_document/data/sign_document_service_test.dart`: checks the output name
  and the `_2` suffix
- `docs/features.md` §2.7a: one line about the output name
- `CHANGELOG.md`: one line

No new strings, so no ARB change.

## Not in this plan (needs a decision)

**"Save into the same PDF" (overwrite the original).** *Dropped by the user: the
original is never replaced.* This breaks hard rule 5
(copy-on-write: the original is never modified in place). It also does not work today:
the app opens files with **read-only** access, and files from "Open with" are usually
read-only anyway. If the user wants this, it is a separate plan that changes the project
rule (CLAUDE.md, AGENTS.md, .agents/AGENTS.md, features.md, security.md) and asks for
write access.

**Other page tools** (`merged_…`, `organized_…`, `watermarked_…`, `annotated_…`) have the
same naming problem. They can use the same helper in a follow-up.

## Security impact

None. No new permission, storage location, or network use. The file name comes from the
document's display name, so it is cleaned before use, which also stops path tricks such as
`../`.

## Checks

- `dart format .`, `flutter analyze` (0 issues), `flutter test`.
- On the phone: sign `EliteHub_Invoice.pdf`, tap Save, and check the suggested name.
