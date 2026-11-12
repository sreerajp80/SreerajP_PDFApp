# Change log: upgrade all Flutter packages

Implements plan: [plans/20261005_193850_upgrade_all_packages.md](../plans/20261005_193850_upgrade_all_packages.md)

## Why

Flutter 3.47.6 (Dart 3.13.5) could not compile `pdfrx` 1.3.5, so the app could not be built
and most tests could not run. The user asked to bring every package to its latest version.

## Package versions

| Package | Before | After |
|---|---|---|
| `pdfrx` | 1.3.5 | 2.6.5 |
| `flutter_riverpod` | 2.6.1 | 3.4.3 |
| `go_router` | 14.8.1 | 18.0.2 |
| `package_info_plus` | 8.3.1 | 10.2.2 |
| `cupertino_icons` | 1.0.9 | 2.0.0 |
| `intl`, `logger`, `sqflite`, `unorm_dart`, `sqflite_common_ffi`, and about 50 indirect packages | — | latest allowed |

New indirect packages: `pdfrx_engine`, `pdfium_flutter`, `pdfium_dart`, `archive`, `image`,
`posix`, `uuid` (MIT); `material_ui`, `cupertino_ui`, `process`, `fixnum`, `listen`,
`ffi_leak_tracker` (BSD). All are open source and meet the licence rule.

## Code and build changes

- `pubspec.yaml` — new version ranges. The project minimum is now Dart 3.13.0 and Flutter
  3.47.0, because `pdfrx` 2.x needs them. The `pdfrx` licence comment was corrected (MIT,
  not BSD).
- `android/settings.gradle.kts` — Android Gradle Plugin 8.11.1 → 8.12.1 (needed by
  `package_info_plus` 9+).
- `lib/main.dart` — calls `pdfrxFlutterInitialize()` at start-up, with a logged failure path.
  Turns off Riverpod 3's automatic retry in `ProviderScope`, so a failure shows its message
  at once instead of retrying quietly.
- `pdfrx` 2.x API changes:
  - `PdfPage.loadText()` → `loadStructuredText()` (in `pdf_text_source.dart` and
    `page_annotation_layer.dart`).
  - `PdfRect.toRectInPageRect` → `toRectInDocument` (`page_annotation_layer.dart`).
  - `PdfViewerParams.enableTextSelection` → `textSelectionParams:
    PdfTextSelectionParams(enabled: ...)` (`viewer_screen.dart`).
- Riverpod 3 changes:
  - `ChangeNotifierProvider` is imported from `flutter_riverpod/legacy.dart`
    (`reading/presentation/providers.dart`).
  - `SignatureVerdictsNotifier` now extends `AsyncNotifier` and takes the document path in
    its constructor (`FamilyAsyncNotifier` was removed).
  - `AsyncValue.valueOrNull` → `value` (`signatures_screen.dart`, `viewer_screen.dart`).
  - Test: `signatures_screen_test.dart` uses `overrideWith2` and the new constructor.
- go_router 18, package_info_plus 10, cupertino_icons 2: no code changes needed.
- `analysis_options.yaml` — the Flutter tool added `build/**` and `android/**` to the
  analyzer's exclude list.
- Docs: `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md`, `README.md`, `docs/features.md`,
  `docs/dependencies.md` — new SDK minimums, versions, and licences.

## Checks

- `flutter analyze`: no issues.
- `flutter test`: all 417 tests pass, including the Indic search tests and the tests that use
  `pdfrx` text.
- `flutter build apk --flavor dev --debug`: builds.
- Merged manifest: `android.permission.INTERNET` comes only from the debug-only manifest
  (`android/app/src/debug/`). No package adds it, so the production build stays offline.
- On the phone: the dev build installs and starts without errors. The hands-on check
  (open, scroll, zoom, search, TTS, annotations, page tools) is **not done yet**, because the
  phone was locked.
