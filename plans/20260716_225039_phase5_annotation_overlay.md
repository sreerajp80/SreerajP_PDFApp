# Phase 5 — Annotation overlay layer

**Status:** completed

> **Implementation note (export):** PdfBox-Android 2.0.27 has no ink-annotation class and does
> not generate appearance streams for text markup, so highlight/underline/strike/ink are painted
> into the page content stream on export (they render in every viewer). Notes stay real
> `PDAnnotationText` annotations; bookmarks become PDF outline entries. Same user-facing outcome
> as "real annotations"; the painted marks are baked in rather than separately editable. See the
> change log for details.

This plan implements **Phase 5** from
[docs/pdf-app-implementation-plan.md](../docs/pdf-app-implementation-plan.md): an app-side
annotation overlay. Open-source PDF renderers are view-only, so we build annotations ourselves,
store them in the app database, and draw them on top of the rendered page. The original PDF is
**never** changed. An optional export writes real PDF annotations into a **copy**.

---

## 1. What the issue is

- The viewer (Phase 1) can only display a PDF. There is no way to mark it up.
- We must add: **highlight, underline, strikethrough, sticky notes, freehand ink, and page
  bookmarks** — all stored in the app, keyed to the file fingerprint, and redrawn at the right
  place after the file is reopened.
- The original file must stay byte-for-byte the same (project rule 5: copy-on-write).
- The user must be told clearly that these marks live only inside this app until they export.
- Optional: export the marks as real PDF annotations into a new copy, using PdfBox-Android.

---

## 2. Key design decisions (grounded in the current code)

1. **Coordinates are stored normalized (0.0–1.0).** Every point/rect is saved as a fraction of
   the page width and height, in a **top-left origin** space (same as the screen `pageRect` that
   pdfrx gives paint callbacks). This makes marks resolution- and zoom-independent, so they redraw
   correctly at any scale. PDF's native bottom-left origin is only dealt with at **export time**.

