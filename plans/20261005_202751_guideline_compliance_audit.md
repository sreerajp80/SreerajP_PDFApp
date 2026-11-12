# Plan — Bring the code in line with the shared guidelines

**Status:** completed

## What the issue is

The user asked that the project's code follow the guidelines strictly. I read the project rules
(`CLAUDE.md`, `docs/PROJECT_PROFILE.md`) and the shared guidelines in `docs/guidelines/`
(engineering standard, `guideline.md`, the Sanskrit/Malayalam language pack). Then I checked the
code against them.

Starting point (before any change):

- `flutter analyze`: no issues.
- `flutter test`: 417 tests, all pass.
- Already compliant: Tier 2 layout, thin `main.dart`, global error handlers, typed exceptions,
  WAL + foreign keys in `onConfigure`, versioned migrations, About config, the `sa` fallback
  delegates, the language picker, parity + label-length tests, no `INTERNET` permission, package
  imports only, lint set from §16.1.

The gaps found are listed below. Each has the rule it breaks. They are grouped into phases. Each
phase is small enough to build, test and log on its own (the guidelines ask for small, separately
approved steps — `AI_AGENT_START_HERE.md` §4).

## Findings

### MUST-level gaps

| # | Gap | Rule | Where |
|---|---|---|---|
| F1 | 72 files import `package:flutter/material.dart` / `cupertino.dart`; `material_ui` is not a direct dependency | Eng. std §6.1, `guideline.md` §4 | `lib/**`, `test/**`, `pubspec.yaml` |
| F2 | The Features screen has about 33 feature titles, descriptions and highlight chips as raw English literals — not in ARB, not translated | §8.2, §8.7 | `lib/features/settings/presentation/features_screen.dart` |
| F3 | Error text shown to users includes the raw exception (`'${l10n.opFailed}: $e'`) — this can show class names and internal detail | §11.2 | 11 places in `page_ops`, `printer`, `extraction` widgets |
| F4 | `SafeErrorFallback` shows a hard-coded English sentence and uses raw `Color(0x…)` literals inside `build` | §8.2, §6.1 | `lib/core/errors/safe_error_fallback.dart` |
| F5 | `debugPrint` is used in committed code | §14.3 | `lib/main.dart` |
| F6 | `AppLogger` throws `StateError` if called before `init()`; the guideline says log calls must never throw. Init order is error handlers → logger; the guideline order is logger → handlers | §14.2, §4.5 | `lib/core/logging/app_logger.dart`, `lib/main.dart` |
| F7 | No Devanagari font bundled and no `fontFamilyFallback` chain for Sanskrit | Language pack §2, §8.3.3 | `pubspec.yaml`, `lib/app/theme/app_theme.dart` |
| F8 | Android App Bundle language splitting is not turned off (`bundle { language { enableSplit = false } }`) | §8.1, `guideline.md` §4 | `android/app/build.gradle.kts` |
| F9 | Gradle uses `kotlinOptions { jvmTarget }`; the guideline requires `kotlin { compilerOptions { } }` | §5.3, `guideline.md` §4 | `android/app/build.gradle.kts` |
| F10 | Two lists that can grow past 20 items use eager `ListView(children: …)`: the PDF outline (unbounded) and the Features screen (~30 children) | §10.3 | `outline_drawer.dart`, `features_screen.dart` |
| F11 | Watermark color swatches are 24×24 dp tap targets with no tooltip, no semantics label, and color is the only cue. The accent color wheel (custom painter) has no semantics | §7.1, §7.2, §7.3, §7.8 | `watermark_dialog.dart`, `accent_color_screen.dart` |
| F12 | No "Delete all data" action (database, cache, logs, settings) | §15.4 | Settings → Storage |
| F13 | Lifecycle service only logs. Required: close the database on `detached`; clean leftover temp files on `resumed` | §9.2, §9.3 | `lib/core/lifecycle/app_lifecycle_service.dart` |
| F14 | 616 of 694 ARB keys do not use the category prefixes (`action…`, `label…`, `title…`, `tooltip…`, `desc…`, `error…`, …). So the label-length test cannot see most short labels | §8.6 | `lib/l10n/*.arb`, every widget using them |

