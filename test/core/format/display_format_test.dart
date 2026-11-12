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

  group('DisplayFormat.decimal', () {
    test('uses exactly the asked number of decimals', () {
      expect(DisplayFormat.decimal(1, 'en', fractionDigits: 2), '1.00');
      expect(DisplayFormat.decimal(0.456, 'en', fractionDigits: 1), '0.5');
      expect(DisplayFormat.decimal(12, 'en'), '12');
    });

    test('never groups thousands in plain settings numbers', () {
      expect(DisplayFormat.decimal(12345, 'en'), '12345');
    });

    test('Sanskrit and unknown locales fall back to English patterns', () {
      expect(DisplayFormat.formattingLocale('sa'), 'en');
      expect(DisplayFormat.formattingLocale('zz_ZZ'), 'en');
      expect(DisplayFormat.decimal(1.5, 'sa', fractionDigits: 1), '1.5');
    });

    test('known locales are used as they are', () {
      expect(DisplayFormat.formattingLocale('ml'), 'ml');
      expect(DisplayFormat.formattingLocale('en'), 'en');
    });

    test('language tags are turned into intl keys', () {
      expect(DisplayFormat.formattingLocale('en-US'), 'en_US');
      expect(DisplayFormat.formattingLocale('en_US'), 'en_US');
    });

    test('an unknown region falls back to the language code', () {
      expect(DisplayFormat.formattingLocale('ml_ZZ'), 'ml');
      expect(DisplayFormat.formattingLocale('sa-IN'), 'en');
    });

    test('a malformed name falls back to English', () {
      expect(DisplayFormat.formattingLocale(''), 'en');
      expect(DisplayFormat.formattingLocale('???'), 'en');
    });

    test('bytes use the locale for the number', () {
      expect(DisplayFormat.bytes(1536, 'sa'), '1.5 KB');
      expect(DisplayFormat.bytes(1536, 'ml'), '1.5 KB');
    });
  });
}
