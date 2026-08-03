# Fix wrong "Process Text" claim in docs/features.md

Implements: `plans/20260803_160454_fix_process_text_claim.md`

## What changed

Removed the "Process Text" Selection Target bullet from section 2.6 of
`docs/features.md`. Only `docs/features.md` was edited; no app code changed.

## Why

A full critical review of `docs/features.md` against the real code (Dart, native
Kotlin, and the Android manifest) found this bullet described a feature that does
not exist: the app is not registered to receive Android's `ACTION_PROCESS_TEXT`
intent. The manifest's only `PROCESS_TEXT` entry is a package-visibility query
(so Flutter's own text-selection menu can see other apps), not an intent-filter
that lets other apps send text to this app. `MainActivity.kt` only handles
`ACTION_VIEW`, `ACTION_SEND`, and `ACTION_SEND_MULTIPLE`. The claim was
mistakenly added in an earlier doc-fix pass
(`change_log/20260803_155047_fix_features_doc_gaps.md`).

The rest of the document was checked folder-by-folder against `lib/features/*`,
`lib/core/`, `pubspec.yaml`, and the SQLite schema, and found accurate. No other
missing features or wrong claims were found. The App Overview & Description
(section 1) already covers the full feature scope and needed no change.
