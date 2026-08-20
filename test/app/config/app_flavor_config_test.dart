import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/app_flavor_config.dart';

void main() {
  group('AppFlavorConfig', () {
    // Without --dart-define/--flavor, FLUTTER_APP_FLAVOR defaults to 'prod',
    // so a plain test run resolves to prod.
    test('defaults to prod when no flavor is provided', () {
      expect(AppFlavorConfig.instance.isProd, isTrue);
      expect(AppFlavorConfig.instance.isDev, isFalse);
      expect(AppFlavorConfig.instance.appName, 'SreerajP PDF App');
    });
  });
}
