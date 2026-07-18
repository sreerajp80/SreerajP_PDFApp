# Security — SreerajP_PDFApp

This document records the security posture, threat model, and technical controls implemented in the SreerajP PDF App, following the shared security engineering guidelines.

---

## 1. Security Scope

*   **App:** SreerajP PDF App (offline Android PDF reader, editor, and signature verifier)
*   **Data Sensitivity Level:** Moderate (handles PDF file passwords and digital signature trust certificates)
*   **Engineering Standard Profiles in Force:** Core Baseline + Production App Extension + selected Sensitive Data Extension controls (PDF passwords, signature trust store integrity).
*   **Platforms in Scope:** Android (minSdk 26).

---

## 2. Threat Model Summary

### In Scope Threats
*   **Malicious PDF File Execution:** Attackers crafting corrupted or malformed PDF inputs to crash the application or run unauthorized code.
*   **Log Leakage of Passwords:** Accidental exposure of document decryption passwords or certificates in the system console/debugger logs.
*   **Trust Store Tampering:** Unauthorized addition of untrusted digital signature certificates to the local trust store.
*   **Broad Storage Access Exploits:** Unauthorized apps accessing PDF documents in other folders via loose storage permissions.
*   **Binary Reverse Engineering:** Reverse engineering of proprietary logic from the compiled Android application.

### Out of Scope Threats
*   **Fully Compromised (Rooted) OS:** We assume the underlying Android OS sandbox is secure and untampered.
*   **Side-Channel / Physical Memory Attacks:** Extracting decryption keys directly from device memory chips using physical probes.
*   **Network-Based Revocation Spying:** Real-time online certificate revocation checks (CRL/OCSP) are disabled to preserve the offline-first status.

---

## 3. Sensitive Data Inventory

| Data Type | Description | Location | Protection Control |
|---|---|---|---|
| **Document Passwords** | Decryption keys for password-protected PDFs. | In-memory only | Held briefly in volatile memory, never persisted, never logged, and never written to SharedPreferences. |
| **Trust Store Certificates** | Public key certificates added by the user to verify signatures. | sqflite DB (`trust_store` table) | Integrity protected by SQLite schema. |
| **Document Content Fingerprints** | SHA-256 hash + file size of recently opened documents. | sqflite DB | Used as identifier for reading positions and annotations overlay. |

---

## 4. Storage & Access Controls

### Scoped Storage Boundary (SAF)
*   The application does **not** request broad storage permissions (e.g., `READ_EXTERNAL_STORAGE` or `WRITE_EXTERNAL_STORAGE` are absent from the manifest).
*   All file access is mediated via the Android **Storage Access Framework (SAF)** and "Open with" / share intents.
*   The app requests **persistable URI permissions** to remember recent documents. It copies document content to a private cache directory for rendering when required, and cleans it up when the reader finishes.

### Network Isolation (Offline-First)
*   The production Android manifest (`android/app/src/main/AndroidManifest.xml`) does **not** request `android.permission.INTERNET`.
*   All signature validation is executed entirely locally (offline). It verifies PKCS#7 structures and builds certificate chains without invoking external CRL or OCSP network endpoints.

---

## 5. Cryptography & Signature Verification

### PDF Decryption
*   Standard PDF decryption (RC4, AES-128, AES-256) is executed natively via **PdfBox-Android**.
*   Passwords input by the user are immediately processed in Kotlin and are destroyed or dereferenced in memory. They are never written to disk.

### Signature Validation
*   **Integrity Checks:** The native Kotlin module uses Bouncy Castle (repackaged artifact to avoid classloader clashes) to verify PKCS#7 signatures against the ByteRange content.
*   **ByteRange Coverage Audit:** We verify that the signature's ByteRange covers the entire file length. If any bytes exist past the ByteRange, the file has been modified after signature creation and is marked as invalid.
*   **Chain Validation:** Validated offline using standard Android `CertPathValidator`.
*   **Trust Anchors:**
    1.  Bundled globally trusted certificate list (EU Trusted Lists pem file).
    2.  User-added certificates stored in the local SQLite `trust_store` table.
    *   *Note:* The Android system CA store is **not** used because it contains TLS authority anchors, not document-signing anchors.

---

## 6. Build Hardening

*   **Obfuscation:** Release builds are compiled with `--obfuscate` to randomize class and method names.
*   **Debug Symbols:** Debug mapping symbols are exported to a separate folder (`build/symbols`) and git-ignored.
*   **R8 / ProGuard:** Enabled for release builds to strip dead code and optimize native library bindings.
*   **No Debugging in Release:** The merged release manifest omits `android:debuggable="true"` (defaults to false), protecting runtime processes from attachment.
