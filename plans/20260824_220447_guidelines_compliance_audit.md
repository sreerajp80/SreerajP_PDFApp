# Guidelines Compliance Audit and Fixes

**Status:** completed

This plan records a full audit of the project against the shared guidelines in
`docs/guidelines/`, and the fixes needed to make the structure, code, and docs follow them.

Guidelines checked: `guideline.md`, `CLAUDE_MD_GUIDELINE.md`, `AGENTS_MD_GUIDELINE.md`,
`DOCS_FOLDER_GUIDELINE.md`, `flutter_project_engineering_standard.md`, `GUIDELINES_MANIFEST.md`.

---

## 1. What already passes (no change needed)

These were checked and are fully compliant. They are listed so the audit is complete.

- `flutter analyze` — **0 issues**.
- `flutter test` — **390 tests pass**.
- Localization — 646 keys in `app_en.arb`, all with `@key` descriptions; `app_ml.arb` has all
  646 keys. `l10n.yaml` and `lib/l10n/app_en.arb` exist.
- About config pattern (`guideline.md` §1) — `assets/config/app_config.json`,
  `lib/core/config/app_config.dart` (`AppConfig` with `fromJson` + `fallback`),
  `lib/core/config/config_service.dart` (`ConfigService` with `load()` + `loadAndVerify()`),
  and a data-driven About screen. All exact.
- `pubspec.yaml` registers `assets/config/`; version `2.7.1+21` matches `app_config.json`.
- Keystore rules (`guideline.md` §2) — `.gitignore` covers `android/key.properties`,
  `android/*.jks`, `android/*.keystore`, `build/symbols/`, APK/AAB output.
- Git hygiene — no build output, secrets, `.dart_tool/`, or IDE files tracked.
- No `INTERNET` permission in the manifest.
- No relative Dart imports (0 found); `always_use_package_imports` lint is on.
- All 8 mandatory baseline docs from `DOCS_FOLDER_GUIDELINE.md` §6 exist.
- Root `CLAUDE.md` and `AGENTS.md` both exist and their rule sections match each other.
- Every relative markdown link in the root files and `docs/` resolves to a real file.
- `README.md` meets engineering standard §21.3 (prerequisites, setup, tests, code generation,
  build commands, migration steps, dart-defines).

---

## 2. Issues found

### A. Privacy rule breach in `plans/` and `change_log/` (MUST)

`guideline.md` §3, `DOCS_FOLDER_GUIDELINE.md` §3, engineering standard §21.1.1, and this
project's own `CLAUDE.md` workflow rule 3 all forbid absolute system paths in these folders.

**22 files contain 62 links** that begin with a `file:` URL carrying a drive letter and the
machine-local project folder — 7 files in `plans/`, 15 files in `change_log/`. A 23rd file also
links to a local IDE working folder under a home directory, which leaks the OS user name.

### B. Root `CLAUDE.md` / `AGENTS.md` are wrong about the build

The app defines two Gradle product flavors (`dev`, `prod`) in `android/app/build.gradle.kts`.

- **B1.** Neither file has the "Build flavors" section that `CLAUDE_MD_GUIDELINE.md` §3 (row 7)
  and `AGENTS_MD_GUIDELINE.md` §3 require when flavors are used.
- **B2.** The build commands are wrong. They say `flutter run` (which **fails** on a flavored
  project) and `flutter build apk --release` without `--flavor prod`. `README.md` already has
  the correct commands, so the two disagree.
- **B3.** The "Where things live" tree lists `assets/icons/`, which does not exist. The real
  folder is `assets/branding/`. `assets/fonts/`, `tool/`, `samples/`, `README.md`,
  `CHANGELOG.md`, `l10n.yaml`, and `analysis_options.yaml` are missing from the tree.
- **B4.** The "Read these docs before working" table lists 7 docs but `docs/` holds 12. Missing:
  `features.md`, `pdf_idea.md`, `implementation_plan.md`, `implementation_progress.md`,
  `feature_analysis_and_roadmap.md`.

