import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pdfBoxChannel = MethodChannel('in.sreerajp.pdfapp/pdfbox');
  const openChannel = MethodChannel('in.sreerajp.pdfapp/open');
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void mockPdfBox(Future<Object?>? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(pdfBoxChannel, handler);
  }

  void mockOpen(Future<Object?>? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(openChannel, handler);
  }

  setUp(() {
    messenger.setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getTemporaryDirectory') {
        return Directory.systemTemp.path;
      }
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(pdfBoxChannel, null);
    messenger.setMockMethodCallHandler(openChannel, null);
    messenger.setMockMethodCallHandler(pathProviderChannel, null);
  });

  final sut = PageOpsService(
    PdfBoxChannel(method: pdfBoxChannel),
    OpenDocumentChannel(method: openChannel),
  );

  group('PageOpsService', () {
    test('merge passes all paths and returns the new file', () async {
      mockPdfBox((call) async {
        expect(call.method, 'mergePdfs');
        expect(call.arguments['paths'], ['/a.pdf', '/b.pdf']);
        return call.arguments['outputPath'] as String;
      });

      final out = await sut.merge(['/a.pdf', '/b.pdf']);
      expect(out, contains('merged_'));
      expect(out, endsWith('.pdf'));
    });

    test('split returns the per-page file list', () async {
      mockPdfBox((call) async {
        expect(call.method, 'splitPdf');
        expect(call.arguments['path'], '/doc.pdf');
        return ['/tmp/page_ops/doc_page_1.pdf', '/tmp/page_ops/doc_page_2.pdf'];
      });

      final out = await sut.split('/doc.pdf');
      expect(out, hasLength(2));
    });

    test('organize sends the ordered page+rotation list', () async {
      mockPdfBox((call) async {
        expect(call.method, 'organizePages');
        expect(call.arguments['pages'], [
          {'page': 2, 'rotation': 90},
          {'page': 1, 'rotation': 0},
        ]);
        return call.arguments['outputPath'] as String;
      });

      final out = await sut.organize('/doc.pdf', [
        {'page': 2, 'rotation': 90},
        {'page': 1, 'rotation': 0},
      ]);
      expect(out, contains('organized_'));
    });

    test('compress delegates to the channel', () async {
      mockPdfBox((call) async {
        expect(call.method, 'compressPdf');
        return call.arguments['outputPath'] as String;
      });

      final out = await sut.compress('/doc.pdf');
      expect(out, contains('compressed_'));
    });

    test('protect forwards the user and owner passwords', () async {
      mockPdfBox((call) async {
        expect(call.method, 'encryptPdf');
        expect(call.arguments['userPassword'], 'secret');
        expect(call.arguments['ownerPassword'], 'owner');
        return call.arguments['outputPath'] as String;
      });

      final out = await sut.protect(
        '/doc.pdf',
        userPassword: 'secret',
        ownerPassword: 'owner',
      );
      expect(out, contains('protected_'));
    });

    test('unlock forwards the current password', () async {
      mockPdfBox((call) async {
        expect(call.method, 'decryptPdf');
        expect(call.arguments['password'], 'secret');
        return call.arguments['outputPath'] as String;
      });

      final out = await sut.unlock('/doc.pdf', password: 'secret');
      expect(out, contains('unlocked_'));
    });

    test('a locked source maps to PdfPasswordRequiredException', () async {
      mockPdfBox((call) async {
        throw PlatformException(code: 'password_required', message: 'locked');
      });

      await expectLater(
        sut.compress('/doc.pdf'),
        throwsA(isA<PdfPasswordRequiredException>()),
      );
    });

    test('pickPdfsToMerge returns the picked documents', () async {
      mockOpen((call) async {
        expect(call.method, 'pickPdfs');
        return [
          {'uri': 'u1', 'name': 'a.pdf', 'size': 10, 'path': '/a.pdf'},
        ];
      });

      final picked = await sut.pickPdfsToMerge();
      expect(picked, hasLength(1));
      expect(picked.first.cachePath, '/a.pdf');
    });

    test('saveToDevice returns the saved file name', () async {
      mockOpen((call) async {
        expect(call.method, 'saveToDevice');
        expect(call.arguments['sourcePath'], '/tmp/out.pdf');
        return 'my saved.pdf';
      });

      final saved = await sut.saveToDevice('/tmp/out.pdf', 'out.pdf');
      expect(saved, 'my saved.pdf');
    });
  });
}
