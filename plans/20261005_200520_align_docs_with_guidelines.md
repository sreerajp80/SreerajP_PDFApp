# Plan — Align project documents with the shared guidelines

**Status:** completed

---

## 1. What the issue is

The shared guidelines in `docs/guidelines/` were updated (see
`plans/20261005_195627_update_guidelines_submodule.md`). The project's own documents now fall
short of them in several places. I compared every project doc with these guideline files:

- `docs/guidelines/AI_AGENT_START_HERE.md`
- `docs/guidelines/GUIDELINES_MANIFEST.md`
- `docs/guidelines/DOCS_FOLDER_GUIDELINE.md`
- `docs/guidelines/CLAUDE_MD_GUIDELINE.md` and `docs/guidelines/AGENTS_MD_GUIDELINE.md`
- `docs/guidelines/PROJECT_PROFILE_TEMPLATE.md` (+ `profiles/example_en_ml_sa_profile.md`)
- the templates `docs/guidelines/architecture.md`, `security.md`, `release_process.md`
- `docs/guidelines/language_packs/sanskrit_malayalam.md`

### 1.1 Gaps found

| # | Gap | Guideline rule |
|---|---|---|
| G1 | `docs/GUIDELINES_MANIFEST.md` is an old copy. It differs from the submodule copy (no profile step, no templates-vs-references note, no `AI_AGENT_START_HERE.md`, no store readiness, no language packs). | DOCS_FOLDER §1: copied in **unchanged** |
| G2 | `docs/PROJECT_PROFILE.md` does not exist. It is the first of the 9 mandatory baseline docs. | DOCS_FOLDER §6.1, AI_AGENT_START_HERE §4.2 |
| G3 | `CLAUDE.md` identity table has no **Stores / channels** and no **Languages** row; Flutter/Dart rows say "or higher" instead of the pinned version. | CLAUDE_MD §4 template, §8 self-check |
| G4 | `CLAUDE.md` "Read these docs" table is missing `docs/PROJECT_PROFILE.md`, `docs/guidelines/AI_AGENT_START_HERE.md`, `guideline.md`, `flutter_project_engineering_standard.md`, `flutter_build_flavors_guide.md`, `platform_store_readiness.md`, and the `sanskrit_malayalam.md` language pack. | CLAUDE_MD §4 |
| G5 | `CLAUDE.md` localization rules are missing: declared languages by name, key parity + real translations, `@key` descriptions, language pack in force, fallback delegate for `sa`, `formattingLocale(...)`, in-app language picker, short-label rule, tooltip rule, `material_ui` import rule, About-screen rule (badge off). | CLAUDE_MD §4 + §8 self-check |
| G6 | `CLAUDE.md` signing section lists `build/symbols/` instead of `build/`; release build commands use `build/symbols/android-prod/` instead of a per-version folder `android-prod-<version>/`; no pointer to `platform_store_readiness.md`. | CLAUDE_MD §4 |
| G7 | `AGENTS.md` and `.agents/AGENTS.md` have the same gaps (G3–G6). They must match `CLAUDE.md` exactly. | AGENTS_MD §5 |
| G8 | Every `docs/` file links "up" to `../.agents/AGENTS.md` first. The rule is to link to `../CLAUDE.md` and `../AGENTS.md`. | DOCS_FOLDER §4.3, §9 |
| G9 | Point-in-time docs put the `**Date:**` line **above** the purpose paragraph (`implementation_plan.md`, `implementation_progress.md`, `feature_analysis_and_roadmap.md`). It must come right **under** it. `implementation_plan.md` has no "Read first" block. | DOCS_FOLDER §4, §5 |
| G10 | `docs/security.md` covers only 7 of the 18 template sections. The app handles PDF passwords, private user files and a trust store, so the Sensitive Data Extension applies and the file must be **full**. Missing: authentication/access, binary protections, logging & telemetry policy, platform security controls (`allowBackup`), permissions, OWASP Mobile Top 10, **data retention & purge (§13)**, backup/import/export, security testing, incident response, open risks, review checklist. | security template; DOCS_FOLDER §6 |
| G11 | `docs/release_process.md` covers only 5 of the template sections. The Production App Extension applies, so it must be **full** (Android only). Missing: **§1 Release Scope**, roles, versioning policy, branch/merge policy, environment & flavor matrix, hardening checks, release checklist (§8), Android release steps (§9), distribution channels (Google Play + direct APK), rollback & hotfix, release evidence, post-release checks, and the store gate from `platform_store_readiness.md`. | release template; AI_AGENT_START_HERE §5 |
| G12 | `docs/architecture.md` uses its own 16-section order. Missing template sections: app lifecycle, offline behavior, state management, data flow, domain model, dependency injection, navigation, environment & build model, decisions & tradeoffs, related documents. | architecture template |
| G13 | `docs/architecture.md`, `security.md`, `implementation_plan.md` say "**selected** Sensitive Data controls". With G10 this becomes "Sensitive Data Extension in force". | engineering standard §1.2 |

