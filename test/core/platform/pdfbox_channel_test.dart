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
}
