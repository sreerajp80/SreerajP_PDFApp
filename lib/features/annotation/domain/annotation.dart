import 'dart:convert';
import 'dart:ui';

import 'package:pdfapp/features/annotation/domain/annotation_type.dart';

/// One overlay annotation, stored in the app database and drawn on top of a
/// rendered page (Phase 5). The original PDF is never changed.
///
/// Every subtype shares the same columns (id, fingerprint, page, type, color,
/// timestamps). The shape-specific data (quads / strokes / note text / bookmark
/// label) is serialized into the JSON `payload` column by [payloadJson].
///
/// All coordinates are **normalized**: a fraction (0.0–1.0) of the page width or
/// height, top-left origin. See `AnnotationGeometry`.
sealed class Annotation {
  const Annotation({
    required this.id,
    required this.fingerprint,
    required this.page,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Row id. Null before the row is inserted.
  final int? id;
  final String fingerprint;

  /// 1-based page number. Page-level marks (bookmarks) still carry it.
  final int page;

  /// ARGB color, or null to use the type's default (notes, bookmarks).
  final int? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnnotationType get type;

  /// The shape-specific data as a JSON string for the `payload` column.
  String get payloadJson;

  Map<String, Object?> toRow() => {
    if (id != null) 'id': id,
    'fingerprint': fingerprint,
    'page': page,
    'type': type.storageName,
    'color': color,
    'payload': payloadJson,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
  };

  /// Rebuilds the right subtype from a database row.
  factory Annotation.fromRow(Map<String, Object?> row) {
    final type = AnnotationType.fromStorage(row['type']! as String);
    final id = (row['id'] as num?)?.toInt();
    final fingerprint = row['fingerprint']! as String;
    final page = (row['page']! as num).toInt();
    final color = (row['color'] as num?)?.toInt();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(
      (row['created_at']! as num).toInt(),
    );
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(
      (row['updated_at']! as num).toInt(),
    );
    final payload =
        jsonDecode(row['payload']! as String) as Map<String, dynamic>;

    switch (type) {
      case AnnotationType.highlight:
      case AnnotationType.underline:
      case AnnotationType.strikethrough:
        return MarkupAnnotation(
          id: id,
          fingerprint: fingerprint,
          page: page,
          color: color,
          createdAt: createdAt,
          updatedAt: updatedAt,
          markupType: type,
          quads: _rectsFromJson(payload['quads'] as List<dynamic>? ?? const []),
        );
      case AnnotationType.ink:
        final strokes = (payload['strokes'] as List<dynamic>? ?? const [])
            .map((s) => InkStroke.fromJson(s as Map<String, dynamic>))
            .toList();
        return InkAnnotation(
          id: id,
          fingerprint: fingerprint,
          page: page,
          color: color,
          createdAt: createdAt,
          updatedAt: updatedAt,
          strokes: strokes,
        );
      case AnnotationType.note:
        final at = payload['at'] as List<dynamic>;
        return NoteAnnotation(
          id: id,
          fingerprint: fingerprint,
          page: page,
          color: color,
          createdAt: createdAt,
          updatedAt: updatedAt,
          anchor: Offset((at[0] as num).toDouble(), (at[1] as num).toDouble()),
          text: payload['text'] as String? ?? '',
        );
      case AnnotationType.bookmark:
        return BookmarkAnnotation(
          id: id,
          fingerprint: fingerprint,
          page: page,
          color: color,
          createdAt: createdAt,
          updatedAt: updatedAt,
          label: payload['label'] as String? ?? '',
        );
    }
  }

  static List<Rect> _rectsFromJson(List<dynamic> list) => list
      .map(
        (r) => (r as List<dynamic>).map((n) => (n as num).toDouble()).toList(),
      )
      .map((v) => Rect.fromLTWH(v[0], v[1], v[2], v[3]))
      .toList();

  static List<List<double>> rectsToJson(List<Rect> rects) =>
      rects.map((r) => [r.left, r.top, r.width, r.height]).toList();
}

/// Text markup: highlight, underline, or strikethrough. Drawn from one quad per
/// text line (normalized), which come from the page's character rectangles.
class MarkupAnnotation extends Annotation {
  const MarkupAnnotation({
    required super.id,
    required super.fingerprint,
    required super.page,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    required this.markupType,
    required this.quads,
  }) : assert(
         markupType == AnnotationType.highlight ||
             markupType == AnnotationType.underline ||
             markupType == AnnotationType.strikethrough,
         'markupType must be a text-markup type',
       );

  final AnnotationType markupType;
  final List<Rect> quads;

  @override
  AnnotationType get type => markupType;

  @override
  String get payloadJson =>
      jsonEncode({'quads': Annotation.rectsToJson(quads)});
}

/// One freehand stroke: an ordered list of normalized points and a stroke width
/// (as a fraction of the page width, so it scales with the page).
class InkStroke {
  const InkStroke({required this.points, required this.width});

  final List<Offset> points;
  final double width;

  Map<String, Object?> toJson() => {
    'w': width,
    'pts': points.map((p) => [p.dx, p.dy]).toList(),
  };

  factory InkStroke.fromJson(Map<String, dynamic> json) => InkStroke(
    width: (json['w'] as num).toDouble(),
    points: (json['pts'] as List<dynamic>)
        .map((p) => (p as List<dynamic>))
        .map((p) => Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()))
        .toList(),
  );
}

/// Freehand ink: one or more strokes.
class InkAnnotation extends Annotation {
  const InkAnnotation({
    required super.id,
    required super.fingerprint,
    required super.page,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    required this.strokes,
  });

  final List<InkStroke> strokes;

  @override
  AnnotationType get type => AnnotationType.ink;

  @override
  String get payloadJson =>
      jsonEncode({'strokes': strokes.map((s) => s.toJson()).toList()});
}

/// A sticky note: a normalized anchor point plus its text.
class NoteAnnotation extends Annotation {
  const NoteAnnotation({
    required super.id,
    required super.fingerprint,
    required super.page,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    required this.anchor,
    required this.text,
  });

  final Offset anchor;
  final String text;

  @override
  AnnotationType get type => AnnotationType.note;

  @override
  String get payloadJson => jsonEncode({
    'at': [anchor.dx, anchor.dy],
    'text': text,
  });
}

/// A page bookmark: page-level, with an optional label.
class BookmarkAnnotation extends Annotation {
  const BookmarkAnnotation({
    required super.id,
    required super.fingerprint,
    required super.page,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    required this.label,
  });

  final String label;

  @override
  AnnotationType get type => AnnotationType.bookmark;

  @override
  String get payloadJson => jsonEncode({'label': label});
}
