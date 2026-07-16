import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/pdfbox');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// Answers the next `readMetadata` call with [handler].
  void mockChannel(Future<Object?>? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(channel, handler);
  }

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  final sut = PdfBoxChannel(method: channel);

  group('readMetadata', () {
    test('maps every field the native side returns', () async {
      mockChannel(
        (call) async => {
          'title': 'A Title',
          'author': 'An Author',
          'subject': 'A Subject',
          'keywords': 'one, two',
          'creator': 'Writer',
          'producer': 'PdfBox',
          'creationDate': 1752494520000,
          'modificationDate': 1752494520000,
          'pageCount': 12,
          'encrypted': false,
          'pdfVersion': '1.7',
        },
      );

      final result = await sut.readMetadata('/tmp/a.pdf');

      expect(result.title, 'A Title');
      expect(result.author, 'An Author');
      expect(result.subject, 'A Subject');
      expect(result.keywords, 'one, two');
      expect(result.creator, 'Writer');
      expect(result.producer, 'PdfBox');
      expect(result.pageCount, 12);
      expect(result.encrypted, isFalse);
      expect(result.pdfVersion, '1.7');
      expect(
        result.creationDate,
        DateTime.fromMillisecondsSinceEpoch(1752494520000),
      );
      expect(result.isEmpty, isFalse);
    });

    test(
      'passes the cache path, and no password unless one is given',
      () async {
        MethodCall? seen;
        mockChannel((call) async {
          seen = call;
          return {'pageCount': 1, 'encrypted': false};
        });

        await sut.readMetadata('/tmp/a.pdf');

        expect(seen!.method, 'readMetadata');
        expect(seen!.arguments, {'path': '/tmp/a.pdf'});
      },
    );

    test('sends the password only when the caller supplies one', () async {
      MethodCall? seen;
      mockChannel((call) async {
        seen = call;
        return {'pageCount': 1, 'encrypted': false};
      });

      await sut.readMetadata('/tmp/a.pdf', password: 'secret');

      expect(seen!.arguments, {'path': '/tmp/a.pdf', 'password': 'secret'});
    });

    test('a PDF with no description fields reports isEmpty', () async {
      mockChannel((call) async => {'pageCount': 3, 'encrypted': false});

      final result = await sut.readMetadata('/tmp/a.pdf');

      expect(result.isEmpty, isTrue);
      expect(result.pageCount, 3);
    });

    test('a locked PDF becomes a typed password exception', () async {
      mockChannel(
        (call) async =>
            throw PlatformException(code: 'password_required', message: 'x'),
      );

      expect(
        () => sut.readMetadata('/tmp/a.pdf'),
        throwsA(isA<PdfPasswordRequiredException>()),
      );
    });

    test('an unreadable PDF becomes a typed open exception, not a crash', () {
      mockChannel(
        (call) async =>
            throw PlatformException(code: 'read_failed', message: 'x'),
      );

      expect(
        () => sut.readMetadata('/tmp/a.pdf'),
        throwsA(isA<PdfOpenException>()),
      );
    });

    test('a missing native side fails typed rather than crashing', () {
      // Host tests and unsupported platforms have no plugin registered.
      mockChannel((call) async => throw MissingPluginException('no impl'));

      expect(
        () => sut.readMetadata('/tmp/a.pdf'),
        throwsA(isA<PdfOpenException>()),
      );
    });

    test('a null result fails typed rather than crashing', () {
      mockChannel((call) async => null);

      expect(
        () => sut.readMetadata('/tmp/a.pdf'),
        throwsA(isA<PdfOpenException>()),
      );
    });
  });

  group('extractText', () {
    test('calls native and returns text', () async {
      mockChannel((call) async {
        expect(call.method, 'extractText');
        expect(call.arguments, {
          'path': '/tmp/a.pdf',
          'password': 'pass',
          'startPage': 1,
          'endPage': 2,
        });
        return 'Hello, extraction!';
      });

      final result = await sut.extractText(
        '/tmp/a.pdf',
        password: 'pass',
        startPage: 1,
        endPage: 2,
      );
      expect(result, 'Hello, extraction!');
    });

    test('handles exceptions gracefully', () async {
      mockChannel(
        (call) async =>
            throw PlatformException(code: 'read_failed', message: 'x'),
      );
      expect(
        () => sut.extractText('/tmp/a.pdf'),
        throwsA(isA<PdfOpenException>()),
      );
    });
  });

  group('extractImages', () {
    test('calls native and returns output paths', () async {
      mockChannel((call) async {
        expect(call.method, 'extractImages');
        expect(call.arguments, {
          'path': '/tmp/a.pdf',
          'outputDir': '/tmp/out',
          'password': null,
          'startPage': 1,
          'endPage': 3,
        });
        return ['/tmp/out/img1.png', '/tmp/out/img2.png'];
      });

      final result = await sut.extractImages(
        '/tmp/a.pdf',
        '/tmp/out',
        startPage: 1,
        endPage: 3,
      );
      expect(result, ['/tmp/out/img1.png', '/tmp/out/img2.png']);
    });
  });

  group('readFormFields', () {
    test('calls native and maps results to dynamic map list', () async {
      mockChannel((call) async {
        expect(call.method, 'readFormFields');
        return [
          {
            'name': 'fieldName1',
            'value': 'value1',
            'type': 'Tx',
            'readOnly': false,
          },
          {
            'name': 'fieldName2',
            'value': 'value2',
            'type': 'Btn',
            'readOnly': true,
          },
        ];
      });

      final result = await sut.readFormFields('/tmp/a.pdf');
      expect(result, hasLength(2));
      expect(result[0]['name'], 'fieldName1');
      expect(result[0]['value'], 'value1');
      expect(result[0]['type'], 'Tx');
      expect(result[0]['readOnly'], isFalse);

      expect(result[1]['name'], 'fieldName2');
      expect(result[1]['value'], 'value2');
      expect(result[1]['type'], 'Btn');
      expect(result[1]['readOnly'], isTrue);
    });
  });

  group('renderPagesToImages', () {
    test('calls native and returns paths of rendered pages', () async {
      mockChannel((call) async {
        expect(call.method, 'renderPagesToImages');
        expect(call.arguments, {
          'path': '/tmp/a.pdf',
          'outputDir': '/tmp/out',
          'password': null,
          'startPage': 1,
          'endPage': 1,
          'format': 'png',
          'dpi': 150,
        });
        return ['/tmp/out/page_1.png'];
      });

      final result = await sut.renderPagesToImages(
        '/tmp/a.pdf',
        '/tmp/out',
        startPage: 1,
        endPage: 1,
      );
      expect(result, ['/tmp/out/page_1.png']);
    });
  });

  group('page operations (Phase 4)', () {
    test('mergePdfs sends the paths and returns the output path', () async {
      mockChannel((call) async {
        expect(call.method, 'mergePdfs');
        expect(call.arguments['paths'], ['/a.pdf', '/b.pdf']);
        expect(call.arguments['outputPath'], '/out/merged.pdf');
        return '/out/merged.pdf';
      });

      final result = await sut.mergePdfs([
        '/a.pdf',
        '/b.pdf',
      ], '/out/merged.pdf');
      expect(result, '/out/merged.pdf');
    });

    test('splitPdf returns the per-page paths', () async {
      mockChannel((call) async {
        expect(call.method, 'splitPdf');
        expect(call.arguments['path'], '/a.pdf');
        expect(call.arguments['outputDir'], '/out');
        return ['/out/a_page_1.pdf'];
      });

      final result = await sut.splitPdf('/a.pdf', '/out');
      expect(result, ['/out/a_page_1.pdf']);
    });

    test('organizePages forwards the ordered page list', () async {
      mockChannel((call) async {
        expect(call.method, 'organizePages');
        expect(call.arguments['pages'], [
          {'page': 1, 'rotation': 90},
        ]);
        return '/out/organized.pdf';
      });

      final result = await sut.organizePages('/a.pdf', '/out/organized.pdf', [
        {'page': 1, 'rotation': 90},
      ]);
      expect(result, '/out/organized.pdf');
    });

    test('encryptPdf forwards the passwords', () async {
      mockChannel((call) async {
        expect(call.method, 'encryptPdf');
        expect(call.arguments['userPassword'], 'u');
        expect(call.arguments['ownerPassword'], 'o');
        return '/out/protected.pdf';
      });

      final result = await sut.encryptPdf(
        '/a.pdf',
        '/out/protected.pdf',
        userPassword: 'u',
        ownerPassword: 'o',
      );
      expect(result, '/out/protected.pdf');
    });

    test('decryptPdf maps a wrong password to a typed exception', () async {
      mockChannel((call) async {
        throw PlatformException(code: 'password_required', message: 'bad');
      });

      await expectLater(
        sut.decryptPdf('/a.pdf', '/out/unlocked.pdf', password: 'x'),
        throwsA(isA<PdfPasswordRequiredException>()),
      );
    });
  });
}
