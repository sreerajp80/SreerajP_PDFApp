import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/config/app_config.dart';

void main() {
  group('AppConfig.fromJson', () {
    test('reads all fields from a well-formed map', () {
      final config = AppConfig.fromJson({
        'appName': 'Test App',
        'description': 'A test.',
        'version': '2.0.1',
        'build': '42',
        'details': {'Author': 'Sreeraj', 'Email': 'x@y.z'},
      });

      expect(config.appName, 'Test App');
      expect(config.description, 'A test.');
      expect(config.version, '2.0.1');
      expect(config.build, '42');
      expect(config.details['Author'], 'Sreeraj');
      expect(config.details['Email'], 'x@y.z');
    });

    test('falls back per field on missing or wrong-typed values', () {
      final config = AppConfig.fromJson({'appName': 123, 'version': null});

      expect(config.appName, AppConfig.fallback.appName);
      expect(config.version, AppConfig.fallback.version);
      expect(config.details, isEmpty);
    });

    test('ignores non-string entries inside details', () {
      final config = AppConfig.fromJson({
        'details': {'Good': 'yes', 'Bad': 5, 7: 'nope'},
      });

      expect(config.details, {'Good': 'yes'});
    });
  });
}
