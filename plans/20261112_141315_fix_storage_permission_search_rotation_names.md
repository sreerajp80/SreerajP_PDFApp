# Fix: storage permission, search on unloaded pages, rotated thumbnails, app name in translations

**Status:** completed

**Date:** 2026-11-12
**Found in:** [change_log/20261112_125833_play_closed_testing_docs.md](../change_log/20261112_125833_play_closed_testing_docs.md)

---

## 1. The issues

| # | Issue | Cause (checked in code) |
|---|---|---|
| 1 | The release build asks for `READ_EXTERNAL_STORAGE`. Breaks Hard Rule 3; Play would show "read your shared storage". | Not in our manifest. The manifest merger **implies** it because the CameraX plugin asks for `WRITE_EXTERNAL_STORAGE` (we remove WRITE with `tools:node="remove"`, but the implied READ stays). |
| 2 | Search finds nothing on some pages (page 3 of a 3-page sample), even when the word is on screen. Read aloud and the text-quality check can be hit the same way. | The viewer opens documents with pdfrx **progressive loading** (default `useProgressiveLoading = true`). For a page that is not loaded yet, `PdfPage.loadText()` returns `null` (`pdfrx_engine` 0.6.1, `pdfrx_pdfium.dart:1856`). `PdfTextSource.page()` turns that into an empty page **and caches it**, so the page stays empty for the life of the screen. |
| 3 | Organise pages: a rotated page shows "90°", but its thumbnail does not turn. | `organize_pages_screen.dart` draws `PdfPageView` (grid line 401, list line 518) with no rotation applied. |
| 4 | Malayalam and Sanskrit text says "Folio" instead of ഗ്രന്ഥം / ग्रन्थः. | 19 strings in `app_ml.arb` and 19 in `app_sa.arb` keep the English name. |
| 5 | The reader's search field draws Malayalam wrongly: typed കര്മ്മണി shows as കരമ്മണ।, and the hint ഈ പി.ഡി.എഫ്. ഇൽ തിരയുക shows as ഈ പ।.ഡ।.എഫ. … . Seen on the Android 17 emulator **and on a real Motorola (Android 17)**. | Not the keyboard: the hint (no typing) is broken too. Not the fonts list: other text with the same theme is fine. The field alone uses `theme.textTheme.titleMedium` (`reader_search_bar.dart:144`); the note dialog's field (default style) draws Malayalam correctly. The exact property is found with a small test app (see §4). |

## 2. Files to change

| File | Change |
|---|---|
| `android/app/src/main/AndroidManifest.xml` | Add `<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" tools:node="remove"/>` next to the other removed ones, with a short comment |
| `lib/features/reading/data/pdf_text_source.dart` | Before `loadText()`, wait for the page to load: `document.pages[n - 1].waitForLoaded(timeout: …)`, and call `loadText()` on the page instance it returns. If it does not load in time, return an empty page **without caching it**, so a later call tries again |
| `lib/core/constants/app_constants.dart` | New constant for that wait (for example 10 seconds) |
| `lib/features/page_ops/presentation/widgets/organize_pages_screen.dart` | Wrap both `PdfPageView`s in `RotatedBox(quarterTurns: entry.rotation ~/ 90)` |
| `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` | Replace "Folio" with ഗ്രന്ഥം / ग्रन्थः, with the right case endings. Where the text points to a **system** screen (Print services list, camera permission in Android settings), write "ഗ്രന്ഥം (Folio)" / "ग्रन्थः (Folio)", because Android shows the name in the phone's language, which may differ from the app's language |
| `test/features/reading/data/` (new test) | A page source whose first answer is "not loaded" must not stay empty: the next call returns the text. A page that never loads returns empty and is not cached |
| `test/features/page_ops/presentation/` (new or existing widget test) | A rotated entry shows a `RotatedBox` with the right quarter turns |
| `docs/security.md` §11 | Note that `READ_EXTERNAL_STORAGE` is removed (implied by CameraX) |
| `CHANGELOG.md` | User-facing fixes |
| `change_log/<timestamp>_…md` | Change log |

No new dependency. No change to the submodule.

## 3. Plan for the fix

1. Manifest line; rebuild prod release; check the merged manifest has only `INTERNET`, `CAMERA`,
   `ACCESS_NETWORK_STATE` and the AndroidX private permission.
2. `PdfTextSource.page()` waits for the page, uses the loaded page instance, and caches only real
   results. The search engine, read aloud and quality check need no change; they all use this.
3. `RotatedBox` on both thumbnails.
4. ARB edits; `flutter gen-l10n`; parity and label-length tests.
5. `dart format .`, `flutter analyze`, `flutter test`.
6. Install the dev build on the emulator: search the 3-page sample for "eyes" and "original"
   (page 3), rotate a page in Organise pages, open Device sync in Malayalam and Sanskrit, check
   the search field in Malayalam. (The Motorola cannot take the new dev build: an older dev build,
   signed with another key, is installed in its "Vault Profile". Replacing it would delete its
   data there, so that is your call.)
7. Stop Gradle daemons. Write the change log.

## 4. Search field (issue 5)

A throwaway app (scratch folder, not in the repository; same fonts, same `fontFamilyFallback`,
same `material_ui` 1.5.0) drew the same text correctly in **every** case tried:
`titleMedium` and variants (weight 400, letter spacing 0, line height 1.0), a `TextField` inside an
`AppBar` title, the hint, the app language set to Malayalam, and keyboard "composing" ranges that
end inside a letter cluster.

So the cause is something specific to Folio that a small app does not copy. Not found yet.

**Plan for issue 5 (time-boxed, about one hour):** in the dev build on the emulator, try the
likely candidates one at a time and keep the first that fixes it, with a widget test that pins the
style: (a) the field without the explicit `titleMedium` style, like the note dialog's field that
draws correctly; (b) an explicit `fontFamily` / `fontFamilyFallback` on the field style;
(c) remove other parts of the search bar one by one. If none works within the time box, I stop,
record what was tried in the change log, and leave it as a known issue with its own plan.

## 4A. Wording for the app name (your choice)

ഗ്രന്ഥം and ग्रन्थः also mean "book". In a sentence such as "ഗ്രന്ഥം ഒരിക്കലും
ഇന്റർനെറ്റുമായി ബന്ധപ്പെടുന്നില്ല" it can read as "the book never connects…".

| Option | Malayalam | Sanskrit |
|---|---|---|
| A. Name alone | ഗ്രന്ഥം ഒരിക്കലും… | ग्रन्थः कदापि… |
| B. Name + "app" where it is the subject of a sentence | ഗ്രന്ഥം ആപ്പ് ഒരിക്കലും… | ग्रन्थ-अनुप्रयोगः कदापि… |

Either way: in text that points to a **system** screen (Print services, Android camera
permission, "on the other phone open …"), add "(Folio)", because Android shows the name in the
phone's own language. Case endings follow the grammar (ഗ്രന്ഥത്തിന്റെ, ग्रन्थस्य, ग्रन्थाय …).

## 5. Security impact

Manifest: removes a permission (less access). No network, storage, sign-in or dependency change.

## 6. Native-reader review

The new Malayalam and Sanskrit wording with the app name will be listed in the change log for a
fluent reader to check.

## 7. Decision

Approved on 2026-11-12 with wording **B** (name + "app" where it is the subject of a sentence).

## 8. Result

Completed. Issue 5 turned out to be clipping, not fonts: the search bar sat in an `AppBar` with a fixed `toolbarHeight` of 104, and its top row was cut off. Fixed by placing the search bar at the top of the body (`viewer_screen.dart`) instead. See the change log.
