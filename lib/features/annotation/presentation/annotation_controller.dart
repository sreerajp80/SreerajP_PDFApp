import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:pdfapp/features/annotation/data/annotation_repository.dart';
import 'package:pdfapp/features/annotation/domain/annotation.dart';
import 'package:pdfapp/features/annotation/domain/annotation_type.dart';

/// The tool the user is drawing with. [none] means annotation mode is off and
/// the viewer behaves as a plain reader.
enum AnnotationTool {
  none,
  highlight,
  underline,
  strikethrough,
  note,
  ink,
  eraser;

  /// The annotation type this tool creates, or null for [none]/[eraser].
  AnnotationType? get creates => switch (this) {
    AnnotationTool.highlight => AnnotationType.highlight,
    AnnotationTool.underline => AnnotationType.underline,
    AnnotationTool.strikethrough => AnnotationType.strikethrough,
    AnnotationTool.note => AnnotationType.note,
    AnnotationTool.ink => AnnotationType.ink,
    AnnotationTool.none || AnnotationTool.eraser => null,
  };

  bool get isTextMarkup => creates?.isTextMarkup ?? false;
}

/// Default colors (ARGB) for each markable tool.
const int kHighlightColor = 0xFFFFEB3B; // yellow
const int kUnderlineColor = 0xFFE53935; // red
const int kStrikethroughColor = 0xFFE53935; // red
const int kInkColor = 0xFF1E88E5; // blue
const int kNoteColor = 0xFFFFC107; // amber

/// The palette offered in the toolbar's color picker.
const List<int> kAnnotationPalette = [
  0xFFFFEB3B, // yellow
  0xFF4CAF50, // green
  0xFF2196F3, // blue
  0xFFE53935, // red
  0xFF9C27B0, // purple
  0xFFFF9800, // orange
  0xFF000000, // black
];

/// Freehand ink stroke width as a fraction of page width.
const double kInkStrokeWidth = 0.004;

/// Drives overlay annotations for one open PDF (Phase 5).
///
/// Owned by the reader screen and thrown away with it, like
/// `PdfSearchController`. It is bound to one file (by fingerprint) and one
/// source path (for export). App-wide state stays in Riverpod.
class AnnotationController extends ChangeNotifier {
  AnnotationController({
    required this.repository,
    required this.fingerprint,
    required this.sourcePath,
  });

  final AnnotationRepository repository;
  final String fingerprint;
  final String sourcePath;

  final List<Annotation> _annotations = [];
  List<Annotation> get annotations => List.unmodifiable(_annotations);

  AnnotationTool _tool = AnnotationTool.none;
  AnnotationTool get tool => _tool;

  int _color = kHighlightColor;
  int get color => _color;

  bool _loaded = false;
  bool get loaded => _loaded;

  /// True once the user has been shown the "in-app only" notice for this file.
  bool noticeShown = false;

  /// Annotation mode is on whenever a tool other than [none] is chosen.
  bool get active => _tool != AnnotationTool.none;

  /// Loads the file's stored marks. Safe to call once on viewer ready.
  Future<void> load() async {
    final loaded = await repository.forFile(fingerprint);
    _annotations
      ..clear()
      ..addAll(loaded);
    _loaded = true;
    notifyListeners();
  }

  void setTool(AnnotationTool tool) {
    if (_tool == tool) return;
    _tool = tool;
    // Keep a sensible default color when switching to a tool with a fixed hue.
    switch (tool) {
      case AnnotationTool.highlight:
        _color = kHighlightColor;
      case AnnotationTool.underline:
        _color = kUnderlineColor;
      case AnnotationTool.strikethrough:
        _color = kStrikethroughColor;
      case AnnotationTool.ink:
        _color = kInkColor;
      case AnnotationTool.note:
      case AnnotationTool.eraser:
      case AnnotationTool.none:
        break;
    }
    notifyListeners();
  }

  void setColor(int color) {
    _color = color;
    notifyListeners();
  }

