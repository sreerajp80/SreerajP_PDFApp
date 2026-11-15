# Plan: Sign a PDF with a drawn or imported signature

**Status:** completed

## The issue (what users want)

Users want to put their own signature on a PDF. They should be able to:

1. **Draw** the signature on the screen with a finger or stylus, or
2. **Import a picture** of their signature (a photo or scan),

and then **place** it anywhere on any page, at any size, and get a signed PDF.

Today the app can only **check** digital (certificate) signatures (`lib/features/signature/`).
It has no way to add a visible handwritten signature.

## Decisions already made (with the user)

- **Separate "Sign" flow**, not a new annotation type. The user places the signature, taps
  **Done**, and the app writes a **new signed PDF** at once (copy-on-write). Nothing about the
  placement is kept in the `annotations` table.
- **Saved signatures list.** Drawn or imported signatures are kept in app-private storage so
  they can be reused on other PDFs. The user can delete them.

## How it will work (user's view)

1. In the viewer, the overflow menu gets a new item **Sign** (pen icon).
2. A **"My signatures"** sheet opens. It shows saved signatures as thumbnails, plus two
   buttons: **Draw new** and **Import image**. A short line says: "This adds a picture of
   your signature. It is not a digital (certificate) signature."
3. **Draw new** opens a full-screen signature pad: ink color (black / blue / dark red), pen
   thickness, **Undo**, **Clear**, **Save**. Works in portrait and landscape.
4. **Import image** opens the **system picker** (Storage Access Framework) for PNG / JPEG /
   WebP. After picking, a preview shows with a **"Remove white background"** switch (on by
   default) so a photo of ink on paper becomes a clean, see-through signature. **Save**.
5. Tapping a saved signature opens the **placement screen**: the current page is shown, the
   signature appears in the middle as a box that can be **dragged** and **resized** (corner
   handle, keeps its shape). Page arrows move between pages. **Add another** puts the
   signature on more places / pages. Each placed box has a small remove (×) button.
6. **Done** writes a new PDF and shows the usual result dialog (Open / Save to device /
   Share), the same `PageOpsResultDialog` used by page tools.
7. If the PDF **already has digital signatures**, a warning shows before saving: the new copy
   will show those digital signatures as broken, because the file content changes. The
   original file is never changed.

## Design (developer's view)

New feature folder `lib/features/sign_document/` (separate from `signature/`, which is
verification only):

```
lib/features/sign_document/
  domain/
    saved_signature.dart          # immutable model: id, fileName, widthPx, heightPx, source (drawn/imported), createdAt
    signature_placement.dart      # immutable: page (1-based), normalized Rect (0–1, top-left origin)
    placement_geometry.dart       # pure math: clamp box inside page, keep aspect ratio on resize, min/max size
    signature_image_tools.dart    # pure functions: trim transparent edges, remove near-white background, downscale
  data/
    saved_signature_dao.dart      # SQL for the new table
    saved_signature_repository.dart  # owns the private folder + DAO; save PNG bytes, list, delete (file + row)
    sign_document_service.dart    # builds output path, calls native stamp, maps errors
  presentation/
    providers.dart
    my_signatures_sheet.dart
    signature_pad_screen.dart     # drawing pad (CustomPainter, exported to PNG with transparent background)
    import_signature_screen.dart  # preview + "remove white background" switch
    sign_placement_screen.dart    # PdfPageView + draggable/resizable boxes
    widgets/placement_box.dart
```

**Storage of saved signatures**
- PNG files in the app's private files folder, subfolder `my_signatures/` (not cache, so the
  system does not clear them). Only the repository knows this path.
- New SQLite table via **migration v5** `saved_signatures` (`id`, `file_name`, `width_px`,
  `height_px`, `source`, `created_at`). Append-only migration; v1–v4 are not touched.
- On load, a row whose file is missing is removed quietly (never a broken thumbnail).

**Importing an image (native)**
- New method `pickImage` in `MainActivity.kt`, built like `pickCertificate`:
  `ACTION_OPEN_DOCUMENT`, MIME types `image/png`, `image/jpeg`, `image/webp`, read-only grant
  (no persistable permission needed — we copy the bytes once). The copy goes to the cache and
  is deleted after the PNG is saved.
- The picked file is treated as untrusted: decoded with `dart:ui` in a try/catch; a corrupt,
  empty or huge file shows a friendly error. Images are downscaled to at most 1200 px on the
  long side before saving.

