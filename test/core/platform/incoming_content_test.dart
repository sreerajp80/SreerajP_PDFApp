import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';

/// Phase 6: the `kind` tag on a native intent payload decides where shared
/// content goes. A payload we cannot read must be dropped, never thrown.
void main() {
  // A dropped payload is logged, and the logger refuses to run uninitialized.
  setUpAll(AppLogger.init);

  group('IncomingContent.fromMap', () {
    test('reads a PDF payload', () {
      final content = IncomingContent.fromMap({
        'kind': 'pdf',
        'uri': 'content://doc/1',
        'name': 'report.pdf',
        'size': 1024,
        'path': '/cache/report.pdf',
      });

      expect(content, isA<IncomingPdf>());
      final doc = (content! as IncomingPdf).document;
      expect(doc.displayName, 'report.pdf');
      expect(doc.cachePath, '/cache/report.pdf');
      expect(doc.sizeBytes, 1024);
    });

    test('treats a payload with no kind as a PDF (pre-Phase-6 shape)', () {
      final content = IncomingContent.fromMap({
        'uri': 'content://doc/1',
        'name': 'old.pdf',
        'size': 10,
        'path': '/cache/old.pdf',
      });

      expect(content, isA<IncomingPdf>());
    });

    test('reads an images payload', () {
      final content = IncomingContent.fromMap({
        'kind': 'images',
        'name': 'holiday',
        'size': 2048,
        'paths': ['/cache/a.jpg', '/cache/b.jpg'],
      });

      expect(content, isA<IncomingImages>());
      final images = content! as IncomingImages;
      expect(images.paths, ['/cache/a.jpg', '/cache/b.jpg']);
      expect(images.suggestedName, 'holiday');
    });

    test('reads a text payload', () {
      final content = IncomingContent.fromMap({
        'kind': 'text',
        'name': 'note',
        'size': 5,
        'text': 'hello',
      });

      expect(content, isA<IncomingText>());
      expect((content! as IncomingText).text, 'hello');
    });

    test('drops an images payload with no pictures', () {
      final content = IncomingContent.fromMap({
        'kind': 'images',
        'name': 'empty',
        'size': 0,
        'paths': <String>[],
      });

      expect(content, isNull);
    });

    test('drops a text payload that is only whitespace', () {
      final content = IncomingContent.fromMap({
        'kind': 'text',
        'name': 'blank',
        'size': 3,
        'text': '   ',
      });

      expect(content, isNull);
    });

    test('drops an unknown kind instead of throwing', () {
      final content = IncomingContent.fromMap({
        'kind': 'video',
        'name': 'clip',
        'size': 99,
      });

      expect(content, isNull);
    });

    test('drops a payload missing its fields instead of throwing', () {
      final content = IncomingContent.fromMap({'kind': 'pdf'});

      expect(content, isNull);
    });
  });
}