### SHOULD-level gaps

| # | Gap | Rule | Where |
|---|---|---|---|
| S1 | Numbers shown to users use `toStringAsFixed` (TTS rate/pitch/pause, file sizes) instead of `intl` `NumberFormat` via `DisplayFormat`; two copies of a bytes formatter exist besides `DisplayFormat.bytes` | §8.9 | `cache_service.dart`, `import_screen.dart`, `tts_settings_screen.dart` |
| S2 | 43 places use `EdgeInsets.fromLTRB` / `Alignment.topLeft` etc. instead of the direction-aware versions | §8.8 | settings, help, sheets |
| S3 | No CI workflow (format, analyze, test, and a hardened Android release build) | §19.1, §19.2 | `.github/workflows/` (missing) |
| S4 | Android adaptive icon has no monochrome layer; the dev flavor uses the same icon as prod | §17.5 | `android/app/src/main/res/`, `android/app/src/dev/` |
| S5 | The heart color in `MadeWithLove` is a private constant, not a named design token | `guideline.md` §1.7, §6.1 | `made_with_love.dart`, `lib/app/theme/tokens.dart` |
| S6 | No shared "every icon button has a tooltip" widget test helper (§7.8 verification) | §7.8 | `test/helpers/` |

Out of scope here (process items, not code): privacy policy URL / `PRIVACY.md` (needed before the
first Play release — profile already says so), native-reader review, screen-reader passes,
size budget, release checklist.

## The plan for the fix (phases)

Each phase ends with `dart format .`, `flutter analyze` (0 issues), `flutter test` (all pass) and
its own change log in `change_log/`.

### Phase 1 — Small safe fixes (F4, F5, F6, F8, F9, F13, S5)

- `app_logger.dart`: start with a console-only logger so a call before `init()` never throws.
- `main.dart`: order = binding → `AppLogger.init()` → error handlers → rest. Remove `_safeLog` /
  `debugPrint`.
- `safe_error_fallback.dart`: read text with `AppLocalizations.maybeOf(context)`, falling back to
  `lookupAppLocalizations(const Locale('en'))`. New ARB key `errorScreenFallback` in en/ml/sa.
  Move its colors to `tokens.dart`.
- `tokens.dart`: add `AppTokens.heartRed` (`#E53935`); `made_with_love.dart` uses it.
- `build.gradle.kts`: add `bundle { language { enableSplit = false } }`; replace
  `kotlinOptions` with `kotlin { compilerOptions { jvmTarget.set(JvmTarget.JVM_17) } }`.
- `app_lifecycle_service.dart`: take the `AppDatabase` and `CacheService`; close the DB on
  `detached`; clear the temp cache on startup and on `resumed`. (Only files the app made in its
  private cache — never user files.)
- Tests: logger before init, fallback widget in en/ml/sa, lifecycle calls.
- Check: `flutter build apk --flavor dev --debug` still builds.

### Phase 2 — User-safe error messages (F3)

- Replace `'${l10n.opFailed}: $e'` style text with only the localized message. Map known
  `AppException` types to friendly ARB messages; log the detail with `AppLogger.error`.
- Add a retry action to operation-failed SnackBars where the operation can be re-run (§11.4).

### Phase 3 — Features screen localization + list builder (F2, F10 part)

- Move every title, description and highlight on the Features screen into ARB keys
  (`featureXxxTitle`, `descFeatureXxx`, `labelFeatureXxxHighlightN`) with real Malayalam and
  Sanskrit translations, using the language pack glossary.
- Build the screen with `ListView.builder`.
- Uncertain translations are listed in the change log as "needs native-reader review".
- Widget test: screen in en/ml/sa, no English leaking in ml/sa, no overflow.

### Phase 4 — Lists, accessibility, formatting, RTL (F10 part, F11, S1, S2, S6)