  /// All annotations on a page, in draw order (bookmarks excluded — they are not
  /// drawn on the page).
  List<Annotation> onPage(int page) => _annotations
      .where((a) => a.page == page && a.type != AnnotationType.bookmark)
      .toList();

  List<BookmarkAnnotation> get bookmarks =>
      _annotations.whereType<BookmarkAnnotation>().toList()
        ..sort((a, b) => a.page.compareTo(b.page));

  bool isBookmarked(int page) =>
      _annotations.any((a) => a is BookmarkAnnotation && a.page == page);

  DateTime get _now => DateTime.now();

  /// Adds a text-markup annotation from the covered line quads (normalized).
  Future<void> addMarkup({
    required int page,
    required AnnotationType markupType,
    required List<Rect> quads,
  }) async {
    if (quads.isEmpty) return;
    await _add(
      MarkupAnnotation(
        id: null,
        fingerprint: fingerprint,
        page: page,
        color: _color,
        createdAt: _now,
        updatedAt: _now,
        markupType: markupType,
        quads: quads,
      ),
    );
  }

  /// Adds one freehand ink stroke (normalized points).
  Future<void> addInkStroke({
    required int page,
    required List<Offset> points,
  }) async {
    if (points.length < 2) return;
    await _add(
      InkAnnotation(
        id: null,
        fingerprint: fingerprint,
        page: page,
        color: _color,
        createdAt: _now,
        updatedAt: _now,
        strokes: [InkStroke(points: points, width: kInkStrokeWidth)],
      ),
    );
  }

  /// Adds a sticky note at a normalized anchor point.
  Future<void> addNote({
    required int page,
    required Offset anchor,
    required String text,
  }) async {
    await _add(
      NoteAnnotation(
        id: null,
        fingerprint: fingerprint,
        page: page,
        color: kNoteColor,
        createdAt: _now,
        updatedAt: _now,
        anchor: anchor,
        text: text,
      ),
    );
  }

  /// Updates an existing note's text (or deletes it when cleared).
  Future<void> updateNoteText(NoteAnnotation note, String text) async {
    if (text.trim().isEmpty) {
      await delete(note);
      return;
    }
    final updated = NoteAnnotation(
      id: note.id,
      fingerprint: note.fingerprint,
      page: note.page,
      color: note.color,
      createdAt: note.createdAt,
      updatedAt: _now,
      anchor: note.anchor,
      text: text,
    );
    await repository.update(updated);
    final i = _annotations.indexWhere((a) => a.id == note.id);
    if (i >= 0) _annotations[i] = updated;
    notifyListeners();
  }

  /// Toggles a bookmark on [page]. Returns true if it is now bookmarked.
  Future<bool> toggleBookmark(int page, {String label = ''}) async {
    final existing = _annotations
        .whereType<BookmarkAnnotation>()
        .where((b) => b.page == page)
        .toList();
    if (existing.isNotEmpty) {
      for (final b in existing) {
        await delete(b);
      }
      return false;
    }
    await _add(
      BookmarkAnnotation(
        id: null,
        fingerprint: fingerprint,
        page: page,
        color: null,
        createdAt: _now,
        updatedAt: _now,
        label: label,
      ),
    );
    return true;
  }

  Future<void> delete(Annotation annotation) async {
    final id = annotation.id;
    if (id == null) return;
    await repository.delete(id);
    _annotations.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await repository.clearFile(fingerprint);
    _annotations.clear();
    notifyListeners();
  }

  /// Exports every mark into a new annotated copy, returning the produced path.
  Future<String> exportCopy({String? password}) =>
      repository.exportAnnotatedCopy(
        sourcePath: sourcePath,
        annotations: _annotations,
        password: password,
      );

  Future<String?> saveToDevice(String path, String suggestedName) =>
      repository.saveToDevice(path, suggestedName);

  bool get hasAnnotations => _annotations.isNotEmpty;

  Future<void> _add(Annotation annotation) async {
    final saved = await repository.add(annotation);
    _annotations.add(saved);
    notifyListeners();
  }

  void markNoticeShown() => noticeShown = true;
}
