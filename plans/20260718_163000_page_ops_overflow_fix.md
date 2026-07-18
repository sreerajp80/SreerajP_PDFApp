# Fix Page Tools Bottom Sheet Layout Overflow

**Status:** `completed`

## 1. Issue Description
In `lib/features/page_ops/presentation/page_ops_sheet.dart`, the `_PageOpsSheet` widget lists six options using a `Column` widget. On smaller screens, or devices with increased font sizes/display scaling, this widget layout exceeds the vertical bounds of the bottom sheet, resulting in a layout overflow of 54 pixels.

## 2. Proposed Changes
To fix the overflow and support different screen heights and font sizes, we will wrap the layout in a `SingleChildScrollView`. This allows the options list to scroll if the height of the sheet exceeds the available space.

We will modify the following file:
- `lib/features/page_ops/presentation/page_ops_sheet.dart` [MODIFY]

Specifically:
- In `_PageOpsSheet.build`, wrap the `Column` widget inside a `SingleChildScrollView`.
- Add `isScrollControlled: true` to the `showModalBottomSheet` call to ensure the sheet can expand properly if needed.

Additionally, to defensively prevent similar overflow issues in the printing feature's bottom sheet (which also uses a list of options that could overflow on very small devices or landscape orientation):
- `lib/features/printer/presentation/widgets/print_sheet.dart` [MODIFY]
  - Wrap the `Column` widget inside a `SingleChildScrollView`.
  - Add `isScrollControlled: true` to `showModalBottomSheet`.

## 3. Verification Plan
- Build and run the app.
- Open the Page Tools sheet (`പേജ് ഉപകരണങ്ങൾ`) and verify that no layout overflow occurs and that all 6 tools are visible (scrollable if screen space is constrained).
- Open the Print sheet and verify that it renders correctly without layout overflow.
