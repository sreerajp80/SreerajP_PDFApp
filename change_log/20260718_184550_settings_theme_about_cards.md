# Settings page: Theme card + About card

Implements plan
[plans/20260718_184550_settings_theme_about_cards.md](../plans/20260718_184550_settings_theme_about_cards.md).

## What changed

- **New Theme page.** Added
  `lib/features/settings/presentation/theme_screen.dart` (`ThemeScreen`). The
  theme selection (the `RadioGroup` of theme modes) moved here from the Settings
  page. Its app bar title is "Theme".

- **New route.** In `lib/app/routing/app_router.dart` added `AppRoute.theme`
  (path `/theme`) and a `GoRoute` that builds `ThemeScreen`.

- **Settings page now uses cards.** In
  `lib/features/settings/presentation/settings_screen.dart`:
  - Removed the inline theme radio list.
  - Added a **Theme card** (palette icon, "Theme" title, current theme name as
    subtitle, chevron) that opens the new Theme page.
  - Added an **About card** (info icon, "About" title, chevron) that opens the
    existing About page.
  - Kept the Read aloud (Malayalam voice) switch and the Trust store row.

- **Home app bar.** In
  `lib/features/viewer/presentation/home_screen.dart` removed the About
  (info) icon, because About is now reached from Settings. The Settings icon
  stays.

## Tests

- Updated `test/features/settings/presentation/settings_screen_test.dart`: the
  first test now checks the Theme card (with its current value "System") and the
  About card are shown, and that the radio choices are no longer on the Settings
  page.
- Added `test/features/settings/presentation/theme_screen_test.dart`: checks the
  Theme page shows all choices and that tapping "Light" saves `light` to
  preferences.

## Verification

- `flutter analyze` on the changed folders: no issues.
- `flutter test` on both settings tests: all pass.

## Notes

- No new localization strings were needed; reused `settingsThemeLabel` and
  `aboutTitle`. The `openAbout` string is now unused but left in place.
