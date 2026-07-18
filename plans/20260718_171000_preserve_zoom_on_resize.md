# Plan: Preserve Zoom Level on Viewport/Layout Resize

**Status:** completed

## Files to be changed:
- `lib/features/viewer/presentation/viewer_screen.dart`

## What the issue is:
When a document is open and the user zooms in, clicking the search icon changes the AppBar height to show the search bar. This triggers a viewport size change in `pdfrx`'s `PdfViewer`. In `pdfrx`, any view size change triggers an automatic call to `_goToPage` which resets the zoom level to fit the page, causing the user's custom zoom to revert.

## Plan for the fix:
We will intercept the automatic zoom reset in `lib/features/viewer/presentation/viewer_screen.dart` by listening to `PdfViewerController` matrix notifications.
1. Add a matrix change listener to the viewer controller inside `initState` (and remove it in `dispose`).
2. Keep track of the last user-zoomed matrix and its corresponding viewport size.
3. When the listener detects that a matrix change has occurred alongside a viewport size change, it cancels the reset animation by immediately calling `goTo` on the controller with `duration: Duration.zero` to restore the last matrix.
4. It then updates its tracked viewport size to the new size, preventing loops and allowing subsequent user panning/zooming.
