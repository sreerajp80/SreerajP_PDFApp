import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/printer/data/pdf_builder_service.dart';

/// Phase 6: shared pictures and text become a brand-new PDF in the cache.
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

  final sut = PdfBuilderService(
    PdfBoxChannel(method: pdfBoxChannel),
    OpenDocumentChannel(method: openChannel),
  );

  group('PdfBuilderService.fromImages', () {
    test('sends every picture and writes into the printer cache', () async {
      mockPdfBox((call) async {
        expect(call.method, 'imagesToPdf');
        expect(call.arguments['paths'], ['/a.jpg', '/b.png']);
        return call.arguments['outputPath'] as String;
      });

      final out = await sut.fromImages(
        const IncomingImages(
          paths: ['/a.jpg', '/b.png'],
          suggestedName: 'holiday',
        ),
      );

      expect(out, contains(AppConstants.printerCacheDir));
      expect(out, contains('holiday_'));
      expect(out, endsWith('.pdf'));
    });

    test('cuts an over-long batch to the limit', () async {
      late List<Object?> sent;
      mockPdfBox((call) async {
        sent = call.arguments['paths'] as List<Object?>;
        return call.arguments['outputPath'] as String;
      });

      final many = List.generate(
        AppConstants.maxImportImages + 25,
        (i) => '/pic_$i.jpg',
      );
      await sut.fromImages(IncomingImages(paths: many, suggestedName: 'batch'));

      expect(sent, hasLength(AppConstants.maxImportImages));
      expect(sent.first, '/pic_0.jpg');
    });

    test('keeps a batch at the limit whole', () async {
      late List<Object?> sent;
      mockPdfBox((call) async {
        sent = call.arguments['paths'] as List<Object?>;
        return call.arguments['outputPath'] as String;
      });

      final exact = List.generate(
        AppConstants.maxImportImages,
        (i) => '/pic_$i.jpg',
      );
      await sut.fromImages(
        IncomingImages(paths: exact, suggestedName: 'batch'),
      );

      expect(sent, hasLength(AppConstants.maxImportImages));
    });

    test('makes a safe file name out of an awkward one', () async {
      mockPdfBox((call) async => call.arguments['outputPath'] as String);

      final out = await sut.fromImages(
        const IncomingImages(
          paths: ['/a.jpg'],
          suggestedName: 'my photo/../x*y',
        ),
      );

      expect(out, contains('my_photo_.._x_y_'));
    });
  });

  group('PdfBuilderService.fromText', () {
    test('sends the text and returns the new file', () async {
      mockPdfBox((call) async {
        expect(call.method, 'textToPdf');
        expect(call.arguments['text'], 'hello there');
        return call.arguments['outputPath'] as String;
      });

      final out = await sut.fromText(
        const IncomingText(text: 'hello there', suggestedName: 'note'),
      );

      expect(out, contains('note_'));
      expect(out, endsWith('.pdf'));
    });

    test('turns unsupported letters into a typed exception', () async {
      mockPdfBox((call) async {
        throw PlatformException(
          code: 'unsupported_text',
          message: 'These letters cannot be written to a PDF.',
        );
      });

      expect(
        () => sut.fromText(
          const IncomingText(text: 'മലയാളം', suggestedName: 'note'),
        ),
        throwsA(isA<PdfUnsupportedTextException>()),
      );
    });

    test('turns any other native failure into a PDF exception', () async {
      mockPdfBox((call) async {
        throw PlatformException(code: 'op_failed', message: 'disk full');
      });

      expect(
        () => sut.fromText(
          const IncomingText(text: 'hello', suggestedName: 'note'),
        ),
        throwsA(isA<PdfException>()),
      );
    });
  });

  group('PdfBuilderService.canWriteText', () {
    test('passes the answer through', () async {
      mockPdfBox((call) async {
        expect(call.method, 'canWriteTextToPdf');
        return false;
      });

      expect(await sut.canWriteText('മലയാളം'), isFalse);
    });

    test('says no when the platform side is missing', () async {
      mockPdfBox((call) async {
        throw PlatformException(code: 'whatever');
      });

      expect(await sut.canWriteText('hello'), isFalse);
    });
  });
}