### 1.2 Code gaps found while checking (NOT fixed by this plan)

These are code problems, not doc problems. The docs will record them honestly as open items
(in `security.md` §17 / `architecture.md` "Known risks"). Each one needs its own plan later.

1. `AndroidManifest.xml` does not set `android:allowBackup`, so Android's default (`true`) applies.
   The security template expects an explicit, documented choice.
2. The code imports `package:flutter/material.dart` (72 files), not `package:material_ui/...`
   (engineering standard §6.1).
3. `lib/features/settings/presentation/features_screen.dart` has raw English string literals in
   widgets (localization rule).
4. No CI workflow (`.github/workflows/`) exists (engineering standard §19).

---

## 2. Decisions from the user (2026-10-05)

- Distribution channels: **Google Play** and **direct APK**.
- Public contact: the email already shown in the About screen. Website and privacy policy:
  "none yet" (a privacy policy URL is required before the first Google Play release — this will be
  recorded as an open gate).
- License of the app's own code: **MIT**.
- Templates: re-shape `architecture.md`, `security.md`, `release_process.md` to the **full
  template order**, keeping all existing content.

Values taken from the code: app name, `in.sreerajp.pdfapp`, `pdfapp` package name, Android only,
minSdk 26, flavors dev + prod, languages `en` / `ml` / `sa`, language pack `sanskrit_malayalam.md`,
`sa` fallback delegates present, Riverpod, Tier 2 feature-first, About signature badge **off** (not
in `app_config.json`), Flutter 3.47.6 (from `flutter --version`).

---

## 3. Files to change

| File | Action |
|---|---|
| `docs/GUIDELINES_MANIFEST.md` | Replace with an unchanged copy of `docs/guidelines/GUIDELINES_MANIFEST.md` (G1) |
| `docs/PROJECT_PROFILE.md` | **Create** from `PROJECT_PROFILE_TEMPLATE.md` (G2) |
| `CLAUDE.md` | Update identity, docs table, localization, signing, build commands (G3–G6) |
| `AGENTS.md` | Same updates as `CLAUDE.md`, AI-agent wording (G7) |
| `.agents/AGENTS.md` | Same as `AGENTS.md`, with `../` link prefixes (G7) |
| `docs/security.md` | Re-shape to full 18-section template (G10, G13) |
| `docs/release_process.md` | Re-shape to full template, Android only (G11) |
| `docs/architecture.md` | Re-shape to the 22-section template order (G12, G13) |
| `docs/implementation_plan.md` | Move `**Date:**` under purpose, add "Read first", fix profile wording (G9, G13) |
| `docs/implementation_progress.md` | Move `**Date:**` under purpose, fix "Read first" links (G8, G9) |
| `docs/feature_analysis_and_roadmap.md` | Move `**Date:**` under purpose, fix links (G8, G9) |
| `docs/features.md`, `docs/pdf_idea.md`, `docs/dependencies.md`, `docs/project_structure.md`, `docs/workflow_rules.md` | Fix "Read first" links (G8); add `PROJECT_PROFILE.md` to `project_structure.md` tree |
| `change_log/<timestamp>_align_docs_with_guidelines.md` | **Create** after the work |