**Writing the signed PDF (native)**
- New method `stampImages` in `PdfBoxHandler.kt`:
  input `path`, `password`, `outputPath`, list of `{page, x, y, w, h, imagePath}` (normalized).
- Uses `LosslessFactory.createFromImage` from a decoded `Bitmap` so the transparent background
  is kept, and draws with `PDPageContentStream` in `APPEND` mode (same pattern as
  `exportAnnotations`).
- Uses the page's **crop box** (what the viewer shows) and handles pages with `/Rotate`
  90/180/270, so the signature lands exactly where the user put it and is upright. (The
  existing export uses the media box and ignores rotation; I will not change that code here,
  but I will note it in the change log as a possible follow-up.)
- Each image file is decoded once and reused if placed many times.
- Errors map to the same codes as other operations (`password_required`, `op_failed`, out of
  memory). Output goes to the page-ops output folder via a `_outputPath('signed')`-style helper.
- Dart side: a new `stampImages(...)` method in `lib/core/platform/pdfbox_channel.dart`, and
  `pickImage()` in `lib/core/platform/open_document_channel.dart`.

**Viewer hook**
- `viewer_screen.dart`: new `_ViewerMenu.sign` item that opens the "My signatures" sheet with
  the open path, password (if any), current page and `PdfDocument`.
- Digital-signature warning: use the existing signature repository to ask whether the file has
  any signature fields; if yes, show the warning dialog before writing.

## Files to change

New:
- `lib/features/sign_document/**` (files listed above)
- `test/features/sign_document/domain/placement_geometry_test.dart`
- `test/features/sign_document/domain/signature_image_tools_test.dart`
- `test/features/sign_document/data/saved_signature_dao_test.dart`
- `test/features/sign_document/data/saved_signature_repository_test.dart`
- `test/features/sign_document/presentation/sign_placement_screen_test.dart`
- `test/core/storage/migration_v5_test.dart` (or extend the existing migration test; migrations need 100% coverage)

Changed:
- `lib/core/storage/migrations.dart` — add v5 `saved_signatures`
- `lib/core/storage/app_database.dart` — bump version if it is set there
- `lib/core/platform/pdfbox_channel.dart` — `stampImages`
- `lib/core/platform/open_document_channel.dart` — `pickImage`
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` — `stampImages`
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — `pickImage`
- `lib/features/viewer/presentation/viewer_screen.dart` — menu item + launch
- `lib/app/routing/app_router.dart` — routes for the pad / import / placement screens (if full screens are pushed by route)
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — all new strings, real Malayalam and Sanskrit, `@` descriptions, short labels
- `docs/features.md` — new section "Sign a document"
- `docs/architecture.md` — new feature folder, table v5
- `docs/security.md` — saved signature images: private storage, no backup, not in Device sync
- `lib/features/help/...` — one short help entry explaining "visible signature vs digital signature" (if the help screen lists features)
- `CHANGELOG.md` — user-facing line

## Security impact

- **Storage / permissions:** no new permission. Images come only through the system picker
  (SAF), read-only, copied once, cache copy deleted. No broad storage access.
- **Sensitive data:** a signature image is personal. It is stored only in app-private files.
  `allowBackup="false"` is already set, so it is not backed up. It is **not** added to the
  Device sync allow-list. It is never logged.
- **Untrusted input:** picked images are decoded defensively with size limits.
- **Network:** none.
- **Platform folders:** `MainActivity.kt` and `PdfBoxHandler.kt` change (new methods only).
- **Dependencies:** none added. PdfBox-Android already has `LosslessFactory`.

## Out of scope (first version)

- Real digital (certificate) signing — that is a much bigger feature.
- Adding text such as name / date next to the signature.
- "Put on every page" in one tap (can be a later small addition).
- Moving a signature after the signed copy is saved (sign again from the original instead).

## Checks

- `flutter gen-l10n`, `dart format .`, `flutter analyze` (0 warnings), `flutter test`.
- User builds `flutter run --flavor dev` and tries: draw, import a photo, place on page 1 and
  a rotated page, a password-protected PDF, a PDF that already has a digital signature, and
  a corrupt image file.
- After any Gradle build: `android\gradlew --stop` and check no Gradle/Kotlin daemons remain.
