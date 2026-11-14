import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/reading/domain/tts_speed.dart';

void main() {
  group('nextSpeechRate', () {
    test('steps through the speeds and wraps around', () {
      expect(nextSpeechRate(0.75), 1.0);
      expect(nextSpeechRate(1.0), 1.25);
      expect(nextSpeechRate(1.25), 1.5);
      expect(nextSpeechRate(1.5), 2.0);
      expect(nextSpeechRate(2.0), 0.75);
    });

    test('a value between steps goes to the next higher step', () {
      expect(nextSpeechRate(0.5), 0.75);
      expect(nextSpeechRate(1.1), 1.25);
      expect(nextSpeechRate(1.9), 2.0);
    });

    test('a value a hair off a step counts as that step', () {
      expect(nextSpeechRate(1.2500001), 1.5);
      expect(nextSpeechRate(0.9999999), 1.25);
    });
  });

  test('speechRateFractionDigits shows only the digits needed', () {
    expect(speechRateFractionDigits(1.0), 0);
    expect(speechRateFractionDigits(2.0), 0);
    expect(speechRateFractionDigits(1.5), 1);
    expect(speechRateFractionDigits(1.25), 2);
    expect(speechRateFractionDigits(0.75), 2);
  });
}
