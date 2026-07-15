import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/format/display_format.dart';

void main() {
  group('DisplayFormat.bytes', () {
    test('shows whole bytes below 1 KB', () {
      expect(DisplayFormat.bytes(0), '0 B');
      expect(DisplayFormat.bytes(1), '1 B');
      expect(DisplayFormat.bytes(900), '900 B');
      expect(DisplayFormat.bytes(1023), '1023 B');
    });

    test('steps up a unit at 1024', () {
      expect(DisplayFormat.bytes(1024), '1.0 KB');
      expect(DisplayFormat.bytes(1024 * 1024), '1.0 MB');
      expect(DisplayFormat.bytes(1024 * 1024 * 1024), '1.0 GB');
    });

    test('shows one decimal above 1 KB', () {
      expect(DisplayFormat.bytes(1536), '1.5 KB');
      expect(DisplayFormat.bytes(52 * 1024 * 1024), '52.0 MB');
    });

    test('treats a bad (negative) size as zero rather than throwing', () {
      // Display text must never break a screen.
      expect(DisplayFormat.bytes(-1), '0 B');
    });

    test('stops at the largest unit it knows', () {
      const huge = 5 * 1024 * 1024 * 1024 * 1024;
      expect(DisplayFormat.bytes(huge), '5.0 TB');
    });
  });

  group('DisplayFormat.dateTime', () {
    test('formats a date and time', () {
      final value = DateTime(2026, 7, 14, 16, 22);
      expect(DisplayFormat.dateTime(value, 'en_US'), 'Jul 14, 2026 16:22');
    });

    test('falls back instead of throwing when locale data is missing', () {
      // Date symbols are only loaded for the running app's locale. An unknown
      // locale must still render text — the sheet must never break.
      final value = DateTime(2026, 7, 14, 16, 22);
      expect(DisplayFormat.dateTime(value, 'zz_ZZ'), contains('2026'));
    });
  });
}
