import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/domain/signature_placement.dart';

void main() {
  final sig = SavedSignature(
    id: 7,
    fileName: 'sig_1.png',
    widthPx: 600,
    heightPx: 200,
    source: SignatureSource.imported,
    createdAt: DateTime.fromMillisecondsSinceEpoch(1234),
  );

  test('row round trip keeps every field', () {
    final back = SavedSignature.fromRow(sig.toRow());
    expect(back.id, 7);
    expect(back.fileName, 'sig_1.png');
    expect(back.widthPx, 600);
    expect(back.heightPx, 200);
    expect(back.source, SignatureSource.imported);
    expect(back.createdAt.millisecondsSinceEpoch, 1234);
  });

  test('a new signature has no id in its row', () {
    expect(sig.copyWith().toRow().containsKey('id'), isTrue);
    final draft = SavedSignature(
      id: null,
      fileName: 'a.png',
      widthPx: 1,
      heightPx: 1,
      source: SignatureSource.drawn,
      createdAt: DateTime(2026),
    );
    expect(draft.toRow().containsKey('id'), isFalse);
  });

  test('an unknown source value does not throw', () {
    expect(SignatureSource.fromStorage('drawn'), SignatureSource.drawn);
    expect(SignatureSource.fromStorage('???'), SignatureSource.imported);
  });

  test('aspect ratio is safe for a bad size', () {
    expect(sig.aspectRatio, 3);
    expect(sig.copyWith(heightPx: 0).aspectRatio, 1);
  });

  test('placement map carries the normalized box and the picture path', () {
    const p = SignaturePlacement(
      page: 2,
      rect: Rect.fromLTWH(0.1, 0.2, 0.3, 0.05),
    );
    final map = p.toPlatformMap('/x/sig.png');
    expect(map['page'], 2);
    expect(map['x']! as double, closeTo(0.1, 1e-9));
    expect(map['y']! as double, closeTo(0.2, 1e-9));
    expect(map['w']! as double, closeTo(0.3, 1e-9));
    expect(map['h']! as double, closeTo(0.05, 1e-9));
    expect(map['imagePath'], '/x/sig.png');
  });
}
