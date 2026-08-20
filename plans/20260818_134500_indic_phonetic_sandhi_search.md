# Indic Phonetic and Sandhi-Aware Search (Malayalam & Sanskrit)

**Status:** Proposed

## Problem
Standard PDF search engines compare exact bytes. In Indic languages like Malayalam and Sanskrit (in Malayalam and Devanagari scripts), words often merge together using grammatical Sandhi rules (e.g. `വിദ്യ` + `ആലയം` = `വിദ്യാലയം`, `ഹിമ` + `ആലയം` = `ഹിമാലയം`, `സത്` + `ചരിതം` = `സച്ചരിതം`, `നമഃ` + `തേ` = `നമസ്തേ`, `ഗംഗ` vs `ഗങ്ഗ` / `गंगा` vs `गङ्गा`).
Users searching for split terms, compound roots, alternate chillu/virama spellings, or phonetic sound-alike spellings fail to find matches in document text.

## Fix
Implement a comprehensive phonetic and Sandhi-aware search engine:
1. **Sandhi Rule & Compound Engine (`lib/core/search/sandhi_engine.dart`)**:
   - Vowel Sandhi (സ്വരസന്ധി): Savarna Deergha, Guna, Vriddhi, Yan, Ayadi, and Poorvaroopa Sandhi (including Avagraha handling `ഽ` / `ऽ`).
   - Consonant Sandhi (വ്യഞ്ജനസന്ധി): Jashthva, Anunasika, Schutva/Shtutva, and Parasavarna (Anusvara to class nasals).
   - Visarga Sandhi (വിസർഗ്ഗസന്ധി): Ruthva, Sathva, Uthva, and Lopa.
   - Dravidian / Malayalam Sandhi: Agama (യാഗമം, വാഗമം), Dvitva (consonant doubling), Lopa (elision), and Adesha.
   - Query expansion: When user searches for multi-word or split queries, automatically generates Sandhi compound candidates and match patterns.
   - Compound splitting & root awareness: Substring match inside conjoined grapheme clusters without slicing dependent vowels.
2. **Indic Phonetic Sound-Alike Engine (`lib/core/search/indic_phonetic_engine.dart`)**:
   - Class nasal and Anusvara equivalence (e.g., `ങ്ക` / `ംക`, `ഞ്ച` / `ംച`, `ണ്ട` / `ംട`, `ന്ത` / `ംത`, `മ്പ` / `ംപ` in Malayalam; `ङ्`, `ञ्`, `ण्`, `न्`, `म्` vs `ं` in Devanagari).
   - Chillu and Virama / Halant phonetic equivalence (`ൺ` / `ണ്`, `ൻ` / `ന്`, `ർ` / `ര്`, `ൽ` / `ല്`, `ൾ` / `ള്`, `ൿ` / `ക്`).
   - NTA ligature equivalence (`ന്റ` vs `ൻറ` vs `ൻറ്റ`).
   - Samvruthokaram / Chandrakkala tolerance at word endings (`്` vs `ു` vs `ു്`).
   - Repha gemination equivalence in Sanskrit texts (`ര്മ്മ` / `ർമ`, `धर्म्म` / `धर्म`).
   - Sibilant and phonetic sound-alike mapping for Malayalam and Sanskrit.
3. **Search Normalizer & Search Engine Integration (`lib/core/search/search_normalizer.dart`, `lib/features/reading/data/pdf_search_engine.dart`)**:
   - Update `SearchOptions` with `sandhi` (default: true) and `phonetic` (default: true) switches alongside `strict` and `ignoreAccents`.
   - Update `SearchNormalizer` and `PdfSearchEngine` to generate Sandhi and phonetic search keys/patterns while preserving exact character coordinate mapping (`sourceStart`, `sourceEnd`) and pdfium highlight rectangles.
4. **UI & Localization (`lib/features/reading/presentation/widgets/reader_search_bar.dart`, `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`)**:
   - Add Sandhi search and Phonetic search toggles in the search options menu.
   - Add English and Malayalam localized strings.
5. **Roadmap & Documentation Update (`docs/feature_analysis_and_roadmap.md`, `docs/features.md`)**:
   - Update status of Feature 2.1 to Implemented.
6. **Testing**:
   - Comprehensive unit tests covering all Sandhi transformations, phonetic equivalence, offset back-mapping, search bar options, and engine streaming.

## Files to Change
- `lib/core/search/sandhi_engine.dart` (new)
- `lib/core/search/indic_phonetic_engine.dart` (new)
- `lib/core/search/search_normalizer.dart` (modify)
- `lib/features/reading/data/pdf_search_engine.dart` (modify)
- `lib/features/reading/presentation/widgets/reader_search_bar.dart` (modify)
- `lib/l10n/app_en.arb` (modify)
- `lib/l10n/app_ml.arb` (modify)
- `docs/feature_analysis_and_roadmap.md` (modify)
- `docs/features.md` (modify)
- `test/core/search/sandhi_engine_test.dart` (new)
- `test/core/search/indic_phonetic_engine_test.dart` (new)
- `test/core/search/search_normalizer_test.dart` (modify)
- `test/features/reading/data/pdf_search_engine_test.dart` (modify)
- `test/features/reading/presentation/reader_search_bar_test.dart` (modify)