### C. `docs/` folder issues

- **C1.** `docs/GUIDELINES_MANIFEST.md` is a **stale copy**. `DOCS_FOLDER_GUIDELINE.md` §1 says
  it is copied in unchanged from the shared set. The submodule version has since added rows for
  `CLAUDE_MD_GUIDELINE.md`, `AGENTS_MD_GUIDELINE.md`, and `DOCS_FOLDER_GUIDELINE.md`, plus an
  updated profile table and "Where to start" list. Ours has none of that.
- **C2.** `docs/project_structure.md` §2 does not match the real code. It lists
  `core/database/`, `core/utils/`, and `core/widgets/` — **none of these exist**. It omits the
  real folders `core/constants/`, `core/format/`, `core/lifecycle/`, `core/platform/`,
  `core/search/`, `core/storage/`. It also omits the `help/` feature, and its root tree repeats
  the `assets/icons/` error from B3.
- **C3.** `docs/feature_analysis_and_roadmap.md` is a point-in-time roadmap but has no
  `**Date:**` line (`DOCS_FOLDER_GUIDELINE.md` §5).
- **C4.** `docs/features.md` does not follow the §4 file anatomy: its title is
  `# SreerajP PDF App — Features & App Documentation` instead of `# Features — SreerajP PDF App`,
  and it has no purpose paragraph, no "read first" links, and no `---` before the first section.

### D. Plan status values outside the allowed set

The allowed values are `draft`, `approval_pending`, `in_progress`, `completed`, `dropped`,
`partial_completion`. **24 of 63 plans** use something else:

| Current value | Count | Correct value |
|---|---|---|
| `Proposed` | 13 | `completed` — each has a matching change log |
| `` `completed` `` (backticked) | 4 | `completed` |
| `Completed` (capital C) | 2 | `completed` |
| `approval_pending` (but a change log exists) | 3 | `completed` |
| `Pending Approval` / `pending approval` | 2 | `completed` — both have change logs |

One exception: `plans/20260718_185725_app-name-sreerajp-pdfapp.md` has **no** change log and was
superseded by `plans/20260818_212300_update_app_name.md`. It becomes `dropped`.

### E. Code issues

- **E1.** **13 Dart files fail `dart format`.** Engineering standard §23.1 (Definition of Done)
  requires `dart format .` to produce no follow-up changes.
- **E2.** A few user-visible strings are still raw literals, against the localization rule in
  `guideline.md` §3, `CLAUDE_MD_GUIDELINE.md`, and engineering standard §22.2:
  - `lib/features/about/presentation/about_screen.dart:37` — `Text('Version')`
  - `lib/features/extraction/presentation/widgets/extraction_dialog.dart:343-344` —
    `'PNG (Lossless)'`, `'JPEG'`
  - `lib/features/printer/presentation/widgets/n_up_dialog.dart:127-130` — `'2-in-1'`,
    `'4-in-1'`, `'6-in-1'`, `'9-in-1'`
  - `lib/features/viewer/presentation/widgets/page_jump_sheet.dart:64` —
    `helperText: '1 – ${widget.pageCount}'`

> Not an issue: `lib/main.dart:69` uses `debugPrint` only as a fallback when `AppLogger` itself
> fails, and only in non-release builds. This is deliberate and documented in the code. No change.

---

## 3. Files to be changed

**Privacy fix (A)** — rewrite every absolute `file:` URL link target as the plain repository-relative
path, and drop links that point outside the repository altogether:

- `plans/` (7 files): `20260715_153000_fix-search-bar-clutter-and-zoom.md`,
  `20260715_164843_phase3_extraction.md`, `20260718_125000_phase8_hardening_release.md`,
  `20260718_170100_fix_pinch_zoom.md`, `20260718_174600_signature_overlay_verification.md`,
  `20260718_180500_fix_signature_menu_visibility.md`, `20260719_151226_pdf_intent_filters.md`
- `change_log/` (15 files): every file matching `file:///`, found by a repo scan.

