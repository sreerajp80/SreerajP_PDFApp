# AGENTS.md — SreerajP_PDFApp

This file is read by AI agents and LLM coding assistants (Gemini, Antigravity, Cursor, Windsurf, Codex, etc.) at the start of every session in this repository.
Read it before making any change. Follow the guidelines listed in `docs/GUIDELINES_MANIFEST.md`, starting with `docs/guidelines/AI_AGENT_START_HERE.md`. See the docs table below for full detail.

---

## Project identity

| Field | Value |
|---|---|
| App name | Folio (Malayalam: ഗ്രന്ഥം, Sanskrit: ग्रन्थः) |
| Type | An offline Android app for everything PDF (view, search, TTS, annotate, extract, reorganize, print, and verify signatures) |
| Platforms | Android only (minSdk 26, targetSdk = Flutter default `flutter.targetSdkVersion`) |
| Stores / channels | Google Play (App Bundle), signed split APKs for direct download |
| Languages | English (`en`, template), Malayalam (`ml`), Sanskrit (`sa`) |
| Package / org id | `in.sreerajp.pdfapp` |
| Flutter SDK | 3.47.6 (stable) — `pubspec.yaml` requires `>=3.47.0` |
| Dart SDK | 3.13.5 — `pubspec.yaml` requires `^3.13.0` |
| State management | `flutter_riverpod` (Riverpod 3.4+) |
| Navigation | `go_router` |
| Database | `sqflite` (SQLite WAL mode) |
| Orientation | Both portrait and landscape (phones and tablets) |
| Connectivity | No internet — zero telemetry; `INTERNET` is declared only for Device sync on the local WiFi |

---

## Read these docs before working

| Document | Read when |
|---|---|
| [docs/PROJECT_PROFILE.md](../docs/PROJECT_PROFILE.md) | Always — platforms, stores, languages, identity, About options |
| [docs/architecture.md](../docs/architecture.md) | Changing structure, screens, state, services, models, repositories |
| [docs/security.md](../docs/security.md) | Touching permissions, logging, storage, crypto, manifest |
| [docs/release_process.md](../docs/release_process.md) | Building a release, versioning, release checklist |
| [docs/dependencies.md](../docs/dependencies.md) | Adding, upgrading, or checking approved packages |
| [docs/project_structure.md](../docs/project_structure.md) | Reviewing folder responsibilities and layer boundaries |
| [docs/workflow_rules.md](../docs/workflow_rules.md) | Starting or finishing any change (plan-before-change, log-after-change) |
| [docs/features.md](../docs/features.md) | Checking what the app already does before adding or changing a feature |
| [docs/pdf_idea.md](../docs/pdf_idea.md) | Understanding the product concept, scope, and design intent |
| [docs/feature_analysis_and_roadmap.md](../docs/feature_analysis_and_roadmap.md) | Planning new features or checking what is already on the roadmap |
| [docs/implementation_plan.md](../docs/implementation_plan.md) | Looking up the phase-by-phase build plan (point-in-time record) |
| [docs/implementation_progress.md](../docs/implementation_progress.md) | Checking which phases are done (point-in-time record) |
| [docs/guidelines/AI_AGENT_START_HERE.md](../docs/guidelines/AI_AGENT_START_HERE.md) | First visit — read order and the "ready for the stores" gates |
| [docs/guidelines/flutter_project_engineering_standard.md](../docs/guidelines/flutter_project_engineering_standard.md) | Any code change — layers, naming, localization, testing |
| [docs/guidelines/guideline.md](../docs/guidelines/guideline.md) | About screen, Android keystore, `lib/` layout |
| [docs/guidelines/flutter_build_flavors_guide.md](../docs/guidelines/flutter_build_flavors_guide.md) | Build config, signing, flavors, Gradle, ProGuard |
| [docs/guidelines/platform_store_readiness.md](../docs/guidelines/platform_store_readiness.md) | Before any release; when touching permissions or store-listed behavior |
| [docs/guidelines/language_packs/sanskrit_malayalam.md](../docs/guidelines/language_packs/sanskrit_malayalam.md) | Adding or changing any Malayalam or Sanskrit text |
| [docs/GUIDELINES_MANIFEST.md](../docs/GUIDELINES_MANIFEST.md) | The shared Flutter guidelines index |

