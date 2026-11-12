# Upgrade all Flutter packages to their latest versions

**Status:** completed

## The issue

Flutter on the build machine was updated to 3.47.6 (Dart 3.13.5). With this Dart version:

- `pdfrx` 1.3.5 (the locked version) no longer compiles. The newer compiler is stricter
  about null checks inside `pdfrx`'s own code. So every test that loads `pdfrx` fails, and
  the app cannot be built.
- `pubspec.lock` is out of date. The new Flutter SDK pins newer `intl`, `matcher`, and
  `meta`, so `flutter pub get` always rewrites the lock file.

The user asked to bring every package up to its latest version.

## Upgrades

| Package | Now | Target | Kind |
|---|---|---|---|
| `pdfrx` | 1.3.5 | 2.6.x | Major — API changes |
| `flutter_riverpod` | 2.6.1 | 3.4.x | Major — API and behavior changes |
| `go_router` | 14.8.1 | 18.0.x | Major — needs Flutter 3.44+ |
| `package_info_plus` | 8.3.1 | 10.2.x | Major — needs newer Android Gradle Plugin |
| `cupertino_icons` | 1.0.9 | 2.0.x | Major — icon font only |
| `intl`, `logger`, `sqflite`, `unorm_dart`, others | — | latest | Minor, no code changes |
| `flutter_lints`, `sqflite_common_ffi` (dev) | — | latest | Check for new lint warnings |

Every package is checked for licence again before upgrading (open-source rule). Any new
indirect package is checked too (for example `pdfrx_engine`, `pdfium_flutter`,
`material_ui`, `cupertino_ui`).

## Files to change

| File / area | Change |
|---|---|
| `pubspec.yaml`, `pubspec.lock` | New version ranges; raise the `environment` SDK lower bound to match. |
| `android/settings.gradle.kts` | Android Gradle Plugin 8.11.1 → 8.12.1 or newer (needed by `package_info_plus` 9+). Gradle 8.14 and Kotlin 2.2.20 already meet the needs. |
| `lib/main.dart` (or app start-up) | Call `pdfrxFlutterInitialize()` if `pdfrx` 2.x requires it. |
| 13 files in `lib/` that use `pdfrx` (viewer, reading, annotation, page_ops) | Update to the `pdfrx` 2.x API: text loading (`loadText` / `PdfPageText` / text ranges), `PdfPage.render()` now may return null, and removed `PdfViewerParams` options. |
| 2 test files that use `pdfrx` (`test/features/reading/data/`) | Same API updates. |
| Riverpod users across `lib/` and `test/` | `FamilyAsyncNotifier` → plain `AsyncNotifier` with the argument in its constructor; `ChangeNotifierProvider` → import from `flutter_riverpod/legacy.dart`; `valueOrNull` → `value` (renamed in 3.x); handle `ProviderException` wrapping where errors are caught; turn **off** automatic retry in `ProviderScope` so a failed file open shows its error instead of quietly retrying. |
| `lib/app/routing/` | Check for anything affected by go_router 15–18 (case-sensitive paths by default, observer changes). Little or nothing is expected to change, since routes are lower-case and named. |
| `docs/dependencies.md` | New versions and licences. |
| `android/` manifest check | Confirm no new package adds `android.permission.INTERNET` to the merged production manifest (offline rule). |

## Steps

1. Update `pubspec.yaml` ranges and run `flutter pub upgrade --major-versions`. Then check
   licences.
2. Raise the Android Gradle Plugin version.
3. Fix compile errors package by package: `pdfrx` first, then Riverpod, then go_router.
4. `dart format .`, `flutter analyze` (0 warnings), `flutter test` (all pass).
5. Build the `dev` APK. Check the merged manifest for `INTERNET`. Install it on the phone and
   smoke-test: open a PDF, scroll, zoom, search, TTS, thumbnails, outline, annotations, page
   tools, settings, about.
6. Write the change log.

## Risks

- `pdfrx` 2.x changed its text API. Search, highlight, and TTS depend on character positions,
  so their tests (Indic search has a 100% coverage rule) must all pass unchanged in meaning.
- Riverpod 3 pauses providers for widgets that are off screen, and compares new values with
  `==`. That can change when some screens update. This will be checked in the smoke test.
- The work is large. If one major upgrade turns out to need a large rewrite, I will stop and
  ask before going on, rather than bundling it in silently.

## Relation to other work

The recent-files reopen fix (`plans/20261005_192800_fix_recent_files_reopen.md`) is paused
at `in_progress`. Its code is written. Its Home screen test can only run once `pdfrx`
compiles again. After this upgrade it is finished, checked, and logged on its own.
