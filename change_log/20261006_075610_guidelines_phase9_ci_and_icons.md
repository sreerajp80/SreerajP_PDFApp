# Change log — Guidelines Phase 9: CI and launcher icons

Implements Phase 9 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(findings S3, S4).

## What changed

### CI (engineering standard §19.1, §19.2)
- New `.github/workflows/ci.yml`, run on pushes to `master` and on pull requests:
  - **checks** job: `flutter pub get`; generated localizations must match the ARB files
    (`flutter gen-l10n` + `git diff --exit-code lib/l10n`); `dart format --set-exit-if-changed`;
    `flutter analyze`; `flutter test`; the Sanskrit Hindi-marker gate copied from language pack
    §4.1 (with its self-test); and a check that the main manifest has no `INTERNET` permission
    (project rule 2).
  - **android** job (after checks): Java 17, then `flutter build appbundle --flavor prod
    --release --obfuscate --split-debug-info=build/symbols/android-prod-<version>/`. The debug
    symbols are kept as a build artifact. A separate arm64 build prints the `--analyze-size`
    report (§10.7) — Flutter refuses `--analyze-size` together with `--split-debug-info`, so they
    cannot be one build.
  - Flutter is pinned to 3.47.6 (the project's version). No signing material is used: without
    `android/key.properties` the Gradle file signs the check build with the debug key.
- Checked locally: the workflow file parses as valid YAML (2 jobs). It has not run on GitHub yet.
- Note: the Sanskrit gate will fail until Phase 10 rewords the 5 strings it flags.

### Launcher icons (§17.5)
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` — new `<monochrome>` layer for
  Android 13+ themed icons. It reuses the foreground image, whose transparent background makes a
  clean mask.
- New `tool/generate_dev_icon.ps1` and its output `android/app/src/dev/res/mipmap-*/`
  (`ic_launcher.png`, `ic_launcher_foreground.png`, 5 densities): the normal icon with an amber
  "DEV" banner, so a dev build is never mistaken for production. On the adaptive foreground the
  banner stays inside the safe zone.

### Docs
- `README.md` (testing section), `docs/release_process.md` (required checks; checklist items for
  CI and language splitting now ticked), `docs/security.md` §17, `docs/architecture.md` §21.

## Tests

- `flutter build apk --flavor dev --debug`: built with the dev icons and the monochrome layer.
- No Dart code changed in this phase.

## To verify on a device

- Install the dev and prod builds side by side: the dev icon shows the "DEV" banner.
- Android 13+: turn on themed icons; the app icon follows the wallpaper colors.
- First CI run on GitHub: both jobs pass (after Phase 10).
