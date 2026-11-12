# Play Console closed testing: documents, graphics and README

**Status:** partial_completion

**Date:** 2026-11-12
**Version this is for:** 2.8.1 (28), from `pubspec.yaml`
**Modelled on:** the Gallery app (`play_closed_testing/`, `PRIVACY.md`, README refresh) and the
QR Forge app (`play_store_private/`, `docs/graphics/`)

---

## 1. The issue

We want to upload Folio to Google Play Console for **closed testing**. Today the project has:

| Needed by Play | State now |
|---|---|
| Public privacy policy URL | **None.** `docs/PROJECT_PROFILE.md` §1 says "none yet" |
| Answers for App content, Data safety, content rating | None written |
| Store listing text (`en-IN`, `ml-IN`) and release notes | None written |
| Store icon 512 × 512 | Not made. The source `assets/branding/ic_launcher_1024.png` exists |
| Feature graphic 1024 × 500 | None |
| Phone screenshots (2–8) | `docs/screenshots/` has 6, but they are **1344 × 2992**. Play refuses a screenshot whose long side is more than twice the short side (2992 / 1344 = 2.23). They must be retaken |
| App Bundle (`.aab`) | Not built. Only split APKs exist in `build/` |

The GitHub `README.md` points at the old screenshots and has no feature graphic.

Two small mistakes in `docs/release_process.md`:

- §15 still says language splitting is "Not set yet", but `android/app/build.gradle.kts` already
  has `enableSplit = false` (and §16 marks it done).
- §15 lists `en-US`; the project profile says the listing languages are `en-IN` and `ml-IN`.

## 2. Layout — one place for images, one private place for answers

Same as QR Forge:

```
docs/graphics/                        committed, used by README.md AND uploaded to Play
  app_icon_512.png
  feature_graphic_1024x500.png
  screenshots/en/01_….png … 08_….png  English set (1080 × 1920)
  screenshots/ml/01_….png …           Malayalam set, for the ml-IN listing
play_store_private/                   gitignored, never committed
  PUBLISHING_GUIDE.md
  store_listing.md
  data_safety_answers.md
  app_content_answers.md
  PRODUCTION_ACCESS_APPLICATION.md
  SUBMISSION_RECORD.md
  screenshots/raw/                    raw captures, not uploaded
PRIVACY.md                            committed, linked from Play by its GitHub URL
```

The old `docs/screenshots/` folder is removed after the new set is in `docs/graphics/`, so there
is only one copy of each image.

## 3. Files to be created or changed

| File | Action | What |
|---|---|---|
| `PRIVACY.md` | New | Privacy policy (see §4.1) |
| `docs/graphics/**` | New | Icon, feature graphic, English and Malayalam screenshots |
| `docs/screenshots/*.png` (6 files) | Delete | Replaced by `docs/graphics/screenshots/en/` |
| `play_store_private/PUBLISHING_GUIDE.md` | New | Step 0 (before Play Console) to Step 6 (road to production), screenshot order, common problems |
| `play_store_private/store_listing.md` | New | Store settings; `en-IN` and `ml-IN` name, short and full description; graphics rules; release notes |
| `play_store_private/data_safety_answers.md` | New | Data safety form, reasons, Advertising ID |
| `play_store_private/app_content_answers.md` | New | App access, ads, content rating, target audience, camera / Device sync notes, government, financial, health, news, EU trader status |
| `play_store_private/PRODUCTION_ACCESS_APPLICATION.md` | New | Draft parts of the "Apply for production" form; the test-result parts left for real answers |
| `play_store_private/SUBMISSION_RECORD.md` | New | Empty record to fill in as you go |
| `.gitignore` | Change | Add `play_store_private/` |
| `README.md` | Rewrite | See §4.4 |
| `docs/release_process.md` | Change | Fix the two stale lines in §15; point to `play_store_private/PUBLISHING_GUIDE.md` and `PRIVACY.md` |
| `docs/PROJECT_PROFILE.md` | Change | Privacy policy URL (after it is confirmed reachable) |
| `change_log/<timestamp>_play_closed_testing_docs.md` | New | Change log |

No Dart, Kotlin, manifest, ARB or submodule file is changed.

## 4. How I will do it

### 4.1 Privacy policy (`PRIVACY.md`)

Facts checked in the code first (`lib/features/nearby_transfer/data/`, manifest, TTS, backup
rules, `docs/security.md`):

