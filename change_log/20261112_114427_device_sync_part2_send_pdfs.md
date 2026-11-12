# Device sync, Part 2: send PDFs to a nearby phone over local WiFi

Implements Part 2 of plan `plans/20261112_104132_device_sync_qr_wifi.md`, including the
2026-11-12 decision "remember the receive folder, show a Change button". Part 1 is in
`change_log/20261112_111116_device_sync_part1_settings.md`.

## What changed

### Sending (the phone that has the PDFs)

- **Home**: long-press a recent file to enter selection mode. Taps add or remove files. The app
  bar shows "N selected", a **Send to nearby phone** button and a **Cancel selection** button.
  Back leaves selection mode first. (`lib/features/viewer/presentation/home_screen.dart`)
- **Viewer menu**: new **Send to nearby phone** item for the open PDF.
  (`lib/features/viewer/presentation/viewer_screen.dart`)
- **Send PDFs screen** (`presentation/send_files_screen.dart`, route `/send-files`): copies and
  checks the files, shows the QR code and the file count, lists files that could not be read,
  then shows progress and the result ("2 of 3 PDFs arrived safely"). It stops when the app goes
  to the background, like the settings session.

### Receiving (the phone that scans)

- The receive screen is now general: `receive_settings_screen.dart` → `receive_screen.dart`,
  `ReceiveSettingsController` → `ReceiveController`, route `receiveSettings` → `receive`.
- For PDFs it lists names and sizes, the total size, and **"Saving to: <folder>"** with a
  **Change** button (or **Choose folder** the first time, or a "folder can no longer be used"
  message). Nothing is received until **Accept**. Then it shows progress, saving, and the result
  with any files that were not saved.

### Transfer (`lib/features/nearby_transfer/`)

- `domain/transfer_offer.dart`: `FileOffer` / `OfferedFile` (name, size, SHA-256); limits of
  50 files and 2 GiB per file; a bad entry refuses the whole list. `safePdfFileName()` removes
  folders, `..`, control and reserved characters, cuts long names by whole letters, and always
  ends in `.pdf`.
- `data/transfer_protocol.dart`: new `fileChunk` (raw bytes, up to 256 KiB) and `result`
  messages.
- `data/transfer_connection.dart`: flow control (pause reading at 8 waiting frames, resume at 2)
  so a large file never fills memory; `close()` / `send()` no longer throw when a session is
  stopped in the middle of writing (found by the tests, see below).
- `data/transfer_host.dart`: after Accept, streams each file in pieces, with progress events;
  a file that changed size since the offer ends the session.
- `data/transfer_guest.dart`: `receiveFiles()` writes pieces into a private cache folder and
  checks size, SHA-256 and the `%PDF-` header; failed files are deleted and reported.
- `data/file_transfer_services.dart`: `ReceiveFolderService` (remember / change / lost folder),
  `OutgoingFilesService` (cache copy + SHA-256, skips unreadable files), `ReceivedFilesStore`
  (save into the folder, add to Recents if "Remember recents" is on, delete cache copies).
- `presentation/sync_widgets.dart`: the QR code view and message widget, now shared by the
  settings and PDF screens.

### Native and platform

- New `android/app/src/main/kotlin/in/sreerajp/pdfapp/FolderSaver.kt`: keep / release / check
  folder access, and save files as **new** documents in the folder (`DocumentsContract`),
  renaming clashes to `name (2).pdf`, and deleting a half-written file on failure.
- `MainActivity.kt`: `pickFolder` (`ACTION_OPEN_DOCUMENT_TREE`, persistable read + write),
  `folderStatus`, `releaseFolder`, `saveFilesToFolder` (runs on a background thread).
- `lib/core/platform/open_document_channel.dart`: Dart side of those four methods.
- `lib/core/constants/app_constants.dart`: `prefReceiveFolderUri` (per phone, not synced).
- `lib/core/storage/cache_service.dart`: `received` added to the working folders cleaned at startup.
- `lib/core/errors/app_exception.dart`: new `TransferFailure.cannotSave`.

### Strings

- 30 new keys in `en`, `ml`, `sa`. Removed `titleReceiveSettings` and
  `descReceiveSettingsSubtitle` (replaced by `titleReceive` / `descReceiveSubtitle`).
- Updated: `descShowCodeScanPrompt`, `descDeviceSyncIntro`, `descDeviceSyncSubtitle`,
  `descPermOfflineReason`, `descPermCameraWhatItAchieves`, `errorCameraUnavailable`, so they
  mention PDFs and stay true.

### Docs

- `docs/features.md` §2.10, `docs/security.md` (new threats, what travels, folder permission
  row, export note), `CHANGELOG.md`.

## Tests

- New: `test/features/nearby_transfer/domain/transfer_offer_test.dart`,
  `test/features/nearby_transfer/data/file_transfer_session_test.dart` (3 MB file in many
  pieces, a damaged file and a non-PDF caught, decline, file that shrank),
  `test/features/nearby_transfer/data/file_transfer_services_test.dart` (folder remember /
  change / cancel / lost, prepare with skipped file, save with recents and cleanup).
- Updated: Home tests (selection mode), screen tests (new "Receive" title).
- Result: `flutter analyze` clean; `flutter test` 564 passed; the feature tests passed 8 runs
  in a row; the Sanskrit check and both CI socket checks pass.

## Different from the plan

- `lib/core/storage/app_data_purge_service.dart` was **not** changed: "Delete all data" already
  calls `releaseAllAccess()` (which also releases the folder) and clears all preferences.
- A bug found by the tests and fixed: closing a connection while a message was still being
  written threw "StreamSink is bound to a stream". In the app this could happen when a
  session is stopped mid-file.

## Not verified yet

- No Gradle build: the new Kotlin (`FolderSaver.kt`, `MainActivity.kt`) has not been compiled.
- Not tried on two real phones: folder picker, saving into SD card / Downloads, real WiFi
  speed (pure-Dart AES-GCM may be slow for very large files), and the screen turning off
  during a long transfer (the session stops when the app is hidden).

## Needs native-reader review

- Malayalam: സമീപ ഫോണിലേക്ക് അയയ്ക്കുക (Send to nearby phone), ഫോൾഡർ (folder, loanword),
  സൂക്ഷിക്കുന്നത് (Saving to), and the new progress and result texts.
- Sanskrit: समीपदूरभाषं प्रेष्यताम् (Send to nearby phone), सञ्चिकाधानी (folder), रक्षणस्थानम्
  (Saving to), स्वीकारः (Receive, title), स्वीक्रियताम् (Accept), चितानि (selected).
