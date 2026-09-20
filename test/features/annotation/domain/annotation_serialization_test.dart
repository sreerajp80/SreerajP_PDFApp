import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/annotation/domain/annotation.dart';
import 'package:pdfapp/features/annotation/domain/annotation_type.dart';

void main() {
  final now = DateTime.fromMillisecondsSinceEpoch(1700000000000);

  test('AnnotationType round-trips through storage names', () {
    for (final t in AnnotationType.values) {
      expect(AnnotationType.fromStorage(t.storageName), t);
    }
  });

  test('unknown type throws', () {
    expect(() => AnnotationType.fromStorage('nope'), throwsArgumentError);
  });

  test('markup annotation round-trips via a row', () {
    final original = MarkupAnnotation(
      id: 5,
      fingerprint: 'fp1',
      page: 3,
      color: 0xFFFFEB3B,
      createdAt: now,
      updatedAt: now,
      markupType: AnnotationType.highlight,
      quads: const [
        Rect.fromLTWH(0.1, 0.2, 0.3, 0.04),
        Rect.fromLTWH(0.1, 0.26, 0.2, 0.04),
      ],
    );
    final back = Annotation.fromRow(original.toRow());
    expect(back, isA<MarkupAnnotation>());
    final m = back as MarkupAnnotation;
    expect(m.id, 5);
    expect(m.page, 3);
    expect(m.markupType, AnnotationType.highlight);
    expect(m.color, 0xFFFFEB3B);
    expect(m.quads.length, 2);
    expect(m.quads.first.width, closeTo(0.3, 1e-9));
  });

  test('ink annotation round-trips including stroke width', () {
    final original = InkAnnotation(
      id: 1,
      fingerprint: 'fp1',
      page: 1,
      color: 0xFF1E88E5,
      createdAt: now,
      updatedAt: now,
      strokes: const [
        InkStroke(
          points: [Offset(0.1, 0.1), Offset(0.2, 0.15), Offset(0.3, 0.2)],
          width: 0.004,
        ),
      ],
    );
    final back = Annotation.fromRow(original.toRow()) as InkAnnotation;
    expect(back.strokes.length, 1);
    expect(back.strokes.first.points.length, 3);
    expect(back.strokes.first.width, closeTo(0.004, 1e-9));
    expect(back.strokes.first.points[1].dy, closeTo(0.15, 1e-9));
  });

  test('note annotation round-trips anchor and text', () {
    final original = NoteAnnotation(
      id: 9,
      fingerprint: 'fp1',
      page: 2,
      color: 0xFFFFC107,
      createdAt: now,
      updatedAt: now,
      anchor: const Offset(0.42, 0.66),
      text: 'remember this',
    );
    final back = Annotation.fromRow(original.toRow()) as NoteAnnotation;
    expect(back.anchor.dx, closeTo(0.42, 1e-9));
    expect(back.anchor.dy, closeTo(0.66, 1e-9));
    expect(back.text, 'remember this');
  });

  test('bookmark annotation round-trips label', () {
    final original = BookmarkAnnotation(
      id: 2,
      fingerprint: 'fp1',
      page: 12,
      color: null,
      createdAt: now,
      updatedAt: now,
      label: 'Chapter 2',
    );
    final back = Annotation.fromRow(original.toRow()) as BookmarkAnnotation;
    expect(back.page, 12);
    expect(back.label, 'Chapter 2');
    expect(back.color, isNull);
  });

  test('toRow omits id when it is null (new insert)', () {
    final a = BookmarkAnnotation(
      id: null,
      fingerprint: 'fp1',
      page: 1,
      color: null,
      createdAt: now,
      updatedAt: now,
      label: '',
    );
    expect(a.toRow().containsKey('id'), isFalse);
  });
}
