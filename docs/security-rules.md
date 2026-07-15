# Security rules — SreerajP_PDFApp

Read this file before changing any security-sensitive code (signature verification,
encryption/decryption, storage, logging, secrets, or anything touching opened-file input).
These rules are part of the project rules in [../CLAUDE.md](../CLAUDE.md). Full product
context is in [PDF-Idea.md](PDF-Idea.md).

Security is not optional. Follow these for every change.

- **Treat every opened PDF as untrusted input.** Validate before use. A corrupt, truncated,
  empty, or password-protected file must fail into a clear, friendly message — never a crash.
  Every parser needs a failure path.
- **Never send file contents anywhere** without the user's explicit action (share / export).
  The app is offline-first; there is no telemetry and no upload of document content.
- **Copy-on-write for all page operations.** Merge, split, reorder, rotate, delete, compress,
  and encrypt/decrypt always write a **new file**. The original is never modified in place, so
  write access to the original is not required.
- **Signature verification is done locally.** Real cryptography (PKCS#7 / CMS parsing,
  certificate-chain validation, revocation checks) runs in native Kotlin behind a platform
  channel: **PdfBox-Android** reads the signature and ByteRange, **Bouncy Castle** verifies
  the PKCS#7 data, and Android's **`CertPathValidator`** checks the chain and revocation.
  - Use the **repackaged Bouncy Castle** artifact — Android ships a stripped, outdated copy
    that causes classloader conflicts.
  - **"Globally trusted"** means a certificate list bundled with the app (Adobe AATL / EU
    EUTL), **not** the Android system CA store (that store is for TLS, not document signing).
  - Show the **green tick only** for a signature that verifies against a trusted certificate.
    Show honest unknown / invalid states otherwise — never fake trust.
- **Never log secrets.** File contents, passwords, decryption keys, and certificate private
  material must never be logged — not even in debug builds. Keep error messages user-safe
  (no secret material).
- **File identity is a content fingerprint** (file size + hash), with the persisted URI as a
  fast path. Reading positions, app-side bookmarks, and overlay annotations are keyed to it.
  A modified file is treated as a **new document** — old positions and annotations are not
  applied to content that no longer matches.
- **Storage access is scoped.** Files are opened only through the system file picker (Storage
  Access Framework) and "Open with" / share intents. Take persistable URI permissions for
  recent files, and handle a denied or stale persisted URI gracefully.
