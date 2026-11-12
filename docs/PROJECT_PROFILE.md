# Project Profile — Folio

This file records the choices the shared guidelines leave open for this app: identity, platforms,
stores, languages and About-screen options. Every rule that depends on a platform, store or
language applies **only when this file declares it** (engineering standard §1.2.1). Read it before
writing code. If a value here is missing, ask the project owner — never guess.

> Read first: [../CLAUDE.md](../CLAUDE.md) and [../AGENTS.md](../AGENTS.md) for the project rules,
> and [guidelines/PROJECT_PROFILE_TEMPLATE.md](guidelines/PROJECT_PROFILE_TEMPLATE.md) for the
> template this file is filled in from.

> **Privacy:** this file is committed. It holds only public information. Never put passwords,
> keys or keystore details here.

---

## 1. Identity

| Item | Value |
|---|---|
| App display name | `Folio` (English), `ഗ്രന്ഥം` (Malayalam), `ग्रन्थः` (Sanskrit) for prod; the same name + ` Dev` for the dev flavor |
| Google Play store title | `en-IN`: `Folio: Offline PDF Reader`; `ml-IN`: `ഗ്രന്ഥം: ഓഫ്‌ലൈൻ PDF റീഡർ` (typed into Play Console; Play has no Sanskrit listing) |
| Short description (one line) | `An offline Android app for everything PDF — read, search, listen, annotate, extract, reorganize, print, and verify signatures.` |
| Organization / publisher | `Sreeraj P` |
| Reverse-DNS app id | `in.sreerajp.pdfapp` — permanent once published (dev flavor adds `.dev`) |
| Dart package name (`pubspec.yaml` `name`) | `pdfapp` |
| Public support contact | the email in `assets/config/app_config.json` (`details.email`), shown on the About screen |
| Website | `none` |
| Privacy policy URL | `none yet` — **required before the first Google Play release** |
| Copyright line | `© 2026 Sreeraj P` |
| License of the app's own code | `MIT` |

## 2. Applicability profiles (engineering standard §1.2)

- [x] `Core Baseline` (always)
- [x] `Production App Extension` — shipped to real users and stores
- [x] `Sensitive Data Extension` — the app opens private user files, handles PDF passwords and
      keeps a certificate trust store

## 3. Target platforms and distribution

Only the `android/` platform folder exists. For every ticked channel, the matching gate in
[guidelines/platform_store_readiness.md](guidelines/platform_store_readiness.md) MUST pass before
the first release to it.

| Platform | Ship? | Minimum OS | Distribution channels |
|---|---|---|---|
| Android | yes | `minSdk 26` (Android 8.0) — a hard project rule set in [pdf_idea.md](pdf_idea.md) §8; also the level the native Bouncy Castle setup in `android/app/build.gradle.kts` is checked against | Google Play (App Bundle), signed split APKs for direct download |
| iOS | no | — | — |
| Windows | no | — | — |
| macOS | no | — | — |
| Linux | no | — | — |
| Web | no | — | — |

Build flavors: `dev + prod` (engineering standard §5.1).

## 4. Languages (engineering standard §8)

| Locale | Language | Script | Role | Language pack |
|---|---|---|---|---|
| `en` | English | Latin | Template ARB, ultimate fallback | — |
| `ml` | Malayalam | Malayalam | Full UI translation | `language_packs/sanskrit_malayalam.md` |
| `sa` | Sanskrit | Devanagari | Full UI translation | `language_packs/sanskrit_malayalam.md` |

- In-app language picker: required (3 languages). Endonyms: `English`, `മലയാളം`, `संस्कृतम्`.
- Languages without a Flutter framework translation (need the fallback delegate, §8.3.1): `sa`.
- Store-listing languages: Google Play `en-IN` and `ml-IN`. Sanskrit ships inside the app only.
- Native-reader reviewer for each non-template language: a fluent Malayalam reader and a fluent
  Sanskrit reader (project owner arranges) before each release.

## 5. About screen (`guideline.md` §1)

| Item | Value |
|---|---|
| `details` rows to show | `author`, `email`, `license`, `aiUsed`, `ideUsed` (add `privacyPolicy` once the URL exists) |
| Signature badge (§1.7) | `on` — `lib/core/widgets/made_with_love.dart`, shown at the bottom of the About screen |
| Badge text — template language | `Made with {heart} from India` |
| Badge text — each other language | `ml`: `സ്നേഹത്തോടെ {heart} ഇന്ത്യയിൽ നിന്ന്` · `sa`: `सस्नेहं निर्मितम् {heart} भारततः` |
| Badge screen-reader text | `Made with love from India` / `സ്നേഹത്തോടെ ഇന്ത്യയിൽ നിന്ന്` / `सस्नेहं निर्मितम् भारततः` |

## 6. Optional project-specific values

| Item | Value |
|---|---|
| App size budget override (§10.7) | default |
| State management | Riverpod (`flutter_riverpod`) |
| Structure tier (§3.1) | Tier 2 feature-first |
| Release owner (role) | app maintainer |
