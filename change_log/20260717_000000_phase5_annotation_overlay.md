# Change log — Phase 5: Annotation overlay layer

**Implements:** [plans/20260716_225039_phase5_annotation_overlay.md](../plans/20260716_225039_phase5_annotation_overlay.md)

**Date:** 2026-07-17

---

## What was built

An app-side annotation overlay for the PDF viewer. The user can mark up a PDF with
**highlight, underline, strikethrough, sticky notes, freehand ink, and page bookmarks**. Marks
are stored in the app database, keyed to the file's content fingerprint, and drawn on top of the
rendered page. The original PDF is **never** changed. An optional **export** writes the marks
into a new PDF copy (copy-on-write) as real PDF annotations.

This follows the approved plan. The three defaults offered in the plan were used:
1. Page bookmarks export as **PDF outline (contents) entries**.
2. Removing a mark is **tap-to-delete** (eraser tool for on-page marks; a Delete button in the
   note editor and bookmarks list), not a pixel eraser.
3. The annotate control is an **app-bar pencil toggle** that reveals the tool strip; bookmarks
   are reached from the overflow menu.

---

## How it works

- **Storage (schema v3).** A new `annotations` table holds every mark type. Shape data (quads,
  ink strokes, note text, bookmark label) is stored as JSON in a `payload` column. Coordinates
  are **normalized** (0–1 of page width/height, top-left origin) so marks redraw correctly at any
  zoom or view mode. The table has no foreign key to `recent_files`, so marks survive when a file
  is trimmed from the recents list; they re-attach by fingerprint on the next open.
- **Rendering / input reuse pdfrx callbacks.** Stored highlights/underlines/strikes/ink are
  painted through `pagePaintCallbacks` (the same mechanism as search highlights). A per-page
  `pageOverlaysBuilder` layer captures gestures (ink drawing, note placement, text-markup drag,
  eraser taps) and shows tappable sticky-note markers. Text-markup uses the page's own
  per-character rectangles (`PdfPage.loadText`) to turn a drag into clean per-line quads.
- **Never a dead button.** Text-markup tools are disabled with an honest message on scanned or
  garbled PDFs (no text layer), matching the search behavior. Ink, notes, and bookmarks still
  work on those files.
- **Export (copy-on-write).** A new native `exportAnnotations` method on the PdfBox-Android
  channel writes the marks into a copy. Highlight/underline/strikethrough/ink are **painted into
  the page content stream** so they render in every PDF viewer; notes become real
  `PDAnnotationText` sticky-note annotations; bookmarks become PDF outline (contents) entries.
  Normalized top-left coordinates are converted to PDF points using each page's MediaBox. The
  result is saved to a user-chosen location through the existing SAF save flow.

  **Deviation from the plan (library limit, not a scope change):** the plan said "write real PDF
  annotations". PdfBox-Android 2.0.27 has no ink-annotation class and does not generate
  appearance streams for text-markup annotations, so those marks would not reliably render in
  other viewers. Painting them into the content stream is the robust way to meet the plan's exit
  criterion ("export produces a valid annotated copy") — the user-facing outcome is the same. It
  does mean the painted marks are baked in (not separately editable in another PDF editor); notes
  remain interactive annotations.
- **Messaging.** A dismissible banner tells the user marks live only inside this app until
  exported. It appears the first time a mark is added.

---

## Files changed

**Added (Dart):**
- `lib/features/annotation/domain/annotation.dart` — sealed `Annotation` model + subtypes
  (markup, ink, note, bookmark) with row/JSON serialization.
- `lib/features/annotation/domain/annotation_type.dart` — `AnnotationType` enum.
- `lib/features/annotation/domain/annotation_geometry.dart` — pure normalize/denormalize and
  char-rects → line-quads helpers.
- `lib/features/annotation/data/annotation_dao.dart` — CRUD on the `annotations` table.
- `lib/features/annotation/data/annotation_repository.dart` — UI surface + export flattening.
- `lib/features/annotation/presentation/providers.dart` — DAO + repository providers.
- `lib/features/annotation/presentation/annotation_controller.dart` — per-file mark state, tool,
  color, and mutations (owned by the viewer, like the search controller).
- `lib/features/annotation/presentation/annotation_painter.dart` — paints stored marks on a page.
- `lib/features/annotation/presentation/widgets/annotation_toolbar.dart` — tool strip + colors +
  clear/export.
- `lib/features/annotation/presentation/widgets/page_annotation_layer.dart` — per-page gesture
  capture and note markers.
- `lib/features/annotation/presentation/widgets/note_editor_dialog.dart` — write/edit/delete a note.
- `lib/features/annotation/presentation/widgets/bookmarks_panel.dart` — bookmarks list + add/jump.
- `lib/features/annotation/presentation/widgets/annotation_overlay_notice.dart` — the in-app-only banner.

**Added (tests):**
- `test/features/annotation/annotation_geometry_test.dart`
- `test/features/annotation/annotation_serialization_test.dart`
- `test/features/annotation/annotation_dao_test.dart`
- `test/core/storage/migration_v3_test.dart`

**Changed:**
- `lib/core/storage/migrations.dart` — added `_v3AnnotationsTable`.
- `lib/core/constants/app_constants.dart` — `databaseVersion` 2 → 3; `tableAnnotations`.
- `lib/core/platform/pdfbox_channel.dart` — `exportAnnotations` method.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` — `exportAnnotations`
  handler (content-stream painting for highlight/underline/strike/ink + `PDAnnotationText` notes
  + bookmark outline entries), copy-on-write.
- `lib/features/viewer/presentation/viewer_screen.dart` — annotate toggle, toolbar, notice,
  paint + overlay wiring, bookmarks menu, export flow, controller lifecycle.
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb` (+ regenerated `app_localizations*.dart`) — new
  annotation strings.
- `test/core/storage/migration_v2_test.dart` — fresh-create version assertion now reads the
  current schema version (bumped to 3) instead of a hard-coded 2.
- `docs/pdf-app-implementation-progress.md` — Phase 5 marked done.

---

## Verification

- `flutter analyze` — clean (no issues).
- `dart format` — clean.
- `flutter test` — **210 tests pass** (186 prior + 24 new).
- Native `exportAnnotations` (Kotlin) — `:app:compileDevDebugKotlin` **BUILD SUCCESSFUL**.
  On-device draw → reopen → export pass is the remaining manual check (no unit harness for the
  PdfBox path, as with page-ops export).

---

## Notes / follow-ups

- Export writes standard PDF annotations; quad-point ordering follows the common UL/UR/LL/LR
  layout most viewers accept. Ink line width is derived from the stored normalized width.
- The eraser deletes on-page marks (markup, ink) by a tap near them; notes are deleted by tapping
  their marker while the eraser is active, or via the note editor's Delete button.
- On-device verification of the native export is pending, consistent with how Phase 4's export
  was verified.