- Outline drawer → `ListView.builder` over the outline nodes.
- Watermark swatches: 48×48 hit area, `Tooltip` + `Semantics` with the color name, selected
  state shown by a check icon (not color alone). New ARB color-name keys in en/ml/sa.
- Accent wheel: `Semantics` label + hint.
- `DisplayFormat`: add a locale-aware `decimal(...)` using `NumberFormat` and
  `formattingLocale(...)`; remove the duplicate bytes formatters and use `DisplayFormat.bytes`.
- Swap `EdgeInsets.fromLTRB` → `EdgeInsetsDirectional.fromSTEB`, `Alignment.topLeft` →
  `AlignmentDirectional.topStart`, etc.
- Add `test/helpers/tooltip_checks.dart` (`expectAllIconButtonsHaveTooltips`) and use it in the
  existing screen tests.

### Phase 5 — Delete all data (F12)

- Settings → Storage: "Delete all data" with a destructive confirm dialog (§6.4). Removes the
  database rows, app caches, saved preferences and the user-added trust certificates; releases
  persisted URI permissions. Never touches the user's own PDF files.
- New ARB keys in en/ml/sa; update `docs/security.md` §13 retention text.
- Tests for the service and the confirm flow.

### Phase 6 — Devanagari script coverage (F7) — needs your choice (Question A)

- Option A1 (recommended): bundle Noto Sans Devanagari Regular + Bold (OFL) under
  `assets/fonts/` with its license file, and add it to the theme's `fontFamilyFallback`. This
  needs a one-time download of the font files from the official Noto repository — I will ask
  before downloading.
- Option A2: no download; add a `fontFamilyFallback` chain that relies on the Android system
  Devanagari font, and record "verify on a clean device" in `docs/release_process.md`.

### Phase 7 — Move to `material_ui` / `cupertino_ui` (F1)

- Add `material_ui: ^1.5.0` (and `cupertino_ui` with a caret, since the `sa` delegate uses
  Cupertino localizations) to `pubspec.yaml`.
- Run `dart fix --apply --code=migrate_design_widgets`, fix anything it misses by hand, use
  `...GlobalMaterialLocalizations.delegates` as §8.1 shows.
- Update the "open migration item" note in `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md`
  (kept in sync).
- Full analyze + test + `flutter build apk --flavor dev --debug`.

### Phase 8 — ARB key prefixes (F14) — needs your choice (Question B)

- Option B1 (recommended): rename all 616 keys to the prefix scheme in all three ARB files and
  every call site, keep each `@key` description, regenerate, and tighten the label-length test.
  This is a large mechanical change (many files). Done by a script, checked by the analyzer.
- Option B2: keep the names; instead add an explicit list of short-label keys to the
  label-length test so the budget is still enforced. Smaller, but does not meet the naming rule.

### Phase 9 — CI and icons (S3, S4)

- `.github/workflows/ci.yml`: pub get, `dart format --set-exit-if-changed`, analyze, test, and a
  `flutter build appbundle --flavor prod --release --obfuscate --split-debug-info=…` job (unsigned
  check build; no secrets in the repo).
- Monochrome launcher layer from the existing source art; a dev-flavor icon with a "DEV" badge
  under `android/app/src/dev/res/`.

## Files to be changed

- `pubspec.yaml`, `pubspec.lock`
- `android/app/build.gradle.kts`, `android/app/src/main/res/mipmap-anydpi-v26/*`,
  new `android/app/src/dev/res/*`
