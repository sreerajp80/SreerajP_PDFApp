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
        'details': {'author': 'Sreeraj', 'email': 'x@y.z'},
      });

      expect(config.appName.resolve('en'), 'Test App');
      expect(config.description.resolve('en'), 'A test.');
      expect(config.version, '2.0.1');
      expect(config.build, '42');
      expect(config.details['author']?.resolve('en'), 'Sreeraj');
      expect(config.details['email']?.resolve('en'), 'x@y.z');
    });

    test('reads localized appName, description and details', () {
      final config = AppConfig.fromJson({
        'appName': {
          'en': 'SreerajP PDF App',
          'ml': 'ശ്രീരാജ് പി പി.ഡി.എഫ്. ആപ്പ്',
          'sa': 'श्रीराजपि PDF अनुप्रयोगः',
        },
        'description': {
          'en': 'English desc',
          'ml': 'Malayalam desc',
          'sa': 'संस्कृत विवरणम्',
        },
        'version': '2.0.1',
        'build': '42',
        'details': {
          'license': {
            'en': 'English license',
            'ml': 'Malayalam license',
            'sa': 'अनुज्ञापत्रम्',
          },
        },
      });

      expect(config.appName.resolve('en'), 'SreerajP PDF App');
      expect(config.appName.resolve('ml'), 'ശ്രീരാജ് പി പി.ഡി.എഫ്. ആപ്പ്');
      expect(config.appName.resolve('sa'), 'श्रीराजपि PDF अनुप्रयोगः');
      expect(config.description.resolve('en'), 'English desc');
      expect(config.description.resolve('ml'), 'Malayalam desc');
      expect(config.description.resolve('sa'), 'संस्कृत विवरणम्');
      expect(config.details['license']?.resolve('en'), 'English license');
      expect(config.details['license']?.resolve('ml'), 'Malayalam license');
      expect(config.details['license']?.resolve('sa'), 'अनुज्ञापत्रम्');
    });

    test('falls back per field on missing or wrong-typed values', () {
      final config = AppConfig.fromJson({'appName': 123, 'version': null});

      expect(
        config.appName.resolve('en'),
        AppConfig.fallback.appName.resolve('en'),
      );
      expect(config.version, AppConfig.fallback.version);
      expect(config.details, isEmpty);
    });

    test('ignores non-string and non-map entries inside details', () {
      final config = AppConfig.fromJson({
        'details': {'good': 'yes', 'bad': 5, 7: 'nope'},
      });

      expect(config.details.containsKey('good'), isTrue);
      expect(config.details['good']?.resolve('en'), 'yes');
      expect(config.details.containsKey('bad'), isFalse);
    });
  });
}