Not touched: `docs/guidelines/` (submodule — never edited from the project), any `lib/`,
`android/` or `test/` file, `README.md`, `CHANGELOG.md`.

---

## 4. The fix, step by step

1. **Manifest (G1).** Copy `docs/guidelines/GUIDELINES_MANIFEST.md` over `docs/GUIDELINES_MANIFEST.md`
   byte-for-byte.
2. **Profile (G2).** Create `docs/PROJECT_PROFILE.md` with the six template sections filled in from
   §2 above. Profiles ticked: Core Baseline, Production App Extension, Sensitive Data Extension.
   Platforms: Android only (minSdk 26 with its reason). Languages table with `en` / `ml` / `sa`,
   picker required, fallback needed for `sa`, reviewer role "native-reader reviewer (project
   owner)". About: rows author / email / license / aiUsed / ideUsed, badge off.
3. **CLAUDE.md / AGENTS.md / .agents/AGENTS.md (G3–G7).** Keep the Thin style and the canonical
   section order. Edit only the gaps listed: add identity rows, extend the docs table, extend
   localization rules, fix signing and symbols paths, add the store-readiness pointer. Then make
   the three files say the same thing (only "Claude" vs "AI agents" wording and link prefixes differ).
4. **Read-first links (G8).** In every project doc, change
   `[../.agents/AGENTS.md](../.agents/AGENTS.md) (or [../CLAUDE.md](../CLAUDE.md))` to
   `[../CLAUDE.md](../CLAUDE.md) and [../AGENTS.md](../AGENTS.md)`.
5. **Point-in-time docs (G9).** Order: title → purpose paragraph → `**Date:**` (+ `**Scope:**` /
   `**Status:**`) → "Read first" → `---`. No other content change.
6. **security.md (G10, G13).** Use the template's 18 numbered sections. Move existing text into the
   matching section. Fill new sections only with facts that are true today (taken from the
   manifest, `lib/core/logging/`, the password handling, cache clean-up and trust store code).
   Where something is not done yet (e.g. explicit `allowBackup`), say so plainly and list it in
   §17 Open Risks.
7. **release_process.md (G11).** Use the template sections §1–§9 and §12–§15; drop iOS / Windows /
   macOS / Linux (not declared). Keep the existing keystore, build and verify commands (PowerShell
   + bash). Use `build/symbols/android-prod-<version>/`. Add the Google Play gate and the
   "privacy policy URL needed before first Play release" item.
8. **architecture.md (G12, G13).** Re-order into the template's 22 sections. Existing text moves,
   not rewritten. New sections (lifecycle, offline, state, data flow, domain model, DI,
   navigation, build model, decisions, related docs) are filled from the actual code in `lib/`.
9. **Check.** Re-run the DOCS_FOLDER §10, CLAUDE_MD §8 and AGENTS_MD §9 checklists. Check every
   relative link resolves to a real file. Grep `plans/` and the new change log for absolute paths
   or local details.
10. **Change log.** Write `change_log/<timestamp>_align_docs_with_guidelines.md` and set this plan to
    `completed`.

No code changes, so `flutter analyze` / `flutter test` are not affected; I will still run
`flutter analyze` once as a sanity check.

---

## 5. Risks

- The three re-shaped docs are large. Moving text between sections could drop a detail. I will
  diff old vs new section by section to be sure nothing is lost.
- Some `docs/` files are linked from `README.md` by section number. I will grep for `#` anchors
  and section-number references and fix any that break.