**Root instruction files (B)**

- `CLAUDE.md` — add a "Build flavors" section; fix the build commands; fix the tree; complete the
  docs table.
- `AGENTS.md` — identical changes (dual alignment, `AGENTS_MD_GUIDELINE.md` §5).
- `.agents/AGENTS.md` — identical changes, keeping its `../docs/...` link prefixes.

**Docs (C)**

- `docs/GUIDELINES_MANIFEST.md` — replace with an exact copy of
  `docs/guidelines/GUIDELINES_MANIFEST.md`.
- `docs/project_structure.md` — correct the `core/` list, add the `help/` feature, fix the root
  tree.
- `docs/feature_analysis_and_roadmap.md` — add `**Date:** 2026-08-07` (the date of its last
  content update plan) under the purpose paragraph.
- `docs/features.md` — retitle to `# Features — SreerajP PDF App`, add a one-paragraph purpose,
  add read-first links, add the `---` separator.

**Plans (D)** — normalize the `**Status:**` line in 24 files under `plans/`.

**Code (E)**

- 13 files reformatted by `dart format` (`lib/features/help/presentation/*`,
  `lib/features/settings/presentation/*`, `test/features/help/presentation/*`,
  `test/features/settings/presentation/*`, and the rest reported by the tool).
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb` — add keys: `aboutVersionLabel`,
  `imageFormatPngLossless`, `imageFormatJpeg`, `nUpPagesPerSheet` (a plural/placeholder message
  covering 2/4/6/9-in-1), `pageJumpRangeHint` (with `{min}`/`{max}` placeholders).
- `lib/features/about/presentation/about_screen.dart`
- `lib/features/extraction/presentation/widgets/extraction_dialog.dart`
- `lib/features/printer/presentation/widgets/n_up_dialog.dart`
- `lib/features/viewer/presentation/widgets/page_jump_sheet.dart`

---

## 4. Plan for the fix

1. **Scan and rewrite the privacy breach.** Run a repo-wide replace over `plans/` and
   `change_log/` turning `X` into `X`. Then re-scan for any
   remaining drive letters, `file:///`, home paths, IPs, host names, or personal email addresses.
2. **Refresh `docs/GUIDELINES_MANIFEST.md`** by copying the submodule file byte for byte.
3. **Fix `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md`** — flavors section, correct commands
   (taken from `README.md` so all three agree), corrected tree, complete docs table. Keep the
   three files in step.
4. **Fix `docs/project_structure.md`** against the real `lib/` tree.
5. **Fix `docs/feature_analysis_and_roadmap.md` and `docs/features.md`** headers per
   `DOCS_FOLDER_GUIDELINE.md` §4 and §5.
6. **Normalize plan statuses** to the six allowed values, using the table in §2 D.
7. **Run `dart format .`** to fix the 13 files.
8. **Localize the remaining literals** — add the ARB keys in both `app_en.arb` and `app_ml.arb`
   (with `@key` descriptions), run `flutter gen-l10n`, and switch the four widgets to
   `AppLocalizations`.
9. **Verify** — `flutter analyze` (expect 0 issues), `flutter test` (expect 390 pass),
   `dart format --output=none --set-exit-if-changed .` (expect no changes), and a final privacy
   re-scan of `plans/` and `change_log/`.
10. **Write the change log** to `change_log/` referencing this plan.

### What this plan does NOT do

- It does not touch anything inside `docs/guidelines/` (that is the shared submodule —
  `DOCS_FOLDER_GUIDELINE.md` §1 forbids editing it from a project).
- It does not restructure `lib/`. The Tier 2 feature-first layout already matches the standard.
- It does not rewrite the body text of old plans or change logs — only the absolute paths and
  the `Status:` lines.
- It does not add or remove any app feature.

---

## 5. Risk

Low. Every change is to documentation, plan metadata, formatting, or a string lookup. The only
runtime code changes are the four widgets moving from a hard-coded literal to an existing
localization mechanism, which is covered by the existing widget tests.