> `docs/<file>` = this app's own filled-in copy (templates such as `architecture.md`,
> `security.md`, `release_process.md`, `PROJECT_PROFILE.md` — the local copy wins).
> `docs/guidelines/<file>` = the shared reference in the submodule; never copy it into `docs/`
> and never edit it from this project.

---

## Hard rules (must follow — these override convenience)

1. **Open source only.** Every library used must be **open source** (MIT, BSD, Apache 2.0). Commercial or source-available SDKs are **strictly banned** (e.g. Syncfusion, PSPDFKit, and Apryse are banned). Check a package's license before adding it.
2. **No internet.** The app must work fully offline, never contact an internet host, and have zero telemetry. `android.permission.INTERNET` is declared **only** for Device sync: phone-to-phone on a private local network (WiFi or hotspot), paired by QR code, encrypted with a one-time key, and open only while the Device sync screen is open. Raw sockets live only in `lib/features/nearby_transfer/data/`; HTTP and web-socket clients are banned (both checked in CI).
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

Full detail: [docs/architecture.md](../docs/architecture.md).

---

## Build & run commands

```bash
flutter pub get                        # install dependencies
flutter gen-l10n                       # regenerate localizations after editing any .arb file
flutter run --flavor dev               # daily development
flutter run --flavor prod              # production flavor with debug tooling
flutter analyze                        # static analysis (must be clean, 0 warnings)
flutter test                           # run all unit and widget tests
dart format .                          # format code before committing

# Production release APK (split per ABI with obfuscation) — direct download channel
flutter build apk --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android-prod-<version>/ --split-per-abi

# Production Play Store bundle — Google Play channel
flutter build appbundle --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android-prod-<version>/
```

> This project defines Gradle product flavors, so a bare `flutter run` or
> `flutter build apk` **fails**. Always pass `--flavor dev` or `--flavor prod`.
> `<version>` is the `pubspec.yaml` version, e.g. `2.7.4+24`. Android is the only declared
> platform. Before any release, pass the Google Play gate in
> [docs/guidelines/platform_store_readiness.md](../docs/guidelines/platform_store_readiness.md) and
> follow [docs/release_process.md](../docs/release_process.md).

---

## Build flavors

| Flavor | Application id | Display name | Signing |
|---|---|---|---|
| `dev` | `in.sreerajp.pdfapp.dev` | Folio Dev | Debug keystore (automatic) |
| `prod` | `in.sreerajp.pdfapp` | Folio | Release keystore (`android/key.properties`) |

- The flavors are declared in `android/app/build.gradle.kts` under the `environment` dimension.
  `dev` adds the `.dev` application id suffix and the `-dev` version name suffix.
- Flutter injects `FLUTTER_APP_FLAVOR`; read it with
  `String.fromEnvironment('FLUTTER_APP_FLAVOR')`. Do not pass it yourself.
- Flavor-dependent values live in `lib/app/config/app_flavor_config.dart`. Never use
  `kDebugMode` / `kReleaseMode` as a stand-in for the flavor.
- There are no desktop targets, so the `APP_FLAVOR` dart-define path is not used here.

---

## Signing / keystore

- Keystore file: `android/upload-keystore.jks` (alias `upload`). Keep at least one secure offline backup.
- Signing properties: `android/key.properties` (gitignored — never commit).
- `.gitignore` MUST include `android/key.properties`, `android/*.jks`, `android/*.keystore`, and `build/` (which also holds the debug symbols).
- Keystore rules come from [docs/guidelines/guideline.md](../docs/guidelines/guideline.md) §2. Full steps: [docs/release_process.md](../docs/release_process.md).

---

## Security rules

- Never log secrets, passwords, encryption keys, decrypted data, or document contents — even in debug builds.
- Follow the Security Baseline (`docs/guidelines/flutter_project_engineering_standard.md` §15.1). Never weaken a security control to make something work; ask first.
- No secrets in code, assets, or `--dart-define` — anything shipped in the app is public.
- Passwords entered for encrypted PDFs are kept in volatile memory only and dereferenced immediately.
- Signature verification and chain validation are performed locally and offline via native Kotlin (`PdfBox-Android`, Bouncy Castle, and `CertPathValidator`).
- Request only the permissions the app needs. `INTERNET` and `CAMERA` exist only for Device sync (local WiFi + QR scan); never use them for anything else, and never contact an internet host.
- Scoped storage: use SAF URIs and private cache directories. Clean up temporary cache files when readers finish.

