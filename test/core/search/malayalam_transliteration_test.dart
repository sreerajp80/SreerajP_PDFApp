import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/search/malayalam_transliteration.dart';

void main() {
  group('MalayalamTransliteration', () {
    test('transliterates basic vowels and consonants', () {
      expect(MalayalamTransliteration.transliterate('a'), 'അ');
      expect(MalayalamTransliteration.transliterate('aa'), 'ആ');
      expect(MalayalamTransliteration.transliterate('i'), 'ഇ');
      expect(MalayalamTransliteration.transliterate('u'), 'ഉ');
      expect(MalayalamTransliteration.transliterate('e'), 'എ');
      expect(MalayalamTransliteration.transliterate('o'), 'ഒ');
    });

    test('transliterates syllables with vowel signs', () {
      expect(MalayalamTransliteration.transliterate('ka'), 'ക');
      expect(MalayalamTransliteration.transliterate('kaa'), 'കാ');
      expect(MalayalamTransliteration.transliterate('ki'), 'കി');
      expect(MalayalamTransliteration.transliterate('kee'), 'കീ');
      expect(MalayalamTransliteration.transliterate('ku'), 'കു');
      expect(MalayalamTransliteration.transliterate('koo'), 'കൂ');
    });

    test('transliterates chillu letters', () {
      expect(MalayalamTransliteration.transliterate('n~'), 'ൻ');
      expect(MalayalamTransliteration.transliterate('r~'), 'ർ');
      expect(MalayalamTransliteration.transliterate('l~'), 'ൽ');
      expect(MalayalamTransliteration.transliterate('L~'), 'ൾ');
      expect(MalayalamTransliteration.transliterate('N~'), 'ൺ');
    });

    test('transliterates common words', () {
      expect(MalayalamTransliteration.transliterate('malayalam'), 'മലയാളം');
      expect(MalayalamTransliteration.transliterate('keralam'), 'കേരളം');
    });

    test('generates suggestions for query', () {
      final suggestions = MalayalamTransliteration.suggestionsFor('namaskaram');
      expect(suggestions, isNotEmpty);
      expect(suggestions.first, contains('നമസ്കാരം'));
    });
  });
}
