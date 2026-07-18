import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/printer/data/pdf_builder_service.dart';
import 'package:pdfapp/features/printer/data/print_service.dart';
import 'package:pdfapp/features/printer/data/printer_channel.dart';

/// Phase 6: printing hands a finished PDF to the Android print dialog. A page
/// range is sliced into a new copy first — the source is never touched.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pdfBoxChannel = MethodChannel('in.sreerajp.pdfapp/pdfbox');
  const openChannel = MethodChannel('in.sreerajp.pdfapp/open');
  const printChannel = MethodChannel('in.sreerajp.pdfapp/print');
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void mockPdfBox(Future<Object?>? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(pdfBoxChannel, handler);
  }

  void mockPrint(Future<Object?>? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(printChannel, handler);
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
    messenger.setMockMethodCallHandler(printChannel, null);
    messenger.setMockMethodCallHandler(pathProviderChannel, null);
  });

  final pdfBox = PdfBoxChannel(method: pdfBoxChannel);
  final open = OpenDocumentChannel(method: openChannel);
  final sut = PrintService(
    PrinterChannel(method: printChannel),
    PageOpsService(pdfBox, open),
    PdfBuilderService(pdfBox, open),
  );

  group('PrintService.printDocument', () {
    test('sends the file straight to the print dialog', () async {
      late Map<Object?, Object?> args;
      mockPrint((call) async {
        expect(call.method, 'printPdf');
        args = call.arguments as Map<Object?, Object?>;
        return null;
      });

      await sut.printDocument('/doc.pdf', 'report.pdf');

      expect(args['path'], '/doc.pdf');
      expect(args['jobName'], 'report.pdf');
    });

    test('reports a device that cannot print', () async {
      mockPrint((call) async {
        throw PlatformException(code: 'print_unavailable');
      });

      expect(
        () => sut.printDocument('/doc.pdf', 'report.pdf'),
        throwsA(isA<PrintException>()),
      );
    });

    test('reports a missing file', () async {
      mockPrint((call) async {
        throw PlatformException(code: 'file_not_found');
      });

      expect(
        () => sut.printDocument('/gone.pdf', 'gone.pdf'),
        throwsA(isA<PrintException>()),
      );
    });
  });

  group('PrintService.printRange', () {
    test('slices the range into a new copy, then prints that copy', () async {
      Object? sentPages;
      String? organizedTo;
      mockPdfBox((call) async {
        expect(call.method, 'organizePages');
        expect(call.arguments['path'], '/doc.pdf');
        sentPages = call.arguments['pages'];
        organizedTo = call.arguments['outputPath'] as String;
        return organizedTo;
      });
      String? printed;
      mockPrint((call) async {
        printed = call.arguments['path'] as String;
        return null;
      });

      await sut.printRange('/doc.pdf', 'report.pdf', from: 2, to: 4);

      // Pages 2..4 in order, each unrotated.
      expect(sentPages, [
        {'page': 2, 'rotation': 0},
        {'page': 3, 'rotation': 0},
        {'page': 4, 'rotation': 0},
      ]);
      // The copy is what goes to the printer — never the original.
      expect(printed, organizedTo);
      expect(printed, isNot('/doc.pdf'));
    });

    test('a single-page range sends just that page', () async {
      Object? sentPages;
      mockPdfBox((call) async {
        sentPages = call.arguments['pages'];
        return call.arguments['outputPath'] as String;
      });
      mockPrint((call) async => null);

      await sut.printRange('/doc.pdf', 'report.pdf', from: 3, to: 3);

      expect(sentPages, [
        {'page': 3, 'rotation': 0},
      ]);
    });

    test('does not print when the slice fails', () async {
      mockPdfBox((call) async {
        throw PlatformException(code: 'op_failed', message: 'broken');
      });
      var printCalled = false;
      mockPrint((call) async {
        printCalled = true;
        return null;
      });

      await expectLater(
        () => sut.printRange('/doc.pdf', 'report.pdf', from: 1, to: 2),
        throwsA(isA<PdfException>()),
      );
      expect(printCalled, isFalse);
    });
  });

  group('PrintService.printText', () {
    test('builds a PDF from the text, then prints it', () async {
      String? builtAt;
      mockPdfBox((call) async {
        expect(call.method, 'textToPdf');
        expect(call.arguments['text'], 'hello there');
        builtAt = call.arguments['outputPath'] as String;
        return builtAt;
      });
      String? printed;
      mockPrint((call) async {
        printed = call.arguments['path'] as String;
        return null;
      });

      await sut.printText('hello there', 'report.pdf');

      expect(printed, builtAt);
    });

    test('does not print text the fonts cannot write', () async {
      mockPdfBox((call) async {
        throw PlatformException(code: 'unsupported_text');
      });
      var printCalled = false;
      mockPrint((call) async {
        printCalled = true;
        return null;
      });

      await expectLater(
        () => sut.printText('മലയാളം', 'report.pdf'),
        throwsA(isA<PdfUnsupportedTextException>()),
      );
      expect(printCalled, isFalse);
    });
  });

  group('PrintService.isAvailable', () {
    test('passes the platform answer through', () async {
      mockPrint((call) async {
        expect(call.method, 'isPrintingAvailable');
        return true;
      });

      expect(await sut.isAvailable(), isTrue);
    });

    test('says no when the platform side is missing', () async {
      mockPrint((call) async {
        throw PlatformException(code: 'whatever');
      });

      expect(await sut.isAvailable(), isFalse);
    });
  });
}
