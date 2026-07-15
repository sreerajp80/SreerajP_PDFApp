# Change Log — Fix Search Bar Clutter and Zoom Reset

This change log documents the reorganization of the search bar UI layout and the preservation of the document zoom level when starting a search.

It implements the plan described in [plans/20260715_153000_fix-search-bar-clutter-and-zoom.md](file:///l:/Android/SreerajP_PDFApp/plans/20260715_153000_fix-search-bar-clutter-and-zoom.md).

Written in plain, simple English per the project rules.

---

## 1. What was changed

### Component: Features / Reading / Presentation
- **Modified:** [reader_search_bar.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/reading/presentation/widgets/reader_search_bar.dart)
  - Changed the single `Row` layout into a two-row `Column`.
  - Row 1 now only contains the close button, search query text field (given full width), and clear button.
  - Row 2 now contains the search status text, options menu button, and previous/next match navigation arrows.
  - Added a thin `Divider` to separate the two rows visually.

- **Modified:** [viewer_screen.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/viewer/presentation/viewer_screen.dart)
  - Added `toolbarHeight: 104.0` to the search `AppBar` so that it has enough vertical height to fit the new two-row layout.
  - Added `resizeToAvoidBottomInset: false` to the primary `Scaffold` widget. This prevents the software keyboard from resizing the PDF viewer viewport, preserving the zoom level when the search box is focused.

---

## 2. Verification

- **Automated Tests:** Ran `flutter test`. All 159 tests compiled and passed successfully.
- **Manual Verification:** Open any PDF, zoom in, and tap the search icon. The zoom level is preserved, the keyboard overlay does not resize the viewer, and the search text field takes up the entire width of the top row, making it spacious and easy to read.
