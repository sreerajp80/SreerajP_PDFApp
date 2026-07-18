# Plan - Dynamic Signature Verification Overlay

**Status:** completed

## Problem Description
When a PDF document containing a signature is opened, the page renders the signature field using the static "/AP" (Appearance Stream) embedded inside the PDF file at the time of signing. Since the signature was created externally or before it was trusted by our app, the rendered PDF page displays a question mark `?` and the text "Signature Not Verified". 

Even after the user trusts the certificate in our app (which updates the signatures screen to show "Signed, trusted" in Malayalam/English), the PDF page itself continues to display the static "Signature Not Verified" graphic.

## Proposed Changes

We will solve this by:
1. **Extracting Signature Field Bounds (Kotlin):** Modify `SignatureHandler.kt` to scan the pages of the PDF for widget annotations that match the signature dictionary, returning their page index, coordinates (x, y, width, height), and the page size.
2. **Bridging to Dart:** Update the `PdfSignature` domain model to parse and store the coordinates under a new `SignaturePosition` class.
3. **Watching Verdicts in Viewer:** Watch `signatureVerdictsProvider` inside `ViewerScreen` so the app is reactively updated as soon as a certificate trust status changes.
4. **Drawing a Dynamic Overlay (Flutter):** Add a `pagePaintCallback` inside `PdfViewerParams` that draws a premium, solid white background to cover up the static "Signature Not Verified" and "?" graphics, and draws a large, high-fidelity green checkmark (with black borders) in the background with the raw validated details printed directly on top. To comply with PDF document formatting standards, all text (including timezone) is rendered in standard English layout and supports full text wrapping without truncation.
5. **Reactive Trust Updates:** Make `SignatureVerdictsNotifier` watch `trustedCertificatesProvider` so the signature verdicts automatically re-evaluate and repaint on the screen as soon as a certificate is trusted or untrusted in the app.

---

## Detailed File Changes

### 1. Kotlin Signature Handler

#### [MODIFY] [SignatureHandler.kt](file:///l:/Android/SreerajP_PDFApp/android/app/src/main/kotlin/in/sreerajp/pdfapp/SignatureHandler.kt)
- Create a private helper class/struct `SignatureLoc` to represent a signature's coordinates on a page.
- Implement `findSignatureLocations(doc: PDDocument)` to scan all pages and find annotation widgets linked to signature dictionaries.
- Update `verifySignatures` to scan for locations and merge them into the signature map under key `"position"`.

### 2. Dart Bridge & Domain Models

#### [MODIFY] [pdf_signature.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/signature/domain/pdf_signature.dart)
- Define the `SignaturePosition` domain class.
- Update `PdfSignature` to have an optional `final SignaturePosition? position` field.
- Parse it in `PdfSignature.fromMap`.

### 3. Flutter Viewer Screen

#### [MODIFY] [viewer_screen.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/viewer/presentation/viewer_screen.dart)
- Declare `List<SignatureVerdict>? _currentVerdicts` inside `_ViewerScreenState`.
- Inside `_buildBody`, read the verdicts reactively to cache them for painting.
- Pass `_paintSignatureOverlays` to `PdfViewerParams.pagePaintCallbacks`.
- Implement `_paintSignatureOverlays` and `_drawSignatureOverlay`.

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` to verify code correctness.
- Run `flutter test` to ensure existing tests pass.

### Manual Verification
1. Launch the app on a device or emulator.
2. Open the signed PDF document showing "Signature Not Verified".
3. Verify that the signature block is covered by a greyish/neutral overlay stating the signature is valid but untrusted (in Malayalam/English depending on locale).
4. Go to the Signatures screen and trust the certificate.
5. Return to the viewer and verify that the overlay updates instantly to a green "Signed and trusted" card.
6. Verify that pinch-to-zoom scales the overlay perfectly.
