# Change Log — Phase 3: Extraction & Conversion

**Status:** completed

This log records the changes made to complete Phase 3: Extraction & conversion.

---

## 1. What was changed

### Android Native Layer
- **FileProvider Sharing Resource**: Created `android/app/src/main/res/xml/file_paths.xml` configuring `<cache-path name="app_cache" path="." />`.
- **AndroidManifest.xml**: Declared `androidx.core.content.FileProvider` in the `<application>` element with authority `${applicationId}.fileprovider`.
- **MainActivity.kt**: Added `"shareFiles"` and `"shareText"` methods to the MethodChannel `"in.sreerajp.pdfapp/open"` handler to allow sharing generated files/strings from Cache storage.
- **PdfBoxHandler.kt**: Added background tasks for `"extractText"`, `"extractImages"` (embedded images), `"readFormFields"` (AcroForm), and `"renderPagesToImages"` (DPI & format settings).

### Flutter Core / Platform Layer
- **pdfbox_channel.dart**: Added Dart bindings for `extractText`, `extractImages`, `readFormFields`, and `renderPagesToImages`.
- **open_document_channel.dart**: Added Dart bindings for `shareFiles` and `shareText` call.
- **extraction_service.dart**: Implemented ExtractionService to manage temporary directories and offload large file saves using `compute` isolates.
- **share_service.dart**: Implemented ShareService to delegate sharing to the native OpenDocument MethodChannel.

### Presentation & Localization Layer
- **app_en.arb & app_ml.arb**: Added localization strings for operations, page range pickers, progress screens, preview options, and copy indicators.
- **viewer_screen.dart**: Added the "Extract & Convert" popup menu action to open the `ExtractionDialog`.
- **extraction_dialog.dart**: Implemented the operation configuration dialog.
- **text_preview_dialog.dart**: Implemented text preview dialog with copy/share functionality.
- **form_fields_dialog.dart**: Implemented AcroForm field display table with JSON export feature.

---

## 2. Verification Results

### Unit Tests
- Updated `test/core/platform/pdfbox_channel_test.dart` to cover the new extraction calls.
- Created `test/features/extraction/extraction_service_test.dart` mocking the `plugins.flutter.io/path_provider` and `in.sreerajp.pdfapp/pdfbox` channels.
- All 172 tests passed successfully.

### Static Analysis
- Resolved all static analysis errors, warnings, and lints in the modified files.
- `flutter analyze` completed with no issues found.
