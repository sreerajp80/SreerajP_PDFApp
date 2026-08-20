# Indic Phonetic and Sandhi-Aware Search (Malayalam & Sanskrit)

This change implements the plan defined in [plans/20260818_134500_indic_phonetic_sandhi_search.md](plans/20260818_134500_indic_phonetic_sandhi_search.md).

## Summary of Changes

1. **Sandhi Compound Rules & Joining Engine (`lib/core/search/sandhi_engine.dart`)**:
   - Implemented rule-based Sandhi transformation for Malayalam and Sanskrit in both Malayalam and Devanagari scripts.
   - Handles Vowel Sandhi (Savarna Deergha, Guna, Vriddhi, Yan, Ayadi, and Poorvaroopa with Avagraha `ഽ`/`ऽ`).
   - Handles Consonant Sandhi (Jashthva, Anunasika, Schutva, and Parasavarna).
   - Handles Visarga Sandhi (Ruthva, Sathva, Uthva, and Lopa).
   - Handles Malayalam Dravidian Sandhi (Agama, Dvitva, Lopa, and Adesha).
   - Generates compound candidate queries so split terms match joined words in the PDF text layer.

2. **Indic Phonetic & Orthographic Sound-Alike Engine (`lib/core/search/indic_phonetic_engine.dart`)**:
   - Handles Malayalam and Devanagari Anusvara (`ം`/`ं`) vs class nasal conjuncts (e.g. `സംഗീതം` / `സങ്ഗീതം`, `गंगा` / `गङ्गा`, `संत` / `सन्त`).
   - Handles chillu and virama / halant equivalence (`ൺ`/`ണ്`, `ൻ`/`ന്`, `ർ`/`ര്`, `ൽ`/`ല്`, `ൾ`/`ള്`, `ൿ`/`ക്`).
   - Handles Malayalam NTA ligature variants (`ന്റ` vs `ൻറ` vs `ൻറ്റ` vs `ന്റ്റ`).
   - Handles Sanskrit Repha gemination (`धर्म्म` vs `धर्म`, `ര്മ്മ` vs `ർമ`).
   - Handles Avagraha ignorable folding and Samvruthokaram variants.

3. **Search Normalizer & Search Engine Integration (`lib/core/search/search_normalizer.dart`, `lib/features/reading/data/pdf_search_engine.dart`, `lib/features/reading/presentation/pdf_search_controller.dart`)**:
   - Added `sandhi` (default: true) and `phonetic` (default: true) to `SearchOptions`.
   - Updated `SearchNormalizer` with `candidateQueryKeys()` and `NormalizedText.findAllKeys()` for multi-pattern matching with exact offset back-mapping to original source text.
   - Updated `PdfSearchEngine` to stream search hits for candidate keys without missing cluster boundaries or slicing vowels.

4. **UI & Localization (`lib/features/reading/presentation/widgets/reader_search_bar.dart`, `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`)**:
   - Added Sandhi search and Phonetic matching toggles to the search options popup menu in the reader search bar.
   - Localized all search options in English and Malayalam.

5. **Documentation & Roadmap (`docs/feature_analysis_and_roadmap.md`, `docs/features.md`)**:
   - Updated Feature 2.1 status to Implemented.

6. **Automated Testing**:
   - Added `test/core/search/sandhi_engine_test.dart` and `test/core/search/indic_phonetic_engine_test.dart`.
   - Extended `test/core/search/search_normalizer_test.dart`, `test/features/reading/data/pdf_search_engine_test.dart`, and `test/features/reading/presentation/reader_search_bar_test.dart`.
   - Verified 100% test pass rate (341 tests) and clean static analysis (0 warnings).
