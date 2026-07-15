# Plan — Add architecture and release-signing docs

**Status:** completed

## What is the issue / goal

The PDF app has product docs (`PDF-Idea.md`), a build plan, a progress tracker, and the new
`CLAUDE.md` set. It is still missing two design docs that the sibling project
`SreerajP_TextApp` has, and that the shared guidelines expect:

- **`doc/architecture.md`** — the technical design (layers, packages, module layout, security,
  NFRs, testing). The engineering standard and `Core Baseline` profile require it.
- **`doc/release-signing.md`** — the runbook for building a signed production release.

Adding both keeps all projects on the same structure and guidelines.

## Files to be created / changed

| File | Action | Purpose |
|---|---|---|
| `doc/architecture.md` | create | Full technical design, mirroring TextApp's `architecture.md` layout, filled with PDF decisions from `PDF-Idea.md` + `pdf-app-implementation-plan.md`. |
| `doc/release-signing.md` | create | Signed-release runbook, mirroring TextApp's `release-signing.md`, adapted to this app (keystore, `key.properties`, build, verify, backup). |
| `CLAUDE.md` | edit | Add the two new docs to the "Where things live" tree and reference `architecture.md` as the technical design. |

No product docs are modified. Content is drawn from the existing docs, not copy-pasted wholesale.

## Plan for the content

### `doc/architecture.md` (same section shape as TextApp, PDF content)
1. **Design goals** — offline-first, one shared core reused across features, bounded memory on
   large PDFs (pdfium lazy pages), open-source only, security by default, never crash / never
   modify the original.
2. **Layered architecture** — UI → State (Riverpod) → Core+services (pure Dart) → Data/platform
   (SAF, sqflite, secure storage, Kotlin channels). Lower layers never depend on upper.
3. **Recommended open-source packages** — table: `pdfrx`, `flutter_riverpod`, `go_router`,
   `sqflite`, `shared_preferences`, `flutter_secure_storage`, `flutter_tts`, `share_plus`,
   `printing`, `logger`, plus native PdfBox-Android + Bouncy Castle behind platform channels.
4. **Project / module layout** — the Tier-2 feature-first `lib/` tree from the implementation
   plan §4 (viewer, reading, extraction, page_ops, annotation, printer, signature, settings,
   about; core/ config, constants, errors, logging, lifecycle, storage, platform).
5. **Modern UI approach** — Material 3, light/dark/sepia, adaptive layout, single/continuous/
   two-page views, thumbnails, TOC, friendly empty/error states.
6. **Feature modules (architectural view)** — viewer, reading (search/copy/metadata/TTS),
   extraction/convert, page operations (copy-on-write), annotation overlay layer, PDF printer,
   signature verification — each with its key design points and the platform channel it uses.
7. **Platform channels (native Kotlin)** — PdfBox-Android (page ops, extraction, metadata),
   signature module (Bouncy Castle repackaged + `CertPathValidator`), print service; the
   Dart-side wrappers under `core/platform/`.
8. **Data / database** — sqflite (WAL, FKs), the planned migrations table (recent_files,
   reading_positions, annotations, trust_store), content-fingerprint file identity.
9. **Settings + About config** — Settings sections (Appearance, Reading, Speech/TTS incl.
   Malayalam guided-install, Files, Security, About), and the fixed `app_config.json` →
   `ConfigService` → `AppConfig` About pattern.
10. **Security architecture** — untrusted input, scoped storage, copy-on-write, local signature
    verification, no secret/password logging, offline by design (link to `security-rules.md`).
11. **Non-functional requirements** — large files, file identity, offline, error handling,
    performance/memory, accessibility/localization.
12. **Testing strategy** — unit (fingerprint, config, TTS state, trust rules, conversion),
    widget (viewer states, scanned notice, Malayalam toggle, signature badge), integration
    (open→reopen-at-page, copy-on-write intact, encrypt/decrypt round-trip, DB upgrade, offline),
    test fixtures.

### `doc/release-signing.md` (mirrors TextApp, adapted)
- Secrets warning (keystore + `key.properties` are gitignored, never committed, back up offline).
- Note that the Gradle signing wiring is set up in Phase 0 scaffolding / finalized in Phase 8
  (reads `android/key.properties` if present, else falls back to debug signing).
- Generate the keystore (one time) — `keytool` command (PowerShell + bash).
- Create `android/key.properties` from the example template.
- Build the signed release — `flutter build appbundle` / `apk --release`, with
  `--obfuscate --split-debug-info` per the Definition of Done.
- Verify it is signed with the real key (`keytool -printcert`), not the debug key.
- Backup checklist.

## Notes
- Simple English throughout.
- After implementation, a change log goes to
  `change_log/yyyymmdd_hhMMss_architecture-and-release-signing-docs.md`.
