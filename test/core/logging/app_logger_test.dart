import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/logging/app_logger.dart';

void main() {
  // Runs before any test calls AppLogger.init(): a log call made early in
  // startup (e.g. from an error handler) must never throw (§14.2).
  test('logging before init does not throw', () {
    expect(() => AppLogger.info('early message'), returnsNormally);
    expect(
      () => AppLogger.error('early error', error: StateError('x')),
      returnsNormally,
    );
  });

  test('logging after init does not throw', () {
    AppLogger.init();
    expect(() => AppLogger.warning('after init'), returnsNormally);
  });
}
