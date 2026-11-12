# Change log — Guidelines Phase 3: Features screen in every language

Implements Phase 3 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(finding F2, and the Features-screen part of F10).

## What changed

- `lib/features/settings/presentation/features_screen.dart` — the 36 feature cards no longer
  hold English literals. Every title, description and highlight chip comes from
  `AppLocalizations` (engineering standard §8.2, §8.7). The list is now a `ListView.builder`
  (one item for the header card, one per category) instead of an eager `ListView` (§10.3).
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — 182 new keys:
  `helpFeature<Name>Title`, `helpFeature<Name>Body`, `helpFeature<Name>Tag<n>`, each with an
  `@key` description in `app_en.arb`. Generated localizations regenerated.
- Key prefix choice: these keys use `help…` (descriptive help content, exempt from the
  short-label budget, §8.6). The Features screen is a guide to what the app does; several English
  card titles and chips are longer than 20 characters, and shortening them would change the
  content.
- Malayalam follows the language pack (§4.2): `താൾ` for page, `അച്ചടി` for print,
  `സൂക്ഷിക്കുക` for save, `കയറ്റുമതി` / `ഇറക്കുമതി` for export / import.
- Sanskrit follows the pack (§4.1) and passes the Hindi-marker gate. Product names (pdfium,
  Bouncy Castle, Android, Anek Malayalam, Noto Sans Malayalam) and units (DPI, AES-256, SHA-256,
  JSON, PEM, X.509) stay in Latin letters.

## Tests

- `test/features/settings/presentation/features_screen_test.dart` — new test per language
  (en, ml, sa): the screen renders with no exception, shows that language's text, shows no
  English feature text under ml or sa, and the last (lazily built) category can be scrolled to.
- `test/features/printer/presentation/import_screen_test.dart` — test-only fix for a flaky
  helper: it waited a fixed 50 ms of real time for real file writes, which sometimes was not
  enough when the whole suite ran in parallel. It now waits until the progress indicator is gone
  (up to 2 s).
- `dart format`: clean. `flutter analyze`: no issues. `flutter test`: 436 passed.

## Needs native-reader review

All 182 new Malayalam and Sanskrit strings are AI drafts and need a fluent reader before
release. Terms I am least sure of:

- Sanskrit: `बाइट्` (byte, transliterated — no settled Sanskrit word), `आभासीकुञ्जीफलकम्`
  (virtual keypad), `सङ्कोच्य-` (foldable), `पुटरेखाः` (fold lines), `मध्यसीवनम्`
  (saddle-stitch), `आकर्षणपातनम्` (drag and drop), `सेपिया` (sepia), `मङ्ग्लिश्` (Manglish).
- Malayalam: `ഒതുക്കൽ രീതികൾ` (fit modes), `അക്ഷരക്കൂട്ട ക്രമീകരണം` (grapheme alignment),
  `സിസ്റ്റം അച്ചടി നിര` (print spooler), `നടുത്തുന്നൽ` (saddle-stitch), `ഓൺസ്ക്രീൻ കീപാഡ്`.