- `lib/main.dart`, `lib/app/app.dart`, `lib/app/theme/tokens.dart`, `lib/app/theme/app_theme.dart`
- `lib/core/logging/app_logger.dart`, `lib/core/lifecycle/app_lifecycle_service.dart`,
  `lib/core/errors/safe_error_fallback.dart`, `lib/core/widgets/made_with_love.dart`,
  `lib/core/format/display_format.dart`, `lib/core/storage/cache_service.dart`
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` and the generated `app_localizations*.dart`,
  `lib/l10n/sa_material_localizations.dart`
- `lib/features/settings/presentation/features_screen.dart`, `storage_settings_screen.dart`,
  `tts_settings_screen.dart`, `accent_color_screen.dart` and other settings screens (RTL padding)
- `lib/features/viewer/presentation/widgets/outline_drawer.dart`
- `lib/features/page_ops/presentation/**` (error text, watermark swatches)
- `lib/features/printer/presentation/**`, `lib/features/extraction/presentation/**` (error text)
- `lib/features/help/presentation/*.dart` (RTL padding)
- Phase 7: every Dart file under `lib/` and `test/` that imports Material/Cupertino
- Phase 8: every Dart file that reads `AppLocalizations`
- New: `test/helpers/tooltip_checks.dart`, new/updated tests under `test/` (mirroring `lib/`),
  `.github/workflows/ci.yml`, `assets/fonts/NotoSansDevanagari-*.ttf` + license (Option A1 only)
- Docs: `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md`, `docs/architecture.md` (init order,
  lifecycle), `docs/security.md` §13, `docs/dependencies.md`, `README.md` (CI)
- One change log per phase in `change_log/`

## Risks

- Phase 7 and Phase 8 touch many files. They run last, alone, each with a full analyze + test.
- New Malayalam and Sanskrit text is a draft by an AI. It will be flagged for native-reader
  review in the change logs.
- I cannot run a real device here. Device-only checks (fonts on a clean device, TalkBack) are
  listed in the change logs as "to verify on device".

## Decisions (from the user)

- All 9 phases approved.
- Question A: Option A1 — bundle Noto Sans Devanagari (ask again before the download).
- Question B: Option B1 — rename all ARB keys to the prefix scheme.

## Addition (found during Phase 3) — approved by the user

### Phase 10 — Language-pack terminology in existing translations (pack §4.1, §4.2)

- **Malayalam:** about 99 existing strings in `lib/l10n/app_ml.arb` use loanwords the pack bans:
  `പേജ്` (40, should be `താൾ`), `പ്രിന്റ്` (32, should be `അച്ചടി…`), `സേവ്` (17, should be
  `സൂക്ഷിക്കുക`), `എക്സ്പോർട്ട്` (5, should be `കയറ്റുമതി`), `നമ്പർ` (3, should be `സംഖ്യ`),
  and single uses of `സെറ്റിംഗ്` and `കോപ്പി`. Fix each to the pack term, keeping the
  short-label budget.
- **Sanskrit:** the pack's Hindi-marker gate finds 5 existing strings where a real Sanskrit word
  contains a banned letter sequence (`शक्याः` has `क्या`, `सङ्ग्रहे` has `रहे`,
  `-ग्रहानु-` has `रहा`, `वाक्यावसान-` has `क्या`). Reword them slightly so the gate passes:
  `reopenFailedHelp`, `helpTtsStep3`, `helpSignaturesStep3`, `permNoBroadStorageTitle`,
  `ttsSentencePauseTitle`.
- Files: `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb`, generated localizations, and any test
  that looks for the old Malayalam text.
- The gate itself is added to CI in Phase 9.

### Phase 11 — Turn off Android cloud backup (approved by the user during Phase 5)

- `android:allowBackup` is not set, so it defaults to `true` and Android may back up the app's
  database (recent files, annotations, trusted certificates) to the cloud. `docs/security.md` §17
  lists this as required before the first Google Play release (engineering standard §15.2).
- Fix: set `android:allowBackup="false"` on `<application>` in
  `android/app/src/main/AndroidManifest.xml`; update `docs/security.md` §10, §13, §17.

## Outcome

All 11 phases are implemented. One change log per phase in `change_log/`
(`20261005_204051` … `20261006_080100`, names ending `guidelines_phase<N>_…`).
Final state: `dart format` clean, `flutter analyze` 0 issues, `flutter test` 449 passed,
`flutter build apk --flavor dev --debug` builds, Sanskrit Hindi-marker gate clean.
