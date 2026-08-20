import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/search/sandhi_engine.dart';

void main() {
  const sut = SandhiEngine();

  group('Malayalam Vowel Sandhi (സ്വരസന്ധി)', () {
    test('Savarna Deergha Sandhi (സവർണ്ണദീർഘസന്ധി)', () {
      // വിദ്യ + ആലയം -> വിദ്യാലയം
      final r1 = sut.joinWords('വിദ്യ', 'ആലയം');
      expect(r1, contains('വിദ്യാലയം'));

      // ഹിമ + ആലയം -> ഹിമാലയം
      final r2 = sut.joinWords('ഹിമ', 'ആലയം');
      expect(r2, contains('ഹിമാലയം'));

      // ഗിരി + ഈശ -> ഗിരീശ
      final r3 = sut.joinWords('ഗിരി', 'ഈശ');
      expect(r3, contains('ഗിരീശ'));

      // ഭാനു + ഉദയം -> ഭാനൂദയം
      final r4 = sut.joinWords('ഭാനു', 'ഉദയം');
      expect(r4, contains('ഭാനൂദയം'));
    });

    test('Guna Sandhi (ഗുണസന്ധി)', () {
      // മഹാ + ഈശ -> മഹേശ
      final r1 = sut.joinWords('മഹാ', 'ഈശ');
      expect(r1, contains('മഹേശ'));

      // സൂര്യ + ഉദയം -> സൂര്യോദയം
      final r2 = sut.joinWords('സൂര്യ', 'ഉദയം');
      expect(r2, contains('സൂര്യോദയം'));

      // മഹാ + ഋഷി -> മഹർഷി
      final r3 = sut.joinWords('മഹാ', 'ഋഷി');
      expect(r3, contains('മഹർഷി'));
    });

    test('Vriddhi Sandhi (വൃദ്ധിസന്ധി)', () {
      // ഏക + ഏക -> ഏകൈക
      final r1 = sut.joinWords('ഏക', 'ഏക');
      expect(r1, contains('ഏകൈക'));

      // മഹാ + ഔഷധം -> മഹൗഷധം
      final r2 = sut.joinWords('മഹാ', 'ഔഷധം');
      expect(r2, contains('മഹൗഷധം'));
    });

    test('Yan Sandhi (യൺസന്ധി)', () {
      // ഇതി + ആദി -> ഇത്യാദി
      final r1 = sut.joinWords('ഇതി', 'ആദി');
      expect(r1, contains('ഇത്യാദി'));

      // പ്രതി + ഏകം -> പ്രത്യേകം
      final r2 = sut.joinWords('പ്രതി', 'ഏകം');
      expect(r2, contains('പ്രത്യേകം'));

      // അനു + അയം -> അന്വയം
      final r3 = sut.joinWords('അനു', 'അയം');
      expect(r3, contains('അന്വയം'));
    });

    test('Dravidian Agama Sandhi (ആഗമസന്ധി)', () {
      // തിരു + ഓണം -> തിരുവോണം
      final r1 = sut.joinWords('തിരു', 'ഓണം');
      expect(r1, contains('തിരുവോണം'));

      // പൂ + ഇതൾ -> പൂവിതൾ
      final r2 = sut.joinWords('പൂ', 'ഇതൾ');
      expect(r2, contains('പൂവിതൾ'));

      // വഴി + അരികിൽ -> വഴിയരികിൽ
      final r3 = sut.joinWords('വഴി', 'അരികിൽ');
      expect(r3, contains('വഴിയരികിൽ'));
    });

    test('Dravidian Lopa Sandhi (ലോപസന്ധി)', () {
      // വന്നു + ഇല്ല -> വന്നില്ല
      final r1 = sut.joinWords('വന്നു', 'ഇല്ല');
      expect(r1, contains('വന്നില്ല'));

      // പോയി + ഇല്ല -> പോയില്ല
      final r2 = sut.joinWords('പോയി', 'ഇല്ല');
      expect(r2, contains('പോയില്ല'));

      // നല്ല + ആൾ -> നല്ലാൾ
      final r3 = sut.joinWords('നല്ല', 'ആൾ');
      expect(r3, contains('നല്ലാൾ'));
    });

    test('Poorvaroopa / Avagraha Sandhi', () {
      // തേ + അപി -> തേഽപി / തേപി
      final r1 = sut.joinWords('തേ', 'അപി');
      expect(r1, anyOf(contains('തേഽപി'), contains('തേപി')));
    });
  });

  group('Malayalam Consonant Sandhi & Dvitva', () {
    test('Consonant doubling (ദ്വിത്വസന്ധി: ക, ച, ത, പ)', () {
      // കിളി + കൂട് -> കിളിക്കൂട്
      expect(sut.joinWords('കിളി', 'കൂട്'), contains('കിളിക്കൂട്'));

      // മഴ + കാലം -> മഴക്കാലം
      expect(sut.joinWords('മഴ', 'കാലം'), contains('മഴക്കാലം'));

      // കൈ + കൂപ്പ് -> കൈക്കൂപ്പ്
      expect(sut.joinWords('കൈ', 'കൂപ്പ്'), contains('കൈക്കൂപ്പ്'));
    });

    test('Anunasika, Jashthva, and Schutva Sandhi', () {
      // സത് + മാര്ഗ്ഗം -> സന്മാര്ഗ്ഗം
      final r1 = sut.joinWords('സത്', 'മാര്ഗ്ഗം');
      expect(r1, anyOf(contains('സന്മാര്ഗ്ഗം'), contains('സൻമാർഗ്ഗം')));

      // ജഗത് + നാഥ -> ജഗന്നാഥ
      expect(sut.joinWords('ജഗത്', 'നാഥ'), contains('ജഗന്നാഥ'));

      // സത് + ചരിതം -> സച്ചരിതം
      expect(sut.joinWords('സത്', 'ചരിതം'), contains('സച്ചരിതം'));

      // വാക് + ഈശ -> വാഗീശ
      expect(sut.joinWords('വാക്', 'ഈശ'), contains('വാഗീശ'));
    });

    test('Parasavarna Sandhi (Anusvara to class nasals)', () {
      // സം + കല്പം -> സങ്കല്പം
      expect(sut.joinWords('സം', 'കല്പം'), contains('സങ്കല്പം'));

      // സം + ചയം -> സഞ്ചയം
      expect(sut.joinWords('സം', 'ചയം'), contains('സഞ്ചയം'));

      // സം + തോഷം -> സന്തോഷം
      expect(sut.joinWords('സം', 'തോഷം'), contains('സന്തോഷം'));

      // സം + ബന്ധം -> സമ്ബന്ധം / സമ്പന്ധം
      final r4 = sut.joinWords('സം', 'ബന്ധം');
      expect(r4, anyOf(contains('സമ്ബന്ധം'), contains('സമ്പന്ധം')));
    });
  });

  group('Visarga Sandhi (വിസർഗ്ഗസന്ധി)', () {
    test('Sathva (ഃ + ത -> സ്ത, ഃ + ച -> ശ്ച, ഃ + ട -> ഷ്ട)', () {
      // നമഃ + തേ -> നമസ്തേ
      expect(sut.joinWords('നമഃ', 'തേ'), contains('നമസ്തേ'));

      // നിഃ + ചലം -> നിശ്ചലം
      expect(sut.joinWords('നിഃ', 'ചലം'), contains('നിശ്ചലം'));

      // ധനുഃ + ടങ്കാരം -> ധനുഷ്ടങ്കാരം
      expect(sut.joinWords('ധനുഃ', 'ടങ്കാരം'), contains('ധനുഷ്ടങ്കാരം'));
    });

    test('Ruthva (ഃ -> ർ / ര്)', () {
      // പുനഃ + അപി -> പുനരപി
      expect(
        sut.joinWords('പുനഃ', 'അപി'),
        anyOf(contains('പുനരപി'), contains('പുനർഅപി'), contains('പുനര്അപി')),
      );

      // ജ്യോതിഃ + മയം -> ജ്യോതിർമയം
      expect(
        sut.joinWords('ജ്യോതിഃ', 'മയം'),
        anyOf(contains('ജ്യോതിർമയം'), contains('ജ്യോതിര്മയം')),
      );
    });

    test('Uthva / O (അഃ -> ോ)', () {
      // മനഃ + രഥം -> മനോരഥം
      expect(sut.joinWords('മനഃ', 'രഥം'), contains('മനോരഥം'));
    });
  });

  group('Devanagari Sanskrit Sandhi (देवनागरी सन्धि)', () {
    test('Savarna Deergha Sandhi', () {
      // हिम + आलय -> हिमालय
      expect(sut.joinWords('हिम', 'आलय'), contains('हिमालय'));

      // विद्या + आलय -> विद्यालय
      expect(sut.joinWords('विद्या', 'आलय'), contains('विद्यालय'));
    });

    test('Guna & Vriddhi Sandhi', () {
      // महा + ईश -> महेश
      expect(sut.joinWords('महा', 'ईश'), contains('महेश'));

      // सूर्य + उदय -> सूर्योदय
      expect(sut.joinWords('सूर्य', 'उदय'), contains('सूर्योदय'));

      // एक + एक -> एकैक
      expect(sut.joinWords('एक', 'एक'), contains('एकैक'));
    });

    test('Consonant & Visarga Sandhi in Devanagari', () {
      // सत् + चरित -> सच्चरित
      expect(sut.joinWords('सत्', 'चरित'), contains('सच्चरित'));

      // जगत् + नाथ -> जगन्नाथ
      expect(sut.joinWords('जगत्', 'नाथ'), contains('जगन्नाथ'));

      // नमः + ते -> नमस्ते
      expect(sut.joinWords('नमः', 'ते'), contains('नमस्ते'));
    });
  });

  group('Multi-word phrase compound query generation', () {
    test('generates compound chains for 3 words', () {
      final queries = sut.generateCompoundQueries(['ഹിമ', 'ഗിരി', 'വാസ']);
      expect(queries, isNotEmpty);
      expect(queries, contains('ഹിമഗിരിവാസ'));
    });
  });
}
