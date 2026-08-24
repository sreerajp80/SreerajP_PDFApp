# Guidelines Compliance Audit and Fixes

Implements plan [plans/20260824_220447_guidelines_compliance_audit.md](plans/20260824_220447_guidelines_compliance_audit.md).

This change brings the project structure, code, and docs in line with the shared guidelines in
`docs/guidelines/` — `guideline.md`, `CLAUDE_MD_GUIDELINE.md`, `AGENTS_MD_GUIDELINE.md`,
`DOCS_FOLDER_GUIDELINE.md`, and `flutter_project_engineering_standard.md`.

---

## 1. Privacy rule fixes in `plans/` and `change_log/`

The privacy rule (engineering standard §21.1.1) forbids absolute system paths and local machine
details in these folders, because they are committed and may become public.

- Rewrote **62 absolute `file:` URL links across 22 files** (7 in `plans/`, 15 in
  `change_log/`) as plain repository-relative paths. The links pointed at a drive letter and a
  machine-local project folder.
- Removed a "Walkthrough" link in `change_log/20260718_165100_menu_restructuring.md` that
  pointed at a local IDE working folder under a home directory. It leaked the OS user name and
  the file was never part of the repository.
- Replaced three more leaks that the first scan of the plan had not caught:
  - `plans/20260714_133333_create-claude-md.md` — a path to a sibling project on another drive
    became "the sibling TextApp project's `CLAUDE.md`".
  - `plans/20260807_074500_update_feature_analysis_roadmap.md` and
    `change_log/20260807_074600_update_feature_analysis_roadmap.md` — a path to a local index of
    other Flutter apps became a plain description.
  - `change_log/20260718_131000_phase8_hardening_release.md` — a verification command holding a
    home-directory script path became a relative command.

A repeat scan for `file:` URLs, drive paths, home paths, UNC shares, private IP addresses,
`localhost:port`, email addresses, and credential-looking assignments now reports **no findings**.

## 2. Root instruction files — `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md`

All three files got the same edits, so they stay in step (`AGENTS_MD_GUIDELINE.md` §5).

- **Added the missing "Build flavors" section.** The app declares `dev` and `prod` Gradle
  flavors, which makes this section required (`CLAUDE_MD_GUIDELINE.md` §3, row 7). It records
  the application ids, display names, signing, where the flavors are declared, how to read
  `FLUTTER_APP_FLAVOR`, and the rule against using `kDebugMode` as a stand-in for the flavor.
- **Fixed the build commands.** They previously told an agent to run bare `flutter run` and
  `flutter build apk --release`, which **fail** on a flavored project. They now pass
  `--flavor dev` / `--flavor prod`, match `README.md`, add `flutter gen-l10n`, and carry a
  callout explaining that a bare `flutter run` fails.
- **Fixed the "Where things live" tree.** It listed `assets/icons/`, which does not exist (the
  real folder is `assets/branding/`). Added the missing `assets/fonts/`, `samples/`, `tool/`,
  `AGENTS.md`, `CLAUDE.md`, `CHANGELOG.md`, `README.md`, `analysis_options.yaml`, and
  `l10n.yaml`.
- **Completed the docs table.** It listed 7 of the 12 files in `docs/`. Added rows for
  `features.md`, `pdf_idea.md`, `feature_analysis_and_roadmap.md`, `implementation_plan.md`,
  and `implementation_progress.md`.

The section order in all three files now matches the canonical order in the guidelines §2.

## 3. `docs/` folder fixes

- **`docs/GUIDELINES_MANIFEST.md`** — replaced with an exact copy of the submodule file. The
  local copy was stale and missing the `CLAUDE_MD_GUIDELINE.md`, `AGENTS_MD_GUIDELINE.md`, and
  `DOCS_FOLDER_GUIDELINE.md` rows plus the updated profile and "Where to start" sections. This
  file is copied in unchanged and never hand-edited (`DOCS_FOLDER_GUIDELINE.md` §1).
