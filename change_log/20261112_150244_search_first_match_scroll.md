# Change log — search scrolls to the first match on a later page

**Plan:** [plans/20261112_145158_search_first_match_scroll.md](../plans/20261112_145158_search_first_match_scroll.md)
**Date:** 2026-11-12

## What changed

| File | Change |
|---|---|
| `lib/features/viewer/presentation/viewer_screen.dart` | `_goToHit` records the current position and view size (`_lastMatrix`, `_lastMatrixViewSize`) right before it moves the view, on both paths (`goTo` and `goToPage`) |
| `CHANGELOG.md` | One "Fixed" line |

## Cause

Found with temporary log lines (page number, view sizes; no document text), removed afterwards.

1. Opening search changes the viewer's height (the search bar is taller than the app bar; on the
   emulator 543 → 502). The view itself does not move, so `_onMatrixChanged` does not run and its
   saved size stays the old one.
2. The first match is on page 3, so `_goToHit` starts a scroll.
3. The scroll's first frame calls `_onMatrixChanged`. It sees a size different from the saved one,
   takes this for a resize (the case it exists for: pdfrx resets the view on rotation, and the
   listener puts the reader's position back), and restores the old position. The jump is cancelled.

A move that the screen starts itself always starts from the current position at the current size,
so recording both first is correct and keeps the rotation behaviour unchanged.

## Checks

- `dart format`, `flutter analyze`: no issues. `flutter test`: 574 passed.
- Dev release build on the Android 17 emulator:
  - "eyes" in `Reading_Guide.pdf` from page 1: jumps to page 3, first match above the keyboard.
  - Next ×2 → 3 of 3; Previous ×3 wraps back to 3 of 3.
  - Malayalam: വായന, first match on page 1 stays in place; Next moves to page 2.
- Temporary log lines removed (no `TEMP-JUMP` left). Gradle daemons stopped.

## Not covered

- No automated test: the logic needs pdfrx's live controller (native pdfium). Checked by hand.
- The reader's own first scroll after opening search can still be taken for a resize once (same
  stale saved size). Not reported and not seen in testing; left as is to keep this change small.