Full detail (threat model, data retention, OWASP checklist): [docs/security.md](../docs/security.md).

---

## Localization rules

- Declared languages (from `docs/PROJECT_PROFILE.md`): **English (`en`, template), Malayalam
  (`ml`), Sanskrit (`sa`)**. Every feature and every screen works in every declared language.
- All user-visible text MUST come from `lib/l10n/*.arb` via `AppLocalizations` — never raw string literals in widgets.
- `l10n.yaml` (project root) and `app_en.arb`, `app_ml.arb`, `app_sa.arb` exist. Run `flutter gen-l10n` after editing any `.arb` file.
- Every new key goes into **every** ARB file with a real translation — never leave the English
  value in `app_ml.arb` or `app_sa.arb`. Key parity is checked by `test/l10n/translation_parity_test.dart`.
- Every ARB key needs an `@key` description entry in `app_en.arb`.
- Language pack in force: [docs/guidelines/language_packs/sanskrit_malayalam.md](../docs/guidelines/language_packs/sanskrit_malayalam.md).
  Sanskrit must be authentic (no Hindi markers) and use the pack glossary; Malayalam must be
  natural (no lazy transliteration). Flag any translation you are unsure of for native-reader
  review in the change log.
- `supportedLocales` equals the declared languages. `sa` has no Flutter framework translation, so
  the `Sa*LocalizationsDelegate` fallback delegates (English, never Hindi) stay installed.
  Format dates and numbers through `DisplayFormat` (`lib/core/format/`), which falls back safely
  for locales `intl` does not know (the project's `formattingLocale(...)` helper, engineering standard §8.3.2).
- The language is user-selectable in Settings (System default + each language by its endonym:
  English, മലയാളം, संस्कृतम्), persisted, and applied without restarting the app.
- Menu, button, label, tab and tooltip strings stay short in every declared language (20 for `en`, 22
  for `ml` / `sa`, checked by `test/l10n/label_length_test.dart`); only
  `desc…`/`help…`/`empty…`/`error…`/`body…`/`aboutDetail…` keys may be long.
- Every icon-only control has a localized `tooltip:` (engineering standard §7.8).
- Material and Cupertino come from the `material_ui` / `cupertino_ui` packages (engineering
  standard §6.1). Import `package:material_ui/material_ui.dart` /
  `package:cupertino_ui/cupertino_ui.dart` — never `package:flutter/material.dart` or
  `package:flutter/cupertino.dart`. From `flutter_localizations` import only
  `GlobalWidgetsLocalizations` (`show GlobalWidgetsLocalizations`).
- The About screen is data-driven (`assets/config/app_config.json`) and localized. It ends with
  the signature badge "Made with ❤️ from India" (`MadeWithLove`, `lib/core/widgets/`), localized
  in all three languages with a red heart — the project profile enables it.
- Literals are permitted only for internal logs, non-UI exceptions, asset paths, route names, map/JSON keys, and database identifiers.

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
- **Blocked** (never add, never accept as a transitive dependency): Proprietary PDF SDKs (Syncfusion, PSPDFKit, Apryse), Firebase/BaaS, analytics/telemetry, crash reporting, ad SDKs, and remote HTTP clients.
- Before adding any package: check its license and its own dependencies for networking, and record it in [docs/dependencies.md](../docs/dependencies.md).

---

## Where things live

```
.
|-- .agents/                 # Copy of AGENTS.md for tools that look inside .agents/
|-- android/                 # Native Android project (Kotlin, PdfBox, Bouncy Castle)
|-- assets/
|   |-- branding/            # App launcher icon source art
|   |-- config/              # app_config.json (Single source of truth for About metadata)
|   |-- fonts/               # Bundled Malayalam fonts (Manjari, Anek, Noto Sans Malayalam)
|   `-- trust/               # Bundled EU trusted lists root certificates
|-- change_log/              # Implemented change logs (yyyymmdd_hhMMss_<slug>.md)
|-- docs/                    # Project profile, architecture, security, and process documentation
|   `-- guidelines/          # Shared Flutter guidelines Git submodule (read-only here)
|-- lib/                     # Application source code (Tier 2 Feature-First)
|-- plans/                   # Implementation plans (yyyymmdd_hhMMss_<slug>.md)
|-- samples/                 # Sample PDFs used for manual testing
|-- test/                    # Unit and widget tests (mirrors lib/)
|-- tool/                    # Project utility scripts (e.g. icon generation)
|-- AGENTS.md                # This file — project rules for AI agents and LLMs
|-- CLAUDE.md                # Claude Code native project rules (same rules)
|-- CHANGELOG.md             # User-facing release history
|-- README.md                # Setup, run, test, and build instructions
|-- analysis_options.yaml    # Lint and static analysis configuration
|-- l10n.yaml                # Localization generator configuration
`-- pubspec.yaml             # Dependencies and metadata
```

---

## Workflow rules (mandatory)

Every change follows plan-before-changing and log-after-changing:

1. **Plan before changing.** Write a full plan to `plans/` named `yyyymmdd_hhMMss_<short-slug>.md` with a `**Status:**` line, the files to change, the issue, and the fix. Then **STOP and get explicit approval** before editing/creating/deleting any project file (other than the plan). A question or ambiguous reply is not approval. A plan that touches network, storage, sign-in, permissions, deep links, WebViews, platform folders or dependencies has a short **"Security impact"** line (engineering standard §22.2).
2. **Log after changing.** After implementing, write a change log to `change_log/` named `yyyymmdd_hhMMss_<short-slug>.md` describing what changed and referencing its plan.
3. **Relative paths & privacy only.** `plans/` and `change_log/` files are committed and may become public on the internet. They MUST use relative repository paths only (never absolute system paths like `C:\...`, `l:\...`, or `file:///...`). They MUST NOT contain any **local system details** — OS user name, computer/host name, home or drive-letter paths, network share names, LAN/internal IP addresses, local server URLs with ports, device serial numbers, personal email addresses — or any secret (API keys, tokens, passwords, keystore passphrases, credentials, PII). Write them as if a stranger will read them; nothing should reveal the machine they came from.
4. **The guidelines submodule is read-only.** `docs/guidelines/` is read-only. Never edit, pull, check out or commit the submodule or its version. If a guideline needs a change, write a note for the user instead (`docs/guidelines/DOCS_FOLDER_GUIDELINE.md` §1.1). If the folder is empty or missing, stop and ask the user.
5. **CI is checks only.** GitHub CI runs only `flutter pub get`, code generation (if used), the format check, `flutter analyze`, `flutter test`, and other pass/fail check scripts. No Dependabot or other update bot: dependencies are updated by hand. CI never builds release artifacts, signs, holds signing secrets, uploads, or publishes. Release builds are done locally (`docs/guidelines/flutter_project_engineering_standard.md` §19).

Create `plans/` and `change_log/` if they do not exist. Full detail: [docs/workflow_rules.md](../docs/workflow_rules.md).

---

## Communication rules

- **Always use simple English.** Write all responses, plans, change logs, and explanations in plain, simple English. Short sentences, common words. Explain any jargon you must use.

---

## What AI agents must always / never do

**Always:**
- Read this file and referenced docs before modifying code.
- Write a plan to `plans/` and wait for explicit user approval before editing code.
- Write a change log to `change_log/` after completing changes.
- Ensure all user-facing strings are localized via `AppLocalizations`, in all three languages.
- Keep `main.dart` minimal (initialization only).
- Run `flutter analyze` and `flutter test` after code modifications.
- Keep `AGENTS.md`, `.agents/AGENTS.md` and `CLAUDE.md` in sync when changing any rule.

**Never:**
- Never modify existing PDF files in place (always copy-on-write).
- Never add proprietary/commercial SDKs or network telemetry packages.
- Never log user passwords or decrypted document content.
- Never hard-code About metadata in UI widgets.
- Never edit files inside the `docs/guidelines/` submodule from this project.
- Never use absolute file paths or include local system details in `plans/` or `change_log/`.