- **`docs/project_structure.md`** — the `lib/core/` listing described folders that do not exist
  (`database/`, `utils/`, `widgets/`) and omitted the six that do (`constants/`, `format/`,
  `lifecycle/`, `platform/`, `search/`, `storage/`). Corrected, added the missing `help/`
  feature, and fixed the same `assets/icons/` error in the root tree.
- **`docs/feature_analysis_and_roadmap.md`** — added the `**Date:** 2026-08-19` and `**Scope:**`
  lines required for a point-in-time document (`DOCS_FOLDER_GUIDELINE.md` §5), added read-first
  links, and made the title use the app's real name.
- **`docs/features.md`** — reshaped the header to the standard file anatomy (§4): title
  `# Features — SreerajP PDF App`, a one-paragraph purpose, read-first links, and a `---`
  separator before the first section.

Nothing inside `docs/guidelines/` was touched — it is the shared submodule and must only change
in its own repository.

## 4. Plan status hygiene

The allowed values are `draft`, `approval_pending`, `in_progress`, `completed`, `dropped`, and
`partial_completion`. **24 of 63 plans** used something else — `Proposed`, `Completed`,
`Pending Approval`, `pending approval`, or a backticked `` `completed` ``.

- 23 became `completed`; each has a matching change log confirming it was implemented.
- `plans/20260718_185725_app-name-sreerajp-pdfapp.md` became `dropped`. It has no change log and
  was superseded by `plans/20260818_212300_update_app_name.md`. A short note in the file records
  why.

All plans now use one of the six allowed values.

## 5. Code fixes

- **Formatting.** 13 files failed `dart format` (help and settings screens plus their tests),
  against the Definition of Done (§23.1). Ran `dart format .`; the check is now clean.
- **Localization.** Four widgets still held raw user-visible strings. Added five keys to
  `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb` (each with an `@key` description), ran
  `flutter gen-l10n`, and switched the widgets to `AppLocalizations`:

  | New key | Replaces |
  |---|---|
  | `aboutVersionLabel` | `Text('Version')` in `about_screen.dart` |
  | `imageFormatPngLossless`, `imageFormatJpeg` | `'PNG (Lossless)'` / `'JPEG'` in `extraction_dialog.dart` |
  | `nUpPagesPerSheet` | the four `'2-in-1'`…`'9-in-1'` labels in `n_up_dialog.dart` |
  | `pageJumpRangeHint` | `helperText: '1 – ${widget.pageCount}'` in `page_jump_sheet.dart` |

  The N-up labels also collapsed from four hard-coded segments into one loop over
  `[2, 4, 6, 9]`.

`lib/main.dart` was left alone: its `debugPrint` runs only as a fallback when `AppLogger` itself
throws, and only outside release builds. That is deliberate and documented in the code.

---

## 6. Verification

| Check | Result |
|---|---|
| `flutter analyze` | No issues found |
| `flutter test` | 390 tests, all passed |
| `dart format --output=none --set-exit-if-changed .` | 202 files, 0 changed |
| ARB parity | 651 keys in English, 651 in Malayalam, every English key has an `@key` description |
| Privacy re-scan of `plans/` + `change_log/` | No findings |
| Relative links in root files and `docs/` | 0 broken |
| Plan statuses | 62 `completed`, 1 `dropped`, 1 `in_progress` (this plan) — all allowed values |

## 7. What was deliberately not changed

- `docs/guidelines/` (shared submodule — read-only from this project).
- The `lib/` layout. The Tier 2 feature-first structure already matches the standard.
- The body text of older plans and change logs. Only the leaked paths and the `Status:` lines
  were edited.
- App features and behaviour. The only runtime change is four widgets reading their text from
  `AppLocalizations` instead of a literal.

## 8. Known minor item left open

`lib/features/about/presentation/about_screen.dart` builds its version row subtitle as
`'${config.version} (build ${config.build})'`. The word "build" is an English literal inside an
otherwise data-driven string. It was outside the approved plan's scope, so it was left as is and
is recorded here.
