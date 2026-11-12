# Change log — storage permission, search on unloaded pages, clipped search field, rotated thumbnails, app name in translations

**Plan:** [plans/20261112_141315_fix_storage_permission_search_rotation_names.md](../plans/20261112_141315_fix_storage_permission_search_rotation_names.md)
**Date:** 2026-11-12
**Decision:** wording B for the app name (name + "app" where it is the subject of a sentence)

## What changed

| File | Change |
|---|---|
| `android/app/src/main/AndroidManifest.xml` | Removes `READ_EXTERNAL_STORAGE` with `tools:node="remove"`. The manifest merger implied it from CameraX's `WRITE_EXTERNAL_STORAGE` |
| `lib/core/constants/app_constants.dart` | New `pageTextLoadTimeout` (10 seconds) |
| `lib/features/reading/data/pdf_text_source.dart` | Waits for a page to load (`waitForLoaded`) before reading its text, and uses the loaded page instance. A page that does not load in time is returned empty **and not cached**. The wait can be injected for tests (`PageLoadWaiter`) |
| `lib/features/viewer/presentation/viewer_screen.dart` | While searching, the search bar is no longer an `AppBar` with a fixed 104 height. It sits at the top of the body (status-bar safe area, app-bar colour) and takes the height it needs |
| `lib/features/page_ops/presentation/widgets/organize_pages_screen.dart` | Grid and list thumbnails are wrapped in `RotatedBox(quarterTurns: rotation ~/ 90)` |
| `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` (+ generated files) | 19 strings each: "Folio" → ഗ്രന്ഥം / ग्रन्थः with case endings; "(Folio)" kept where the text points to an Android screen |
| `test/features/reading/data/pdf_text_source_test.dart` | New: unloaded page is waited for; a page that misses the time is not cached; loaded page is cached; out-of-range page |
| `test/features/page_ops/presentation/organize_pages_screen_test.dart` | New: rotating a page turns its thumbnail |
| `docs/security.md` §11 | Rows for `READ_EXTERNAL_STORAGE` (removed) and `ACCESS_NETWORK_STATE` (from `media3`) |
| `CHANGELOG.md` | Four "Fixed" lines under Unreleased |
| `play_store_private/*` (local only) | Blocker marked fixed; screenshot note updated |

## Causes found

1. **Storage permission:** the merger implies `READ_EXTERNAL_STORAGE` when any library asks for
   `WRITE_EXTERNAL_STORAGE`, even after WRITE is removed.
2. **Search missed pages:** the viewer opens PDFs with pdfrx progressive loading. `loadText()` on a
   page that is not loaded yet returns `null` (`pdfrx_engine` 0.6.1). The empty result was cached for
   the life of the screen. Read aloud and the text-quality check use the same source, so they were
   exposed too.
3. **Malayalam drawn wrongly in the search field:** not fonts, not the keyboard. The search bar was
   inside an `AppBar` with `toolbarHeight: 104`. With the Malayalam helper row open, or with taller
   Malayalam text, it did not fit, and its top row was clipped. Malayalam draws vowel signs and the
   chandrakkala above the letters, so the clipped കര്മ്മണി looked like കരമ്മണ।. A test app with the
   same fonts and theme, and test fields inside the real search bar, all drew correctly; the real
   field was the only clipped one.
4. **Rotated thumbnail:** the rotation was stored and shown as a label but not applied to the picture.
5. **App name:** 19 strings per language still had the English name.

## Checks

- `dart format`, `flutter analyze`: no issues.
- `flutter test`: 574 tests passed.
- Merged dev release manifest permissions: `INTERNET`, `CAMERA`, `ACCESS_NETWORK_STATE`, AndroidX's
  private `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`. No storage permission.
- Dev release build (`x86_64`) on the Android 17 emulator:
  - "eyes" in the 3-page sample: 1 of 3, all on page 3 (before: no matches).
  - Malayalam UI: the search hint ഈ പി.ഡി.എഫ്. ഇൽ തിരയുക and the typed കര്മ്മണി draw correctly
    with the helper open; the search finds it.
  - Organise pages: 180° and 90° pages show turned thumbnails.
  - Device sync text reads "മറ്റേ ഫോണിൽ ഗ്രന്ഥം (Folio) › …".
- Not checked on the Motorola: an older dev build signed with another key sits in its Vault Profile;
  replacing it would delete its data there.
- Gradle daemons stopped (`gradlew.bat --stop`); one leftover Kotlin daemon ended.

## Not done / follow-ups

- When a search's first match is on a page that loads later, the view does not move to it by itself
  (the counter shows "1 of 3"; Next works). Small follow-up.
- The plan listed a widget test for issue 5. The fix moved to the viewer screen layout, which has no
  widget test harness yet, so it was checked by hand on the emulator only.

## Needs native-reader review

New Malayalam and Sanskrit wording for the 19 strings in each file, especially:
ഗ്രന്ഥം ആപ്പിലെ നിങ്ങളുടെ ക്രമീകരണങ്ങൾ, ഗ്രന്ഥം (Folio) ആപ്പിന്, ग्रन्थ-अनुप्रयोगः … पृष्ठभूमिं गतः,
ग्रन्थ-अनुप्रयोगाय (Folio), भवतः ग्रन्थ-अनुप्रयोगस्य विन्यासः.
