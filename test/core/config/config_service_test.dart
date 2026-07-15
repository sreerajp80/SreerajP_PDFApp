import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/config/config_service.dart';

void main() {
  group('ConfigService.load', () {
    test('parses a valid config asset', () async {
      final service = ConfigService(
        loadAsset: (_) async =>
            '{"appName":"X","description":"d","version":"1.2.3","build":"9"}',
      );

      final config = await service.load();

      expect(config.appName, 'X');
      expect(config.version, '1.2.3');
      expect(config.build, '9');
    });

    test('degrades to fallback on bad JSON', () async {
      final service = ConfigService(loadAsset: (_) async => 'not json{');

      final config = await service.load();

      expect(config.appName, isNotEmpty);
      expect(config.version, '0.0.0'); // fallback value
    });

    test('degrades to fallback when the asset is missing', () async {
      final service = ConfigService(
        loadAsset: (_) async => throw Exception('missing asset'),
      );

      final config = await service.load();

      expect(config.version, '0.0.0');
    });

    test('degrades to fallback when JSON is not an object', () async {
      final service = ConfigService(loadAsset: (_) async => '[1,2,3]');

      final config = await service.load();

      expect(config.version, '0.0.0');
    });
  });
}
