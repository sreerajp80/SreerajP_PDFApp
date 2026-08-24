# Project Structure — SreerajP_PDFApp

This document details the folder structure and architectural responsibilities of the SreerajP PDF App codebase.

Read this before adding new modules, features, or screens. Full architectural details live in [architecture.md](architecture.md).

---

## 1. Directory Tree Overview

```
.
|-- .agents/                 # Copy of AGENTS.md for tools that look inside .agents/
|-- android/                 # Native Android Gradle project (Kotlin, PdfBox, Bouncy Castle)
|-- assets/
|   |-- branding/            # App launcher icon source art
|   |-- config/              # app_config.json (Single source of truth for About metadata)
|   |-- fonts/               # Bundled Malayalam fonts (Manjari, Anek, Noto Sans Malayalam)
|   `-- trust/               # Bundled root certificates for signature checking
|-- change_log/              # Implemented change logs (yyyymmdd_hhMMss_<slug>.md)
|-- docs/                    # Architectural, security, and process documentation
|   `-- guidelines/          # Shared Flutter guidelines Git submodule
|-- lib/                     # Application source code (Tier 2 Feature-First)
|-- plans/                   # Implementation plans (yyyymmdd_hhMMss_<slug>.md)
|-- samples/                 # Sample PDFs used for manual testing
|-- test/                    # Unit and widget test suite (mirrors lib/ structure)
|-- tool/                    # Project utility scripts (e.g. icon generation)
|-- AGENTS.md                # Project rules for AI agents and LLMs
|-- CLAUDE.md                # Project rules for Claude Code
|-- CHANGELOG.md             # User-facing release history
|-- README.md                # Setup, run, test, and build instructions
|-- analysis_options.yaml    # Static analysis and lint configurations
|-- l10n.yaml                # Flutter localization tool configuration
`-- pubspec.yaml             # Dart and Flutter dependencies configuration
```

---

## 2. Source Code Layout (`lib/`)

The application follows the **Tier 2 Feature-First** layout specified in `docs/guidelines/flutter_project_engineering_standard.md §3.1`.

```
lib/
|-- main.dart                # Application entrypoint, initializes DB and runs ProviderScope
|-- app/
|   |-- config/              # Flavor config and global Riverpod providers / service wiring
|   |-- routing/             # AppRouter, route definitions, and navigation guards
|   `-- theme/               # Material 3 theme configurations and design tokens
|-- core/
|   |-- config/              # AppConfig model + ConfigService (About metadata - fixed path)
|   |-- constants/           # AppConstants — technical constants, values only, no logic
|   |-- errors/              # AppException hierarchy and safe error fallbacks
|   |-- format/              # Display formatting helpers (sizes, dates, page labels)
|   |-- lifecycle/           # AppLifecycleService — foreground/background handling
|   |-- logging/             # AppLogger abstraction wrapping package:logger
|   |-- platform/            # Method-channel clients (PdfBox, signature, TTS, open document)
|   |-- search/              # Indic phonetic engine, Sandhi engine, script detection,
|   |                        # transliteration, and search normalization
|   `-- storage/             # AppDatabase, SQLite migrations, cache service, file fingerprint
|-- features/
|   |-- about/               # About screen presentation and config binding
|   |-- annotation/          # Overlay annotations (markups, drawings, sticky notes, bookmarks)
|   |-- extraction/          # Plain text, images, form fields, and metadata extraction
|   |-- help/                # In-app help topics (TTS, Unicode printing, PDF printer guide)
|   |-- page_ops/            # Reorganize, merge, split, rotate, compress, encrypt/decrypt
|   |-- printer/             # System print integration, text/image-to-PDF converters
|   |-- reading/             # Search engine (Indic/Sandhi), TTS integration, bookmarks
|   |-- settings/            # Appearance, Malayalam TTS toggle, permissions, and preferences
|   |-- signature/           # Digital signature verification and custom trust store
|   `-- viewer/              # Home recents screen, core PDF rendering, zoom, and navigation
`-- l10n/                    # ARB localizations (app_en.arb, app_ml.arb, generated classes)
```

---

## 3. Feature Directory Structure

Each feature under `lib/features/<feature_name>/` adheres strictly to standard separation of concerns:

- `domain/` — Pure Dart models, entities, and business validation (no UI imports).
- `data/` — DAOs, local database repositories, and platform-channel service clients.
- `presentation/` — State notifiers (Riverpod), UI screens, dialogs, and widgets.

---

## 4. Layer Boundary Rules

1. **Presentation Layer (`presentation/`)**:
   - MUST NOT execute direct SQL queries or invoke platform channels directly.
   - All state mutations and asynchronous loads MUST flow through Riverpod providers.
   - All user-facing strings MUST come from `AppLocalizations`.
2. **Domain Layer (`domain/`)**:
   - MUST remain pure Dart (no `flutter/material.dart`, no platform-specific code).
   - Models MUST be immutable with `copyWith` and serialization helpers.
3. **Data Layer (`data/`)**:
   - Encapsulates database tables, `SharedPreferences`, and platform channels.
   - Catches lower-level errors and returns domain models or typed failures.
