# Fix: the first search match does not scroll into view

**Status:** completed

**Date:** 2026-11-12
**Found in:** [change_log/20261112_144911_fix_storage_permission_search_rotation_names.md](../change_log/20261112_144911_fix_storage_permission_search_rotation_names.md)

## The issue

Open `Reading_Guide.pdf` (3 pages) on page 1 and search "eyes". The counter shows "1 of 3" within a
second, but the view stays on page 1. All three matches are on page 3. Tapping Next does move the
view. A single match lower on page 1 (കർമ്മണി ഏവ, "1 of 1") did scroll into view, so the jump
works in some cases.

## What is known

- `ViewerScreen._onSearchChanged` calls `_goToHit(current)` the first time the current match
  changes. `_goToHit` works out the match's area, skips the move if it is already visible, and
  otherwise calls `_controller.goTo(...)` (`viewer_screen.dart` around line 443).
- `_controller.invalidate()` (called on every new result) only repaints; it does not stop pdfrx's
  scroll animation, so that is not the cause.
- Not yet known: whether `_goToHit` runs for the page-3 match, what area and visible rectangle it
  sees, and whether the move is skipped or undone.

## Plan for the fix

1. Add **temporary** log lines in `_goToHit` (page, match area, visible area, decision). Build the
   dev app, repeat the search on the emulator, read the log. No document text is logged.
2. Fix the cause found. Likely candidates: the jump is skipped because the area/visible check is
   wrong for a page further down; or the move is undone by a later layout change. The fix stays
   in `_onSearchChanged` / `_goToHit`.
3. Remove the temporary log lines.
4. Add a test if the cause can be pinned without native pdfium (for example, if the decision is
   moved into a small pure function); otherwise check by hand on the emulator.
5. `dart format`, `flutter analyze`, `flutter test`; dev build on the emulator: "eyes" scrolls to
   page 3; the page-1 Malayalam case still works; Next/Previous still work.
6. Stop Gradle daemons. Change log; `CHANGELOG.md` line.

## Files to change

| File | Change |
|---|---|
| `lib/features/viewer/presentation/viewer_screen.dart` | Fix in `_onSearchChanged` / `_goToHit` (temporary logs added and removed) |
| `test/...` | New test only if the logic can be tested without native code |
| `CHANGELOG.md` | One "Fixed" line |
| `change_log/<timestamp>_search_first_match_scroll.md` | Change log |

## Security impact

None. The temporary logs record page numbers and rectangles only, never document text, and are
removed before finishing.
