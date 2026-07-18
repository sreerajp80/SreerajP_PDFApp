# Settings page: Theme card + About card

**Status:** completed

## What the user asked

1. On the **Settings** page, make **Theme** a card. Tapping the card opens a
   new **Theme** page where the theme is chosen.
2. Move **About** into the **Settings** page as an **About card**. Tapping it
   opens the existing About page.

## The issue / current state

- [settings_screen.dart](../lib/features/settings/presentation/settings_screen.dart)
  shows the theme choices inline as a `RadioGroup` of `RadioListTile`s. There is
  no separate Theme page.
- The **About** page is reached only from an info icon in the **Home** app bar
  ([home_screen.dart](../lib/features/viewer/presentation/home_screen.dart) lines
  134-138). It is not reachable from Settings.

## Plan for the change

### 1. New Theme page
- Create `lib/features/settings/presentation/theme_screen.dart`
  (`ThemeScreen`, a `ConsumerWidget`).
- Move the theme selection (`RadioGroup` + one `RadioListTile` per
  `AppThemeMode`) out of Settings and into this page.
- App bar title uses the existing `settingsThemeLabel` ("Theme").

### 2. Route for the Theme page
- In [app_router.dart](../lib/app/routing/app_router.dart):
  - Add `theme` to the `AppRoute` enum.
  - Add its path `'/theme'` in `AppRoutePath`.
  - Add a `GoRoute` that builds `const ThemeScreen()`.

### 3. Settings page becomes cards
- In [settings_screen.dart](../lib/features/settings/presentation/settings_screen.dart):
  - Remove the inline theme `RadioGroup` block.
  - Add a **Theme card** (`Card` wrapping a `ListTile`): palette icon, title
    "Theme" (`settingsThemeLabel`), subtitle = the current theme's label
    (System / Light / Dark / Sepia), trailing chevron, `onTap` pushes the new
    `theme` route.
  - Keep the **Read aloud** section (Malayalam voice switch) as it is.
  - Keep the **Trust store** list tile as it is.
  - Add an **About card** (`Card` wrapping a `ListTile`): info icon, title
    "About" (`aboutTitle`), trailing chevron, `onTap` pushes the `about` route.

### 4. Home app bar
- In [home_screen.dart](../lib/features/viewer/presentation/home_screen.dart):
  remove the About (`info_outline`) `IconButton`, since About now lives inside
  Settings. Keep the Settings icon.

### 5. Localization
- No new user-facing strings are strictly needed; reuse `settingsThemeLabel`
  and `aboutTitle`. (The now-unused `openAbout` key is left in place to avoid
  churn.)

### 6. Tests
- Update
  [settings_screen_test.dart](../test/features/settings/presentation/settings_screen_test.dart):
  the theme radio choices are no longer on the Settings page. Change the first
  test to check the Settings page shows the **Theme** card (and its current
  value) and the **About** card, instead of the radio options. The
  theme-change test moves to a new theme-page test.
- Add `test/features/settings/presentation/theme_screen_test.dart` that pumps
  `ThemeScreen` and checks tapping "Light" saves `light` to preferences.

## Files to change
- `lib/features/settings/presentation/theme_screen.dart` (new)
- `lib/features/settings/presentation/settings_screen.dart`
- `lib/app/routing/app_router.dart`
- `lib/features/viewer/presentation/home_screen.dart`
- `test/features/settings/presentation/settings_screen_test.dart`
- `test/features/settings/presentation/theme_screen_test.dart` (new)

## Out of scope
- No change to the About page content or its config-driven data.
- No visual redesign of the TTS or Trust store rows beyond what is above.
