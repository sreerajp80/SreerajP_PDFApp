# Change log: strict guideline compliance (after the October 2026 guidelines update)

Implements: `plans/20261107_171722_strict_guideline_compliance.md`

## What changed

| # | File(s) | Change |
|---|---|---|
| 1 | `.github/workflows/ci.yml` | Removed the `android` job (release App Bundle build, symbols upload, size build). CI now runs checks only (engineering standard §19.3). Header comment updated. |
| 2 | `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md` | Added workflow rule 4 (guidelines submodule is read-only) and rule 5 (CI is checks only); the "Security impact" sentence in rule 1; two Security Baseline lines (§15.1, never weaken a control; no secrets in code/assets/`--dart-define`). The three files stay in sync. |
| 3 | `android/app/src/main/res/values/strings.xml` | Added `app_name` = "SreerajP PDF App". |
| 3 | New `android/app/src/main/res/values-ml/strings.xml`, `values-sa/strings.xml` | `app_name` in Malayalam and Sanskrit, the same text as `appName` in `app_config.json` (guideline.md §1.8). |
| 3 | New `android/app/src/dev/res/values/`, `values-ml/`, `values-sa/` `strings.xml` | Dev flavor `app_name` = the name + " Dev". |
| 3 | `android/app/src/main/AndroidManifest.xml`, `android/app/build.gradle.kts` | Label is now `@string/app_name`; the two `manifestPlaceholders["appLabel"]` literals were removed. |
| 3 | `lib/app/config/app_flavor_config.dart`, `test/app/config/app_flavor_config_test.dart` | `appName` (a literal, unused) replaced by `nameSuffix` (`' Dev'` / `''`). |
| 4 | `assets/config/app_config.json` | `appName.en` "Sreeraj P PDF App" → "SreerajP PDF App", so it matches the launcher, the profile and `CLAUDE.md`. |
| 5 | `lib/core/format/display_format.dart`, `test/core/format/display_format_test.dart` | `formattingLocale` now tries `Intl.canonicalizedLocale(name)`, then the language code, then `en` (standard §8.3.2). New tests: `en-US`, `en_US`, `ml_ZZ`, `sa-IN`, empty and malformed names. |
| 6 | `.gitignore` | Ignores `.env` and `.env.*` (standard §20.4). |

## Change from the plan

- **Print-service strings were not translated** (plan issue 3c). 18 Malayalam and Sanskrit help
  texts in `app_ml.arb` / `app_sa.arb` tell the user to pick "SreerajP PDF App" as the printer.
  Translating only the printer name would make that help wrong. This needs one change that
  updates the print strings and those help texts together — follow-up.

## Checks

- `dart format .` — 0 files changed.
- `flutter analyze` — no issues.
- `flutter test` — all 452 tests passed.
- **Not done yet:** a device build and a check of the launcher name in all three languages
  (handed to the user). The toolchain plan
  (`plans/20261107_171200_toolchain_upgrade_agp9_gradle9.md`) is still open, so the first build
  tests both changes.

## Needs native-reader review

- Malayalam launcher name `ശ്രീരാജ് പി പിഡിഎഫ് ആപ്പ്` and Sanskrit `श्रीराज पी पीडीएफ अनुप्रयोगः`
  (copied from `app_config.json`). The Sanskrit name has `श्रीराज` without a virama, while the
  About author row uses `श्रीराज्`; please confirm which is meant.
- The dev suffix stays the Latin word "Dev" in all languages (a developer-only marker).

## Still open (not in this plan)

- `plans/20261107_170947_security_baseline_and_kotlin_review.md` — still `draft`.
- Privacy policy URL — required before the first Google Play release (`docs/PROJECT_PROFILE.md`).
- `docs/workflow_rules.md` may also need the new workflow rules 4 and 5.
