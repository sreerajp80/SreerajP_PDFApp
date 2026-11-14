import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/reading/domain/tts_text_splitter.dart';

void main() {
  test('cuts after sentence marks followed by a space', () {
    expect(splitForSpeech('One. Two! Three? Four।  Five॥ Six| Seven'), [
      'One.',
      'Two!',
      'Three?',
      'Four।',
      'Five॥',
      'Six|',
      'Seven',
    ]);
  });

  test('does not cut inside numbers or at marks with no space after', () {
    expect(splitForSpeech('Version 2.5 is out.'), ['Version 2.5 is out.']);
  });

  test('a line wrap inside a sentence joins with a space, no cut', () {
    expect(splitForSpeech('This sentence wraps\nacross two lines.'), [
      'This sentence wraps across two lines.',
    ]);
  });

  test('empty or blank text gives no pieces, and the list can be cleared', () {
    final pieces = splitForSpeech('  \n ');
    expect(pieces, isEmpty);
    pieces.clear(); // TtsService.stop() clears the queue.
  });

  test('long text with no marks is cut at spaces within the limit', () {
    // Verse-like Malayalam with line breaks and no punctuation.
    final verse = List.filled(40, 'ശ്രീമാതാ ശ്രീമഹാരാജ്ഞീ (1)\n').join();
    final pieces = splitForSpeech(verse, maxLength: 60);

    expect(pieces.length, greaterThan(1));
    for (final piece in pieces) {
      expect(piece.length, lessThanOrEqualTo(60));
      expect(piece, isNot(startsWith(' ')));
      expect(piece, isNot(endsWith(' ')));
    }
    // Nothing is lost: the words come back in order.
    expect(pieces.join(' '), verse.replaceAll('\n', ' ').trim());
  });

  test('a single very long word is hard-cut at the limit', () {
    final word = 'a' * 25;
    expect(splitForSpeech(word, maxLength: 10), ['a' * 10, 'a' * 10, 'a' * 5]);
  });

  test('a hard cut never splits a surrogate pair', () {
    // Each emoji is two UTF-16 units; a cut at 5 would land mid-pair.
    final text = 'ab${'😀' * 4}';
    final pieces = splitForSpeech(text, maxLength: 5);
    expect(pieces.join(), text);
    for (final piece in pieces) {
      expect(piece.runes.every((r) => r < 0xD800 || r > 0xDFFF), isTrue);
    }
  });
}
