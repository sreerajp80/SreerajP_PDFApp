# Change Log - Dynamic Signature Verification Overlay

**Date:** 2026-07-18
**Implements plan:** [plans/20260718_174600_signature_overlay_verification.md](file:///l:/Android/SreerajP_PDFApp/plans/20260718_174600_signature_overlay_verification.md)

## Summary of Changes

### Native Kotlin Android
- Modified [SignatureHandler.kt](file:///l:/Android/SreerajP_PDFApp/android/app/src/main/kotlin/in/sreerajp/pdfapp/SignatureHandler.kt):
  - Created a private `SignatureLoc` helper class to hold signature page index and coordinates (x, y, width, height).
  - Implemented `findSignatureLocations` helper to iterate through pages and match widget annotations `/Widget` to their corresponding signature dictionaries.
  - Updated `verifySignatures` to find and append signature locations under `"position"` key in the returned map.

### Signature Domain Bridge
- Modified [pdf_signature.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/signature/domain/pdf_signature.dart):
  - Added `SignaturePosition` class representing signature location details.
  - Added optional `SignaturePosition? position` to `PdfSignature`.
  - Parsed the coordinates in `PdfSignature.fromMap`.

### Signature Presentation Providers
- Modified [providers.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/signature/presentation/providers.dart):
  - Updated `SignatureVerdictsNotifier.build` to watch `trustedCertificatesProvider`. This ensures all signature verdicts are automatically re-calculated and the viewer screen is repainted as soon as any certificate is trusted or untrusted in the app.

### PDF Viewer UI
- Modified [viewer_screen.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/viewer/presentation/viewer_screen.dart):
  - Added imports for `pdf_signature.dart` and `signature_status.dart`.
  - Declared class field `_currentVerdicts` to cache signature verdicts list inside state.
  - Watched `signatureVerdictsProvider` reactively in `_buildBody` and assigned results to `_currentVerdicts`.
  - Added `_paintSignatureOverlays` callback to `PdfViewerParams.pagePaintCallbacks`.
  - Implemented `_paintSignatureOverlays` and `_drawSignatureOverlay` to draw a solid white background covering up the static pre-signed text, render a large, high-fidelity checkmark/cross in the background (with black outline for visibility), and print the raw validated details directly on top (matching Adobe Acrobat style). The text is always drawn in English with standard date formatting (including timezone like IST/PDT) and supports natural word-wrapping to show the full signature information clearly without truncation.

## Verification
- Ran `flutter test` and all 303 tests passed successfully.
- Ran `flutter analyze` and it passed with no warnings or static analysis issues.
