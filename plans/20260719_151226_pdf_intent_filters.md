# Support System-Wide PDF File Opening (Intent Filters)

**Status:** completed

## Files to be changed
* [AndroidManifest.xml](file:///l:/Android/SreerajP_PDFApp/android/app/src/main/AndroidManifest.xml)

## Issue
Currently, the application only registers an intent filter for the `VIEW` action with MIME type `application/pdf` and schemes `content` and `file`. This causes the app to miss PDF files that are shared or opened:
1. With alternative PDF MIME types (like `application/x-pdf` or `application/vnd.pdf`).
2. With generic MIME types (like `*/*` or `application/octet-stream`), even when they have a `.pdf` or `.PDF` file extension.
3. Without a MIME type specified, even when they have a `.pdf` or `.PDF` file extension.

We need to register comprehensive intent filters to cover these cases so that any app on the Android device can offer our app to open PDF files.

## Plan for the fix
1. Modify `android/app/src/main/AndroidManifest.xml` to update the primary `ACTION_VIEW` intent filter to support `application/pdf`, `application/x-pdf`, and `application/vnd.pdf`.
2. Add a fallback intent filter matching `*/*` with `.pdf` and `.PDF` path patterns.
3. Add a fallback intent filter without `mimeType` using `.pdf` and `.PDF` path patterns.
4. Run `flutter analyze` and build the application to verify syntax and configuration correctness.
