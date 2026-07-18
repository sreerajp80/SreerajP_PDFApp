# Change log — Fix adbe.pkcs7.sha1 Signature Verification

**Date:** 2026-07-18
**Implements:** `plans/20260718_173200_diagnose_signature_invalid.md` (updated implementation plan)

---

## What was built

We resolved the issue where signatures using the legacy `adbe.pkcs7.sha1` subfilter were incorrectly verified as cryptographically invalid.

1. **Subfilter-aware CMS Parsing**
   - Updated [SignatureHandler.kt](file:///l:/Android/SreerajP_PDFApp/android/app/src/main/kotlin/in/sreerajp/pdfapp/SignatureHandler.kt) to check the signature `SubFilter`.
   - If the subfilter is `adbe.pkcs7.sha1`, the CMS container is parsed without passing the document bytes (since the digest is encapsulated inside the CMS object, unlike detached signatures).

2. **Manual Digest Validation**
   - Added logic to manually calculate the SHA-1 digest of the document bytes (`signedContent`) and compare it with the encapsulated digest stored inside the verified `CMSSignedData` object.
   - Combined the signature verification result with the digest validation result to establish the final integrity status.

---

## Checks

- Ran signature and trust unit tests:
  ```bash
  flutter test test/features/signature/
  ```
  **Result:** All 56 tests passed successfully.
