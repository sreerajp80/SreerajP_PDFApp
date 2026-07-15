# Plan — Fix Search Bar Clutter and Zoom Reset

**Status:** completed

This plan addresses the clutter in the PDF reader search bar and prevents the document zoom level from resetting when searching.

Written in plain, simple English per the project rules. No project code is written until you approve this plan.

---

## 1. What the issue is

1. **Cluttered Search Bar:** Currently, the search bar has too many elements in one row: back button, search text field, clear button, match status, options button, and previous/next match buttons. Because of this, the search text field gets squeezed down to a very narrow width, hiding the query text and looking very cluttered.
2. **Zoom Level Reset:** When starting a search, the software keyboard appears. This causes the screen size to change and forces the viewer to resize. On resize, the pdfrx viewer recalculates the viewport and resets the zoom scale back to the default fit scale, disrupting the user's reading experience.

---

## 2. Proposed Changes

We will modify two files to implement the fixes:

### Component: Features / Reading / Presentation

#### [MODIFY] [reader_search_bar.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/reading/presentation/widgets/reader_search_bar.dart)
- Change the structure from a single `Row` to a `Column` containing:
  - **Row 1:** Back button, search text field (wrapped in `Expanded`), and clear button. This gives the text field the maximum width possible.
  - **A visual Divider:** A subtle separator line.
  - **Row 2:** Match status text (wrapped in `Expanded` to prevent overflow), search options button, and previous/next match buttons.

#### [MODIFY] [viewer_screen.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/viewer/presentation/viewer_screen.dart)
- In `_buildSearchAppBar()`, set `toolbarHeight: 104.0` on the `AppBar` to give the two-row layout of `ReaderSearchBar` enough vertical room.
- In `ViewerScreen`'s main `Scaffold`, set `resizeToAvoidBottomInset: false`. This stops the keyboard from resizing the PDF viewer viewport, preserving the zoom level and avoiding layout shifts.

---

## 3. Verification Plan

### Automated Tests
- Run `flutter test` to ensure existing tests pass.

### Manual Verification
- Launch the application and open a PDF document.
- Pinch-zoom into the document.
- Tap search icon: check that the search bar now opens in a two-line layout and the document zoom level is preserved.
- Type search query and navigate through results: check that the query is fully visible and the zoom level remains.
