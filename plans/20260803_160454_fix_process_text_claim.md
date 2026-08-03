# Fix wrong "Process Text" claim in docs/features.md

**Status:** completed

## What is the issue

While doing a full critical review of `docs/features.md` against the real app code (Dart,
native Kotlin, and the Android manifest), one wrong claim was found:

Section 2.6 ("PDF Printer & Content Importer") says:

> **"Process Text" Selection Target**: The app registers for Android's `ACTION_PROCESS_TEXT`
> intent, so a user can select text inside any other app and, from that app's
> text-selection menu, send the selection straight to this app to be saved as a PDF — a
> separate entry point from sharing a whole PDF or block of text.

This is not true. Checked three places in the code:

1. `android/app/src/main/AndroidManifest.xml` — the only `PROCESS_TEXT` entry is inside a
   `<queries>` block (package-visibility declaration), not an `<intent-filter>` on the
   app's activity. The manifest's own comment says this entry exists so Flutter's own
   `io.flutter.plugin.text.ProcessTextPlugin` can see *other* apps that offer to process
   text — the opposite direction from what the doc claims.
2. `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` (lines 384–386) only
   handles `ACTION_VIEW`, `ACTION_SEND`, and `ACTION_SEND_MULTIPLE`. There is no
   `ACTION_PROCESS_TEXT` handling anywhere.
3. No Dart code references `PROCESS_TEXT` either.

So the app is not actually a registered "Process Text" target. This claim appears to have
been mistakenly added in an earlier doc-fix pass
(`change_log/20260803_155047_fix_features_doc_gaps.md`), which misread the manifest's
package-visibility query as if it registered the app to receive that intent.

The rest of `docs/features.md` was checked folder-by-folder against `lib/features/*`,
`lib/core/`, `pubspec.yaml`, and the DB schema, and found accurate — no other wrong claims
or missing real features turned up. Section 1 (App Overview & Description) already covers
the full feature scope and needs no change.

## Files to change

- `docs/features.md` (only this file)

## The fix

In section 2.6, remove the "Process Text" Selection Target bullet entirely, since the
feature does not exist in the app.

No code changes — this is a documentation-only correction.
