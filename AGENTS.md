# AGENTS.md — SreerajP_PDFApp

This file gives rules for AI coding assistants, agentic models, and LLMs (Gemini, Antigravity, Cursor, Windsurf, Codex, etc.) working in this project.
Read it before making any change. See the docs table below for full architectural and technical detail.

---

## Project identity

| Field | Value |
|---|---|
| App name | SreerajP PDF App |
| Type | An offline Android app for everything PDF (view, search, TTS, annotate, extract, reorganize, print, and verify signatures) |
| Platform(s) | Android only (minSdk 26, targetSdk 35) |
| Package / org id | `in.sreerajp.pdfapp` |
| Flutter SDK | 3.44.8 or higher |
| Dart SDK | 3.12.2 or higher |
| State management | `flutter_riverpod` (Riverpod 2.6+) |
| Navigation | `go_router` |
| Database | `sqflite` (SQLite WAL mode) |
| Orientation | Both portrait and landscape (phones and tablets) |
| Connectivity | Fully offline — zero network telemetry, `android.permission.INTERNET` is absent |

---

## Read these docs before working

| Document | Read when |
|---|---|
| [docs/architecture.md](docs/architecture.md) | Changing structure, screens, state, services, models, repositories |
| [docs/security.md](docs/security.md) | Touching permissions, logging, storage, crypto, manifest |
| [docs/release_process.md](docs/release_process.md) | Building a release, versioning, release checklist |
| [docs/dependencies.md](docs/dependencies.md) | Adding, upgrading, or checking approved packages |
| [docs/project_structure.md](docs/project_structure.md) | Reviewing folder responsibilities and layer boundaries |
| [docs/workflow_rules.md](docs/workflow_rules.md) | Starting or finishing any change (plan-before-change, log-after-change) |
| [docs/GUIDELINES_MANIFEST.md](docs/GUIDELINES_MANIFEST.md) | The shared Flutter guidelines index |

> If a doc is copied into this project's own `docs/`, the local copy wins over the master submodule.

---

## Hard rules (must follow — these override convenience)

1. **Open source only.** Every library used must be **open source** (MIT, BSD, Apache 2.0). Commercial or source-available SDKs are **strictly banned** (e.g. Syncfusion, PSPDFKit, and Apryse are banned). Check a package's license before adding it.
2. **Offline-first.** The app must work fully offline with zero telemetry. The production manifest must not request `android.permission.INTERNET`.
3. **Scoped storage only.** Open files through the **system file picker (Storage Access Framework)** and **"Open with" / share intents** only. **No** broad storage permission and **no** in-app file browser. Take persistable URI permissions for recent files.
4. **Never crash on bad input.** Corrupt, truncated, empty, or password-protected files must show a clear, friendly message. Every parser needs a failure path.
5. **Copy-on-write.** Every page operation (merge, split, reorder, rotate, delete, compress, encrypt/decrypt) writes a **new file**. The original is **never** modified in place.
6. **Never a dead button.** Shared modules — especially Malayalam TTS — report their state (ready / needs-install / unavailable). Reader screens render that state and never show a silently broken control.
7. **OCR is out of scope.** A scanned (image-only) PDF with no text layer degrades gracefully: show a notice and disable search, copy, text extraction, and TTS for it.

---

## Architecture rules

- **Layout**: Tier 2 Feature-First under `lib/` (`app/`, `core/`, `features/<feature>/`, `l10n/`, `main.dart`).
- **Layer boundaries**: Widgets MUST NOT know direct SQL queries, raw SharedPreferences keys, file paths, or platform channels. Data services MUST NOT know `BuildContext`, routes, or UI strings.
- **Dependency direction**: Presentation (`screens/`, `widgets/`) -> Providers / Controllers -> Data / Services -> Models.
- **Models**: Immutable Dart classes with `const` constructors and `copyWith` helpers.
- **Config Single Source of Truth**: About-screen constants come strictly from `assets/config/app_config.json` via `AppConfig` and `ConfigService` (`lib/core/config/`). Never hard-code About metadata.

---

## Build & run commands

```bash
flutter pub get                        # install dependencies
flutter run                            # daily development
flutter analyze                        # static analysis (must be clean, 0 warnings)
flutter test                           # run all unit and widget tests
dart format .                          # format code before committing

# Production release APK (split per ABI with obfuscation)
flutter build apk --release \
  --obfuscate --split-debug-info=build/symbols --split-per-abi

# Production Play Store bundle
flutter build appbundle --release \
  --obfuscate --split-debug-info=build/symbols
```

---

## Signing / keystore

- Keystore file: `android/upload-keystore.jks` (alias `upload`). Keep secure offline backups.
- Signing properties: `android/key.properties` (gitignored — never commit).
- `.gitignore` MUST include `android/key.properties`, `android/*.jks`, `android/*.keystore`, and `build/symbols/`.

---

## Security rules

