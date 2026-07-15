import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';

void main() {
  group('AppException hierarchy', () {
    test('all typed exceptions are AppExceptions', () {
      expect(const StorageException('db'), isA<AppException>());
      expect(const ValidationException('field', 'bad'), isA<AppException>());
      expect(const PdfException('parse'), isA<AppException>());
    });

    test('carries message and cause', () {
      final cause = Exception('root');
      final e = StorageException('open failed', cause: cause);

      expect(e.message, 'open failed');
      expect(e.cause, cause);
      expect(e.toString(), contains('open failed'));
    });

    test('ValidationException records the field', () {
      const e = ValidationException('password', 'too short');
      expect(e.field, 'password');
      expect(e.message, 'too short');
    });
  });
}
