// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PDF App';

  @override
  String get homeTitle => 'PDF App';

  @override
  String get homeEmptyMessage =>
      'No PDF open yet. Opening files comes in the next phase.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSepia => 'Sepia';

  @override
  String get aboutTitle => 'About';

  @override
  String get openSettings => 'Settings';

  @override
  String get openAbout => 'About';

  @override
  String get openPdf => 'Open PDF';

  @override
  String get recentFilesTitle => 'Recent files';

  @override
  String get noRecentFiles =>
      'No recent files yet. Tap \"Open PDF\" to read one.';

  @override
  String get removeFromRecents => 'Remove';

  @override
  String get openFailed => 'Could not open the file.';

  @override
  String get reopenFailed =>
      'This file could not be reopened. It may have been moved or deleted.';

  @override
  String pagesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get viewModeContinuous => 'Continuous';

  @override
  String get viewModeSingle => 'Single page';

  @override
  String get viewModeBook => 'Two pages';

  @override
  String get viewModeTooltip => 'View mode';

  @override
  String get fitWidth => 'Fit width';

  @override
  String get fitPage => 'Fit page';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get resetZoom => 'Reset zoom';

  @override
  String get invertColors => 'Night colors';

  @override
  String get contentsTitle => 'Contents';

  @override
  String get noOutline => 'This PDF has no contents.';

  @override
  String get thumbnailsTitle => 'Pages';

  @override
  String get goToPage => 'Go to page';

  @override
  String pageOfPages(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get pageNumberHint => 'Page number';

  @override
  String get goAction => 'Go';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get passwordTitle => 'Password required';

  @override
  String get passwordMessage =>
      'This PDF is protected. Enter its password to read it.';

  @override
  String get passwordHint => 'Password';

  @override
  String get unlockAction => 'Unlock';

  @override
  String get tryAgainAction => 'Try again';

  @override
  String get errorCorruptTitle => 'Can\'t open this PDF';

  @override
  String get errorCorruptBody =>
      'The file seems damaged or is not a valid PDF.';

  @override
  String get errorEmptyTitle => 'Nothing to show';

  @override
  String get errorEmptyBody => 'This PDF is empty — it has no pages.';

  @override
  String get errorPasswordTitle => 'Locked PDF';

  @override
  String get errorPasswordBody =>
      'This PDF is password protected. Enter the password to read it.';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericBody => 'This PDF could not be opened.';

  @override
  String get largeFileWarning =>
      'This is a large PDF, so it opens one page at a time for smoother reading.';

  @override
  String get loadingPdf => 'Opening…';

  @override
  String get yes => 'Yes';

  @override
  String get metadataTitle => 'Details';

  @override
  String get metadataAction => 'Details';

  @override
  String get metadataFileSection => 'File';

  @override
  String get metadataFileName => 'Name';

  @override
  String get metadataFileSize => 'Size';

  @override
  String get metadataPdfSection => 'PDF details';

  @override
  String get metadataUnavailable => 'These details could not be read.';

  @override
  String get metadataNoFields => 'This PDF does not describe itself.';

  @override
  String get metadataTitleField => 'Title';

  @override
  String get metadataAuthor => 'Author';

  @override
  String get metadataSubject => 'Subject';

  @override
  String get metadataKeywords => 'Keywords';

  @override
  String get metadataCreator => 'Made with';

  @override
  String get metadataProducer => 'Saved by';

  @override
  String get metadataCreated => 'Created';

  @override
  String get metadataModified => 'Changed';

  @override
  String get metadataPages => 'Pages';

  @override
  String get metadataPdfVersion => 'PDF version';

  @override
  String get metadataProtected => 'Password protected';

  @override
  String get searchAction => 'Search';

  @override
  String get searchHint => 'Search in this PDF';

  @override
  String get searchClose => 'Close search';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchNextMatch => 'Next match';

  @override
  String get searchPreviousMatch => 'Previous match';

  @override
  String get searchSearching => 'Searching…';

  @override
  String get searchNoMatches => 'No matches';

  @override
  String searchMatchOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String searchLimitReached(int count) {
    return 'Showing the first $count matches. Try a longer word.';
  }

  @override
  String get searchOptionsTooltip => 'Search options';

  @override
  String get searchOptionStrict => 'Exact spelling';

  @override
  String get searchOptionStrictNote =>
      'Tell joined and unjoined spellings apart';

  @override
  String get searchOptionIgnoreAccents => 'Ignore accent marks';

  @override
  String get searchOptionIgnoreAccentsNote =>
      'Useful for Sanskrit chant accents';

  @override
  String get noTextTitle => 'No selectable text';

  @override
  String get noTextBody =>
      'This PDF has no text layer, so it looks scanned. Search, copy, and read aloud are not available. This app does not read text from pictures.';

  @override
  String get garbledTextTitle => 'Text cannot be read properly';

  @override
  String get garbledTextBody =>
      'This PDF\'s fonts do not say which letters they show, so search and read aloud would give wrong results. Reading the pages still works.';

  @override
  String get searchUnavailableNoText =>
      'Search needs selectable text, and this PDF has none.';

  @override
  String get searchUnavailableGarbled =>
      'Search is off because this PDF\'s text cannot be read properly.';

  @override
  String get dismissAction => 'Got it';

  @override
  String get ttsReadAloud => 'Read aloud';

  @override
  String get ttsPause => 'Pause';

  @override
  String get ttsStop => 'Stop';

  @override
  String get ttsUnavailableNoText =>
      'Read aloud needs selectable text, and this PDF has none.';

  @override
  String get ttsUnavailableGarbled =>
      'Read aloud is off because this PDF\'s text cannot be read properly.';

  @override
  String get ttsUnavailableNoVoice =>
      'No speech voice is installed on this device.';

  @override
  String get ttsNothingToRead => 'There is nothing to read on this page.';

  @override
  String get settingsReadAloudLabel => 'Read aloud';

  @override
  String get settingsMalayalamVoice => 'Malayalam voice';

  @override
  String get settingsMalayalamVoiceReady =>
      'Ready. Malayalam text will be read in Malayalam.';

  @override
  String get settingsMalayalamVoiceOff =>
      'Malayalam text is read with the English voice.';

  @override
  String get settingsMalayalamVoiceNeedsInstall =>
      'The Malayalam voice is not downloaded yet.';

  @override
  String get settingsMalayalamVoiceUnavailable =>
      'This device\'s speech engine does not offer Malayalam.';

  @override
  String get settingsMalayalamVoiceChecking => 'Checking…';

  @override
  String get ttsInstallTitle => 'Get the Malayalam voice';

  @override
  String get ttsInstallBody =>
      'This phone does not have the Malayalam voice yet. Try one of these:';

  @override
  String get ttsInstallVoiceData => 'Download voice data';

  @override
  String get ttsOpenTtsSettings => 'Open speech settings';

  @override
  String get ttsOpenPlayStore => 'Get Google speech services';

  @override
  String get ttsInstallDoneNote =>
      'Come back here after installing — the setting turns on by itself once the voice is ready.';

  @override
  String get ttsInstallCannotOpen => 'This phone could not open that screen.';

  @override
  String get ttsVoiceLostNotice =>
      'The Malayalam voice is no longer installed, so the setting was turned off.';
}
