import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ml'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'SreerajP PDF App'**
  String get appTitle;

  /// Title of the Home screen
  ///
  /// In en, this message translates to:
  /// **'SreerajP PDF App'**
  String get homeTitle;

  /// Empty-state message on Home
  ///
  /// In en, this message translates to:
  /// **'No PDF open yet. Opening files comes in the next phase.'**
  String get homeEmptyMessage;

  /// Title of the Settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Label for the theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Sepia reading theme option
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get themeSepia;

  /// OLED pure pitch-black theme option
  ///
  /// In en, this message translates to:
  /// **'OLED Pitch-Black'**
  String get themeOled;

  /// Title of the About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// Tooltip/label to open Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get openSettings;

  /// Tooltip/label to open About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get openAbout;

  /// Button to open a PDF via the system picker
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get openPdf;

  /// Header for the recent files list
  ///
  /// In en, this message translates to:
  /// **'Recent files'**
  String get recentFilesTitle;

  /// Empty state for the recents list
  ///
  /// In en, this message translates to:
  /// **'No recent files yet. Tap \"Open PDF\" to read one.'**
  String get noRecentFiles;

  /// Action to remove a recent file entry
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeFromRecents;

  /// Generic open failure message
  ///
  /// In en, this message translates to:
  /// **'Could not open the file.'**
  String get openFailed;

  /// Message when a recent file cannot be reopened
  ///
  /// In en, this message translates to:
  /// **'This file could not be reopened. It may have been moved or deleted.'**
  String get reopenFailed;

  /// Page count label for a recent file
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String pagesLabel(int count);

  /// Continuous scroll view mode
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get viewModeContinuous;

  /// Single page view mode
  ///
  /// In en, this message translates to:
  /// **'Single page'**
  String get viewModeSingle;

  /// Two-page book view mode
  ///
  /// In en, this message translates to:
  /// **'Two pages'**
  String get viewModeBook;

  /// Tooltip for the view mode selector
  ///
  /// In en, this message translates to:
  /// **'View mode'**
  String get viewModeTooltip;

  /// Fit page to screen width
  ///
  /// In en, this message translates to:
  /// **'Fit width'**
  String get fitWidth;

  /// Fit whole page to screen
  ///
  /// In en, this message translates to:
  /// **'Fit page'**
  String get fitPage;

  /// Label for page fit options dialog
  ///
  /// In en, this message translates to:
  /// **'Page fit'**
  String get pageFit;

  /// Zoom in control
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// Zoom out control
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// Reset zoom to original scale
  ///
  /// In en, this message translates to:
  /// **'Reset zoom'**
  String get resetZoom;

  /// Toggle to invert page colors for night reading
  ///
  /// In en, this message translates to:
  /// **'Night colors'**
  String get invertColors;

  /// Title of the table-of-contents drawer
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get contentsTitle;

  /// Shown when a PDF has no outline
  ///
  /// In en, this message translates to:
  /// **'This PDF has no contents.'**
  String get noOutline;

  /// Title of the thumbnail grid
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get thumbnailsTitle;

  /// Action/title to jump to a page number
  ///
  /// In en, this message translates to:
  /// **'Go to page'**
  String get goToPage;

  /// Current page indicator
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfPages(int current, int total);

  /// Hint for the page-number input
  ///
  /// In en, this message translates to:
  /// **'Page number'**
  String get pageNumberHint;

  /// Confirm jump to page
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get goAction;

  /// Cancel a dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// Title of the PDF password dialog
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get passwordTitle;

  /// Body of the PDF password dialog
  ///
  /// In en, this message translates to:
  /// **'This PDF is protected. Enter its password to read it.'**
  String get passwordMessage;

  /// Hint for the password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// Confirm the password
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockAction;

  /// Retry opening the file
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgainAction;

  /// Title for a corrupt/damaged PDF
  ///
  /// In en, this message translates to:
  /// **'Can\'t open this PDF'**
  String get errorCorruptTitle;

  /// Body for a corrupt/damaged PDF
  ///
  /// In en, this message translates to:
  /// **'The file seems damaged or is not a valid PDF.'**
  String get errorCorruptBody;

  /// Title for an empty PDF
  ///
  /// In en, this message translates to:
  /// **'Nothing to show'**
  String get errorEmptyTitle;

  /// Body for an empty PDF
  ///
  /// In en, this message translates to:
  /// **'This PDF is empty — it has no pages.'**
  String get errorEmptyBody;

  /// Title when the password was not given
  ///
  /// In en, this message translates to:
  /// **'Locked PDF'**
  String get errorPasswordTitle;

  /// Body when the password was not given
  ///
  /// In en, this message translates to:
  /// **'This PDF is password protected. Enter the password to read it.'**
  String get errorPasswordBody;

  /// Generic viewer error title
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// Generic viewer error body
  ///
  /// In en, this message translates to:
  /// **'This PDF could not be opened.'**
  String get errorGenericBody;

  /// Notice shown when opening a large PDF
  ///
  /// In en, this message translates to:
  /// **'This is a large PDF, so it opens one page at a time for smoother reading.'**
  String get largeFileWarning;

  /// Loading label while the PDF opens
  ///
  /// In en, this message translates to:
  /// **'Opening…'**
  String get loadingPdf;

  /// Affirmative value
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Title of the document details sheet
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get metadataTitle;

  /// Menu item that opens the details sheet
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get metadataAction;

  /// Header for the file facts section
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get metadataFileSection;

  /// File name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get metadataFileName;

  /// File size label
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get metadataFileSize;

  /// Header for the PDF's own fields
  ///
  /// In en, this message translates to:
  /// **'PDF details'**
  String get metadataPdfSection;

  /// Shown when PDF details cannot be read
  ///
  /// In en, this message translates to:
  /// **'These details could not be read.'**
  String get metadataUnavailable;

  /// Shown when the PDF has no description fields
  ///
  /// In en, this message translates to:
  /// **'This PDF does not describe itself.'**
  String get metadataNoFields;

  /// PDF title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get metadataTitleField;

  /// PDF author field label
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get metadataAuthor;

  /// PDF subject field label
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get metadataSubject;

  /// PDF keywords field label
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get metadataKeywords;

  /// PDF creator (source app) field label
  ///
  /// In en, this message translates to:
  /// **'Made with'**
  String get metadataCreator;

  /// PDF producer field label
  ///
  /// In en, this message translates to:
  /// **'Saved by'**
  String get metadataProducer;

  /// PDF creation date label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get metadataCreated;

  /// PDF modification date label
  ///
  /// In en, this message translates to:
  /// **'Changed'**
  String get metadataModified;

  /// Page count label
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get metadataPages;

  /// PDF version label
  ///
  /// In en, this message translates to:
  /// **'PDF version'**
  String get metadataPdfVersion;

  /// Shown when the PDF is encrypted
  ///
  /// In en, this message translates to:
  /// **'Password protected'**
  String get metadataProtected;

  /// Tooltip for the search button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchAction;

  /// Hint text in the search field
  ///
  /// In en, this message translates to:
  /// **'Search in this PDF'**
  String get searchHint;

  /// Tooltip to leave search
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get searchClose;

  /// Tooltip to clear the search text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// Tooltip to go to the next match
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get searchNextMatch;

  /// Tooltip to go to the previous match
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get searchPreviousMatch;

  /// Shown while the search runs
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get searchSearching;

  /// Shown when a finished search found nothing
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get searchNoMatches;

  /// Which match is showing, out of how many
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String searchMatchOf(int current, int total);

  /// Shown when the search stopped at the match limit
  ///
  /// In en, this message translates to:
  /// **'Showing the first {count} matches. Try a longer word.'**
  String searchLimitReached(int count);

  /// Tooltip for the search options menu
  ///
  /// In en, this message translates to:
  /// **'Search options'**
  String get searchOptionsTooltip;

  /// Strict search mode option
  ///
  /// In en, this message translates to:
  /// **'Exact spelling'**
  String get searchOptionStrict;

  /// Explains the strict search mode
  ///
  /// In en, this message translates to:
  /// **'Tell joined and unjoined spellings apart'**
  String get searchOptionStrictNote;

  /// Accent-insensitive search option
  ///
  /// In en, this message translates to:
  /// **'Ignore accent marks'**
  String get searchOptionIgnoreAccents;

  /// Explains accent-insensitive search
  ///
  /// In en, this message translates to:
  /// **'Useful for Sanskrit chant accents'**
  String get searchOptionIgnoreAccentsNote;

  /// Sandhi compound search option
  ///
  /// In en, this message translates to:
  /// **'Sandhi compound search'**
  String get searchOptionSandhi;

  /// Explains Sandhi search mode
  ///
  /// In en, this message translates to:
  /// **'Find joined or split compound words (Malayalam & Sanskrit)'**
  String get searchOptionSandhiNote;

  /// Phonetic sound-alike search option
  ///
  /// In en, this message translates to:
  /// **'Phonetic matching'**
  String get searchOptionPhonetic;

  /// Explains phonetic search mode
  ///
  /// In en, this message translates to:
  /// **'Match sound-alike letters, anusvara nasals, and chillu variations'**
  String get searchOptionPhoneticNote;

  /// Title of the scanned-PDF notice
  ///
  /// In en, this message translates to:
  /// **'No selectable text'**
  String get noTextTitle;

  /// Body of the scanned-PDF notice
  ///
  /// In en, this message translates to:
  /// **'This PDF has no text layer, so it looks scanned. Search, copy, and read aloud are not available. This app does not read text from pictures.'**
  String get noTextBody;

  /// Title of the garbled-extraction notice
  ///
  /// In en, this message translates to:
  /// **'Text cannot be read properly'**
  String get garbledTextTitle;

  /// Body of the garbled-extraction notice
  ///
  /// In en, this message translates to:
  /// **'This PDF\'s fonts do not say which letters they show, so search and read aloud would give wrong results. Reading the pages still works.'**
  String get garbledTextBody;

  /// Why search is off for a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'Search needs selectable text, and this PDF has none.'**
  String get searchUnavailableNoText;

  /// Why search is off for a garbled PDF
  ///
  /// In en, this message translates to:
  /// **'Search is off because this PDF\'s text cannot be read properly.'**
  String get searchUnavailableGarbled;

  /// Dismisses a notice
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dismissAction;

  /// Tooltip to start reading the page aloud
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get ttsReadAloud;

  /// Tooltip to pause reading
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get ttsPause;

  /// Tooltip to stop reading
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get ttsStop;

  /// Why read-aloud is off for a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'Read aloud needs selectable text, and this PDF has none.'**
  String get ttsUnavailableNoText;

  /// Why read-aloud is off for a garbled PDF
  ///
  /// In en, this message translates to:
  /// **'Read aloud is off because this PDF\'s text cannot be read properly.'**
  String get ttsUnavailableGarbled;

  /// Why read-aloud is off with no voice
  ///
  /// In en, this message translates to:
  /// **'No speech voice is installed on this device.'**
  String get ttsUnavailableNoVoice;

  /// Shown when the page has no text to speak
  ///
  /// In en, this message translates to:
  /// **'There is nothing to read on this page.'**
  String get ttsNothingToRead;

  /// Header for the read-aloud settings
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get settingsReadAloudLabel;

  /// The Malayalam TTS toggle
  ///
  /// In en, this message translates to:
  /// **'Malayalam voice'**
  String get settingsMalayalamVoice;

  /// Malayalam voice is installed
  ///
  /// In en, this message translates to:
  /// **'Ready. Malayalam text will be read in Malayalam.'**
  String get settingsMalayalamVoiceReady;

  /// Malayalam toggle is off
  ///
  /// In en, this message translates to:
  /// **'Malayalam text is read with the English voice.'**
  String get settingsMalayalamVoiceOff;

  /// Malayalam voice needs installing
  ///
  /// In en, this message translates to:
  /// **'The Malayalam voice is not downloaded yet.'**
  String get settingsMalayalamVoiceNeedsInstall;

  /// Malayalam not supported at all
  ///
  /// In en, this message translates to:
  /// **'This device\'s speech engine does not offer Malayalam.'**
  String get settingsMalayalamVoiceUnavailable;

  /// Still checking the voice
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get settingsMalayalamVoiceChecking;

  /// Title of the guided-install sheet
  ///
  /// In en, this message translates to:
  /// **'Get the Malayalam voice'**
  String get ttsInstallTitle;

  /// Body of the guided-install sheet
  ///
  /// In en, this message translates to:
  /// **'This phone does not have the Malayalam voice yet. Try one of these:'**
  String get ttsInstallBody;

  /// Opens the engine's voice download screen
  ///
  /// In en, this message translates to:
  /// **'Download voice data'**
  String get ttsInstallVoiceData;

  /// Opens the system TTS settings
  ///
  /// In en, this message translates to:
  /// **'Open speech settings'**
  String get ttsOpenTtsSettings;

  /// Opens the Play Store listing
  ///
  /// In en, this message translates to:
  /// **'Get Google speech services'**
  String get ttsOpenPlayStore;

  /// What happens after installing
  ///
  /// In en, this message translates to:
  /// **'Come back here after installing — the setting turns on by itself once the voice is ready.'**
  String get ttsInstallDoneNote;

  /// Shown when an install door does not exist
  ///
  /// In en, this message translates to:
  /// **'This phone could not open that screen.'**
  String get ttsInstallCannotOpen;

  /// Auto-disable notice when the voice disappears
  ///
  /// In en, this message translates to:
  /// **'The Malayalam voice is no longer installed, so the setting was turned off.'**
  String get ttsVoiceLostNotice;

  /// Title/action for extracting and converting PDF contents
  ///
  /// In en, this message translates to:
  /// **'Extract & Convert'**
  String get extractAndConvert;

  /// Action to extract plain text
  ///
  /// In en, this message translates to:
  /// **'Extract text'**
  String get extractTextAction;

  /// Action to extract embedded images
  ///
  /// In en, this message translates to:
  /// **'Extract images'**
  String get extractImagesAction;

  /// Action to convert PDF pages to images
  ///
  /// In en, this message translates to:
  /// **'Convert to images'**
  String get convertPdfAction;

  /// Action to read AcroForm fields
  ///
  /// In en, this message translates to:
  /// **'Form fields'**
  String get formFieldsAction;

  /// Message when extraction completes successfully
  ///
  /// In en, this message translates to:
  /// **'Extraction successful'**
  String get extractionSuccess;

  /// Message when extraction fails
  ///
  /// In en, this message translates to:
  /// **'Extraction failed'**
  String get extractionFailed;

  /// Message shown during extraction process
  ///
  /// In en, this message translates to:
  /// **'Extracting content…'**
  String get extractingProgress;

  /// Page range option for all pages
  ///
  /// In en, this message translates to:
  /// **'All pages'**
  String get rangeAll;

  /// Page range option for the current page
  ///
  /// In en, this message translates to:
  /// **'Current page (Page {page})'**
  String rangeCurrent(int page);

  /// Page range option for a custom range
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get rangeCustom;

  /// Label for the start page input field
  ///
  /// In en, this message translates to:
  /// **'Start page'**
  String get startPageLabel;

  /// Label for the end page input field
  ///
  /// In en, this message translates to:
  /// **'End page'**
  String get endPageLabel;

  /// Error shown on invalid page range
  ///
  /// In en, this message translates to:
  /// **'Invalid page range'**
  String get invalidPageRange;

  /// Label for image format selector
  ///
  /// In en, this message translates to:
  /// **'Image format'**
  String get imageFormatLabel;

  /// Label for resolution in DPI
  ///
  /// In en, this message translates to:
  /// **'Resolution: {dpi} DPI'**
  String resolutionLabel(int dpi);

  /// Column header for field names
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get fieldsNameHeader;

  /// Column header for field values
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get fieldsValueHeader;

  /// Message shown when PDF has no AcroForm fields
  ///
  /// In en, this message translates to:
  /// **'No interactive form fields found in this PDF.'**
  String get noFormFieldsFound;

  /// Message when no embedded images are found in page range
  ///
  /// In en, this message translates to:
  /// **'No images were found in the selected range.'**
  String get noImagesFound;

  /// Generic share action button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// Action to share text/form as a file
  ///
  /// In en, this message translates to:
  /// **'Share as file'**
  String get shareFileAction;

  /// Action to copy text/fields to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyClipboardAction;

  /// Toast message on successful copy
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copySuccess;

  /// Title of text preview dialog
  ///
  /// In en, this message translates to:
  /// **'Extracted Text Preview'**
  String get previewTextTitle;

  /// Title of form fields display dialog
  ///
  /// In en, this message translates to:
  /// **'Interactive Form Fields'**
  String get formFieldsTitle;

  /// Menu entry and sheet title for page operations
  ///
  /// In en, this message translates to:
  /// **'Page tools'**
  String get pageToolsTitle;

  /// Action to merge several PDFs into one
  ///
  /// In en, this message translates to:
  /// **'Merge PDFs'**
  String get mergeAction;

  /// Subtitle for the merge action
  ///
  /// In en, this message translates to:
  /// **'Join this PDF with others into one new file'**
  String get mergeDescription;

  /// Success title after merging
  ///
  /// In en, this message translates to:
  /// **'PDFs merged'**
  String get mergeDoneTitle;

  /// Action to split a PDF into one file per page
  ///
  /// In en, this message translates to:
  /// **'Split into pages'**
  String get splitAction;

  /// Subtitle for the split action
  ///
  /// In en, this message translates to:
  /// **'Make one new file for each page'**
  String get splitDescription;

  /// Success title after splitting
  ///
  /// In en, this message translates to:
  /// **'PDF split'**
  String get splitDoneTitle;

  /// Action to reorder, rotate, and delete pages
  ///
  /// In en, this message translates to:
  /// **'Organize pages'**
  String get organizeAction;

  /// Subtitle for the organize action
  ///
  /// In en, this message translates to:
  /// **'Reorder, rotate, or delete pages'**
  String get organizeDescription;

  /// App bar title of the organizer screen
  ///
  /// In en, this message translates to:
  /// **'Organize pages'**
  String get organizeTitle;

  /// Help text on the organizer screen
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder. Use the buttons to rotate or delete a page. Save writes a new file.'**
  String get organizeHint;

  /// Success title after organizing pages
  ///
  /// In en, this message translates to:
  /// **'Pages organized'**
  String get organizeDoneTitle;

  /// Action to compress a PDF
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get compressAction;

  /// Subtitle for the compress action
  ///
  /// In en, this message translates to:
  /// **'Make a smaller copy (best-effort)'**
  String get compressDescription;

  /// Success title after compressing
  ///
  /// In en, this message translates to:
  /// **'PDF compressed'**
  String get compressDoneTitle;

  /// Note explaining that compression is weak
  ///
  /// In en, this message translates to:
  /// **'Compression is best-effort. Already-optimized files may not shrink much.'**
  String get compressBestEffortNote;

  /// Action to add a password to a PDF
  ///
  /// In en, this message translates to:
  /// **'Protect with password'**
  String get protectAction;

  /// Subtitle for the protect action
  ///
  /// In en, this message translates to:
  /// **'Add a password to a new copy'**
  String get protectDescription;

  /// Title of the protect dialog
  ///
  /// In en, this message translates to:
  /// **'Protect PDF'**
  String get protectTitle;

  /// Success title after protecting
  ///
  /// In en, this message translates to:
  /// **'PDF protected'**
  String get protectDoneTitle;

  /// Action to remove a PDF password
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
  String get removePasswordAction;

  /// Subtitle for the unlock action
  ///
  /// In en, this message translates to:
  /// **'Make an unlocked copy (needs the current password)'**
  String get unlockDescription;

  /// Title of the unlock dialog
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
  String get unlockTitle;

  /// Success title after unlocking
  ///
  /// In en, this message translates to:
  /// **'Password removed'**
  String get unlockDoneTitle;

  /// Label for the open password field
  ///
  /// In en, this message translates to:
  /// **'Password (to open the file)'**
  String get userPasswordLabel;

  /// Label for the optional owner password field
  ///
  /// In en, this message translates to:
  /// **'Owner password (optional)'**
  String get ownerPasswordLabel;

  /// Helper text for the owner password field
  ///
  /// In en, this message translates to:
  /// **'Controls printing and editing. Leave blank to match the open password.'**
  String get ownerPasswordHelp;

  /// Label for the current password field when unlocking
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// Validation error when no password is entered
  ///
  /// In en, this message translates to:
  /// **'Please enter a password.'**
  String get passwordRequiredError;

  /// Progress text shown while an operation runs
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get workingProgress;

  /// Generic failure message for a page operation
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get opFailed;

  /// Action to save a file to a chosen location
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// Message shown when saving fails
  ///
  /// In en, this message translates to:
  /// **'Could not save the file'**
  String get saveFailed;

  /// Toast after a file is saved to a chosen location
  ///
  /// In en, this message translates to:
  /// **'Saved {name}'**
  String savedFileMessage(String name);

  /// Result dialog line for a single output file
  ///
  /// In en, this message translates to:
  /// **'New file: {name}'**
  String resultOneFile(String name);

  /// Result dialog line for many output files
  ///
  /// In en, this message translates to:
  /// **'{count} new files were created.'**
  String resultManyFiles(int count);

  /// Label for a page row in the organizer
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pageLabel(int page);

  /// Shows how much a page is rotated
  ///
  /// In en, this message translates to:
  /// **'Rotated {degrees}°'**
  String rotatedBy(int degrees);

  /// Snackbar after a page is deleted in the organizer
  ///
  /// In en, this message translates to:
  /// **'Page {page} removed'**
  String pageDeletedMessage(int page);

  /// Undo a deletion
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoAction;

  /// Rotate a page
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotateAction;

  /// Delete a page
  ///
  /// In en, this message translates to:
  /// **'Delete page'**
  String get deletePageAction;

  /// Error when the user deletes every page
  ///
  /// In en, this message translates to:
  /// **'Keep at least one page.'**
  String get noPagesLeftError;

  /// Turn annotation mode on/off
  ///
  /// In en, this message translates to:
  /// **'Annotate'**
  String get annotateAction;

  /// Highlight text tool
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get annotationHighlight;

  /// Underline text tool
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get annotationUnderline;

  /// Strikethrough text tool
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get annotationStrikethrough;

  /// Freehand ink tool
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get annotationInk;

  /// Sticky note tool
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get annotationNote;

  /// Erase a mark tool
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get annotationEraser;

  /// Remove every mark on the file
  ///
  /// In en, this message translates to:
  /// **'Clear all marks'**
  String get annotationClearAll;

  /// Write marks into a new PDF copy
  ///
  /// In en, this message translates to:
  /// **'Export annotated copy'**
  String get annotationExport;

  /// Banner explaining overlay-only annotations
  ///
  /// In en, this message translates to:
  /// **'These marks are saved only inside this app. Export an annotated copy to keep them in the PDF.'**
  String get annotationOverlayNotice;

  /// Shown when text markup is used on a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'This PDF has no selectable text to mark.'**
  String get annotationTextMarkupUnavailable;

  /// Progress while exporting annotations
  ///
  /// In en, this message translates to:
  /// **'Making an annotated copy…'**
  String get annotationExporting;

  /// Export failure message
  ///
  /// In en, this message translates to:
  /// **'Could not export the annotated copy.'**
  String get annotationExportFailed;

  /// Export pressed with no marks
  ///
  /// In en, this message translates to:
  /// **'Add a mark first.'**
  String get annotationNothingToExport;

  /// Confirm dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear all marks?'**
  String get annotationClearAllTitle;

  /// Confirm dialog body
  ///
  /// In en, this message translates to:
  /// **'This removes every mark on this file. It cannot be undone.'**
  String get annotationClearAllMessage;

  /// Note editor title
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteTitle;

  /// Note editor text field hint
  ///
  /// In en, this message translates to:
  /// **'Write your note'**
  String get noteHint;

  /// Delete a mark or note
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// Bookmarks panel title
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksTitle;

  /// Open the bookmarks panel
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksAction;

  /// Empty bookmarks list
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet.'**
  String get bookmarksEmpty;

  /// Add a bookmark on the current page
  ///
  /// In en, this message translates to:
  /// **'Bookmark page {page}'**
  String bookmarkAddCurrent(int page);

  /// Remove the bookmark on the current page
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark on page {page}'**
  String bookmarkRemoveCurrent(int page);

  /// Label for a bookmark row
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String bookmarkPageLabel(int page);

  /// Share sheet could not be opened
  ///
  /// In en, this message translates to:
  /// **'Could not share this file.'**
  String get shareFailed;

  /// Title of the screen for content shared into the app
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get importTitle;

  /// Progress while building a PDF from shared content
  ///
  /// In en, this message translates to:
  /// **'Making your PDF…'**
  String get importBuilding;

  /// The shared content became a PDF
  ///
  /// In en, this message translates to:
  /// **'Your PDF is ready'**
  String get importReadyTitle;

  /// How many shared pictures went into the PDF
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Made from 1 picture} other{Made from {count} pictures}}'**
  String importImagesSummary(int count);

  /// The PDF was built from shared text
  ///
  /// In en, this message translates to:
  /// **'Made from the text you shared.'**
  String get importTextSummary;

  /// Size of the built PDF
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String importSize(String size);

  /// Save the built PDF to a chosen place
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get importSaveAction;

  /// Share the built PDF
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get importShareAction;

  /// Confirmation after saving the built PDF
  ///
  /// In en, this message translates to:
  /// **'Saved {name}'**
  String importSaved(String name);

  /// Building a PDF from shared content failed
  ///
  /// In en, this message translates to:
  /// **'Could not make the PDF'**
  String get importFailedTitle;

  /// Shared text uses a script the PDF fonts do not cover
  ///
  /// In en, this message translates to:
  /// **'These letters cannot be saved yet'**
  String get importUnsupportedTextTitle;

  /// Plain explanation of the Latin-1 font limit
  ///
  /// In en, this message translates to:
  /// **'This app can only write English letters and numbers into a PDF. Malayalam and other scripts are not supported yet. A picture of the text will save fine.'**
  String get importUnsupportedTextDetail;

  /// Open the print options
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printAction;

  /// Title of the print sheet
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printTitle;

  /// Print every page
  ///
  /// In en, this message translates to:
  /// **'Whole document'**
  String get printWholeAction;

  /// Explains the whole-document print option
  ///
  /// In en, this message translates to:
  /// **'Print every page of this PDF.'**
  String get printWholeDescription;

  /// Print only some pages
  ///
  /// In en, this message translates to:
  /// **'Page range'**
  String get printRangeAction;

  /// Explains the page-range print option
  ///
  /// In en, this message translates to:
  /// **'Choose which pages to print.'**
  String get printRangeDescription;

  /// Print the text of the PDF, not the pages
  ///
  /// In en, this message translates to:
  /// **'Text only'**
  String get printTextAction;

  /// Explains the text-only print option
  ///
  /// In en, this message translates to:
  /// **'Print the words of this PDF as plain pages.'**
  String get printTextDescription;

  /// Title of the page-range dialog
  ///
  /// In en, this message translates to:
  /// **'Pages to print'**
  String get printRangeTitle;

  /// First page of the print range
  ///
  /// In en, this message translates to:
  /// **'From page'**
  String get printFromLabel;

  /// Last page of the print range
  ///
  /// In en, this message translates to:
  /// **'To page'**
  String get printToLabel;

  /// The typed print range is out of bounds or backwards
  ///
  /// In en, this message translates to:
  /// **'Enter a page range inside 1 to {pageCount}.'**
  String printRangeInvalid(int pageCount);

  /// Progress while preparing a document to print
  ///
  /// In en, this message translates to:
  /// **'Getting the pages ready…'**
  String get printPreparing;

  /// Printing is not supported on this device
  ///
  /// In en, this message translates to:
  /// **'This device cannot print.'**
  String get printUnavailable;

  /// Generic print failure
  ///
  /// In en, this message translates to:
  /// **'Could not start printing.'**
  String get printFailed;

  /// Text-only printing on a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'This PDF has no text to print.'**
  String get printNoText;

  /// Open the signatures screen from the viewer menu
  ///
  /// In en, this message translates to:
  /// **'Signatures'**
  String get signaturesAction;

  /// Title of the signatures screen
  ///
  /// In en, this message translates to:
  /// **'Signatures'**
  String get signaturesTitle;

  /// Progress while signatures are verified
  ///
  /// In en, this message translates to:
  /// **'Checking signatures…'**
  String get signaturesChecking;

  /// Empty state when a document has no signatures
  ///
  /// In en, this message translates to:
  /// **'This PDF is not signed.'**
  String get signaturesNone;

  /// The signature check itself failed — not the same as a bad signature
  ///
  /// In en, this message translates to:
  /// **'These signatures could not be checked.'**
  String get signaturesFailed;

  /// Explains that a failed check is not a verdict
  ///
  /// In en, this message translates to:
  /// **'This does not mean the signatures are bad. It means the app could not read them, so it will not say either way.'**
  String get signaturesFailedDetail;

  /// Green tick state
  ///
  /// In en, this message translates to:
  /// **'Signed and trusted'**
  String get signatureStatusTrusted;

  /// Explains the trusted state
  ///
  /// In en, this message translates to:
  /// **'The document has not changed since it was signed, and you trust the signer\'s certificate.'**
  String get signatureStatusTrustedDetail;

  /// Valid crypto, untrusted signer
  ///
  /// In en, this message translates to:
  /// **'Signed, but signer unknown'**
  String get signatureStatusValidNotTrusted;

  /// Explains the valid-not-trusted state
  ///
  /// In en, this message translates to:
  /// **'The document has not changed since it was signed. But the app does not know the signer, so it cannot vouch for who they are.'**
  String get signatureStatusValidNotTrustedDetail;

  /// Red state
  ///
  /// In en, this message translates to:
  /// **'Signature is not valid'**
  String get signatureStatusInvalid;

  /// Explains the invalid state
  ///
  /// In en, this message translates to:
  /// **'The document changed after it was signed, or the signature does not match. Do not rely on it.'**
  String get signatureStatusInvalidDetail;

  /// Grey state
  ///
  /// In en, this message translates to:
  /// **'Signature could not be read'**
  String get signatureStatusUnknown;

  /// Explains the unknown state
  ///
  /// In en, this message translates to:
  /// **'The app could not make sense of this signature, so it will not say whether it is good or bad.'**
  String get signatureStatusUnknownDetail;

  /// Short label for the partial-coverage note
  ///
  /// In en, this message translates to:
  /// **'Covers only part of the file'**
  String get signatureNotePartialCoverage;

  /// Explains partial coverage in plain words
  ///
  /// In en, this message translates to:
  /// **'Something was added to this file after it was signed. The signature says nothing about that part.'**
  String get signatureNotePartialCoverageDetail;

  /// Short label for a revoked certificate
  ///
  /// In en, this message translates to:
  /// **'The certificate was cancelled'**
  String get signatureNoteRevoked;

  /// Explains revocation
  ///
  /// In en, this message translates to:
  /// **'Whoever issued this certificate has since cancelled it. It should not be trusted.'**
  String get signatureNoteRevokedDetail;

  /// Short label when revocation was not checked
  ///
  /// In en, this message translates to:
  /// **'Could not check if the certificate was cancelled'**
  String get signatureNoteRevocationNotChecked;

  /// Explains why revocation was not checked, offline-first
  ///
  /// In en, this message translates to:
  /// **'Checking that needs the internet, which this app never uses, and this PDF does not carry the proof inside it.'**
  String get signatureNoteRevocationNotCheckedDetail;

  /// Short label for expired-at-signing
  ///
  /// In en, this message translates to:
  /// **'The certificate had expired when it signed'**
  String get signatureNoteCertExpired;

  /// Explains expired-at-signing
  ///
  /// In en, this message translates to:
  /// **'The signing certificate was outside its valid dates at the time of signing.'**
  String get signatureNoteCertExpiredDetail;

  /// Short label for an unverified signing time
  ///
  /// In en, this message translates to:
  /// **'The signing time is only a claim'**
  String get signatureNoteUnverifiedTime;

  /// Explains why a signing time may not be trustworthy
  ///
  /// In en, this message translates to:
  /// **'This time is stored outside the signed part of the file, so anyone could have changed it.'**
  String get signatureNoteUnverifiedTimeDetail;

  /// Label for the signer name
  ///
  /// In en, this message translates to:
  /// **'Signed by'**
  String get signatureSignerLabel;

  /// Shown when the signature carries no signer name
  ///
  /// In en, this message translates to:
  /// **'Not stated'**
  String get signatureSignerUnknown;

  /// Label for the signing time
  ///
  /// In en, this message translates to:
  /// **'Signed on'**
  String get signatureSignedAtLabel;

  /// Label for the stated reason for signing
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get signatureReasonLabel;

  /// Label for the stated signing location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get signatureLocationLabel;

  /// Title of the certificate details section
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get signatureCertificateTitle;

  /// Certificate subject
  ///
  /// In en, this message translates to:
  /// **'Issued to'**
  String get signatureIssuedToLabel;

  /// Certificate issuer
  ///
  /// In en, this message translates to:
  /// **'Issued by'**
  String get signatureIssuedByLabel;

  /// Certificate start date
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get signatureValidFromLabel;

  /// Certificate end date
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get signatureValidUntilLabel;

  /// Explains a self-signed certificate without implying it is fake
  ///
  /// In en, this message translates to:
  /// **'This certificate vouches for itself. Nobody else backs it, so trust it only if you know the signer.'**
  String get signatureSelfSignedNote;

  /// Button to add the signer's certificate to the trust store
  ///
  /// In en, this message translates to:
  /// **'Trust this certificate'**
  String get signatureTrustAction;

  /// Title of the trust confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Trust this signer?'**
  String get signatureTrustTitle;

  /// Explains what trusting a certificate means before the user does it
  ///
  /// In en, this message translates to:
  /// **'From now on, any PDF signed with this certificate will show as trusted. Only do this if you know who the signer is.'**
  String get signatureTrustExplain;

  /// Confirm button of the trust dialog
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get signatureTrustConfirm;

  /// Shown after a certificate is added to the trust store
  ///
  /// In en, this message translates to:
  /// **'Certificate trusted.'**
  String get signatureTrustedToast;

  /// Title of the trust store screen
  ///
  /// In en, this message translates to:
  /// **'Trusted certificates'**
  String get trustStoreTitle;

  /// Empty state of the trust store screen
  ///
  /// In en, this message translates to:
  /// **'You have not trusted any certificates yet.'**
  String get trustStoreEmpty;

  /// Explains the trust store
  ///
  /// In en, this message translates to:
  /// **'When you trust a signer\'s certificate, it is listed here. You can remove it at any time.'**
  String get trustStoreEmptyDetail;

  /// Pick a certificate file to trust
  ///
  /// In en, this message translates to:
  /// **'Add a certificate'**
  String get trustStoreAddAction;

  /// Remove a certificate from the trust store
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get trustStoreRemoveAction;

  /// Title of the remove confirmation
  ///
  /// In en, this message translates to:
  /// **'Stop trusting this certificate?'**
  String get trustStoreRemoveTitle;

  /// Explains what removing a certificate does
  ///
  /// In en, this message translates to:
  /// **'PDFs signed with it will stop showing as trusted.'**
  String get trustStoreRemoveExplain;

  /// The picked file could not be parsed as a certificate
  ///
  /// In en, this message translates to:
  /// **'That file is not a certificate the app can read.'**
  String get trustStoreInvalidFile;

  /// Warning shown for an expired certificate in the trust store
  ///
  /// In en, this message translates to:
  /// **'This certificate has expired.'**
  String get trustStoreExpiredWarning;

  /// Action to crop blank page margins
  ///
  /// In en, this message translates to:
  /// **'Trim margins'**
  String get trimMarginsAction;

  /// Title of the smart margin trim dialog
  ///
  /// In en, this message translates to:
  /// **'Smart Margin Trim'**
  String get trimMarginsTitle;

  /// Description of smart margin trimming
  ///
  /// In en, this message translates to:
  /// **'Crops blank page margins for mobile reading.'**
  String get trimMarginsDescription;

  /// Progress message while trimming margins
  ///
  /// In en, this message translates to:
  /// **'Trimming blank page margins…'**
  String get trimMarginsWorking;

  /// Title shown when margin trim succeeds
  ///
  /// In en, this message translates to:
  /// **'Margins trimmed'**
  String get trimMarginsDoneTitle;

  /// Note on trimmed PDF result
  ///
  /// In en, this message translates to:
  /// **'Blank margins cropped to fit mobile screens.'**
  String get trimMarginsDoneNote;

  /// Label for margin padding selector
  ///
  /// In en, this message translates to:
  /// **'Margin padding'**
  String get trimPaddingLabel;

  /// Tight padding option
  ///
  /// In en, this message translates to:
  /// **'Tight (4 pt)'**
  String get trimPaddingTight;

  /// Standard padding option
  ///
  /// In en, this message translates to:
  /// **'Standard (12 pt)'**
  String get trimPaddingStandard;

  /// Comfortable padding option
  ///
  /// In en, this message translates to:
  /// **'Comfortable (24 pt)'**
  String get trimPaddingComfortable;

  /// Label for symmetric margin toggle
  ///
  /// In en, this message translates to:
  /// **'Symmetric margins'**
  String get trimSymmetricLabel;

  /// Help text for symmetric margin toggle
  ///
  /// In en, this message translates to:
  /// **'Keeps left and right margins balanced.'**
  String get trimSymmetricHelp;

  /// Action to create a foldable booklet
  ///
  /// In en, this message translates to:
  /// **'Create booklet'**
  String get bookletAction;

  /// Title of the booklet imposition dialog
  ///
  /// In en, this message translates to:
  /// **'Foldable Booklet (2-Up)'**
  String get bookletTitle;

  /// Description of booklet imposition
  ///
  /// In en, this message translates to:
  /// **'Generates a 2-Up foldable booklet imposition layout for double-sided printing.'**
  String get bookletDescription;

  /// Progress message while generating booklet
  ///
  /// In en, this message translates to:
  /// **'Generating booklet layout…'**
  String get bookletWorking;

  /// Title shown when booklet generation succeeds
  ///
  /// In en, this message translates to:
  /// **'Booklet generated'**
  String get bookletDoneTitle;

  /// Printing and folding advice for generated booklet
  ///
  /// In en, this message translates to:
  /// **'Print double-sided (flip on short edge) and fold in half along the center spine.'**
  String get bookletDoneNote;

  /// Title for booklet plan summary card
  ///
  /// In en, this message translates to:
  /// **'Booklet layout summary'**
  String get bookletSummaryTitle;

  /// Page count mapping in booklet summary
  ///
  /// In en, this message translates to:
  /// **'{source} original pages -> {padded} booklet pages'**
  String bookletSummaryPages(int source, int padded);

  /// Sheet and face count in booklet summary
  ///
  /// In en, this message translates to:
  /// **'{sheets, plural, =1{1 physical landscape sheet} other{{sheets} physical landscape sheets}} ({faces} printable sides)'**
  String bookletSummarySheets(int sheets, int faces);

  /// Blank page count in booklet summary
  ///
  /// In en, this message translates to:
  /// **'{blanks, plural, =1{1 blank filler page added at end} other{{blanks} blank filler pages added at end}}'**
  String bookletSummaryBlanks(int blanks);

  /// Label for binding direction selector
  ///
  /// In en, this message translates to:
  /// **'Binding direction'**
  String get bookletBindingLabel;

  /// LTR binding direction option
  ///
  /// In en, this message translates to:
  /// **'Left to Right (LTR)'**
  String get bookletBindingLtr;

  /// RTL binding direction option
  ///
  /// In en, this message translates to:
  /// **'Right to Left (RTL)'**
  String get bookletBindingRtl;

  /// Label for booklet sheet size selector
  ///
  /// In en, this message translates to:
  /// **'Paper size'**
  String get bookletPaperSizeLabel;

  /// Auto paper size option
  ///
  /// In en, this message translates to:
  /// **'Match source'**
  String get bookletPaperAuto;

  /// A4 landscape paper size option
  ///
  /// In en, this message translates to:
  /// **'A4 Landscape'**
  String get bookletPaperA4;

  /// US Letter landscape paper size option
  ///
  /// In en, this message translates to:
  /// **'US Letter'**
  String get bookletPaperLetter;

  /// Label for fold line guideline switch
  ///
  /// In en, this message translates to:
  /// **'Center fold guide'**
  String get bookletFoldGuideLabel;

  /// Help text for fold line guideline switch
  ///
  /// In en, this message translates to:
  /// **'Draws a faint dotted guideline showing where to fold the booklet.'**
  String get bookletFoldGuideHelp;

  /// Title of the Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// Subtitle of the Appearance card
  ///
  /// In en, this message translates to:
  /// **'Theme mode, typography, and colors'**
  String get appearanceSubtitle;

  /// Title of the Theme mode section
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeTitle;

  /// Subtitle of the Theme mode card
  ///
  /// In en, this message translates to:
  /// **'Choose between Light, Dark, System, or Sepia mode'**
  String get themeModeSubtitle;

  /// Brief subtitle for the theme mode card
  ///
  /// In en, this message translates to:
  /// **'Select Light, Dark, or System'**
  String get themeModeCardSubtitle;

  /// Information explaining theme modes
  ///
  /// In en, this message translates to:
  /// **'System mode automatically follows your device\'s system-wide dark mode setting. Sepia mode provides a warm, eye-comfort reading background.'**
  String get themeModeDescription;

  /// Title of Typography & Text Size section
  ///
  /// In en, this message translates to:
  /// **'Typography & Text Size'**
  String get typographyTitle;

  /// Subtitle for Typography & Text Size card
  ///
  /// In en, this message translates to:
  /// **'App font family and text size'**
  String get typographySubtitle;

  /// Description of typography settings
  ///
  /// In en, this message translates to:
  /// **'Customize the app font family and reading text size for better readability across screens.'**
  String get typographyDescription;

  /// Label for font family picker
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get typographyFontLabel;

  /// Label for text size segmented button
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get typographyTextSizeLabel;

  /// Default system font family
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get fontSystemDefault;

  /// Manjari font family
  ///
  /// In en, this message translates to:
  /// **'Manjari'**
  String get fontManjari;

  /// Anek Malayalam font family
  ///
  /// In en, this message translates to:
  /// **'Anek Malayalam'**
  String get fontAnekMalayalam;

  /// Noto Sans Malayalam font family
  ///
  /// In en, this message translates to:
  /// **'Noto Sans Malayalam'**
  String get fontNotoSansMalayalam;

  /// Small text size label
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get textSizeSmall;

  /// Default text size label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get textSizeDefault;

  /// Large text size label
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get textSizeLarge;

  /// Larger text size label
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get textSizeLarger;

  /// Latin sample text for typography preview
  ///
  /// In en, this message translates to:
  /// **'The quick brown fox 0123'**
  String get typographySampleLatin;

  /// Malayalam sample text for typography preview
  ///
  /// In en, this message translates to:
  /// **'മലയാളം സുന്ദരമാണ്'**
  String get typographySampleMalayalam;

  /// Title of the Accent color screen
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColorTitle;

  /// Subtitle of the Accent color card
  ///
  /// In en, this message translates to:
  /// **'Presets, color wheel, live preview'**
  String get accentColorSubtitle;

  /// Note telling which theme the edited accent applies to.
  ///
  /// In en, this message translates to:
  /// **'This color is used while the app is in light mode.'**
  String get accentAppliesToLight;

  /// Note telling which theme the edited accent applies to.
  ///
  /// In en, this message translates to:
  /// **'This color is used while the app is in dark mode.'**
  String get accentAppliesToDark;

  /// Live preview section label
  ///
  /// In en, this message translates to:
  /// **'LIVE PREVIEW'**
  String get livePreviewLabel;

  /// Sample text on preview chip
  ///
  /// In en, this message translates to:
  /// **'Sample text'**
  String get sampleText;

  /// Presets section label
  ///
  /// In en, this message translates to:
  /// **'PRESETS'**
  String get presetsLabel;

  /// Custom color wheel label
  ///
  /// In en, this message translates to:
  /// **'CUSTOM COLOR WHEEL'**
  String get customColorWheelLabel;

  /// Button to reset color
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetToDefault;

  /// Button to reset Light theme accent
  ///
  /// In en, this message translates to:
  /// **'Reset Light to default'**
  String get resetLightToDefault;

  /// Button to reset Dark theme accent
  ///
  /// In en, this message translates to:
  /// **'Reset Dark to default'**
  String get resetDarkToDefault;

  /// Notice for automatic contrast adjustment
  ///
  /// In en, this message translates to:
  /// **'Text contrast is adjusted automatically for readability.'**
  String get contrastNotice;

  /// Title of the Permissions screen
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsTitle;

  /// Subtitle of the Permissions card
  ///
  /// In en, this message translates to:
  /// **'Storage, virtual print service and privacy capabilities'**
  String get permissionsSubtitle;

  /// Tooltip to open system app settings
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get permissionsOpenSettings;

  /// Header for explicit system capabilities
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get permissionsExplicitHeader;

  /// Subtitle for explicit capabilities
  ///
  /// In en, this message translates to:
  /// **'Features and system roles designed for safe document access.'**
  String get permissionsExplicitSubtitle;

  /// Header for implicit privacy items
  ///
  /// In en, this message translates to:
  /// **'Privacy & System Declarations'**
  String get permissionsImplicitHeader;

  /// Subtitle for implicit declarations
  ///
  /// In en, this message translates to:
  /// **'Declared in the manifest; 100% safe offline processing.'**
  String get permissionsImplicitSubtitle;

  /// Title for scoped storage
  ///
  /// In en, this message translates to:
  /// **'Scoped Storage (SAF)'**
  String get permScopedStorageTitle;

  /// Reason for scoped storage
  ///
  /// In en, this message translates to:
  /// **'Open and save documents securely via the Android system file picker without broad device storage permissions.'**
  String get permScopedStorageReason;

  /// Title for virtual print service
  ///
  /// In en, this message translates to:
  /// **'Virtual Print Service'**
  String get permPrintServiceTitle;

  /// Reason for virtual print service
  ///
  /// In en, this message translates to:
  /// **'Allows other Android apps to print documents directly to SreerajP PDF App.'**
  String get permPrintServiceReason;

  /// Title for offline guarantee
  ///
  /// In en, this message translates to:
  /// **'100% Offline & Private'**
  String get permOfflineTitle;

  /// Reason for offline guarantee
  ///
  /// In en, this message translates to:
  /// **'Zero internet permissions. Your documents and data never leave this device.'**
  String get permOfflineReason;

  /// Title for TTS query
  ///
  /// In en, this message translates to:
  /// **'Text-to-Speech Engine'**
  String get permTtsTitle;

  /// Reason for TTS query
  ///
  /// In en, this message translates to:
  /// **'Queries installed speech engines for reading documents aloud in English and Malayalam.'**
  String get permTtsReason;

  /// Title for process text capability
  ///
  /// In en, this message translates to:
  /// **'Process Text Action'**
  String get permProcessTextTitle;

  /// Reason for process text capability
  ///
  /// In en, this message translates to:
  /// **'Enables quick searching and text actions when selecting text in other applications.'**
  String get permProcessTextReason;

  /// Status badge for active feature
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// Status badge for system-managed item
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get statusSystem;

  /// Status badge for offline guarantee
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// Subtitle for trust store card
  ///
  /// In en, this message translates to:
  /// **'Manage digital signature root certificates'**
  String get trustStoreSubtitle;

  /// Subtitle for about card
  ///
  /// In en, this message translates to:
  /// **'App version, licenses, and legal info'**
  String get aboutSubtitle;

  /// Title of the Help screen and Settings card
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// Subtitle for Help card in settings
  ///
  /// In en, this message translates to:
  /// **'Guides, setup instructions, and tips'**
  String get helpSubtitle;

  /// Title of PDF Printer topic in Help
  ///
  /// In en, this message translates to:
  /// **'PDF Printer Setup'**
  String get helpPdfPrinterTitle;

  /// Subtitle of PDF Printer card in Help
  ///
  /// In en, this message translates to:
  /// **'How to enable and use the virtual print service'**
  String get helpPdfPrinterSubtitle;

  /// Header for PDF Printer enable guide
  ///
  /// In en, this message translates to:
  /// **'1. How to Enable the PDF Printer on Android'**
  String get helpPdfPrinterTopicHeader;

  /// Intro explanation for enabling PDF printer
  ///
  /// In en, this message translates to:
  /// **'On Android, virtual print services are managed at the system level. To enable SreerajP PDF App as a system-wide printer:'**
  String get helpPdfPrinterIntro;

  /// Step 1 to enable PDF printer
  ///
  /// In en, this message translates to:
  /// **'Open your Android device\'s Settings.'**
  String get helpPdfPrinterStep1;

  /// Step 2 to enable PDF printer
  ///
  /// In en, this message translates to:
  /// **'Go to Connected devices → Connection preferences → Printing (or search for \"Printing\" in your Settings search bar).'**
  String get helpPdfPrinterStep2;

  /// Step 3 to enable PDF printer
  ///
  /// In en, this message translates to:
  /// **'Under Print services, find SreerajP PDF App (or your app\'s name).'**
  String get helpPdfPrinterStep3;

  /// Step 4 to enable PDF printer
  ///
  /// In en, this message translates to:
  /// **'Tap it and switch the toggle to On.'**
  String get helpPdfPrinterStep4;

  /// Button to jump directly to Android print settings
  ///
  /// In en, this message translates to:
  /// **'Open Print Settings'**
  String get helpOpenPrintSettings;

  /// Title of Unicode PDF Printing topic in Help
  ///
  /// In en, this message translates to:
  /// **'Unicode & Malayalam PDF Printing'**
  String get helpUnicodePrintingTitle;

  /// Subtitle of Unicode PDF Printing card in Help
  ///
  /// In en, this message translates to:
  /// **'Printing complex Indic scripts without broken characters'**
  String get helpUnicodePrintingSubtitle;

  /// Header for Unicode PDF Printing guide
  ///
  /// In en, this message translates to:
  /// **'Printing Unicode & Malayalam Text Accurately'**
  String get helpUnicodePrintingTopicHeader;

  /// Intro explanation for Unicode PDF printing
  ///
  /// In en, this message translates to:
  /// **'Standard Android printing can sometimes garble complex scripts (such as Malayalam, Hindi, or Sanskrit), resulting in broken chillu characters, disconnected conjuncts, or missing fonts. SreerajP PDF App handles complex script shaping and font embedding to generate pristine PDFs.'**
  String get helpUnicodePrintingIntro;

  /// Step 1 for Unicode PDF printing
  ///
  /// In en, this message translates to:
  /// **'Enable the PDF Virtual Printer in Android Settings if you haven\'t already.'**
  String get helpUnicodePrintingStep1;

  /// Step 2 for Unicode PDF printing
  ///
  /// In en, this message translates to:
  /// **'In any app (such as Chrome, WhatsApp, or Office), select Print from the menu.'**
  String get helpUnicodePrintingStep2;

  /// Step 3 for Unicode PDF printing
  ///
  /// In en, this message translates to:
  /// **'Select \'SreerajP PDF App\' as the target printer instead of the standard Android \'Save as PDF\'.'**
  String get helpUnicodePrintingStep3;

  /// Step 4 for Unicode PDF printing
  ///
  /// In en, this message translates to:
  /// **'The app captures the print spool, resolves Unicode glyphs and fonts, and creates a crisp, readable PDF file.'**
  String get helpUnicodePrintingStep4;

  /// Helpful tip for Unicode PDF printing
  ///
  /// In en, this message translates to:
  /// **'Tip: For web articles with complex layouts, enable \'Clean Web Content\' in Printer Settings to strip unwanted ads and headers automatically.'**
  String get helpUnicodePrintingTip;

  /// Button to jump to Printer Settings
  ///
  /// In en, this message translates to:
  /// **'Open Printer Settings'**
  String get helpOpenPrinterSettings;

  /// Title of TTS topic in Help
  ///
  /// In en, this message translates to:
  /// **'Read Aloud (TTS) & Malayalam Voice'**
  String get helpTtsTitle;

  /// Subtitle of TTS card in Help
  ///
  /// In en, this message translates to:
  /// **'Configure speech engine, voice speed, and Malayalam support'**
  String get helpTtsSubtitle;

  /// Header for TTS guide
  ///
  /// In en, this message translates to:
  /// **'How to Use Read Aloud and Install Malayalam Voices'**
  String get helpTtsTopicHeader;

  /// Intro explanation for TTS
  ///
  /// In en, this message translates to:
  /// **'The app can read PDF text aloud using your device\'s Text-to-Speech (TTS) engine. It supports both English and Malayalam.'**
  String get helpTtsIntro;

  /// Step 1 for TTS
  ///
  /// In en, this message translates to:
  /// **'Open any text-based PDF and tap the \'Read Aloud\' (speaker) button in the top bar.'**
  String get helpTtsStep1;

  /// Step 2 for TTS
  ///
  /// In en, this message translates to:
  /// **'If the Malayalam voice is not installed, go to Settings → Read Aloud (TTS) and tap \'Get the Malayalam voice\'.'**
  String get helpTtsStep2;

  /// Step 3 for TTS
  ///
  /// In en, this message translates to:
  /// **'You can customize speech speed, voice pitch, sentence-ending pauses, and auto-scrolling to match your reading style.'**
  String get helpTtsStep3;

  /// Tip for TTS regarding scanned documents
  ///
  /// In en, this message translates to:
  /// **'Note: Scanned documents containing only images without a selectable text layer cannot be read aloud. OCR is not supported.'**
  String get helpTtsTip;

  /// Button to jump to TTS Settings
  ///
  /// In en, this message translates to:
  /// **'Open TTS Settings'**
  String get helpOpenTtsSettings;

  /// Title of Organizing Pages topic in Help
  ///
  /// In en, this message translates to:
  /// **'Organizing & Modifying Pages'**
  String get helpPageOpsTitle;

  /// Subtitle of Organizing Pages card in Help
  ///
  /// In en, this message translates to:
  /// **'Merge, split, reorder, rotate, booklet, and N-Up layouts'**
  String get helpPageOpsSubtitle;

  /// Header for Page Operations guide
  ///
  /// In en, this message translates to:
  /// **'Page Operations & Copy-on-Write Safety'**
  String get helpPageOpsTopicHeader;

  /// Intro explanation for Page Operations
  ///
  /// In en, this message translates to:
  /// **'Easily reorganize or transform pages in your PDF documents. Every operation strictly adheres to Copy-on-Write — your original document is never modified in place.'**
  String get helpPageOpsIntro;

  /// Step 1 for Page Operations
  ///
  /// In en, this message translates to:
  /// **'Open a document and tap the Page Operations menu (or use the Organizer view).'**
  String get helpPageOpsStep1;

  /// Step 2 for Page Operations
  ///
  /// In en, this message translates to:
  /// **'Select desired actions: Reorder pages by dragging, Rotate individual or all pages, or Delete unwanted pages.'**
  String get helpPageOpsStep2;

  /// Step 3 for Page Operations
  ///
  /// In en, this message translates to:
  /// **'Use \'Booklet Creation\' for foldable 2-up booklets or \'N-Up Layout\' to fit multiple pages (2, 4, 6, 9) onto a single sheet.'**
  String get helpPageOpsStep3;

  /// Step 4 for Page Operations
  ///
  /// In en, this message translates to:
  /// **'Tap Save / Export to generate a brand new PDF file in your chosen location.'**
  String get helpPageOpsStep4;

  /// Tip for Page Operations
  ///
  /// In en, this message translates to:
  /// **'Safety Guarantee: Because operations create a new file, you can experiment freely without risking loss or damage to your original PDFs.'**
  String get helpPageOpsTip;

  /// Title of Digital Signatures topic in Help
  ///
  /// In en, this message translates to:
  /// **'Digital Signatures & Trust Store'**
  String get helpSignaturesTitle;

  /// Subtitle of Digital Signatures card in Help
  ///
  /// In en, this message translates to:
  /// **'Offline cryptographic verification and certificate management'**
  String get helpSignaturesSubtitle;

  /// Header for Digital Signatures guide
  ///
  /// In en, this message translates to:
  /// **'Verifying Digital Signatures Offline'**
  String get helpSignaturesTopicHeader;

  /// Intro explanation for Digital Signatures
  ///
  /// In en, this message translates to:
  /// **'SreerajP PDF App verifies digital signatures completely offline using cryptographic algorithms (SHA-256 digests and X.509 certificate chains) with zero network requests.'**
  String get helpSignaturesIntro;

  /// Step 1 for Digital Signatures
  ///
  /// In en, this message translates to:
  /// **'When opening a signed PDF, tap the Signature Badge in the top bar to inspect signer details and byte coverage.'**
  String get helpSignaturesStep1;

  /// Step 2 for Digital Signatures
  ///
  /// In en, this message translates to:
  /// **'The app checks if the document has been altered or tampered with since it was signed.'**
  String get helpSignaturesStep2;

  /// Step 3 for Digital Signatures
  ///
  /// In en, this message translates to:
  /// **'If a certificate shows as untrusted, you can inspect the certificate chain and add trusted root certificates in the Trust Store.'**
  String get helpSignaturesStep3;

  /// Tip for Digital Signatures
  ///
  /// In en, this message translates to:
  /// **'Security Note: All cryptographic checking runs locally in Kotlin using Bouncy Castle and CertPathValidator without sending documents to any remote server.'**
  String get helpSignaturesTip;

  /// Button to jump to Trust Store
  ///
  /// In en, this message translates to:
  /// **'Open Trust Store'**
  String get helpOpenTrustStore;

  /// Title of Privacy & Storage topic in Help
  ///
  /// In en, this message translates to:
  /// **'Privacy & Scoped Storage'**
  String get helpPrivacyStorageTitle;

  /// Subtitle of Privacy & Storage card in Help
  ///
  /// In en, this message translates to:
  /// **'Zero internet permissions and Scoped Storage security'**
  String get helpPrivacyStorageSubtitle;

  /// Header for Privacy & Storage guide
  ///
  /// In en, this message translates to:
  /// **'100% Offline Privacy Guarantee'**
  String get helpPrivacyStorageTopicHeader;

  /// Intro explanation for Privacy & Storage
  ///
  /// In en, this message translates to:
  /// **'Your privacy is paramount. SreerajP PDF App is built from the ground up to operate in total isolation without internet connectivity.'**
  String get helpPrivacyStorageIntro;

  /// Step 1 for Privacy & Storage
  ///
  /// In en, this message translates to:
  /// **'Zero Internet: The app\'s manifest contains no INTERNET permission. It cannot transmit data or collect analytics.'**
  String get helpPrivacyStorageStep1;

  /// Step 2 for Privacy & Storage
  ///
  /// In en, this message translates to:
  /// **'Scoped Storage (SAF): The app only accesses files you explicitly pick via Android\'s system file picker.'**
  String get helpPrivacyStorageStep2;

  /// Step 3 for Privacy & Storage
  ///
  /// In en, this message translates to:
  /// **'Temporary Cache Management: Render caches and printer spool files can be cleared at any time from Storage Settings.'**
  String get helpPrivacyStorageStep3;

  /// Tip for Privacy & Storage
  ///
  /// In en, this message translates to:
  /// **'Password Safety: Passwords entered for encrypted PDFs are kept in volatile memory only and are never saved to disk or logged.'**
  String get helpPrivacyStorageTip;

  /// Button to jump to Storage Settings
  ///
  /// In en, this message translates to:
  /// **'Open Storage & Privacy Settings'**
  String get helpOpenStorageSettings;

  /// Title of Language settings screen
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// Subtitle of Language settings card
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get languageSubtitle;

  /// Option to follow system language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Malayalam language option
  ///
  /// In en, this message translates to:
  /// **'മലയാളം (Malayalam)'**
  String get languageMalayalam;

  /// Heading for language selection
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageSelectTitle;

  /// Description for language selection
  ///
  /// In en, this message translates to:
  /// **'Changes apply immediately across the entire application.'**
  String get languageSelectSubtitle;

  /// Title of Reader settings screen
  ///
  /// In en, this message translates to:
  /// **'Reader & Viewer'**
  String get readerSettingsTitle;

  /// Subtitle of Reader settings card
  ///
  /// In en, this message translates to:
  /// **'Reading position, layout, zoom, and display'**
  String get readerSettingsSubtitle;

  /// Title for saving reading position
  ///
  /// In en, this message translates to:
  /// **'Remember Reading Position'**
  String get saveLastPositionTitle;

  /// Subtitle for saving reading position
  ///
  /// In en, this message translates to:
  /// **'Automatically resume from the last viewed page and zoom level'**
  String get saveLastPositionSubtitle;

  /// Title for default page layout setting
  ///
  /// In en, this message translates to:
  /// **'Default Page Layout'**
  String get defaultPageLayoutTitle;

  /// Subtitle for default page layout setting
  ///
  /// In en, this message translates to:
  /// **'Choose how pages are presented when opening documents'**
  String get defaultPageLayoutSubtitle;

  /// Continuous vertical scrolling option
  ///
  /// In en, this message translates to:
  /// **'Continuous Scroll'**
  String get layoutContinuous;

  /// Single page horizontal swiping option
  ///
  /// In en, this message translates to:
  /// **'Single Page'**
  String get layoutSinglePage;

  /// Title for double-tap zoom setting
  ///
  /// In en, this message translates to:
  /// **'Double-Tap Zoom'**
  String get doubleTapZoomTitle;

  /// Subtitle for double-tap zoom setting
  ///
  /// In en, this message translates to:
  /// **'Action performed on double-tapping a PDF page'**
  String get doubleTapZoomSubtitle;

  /// Fit to width zoom option
  ///
  /// In en, this message translates to:
  /// **'Fit to Width'**
  String get zoomFitWidth;

  /// 200% zoom option
  ///
  /// In en, this message translates to:
  /// **'Zoom to 200%'**
  String get zoom200;

  /// Title for page indicator toggle
  ///
  /// In en, this message translates to:
  /// **'Page Number Indicator'**
  String get showPageIndicatorTitle;

  /// Subtitle for page indicator toggle
  ///
  /// In en, this message translates to:
  /// **'Display page indicator pill overlay while reading'**
  String get showPageIndicatorSubtitle;

  /// Title for PDF color inversion
  ///
  /// In en, this message translates to:
  /// **'Invert PDF Colors'**
  String get invertColorsTitle;

  /// Subtitle for PDF color inversion
  ///
  /// In en, this message translates to:
  /// **'Inverts document colors for night-time reading'**
  String get invertColorsSubtitle;

  /// Title of TTS settings screen
  ///
  /// In en, this message translates to:
  /// **'Read Aloud (TTS)'**
  String get ttsSettingsTitle;

  /// Subtitle of TTS settings card
  ///
  /// In en, this message translates to:
  /// **'Voice, speech speed, pitch, and playback options'**
  String get ttsSettingsSubtitle;

  /// Title for speech speed slider
  ///
  /// In en, this message translates to:
  /// **'Speech Rate'**
  String get ttsSpeechRateTitle;

  /// Speech speed display
  ///
  /// In en, this message translates to:
  /// **'{rate}x speed'**
  String ttsSpeechRateSubtitle(String rate);

  /// Title for speech pitch slider
  ///
  /// In en, this message translates to:
  /// **'Voice Pitch'**
  String get ttsPitchTitle;

  /// Speech pitch display
  ///
  /// In en, this message translates to:
  /// **'{pitch}x pitch'**
  String ttsPitchSubtitle(String pitch);

  /// Title for auto-scroll toggle during TTS
  ///
  /// In en, this message translates to:
  /// **'Auto-Scroll with Speech'**
  String get ttsAutoScrollTitle;

  /// Subtitle for auto-scroll toggle during TTS
  ///
  /// In en, this message translates to:
  /// **'Automatically scroll the document as sentences are spoken'**
  String get ttsAutoScrollSubtitle;

  /// Title of PDF Printer settings screen
  ///
  /// In en, this message translates to:
  /// **'PDF Virtual Printer'**
  String get printerSettingsTitle;

  /// Subtitle of PDF Printer settings card
  ///
  /// In en, this message translates to:
  /// **'Print service integration, paper size, and cache'**
  String get printerSettingsSubtitle;

  /// Title for virtual printer toggle
  ///
  /// In en, this message translates to:
  /// **'Enable PDF Printer Integration'**
  String get printerEnableTitle;

  /// Subtitle for virtual printer toggle
  ///
  /// In en, this message translates to:
  /// **'Accept print jobs from other apps and save them as PDF'**
  String get printerEnableSubtitle;

  /// Title for default paper size
  ///
  /// In en, this message translates to:
  /// **'Default Paper Size'**
  String get defaultPaperSizeTitle;

  /// Subtitle for default paper size
  ///
  /// In en, this message translates to:
  /// **'Default page dimensions for generated PDFs'**
  String get defaultPaperSizeSubtitle;

  /// Title for default color mode
  ///
  /// In en, this message translates to:
  /// **'Default Color Mode'**
  String get defaultColorModeTitle;

  /// Subtitle for default color mode
  ///
  /// In en, this message translates to:
  /// **'Color output for printed documents'**
  String get defaultColorModeSubtitle;

  /// Full color option
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorModeColor;

  /// Grayscale option
  ///
  /// In en, this message translates to:
  /// **'Grayscale'**
  String get colorModeGrayscale;

  /// Monochrome option
  ///
  /// In en, this message translates to:
  /// **'Monochrome (Black & White)'**
  String get colorModeMonochrome;

  /// Title for default orientation
  ///
  /// In en, this message translates to:
  /// **'Default Orientation'**
  String get defaultOrientationTitle;

  /// Subtitle for default orientation
  ///
  /// In en, this message translates to:
  /// **'Page orientation for print jobs'**
  String get defaultOrientationSubtitle;

  /// Auto orientation option
  ///
  /// In en, this message translates to:
  /// **'Auto (Match Source)'**
  String get orientationAuto;

  /// Portrait orientation option
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get orientationPortrait;

  /// Landscape orientation option
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get orientationLandscape;

  /// Title for clearing printer cache
  ///
  /// In en, this message translates to:
  /// **'Clear Printer Cache'**
  String get clearPrinterCacheTitle;

  /// Subtitle for clearing printer cache
  ///
  /// In en, this message translates to:
  /// **'Purge temporary PDF spool files ({size})'**
  String clearPrinterCacheSubtitle(String size);

  /// Notification when printer cache is cleared
  ///
  /// In en, this message translates to:
  /// **'Printer cache cleared.'**
  String get printerCacheCleared;

  /// Title of Storage & Privacy settings screen
  ///
  /// In en, this message translates to:
  /// **'Storage & Privacy'**
  String get storageSettingsTitle;

  /// Subtitle of Storage & Privacy settings card
  ///
  /// In en, this message translates to:
  /// **'Recent files history and cache cleanup'**
  String get storageSettingsSubtitle;

  /// Title for remember recent files toggle
  ///
  /// In en, this message translates to:
  /// **'Remember Recent Files'**
  String get rememberRecentFilesTitle;

  /// Subtitle for remember recent files toggle
  ///
  /// In en, this message translates to:
  /// **'Save opened documents to the recents list on Home'**
  String get rememberRecentFilesSubtitle;

  /// Title for clearing recent files history
  ///
  /// In en, this message translates to:
  /// **'Clear Recent Files History'**
  String get clearRecentFilesTitle;

  /// Subtitle for clearing recent files history
  ///
  /// In en, this message translates to:
  /// **'Remove all opened document records and saved positions'**
  String get clearRecentFilesSubtitle;

  /// Confirmation title for clearing recents
  ///
  /// In en, this message translates to:
  /// **'Clear recent files?'**
  String get clearRecentFilesConfirmTitle;

  /// Confirmation message for clearing recents
  ///
  /// In en, this message translates to:
  /// **'This will clear your recent files list and reading progress. The original PDF files on your device will NOT be deleted.'**
  String get clearRecentFilesConfirmMessage;

  /// Button to confirm clearing recents
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearRecentFilesAction;

  /// Notification when recents are cleared
  ///
  /// In en, this message translates to:
  /// **'Recent files history cleared.'**
  String get recentFilesCleared;

  /// Title for clearing all app cache
  ///
  /// In en, this message translates to:
  /// **'Clear App Cache'**
  String get clearTempCacheTitle;

  /// Subtitle for clearing app cache
  ///
  /// In en, this message translates to:
  /// **'Free up temporary space without losing data ({size})'**
  String clearTempCacheSubtitle(String size);

  /// Notification when app cache is cleared
  ///
  /// In en, this message translates to:
  /// **'Temporary cache cleared.'**
  String get tempCacheCleared;

  /// Title for Security & Signatures card
  ///
  /// In en, this message translates to:
  /// **'Signatures & Trust'**
  String get securitySettingsTitle;

  /// Subtitle for Security & Signatures card
  ///
  /// In en, this message translates to:
  /// **'Digital signature verification and custom certificates'**
  String get securitySettingsSubtitle;

  /// Title for auto-verify signatures toggle
  ///
  /// In en, this message translates to:
  /// **'Auto-Verify Signatures'**
  String get autoVerifySignaturesTitle;

  /// Subtitle for auto-verify signatures toggle
  ///
  /// In en, this message translates to:
  /// **'Automatically check digital signatures when opening signed PDFs'**
  String get autoVerifySignaturesSubtitle;

  /// Title for FileProvider capability
  ///
  /// In en, this message translates to:
  /// **'Secure File Provider'**
  String get permFileProviderTitle;

  /// Reason for FileProvider
  ///
  /// In en, this message translates to:
  /// **'Shares temporary PDFs and extracted files with external apps without exposing private file paths.'**
  String get permFileProviderReason;

  /// What FileProvider achieves
  ///
  /// In en, this message translates to:
  /// **'Enables safe sharing and printing of PDFs to external apps without compromising storage security.'**
  String get permFileProviderWhatItAchieves;

  /// Title for TTS voice data installer query
  ///
  /// In en, this message translates to:
  /// **'Voice Data Installer'**
  String get permTtsInstallTitle;

  /// Reason for TTS voice data installer query
  ///
  /// In en, this message translates to:
  /// **'Opens system voice package download screens if required language voices are missing.'**
  String get permTtsInstallReason;

  /// What TTS installer achieves
  ///
  /// In en, this message translates to:
  /// **'Enables guided installation of Malayalam and English speech voices without dead-ends.'**
  String get permTtsInstallWhatItAchieves;

  /// Title for Send/Share intent filter
  ///
  /// In en, this message translates to:
  /// **'Receive Shares & \'Open with\''**
  String get permSendShareTitle;

  /// Reason for Send/Share intent filter
  ///
  /// In en, this message translates to:
  /// **'Receives images, plain text, and PDF files shared from other applications.'**
  String get permSendShareReason;

  /// What Send/Share intent achieves
  ///
  /// In en, this message translates to:
  /// **'Enables direct conversion of shared images and text into PDFs and opening PDFs from any app.'**
  String get permSendShareWhatItAchieves;

  /// Title for zero internet guarantee
  ///
  /// In en, this message translates to:
  /// **'Zero Internet Guarantee'**
  String get permZeroInternetTitle;

  /// Reason for zero internet guarantee
  ///
  /// In en, this message translates to:
  /// **'No android.permission.INTERNET is requested. The app runs 100% offline.'**
  String get permZeroInternetReason;

  /// What zero internet achieves
  ///
  /// In en, this message translates to:
  /// **'Guarantees complete privacy with zero data leakage, tracking, or remote telemetry.'**
  String get permZeroInternetWhatItAchieves;

  /// What scoped storage achieves
  ///
  /// In en, this message translates to:
  /// **'Allows reading and saving PDFs selected by the user while keeping the rest of the device private.'**
  String get permScopedStorageWhatItAchieves;

  /// What print service achieves
  ///
  /// In en, this message translates to:
  /// **'Allows other Android apps to send print jobs directly to SreerajP PDF App to save as PDF.'**
  String get permPrintServiceWhatItAchieves;

  /// What offline guarantee achieves
  ///
  /// In en, this message translates to:
  /// **'Ensures document contents and personal information never leave your device.'**
  String get permOfflineWhatItAchieves;

  /// What TTS engine query achieves
  ///
  /// In en, this message translates to:
  /// **'Discovers installed speech engines to read documents aloud in English and Malayalam.'**
  String get permTtsWhatItAchieves;

  /// What process text achieves
  ///
  /// In en, this message translates to:
  /// **'Allows selected text in any app to be processed or searched directly in SreerajP PDF App.'**
  String get permProcessTextWhatItAchieves;

  /// Header for permission reason
  ///
  /// In en, this message translates to:
  /// **'Why it is needed'**
  String get permWhyNeededHeader;

  /// Header for what permission achieves
  ///
  /// In en, this message translates to:
  /// **'What this achieves'**
  String get permWhatItAchievesHeader;

  /// Badge for explicit permission
  ///
  /// In en, this message translates to:
  /// **'Explicit Capability'**
  String get permTypeExplicit;

  /// Badge for implicit permission
  ///
  /// In en, this message translates to:
  /// **'Implicit / System Query'**
  String get permTypeImplicit;

  /// Badge for privacy guarantee
  ///
  /// In en, this message translates to:
  /// **'Privacy Guarantee'**
  String get permTypePrivacy;

  /// Title for reading velocity section
  ///
  /// In en, this message translates to:
  /// **'Reading Velocity & Time Estimates'**
  String get readingVelocityTitle;

  /// Subtitle for reading velocity section
  ///
  /// In en, this message translates to:
  /// **'Calculates remaining reading time based on your reading speed'**
  String get readingVelocitySubtitle;

  /// Reading speed in words per minute
  ///
  /// In en, this message translates to:
  /// **'{wpm} wpm'**
  String readingSpeedLabel(int wpm);

  /// Remaining reading time in current chapter
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left in chapter'**
  String readingTimeLeftChapter(int minutes);

  /// Remaining reading time in document
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String readingTimeLeftDoc(int minutes);

  /// Less than a minute left to read
  ///
  /// In en, this message translates to:
  /// **'< 1 min left'**
  String get readingTimeLessMinute;

  /// Toggle to show remaining reading time
  ///
  /// In en, this message translates to:
  /// **'Reading Time Estimates'**
  String get readingTimeEstimatesToggle;

  /// Subtitle for reading time estimate toggle
  ///
  /// In en, this message translates to:
  /// **'Display remaining chapter and document reading time in the reader bar'**
  String get readingTimeEstimatesToggleSubtitle;

  /// Automatic responsive view mode option
  ///
  /// In en, this message translates to:
  /// **'Auto (Dual-page on wide / foldables)'**
  String get viewModeAuto;

  /// Description for auto responsive view mode
  ///
  /// In en, this message translates to:
  /// **'Single-page on phones; dual-page book view on foldables and tablets'**
  String get viewModeAutoSubtitle;

  /// Title for Malayalam transliteration input helper
  ///
  /// In en, this message translates to:
  /// **'Malayalam Keyboard Helper'**
  String get malayalamHelperTitle;

  /// Tooltip for Malayalam input helper button
  ///
  /// In en, this message translates to:
  /// **'Malayalam input helper (Manglish typing & keypad)'**
  String get malayalamHelperTooltip;

  /// Manglish transliteration tab label
  ///
  /// In en, this message translates to:
  /// **'Manglish'**
  String get malayalamKeypadTabTranslit;

  /// Malayalam vowels tab label
  ///
  /// In en, this message translates to:
  /// **'Vowels'**
  String get malayalamKeypadTabVowels;

  /// Malayalam consonants tab label
  ///
  /// In en, this message translates to:
  /// **'Consonants'**
  String get malayalamKeypadTabConsonants;

  /// Malayalam signs and chillu letters tab label
  ///
  /// In en, this message translates to:
  /// **'Signs & Chillu'**
  String get malayalamKeypadTabSigns;

  /// Title for sentence pause setting
  ///
  /// In en, this message translates to:
  /// **'Sentence-Ending Pause'**
  String get ttsSentencePauseTitle;

  /// Subtitle for sentence pause setting
  ///
  /// In en, this message translates to:
  /// **'{seconds}s pause between sentences'**
  String ttsSentencePauseSubtitle(String seconds);

  /// TTS currently reading a page
  ///
  /// In en, this message translates to:
  /// **'Reading page {page}...'**
  String ttsReadingPage(int page);

  /// TTS playback paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get ttsPaused;

  /// TTS ready to read a page
  ///
  /// In en, this message translates to:
  /// **'Ready to read page {page}'**
  String ttsReadyToRead(int page);

  /// Menu title for applying watermark
  ///
  /// In en, this message translates to:
  /// **'Custom watermark'**
  String get watermarkAction;

  /// Menu description for watermark
  ///
  /// In en, this message translates to:
  /// **'Add text or image watermark onto pages'**
  String get watermarkDescription;

  /// Title of watermark dialog
  ///
  /// In en, this message translates to:
  /// **'Custom Watermark'**
  String get watermarkDialogTitle;

  /// Label for watermark text input
  ///
  /// In en, this message translates to:
  /// **'Watermark Text'**
  String get watermarkTextLabel;

  /// Error when watermark text is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter watermark text.'**
  String get watermarkEmptyTextError;

  /// Title when watermarked PDF is done
  ///
  /// In en, this message translates to:
  /// **'Watermarked PDF Created'**
  String get watermarkDoneTitle;

  /// Label for opacity slider
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get watermarkOpacityLabel;

  /// Label for rotation slider
  ///
  /// In en, this message translates to:
  /// **'Rotation Angle'**
  String get watermarkRotationLabel;

  /// Label for font size slider
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get watermarkFontSizeLabel;

  /// Label for color selection
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get watermarkColorLabel;

  /// Switch label for tiled watermark
  ///
  /// In en, this message translates to:
  /// **'Tile across page'**
  String get watermarkTiledLabel;

  /// Description for tiled watermark
  ///
  /// In en, this message translates to:
  /// **'Repeats watermark pattern across entire page'**
  String get watermarkTiledDescription;

  /// Dropdown label for page range
  ///
  /// In en, this message translates to:
  /// **'Apply to'**
  String get watermarkPageRangeLabel;

  /// All pages option
  ///
  /// In en, this message translates to:
  /// **'All pages'**
  String get watermarkAllPages;

  /// Odd pages option
  ///
  /// In en, this message translates to:
  /// **'Odd pages only'**
  String get watermarkOddPages;

  /// Even pages option
  ///
  /// In en, this message translates to:
  /// **'Even pages only'**
  String get watermarkEvenPages;

  /// Button to apply watermark
  ///
  /// In en, this message translates to:
  /// **'Apply Watermark'**
  String get watermarkApplyAction;

  /// Title for batch operations
  ///
  /// In en, this message translates to:
  /// **'Batch Operations'**
  String get batchOperationsTitle;

  /// Description for batch operations
  ///
  /// In en, this message translates to:
  /// **'Process multiple PDF files at once'**
  String get batchOperationsDescription;

  /// Label for batch operation dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Operation'**
  String get batchOperationLabel;

  /// Batch encrypt option
  ///
  /// In en, this message translates to:
  /// **'Batch Encrypt / Protect'**
  String get batchOpEncrypt;

  /// Batch merge option
  ///
  /// In en, this message translates to:
  /// **'Batch Merge'**
  String get batchOpMerge;

  /// Batch extract text option
  ///
  /// In en, this message translates to:
  /// **'Batch Extract Text (.txt)'**
  String get batchOpExtractText;

  /// Batch trim margins option
  ///
  /// In en, this message translates to:
  /// **'Batch Trim Margins'**
  String get batchOpTrimMargins;

  /// Batch compress option
  ///
  /// In en, this message translates to:
  /// **'Batch Compress'**
  String get batchOpCompress;

  /// Header for count of selected batch files
  ///
  /// In en, this message translates to:
  /// **'Selected Files ({count})'**
  String batchSelectedFilesCount(int count);

  /// Button to add more files to batch
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get batchAddFilesAction;

  /// Empty state for batch files
  ///
  /// In en, this message translates to:
  /// **'No PDF files selected. Tap Add Files to select PDFs.'**
  String get batchNoFilesSelected;

  /// Progress label for batch operation
  ///
  /// In en, this message translates to:
  /// **'Processing {current} of {total}: {name}'**
  String batchProgressLabel(int current, int total, String name);

  /// Button to start batch operation
  ///
  /// In en, this message translates to:
  /// **'Start Batch Operation'**
  String get batchStartAction;

  /// Summary note after batch operation completes
  ///
  /// In en, this message translates to:
  /// **'Successfully processed {success} of {total} documents.'**
  String batchDoneSummary(int success, int total);

  /// Error when all batch files failed
  ///
  /// In en, this message translates to:
  /// **'Batch processing failed for all documents.'**
  String get batchFailedAll;

  /// Title for N-Up multi-page layout
  ///
  /// In en, this message translates to:
  /// **'N-Up multi-page layout'**
  String get nUpAction;

  /// Description for N-Up layout
  ///
  /// In en, this message translates to:
  /// **'Fit 2, 4, 6, or 9 pages onto each sheet'**
  String get nUpDescription;

  /// Title of N-Up dialog
  ///
  /// In en, this message translates to:
  /// **'N-Up Multi-Page Layout'**
  String get nUpDialogTitle;

  /// Label for grid layout selector
  ///
  /// In en, this message translates to:
  /// **'Grid Layout'**
  String get nUpGridLabel;

  /// Label for sheet size
  ///
  /// In en, this message translates to:
  /// **'Sheet Size'**
  String get nUpSheetSizeLabel;

  /// A4 sheet size
  ///
  /// In en, this message translates to:
  /// **'A4'**
  String get nUpSheetA4;

  /// US Letter sheet size
  ///
  /// In en, this message translates to:
  /// **'US Letter'**
  String get nUpSheetLetter;

  /// Label for sheet orientation
  ///
  /// In en, this message translates to:
  /// **'Sheet Orientation'**
  String get nUpOrientationLabel;

  /// Auto orientation
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get nUpOrientationAuto;

  /// Portrait orientation
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get nUpOrientationPortrait;

  /// Landscape orientation
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get nUpOrientationLandscape;

  /// Label for border lines toggle
  ///
  /// In en, this message translates to:
  /// **'Draw Page Borders'**
  String get nUpBordersLabel;

  /// Description for border lines toggle
  ///
  /// In en, this message translates to:
  /// **'Draws subtle grid boundary line around each page slot'**
  String get nUpBordersDescription;

  /// Label for margin slider
  ///
  /// In en, this message translates to:
  /// **'Margin Padding'**
  String get nUpMarginLabel;

  /// Title when N-Up PDF is created
  ///
  /// In en, this message translates to:
  /// **'N-Up Multi-Page PDF Created'**
  String get nUpDoneTitle;

  /// Action to print N-Up layout
  ///
  /// In en, this message translates to:
  /// **'Print N-Up multi-page grid'**
  String get printNUpAction;

  /// Description for print N-Up
  ///
  /// In en, this message translates to:
  /// **'Print multiple pages per sheet (2-in-1, 4-in-1, etc.)'**
  String get printNUpDescription;

  /// Switch title for web content cleaner
  ///
  /// In en, this message translates to:
  /// **'Clean Web Content (Reader Mode)'**
  String get cleanWebContentTitle;

  /// Switch subtitle for web content cleaner
  ///
  /// In en, this message translates to:
  /// **'Removes headers, footers, sidebars, scripts, and ads before saving'**
  String get cleanWebContentSubtitle;

  /// Notice for multiple pages deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page deleted} other{{count} pages deleted}}'**
  String pagesDeletedCount(int count);

  /// Selected count in organizer
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String organizeSelectedCount(int count);

  /// Select all pages action
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAllAction;

  /// Deselect all pages action
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get deselectAllAction;

  /// Invert page selection action
  ///
  /// In en, this message translates to:
  /// **'Invert'**
  String get invertSelectionAction;

  /// Action to export a certificate
  ///
  /// In en, this message translates to:
  /// **'Export Certificate'**
  String get trustStoreExportAction;

  /// Action to export all certificates
  ///
  /// In en, this message translates to:
  /// **'Export All Certificates'**
  String get trustStoreExportAllAction;

  /// Toast when certificate export succeeds
  ///
  /// In en, this message translates to:
  /// **'Certificate exported to {name}'**
  String trustStoreExportSuccess(String name);

  /// Action to trust signer certificate
  ///
  /// In en, this message translates to:
  /// **'Trust Signer'**
  String get signatureTrustSignerAction;

  /// Label for unnamed signature
  ///
  /// In en, this message translates to:
  /// **'Digital Signature'**
  String get signatureUnnamed;

  /// Label for signature time
  ///
  /// In en, this message translates to:
  /// **'Signing Time'**
  String get signatureTimeLabel;

  /// Note when signing time is a claim
  ///
  /// In en, this message translates to:
  /// **'unverified claim'**
  String get signatureTimeClaimOnly;

  /// Label for document integrity
  ///
  /// In en, this message translates to:
  /// **'Document Integrity'**
  String get signatureIntegrityLabel;

  /// Integrity valid description
  ///
  /// In en, this message translates to:
  /// **'Document unmodified since signing'**
  String get signatureIntegrityValid;

  /// Integrity invalid description
  ///
  /// In en, this message translates to:
  /// **'Document modified after signing'**
  String get signatureIntegrityInvalid;

  /// Integrity unknown description
  ///
  /// In en, this message translates to:
  /// **'Integrity could not be verified'**
  String get signatureIntegrityUnknown;

  /// Label for byte coverage
  ///
  /// In en, this message translates to:
  /// **'Byte Coverage'**
  String get signatureCoverageLabel;

  /// Whole document coverage description
  ///
  /// In en, this message translates to:
  /// **'Signature covers the entire document'**
  String get signatureCoversWholeFile;

  /// Partial document coverage description
  ///
  /// In en, this message translates to:
  /// **'Signature covers only part of the document'**
  String get signatureCoversPartialFile;

  /// Header for signer certificate section
  ///
  /// In en, this message translates to:
  /// **'Signer Certificate Details'**
  String get signatureCertificateHeader;

  /// Title of the Features screen and Settings card
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTitle;

  /// Subtitle for Features card in settings
  ///
  /// In en, this message translates to:
  /// **'Explore all features of SreerajP PDF App'**
  String get featuresSubtitle;

  /// Header title of the Features screen
  ///
  /// In en, this message translates to:
  /// **'SreerajP PDF App Features'**
  String get featuresHeaderTitle;

  /// Header subtitle of the Features screen
  ///
  /// In en, this message translates to:
  /// **'Explore every intelligent tool, privacy safeguard, and PDF feature designed for you.'**
  String get featuresHeaderSubtitle;

  /// Category title for viewing features
  ///
  /// In en, this message translates to:
  /// **'PDF Viewing & Navigation Engine'**
  String get featuresCategoryViewing;

  /// Category subtitle for viewing features
  ///
  /// In en, this message translates to:
  /// **'High-performance rendering, continuous scrolling, book view, and smart navigation'**
  String get featuresCategoryViewingSubtitle;

  /// Category title for search and speech features
  ///
  /// In en, this message translates to:
  /// **'Search, Indic Phonetics & Speech'**
  String get featuresCategorySearch;

  /// Category subtitle for search and speech features
  ///
  /// In en, this message translates to:
  /// **'Sandhi-aware Indic search, Malayalam transliteration, and text-to-speech'**
  String get featuresCategorySearchSubtitle;

  /// Category title for annotations
  ///
  /// In en, this message translates to:
  /// **'Annotation Overlay & Markups'**
  String get featuresCategoryAnnotations;

  /// Category subtitle for annotations
  ///
  /// In en, this message translates to:
  /// **'Non-destructive markups, ink drawing, notes, and PDF flattening'**
  String get featuresCategoryAnnotationsSubtitle;

  /// Category title for page operations
  ///
  /// In en, this message translates to:
  /// **'Page Operations & Reorganization'**
  String get featuresCategoryPageOps;

  /// Category subtitle for page operations
  ///
  /// In en, this message translates to:
  /// **'Visual page organizer, booklet imposition, watermarks, and batch tools'**
  String get featuresCategoryPageOpsSubtitle;

  /// Category title for data extraction
  ///
  /// In en, this message translates to:
  /// **'Data Extraction & Utilities'**
  String get featuresCategoryExtraction;

  /// Category subtitle for data extraction
  ///
  /// In en, this message translates to:
  /// **'Extract plain text, embedded images, form fields, and metadata'**
  String get featuresCategoryExtractionSubtitle;

  /// Category title for printer and importer
  ///
  /// In en, this message translates to:
  /// **'Virtual Printer & Share Hub'**
  String get featuresCategoryPrinter;

  /// Category subtitle for printer and importer
  ///
  /// In en, this message translates to:
  /// **'System-wide virtual PDF printer, web cleaner, and image/text conversion'**
  String get featuresCategoryPrinterSubtitle;

  /// Category title for signatures
  ///
  /// In en, this message translates to:
  /// **'Digital Signatures & Trust Store'**
  String get featuresCategorySignatures;

  /// Category subtitle for signatures
  ///
  /// In en, this message translates to:
  /// **'Native cryptographic verification, visual stamp badges, and custom trust store'**
  String get featuresCategorySignaturesSubtitle;

  /// Category title for themes
  ///
  /// In en, this message translates to:
  /// **'Themes & Customization'**
  String get featuresCategoryThemes;

  /// Category subtitle for themes
  ///
  /// In en, this message translates to:
  /// **'OLED dark mode, custom typography, HSV accent color picker, and settings hubs'**
  String get featuresCategoryThemesSubtitle;

  /// Category title for help guides
  ///
  /// In en, this message translates to:
  /// **'Built-In User Guides'**
  String get featuresCategoryGuides;

  /// Category subtitle for help guides
  ///
  /// In en, this message translates to:
  /// **'Comprehensive offline tutorials and troubleshooting guides'**
  String get featuresCategoryGuidesSubtitle;

  /// Header title of the Help screen
  ///
  /// In en, this message translates to:
  /// **'Help Center & Knowledge Base'**
  String get helpHeaderTitle;

  /// Header subtitle of the Help screen
  ///
  /// In en, this message translates to:
  /// **'Browse in-depth guides and solutions for all features of SreerajP PDF App.'**
  String get helpHeaderSubtitle;

  /// Help section header for printing
  ///
  /// In en, this message translates to:
  /// **'Printing & Conversion'**
  String get helpSectionPrinting;

  /// Help section header for reading
  ///
  /// In en, this message translates to:
  /// **'Reading & Speech'**
  String get helpSectionReading;

  /// Help section header for page operations
  ///
  /// In en, this message translates to:
  /// **'Document Operations'**
  String get helpSectionPageOps;

  /// Help section header for security
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get helpSectionSecurity;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
