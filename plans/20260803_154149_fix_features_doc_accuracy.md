# Fix accuracy of docs/features.md

**Status:** completed

## Files to be changed

- `docs/features.md`

## What the issue is

I compared `docs/features.md` against the real app code (Dart under `lib/`, and the
Android manifest / native Kotlin). The doc calls itself an "Exhaustive Feature Catalog,"
but it has some gaps and some claims that do not match the code:

**Real features missing from the doc:**
1. A "Book" (two-page, side-by-side) view mode exists in the viewer, on top of Single
   Page and Continuous. The doc only lists two modes.
2. An "Invert Colors" display toggle exists in the viewer menu. Not mentioned anywhere.
3. The app can receive a shared PDF file directly (`ACTION_SEND` for `application/pdf`)
   to open it — separate from the "convert images/text to PDF" import path. Section 2.6
   only covers the import/printer direction, not "someone shares a PDF straight at you."

**Claims in the doc that do not match the code (overstated or wrong):**
4. Text-to-speech: the doc claims speech rate, pitch control, a language picker, and
   background audio support. The code only has play / pause / stop, with language chosen
   automatically (not a manual picker). No rate/pitch controls exist anywhere.
5. Page operations: the doc claims a "Duplicate pages" action. It does not exist in the
   organize-pages screen or the native page-ops handler.
6. Split PDF: the doc claims it can split "into separate single-page PDF files **or
   specific page ranges**." In the code, Split always explodes the file into one PDF per
   page — there is no range-based split. (Range export is a different, already-documented
   feature under Extraction.)
7. Images-to-PDF: the doc claims "customizable margins and page layout." The code always
   uses a fixed one-image-per-page layout with no margin or layout options.
8. Settings screen: the doc claims users can "configure default view mode, default fit
   option, ... clear recent files history." None of these exist. The real Settings screen
   only has: Theme, Malayalam TTS voice toggle, Trust Store, About. Removing a recent file
   is only possible one at a time from the Home screen list, not as a bulk "clear history."
9. Material 3 theme: the doc claims "dynamic color support" (Android's wallpaper-based
   Material You color). The app actually uses one fixed brand seed color
   (`ColorScheme.fromSeed`) — this is Material 3 styling, but not dynamic color.

## Plan for the fix

Edit `docs/features.md` only (no code changes — this is a documentation correction):

1. **Section 2.1 (Viewing & Navigation):** add the Book/two-page view mode to the list of
   viewing modes; add a line for the Invert Colors toggle.
2. **Section 2.2 (TTS):** rewrite the TTS bullet to say play / pause / stop only, with
   automatic language selection driven by the Settings toggle (not a manual picker), and
   remove the rate/pitch/background-audio claims.
3. **Section 2.4 (Page Operations):** remove "duplicate pages" from the Organize Pages
   bullet; correct the Split PDF bullet to say it splits into one file per page only
   (remove the "or specific page ranges" claim, and instead point to the existing
   Export Page Ranges feature in section 2.5 for range-based output).
4. **Section 2.6 (Printer & Content Importer):** correct the Images-to-PDF bullet to
   remove "customizable margins and page layout" (fixed layout only); add a bullet noting
   the app also accepts a shared PDF directly (`ACTION_SEND` for `application/pdf`) to
   open and view it.
5. **Section 2.8 (Themes, Settings & System Integration):** remove the "dynamic color
   support" claim from the Material 3 UI bullet; correct the App Settings bullet to list
   only what really exists (Theme, Malayalam TTS toggle, Trust Store management, About),
   and remove the false "default view mode / default fit option / clear recent files
   history" claims. Optionally note that recent files are removed one at a time from Home.
6. Leave the App Description in section 1 as-is except where it repeats a now-corrected
   claim (it currently does not overstate any of the above, so no change expected there
   beyond a light re-read after the section edits).

No code, tests, or other files change. This is a wording-accuracy pass on one Markdown
file so the doc matches what is actually built.