2. **Drawing and rendering reuse pdfrx callbacks that are already in the viewer:**
   - `pagePaintCallbacks` — already used for search highlights
     ([viewer_screen.dart:481](../lib/features/viewer/presentation/viewer_screen.dart#L481)).
     We add a second callback that paints stored annotations for the page.
   - `pageOverlaysBuilder` — a per-page widget layer at the page's screen rect. We use it for a
     `GestureDetector` (freehand ink capture, tap-to-place a note, tap a note marker to open it)
     and to show sticky-note markers. It follows the exact `HitTestBehavior.translucent` +
     `handleLinkTap` rule pdfrx documents so the viewer keeps working.
   - Text markup (highlight/underline/strike) reuses the **same per-character rectangle path**
     the search highlighter already uses (`PdfPageText` / `charRects` via
     [pdf_text_source.dart](../lib/features/reading/data/pdf_text_source.dart) and
     [search_highlight_painter.dart](../lib/features/reading/presentation/widgets/search_highlight_painter.dart)).
     The user drags across text; we collect the covered character rects, merge them per line into
     quads, normalize them, and store them. This only works where there is real text
     (`_textUsable`), matching the scanned-PDF rule.

3. **One database table** (`annotations`, schema **v3**) holds every annotation type. The
   shape-specific data (quads, ink strokes, note text) goes in a JSON `payload` column. This
   matches the plan's schema table (v3 = annotations, fingerprint + page + position + type +
   payload).

4. **Bookmarks are page-level annotations** in the same table (`type = 'bookmark'`, no position),
   shown in a simple bookmarks list. This keeps one storage path and avoids a second table.

5. **Export is optional and copy-on-write.** A new native method `exportAnnotations` on the
   existing PdfBox channel writes PDF annotations (`PDAnnotationTextMarkup`, `PDAnnotationText`,
   `PDAnnotationInk`) into a **new** file, saved to a user-chosen location through the SAF save
   flow already used by page-ops
   ([page_ops_service.dart:103](../lib/features/page_ops/data/page_ops_service.dart#L103)).
   Bookmarks are not standard annotations, so on export they become PDF **outline** entries (or
   are skipped with a note — see §8 open question).

6. **Never a dead button / never crash.** On a scanned PDF (no text), text-markup tools are
   disabled with the same honest message pattern as search; ink, notes, and bookmarks still work.
   Every native call and DB call has a typed failure path mapped to a friendly UI state.

---

## 3. Data model

### Database migration v3 — `annotations`

New migration `_v3AnnotationsTable` in
[lib/core/storage/migrations.dart](../lib/core/storage/migrations.dart):

```sql
CREATE TABLE annotations (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  fingerprint TEXT    NOT NULL,
  page        INTEGER NOT NULL,          -- 1-based; page-level marks (bookmark) still carry it
  type        TEXT    NOT NULL,          -- highlight|underline|strikethrough|note|ink|bookmark
  color       INTEGER,                   -- ARGB; null for note/bookmark defaults
  payload     TEXT    NOT NULL,          -- JSON: quads | strokes | note text | bookmark label
  created_at  INTEGER NOT NULL,
  updated_at  INTEGER NOT NULL
);
CREATE INDEX idx_annotations_file_page ON annotations (fingerprint, page);
```

- `AppConstants.databaseVersion` → **3**; add `tableAnnotations = 'annotations'`
  ([app_constants.dart](../lib/core/constants/app_constants.dart)).
- Not keyed by a foreign key to `recent_files`: annotations should survive even if a file is
  trimmed from the recents list (they are re-attached by fingerprint on next open). This is a
  deliberate difference from `reading_positions` and will be noted in the migration comment.

**Payload JSON shapes** (documented in the domain file):
- markup (`highlight`/`underline`/`strikethrough`): `{ "quads": [[x,y,w,h], ...] }` normalized.
- `ink`: `{ "strokes": [ { "w": 0.004, "pts": [[x,y],...] }, ... ] }` normalized, width as a
  fraction of page width.
- `note`: `{ "at": [x,y], "text": "..." }` normalized anchor point.
- `bookmark`: `{ "label": "..." }` (page comes from the `page` column).

### Domain model

New files under `lib/features/annotation/domain/`:
- `annotation.dart` — an `Annotation` base with `id, fingerprint, page, type, color, createdAt,
  updatedAt` and sealed subtypes `MarkupAnnotation` (quads), `InkAnnotation` (strokes),
  `NoteAnnotation` (point + text), `BookmarkAnnotation` (label). Each has `toRow()` /
  `fromRow()` handling the JSON `payload`.
- `annotation_type.dart` — the `AnnotationType` enum + parsing.
- `annotation_geometry.dart` — small pure helpers: normalize/denormalize a rect or point against
  a `Size`/`Rect`, merge covered char rects into per-line quads. **Pure Dart, unit-tested.**

---

## 4. Data layer

New files under `lib/features/annotation/data/`:
- `annotation_dao.dart` — CRUD on the `annotations` table: `byFile(fingerprint)`,
  `byPage(fingerprint, page)`, `insert(Annotation)`, `update(Annotation)`, `deleteById(id)`,
  `deleteAllForFile(fingerprint)`. Same style as
  [reading_position_dao.dart](../lib/features/viewer/data/reading_position_dao.dart).
- `annotation_repository.dart` — the single surface the UI uses: load/save/delete, plus
  `exportAnnotatedCopy(...)` which calls the native channel and returns the output path.

### Native export (Kotlin + channel)

- `lib/core/platform/pdfbox_channel.dart`: add `exportAnnotations({path, password, outputPath,
  annotations})` that sends the normalized annotation list to native.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`: add an `"exportAnnotations"`
  case that loads the source, adds `PDAnnotationTextMarkup` (highlight/underline/strikethrough),
  `PDAnnotationText` (notes), and `PDAnnotationInk` (ink) to each page, converting normalized
  top-left coordinates to PDF bottom-left points using each page's `MediaBox`, and **saves to a
  new file** (copy-on-write, same pattern as the existing `organizePages`/`compress` cases).
  Runs off the main thread like the other handlers.

Heavy work (building the export, encoding) stays off the UI isolate on the Dart side; the native
call already runs on a background executor.

---

## 5. Presentation layer

New files under `lib/features/annotation/presentation/`:
- `providers.dart` — `annotationDaoProvider`, `annotationRepositoryProvider`, and an
  `AnnotationController` (a `Notifier`/`ChangeNotifier`) that holds: the loaded annotations for
  the open file, the **active tool** (none/highlight/underline/strike/note/ink/eraser), the
  **active color**, and the in-progress ink stroke. Exposes add/update/delete and `invalidate`
  wiring so the page repaints (mirrors how `_onSearchChanged` calls `_controller.invalidate()`).
- `annotation_painter.dart` — a `CustomPainter`-style helper (like
  [search_highlight_painter.dart](../lib/features/reading/presentation/widgets/search_highlight_painter.dart))
  that paints all stored annotations for one page inside its `pageRect`.
- `widgets/annotation_toolbar.dart` — the tool strip (shown when annotation mode is on): tool
  buttons, color picker, undo/clear-selection, and an **export** action.
- `widgets/page_annotation_layer.dart` — the per-page overlay widget (gesture capture for ink +
  note placement, and note markers) returned from `pageOverlaysBuilder`.
- `widgets/note_editor_dialog.dart` — create/edit a sticky note's text.
- `widgets/bookmarks_panel.dart` — list of page bookmarks with add-current-page and jump/delete.
- `widgets/annotation_overlay_notice.dart` — the "these marks are only visible in this app until
  you export" banner/notice.

### Viewer integration (edits to existing files)

- `lib/features/viewer/presentation/viewer_screen.dart`:
  - Add an **annotate** toggle to the app-bar actions and/or the overflow menu (new
    `_ViewerMenu.annotate`, plus a bookmarks entry).
  - When annotation mode is on: show `AnnotationToolbar`, add `page_annotation_layer` via
    `pageOverlaysBuilder`, and add the annotation paint callback to `pagePaintCallbacks`
    (alongside the existing search `_paintMatches`).
  - Load the file's annotations on `_onViewerReady` (keyed to `widget.docRef.fingerprint`), and
    repaint via `_controller.invalidate()` when they change.
  - Text-markup tools follow `_textUsable`: disabled with an honest snackbar on scanned/garbled
    PDFs, exactly like `_openSearch`/`_explainNoSearch`.
  - Show the overlay notice the first time marks are added.

### Localization

- Add new strings to `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb` (tool names, notice text,
  export messages, bookmark labels, note editor labels). Regenerate `app_localizations*.dart`
  with `flutter gen-l10n` (these generated files are committed, matching current git status).

---

## 6. Files to be changed / added

**Added:**
- `lib/features/annotation/domain/annotation.dart`
- `lib/features/annotation/domain/annotation_type.dart`
- `lib/features/annotation/domain/annotation_geometry.dart`
- `lib/features/annotation/data/annotation_dao.dart`
- `lib/features/annotation/data/annotation_repository.dart`
- `lib/features/annotation/presentation/providers.dart`
- `lib/features/annotation/presentation/annotation_painter.dart`
- `lib/features/annotation/presentation/widgets/annotation_toolbar.dart`
- `lib/features/annotation/presentation/widgets/page_annotation_layer.dart`
- `lib/features/annotation/presentation/widgets/note_editor_dialog.dart`
- `lib/features/annotation/presentation/widgets/bookmarks_panel.dart`
- `lib/features/annotation/presentation/widgets/annotation_overlay_notice.dart`
- `test/features/annotation/annotation_geometry_test.dart`
- `test/features/annotation/annotation_serialization_test.dart`
- `test/features/annotation/annotation_dao_test.dart`
- `test/core/storage/migration_v3_test.dart` (v2→v3 upgrade path)

**Changed:**
- `lib/core/storage/migrations.dart` (add v3)
- `lib/core/constants/app_constants.dart` (version 3, table name)
- `lib/core/platform/pdfbox_channel.dart` (exportAnnotations)
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` (export case)
- `lib/features/viewer/presentation/viewer_screen.dart` (toggle, toolbar, layers, load)
- `lib/features/viewer/presentation/providers.dart` (wire annotation providers if shared)
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb` (+ generated `app_localizations*.dart`)
- `docs/pdf-app-implementation-progress.md` (mark Phase 5 items)

---

## 7. Testing strategy

- **Unit (pure Dart):**
  - `annotation_geometry_test` — normalize/denormalize round-trips; char-rects → per-line quads;
    stays within 0–1 bounds.
  - `annotation_serialization_test` — each type `toRow()`/`fromRow()` round-trips, including the
    JSON payload for quads, ink strokes, note text, bookmark label.
- **DB:**
  - `annotation_dao_test` — insert/query-by-file/query-by-page/update/delete on an in-memory FFI
    database (same harness the other DAO/DB tests use).
  - `migration_v3_test` — open at v2, upgrade to v3, assert the `annotations` table and index
    exist and old data survives (append-only migration rule).
- **Widget (if time allows within the phase):** annotation toolbar tool switching; overlay notice
  appears; bookmarks panel add/jump.
- Native export is verified manually on device (build + open a PDF, add marks, export, reopen the
  exported copy in another viewer) — the Kotlin path has no unit harness, matching how page-ops
  export was verified.

**Definition of Done for the phase:** `flutter analyze` clean, `dart format` clean,
`flutter test` passing (existing 186 + new), dev debug APK builds. On-device pass for
draw → reopen (redraw) → export.

---

## 8. Open questions (please confirm; I have a default for each)

1. **Bookmarks on export.** Page bookmarks are not a PDF annotation type. Default: export them as
   **PDF outline (table-of-contents) entries**; if that proves fiddly in PdfBox-Android, skip
   bookmarks in the exported file and tell the user. Acceptable?
2. **Eraser vs. tap-to-delete.** For removing a mark, default is **tap a mark to select, then
   delete** (plus a per-note delete in its editor), rather than a pixel eraser for ink. Simpler
   and reliable. OK?
3. **Where the annotate control lives.** Default: a top-level **app-bar toggle** (pencil icon)
   that reveals the tool strip, with bookmarks reachable from the overflow menu. OK?

If you prefer different defaults, tell me and I will update the plan before coding.

---

## 9. Approval

Per the workflow rules, **no code will be written until you approve.** This plan file is the only
thing created so far.

**Do you approve this plan?**
