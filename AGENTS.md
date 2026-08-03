# AGENTS.md — SreerajP_PDFApp

This file gives rules for anyone (including the AI assistant) working on this project.
Read it before making any change. See [docs/architecture.md](docs/architecture.md) for the full
technical design, [docs/PDF-Idea.md](docs/PDF-Idea.md) for the full product idea, and
[docs/GUIDELINES_MANIFEST.md](docs/GUIDELINES_MANIFEST.md) for the shared Flutter guidelines.

---

## 1. What this app is

An **Android app built in Flutter** for **everything PDF**: opening, reading, navigating,
annotating, extracting from, and reorganizing PDF files. It also works as a **PDF printer
for Android** — other apps can "print to PDF" / share content to this app to be saved as a
PDF. It is one of five apps split out from the original "File Reader" idea (the others cover
text/data files, code files, HTML, and EPUB). See [docs/PDF-Idea.md](docs/PDF-Idea.md) for the
full feature list, risks, and library decisions.

---

## 2. Tech stack (fixed)

- **Flutter 3.44.8 or higher**
- **Dart 3.12.2 or higher**
- **minSdk 26 (Android 8.0)**; phones and tablets, portrait and landscape.
- **Material 3** modern UI.
- Core libraries (open source only): **pdfrx** (pdfium) for rendering, **PdfBox-Android**
  (Apache 2.0) for page operations and data, **Bouncy Castle** + `CertPathValidator` in
  native Kotlin for signature crypto. See [docs/PDF-Idea.md](docs/PDF-Idea.md) for details.

---

## 3. Hard rules for this project

These are **must-follow** rules. They override convenience.

1. **Open source only.** Every library used must be **open source**. Commercial or
   source-available SDKs are **not allowed**, even with a free community license (for
   example, **Syncfusion, PSPDFKit, and Apryse are banned**). Check a package's license
   before adding it.
2. **Offline-first.** The app must work fully offline. The only online part is optional
   (opening remote links).
3. **Scoped storage only.** Open files through the **system file picker (Storage Access
   Framework)** and **"Open with" / share intents** only. **No** broad storage permission
   and **no** in-app file browser. Take persistable URI permissions for recent files.
4. **Never crash on bad input.** Corrupt, truncated, empty, or password-protected files
   must show a clear, friendly message. Every parser needs a failure path.
5. **Copy-on-write.** Every page operation (merge, split, reorder, rotate, delete, compress,
   encrypt/decrypt) writes a **new file**. The original is **never** modified in place.
6. **Never a dead button.** Shared modules — especially Malayalam TTS — report their state
   (ready / needs-install / unavailable). Reader screens render that state and never show a
   silently broken control.
7. **OCR is out of scope.** A scanned (image-only) PDF with no text layer degrades
   gracefully: show a notice and disable search, copy, text extraction, and TTS for it.

---

## 4. Security rules

Security is not optional. The full security rules live in
[docs/security-rules.md](docs/security-rules.md).

**Read [docs/security-rules.md](docs/security-rules.md) before changing any
security-sensitive code** — signature verification, encryption/decryption, storage,
logging, secrets, or anything that handles opened-file input.

---

## 5. Where things live

```
CLAUDE.md                 # this file — project rules
docs/                      # product idea and design notes
docs/PDF-Idea.md              # full product idea (features, risks, libraries, NFRs)
docs/architecture.md          # full technical design (layers, modules, DB, security)
docs/GUIDELINES_MANIFEST.md   # pointer to the shared Flutter guidelines
docs/security-rules.md        # full security rules (read when touching security code)
docs/workflow-rules.md        # full plan/approval/change-log workflow rules
docs/release-signing.md       # signed-release build runbook
plans/                    # one plan per change (see workflow rules)
change_log/               # one log per implemented change
lib/                      # app source (added during implementation)
```

---

## 6. Guidelines

Follow the shared Flutter guidelines listed in
[docs/GUIDELINES_MANIFEST.md](docs/GUIDELINES_MANIFEST.md). Those paths point to the **master**
copies. If a document has been copied into this app's own `docs/` folder, the **local copy
wins** for that app; use the master path only when there is no local copy.

---

## 7. Workflow rules (mandatory — from global rules)

Every change must follow the plan-before-changing and log-after-changing process. The
full workflow rules live in [docs/workflow-rules.md](docs/workflow-rules.md).

**Read [docs/workflow-rules.md](docs/workflow-rules.md) before starting or finishing
any change to the project.** In short: write a plan to `plans/` and get explicit
approval before editing, then write a change log to `change_log/` after.

---

## 8. Communication rules

- **Always use simple English.** Write all responses, plans, change logs, and explanations
  in plain, simple English. Prefer short sentences and common words. Avoid jargon unless it
  is necessary, and explain it when used.
