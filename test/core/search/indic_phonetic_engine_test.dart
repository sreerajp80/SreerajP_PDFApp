import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/search/indic_phonetic_engine.dart';

void main() {
  const sut = IndicPhoneticEngine();

  group('Chillu and Virama unification', () {
    test('unifies atomic chillu into consonant + virama', () {
      expect(sut.phoneticFold('അവൻ'), sut.phoneticFold('അവന്'));
      expect(sut.phoneticFold('പാൽ'), sut.phoneticFold('പാല്'));
      expect(sut.phoneticFold('കൺ'), sut.phoneticFold('കണ്'));
      expect(sut.phoneticFold('വാക്ക്'), contains('വാക്'));
    });
  });

  group('Anusvara and class nasal unification', () {
    test('Malayalam Anusvara to class nasals', () {
      // സംഗീതം vs സങ്ഗീതം
      expect(sut.phoneticFold('സംഗീതം'), sut.phoneticFold('സങ്ഗീതം'));

      // സന്തോഷം vs സന്തോ ഷം
      expect(sut.phoneticFold('സംതോഷം'), sut.phoneticFold('സന്തോഷം'));

      // സഞ്ചയം vs സംചയം
      expect(sut.phoneticFold('സംചയം'), sut.phoneticFold('സഞ്ചയം'));

      // സമ്പത്ത് vs സംപത്ത്
      expect(sut.phoneticFold('സംപത്ത്'), sut.phoneticFold('സമ്പത്ത്'));
    });

    test('Devanagari Anusvara to class nasals', () {
      // गंगा vs गङ्गा
      expect(sut.phoneticFold('गंगा'), sut.phoneticFold('गङ्गा'));

      // संत vs सन्त
      expect(sut.phoneticFold('संत'), sut.phoneticFold('सन्त'));

      // चंचल vs चञ्चल
      expect(sut.phoneticFold('चंचल'), sut.phoneticFold('चञ्चल'));

      // पंडित vs पण्डित
      expect(sut.phoneticFold('पंडित'), sut.phoneticFold('पण्डित'));

      // कंप vs कम्प
      expect(sut.phoneticFold('कंप'), sut.phoneticFold('कम्प'));
    });
  });

  group('Malayalam NTA ligature variants', () {
    test('unifies ന്റ, ൻറ, ൻറ്റ', () {
      expect(sut.phoneticFold('എന്റെ'), sut.phoneticFold('എൻറെ'));
      expect(sut.phoneticFold('എന്റെ'), sut.phoneticFold('എൻറ്റെ'));
    });
  });

  group('Repha gemination in Sanskrit texts', () {
    test('Malayalam script Sanskrit repha gemination', () {
      expect(sut.phoneticFold('ധർമ്മം'), sut.phoneticFold('ധർമം'));
      expect(sut.phoneticFold('കർമ്മം'), sut.phoneticFold('കർമം'));
      expect(sut.phoneticFold('സർവ്വം'), sut.phoneticFold('സർവം'));
      expect(sut.phoneticFold('സൂര്യ്യൻ'), sut.phoneticFold('സൂര്യൻ'));
    });

    test('Devanagari script Sanskrit repha gemination', () {
      expect(sut.phoneticFold('धर्म्म'), sut.phoneticFold('धर्म'));
      expect(sut.phoneticFold('कर्म्म'), sut.phoneticFold('कर्म'));
      expect(sut.phoneticFold('सर्व्व'), sut.phoneticFold('सर्व'));
      expect(sut.phoneticFold('सूर्य्य'), sut.phoneticFold('सूर्य'));
    });
  });

  group('Avagraha ignorable folding', () {
    test('removes Avagraha in Malayalam and Devanagari', () {
      expect(sut.phoneticFold('സോഽപി'), sut.phoneticFold('സോപി'));
      expect(sut.phoneticFold('सोऽपि'), sut.phoneticFold('सोपि'));
    });
  });
}
