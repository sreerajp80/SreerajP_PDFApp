import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/extraction/data/extraction_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('in.sreerajp.pdfapp/pdfbox');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void mockChannel(Future<Object?>? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(channel, handler);
  }

  setUp(() {
    const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
    messenger.setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getTemporaryDirectory') {
        return Directory.systemTemp.path;
      }
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    messenger.setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/path_provider'), null);
  });

  final pdfBoxChannel = PdfBoxChannel(method: channel);
  final sut = ExtractionService(pdfBoxChannel);

  group('ExtractionService', () {
    test('extractText delegates to channel', () async {
      mockChannel((call) async {
        expect(call.method, 'extractText');
        return 'extracted plain text';
      });

      final result = await sut.extractText('/path/to/doc.pdf', startPage: 1, endPage: 2);
      expect(result, 'extracted plain text');
    });

    test('extractTextToFile writes file and returns path', () async {
      mockChannel((call) async => 'short text');

      final path = await sut.extractTextToFile('/path/to/doc.pdf');
      expect(path, contains('extracted_text_'));
      expect(path, endsWith('.txt'));

      final file = File(path);
      expect(await file.exists(), isTrue);
      expect(await file.readAsString(), 'short text');

      // Cleanup
      await file.delete();
    });

    test('extractImages delegates to channel', () async {
      mockChannel((call) async {
        expect(call.method, 'extractImages');
        return ['/tmp/extracted/img_1.png'];
      });

      final paths = await sut.extractImages('/path/to/doc.pdf', startPage: 1, endPage: 1);
      expect(paths, ['/tmp/extracted/img_1.png']);
    });

    test('readFormFields delegates to channel', () async {
      mockChannel((call) async => [
            {
              'name': 'First Name',
              'value': 'Sreeraj',
              'type': 'Tx',
              'readOnly': false,
            }
          ]);

      final fields = await sut.readFormFields('/path/to/doc.pdf');
      expect(fields, hasLength(1));
      expect(fields[0]['name'], 'First Name');
      expect(fields[0]['value'], 'Sreeraj');
    });

    test('readFormFieldsToFile writes json and returns path', () async {
      mockChannel((call) async => [
            {
              'name': 'First Name',
              'value': 'Sreeraj',
              'type': 'Tx',
              'readOnly': false,
            }
          ]);

      final path = await sut.readFormFieldsToFile('/path/to/doc.pdf');
      expect(path, contains('form_fields_'));
      expect(path, endsWith('.json'));

      final file = File(path);
      expect(await file.exists(), isTrue);

      final contents = await file.readAsString();
      final decoded = jsonDecode(contents) as List<dynamic>;
      expect(decoded, hasLength(1));
      expect(decoded[0]['name'], 'First Name');
      expect(decoded[0]['value'], 'Sreeraj');

      // Cleanup
      await file.delete();
    });

    test('renderPagesToImages delegates to channel', () async {
      mockChannel((call) async {
        expect(call.method, 'renderPagesToImages');
        expect(call.arguments['format'], 'jpeg');
        expect(call.arguments['dpi'], 200);
        return ['/tmp/extracted/page_1.jpg'];
      });

      final paths = await sut.renderPagesToImages(
        '/path/to/doc.pdf',
        startPage: 1,
        endPage: 1,
        format: 'jpeg',
        dpi: 200,
      );
      expect(paths, ['/tmp/extracted/page_1.jpg']);
    });
  });
}
