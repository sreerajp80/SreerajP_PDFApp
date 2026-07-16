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
  /// **'PDF App'**
  String get appTitle;

  /// Title of the Home screen
  ///
  /// In en, this message translates to:
  /// **'PDF App'**
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

  /// Action to remove a PDF password
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
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
