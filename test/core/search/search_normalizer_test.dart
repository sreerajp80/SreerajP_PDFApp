import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';

// Characters that are invisible, combining, or easy to confuse are built from
// their code points, so this test says exactly what it means and cannot be
// broken by an editor quietly rewriting a literal.

final zwj = String.fromCharCode(0x200D);
final zwnj = String.fromCharCode(0x200C);

// Malayalam.
const na = 'ന'; // U+0D28
const ka = 'ക'; // U+0D15
final virama = String.fromCharCode(0x0D4D); // chandrakkala
final chilluN = String.fromCharCode(0x0D7B); // atomic form of na+virama+zwj
final chilluK = String.fromCharCode(0x0D7F);
final aaSign = String.fromCharCode(0x0D3E); // vowel sign AA

// Devanagari / Sanskrit.
const kaDev = 'क'; // U+0915
final nukta = String.fromCharCode(0x093C);
final qaPrecomposed = String.fromCharCode(0x0958); // a composition exclusion
final udatta = String.fromCharCode(0x0951); // a Vedic accent

// Latin.
final acute = String.fromCharCode(0x0301);
final ePrecomposed = String.fromCharCode(0x00E9); // é

void main() {
  const sut = SearchNormalizer();

  group('the original text is never changed', () {
    test('normalize reports positions into the untouched source', () {
      const text = 'Hello';
      final result = sut.normalize(text);

      // The key is folded (lowercased), but the source range still points at
      // the original spelling.
      expect(result.key, 'hello');
      final match = result.findAll(sut.queryKey('hello')).single;
      expect(text.substring(match.sourceStart, match.sourceEnd), 'Hello');
    });
  });

  group('chillu: the two spellings are the same word', () {
    test('old spelling (na + virama + zwj) folds to the atomic chillu', () {
      final old = sut.normalize('$na$virama$zwj').key;

      expect(old, chilluN);
      expect(old, sut.normalize(chilluN).key);
    });

    test('typing either spelling finds the other', () {
      final page = sut.normalize('$na$virama$zwj'); // stored the old way
      final matches = page.findAll(sut.queryKey(chilluN)); // typed the new way

      expect(matches, hasLength(1));
      // The highlight must cover all three original characters, not just one.
      expect(matches.single.sourceStart, 0);
      expect(matches.single.sourceEnd, 3);
    });

    test('every chillu consonant folds', () {
      expect(sut.normalize('$ka$virama$zwj').key, chilluK);
      expect(sut.normalize('ണ$virama$zwj').key, String.fromCharCode(0x0D7A));
      expect(sut.normalize('ര$virama$zwj').key, String.fromCharCode(0x0D7C));
      expect(sut.normalize('ല$virama$zwj').key, String.fromCharCode(0x0D7D));
      expect(sut.normalize('ള$virama$zwj').key, String.fromCharCode(0x0D7E));
    });

    test('a consonant + virama without a joiner is left alone', () {
      // This is a real conjunct, not a chillu — folding it would be wrong.
      expect(sut.normalize('$na$virama').key, isNot(chilluN));
    });
  });

  group('ZWJ / ZWNJ are ignorable in the key only', () {
    test('a joiner does not change the key', () {
      expect(sut.normalize('$ka$zwnj$ka').key, sut.normalize('$ka$ka').key);
    });

    test('a query without joiners still finds text that has them', () {
      final page = sut.normalize('$ka$zwnj$ka');
      expect(page.findAll(sut.queryKey('$ka$ka')), hasLength(1));
    });

    test('the highlight still covers a joiner sitting inside the match', () {
      final text = '$ka$zwnj$ka';
      final matches = sut.normalize(text).findAll(sut.queryKey('$ka$ka'));

      expect(matches.single.sourceStart, 0);
      expect(matches.single.sourceEnd, text.length);
    });
  });

  group('strict mode keeps joiners significant', () {
    const strict = SearchNormalizer(SearchOptions(strict: true));

    test('the two chillu spellings stay apart', () {
      expect(
        strict.normalize('$na$virama$zwj').key,
        isNot(strict.normalize(chilluN).key),
      );
    });

    test('a joiner is kept, so a query without it does not match', () {
      final page = strict.normalize('$ka$zwnj$ka');
      expect(page.findAll(strict.queryKey('$ka$ka')), isEmpty);
    });
  });

  group('NFC equivalence', () {
    test('composed and decomposed Latin share one key', () {
      expect(sut.normalize('e$acute').key, sut.normalize(ePrecomposed).key);
    });

    test('Devanagari nukta: precomposed and combined forms match', () {
      // U+0958 is a composition exclusion, so NFC settles both spellings on the
      // decomposed one. That is why nukta needs no fold of its own.
      expect(
        sut.normalize(qaPrecomposed).key,
        sut.normalize('$kaDev$nukta').key,
      );
    });

    test('a query in either nukta form finds the other', () {
      final page = sut.normalize(qaPrecomposed);
      expect(page.findAll(sut.queryKey('$kaDev$nukta')), hasLength(1));
    });
  });

  group('accent-insensitive mode (Sanskrit)', () {
    const folding = SearchNormalizer(SearchOptions(ignoreAccents: true));

    test('by default a Vedic accent matters', () {
      final page = sut.normalize('$kaDev$udatta');
      expect(page.findAll(sut.queryKey(kaDev)), isEmpty);
    });

    test('with the option on, an unaccented query finds accented text', () {
      final page = folding.normalize('$kaDev$udatta');
      expect(page.findAll(folding.queryKey(kaDev)), hasLength(1));
    });

    test('the highlight still covers the accent mark', () {
      final text = '$kaDev$udatta';
      final match = folding
          .normalize(text)
          .findAll(folding.queryKey(kaDev))
          .single;

      expect(match.sourceEnd, text.length);
    });

    test('nukta is not an accent — it stays significant', () {
      // Nukta changes which letter this is, so folding it would be wrong.
      final page = folding.normalize('$kaDev$nukta');
      expect(page.findAll(folding.queryKey(kaDev)), isEmpty);
    });
  });

  group('grapheme-cluster-aware matching', () {
    test('a match never splits a letter from its vowel sign', () {
      // 'ka' must not match the consonant inside the cluster 'kaa'.
      final page = sut.normalize('$ka$aaSign');
      expect(page.findAll(sut.queryKey(ka)), isEmpty);
    });

    test('the whole cluster matches when the query is the whole cluster', () {
      final page = sut.normalize('$ka$aaSign');
      expect(page.findAll(sut.queryKey('$ka$aaSign')), hasLength(1));
    });
  });

  group('offset back-mapping', () {
    test('finds the right source range for a match in the middle', () {
      const text = 'one two three';
      final match = sut.normalize(text).findAll(sut.queryKey('two')).single;

      expect(text.substring(match.sourceStart, match.sourceEnd), 'two');
    });

    test('maps every match when a word repeats', () {
      const text = 'cat dog cat';
      final matches = sut.normalize(text).findAll(sut.queryKey('cat'));

      expect(matches, hasLength(2));
      expect(matches.first.sourceStart, 0);
      expect(matches.last.sourceStart, 8);
    });

    test('matches do not overlap', () {
      final matches = sut.normalize('aaaa').findAll(sut.queryKey('aa'));

      expect(matches, hasLength(2));
      expect(
        matches.first.sourceEnd,
        lessThanOrEqualTo(matches.last.sourceStart),
      );
    });
  });

  group('everyday search behaviour', () {
    test('search ignores letter case', () {
      final page = sut.normalize('The Quick Fox');
      expect(page.findAll(sut.queryKey('quick')), hasLength(1));
    });

    test('a phrase matches across a line break', () {
      // pdfium hands back real newlines inside a wrapped sentence.
      final page = sut.normalize('hello\nworld');
      expect(page.findAll(sut.queryKey('hello world')), hasLength(1));
    });

    test('an empty query finds nothing', () {
      expect(sut.normalize('anything').findAll(sut.queryKey('')), isEmpty);
    });

    test('empty text finds nothing', () {
      expect(sut.normalize('').findAll(sut.queryKey('x')), isEmpty);
    });

    test('a query longer than the text finds nothing', () {
      expect(sut.normalize('ab').findAll(sut.queryKey('abc')), isEmpty);
    });
  });
}