- Never log secrets, passwords, encryption keys, decrypted data, or document contents — even in debug builds.
- Passwords entered for encrypted PDFs are kept in volatile memory only and dereferenced immediately.
- Signature verification and chain validation are performed locally and offline via native Kotlin (`PdfBox-Android`, Bouncy Castle, and `CertPathValidator`).
- Scoped storage: use SAF URIs and private cache directories. Clean up temporary cache files when readers finish.

---

## Localization rules

- All user-visible text MUST come from `lib/l10n/*.arb` via `AppLocalizations` — never raw string literals in widgets.
- The app supports English (`app_en.arb`) and Malayalam (`app_ml.arb`).
- `l10n.yaml` (project root) and `lib/l10n/app_en.arb` exist. Run `flutter gen-l10n` after editing any `.arb` file.
- Literals are permitted only for internal logs, non-UI exceptions, asset paths, and database identifiers.

---

## Code style / naming

- Files: `snake_case.dart`; Classes: `PascalCase`; Variables/Functions: `camelCase`; Providers: `camelCase` + `Provider` suffix.
- Use `package:` imports exclusively (no relative imports across layers).
- Prefer `const` constructors, `final` local declarations, and single quotes.
- Run `dart format .` and maintain `flutter analyze` at zero warnings before committing.

---

## Testing rules

- Mirror `lib/` directory structure in `test/` (e.g. `test/features/viewer/presentation/`, `test/features/reading/domain/`).
- Critical areas with 100% test coverage requirements: SQLite schema migrations, Indic phonetic search and Sandhi normalization, PDF decryption/encryption parsing, copy-on-write file generators, and custom trust store validation.
- Add or update a test whenever a new service, DAO, or provider is introduced.

---

## Dependency constraints

- **Allowed**: Open-source packages (MIT, BSD, Apache 2.0) with zero tracking or telemetry.
- **Blocked**: Proprietary PDF SDKs (Syncfusion, PSPDFKit, Apryse), Firebase/BaaS, analytics/telemetry, ad SDKs, and remote HTTP clients.

---

## Where things live

```
.
|-- .agents/                 # AI assistant instructions (AGENTS.md)
|-- android/                 # Native Android project (Kotlin, PdfBox, Bouncy Castle)
|-- assets/
|   |-- config/              # app_config.json (Single source of truth for About metadata)
|   |-- icons/               # App icon assets
|   `-- trust/               # Bundled EU trusted lists root certificates
|-- change_log/              # Implemented change logs (yyyymmdd_hhMMss_<slug>.md)
|-- docs/                    # Architecture, security, and process documentation
|   `-- guidelines/          # Shared Flutter guidelines Git submodule
|-- lib/                     # Application source code (Tier 2 Feature-First)
|-- plans/                   # Implementation plans (yyyymmdd_hhMMss_<slug>.md)
|-- test/                    # Unit and widget tests
`-- pubspec.yaml             # Dependencies and metadata
```

---

## Workflow rules (mandatory — from global rules)

Every change follows plan-before-changing and log-after-changing:

1. **Plan before changing.** Write a full plan to `plans/` named `yyyymmdd_hhMMss_<short-slug>.md` with a `**Status:**` line, the files to change, the issue, and the fix. Then **STOP and get explicit approval** before editing/creating/deleting any project file (other than the plan). A question or ambiguous reply is not approval.
2. **Log after changing.** After implementing, write a change log to `change_log/` named `yyyymmdd_hhMMss_<short-slug>.md` describing what changed and referencing its plan.
3. **Relative paths & privacy only.** `plans/` and `change_log/` files are committed and may become public on the internet. They MUST use relative repository paths only (never absolute system paths like `C:\...`, `l:\...`, or `file:///...`). They MUST NOT contain any **local system details** — OS user name, computer/host name, home or drive-letter paths, network share names, LAN/internal IP addresses, local server URLs with ports, device serial numbers, personal email addresses — or any secret (API keys, tokens, passwords, keystore passphrases, credentials, PII). Write them as if a stranger will read them; nothing should reveal the machine they came from.

---

## Communication rules

- **Always use simple English.** Write all responses, plans, change logs, and explanations in plain, simple English. Short sentences, common words. Explain any jargon you must use.

---

## What AI assistants must always / never do

**Always:**
- Read this file and referenced docs before modifying code.
- Write a plan to `plans/` and wait for explicit user approval before editing code.
- Write a change log to `change_log/` after completing changes.
- Ensure all user-facing strings are localized via `AppLocalizations`.
- Keep `main.dart` minimal (initialization only).
- Run `flutter analyze` and `flutter test` after code modifications.

**Never:**
- Never modify existing PDF files in place (always copy-on-write).
- Never add proprietary/commercial SDKs or network telemetry packages.
- Never log user passwords or decrypted document content.
- Never hard-code About metadata in UI widgets.
- Never use absolute file paths or include local system details in `plans/` or `change_log/`.