- No data collected by the developer. No analytics, no ads, no crash reporting, no accounts.
- Files stay on the phone; opened only through the system file picker or "Open with".
- Device sync: only to the user's own second phone on the local Wi-Fi, paired by QR code,
  encrypted with a one-time key, only while that screen is open. No internet server.
- Camera: only to scan the pairing QR code. Frames are not stored.
- Read aloud uses the phone's own text-to-speech engine.
- PDF passwords stay in memory only.
- Contact: the public support email already shown on the About screen.

### 4.2 Play answers (`play_store_private/`)

- Same shape and wording style as the Gallery files, with Folio facts.
- **Data safety:** "No data collected or shared". Device sync is the one point to explain: data
  leaves the phone, but encrypted, by user action, to the user's own device, never to the
  developer. I will check Google's current Data safety help page and write the date read.
- **Content rating, "users can exchange content":** a judgment call because of Device sync;
  both answers and my recommendation will be written down (the Gallery had the same question).
- **Closed testing rule** (12 testers, 14 days in a row, for new personal accounts): re-check
  Google's help page and write the date read.
- Listing text from `docs/features.md` only — no "best", "free", emoji or claims we cannot prove.
- Malayalam listing marked **DRAFT** for your check.

### 4.3 Graphics (`docs/graphics/`)

- **Icon:** resize `assets/branding/ic_launcher_1024.png` to 512 × 512 (Python Pillow, script in
  the session scratch folder, not in the repo).
- **Sample PDFs:** made up by a script — a short English article, a Malayalam text page, a small
  multi-page document, and a self-signed test PDF for the signature screen. No real documents and
  no personal data. (The existing `samples/` PDF is not used, to avoid any copyright question.)
- **Device:** an Android emulator with the prod 2.8.1 (28) `x86_64` release APK
  (`build/app/outputs/flutter-apk/`). Screen set to 1080 × 1920 and status-bar demo mode on for
  the capture; both reset at the end. I drive it with `adb` and show you each capture.
- **Screenshots (up to 8), English first:** home / recent files, reader, search (Malayalam
  sandhi), read aloud, annotations, organise pages, signature check, and languages or Device sync.
  Final list fixed against what the app really shows. Then the same set in Malayalam.
- **Feature graphic:** 1024 × 500, no transparency: icon, "Folio", one short line, and one
  screenshot. Drawn with Pillow.
- Every image is checked for size, no alpha in the feature graphic, and no device name, IP
  address or real data.

### 4.4 README (`README.md`)

Like the Gallery README: feature graphic banner at the top, short description and badges, "Why
this app", screenshots table from `docs/graphics/screenshots/en/`, features (checked against
`docs/features.md`), availability (Play closed testing, split APKs), privacy and permissions
(INTERNET and CAMERA only for Device sync), developer sections kept with facts checked, docs
table with `PRIVACY.md`, licence. All paths relative. I will preview it as rendered Markdown.

## 5. Open points (your answer needed)

1. **Is the GitHub repo `sreerajp80/SreerajP_PDFApp` public?** The privacy link and the README
   images work only if it is. `PRIVACY.md`, `docs/graphics/` and `README.md` must also be
   committed and pushed — that is your step.
2. **Emulator:** `adb` sees three devices, which look like real phones. I need an emulator (or a
   phone you are happy to change screen size on, with no private files visible). Which one?
3. The About-screen privacy link (`privacyPolicy` row) is a code + ARB change, so it gets its
   own plan after the URL works.

## 6. Not in this plan

- Building the `.aab` — the guide gives the command; you run it.
- Committing and pushing.
- Tablet screenshots (only needed if we choose to target tablets in the listing).

## 7. Security impact

None on the app. Docs and images only. The Play answers stay in a gitignored folder. Images use
made-up PDFs only and must show no device details. Answers and `PRIVACY.md` must match the real
behaviour of Device sync and the camera.

## 8. Checks

- Every listing claim matches a real feature.
- `PRIVACY.md`, Data safety and app content answers agree with each other and `docs/security.md`.
- Limits: name ≤ 30, short description ≤ 80, full description ≤ 4000, release notes ≤ 500.
- Screenshots 1080 × 1920; icon 512 × 512; feature graphic 1024 × 500, no alpha.
- Every README image and link points to a file that exists.
- `git status` shows `play_store_private/` as ignored.
