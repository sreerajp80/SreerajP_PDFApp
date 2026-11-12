import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_sa.dart';

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
    Locale('sa'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Folio'**
  String get titleApp;

  /// Title of the Home screen
  ///
  /// In en, this message translates to:
  /// **'Folio'**
  String get titleHome;

  /// Empty-state message on Home
  ///
  /// In en, this message translates to:
  /// **'No PDF open yet. Opening files comes in the next phase.'**
  String get bodyHomeEmpty;

  /// Title of the Settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get titleSettings;

  /// Label for the theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get labelSettingsTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get labelThemeSystem;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get labelThemeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get labelThemeDark;

  /// Sepia reading theme option
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get labelThemeSepia;

  /// OLED pure pitch-black theme option
  ///
  /// In en, this message translates to:
  /// **'OLED Pitch-Black'**
  String get labelThemeOled;

  /// Title of the About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get titleAbout;

  /// Tooltip/label to open Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get labelOpenSettings;

  /// Tooltip/label to open About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get labelOpenAbout;

  /// Button to open a PDF via the system picker
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get labelOpenPdf;

  /// Header for the recent files list
  ///
  /// In en, this message translates to:
  /// **'Recent files'**
  String get titleRecentFiles;

  /// Empty state for the recents list
  ///
  /// In en, this message translates to:
  /// **'No recent files yet. Tap \"Open PDF\" to read one.'**
  String get emptyRecentFiles;

  /// Action to remove a recent file entry
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get labelRemoveFromRecents;

  /// Shown under a recent file that was deleted, moved, or can no longer be read by the app
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get descFileUnavailable;

  /// Generic open failure message
  ///
  /// In en, this message translates to:
  /// **'Could not open the file.'**
  String get errorOpenFailed;

  /// Message when a recent file cannot be reopened
  ///
  /// In en, this message translates to:
  /// **'This file could not be reopened. The app may no longer have permission to open it, or it was moved or deleted.'**
  String get errorReopenFailed;

  /// Title of the dialog shown when a recent file cannot be reopened
  ///
  /// In en, this message translates to:
  /// **'Can\'t reopen file'**
  String get titleReopenFailed;

  /// Explains why a recent file cannot be reopened and how to fix it
  ///
  /// In en, this message translates to:
  /// **'Files opened from another app with \"Open with\" can only be reopened until this app closes. Pick the file once more to keep it in the list.'**
  String get helpReopenFailed;

  /// Button that opens the system picker to find a recent file again
  ///
  /// In en, this message translates to:
  /// **'Find file'**
  String get labelFindFileAgain;

  /// Page count label for a recent file
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String descPageCount(int count);

  /// Continuous scroll view mode
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get labelViewModeContinuous;

  /// Single page view mode
  ///
  /// In en, this message translates to:
  /// **'Single page'**
  String get labelViewModeSingle;

  /// Two-page book view mode
  ///
  /// In en, this message translates to:
  /// **'Two pages'**
  String get labelViewModeBook;

  /// Tooltip for the view mode selector
  ///
  /// In en, this message translates to:
  /// **'View mode'**
  String get tooltipViewMode;

  /// Fit page to screen width
  ///
  /// In en, this message translates to:
  /// **'Fit width'**
  String get labelFitWidth;

  /// Fit whole page to screen
  ///
  /// In en, this message translates to:
  /// **'Fit page'**
  String get labelFitPage;

  /// Label for page fit options dialog
  ///
  /// In en, this message translates to:
  /// **'Page fit'**
  String get labelPageFit;

  /// Zoom in control
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get labelZoomIn;

  /// Zoom out control
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get labelZoomOut;

  /// Reset zoom to original scale
  ///
  /// In en, this message translates to:
  /// **'Reset zoom'**
  String get labelResetZoom;

  /// Toggle to invert page colors for night reading
  ///
  /// In en, this message translates to:
  /// **'Night colors'**
  String get labelInvertColors;

  /// Title of the table-of-contents drawer
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get titleContents;

  /// Shown when a PDF has no outline
  ///
  /// In en, this message translates to:
  /// **'This PDF has no contents.'**
  String get emptyOutline;

  /// Title of the thumbnail grid
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get titleThumbnails;

  /// Action/title to jump to a page number
  ///
  /// In en, this message translates to:
  /// **'Go to page'**
  String get labelGoToPage;

  /// Current page indicator
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String descPageOfPages(int current, int total);

  /// Hint for the page-number input
  ///
  /// In en, this message translates to:
  /// **'Page number'**
  String get labelPageNumberHint;

  /// Confirm jump to page
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get actionGo;

  /// Cancel a dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Title of the PDF password dialog
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get titlePassword;

  /// Body of the PDF password dialog
  ///
  /// In en, this message translates to:
  /// **'This PDF is protected. Enter its password to read it.'**
  String get bodyPassword;

  /// Hint for the password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPasswordHint;

  /// Confirm the password
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get actionUnlock;

  /// Retry opening the file
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionTryAgain;

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
  String get descLargeFileWarning;

  /// Loading label while the PDF opens
  ///
  /// In en, this message translates to:
  /// **'Opening…'**
  String get labelLoadingPdf;

  /// Affirmative value
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get labelYes;

  /// Title of the document details sheet
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get titleMetadata;

  /// Menu item that opens the details sheet
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get actionMetadata;

  /// Header for the file facts section
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get labelMetadataFileSection;

  /// File name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelMetadataFileName;

  /// File size label
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get labelMetadataFileSize;

  /// Header for the PDF's own fields
  ///
  /// In en, this message translates to:
  /// **'PDF details'**
  String get labelMetadataPdfSection;

  /// Shown when PDF details cannot be read
  ///
  /// In en, this message translates to:
  /// **'These details could not be read.'**
  String get errorMetadataUnavailable;

  /// Shown when the PDF has no description fields
  ///
  /// In en, this message translates to:
  /// **'This PDF does not describe itself.'**
  String get descMetadataNoFields;

  /// PDF title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get labelMetadataTitleField;

  /// PDF author field label
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get labelMetadataAuthor;

  /// PDF subject field label
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get labelMetadataSubject;

  /// PDF keywords field label
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get labelMetadataKeywords;

  /// PDF creator (source app) field label
  ///
  /// In en, this message translates to:
  /// **'Made with'**
  String get labelMetadataCreator;

  /// PDF producer field label
  ///
  /// In en, this message translates to:
  /// **'Saved by'**
  String get labelMetadataProducer;

  /// PDF creation date label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get labelMetadataCreated;

  /// PDF modification date label
  ///
  /// In en, this message translates to:
  /// **'Changed'**
  String get labelMetadataModified;

  /// Page count label
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get labelMetadataPages;

  /// PDF version label
  ///
  /// In en, this message translates to:
  /// **'PDF version'**
  String get labelMetadataPdfVersion;

  /// Shown when the PDF is encrypted
  ///
  /// In en, this message translates to:
  /// **'Password protected'**
  String get labelMetadataProtected;

  /// Tooltip for the search button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// Hint text in the search field
  ///
  /// In en, this message translates to:
  /// **'Search in this PDF'**
  String get labelSearchHint;

  /// Tooltip to leave search
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get labelSearchClose;

  /// Tooltip to clear the search text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get labelSearchClear;

  /// Tooltip to go to the next match
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get labelSearchNextMatch;

  /// Tooltip to go to the previous match
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get labelSearchPreviousMatch;

  /// Shown while the search runs
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get labelSearchSearching;

  /// Shown when a finished search found nothing
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get labelSearchNoMatches;

  /// Which match is showing, out of how many
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String labelSearchMatchOf(int current, int total);

  /// Shown when the search stopped at the match limit
  ///
  /// In en, this message translates to:
  /// **'Showing the first {count} matches. Try a longer word.'**
  String descSearchLimitReached(int count);

  /// Tooltip for the search options menu
  ///
  /// In en, this message translates to:
  /// **'Search options'**
  String get tooltipSearchOptions;

  /// Strict search mode option
  ///
  /// In en, this message translates to:
  /// **'Exact spelling'**
  String get labelSearchOptionStrict;

  /// Explains the strict search mode
  ///
  /// In en, this message translates to:
  /// **'Tell joined and unjoined spellings apart'**
  String get descSearchOptionStrictNote;

  /// Accent-insensitive search option
  ///
  /// In en, this message translates to:
  /// **'Ignore accent marks'**
  String get labelSearchOptionIgnoreAccents;

  /// Explains accent-insensitive search
  ///
  /// In en, this message translates to:
  /// **'Useful for Sanskrit chant accents'**
  String get descSearchOptionIgnoreAccentsNote;

  /// Sandhi compound search option
  ///
  /// In en, this message translates to:
  /// **'Sandhi compound search'**
  String get descSearchOptionSandhi;

  /// Explains Sandhi search mode
  ///
  /// In en, this message translates to:
  /// **'Find joined or split compound words (Malayalam & Sanskrit)'**
  String get descSearchOptionSandhiNote;

  /// Phonetic sound-alike search option
  ///
  /// In en, this message translates to:
  /// **'Phonetic matching'**
  String get labelSearchOptionPhonetic;

  /// Explains phonetic search mode
  ///
  /// In en, this message translates to:
  /// **'Match sound-alike letters, anusvara nasals, and chillu variations'**
  String get descSearchOptionPhoneticNote;

  /// Title of the scanned-PDF notice
  ///
  /// In en, this message translates to:
  /// **'No selectable text'**
  String get titleNoText;

  /// Body of the scanned-PDF notice
  ///
  /// In en, this message translates to:
  /// **'This PDF has no text layer, so it looks scanned. Search, copy, and read aloud are not available. This app does not read text from pictures.'**
  String get bodyNoText;

  /// Title of the garbled-extraction notice
  ///
  /// In en, this message translates to:
  /// **'Text unreadable'**
  String get titleGarbledText;

  /// Body of the garbled-extraction notice
  ///
  /// In en, this message translates to:
  /// **'This PDF\'s fonts do not say which letters they show, so search and read aloud would give wrong results. Reading the pages still works.'**
  String get bodyGarbledText;

  /// Why search is off for a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'Search needs selectable text, and this PDF has none.'**
  String get descSearchUnavailableNoText;

  /// Why search is off for a garbled PDF
  ///
  /// In en, this message translates to:
  /// **'Search is off because this PDF\'s text cannot be read properly.'**
  String get descSearchUnavailableGarbled;

  /// Title of the notice shown when a PDF text layer is probably not proper Unicode
  ///
  /// In en, this message translates to:
  /// **'Text may be wrong'**
  String get titleUnreliableText;

  /// Body of the notice shown when a PDF text layer is probably not proper Unicode (visual-order Indic text or an old font)
  ///
  /// In en, this message translates to:
  /// **'This PDF\'s text may not be stored as proper Unicode. Search and read aloud may miss words or read them wrongly. Reading the pages still works.'**
  String get bodyUnreliableText;

  /// Tooltip on the warning icon in the search bar for a PDF whose text is probably not proper Unicode
  ///
  /// In en, this message translates to:
  /// **'This PDF\'s text may not be proper Unicode, so some matches may be missing or wrong.'**
  String get descSearchUnreliable;

  /// Dismisses a notice
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get actionDismiss;

  /// Tooltip to start reading the page aloud
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get labelTtsReadAloud;

  /// Tooltip to pause reading
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get labelTtsPause;

  /// Tooltip to stop reading
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get labelTtsStop;

  /// Why read-aloud is off for a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'Read aloud needs selectable text, and this PDF has none.'**
  String get descTtsUnavailableNoText;

  /// Why read-aloud is off for a garbled PDF
  ///
  /// In en, this message translates to:
  /// **'Read aloud is off because this PDF\'s text cannot be read properly.'**
  String get descTtsUnavailableGarbled;

  /// Why read-aloud is off with no voice
  ///
  /// In en, this message translates to:
  /// **'No speech voice is installed on this device.'**
  String get descTtsUnavailableNoVoice;

  /// Shown when the page has no text to speak
  ///
  /// In en, this message translates to:
  /// **'There is nothing to read on this page.'**
  String get descTtsNothingToRead;

  /// Header for the read-aloud settings
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get labelSettingsReadAloud;

  /// The Malayalam TTS toggle
  ///
  /// In en, this message translates to:
  /// **'Malayalam voice'**
  String get labelSettingsMalayalamVoice;

  /// Malayalam voice is installed
  ///
  /// In en, this message translates to:
  /// **'Ready. Malayalam text will be read in Malayalam.'**
  String get descSettingsMalayalamVoiceReady;

  /// Malayalam toggle is off
  ///
  /// In en, this message translates to:
  /// **'Malayalam text is read with the English voice.'**
  String get descSettingsMalayalamVoiceOff;

  /// Malayalam voice needs installing
  ///
  /// In en, this message translates to:
  /// **'The Malayalam voice is not downloaded yet.'**
  String get descSettingsMalayalamVoiceNeedsInstall;

  /// Malayalam not supported at all
  ///
  /// In en, this message translates to:
  /// **'This device\'s speech engine does not offer Malayalam.'**
  String get errorSettingsMalayalamVoiceUnavailable;

  /// Still checking the voice
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get labelSettingsMalayalamVoiceChecking;

  /// Title of the guided-install sheet
  ///
  /// In en, this message translates to:
  /// **'Get Malayalam voice'**
  String get titleTtsInstall;

  /// Body of the guided-install sheet
  ///
  /// In en, this message translates to:
  /// **'This phone does not have the Malayalam voice yet. Try one of these:'**
  String get bodyTtsInstall;

  /// Opens the engine's voice download screen
  ///
  /// In en, this message translates to:
  /// **'Download voice data'**
  String get labelTtsInstallVoiceData;

  /// Opens the system TTS settings
  ///
  /// In en, this message translates to:
  /// **'Open speech settings'**
  String get labelTtsOpenTtsSettings;

  /// Opens the Play Store listing
  ///
  /// In en, this message translates to:
  /// **'Get Google speech services'**
  String get descTtsOpenPlayStore;

  /// What happens after installing
  ///
  /// In en, this message translates to:
  /// **'Come back here after installing — the setting turns on by itself once the voice is ready.'**
  String get descTtsInstallDoneNote;

  /// Shown when an install door does not exist
  ///
  /// In en, this message translates to:
  /// **'This phone could not open that screen.'**
  String get descTtsInstallCannotOpen;

  /// Auto-disable notice when the voice disappears
  ///
  /// In en, this message translates to:
  /// **'The Malayalam voice is no longer installed, so the setting was turned off.'**
  String get descTtsVoiceLostNotice;

  /// Title/action for extracting and converting PDF contents
  ///
  /// In en, this message translates to:
  /// **'Extract & Convert'**
  String get labelExtractAndConvert;

  /// Action to extract plain text
  ///
  /// In en, this message translates to:
  /// **'Extract text'**
  String get actionExtractText;

  /// Action to extract embedded images
  ///
  /// In en, this message translates to:
  /// **'Extract images'**
  String get actionExtractImages;

  /// Action to convert PDF pages to images
  ///
  /// In en, this message translates to:
  /// **'Convert to images'**
  String get actionConvertPdf;

  /// Action to read AcroForm fields
  ///
  /// In en, this message translates to:
  /// **'Form fields'**
  String get actionFormFields;

  /// Message when extraction completes successfully
  ///
  /// In en, this message translates to:
  /// **'Extraction successful'**
  String get descExtractionSuccess;

  /// Message when extraction fails
  ///
  /// In en, this message translates to:
  /// **'Extraction failed'**
  String get errorExtractionFailed;

  /// Message shown during extraction process
  ///
  /// In en, this message translates to:
  /// **'Extracting content…'**
  String get labelExtractingProgress;

  /// Page range option for all pages
  ///
  /// In en, this message translates to:
  /// **'All pages'**
  String get labelRangeAll;

  /// Page range option for the current page
  ///
  /// In en, this message translates to:
  /// **'Current page (Page {page})'**
  String descRangeCurrent(int page);

  /// Page range option for a custom range
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get labelRangeCustom;

  /// Label for the start page input field
  ///
  /// In en, this message translates to:
  /// **'Start page'**
  String get labelStartPage;

  /// Label for the end page input field
  ///
  /// In en, this message translates to:
  /// **'End page'**
  String get labelEndPage;

  /// Error shown on invalid page range
  ///
  /// In en, this message translates to:
  /// **'Invalid page range'**
  String get labelInvalidPageRange;

  /// Label for image format selector
  ///
  /// In en, this message translates to:
  /// **'Image format'**
  String get labelImageFormat;

  /// Label for resolution in DPI
  ///
  /// In en, this message translates to:
  /// **'Resolution: {dpi} DPI'**
  String descResolution(int dpi);

  /// Column header for field names
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get labelFieldsNameHeader;

  /// Column header for field values
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get labelFieldsValueHeader;

  /// Message shown when PDF has no AcroForm fields
  ///
  /// In en, this message translates to:
  /// **'No interactive form fields found in this PDF.'**
  String get emptyFormFieldsFound;

  /// Message when no embedded images are found in page range
  ///
  /// In en, this message translates to:
  /// **'No images were found in the selected range.'**
  String get emptyImagesFound;

  /// Generic share action button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// Action to share text/form as a file
  ///
  /// In en, this message translates to:
  /// **'Share as file'**
  String get actionShareFile;

  /// Action to copy text/fields to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get actionCopyClipboard;

  /// Toast message on successful copy
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get labelCopySuccess;

  /// Title of text preview dialog
  ///
  /// In en, this message translates to:
  /// **'Extracted text'**
  String get titlePreviewText;

  /// Title of form fields display dialog
  ///
  /// In en, this message translates to:
  /// **'Form fields'**
  String get titleFormFields;

  /// Menu entry and sheet title for page operations
  ///
  /// In en, this message translates to:
  /// **'Page tools'**
  String get titlePageTools;

  /// Action to merge several PDFs into one
  ///
  /// In en, this message translates to:
  /// **'Merge PDFs'**
  String get actionMerge;

  /// Subtitle for the merge action
  ///
  /// In en, this message translates to:
  /// **'Join this PDF with others into one new file'**
  String get descMerge;

  /// Success title after merging
  ///
  /// In en, this message translates to:
  /// **'PDFs merged'**
  String get titleMergeDone;

  /// Action to split a PDF into one file per page
  ///
  /// In en, this message translates to:
  /// **'Split into pages'**
  String get actionSplit;

  /// Subtitle for the split action
  ///
  /// In en, this message translates to:
  /// **'Make one new file for each page'**
  String get descSplit;

  /// Success title after splitting
  ///
  /// In en, this message translates to:
  /// **'PDF split'**
  String get titleSplitDone;

  /// Action to reorder, rotate, and delete pages
  ///
  /// In en, this message translates to:
  /// **'Organize pages'**
  String get actionOrganize;

  /// Subtitle for the organize action
  ///
  /// In en, this message translates to:
  /// **'Reorder, rotate, or delete pages'**
  String get descOrganize;

  /// App bar title of the organizer screen
  ///
  /// In en, this message translates to:
  /// **'Organize pages'**
  String get titleOrganize;

  /// Help text on the organizer screen
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder. Use the buttons to rotate or delete a page. Save writes a new file.'**
  String get helpOrganize;

  /// Success title after organizing pages
  ///
  /// In en, this message translates to:
  /// **'Pages organized'**
  String get titleOrganizeDone;

  /// Action to compress a PDF
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get actionCompress;

  /// Subtitle for the compress action
  ///
  /// In en, this message translates to:
  /// **'Make a smaller copy (best-effort)'**
  String get descCompress;

  /// Success title after compressing
  ///
  /// In en, this message translates to:
  /// **'PDF compressed'**
  String get titleCompressDone;

  /// Note explaining that compression is weak
  ///
  /// In en, this message translates to:
  /// **'Compression is best-effort. Already-optimized files may not shrink much.'**
  String get descCompressBestEffortNote;

  /// Action to add a password to a PDF
  ///
  /// In en, this message translates to:
  /// **'Add password'**
  String get actionProtect;

  /// Subtitle for the protect action
  ///
  /// In en, this message translates to:
  /// **'Add a password to a new copy'**
  String get descProtect;

  /// Title of the protect dialog
  ///
  /// In en, this message translates to:
  /// **'Protect PDF'**
  String get titleProtect;

  /// Success title after protecting
  ///
  /// In en, this message translates to:
  /// **'PDF protected'**
  String get titleProtectDone;

  /// Action to remove a PDF password
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
  String get actionRemovePassword;

  /// Subtitle for the unlock action
  ///
  /// In en, this message translates to:
  /// **'Make an unlocked copy (needs the current password)'**
  String get descUnlock;

  /// Title of the unlock dialog
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
  String get titleUnlock;

  /// Success title after unlocking
  ///
  /// In en, this message translates to:
  /// **'Password removed'**
  String get titleUnlockDone;

  /// Label for the open password field
  ///
  /// In en, this message translates to:
  /// **'Open password'**
  String get labelUserPassword;

  /// Label for the optional owner password field
  ///
  /// In en, this message translates to:
  /// **'Owner password'**
  String get labelOwnerPassword;

  /// Helper text for the owner password field
  ///
  /// In en, this message translates to:
  /// **'Controls printing and editing. Leave blank to match the open password.'**
  String get helpOwnerPassword;

  /// Label for the current password field when unlocking
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get labelCurrentPassword;

  /// Validation error when no password is entered
  ///
  /// In en, this message translates to:
  /// **'Please enter a password.'**
  String get errorPasswordRequired;

  /// Progress text shown while an operation runs
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get labelWorkingProgress;

  /// Generic failure message for a page operation
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get errorOpFailed;

  /// Action to save a file to a chosen location
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Message shown when saving fails
  ///
  /// In en, this message translates to:
  /// **'Could not save the file'**
  String get errorSaveFailed;

  /// Toast after a file is saved to a chosen location
  ///
  /// In en, this message translates to:
  /// **'Saved {name}'**
  String bodySavedFile(String name);

  /// Result dialog line for a single output file
  ///
  /// In en, this message translates to:
  /// **'New file: {name}'**
  String labelResultOneFile(String name);

  /// Result dialog line for many output files
  ///
  /// In en, this message translates to:
  /// **'{count} new files were created.'**
  String descResultManyFiles(int count);

  /// Label for a page row in the organizer
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String labelPage(int page);

  /// Shows how much a page is rotated
  ///
  /// In en, this message translates to:
  /// **'Rotated {degrees}°'**
  String labelRotatedBy(int degrees);

  /// Snackbar after a page is deleted in the organizer
  ///
  /// In en, this message translates to:
  /// **'Page {page} removed'**
  String bodyPageDeleted(int page);

  /// Undo a deletion
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// Rotate a page
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get actionRotate;

  /// Delete a page
  ///
  /// In en, this message translates to:
  /// **'Delete page'**
  String get actionDeletePage;

  /// Error when the user deletes every page
  ///
  /// In en, this message translates to:
  /// **'Keep at least one page.'**
  String get errorNoPagesLeft;

  /// Turn annotation mode on/off
  ///
  /// In en, this message translates to:
  /// **'Annotate'**
  String get actionAnnotate;

  /// Highlight text tool
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get labelAnnotationHighlight;

  /// Underline text tool
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get labelAnnotationUnderline;

  /// Strikethrough text tool
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get labelAnnotationStrikethrough;

  /// Freehand ink tool
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get labelAnnotationInk;

  /// Sticky note tool
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get descAnnotationNote;

  /// Erase a mark tool
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get labelAnnotationEraser;

  /// Remove every mark on the file
  ///
  /// In en, this message translates to:
  /// **'Clear all marks'**
  String get labelAnnotationClearAll;

  /// Write marks into a new PDF copy
  ///
  /// In en, this message translates to:
  /// **'Export annotated copy'**
  String get descAnnotationExport;

  /// Banner explaining overlay-only annotations
  ///
  /// In en, this message translates to:
  /// **'These marks are saved only inside this app. Export an annotated copy to keep them in the PDF.'**
  String get descAnnotationOverlayNotice;

  /// Shown when text markup is used on a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'This PDF has no selectable text to mark.'**
  String get errorAnnotationTextMarkupUnavailable;

  /// Progress while exporting annotations
  ///
  /// In en, this message translates to:
  /// **'Making an annotated copy…'**
  String get descAnnotationExporting;

  /// Export failure message
  ///
  /// In en, this message translates to:
  /// **'Could not export the annotated copy.'**
  String get errorAnnotationExportFailed;

  /// Export pressed with no marks
  ///
  /// In en, this message translates to:
  /// **'Add a mark first.'**
  String get descAnnotationNothingToExport;

  /// Confirm dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear all marks?'**
  String get titleAnnotationClearAll;

  /// Confirm dialog body
  ///
  /// In en, this message translates to:
  /// **'This removes every mark on this file. It cannot be undone.'**
  String get bodyAnnotationClearAll;

  /// Note editor title
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get titleNote;

  /// Note editor text field hint
  ///
  /// In en, this message translates to:
  /// **'Write your note'**
  String get labelNoteHint;

  /// Delete a mark or note
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Bookmarks panel title
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get titleBookmarks;

  /// Open the bookmarks panel
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get actionBookmarks;

  /// Empty bookmarks list
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet.'**
  String get emptyBookmarks;

  /// Add a bookmark on the current page
  ///
  /// In en, this message translates to:
  /// **'Bookmark page {page}'**
  String labelBookmarkAddCurrent(int page);

  /// Remove the bookmark on the current page
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark on page {page}'**
  String descBookmarkRemoveCurrent(int page);

  /// Label for a bookmark row
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String labelBookmarkPage(int page);

  /// Share sheet could not be opened
  ///
  /// In en, this message translates to:
  /// **'Could not share this file.'**
  String get errorShareFailed;

  /// Title of the screen for content shared into the app
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get titleImport;

  /// Progress while building a PDF from shared content
  ///
  /// In en, this message translates to:
  /// **'Making your PDF…'**
  String get labelImportBuilding;

  /// The shared content became a PDF
  ///
  /// In en, this message translates to:
  /// **'Your PDF is ready'**
  String get titleImportReady;

  /// How many shared pictures went into the PDF
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Made from 1 picture} other{Made from {count} pictures}}'**
  String descImportImagesSummary(int count);

  /// The PDF was built from shared text
  ///
  /// In en, this message translates to:
  /// **'Made from the text you shared.'**
  String get descImportTextSummary;

  /// Size of the built PDF
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String labelImportSize(String size);

  /// Save the built PDF to a chosen place
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get actionImportSave;

  /// Share the built PDF
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionImportShare;

  /// Confirmation after saving the built PDF
  ///
  /// In en, this message translates to:
  /// **'Saved {name}'**
  String labelImportSaved(String name);

  /// Building a PDF from shared content failed
  ///
  /// In en, this message translates to:
  /// **'PDF not created'**
  String get titleImportFailed;

  /// Shared text uses a script the PDF fonts do not cover
  ///
  /// In en, this message translates to:
  /// **'Unsupported letters'**
  String get titleImportUnsupportedText;

  /// Plain explanation of the Latin-1 font limit
  ///
  /// In en, this message translates to:
  /// **'This app can only write English letters and numbers into a PDF. Malayalam and other scripts are not supported yet. A picture of the text will save fine.'**
  String get descImportUnsupportedTextDetail;

  /// Open the print options
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get actionPrint;

  /// Title of the print sheet
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get titlePrint;

  /// Print every page
  ///
  /// In en, this message translates to:
  /// **'Whole document'**
  String get actionPrintWhole;

  /// Explains the whole-document print option
  ///
  /// In en, this message translates to:
  /// **'Print every page of this PDF.'**
  String get descPrintWhole;

  /// Print only some pages
  ///
  /// In en, this message translates to:
  /// **'Page range'**
  String get actionPrintRange;

  /// Explains the page-range print option
  ///
  /// In en, this message translates to:
  /// **'Choose which pages to print.'**
  String get descPrintRange;

  /// Print the text of the PDF, not the pages
  ///
  /// In en, this message translates to:
  /// **'Text only'**
  String get actionPrintText;

  /// Explains the text-only print option
  ///
  /// In en, this message translates to:
  /// **'Print the words of this PDF as plain pages.'**
  String get descPrintText;

  /// Title of the page-range dialog
  ///
  /// In en, this message translates to:
  /// **'Pages to print'**
  String get titlePrintRange;

  /// First page of the print range
  ///
  /// In en, this message translates to:
  /// **'From page'**
  String get labelPrintFrom;

  /// Last page of the print range
  ///
  /// In en, this message translates to:
  /// **'To page'**
  String get labelPrintTo;

  /// The typed print range is out of bounds or backwards
  ///
  /// In en, this message translates to:
  /// **'Enter a page range inside 1 to {pageCount}.'**
  String descPrintRangeInvalid(int pageCount);

  /// Progress while preparing a document to print
  ///
  /// In en, this message translates to:
  /// **'Getting the pages ready…'**
  String get descPrintPreparing;

  /// Printing is not supported on this device
  ///
  /// In en, this message translates to:
  /// **'This device cannot print.'**
  String get errorPrintUnavailable;

  /// Generic print failure
  ///
  /// In en, this message translates to:
  /// **'Could not start printing.'**
  String get errorPrintFailed;

  /// Text-only printing on a scanned PDF
  ///
  /// In en, this message translates to:
  /// **'This PDF has no text to print.'**
  String get descPrintNoText;

  /// Open the signatures screen from the viewer menu
  ///
  /// In en, this message translates to:
  /// **'Signatures'**
  String get actionSignatures;

  /// Title of the signatures screen
  ///
  /// In en, this message translates to:
  /// **'Signatures'**
  String get titleSignatures;

  /// Progress while signatures are verified
  ///
  /// In en, this message translates to:
  /// **'Checking signatures…'**
  String get labelSignaturesChecking;

  /// Empty state when a document has no signatures
  ///
  /// In en, this message translates to:
  /// **'This PDF is not signed.'**
  String get descSignaturesNone;

  /// The signature check itself failed — not the same as a bad signature
  ///
  /// In en, this message translates to:
  /// **'These signatures could not be checked.'**
  String get errorSignaturesFailed;

  /// Explains that a failed check is not a verdict
  ///
  /// In en, this message translates to:
  /// **'This does not mean the signatures are bad. It means the app could not read them, so it will not say either way.'**
  String get descSignaturesFailedDetail;

  /// Green tick state
  ///
  /// In en, this message translates to:
  /// **'Signed and trusted'**
  String get labelSignatureStatusTrusted;

  /// Explains the trusted state
  ///
  /// In en, this message translates to:
  /// **'The document has not changed since it was signed, and you trust the signer\'s certificate.'**
  String get descSignatureStatusTrustedDetail;

  /// Valid crypto, untrusted signer
  ///
  /// In en, this message translates to:
  /// **'Signed, but signer unknown'**
  String get descSignatureStatusValidNotTrusted;

  /// Explains the valid-not-trusted state
  ///
  /// In en, this message translates to:
  /// **'The document has not changed since it was signed. But the app does not know the signer, so it cannot vouch for who they are.'**
  String get descSignatureStatusValidNotTrustedDetail;

  /// Red state
  ///
  /// In en, this message translates to:
  /// **'Signature is not valid'**
  String get descSignatureStatusInvalid;

  /// Explains the invalid state
  ///
  /// In en, this message translates to:
  /// **'The document changed after it was signed, or the signature does not match. Do not rely on it.'**
  String get descSignatureStatusInvalidDetail;

  /// Grey state
  ///
  /// In en, this message translates to:
  /// **'Signature could not be read'**
  String get descSignatureStatusUnknown;

  /// Explains the unknown state
  ///
  /// In en, this message translates to:
  /// **'The app could not make sense of this signature, so it will not say whether it is good or bad.'**
  String get descSignatureStatusUnknownDetail;

  /// Short label for the partial-coverage note
  ///
  /// In en, this message translates to:
  /// **'Covers only part of the file'**
  String get descSignatureNotePartialCoverage;

  /// Explains partial coverage in plain words
  ///
  /// In en, this message translates to:
  /// **'Something was added to this file after it was signed. The signature says nothing about that part.'**
  String get descSignatureNotePartialCoverageDetail;

  /// Short label for a revoked certificate
  ///
  /// In en, this message translates to:
  /// **'The certificate was cancelled'**
  String get descSignatureNoteRevoked;

  /// Explains revocation
  ///
  /// In en, this message translates to:
  /// **'Whoever issued this certificate has since cancelled it. It should not be trusted.'**
  String get descSignatureNoteRevokedDetail;

  /// Short label when revocation was not checked
  ///
  /// In en, this message translates to:
  /// **'Could not check if the certificate was cancelled'**
  String get descSignatureNoteRevocationNotChecked;

  /// Explains why revocation was not checked, offline-first
  ///
  /// In en, this message translates to:
  /// **'Checking that needs the internet, which this app never uses, and this PDF does not carry the proof inside it.'**
  String get descSignatureNoteRevocationNotCheckedDetail;

  /// Short label for expired-at-signing
  ///
  /// In en, this message translates to:
  /// **'The certificate had expired when it signed'**
  String get descSignatureNoteCertExpired;

  /// Explains expired-at-signing
  ///
  /// In en, this message translates to:
  /// **'The signing certificate was outside its valid dates at the time of signing.'**
  String get descSignatureNoteCertExpiredDetail;

  /// Short label for an unverified signing time
  ///
  /// In en, this message translates to:
  /// **'The signing time is only a claim'**
  String get descSignatureNoteUnverifiedTime;

  /// Explains why a signing time may not be trustworthy
  ///
  /// In en, this message translates to:
  /// **'This time is stored outside the signed part of the file, so anyone could have changed it.'**
  String get descSignatureNoteUnverifiedTimeDetail;

  /// Label for the signer name
  ///
  /// In en, this message translates to:
  /// **'Signed by'**
  String get labelSignatureSigner;

  /// Shown when the signature carries no signer name
  ///
  /// In en, this message translates to:
  /// **'Not stated'**
  String get labelSignatureSignerUnknown;

  /// Label for the signing time
  ///
  /// In en, this message translates to:
  /// **'Signed on'**
  String get labelSignatureSignedAt;

  /// Label for the stated reason for signing
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get labelSignatureReason;

  /// Label for the stated signing location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get labelSignatureLocation;

  /// Title of the certificate details section
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get titleSignatureCertificate;

  /// Certificate subject
  ///
  /// In en, this message translates to:
  /// **'Issued to'**
  String get labelSignatureIssuedTo;

  /// Certificate issuer
  ///
  /// In en, this message translates to:
  /// **'Issued by'**
  String get labelSignatureIssuedBy;

  /// Certificate start date
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get labelSignatureValidFrom;

  /// Certificate end date
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get labelSignatureValidUntil;

  /// Explains a self-signed certificate without implying it is fake
  ///
  /// In en, this message translates to:
  /// **'This certificate vouches for itself. Nobody else backs it, so trust it only if you know the signer.'**
  String get descSignatureSelfSignedNote;

  /// Button to add the signer's certificate to the trust store
  ///
  /// In en, this message translates to:
  /// **'Trust certificate'**
  String get actionSignatureTrust;

  /// Title of the trust confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Trust this signer?'**
  String get titleSignatureTrust;

  /// Explains what trusting a certificate means before the user does it
  ///
  /// In en, this message translates to:
  /// **'From now on, any PDF signed with this certificate will show as trusted. Only do this if you know who the signer is.'**
  String get descSignatureTrustExplain;

  /// Confirm button of the trust dialog
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get labelSignatureTrustConfirm;

  /// Shown after a certificate is added to the trust store
  ///
  /// In en, this message translates to:
  /// **'Certificate trusted.'**
  String get descSignatureTrustedToast;

  /// Title of the trust store screen
  ///
  /// In en, this message translates to:
  /// **'Trusted certificates'**
  String get titleTrustStore;

  /// Empty state of the trust store screen
  ///
  /// In en, this message translates to:
  /// **'You have not trusted any certificates yet.'**
  String get emptyTrustStore;

  /// Explains the trust store
  ///
  /// In en, this message translates to:
  /// **'When you trust a signer\'s certificate, it is listed here. You can remove it at any time.'**
  String get descTrustStoreEmptyDetail;

  /// Pick a certificate file to trust
  ///
  /// In en, this message translates to:
  /// **'Add a certificate'**
  String get actionTrustStoreAdd;

  /// Remove a certificate from the trust store
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionTrustStoreRemove;

  /// Title of the remove confirmation
  ///
  /// In en, this message translates to:
  /// **'Stop trusting?'**
  String get titleTrustStoreRemove;

  /// Explains what removing a certificate does
  ///
  /// In en, this message translates to:
  /// **'PDFs signed with it will stop showing as trusted.'**
  String get descTrustStoreRemoveExplain;

  /// The picked file could not be parsed as a certificate
  ///
  /// In en, this message translates to:
  /// **'That file is not a certificate the app can read.'**
  String get descTrustStoreInvalidFile;

  /// Warning shown for an expired certificate in the trust store
  ///
  /// In en, this message translates to:
  /// **'This certificate has expired.'**
  String get descTrustStoreExpiredWarning;

  /// Action to crop blank page margins
  ///
  /// In en, this message translates to:
  /// **'Trim margins'**
  String get actionTrimMargins;

  /// Title of the smart margin trim dialog
  ///
  /// In en, this message translates to:
  /// **'Smart Margin Trim'**
  String get titleTrimMargins;

  /// Description of smart margin trimming
  ///
  /// In en, this message translates to:
  /// **'Crops blank page margins for mobile reading.'**
  String get descTrimMargins;

  /// Progress message while trimming margins
  ///
  /// In en, this message translates to:
  /// **'Trimming blank page margins…'**
  String get descTrimMarginsWorking;

  /// Title shown when margin trim succeeds
  ///
  /// In en, this message translates to:
  /// **'Margins trimmed'**
  String get titleTrimMarginsDone;

  /// Note on trimmed PDF result
  ///
  /// In en, this message translates to:
  /// **'Blank margins cropped to fit mobile screens.'**
  String get descTrimMarginsDoneNote;

  /// Label for margin padding selector
  ///
  /// In en, this message translates to:
  /// **'Margin padding'**
  String get labelTrimPadding;

  /// Tight padding option
  ///
  /// In en, this message translates to:
  /// **'Tight (4 pt)'**
  String get labelTrimPaddingTight;

  /// Standard padding option
  ///
  /// In en, this message translates to:
  /// **'Standard (12 pt)'**
  String get labelTrimPaddingStandard;

  /// Comfortable padding option
  ///
  /// In en, this message translates to:
  /// **'Comfortable (24 pt)'**
  String get labelTrimPaddingComfortable;

  /// Label for symmetric margin toggle
  ///
  /// In en, this message translates to:
  /// **'Symmetric margins'**
  String get labelTrimSymmetric;

  /// Help text for symmetric margin toggle
  ///
  /// In en, this message translates to:
  /// **'Keeps left and right margins balanced.'**
  String get helpTrimSymmetric;

  /// Action to create a foldable booklet
  ///
  /// In en, this message translates to:
  /// **'Create booklet'**
  String get actionBooklet;

  /// Title of the booklet imposition dialog
  ///
  /// In en, this message translates to:
  /// **'Foldable booklet'**
  String get titleBooklet;

  /// Description of booklet imposition
  ///
  /// In en, this message translates to:
  /// **'Generates a 2-Up foldable booklet imposition layout for double-sided printing.'**
  String get descBooklet;

  /// Progress message while generating booklet
  ///
  /// In en, this message translates to:
  /// **'Generating booklet layout…'**
  String get descBookletWorking;

  /// Title shown when booklet generation succeeds
  ///
  /// In en, this message translates to:
  /// **'Booklet generated'**
  String get titleBookletDone;

  /// Printing and folding advice for generated booklet
  ///
  /// In en, this message translates to:
  /// **'Print double-sided (flip on short edge) and fold in half along the center spine.'**
  String get descBookletDoneNote;

  /// Title for booklet plan summary card
  ///
  /// In en, this message translates to:
  /// **'Booklet layout'**
  String get titleBookletSummary;

  /// Page count mapping in booklet summary
  ///
  /// In en, this message translates to:
  /// **'{source} original pages -> {padded} booklet pages'**
  String descBookletSummaryPages(int source, int padded);

  /// Sheet and face count in booklet summary
  ///
  /// In en, this message translates to:
  /// **'{sheets, plural, =1{1 physical landscape sheet} other{{sheets} physical landscape sheets}} ({faces} printable sides)'**
  String descBookletSummarySheets(int sheets, int faces);

  /// Blank page count in booklet summary
  ///
  /// In en, this message translates to:
  /// **'{blanks, plural, =1{1 blank filler page added at end} other{{blanks} blank filler pages added at end}}'**
  String descBookletSummaryBlanks(int blanks);

  /// Label for binding direction selector
  ///
  /// In en, this message translates to:
  /// **'Binding direction'**
  String get labelBookletBinding;

  /// LTR binding direction option
  ///
  /// In en, this message translates to:
  /// **'Left to Right (LTR)'**
  String get labelBookletBindingLtr;

  /// RTL binding direction option
  ///
  /// In en, this message translates to:
  /// **'Right to Left (RTL)'**
  String get labelBookletBindingRtl;

  /// Label for booklet sheet size selector
  ///
  /// In en, this message translates to:
  /// **'Paper size'**
  String get labelBookletPaperSize;

  /// Auto paper size option
  ///
  /// In en, this message translates to:
  /// **'Match source'**
  String get labelBookletPaperAuto;

  /// A4 landscape paper size option
  ///
  /// In en, this message translates to:
  /// **'A4 Landscape'**
  String get labelBookletPaperA4;

  /// US Letter landscape paper size option
  ///
  /// In en, this message translates to:
  /// **'US Letter'**
  String get labelBookletPaperLetter;

  /// Label for fold line guideline switch
  ///
  /// In en, this message translates to:
  /// **'Center fold guide'**
  String get labelBookletFoldGuide;

  /// Help text for fold line guideline switch
  ///
  /// In en, this message translates to:
  /// **'Draws a faint dotted guideline showing where to fold the booklet.'**
  String get helpBookletFoldGuide;

  /// Title of the Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get titleAppearance;

  /// Subtitle of the Appearance card
  ///
  /// In en, this message translates to:
  /// **'Theme mode, typography, and colors'**
  String get descAppearanceSubtitle;

  /// Title of the Theme mode section
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get titleThemeMode;

  /// Subtitle of the Theme mode card
  ///
  /// In en, this message translates to:
  /// **'Choose between Light, Dark, System, or Sepia mode'**
  String get descThemeModeSubtitle;

  /// Brief subtitle for the theme mode card
  ///
  /// In en, this message translates to:
  /// **'Select Light, Dark, or System'**
  String get descThemeModeCardSubtitle;

  /// Information explaining theme modes
  ///
  /// In en, this message translates to:
  /// **'System mode automatically follows your device\'s system-wide dark mode setting. Sepia mode provides a warm, eye-comfort reading background.'**
  String get descThemeMode;

  /// Title of Typography & Text Size section
  ///
  /// In en, this message translates to:
  /// **'Fonts & text size'**
  String get titleTypography;

  /// Subtitle for Typography & Text Size card
  ///
  /// In en, this message translates to:
  /// **'App font family and text size'**
  String get descTypographySubtitle;

  /// Description of typography settings
  ///
  /// In en, this message translates to:
  /// **'Customize the app font family and reading text size for better readability across screens.'**
  String get descTypography;

  /// Label for font family picker
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get labelTypographyFont;

  /// Label for text size segmented button
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get labelTypographyTextSize;

  /// Default system font family
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get labelFontSystemDefault;

  /// Manjari font family
  ///
  /// In en, this message translates to:
  /// **'Manjari'**
  String get labelFontManjari;

  /// Anek Malayalam font family
  ///
  /// In en, this message translates to:
  /// **'Anek Malayalam'**
  String get labelFontAnekMalayalam;

  /// Noto Sans Malayalam font family
  ///
  /// In en, this message translates to:
  /// **'Noto Sans Malayalam'**
  String get labelFontNotoSansMalayalam;

  /// Small text size label
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get labelTextSizeSmall;

  /// Default text size label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get labelTextSizeDefault;

  /// Large text size label
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get labelTextSizeLarge;

  /// Larger text size label
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get labelTextSizeLarger;

  /// Latin sample text for typography preview
  ///
  /// In en, this message translates to:
  /// **'The quick brown fox 0123'**
  String get descTypographySampleLatin;

  /// Malayalam sample text for typography preview
  ///
  /// In en, this message translates to:
  /// **'മലയാളം സുന്ദരമാണ്'**
  String get labelTypographySampleMalayalam;

  /// Title of the Accent color screen
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get titleAccentColor;

  /// Subtitle of the Accent color card
  ///
  /// In en, this message translates to:
  /// **'Presets, color wheel, live preview'**
  String get descAccentColorSubtitle;

  /// Note telling which theme the edited accent applies to.
  ///
  /// In en, this message translates to:
  /// **'This color is used while the app is in light mode.'**
  String get descAccentAppliesToLight;

  /// Note telling which theme the edited accent applies to.
  ///
  /// In en, this message translates to:
  /// **'This color is used while the app is in dark mode.'**
  String get descAccentAppliesToDark;

  /// Live preview section label
  ///
  /// In en, this message translates to:
  /// **'LIVE PREVIEW'**
  String get labelLivePreview;

  /// Sample text on preview chip
  ///
  /// In en, this message translates to:
  /// **'Sample text'**
  String get labelSampleText;

  /// Presets section label
  ///
  /// In en, this message translates to:
  /// **'PRESETS'**
  String get labelPresets;

  /// Custom color wheel label
  ///
  /// In en, this message translates to:
  /// **'CUSTOM COLOR WHEEL'**
  String get labelCustomColorWheel;

  /// Button to reset color
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get labelResetToDefault;

  /// Button to reset Light theme accent
  ///
  /// In en, this message translates to:
  /// **'Reset Light to default'**
  String get descResetLightToDefault;

  /// Button to reset Dark theme accent
  ///
  /// In en, this message translates to:
  /// **'Reset Dark to default'**
  String get descResetDarkToDefault;

  /// Notice for automatic contrast adjustment
  ///
  /// In en, this message translates to:
  /// **'Text contrast is adjusted automatically for readability.'**
  String get descContrastNotice;

  /// Title of the Permissions screen
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get titlePermissions;

  /// Subtitle of the Permissions card
  ///
  /// In en, this message translates to:
  /// **'Storage, virtual print service and privacy capabilities'**
  String get descPermissionsSubtitle;

  /// Tooltip to open system app settings
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get labelPermissionsOpenSettings;

  /// Header for explicit system capabilities
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get labelPermissionsExplicitHeader;

  /// Subtitle for explicit capabilities
  ///
  /// In en, this message translates to:
  /// **'Features and system roles designed for safe document access.'**
  String get descPermissionsExplicitSubtitle;

  /// Header for implicit privacy items
  ///
  /// In en, this message translates to:
  /// **'Privacy & System Declarations'**
  String get descPermissionsImplicitHeader;

  /// Subtitle for implicit declarations
  ///
  /// In en, this message translates to:
  /// **'Declared in the manifest; all processing stays on this phone.'**
  String get descPermissionsImplicitSubtitle;

  /// Title for scoped storage
  ///
  /// In en, this message translates to:
  /// **'Scoped Storage (SAF)'**
  String get titlePermScopedStorage;

  /// Reason for scoped storage
  ///
  /// In en, this message translates to:
  /// **'Open and save documents securely via the Android system file picker without broad device storage permissions.'**
  String get descPermScopedStorageReason;

  /// Title for virtual print service
  ///
  /// In en, this message translates to:
  /// **'Virtual printer'**
  String get titlePermPrintService;

  /// Reason for virtual print service
  ///
  /// In en, this message translates to:
  /// **'Allows other Android apps to print documents directly to Folio.'**
  String get descPermPrintServiceReason;

  /// Title for offline guarantee
  ///
  /// In en, this message translates to:
  /// **'Private, no internet'**
  String get titlePermOffline;

  /// Reason for offline guarantee
  ///
  /// In en, this message translates to:
  /// **'No internet use. Your documents leave this phone only when you send them to your other phone with Device sync.'**
  String get descPermOfflineReason;

  /// Title for TTS query
  ///
  /// In en, this message translates to:
  /// **'Speech engine'**
  String get titlePermTts;

  /// Reason for TTS query
  ///
  /// In en, this message translates to:
  /// **'Queries installed speech engines for reading documents aloud in English and Malayalam.'**
  String get descPermTtsReason;

  /// Title for process text capability
  ///
  /// In en, this message translates to:
  /// **'Process Text Action'**
  String get titlePermProcessText;

  /// Reason for process text capability
  ///
  /// In en, this message translates to:
  /// **'Enables quick searching and text actions when selecting text in other applications.'**
  String get descPermProcessTextReason;

  /// Status badge for active feature
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get labelStatusActive;

  /// Status badge for system-managed item
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get labelStatusSystem;

  /// Status badge for offline guarantee
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get labelStatusOffline;

  /// Subtitle for trust store card
  ///
  /// In en, this message translates to:
  /// **'Manage digital signature root certificates'**
  String get descTrustStoreSubtitle;

  /// Subtitle for about card
  ///
  /// In en, this message translates to:
  /// **'App version, licenses, and legal info'**
  String get descAboutSubtitle;

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
  /// **'On Android, virtual print services are managed at the system level. To enable Folio as a system-wide printer:'**
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
  /// **'Under Print services, find Folio (or your app\'s name).'**
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
  /// **'Standard Android printing can sometimes garble complex scripts (such as Malayalam, Hindi, or Sanskrit), resulting in broken chillu characters, disconnected conjuncts, or missing fonts. Folio handles complex script shaping and font embedding to generate pristine PDFs.'**
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
  /// **'Select \'Folio\' as the target printer instead of the standard Android \'Save as PDF\'.'**
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
  /// **'Folio verifies digital signatures completely offline using cryptographic algorithms (SHA-256 digests and X.509 certificate chains) with zero network requests.'**
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
  /// **'No internet servers, and Scoped Storage security'**
  String get helpPrivacyStorageSubtitle;

  /// Header for Privacy & Storage guide
  ///
  /// In en, this message translates to:
  /// **'No-Internet Privacy Guarantee'**
  String get helpPrivacyStorageTopicHeader;

  /// Intro explanation for Privacy & Storage
  ///
  /// In en, this message translates to:
  /// **'Your privacy is paramount. Folio never connects to the internet. Its only network use is Device sync, directly between your own phones on local WiFi.'**
  String get helpPrivacyStorageIntro;

  /// Step 1 for Privacy & Storage
  ///
  /// In en, this message translates to:
  /// **'No internet: Folio never contacts an internet server and collects no analytics. The INTERNET permission is used only by Device sync on your local WiFi, and only while that screen is open.'**
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
  String get titleLanguage;

  /// Subtitle of Language settings card
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get descLanguageSubtitle;

  /// Option to follow system language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get labelLanguageSystem;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get labelLanguageEnglish;

  /// Malayalam language option
  ///
  /// In en, this message translates to:
  /// **'മലയാളം (Malayalam)'**
  String get labelLanguageMalayalam;

  /// Sanskrit language option
  ///
  /// In en, this message translates to:
  /// **'संस्कृतम् (Sanskrit)'**
  String get labelLanguageSanskrit;

  /// Heading for language selection
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get titleLanguageSelect;

  /// Description for language selection
  ///
  /// In en, this message translates to:
  /// **'Changes apply immediately across the entire application.'**
  String get descLanguageSelectSubtitle;

  /// Title of Reader settings screen
  ///
  /// In en, this message translates to:
  /// **'Reader & Viewer'**
  String get titleReaderSettings;

  /// Subtitle of Reader settings card
  ///
  /// In en, this message translates to:
  /// **'Reading position, layout, zoom, and display'**
  String get descReaderSettingsSubtitle;

  /// Title for saving reading position
  ///
  /// In en, this message translates to:
  /// **'Remember position'**
  String get titleSaveLastPosition;

  /// Subtitle for saving reading position
  ///
  /// In en, this message translates to:
  /// **'Automatically resume from the last viewed page and zoom level'**
  String get descSaveLastPositionSubtitle;

  /// Title for default page layout setting
  ///
  /// In en, this message translates to:
  /// **'Default Page Layout'**
  String get titleDefaultPageLayout;

  /// Subtitle for default page layout setting
  ///
  /// In en, this message translates to:
  /// **'Choose how pages are presented when opening documents'**
  String get descDefaultPageLayoutSubtitle;

  /// Continuous vertical scrolling option
  ///
  /// In en, this message translates to:
  /// **'Continuous Scroll'**
  String get labelLayoutContinuous;

  /// Single page horizontal swiping option
  ///
  /// In en, this message translates to:
  /// **'Single Page'**
  String get labelLayoutSinglePage;

  /// Title for double-tap zoom setting
  ///
  /// In en, this message translates to:
  /// **'Double-Tap Zoom'**
  String get titleDoubleTapZoom;

  /// Subtitle for double-tap zoom setting
  ///
  /// In en, this message translates to:
  /// **'Action performed on double-tapping a PDF page'**
  String get descDoubleTapZoomSubtitle;

  /// Fit to width zoom option
  ///
  /// In en, this message translates to:
  /// **'Fit to Width'**
  String get labelZoomFitWidth;

  /// 200% zoom option
  ///
  /// In en, this message translates to:
  /// **'Zoom to 200%'**
  String get labelZoom200;

  /// Title for page indicator toggle
  ///
  /// In en, this message translates to:
  /// **'Page indicator'**
  String get titleShowPageIndicator;

  /// Subtitle for page indicator toggle
  ///
  /// In en, this message translates to:
  /// **'Display page indicator pill overlay while reading'**
  String get descShowPageIndicatorSubtitle;

  /// Title for PDF color inversion
  ///
  /// In en, this message translates to:
  /// **'Invert PDF Colors'**
  String get titleInvertColors;

  /// Subtitle for PDF color inversion
  ///
  /// In en, this message translates to:
  /// **'Inverts document colors for night-time reading'**
  String get descInvertColorsSubtitle;

  /// Title of TTS settings screen
  ///
  /// In en, this message translates to:
  /// **'Read Aloud (TTS)'**
  String get titleTtsSettings;

  /// Subtitle of TTS settings card
  ///
  /// In en, this message translates to:
  /// **'Voice, speech speed, pitch, and playback options'**
  String get descTtsSettingsSubtitle;

  /// Title for speech speed slider
  ///
  /// In en, this message translates to:
  /// **'Speech Rate'**
  String get titleTtsSpeechRate;

  /// Speech speed display
  ///
  /// In en, this message translates to:
  /// **'{rate}x speed'**
  String descTtsSpeechRateSubtitle(String rate);

  /// Title for speech pitch slider
  ///
  /// In en, this message translates to:
  /// **'Voice Pitch'**
  String get titleTtsPitch;

  /// Speech pitch display
  ///
  /// In en, this message translates to:
  /// **'{pitch}x pitch'**
  String descTtsPitchSubtitle(String pitch);

  /// Title for auto-scroll toggle during TTS
  ///
  /// In en, this message translates to:
  /// **'Scroll with speech'**
  String get titleTtsAutoScroll;

  /// Subtitle for auto-scroll toggle during TTS
  ///
  /// In en, this message translates to:
  /// **'Automatically scroll the document as sentences are spoken'**
  String get descTtsAutoScrollSubtitle;

  /// Title of PDF Printer settings screen
  ///
  /// In en, this message translates to:
  /// **'PDF Virtual Printer'**
  String get titlePrinterSettings;

  /// Subtitle of PDF Printer settings card
  ///
  /// In en, this message translates to:
  /// **'Print service integration, paper size, and cache'**
  String get descPrinterSettingsSubtitle;

  /// Title for virtual printer toggle
  ///
  /// In en, this message translates to:
  /// **'Enable PDF printer'**
  String get titlePrinterEnable;

  /// Subtitle for virtual printer toggle
  ///
  /// In en, this message translates to:
  /// **'Accept print jobs from other apps and save them as PDF'**
  String get descPrinterEnableSubtitle;

  /// Title for default paper size
  ///
  /// In en, this message translates to:
  /// **'Default Paper Size'**
  String get titleDefaultPaperSize;

  /// Subtitle for default paper size
  ///
  /// In en, this message translates to:
  /// **'Default page dimensions for generated PDFs'**
  String get descDefaultPaperSizeSubtitle;

  /// Title for default color mode
  ///
  /// In en, this message translates to:
  /// **'Default Color Mode'**
  String get titleDefaultColorMode;

  /// Subtitle for default color mode
  ///
  /// In en, this message translates to:
  /// **'Color output for printed documents'**
  String get descDefaultColorModeSubtitle;

  /// Full color option
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get labelColorModeColor;

  /// Grayscale option
  ///
  /// In en, this message translates to:
  /// **'Grayscale'**
  String get labelColorModeGrayscale;

  /// Monochrome option
  ///
  /// In en, this message translates to:
  /// **'Monochrome (Black & White)'**
  String get descColorModeMonochrome;

  /// Title for default orientation
  ///
  /// In en, this message translates to:
  /// **'Default Orientation'**
  String get titleDefaultOrientation;

  /// Subtitle for default orientation
  ///
  /// In en, this message translates to:
  /// **'Page orientation for print jobs'**
  String get descDefaultOrientationSubtitle;

  /// Auto orientation option
  ///
  /// In en, this message translates to:
  /// **'Auto (Match Source)'**
  String get labelOrientationAuto;

  /// Portrait orientation option
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get labelOrientationPortrait;

  /// Landscape orientation option
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get labelOrientationLandscape;

  /// Title for clearing printer cache
  ///
  /// In en, this message translates to:
  /// **'Clear Printer Cache'**
  String get titleClearPrinterCache;

  /// Subtitle for clearing printer cache
  ///
  /// In en, this message translates to:
  /// **'Purge temporary PDF spool files ({size})'**
  String descClearPrinterCacheSubtitle(String size);

  /// Notification when printer cache is cleared
  ///
  /// In en, this message translates to:
  /// **'Printer cache cleared.'**
  String get descPrinterCacheCleared;

  /// Title of Storage & Privacy settings screen
  ///
  /// In en, this message translates to:
  /// **'Storage & Privacy'**
  String get titleStorageSettings;

  /// Subtitle of Storage & Privacy settings card
  ///
  /// In en, this message translates to:
  /// **'Recent files history and cache cleanup'**
  String get descStorageSettingsSubtitle;

  /// Title for remember recent files toggle
  ///
  /// In en, this message translates to:
  /// **'Remember recents'**
  String get titleRememberRecentFiles;

  /// Subtitle for remember recent files toggle
  ///
  /// In en, this message translates to:
  /// **'Save opened documents to the recents list on Home'**
  String get descRememberRecentFilesSubtitle;

  /// Title for clearing recent files history
  ///
  /// In en, this message translates to:
  /// **'Clear recent files'**
  String get titleClearRecentFiles;

  /// Subtitle for clearing recent files history
  ///
  /// In en, this message translates to:
  /// **'Remove all opened document records and saved positions'**
  String get descClearRecentFilesSubtitle;

  /// Confirmation title for clearing recents
  ///
  /// In en, this message translates to:
  /// **'Clear recent files?'**
  String get titleClearRecentFilesConfirm;

  /// Confirmation message for clearing recents
  ///
  /// In en, this message translates to:
  /// **'This will clear your recent files list and reading progress. The original PDF files on your device will NOT be deleted.'**
  String get bodyClearRecentFilesConfirm;

  /// Button to confirm clearing recents
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get actionClearRecentFiles;

  /// Notification when recents are cleared
  ///
  /// In en, this message translates to:
  /// **'Recent files history cleared.'**
  String get descRecentFilesCleared;

  /// Title for clearing all app cache
  ///
  /// In en, this message translates to:
  /// **'Clear App Cache'**
  String get titleClearTempCache;

  /// Subtitle for clearing app cache
  ///
  /// In en, this message translates to:
  /// **'Free up temporary space without losing data ({size})'**
  String descClearTempCacheSubtitle(String size);

  /// Notification when app cache is cleared
  ///
  /// In en, this message translates to:
  /// **'Temporary cache cleared.'**
  String get descTempCacheCleared;

  /// Title for Security & Signatures card
  ///
  /// In en, this message translates to:
  /// **'Signatures & Trust'**
  String get titleSecuritySettings;

  /// Subtitle for Security & Signatures card
  ///
  /// In en, this message translates to:
  /// **'Digital signature verification and custom certificates'**
  String get descSecuritySettingsSubtitle;

  /// Title for auto-verify signatures toggle
  ///
  /// In en, this message translates to:
  /// **'Auto signature check'**
  String get titleAutoVerifySignatures;

  /// Subtitle for auto-verify signatures toggle
  ///
  /// In en, this message translates to:
  /// **'Automatically check digital signatures when opening signed PDFs'**
  String get descAutoVerifySignaturesSubtitle;

  /// Title for FileProvider capability
  ///
  /// In en, this message translates to:
  /// **'Secure File Provider'**
  String get titlePermFileProvider;

  /// Reason for FileProvider
  ///
  /// In en, this message translates to:
  /// **'Shares temporary PDFs and extracted files with external apps without exposing private file paths.'**
  String get descPermFileProviderReason;

  /// What FileProvider achieves
  ///
  /// In en, this message translates to:
  /// **'Enables safe sharing and printing of PDFs to external apps without compromising storage security.'**
  String get descPermFileProviderWhatItAchieves;

  /// Title for TTS voice data installer query
  ///
  /// In en, this message translates to:
  /// **'Voice Data Installer'**
  String get titlePermTtsInstall;

  /// Reason for TTS voice data installer query
  ///
  /// In en, this message translates to:
  /// **'Opens system voice package download screens if required language voices are missing.'**
  String get descPermTtsInstallReason;

  /// What TTS installer achieves
  ///
  /// In en, this message translates to:
  /// **'Enables guided installation of Malayalam and English speech voices without dead-ends.'**
  String get descPermTtsInstallWhatItAchieves;

  /// Title for Send/Share intent filter
  ///
  /// In en, this message translates to:
  /// **'Receive shares'**
  String get titlePermSendShare;

  /// Reason for Send/Share intent filter
  ///
  /// In en, this message translates to:
  /// **'Receives images, plain text, and PDF files shared from other applications.'**
  String get descPermSendShareReason;

  /// What Send/Share intent achieves
  ///
  /// In en, this message translates to:
  /// **'Enables direct conversion of shared images and text into PDFs and opening PDFs from any app.'**
  String get descPermSendShareWhatItAchieves;

  /// Title for zero internet guarantee
  ///
  /// In en, this message translates to:
  /// **'No internet servers'**
  String get titlePermZeroInternet;

  /// Reason for zero internet guarantee
  ///
  /// In en, this message translates to:
  /// **'Folio never contacts an internet server. Its only network use is Device sync between your own phones on local WiFi.'**
  String get descPermZeroInternetReason;

  /// What zero internet achieves
  ///
  /// In en, this message translates to:
  /// **'Guarantees complete privacy with zero data leakage, tracking, or remote telemetry.'**
  String get descPermZeroInternetWhatItAchieves;

  /// What scoped storage achieves
  ///
  /// In en, this message translates to:
  /// **'Allows reading and saving PDFs selected by the user while keeping the rest of the device private.'**
  String get descPermScopedStorageWhatItAchieves;

  /// What print service achieves
  ///
  /// In en, this message translates to:
  /// **'Allows other Android apps to send print jobs directly to Folio to save as PDF.'**
  String get descPermPrintServiceWhatItAchieves;

  /// What offline guarantee achieves
  ///
  /// In en, this message translates to:
  /// **'Ensures document contents and personal information never leave your device.'**
  String get descPermOfflineWhatItAchieves;

  /// What TTS engine query achieves
  ///
  /// In en, this message translates to:
  /// **'Discovers installed speech engines to read documents aloud in English and Malayalam.'**
  String get descPermTtsWhatItAchieves;

  /// What process text achieves
  ///
  /// In en, this message translates to:
  /// **'Allows selected text in any app to be processed or searched directly in Folio.'**
  String get descPermProcessTextWhatItAchieves;

  /// Header for permission reason
  ///
  /// In en, this message translates to:
  /// **'Why it is needed'**
  String get labelPermWhyNeededHeader;

  /// Header for what permission achieves
  ///
  /// In en, this message translates to:
  /// **'What this achieves'**
  String get labelPermWhatItAchievesHeader;

  /// Badge for explicit permission
  ///
  /// In en, this message translates to:
  /// **'Explicit Capability'**
  String get labelPermTypeExplicit;

  /// Badge for implicit permission
  ///
  /// In en, this message translates to:
  /// **'Implicit / System Query'**
  String get descPermTypeImplicit;

  /// Badge for privacy guarantee
  ///
  /// In en, this message translates to:
  /// **'Privacy Guarantee'**
  String get labelPermTypePrivacy;

  /// Header for privacy guarantees section
  ///
  /// In en, this message translates to:
  /// **'Privacy & Zero-Permission Guarantees'**
  String get descPermissionsPrivacyHeader;

  /// Subtitle for privacy guarantees section
  ///
  /// In en, this message translates to:
  /// **'Dangerous permissions intentionally omitted from the manifest.'**
  String get descPermissionsPrivacySubtitle;

  /// Title for BIND_PRINT_SERVICE permission
  ///
  /// In en, this message translates to:
  /// **'BIND_PRINT_SERVICE'**
  String get titlePermBindPrintService;

  /// Reason for BIND_PRINT_SERVICE permission
  ///
  /// In en, this message translates to:
  /// **'Guards the Virtual Print Service so only the Android system print spooler can bind to it.'**
  String get descPermBindPrintServiceReason;

  /// What BIND_PRINT_SERVICE permission achieves
  ///
  /// In en, this message translates to:
  /// **'Ensures untrusted third-party apps cannot invoke the print service or intercept spooled documents.'**
  String get descPermBindPrintServiceWhatItAchieves;

  /// Title for app store and web queries
  ///
  /// In en, this message translates to:
  /// **'Store & web links'**
  String get titlePermStoreQueries;

  /// Reason for app store and web queries
  ///
  /// In en, this message translates to:
  /// **'Queries Google Play Store and browser activities via market:// and https:// intent schemes.'**
  String get descPermStoreQueriesReason;

  /// What app store and web queries achieve
  ///
  /// In en, this message translates to:
  /// **'Enables direct installation of speech engines (such as Speech Services by Google) if missing.'**
  String get descPermStoreQueriesWhatItAchieves;

  /// Title for PDF VIEW intent filter
  ///
  /// In en, this message translates to:
  /// **'Default PDF viewer'**
  String get titlePermViewPdf;

  /// Reason for PDF VIEW intent filter
  ///
  /// In en, this message translates to:
  /// **'Registers the app as a handler for PDF MIME types and file extensions.'**
  String get descPermViewPdfReason;

  /// What PDF VIEW intent filter achieves
  ///
  /// In en, this message translates to:
  /// **'Allows opening PDF files directly from file managers, email attachments, and downloads.'**
  String get descPermViewPdfWhatItAchieves;

  /// Title for Android print framework integration
  ///
  /// In en, this message translates to:
  /// **'Android printing'**
  String get titlePermPrintManager;

  /// Reason for Android print framework integration
  ///
  /// In en, this message translates to:
  /// **'Communicates with Android\'s system PrintManager and print spooler.'**
  String get descPermPrintManagerReason;

  /// What Android print framework integration achieves
  ///
  /// In en, this message translates to:
  /// **'Sends formatted PDF pages to physical printers and system print preview dialogs.'**
  String get descPermPrintManagerWhatItAchieves;

  /// Title for zero broad storage guarantee
  ///
  /// In en, this message translates to:
  /// **'No broad storage'**
  String get titlePermNoBroadStorage;

  /// Reason for zero broad storage guarantee
  ///
  /// In en, this message translates to:
  /// **'No READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, or MANAGE_EXTERNAL_STORAGE permissions are requested.'**
  String get descPermNoBroadStorageReason;

  /// What zero broad storage guarantee achieves
  ///
  /// In en, this message translates to:
  /// **'Ensures all other photos, documents, and private data on your device remain completely inaccessible.'**
  String get descPermNoBroadStorageWhatItAchieves;

  /// Title for reading velocity section
  ///
  /// In en, this message translates to:
  /// **'Reading speed'**
  String get titleReadingVelocity;

  /// Subtitle for reading velocity section
  ///
  /// In en, this message translates to:
  /// **'Calculates remaining reading time based on your reading speed'**
  String get descReadingVelocitySubtitle;

  /// Reading speed in words per minute
  ///
  /// In en, this message translates to:
  /// **'{wpm} wpm'**
  String labelReadingSpeed(int wpm);

  /// Remaining reading time in current chapter
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left in chapter'**
  String descReadingTimeLeftChapter(int minutes);

  /// Remaining reading time in document
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String labelReadingTimeLeftDoc(int minutes);

  /// Less than a minute left to read
  ///
  /// In en, this message translates to:
  /// **'< 1 min left'**
  String get labelReadingTimeLessMinute;

  /// Toggle to show remaining reading time
  ///
  /// In en, this message translates to:
  /// **'Reading Time Estimates'**
  String get descReadingTimeEstimatesToggle;

  /// Subtitle for reading time estimate toggle
  ///
  /// In en, this message translates to:
  /// **'Display remaining chapter and document reading time in the reader bar'**
  String get descReadingTimeEstimatesToggleSubtitle;

  /// Automatic responsive view mode option
  ///
  /// In en, this message translates to:
  /// **'Auto (Dual-page on wide / foldables)'**
  String get descViewModeAuto;

  /// Description for auto responsive view mode
  ///
  /// In en, this message translates to:
  /// **'Single-page on phones; dual-page book view on foldables and tablets'**
  String get descViewModeAutoSubtitle;

  /// Title for Malayalam transliteration input helper
  ///
  /// In en, this message translates to:
  /// **'Malayalam keyboard'**
  String get titleMalayalamHelper;

  /// Tooltip for Malayalam input helper button
  ///
  /// In en, this message translates to:
  /// **'Malayalam typing'**
  String get tooltipMalayalamHelper;

  /// Manglish transliteration tab label
  ///
  /// In en, this message translates to:
  /// **'Manglish'**
  String get labelMalayalamKeypadTabTranslit;

  /// Malayalam vowels tab label
  ///
  /// In en, this message translates to:
  /// **'Vowels'**
  String get labelMalayalamKeypadTabVowels;

  /// Malayalam consonants tab label
  ///
  /// In en, this message translates to:
  /// **'Consonants'**
  String get labelMalayalamKeypadTabConsonants;

  /// Malayalam signs and chillu letters tab label
  ///
  /// In en, this message translates to:
  /// **'Signs & Chillu'**
  String get labelMalayalamKeypadTabSigns;

  /// Title for sentence pause setting
  ///
  /// In en, this message translates to:
  /// **'Sentence pause'**
  String get titleTtsSentencePause;

  /// Subtitle for sentence pause setting
  ///
  /// In en, this message translates to:
  /// **'{seconds}s pause between sentences'**
  String descTtsSentencePauseSubtitle(String seconds);

  /// TTS currently reading a page
  ///
  /// In en, this message translates to:
  /// **'Reading page {page}...'**
  String descTtsReadingPage(int page);

  /// TTS playback paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get labelTtsPaused;

  /// TTS ready to read a page
  ///
  /// In en, this message translates to:
  /// **'Ready to read page {page}'**
  String descTtsReadyToRead(int page);

  /// Menu title for applying watermark
  ///
  /// In en, this message translates to:
  /// **'Custom watermark'**
  String get actionWatermark;

  /// Menu description for watermark
  ///
  /// In en, this message translates to:
  /// **'Add text or image watermark onto pages'**
  String get descWatermark;

  /// Title of watermark dialog
  ///
  /// In en, this message translates to:
  /// **'Custom Watermark'**
  String get titleWatermarkDialog;

  /// Label for watermark text input
  ///
  /// In en, this message translates to:
  /// **'Watermark Text'**
  String get labelWatermarkText;

  /// Error when watermark text is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter watermark text.'**
  String get errorWatermarkEmptyText;

  /// Title when watermarked PDF is done
  ///
  /// In en, this message translates to:
  /// **'Watermark added'**
  String get titleWatermarkDone;

  /// Label for opacity slider
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get labelWatermarkOpacity;

  /// Label for rotation slider
  ///
  /// In en, this message translates to:
  /// **'Rotation Angle'**
  String get labelWatermarkRotation;

  /// Label for font size slider
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get labelWatermarkFontSize;

  /// Label for color selection
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get labelWatermarkColor;

  /// Switch label for tiled watermark
  ///
  /// In en, this message translates to:
  /// **'Tile across page'**
  String get labelWatermarkTiled;

  /// Description for tiled watermark
  ///
  /// In en, this message translates to:
  /// **'Repeats watermark pattern across entire page'**
  String get descWatermarkTiled;

  /// Dropdown label for page range
  ///
  /// In en, this message translates to:
  /// **'Apply to'**
  String get labelWatermarkPageRange;

  /// All pages option
  ///
  /// In en, this message translates to:
  /// **'All pages'**
  String get labelWatermarkAllPages;

  /// Odd pages option
  ///
  /// In en, this message translates to:
  /// **'Odd pages only'**
  String get labelWatermarkOddPages;

  /// Even pages option
  ///
  /// In en, this message translates to:
  /// **'Even pages only'**
  String get labelWatermarkEvenPages;

  /// Button to apply watermark
  ///
  /// In en, this message translates to:
  /// **'Apply Watermark'**
  String get actionWatermarkApply;

  /// Title for batch operations
  ///
  /// In en, this message translates to:
  /// **'Batch Operations'**
  String get titleBatchOperations;

  /// Description for batch operations
  ///
  /// In en, this message translates to:
  /// **'Process multiple PDF files at once'**
  String get descBatchOperations;

  /// Label for batch operation dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Operation'**
  String get labelBatchOperation;

  /// Batch encrypt option
  ///
  /// In en, this message translates to:
  /// **'Batch Encrypt / Protect'**
  String get descBatchOpEncrypt;

  /// Batch merge option
  ///
  /// In en, this message translates to:
  /// **'Batch Merge'**
  String get labelBatchOpMerge;

  /// Batch extract text option
  ///
  /// In en, this message translates to:
  /// **'Batch Extract Text (.txt)'**
  String get descBatchOpExtractText;

  /// Batch trim margins option
  ///
  /// In en, this message translates to:
  /// **'Batch Trim Margins'**
  String get labelBatchOpTrimMargins;

  /// Batch compress option
  ///
  /// In en, this message translates to:
  /// **'Batch Compress'**
  String get labelBatchOpCompress;

  /// Header for count of selected batch files
  ///
  /// In en, this message translates to:
  /// **'Selected Files ({count})'**
  String descBatchSelectedFilesCount(int count);

  /// Button to add more files to batch
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get actionBatchAddFiles;

  /// Empty state for batch files
  ///
  /// In en, this message translates to:
  /// **'No PDF files selected. Tap Add Files to select PDFs.'**
  String get descBatchNoFilesSelected;

  /// Progress label for batch operation
  ///
  /// In en, this message translates to:
  /// **'Processing {current} of {total}: {name}'**
  String descBatchProgress(int current, int total, String name);

  /// Button to start batch operation
  ///
  /// In en, this message translates to:
  /// **'Start batch'**
  String get actionBatchStart;

  /// Summary note after batch operation completes
  ///
  /// In en, this message translates to:
  /// **'Successfully processed {success} of {total} documents.'**
  String descBatchDoneSummary(int success, int total);

  /// Error when all batch files failed
  ///
  /// In en, this message translates to:
  /// **'Batch processing failed for all documents.'**
  String get descBatchFailedAll;

  /// Title for N-Up multi-page layout
  ///
  /// In en, this message translates to:
  /// **'Pages per sheet'**
  String get actionNUp;

  /// Description for N-Up layout
  ///
  /// In en, this message translates to:
  /// **'Fit 2, 4, 6, or 9 pages onto each sheet'**
  String get descNUp;

  /// Title of N-Up dialog
  ///
  /// In en, this message translates to:
  /// **'Pages per sheet'**
  String get titleNUpDialog;

  /// Label for grid layout selector
  ///
  /// In en, this message translates to:
  /// **'Grid Layout'**
  String get labelNUpGrid;

  /// Label for sheet size
  ///
  /// In en, this message translates to:
  /// **'Sheet Size'**
  String get labelNUpSheetSize;

  /// A4 sheet size
  ///
  /// In en, this message translates to:
  /// **'A4'**
  String get labelNUpSheetA4;

  /// US Letter sheet size
  ///
  /// In en, this message translates to:
  /// **'US Letter'**
  String get labelNUpSheetLetter;

  /// Label for sheet orientation
  ///
  /// In en, this message translates to:
  /// **'Sheet Orientation'**
  String get labelNUpOrientation;

  /// Auto orientation
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get labelNUpOrientationAuto;

  /// Portrait orientation
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get labelNUpOrientationPortrait;

  /// Landscape orientation
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get labelNUpOrientationLandscape;

  /// Label for border lines toggle
  ///
  /// In en, this message translates to:
  /// **'Draw Page Borders'**
  String get labelNUpBorders;

  /// Description for border lines toggle
  ///
  /// In en, this message translates to:
  /// **'Draws subtle grid boundary line around each page slot'**
  String get descNUpBorders;

  /// Label for margin slider
  ///
  /// In en, this message translates to:
  /// **'Margin Padding'**
  String get labelNUpMargin;

  /// Title when N-Up PDF is created
  ///
  /// In en, this message translates to:
  /// **'N-up PDF created'**
  String get titleNUpDone;

  /// Action to print N-Up layout
  ///
  /// In en, this message translates to:
  /// **'Print N-up'**
  String get actionPrintNUp;

  /// Description for print N-Up
  ///
  /// In en, this message translates to:
  /// **'Print multiple pages per sheet (2-in-1, 4-in-1, etc.)'**
  String get descPrintNUp;

  /// Switch title for web content cleaner
  ///
  /// In en, this message translates to:
  /// **'Clean web pages'**
  String get titleCleanWebContent;

  /// Switch subtitle for web content cleaner
  ///
  /// In en, this message translates to:
  /// **'Removes headers, footers, sidebars, scripts, and ads before saving'**
  String get descCleanWebContentSubtitle;

  /// Notice for multiple pages deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page deleted} other{{count} pages deleted}}'**
  String descPagesDeletedCount(int count);

  /// Selected count in organizer
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String descOrganizeSelectedCount(int count);

  /// Select all pages action
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get actionSelectAll;

  /// Deselect all pages action
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get actionDeselectAll;

  /// Invert page selection action
  ///
  /// In en, this message translates to:
  /// **'Invert'**
  String get actionInvertSelection;

  /// Action to export a certificate
  ///
  /// In en, this message translates to:
  /// **'Export Certificate'**
  String get actionTrustStoreExport;

  /// Action to export all certificates
  ///
  /// In en, this message translates to:
  /// **'Export all'**
  String get actionTrustStoreExportAll;

  /// Toast when certificate export succeeds
  ///
  /// In en, this message translates to:
  /// **'Certificate exported to {name}'**
  String descTrustStoreExportSuccess(String name);

  /// Action to trust signer certificate
  ///
  /// In en, this message translates to:
  /// **'Trust Signer'**
  String get actionSignatureTrustSigner;

  /// Label for unnamed signature
  ///
  /// In en, this message translates to:
  /// **'Digital Signature'**
  String get labelSignatureUnnamed;

  /// Label for signature time
  ///
  /// In en, this message translates to:
  /// **'Signing Time'**
  String get labelSignatureTime;

  /// Note when signing time is a claim
  ///
  /// In en, this message translates to:
  /// **'unverified claim'**
  String get labelSignatureTimeClaimOnly;

  /// Label for document integrity
  ///
  /// In en, this message translates to:
  /// **'Document Integrity'**
  String get labelSignatureIntegrity;

  /// Integrity valid description
  ///
  /// In en, this message translates to:
  /// **'Document unmodified since signing'**
  String get descSignatureIntegrityValid;

  /// Integrity invalid description
  ///
  /// In en, this message translates to:
  /// **'Document modified after signing'**
  String get descSignatureIntegrityInvalid;

  /// Integrity unknown description
  ///
  /// In en, this message translates to:
  /// **'Integrity could not be verified'**
  String get descSignatureIntegrityUnknown;

  /// Label for byte coverage
  ///
  /// In en, this message translates to:
  /// **'Byte Coverage'**
  String get labelSignatureCoverage;

  /// Whole document coverage description
  ///
  /// In en, this message translates to:
  /// **'Signature covers the entire document'**
  String get descSignatureCoversWholeFile;

  /// Partial document coverage description
  ///
  /// In en, this message translates to:
  /// **'Signature covers only part of the document'**
  String get descSignatureCoversPartialFile;

  /// Header for signer certificate section
  ///
  /// In en, this message translates to:
  /// **'Signer Certificate Details'**
  String get descSignatureCertificateHeader;

  /// Title of the Features screen and Settings card
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get titleFeatures;

  /// Subtitle for Features card in settings
  ///
  /// In en, this message translates to:
  /// **'Explore all features of Folio'**
  String get descFeaturesSubtitle;

  /// Header title of the Features screen
  ///
  /// In en, this message translates to:
  /// **'App features'**
  String get titleFeaturesHeader;

  /// Header subtitle of the Features screen
  ///
  /// In en, this message translates to:
  /// **'Explore every intelligent tool, privacy safeguard, and PDF feature designed for you.'**
  String get descFeaturesHeaderSubtitle;

  /// Category title for viewing features
  ///
  /// In en, this message translates to:
  /// **'PDF Viewing & Navigation Engine'**
  String get descFeaturesCategoryViewing;

  /// Category subtitle for viewing features
  ///
  /// In en, this message translates to:
  /// **'High-performance rendering, continuous scrolling, book view, and smart navigation'**
  String get descFeaturesCategoryViewingSubtitle;

  /// Category title for search and speech features
  ///
  /// In en, this message translates to:
  /// **'Search, Indic Phonetics & Speech'**
  String get descFeaturesCategorySearch;

  /// Category subtitle for search and speech features
  ///
  /// In en, this message translates to:
  /// **'Sandhi-aware Indic search, Malayalam transliteration, and text-to-speech'**
  String get descFeaturesCategorySearchSubtitle;

  /// Category title for annotations
  ///
  /// In en, this message translates to:
  /// **'Annotation Overlay & Markups'**
  String get descFeaturesCategoryAnnotations;

  /// Category subtitle for annotations
  ///
  /// In en, this message translates to:
  /// **'Non-destructive markups, ink drawing, notes, and PDF flattening'**
  String get descFeaturesCategoryAnnotationsSubtitle;

  /// Category title for page operations
  ///
  /// In en, this message translates to:
  /// **'Page Operations & Reorganization'**
  String get descFeaturesCategoryPageOps;

  /// Category subtitle for page operations
  ///
  /// In en, this message translates to:
  /// **'Visual page organizer, booklet imposition, watermarks, and batch tools'**
  String get descFeaturesCategoryPageOpsSubtitle;

  /// Category title for data extraction
  ///
  /// In en, this message translates to:
  /// **'Data Extraction & Utilities'**
  String get descFeaturesCategoryExtraction;

  /// Category subtitle for data extraction
  ///
  /// In en, this message translates to:
  /// **'Extract plain text, embedded images, form fields, and metadata'**
  String get descFeaturesCategoryExtractionSubtitle;

  /// Category title for printer and importer
  ///
  /// In en, this message translates to:
  /// **'Virtual Printer & Share Hub'**
  String get descFeaturesCategoryPrinter;

  /// Category subtitle for printer and importer
  ///
  /// In en, this message translates to:
  /// **'System-wide virtual PDF printer, web cleaner, and image/text conversion'**
  String get descFeaturesCategoryPrinterSubtitle;

  /// Category title for signatures
  ///
  /// In en, this message translates to:
  /// **'Digital Signatures & Trust Store'**
  String get descFeaturesCategorySignatures;

  /// Category subtitle for signatures
  ///
  /// In en, this message translates to:
  /// **'Native cryptographic verification, visual stamp badges, and custom trust store'**
  String get descFeaturesCategorySignaturesSubtitle;

  /// Category title for themes
  ///
  /// In en, this message translates to:
  /// **'Themes & Customization'**
  String get descFeaturesCategoryThemes;

  /// Category subtitle for themes
  ///
  /// In en, this message translates to:
  /// **'OLED dark mode, custom typography, HSV accent color picker, and settings hubs'**
  String get descFeaturesCategoryThemesSubtitle;

  /// Category title for help guides
  ///
  /// In en, this message translates to:
  /// **'Built-In User Guides'**
  String get labelFeaturesCategoryGuides;

  /// Category subtitle for help guides
  ///
  /// In en, this message translates to:
  /// **'Comprehensive offline tutorials and troubleshooting guides'**
  String get descFeaturesCategoryGuidesSubtitle;

  /// Header title of the Help screen
  ///
  /// In en, this message translates to:
  /// **'Help Center & Knowledge Base'**
  String get helpHeaderTitle;

  /// Header subtitle of the Help screen
  ///
  /// In en, this message translates to:
  /// **'Browse in-depth guides and solutions for all features of Folio.'**
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

  /// Label for the version row on the About screen
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get labelAboutVersion;

  /// Label for the build date row on the About screen
  ///
  /// In en, this message translates to:
  /// **'Build date'**
  String get labelAboutBuildDate;

  /// PNG option in the page-image export format picker
  ///
  /// In en, this message translates to:
  /// **'PNG (Lossless)'**
  String get labelImageFormatPngLossless;

  /// JPEG option in the page-image export format picker
  ///
  /// In en, this message translates to:
  /// **'JPEG'**
  String get labelImageFormatJpeg;

  /// N-up grid option label, e.g. 2-in-1 means two pages on one sheet
  ///
  /// In en, this message translates to:
  /// **'{count}-in-1'**
  String labelNUpPagesPerSheet(int count);

  /// Allowed page-number range shown under the go-to-page input
  ///
  /// In en, this message translates to:
  /// **'{min} – {max}'**
  String labelPageJumpRangeHint(int min, int max);

  /// Label for author detail on About screen
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get aboutDetailAuthor;

  /// Label for email detail on About screen
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutDetailEmail;

  /// Label for license detail on About screen
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get aboutDetailLicense;

  /// Label for AI used detail on About screen
  ///
  /// In en, this message translates to:
  /// **'AI used'**
  String get aboutDetailAiUsed;

  /// Label for IDE used detail on About screen
  ///
  /// In en, this message translates to:
  /// **'IDE used'**
  String get aboutDetailIdeUsed;

  /// About-screen signature badge. {heart} is a red heart glyph.
  ///
  /// In en, this message translates to:
  /// **'Made with {heart} from India'**
  String madeWithLove(String heart);

  /// Screen-reader text for the About badge
  ///
  /// In en, this message translates to:
  /// **'Made with love from India'**
  String get madeWithLoveA11y;

  /// Tooltip for the options popup menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get tooltipMenu;

  /// Tooltip for showing password in plain text
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get tooltipShowPassword;

  /// Tooltip for hiding password
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get tooltipHidePassword;

  /// Yellow color name
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get labelColorYellow;

  /// Green color name
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get labelColorGreen;

  /// Blue color name
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get labelColorBlue;

  /// Red color name
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get labelColorRed;

  /// Purple color name
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get labelColorPurple;

  /// Orange color name
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get labelColorOrange;

  /// Version and build number display on About screen
  ///
  /// In en, this message translates to:
  /// **'{version} (build {build})'**
  String descAboutVersionBuild(String version, String build);

  /// Close action button or tooltip
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Remove action button or tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// Tooltip for rotate screen button
  ///
  /// In en, this message translates to:
  /// **'Rotate screen'**
  String get tooltipRotateScreen;

  /// Title for screen orientation setting
  ///
  /// In en, this message translates to:
  /// **'Screen Orientation'**
  String get titleScreenOrientation;

  /// Message on the safe fallback shown in release builds when a part of a screen fails to build. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on this screen. Please go back and try again.'**
  String get errorScreenFallback;

  /// Error shown when a picked file is not a readable certificate. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'This file is not a certificate the app can read.'**
  String get errorInvalidCertificate;

  /// Error shown when exporting a trusted certificate fails. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'Could not export the certificate.'**
  String get errorCertificateExport;

  /// Error shown when the trust store list cannot be read. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'Could not load the trusted certificates.'**
  String get errorTrustStoreLoad;

  /// Detail under 'Could not make the PDF' when building a PDF from shared pictures or text fails. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while making the PDF. Please try again.'**
  String get errorImportBuild;

  /// Features screen: name of the "High-Performance Rendering" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'High-Performance Rendering'**
  String get helpFeatureRenderingTitle;

  /// Features screen: what the "High-Performance Rendering" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Fast, crisp PDF page rendering powered by native pdfium engine with zero network overhead.'**
  String get helpFeatureRenderingBody;

  /// Features screen: highlight chip 1 of the "High-Performance Rendering" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'pdfium Engine'**
  String get helpFeatureRenderingTag1;

  /// Features screen: highlight chip 2 of the "High-Performance Rendering" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Crisp Scaling'**
  String get helpFeatureRenderingTag2;

  /// Features screen: highlight chip 3 of the "High-Performance Rendering" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Offline Fast'**
  String get helpFeatureRenderingTag3;

  /// Features screen: name of the "Flexible Viewing & Fit Modes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Flexible Viewing & Fit Modes'**
  String get helpFeatureViewModesTitle;

  /// Features screen: what the "Flexible Viewing & Fit Modes" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Switch between Single Page, Continuous Vertical Scrolling, and Two-Page Book view with Fit to Width or Fit to Page options.'**
  String get helpFeatureViewModesBody;

  /// Features screen: highlight chip 1 of the "Flexible Viewing & Fit Modes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Single Page'**
  String get helpFeatureViewModesTag1;

  /// Features screen: highlight chip 2 of the "Flexible Viewing & Fit Modes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Continuous Scroll'**
  String get helpFeatureViewModesTag2;

  /// Features screen: highlight chip 3 of the "Flexible Viewing & Fit Modes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Book View'**
  String get helpFeatureViewModesTag3;

  /// Features screen: highlight chip 4 of the "Flexible Viewing & Fit Modes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Fit Modes'**
  String get helpFeatureViewModesTag4;

  /// Features screen: name of the "Foldable & Dual-Screen Support" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Foldable & Dual-Screen Support'**
  String get helpFeatureFoldableTitle;

  /// Features screen: what the "Foldable & Dual-Screen Support" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Adaptive dual-page layout on foldable devices and tablets with display hinge gap spacing.'**
  String get helpFeatureFoldableBody;

  /// Features screen: highlight chip 1 of the "Foldable & Dual-Screen Support" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Foldable Aware'**
  String get helpFeatureFoldableTag1;

  /// Features screen: highlight chip 2 of the "Foldable & Dual-Screen Support" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Hinge Gap'**
  String get helpFeatureFoldableTag2;

  /// Features screen: highlight chip 3 of the "Foldable & Dual-Screen Support" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Tablet Optimized'**
  String get helpFeatureFoldableTag3;

  /// Features screen: name of the "Reading Velocity & Time Estimates" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Reading Velocity & Time Estimates'**
  String get helpFeatureVelocityTitle;

  /// Features screen: what the "Reading Velocity & Time Estimates" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Tracks reading speed in real time to calculate remaining reading time for chapters and the entire document.'**
  String get helpFeatureVelocityBody;

  /// Features screen: highlight chip 1 of the "Reading Velocity & Time Estimates" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'WPM Tracking'**
  String get helpFeatureVelocityTag1;

  /// Features screen: highlight chip 2 of the "Reading Velocity & Time Estimates" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Chapter Estimates'**
  String get helpFeatureVelocityTag2;

  /// Features screen: highlight chip 3 of the "Reading Velocity & Time Estimates" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get helpFeatureVelocityTag3;

  /// Features screen: name of the "Thumbnail Grid & Direct Jump" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail Grid & Direct Jump'**
  String get helpFeatureThumbnailsTitle;

  /// Features screen: what the "Thumbnail Grid & Direct Jump" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Quickly preview all document pages in an interactive grid or jump directly to any page number.'**
  String get helpFeatureThumbnailsBody;

  /// Features screen: highlight chip 1 of the "Thumbnail Grid & Direct Jump" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail Grid'**
  String get helpFeatureThumbnailsTag1;

  /// Features screen: highlight chip 2 of the "Thumbnail Grid & Direct Jump" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Page Slider'**
  String get helpFeatureThumbnailsTag2;

  /// Features screen: highlight chip 3 of the "Thumbnail Grid & Direct Jump" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Quick Jump'**
  String get helpFeatureThumbnailsTag3;

  /// Features screen: name of the "Document Outline & Bookmarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Document Outline & Bookmarks'**
  String get helpFeatureOutlineTitle;

  /// Features screen: what the "Document Outline & Bookmarks" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Browse document table of contents hierarchies with one-tap section jumping and page bookmarking.'**
  String get helpFeatureOutlineBody;

  /// Features screen: highlight chip 1 of the "Document Outline & Bookmarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'TOC Hierarchy'**
  String get helpFeatureOutlineTag1;

  /// Features screen: highlight chip 2 of the "Document Outline & Bookmarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'1-Tap Jump'**
  String get helpFeatureOutlineTag2;

  /// Features screen: highlight chip 3 of the "Document Outline & Bookmarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Page Bookmarks'**
  String get helpFeatureOutlineTag3;

  /// Features screen: name of the "Content Fingerprinting & Recents" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Content Fingerprinting & Recents'**
  String get helpFeatureFingerprintTitle;

  /// Features screen: what the "Content Fingerprinting & Recents" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'SHA-256 fingerprinting preserves reading positions, zoom, and annotations even if files are renamed or moved.'**
  String get helpFeatureFingerprintBody;

  /// Features screen: highlight chip 1 of the "Content Fingerprinting & Recents" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'SHA-256 Fingerprint'**
  String get helpFeatureFingerprintTag1;

  /// Features screen: highlight chip 2 of the "Content Fingerprinting & Recents" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Last Read State'**
  String get helpFeatureFingerprintTag2;

  /// Features screen: highlight chip 3 of the "Content Fingerprinting & Recents" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Recent Files'**
  String get helpFeatureFingerprintTag3;

  /// Features screen: name of the "On-Page Full-Text Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'On-Page Full-Text Search'**
  String get helpFeatureSearchTitle;

  /// Features screen: what the "On-Page Full-Text Search" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Instant keyword search with match counting, bright highlight overlays, and grapheme-aligned navigation.'**
  String get helpFeatureSearchBody;

  /// Features screen: highlight chip 1 of the "On-Page Full-Text Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Instant Search'**
  String get helpFeatureSearchTag1;

  /// Features screen: highlight chip 2 of the "On-Page Full-Text Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Match Counter'**
  String get helpFeatureSearchTag2;

  /// Features screen: highlight chip 3 of the "On-Page Full-Text Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Grapheme Alignment'**
  String get helpFeatureSearchTag3;

  /// Features screen: name of the "Sandhi-Aware Indic Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Sandhi-Aware Indic Search'**
  String get helpFeatureSandhiTitle;

  /// Features screen: what the "Sandhi-Aware Indic Search" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Rule-based Sandhi compound splitting and joining supporting Malayalam, Sanskrit, and Devanagari rules.'**
  String get helpFeatureSandhiBody;

  /// Features screen: highlight chip 1 of the "Sandhi-Aware Indic Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Sandhi Splitting'**
  String get helpFeatureSandhiTag1;

  /// Features screen: highlight chip 2 of the "Sandhi-Aware Indic Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Compound Joining'**
  String get helpFeatureSandhiTag2;

  /// Features screen: highlight chip 3 of the "Sandhi-Aware Indic Search" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Sanskrit & Malayalam'**
  String get helpFeatureSandhiTag3;

  /// Features screen: name of the "Indic Phonetic Sound-Alike Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Indic Phonetic Sound-Alike Engine'**
  String get helpFeaturePhoneticTitle;

  /// Features screen: what the "Indic Phonetic Sound-Alike Engine" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Unifies Anusvara nasal conjuncts, chillu and virama forms, NTA ligatures, and Samvruthokaram endings.'**
  String get helpFeaturePhoneticBody;

  /// Features screen: highlight chip 1 of the "Indic Phonetic Sound-Alike Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Sound-Alike Matching'**
  String get helpFeaturePhoneticTag1;

  /// Features screen: highlight chip 2 of the "Indic Phonetic Sound-Alike Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Chillu Unification'**
  String get helpFeaturePhoneticTag2;

  /// Features screen: highlight chip 3 of the "Indic Phonetic Sound-Alike Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'NFC Normalization'**
  String get helpFeaturePhoneticTag3;

  /// Features screen: name of the "Malayalam Input Helper & Virtual Keypad" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Malayalam Input Helper & Virtual Keypad'**
  String get helpFeatureMalayalamInputTitle;

  /// Features screen: what the "Malayalam Input Helper & Virtual Keypad" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Live Manglish transliteration suggestions and a 3-tab virtual keypad for vowels, consonants, and signs.'**
  String get helpFeatureMalayalamInputBody;

  /// Features screen: highlight chip 1 of the "Malayalam Input Helper & Virtual Keypad" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Manglish Suggestions'**
  String get helpFeatureMalayalamInputTag1;

  /// Features screen: highlight chip 2 of the "Malayalam Input Helper & Virtual Keypad" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Virtual Keypad'**
  String get helpFeatureMalayalamInputTag2;

  /// Features screen: highlight chip 3 of the "Malayalam Input Helper & Virtual Keypad" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Zero Extra Setup'**
  String get helpFeatureMalayalamInputTag3;

  /// Features screen: name of the "Offline Text-to-Speech (TTS)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Offline Text-to-Speech (TTS)'**
  String get helpFeatureTtsTitle;

  /// Features screen: what the "Offline Text-to-Speech (TTS)" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Read PDF text aloud in English and Malayalam with speech rate, pitch, sentence pause sliders, and media notifications.'**
  String get helpFeatureTtsBody;

  /// Features screen: highlight chip 1 of the "Offline Text-to-Speech (TTS)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'English & Malayalam'**
  String get helpFeatureTtsTag1;

  /// Features screen: highlight chip 2 of the "Offline Text-to-Speech (TTS)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Speed & Pitch Controls'**
  String get helpFeatureTtsTag2;

  /// Features screen: highlight chip 3 of the "Offline Text-to-Speech (TTS)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Background Playback'**
  String get helpFeatureTtsTag3;

  /// Features screen: name of the "Text Markups & Color Presets" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Text Markups & Color Presets'**
  String get helpFeatureMarkupsTitle;

  /// Features screen: what the "Text Markups & Color Presets" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Highlight, underline, and strikethrough text with 7 vibrant color presets and customizable opacity.'**
  String get helpFeatureMarkupsBody;

  /// Features screen: highlight chip 1 of the "Text Markups & Color Presets" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get helpFeatureMarkupsTag1;

  /// Features screen: highlight chip 2 of the "Text Markups & Color Presets" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get helpFeatureMarkupsTag2;

  /// Features screen: highlight chip 3 of the "Text Markups & Color Presets" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get helpFeatureMarkupsTag3;

  /// Features screen: highlight chip 4 of the "Text Markups & Color Presets" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'7 Colors'**
  String get helpFeatureMarkupsTag4;

  /// Features screen: name of the "Freehand Ink Drawing & Sticky Notes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Freehand Ink Drawing & Sticky Notes'**
  String get helpFeatureInkTitle;

  /// Features screen: what the "Freehand Ink Drawing & Sticky Notes" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Draw smooth sketches with the pen tool and anchor movable sticky notes anywhere on pages.'**
  String get helpFeatureInkBody;

  /// Features screen: highlight chip 1 of the "Freehand Ink Drawing & Sticky Notes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Freehand Ink'**
  String get helpFeatureInkTag1;

  /// Features screen: highlight chip 2 of the "Freehand Ink Drawing & Sticky Notes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Anchored Notes'**
  String get helpFeatureInkTag2;

  /// Features screen: highlight chip 3 of the "Freehand Ink Drawing & Sticky Notes" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Eraser Tool'**
  String get helpFeatureInkTag3;

  /// Features screen: name of the "Flatten & Export Annotations" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Flatten & Export Annotations'**
  String get helpFeatureFlattenTitle;

  /// Features screen: what the "Flatten & Export Annotations" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Export annotations permanently into standard PDF annotation objects in a new copy of your document.'**
  String get helpFeatureFlattenBody;

  /// Features screen: highlight chip 1 of the "Flatten & Export Annotations" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Copy-on-Write'**
  String get helpFeatureFlattenTag1;

  /// Features screen: highlight chip 2 of the "Flatten & Export Annotations" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Standard PDF Annotations'**
  String get helpFeatureFlattenTag2;

  /// Features screen: highlight chip 3 of the "Flatten & Export Annotations" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Non-Destructive'**
  String get helpFeatureFlattenTag3;

  /// Features screen: name of the "Visual Organize Pages Grid" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Visual Organize Pages Grid'**
  String get helpFeatureOrganizeTitle;

  /// Features screen: what the "Visual Organize Pages Grid" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Drag-and-drop page reordering, 90-degree rotations, and page deletion with multi-selection support.'**
  String get helpFeatureOrganizeBody;

  /// Features screen: highlight chip 1 of the "Visual Organize Pages Grid" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Drag & Drop'**
  String get helpFeatureOrganizeTag1;

  /// Features screen: highlight chip 2 of the "Visual Organize Pages Grid" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Rotate & Delete'**
  String get helpFeatureOrganizeTag2;

  /// Features screen: highlight chip 3 of the "Visual Organize Pages Grid" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Multi-Select Mode'**
  String get helpFeatureOrganizeTag3;

  /// Features screen: name of the "Custom Text Watermarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Custom Text Watermarks'**
  String get helpFeatureWatermarkTitle;

  /// Features screen: what the "Custom Text Watermarks" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Add customizable diagonal or horizontal text watermarks with opacity, color, and repeating grid tiling.'**
  String get helpFeatureWatermarkBody;

  /// Features screen: highlight chip 1 of the "Custom Text Watermarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Custom Text'**
  String get helpFeatureWatermarkTag1;

  /// Features screen: highlight chip 2 of the "Custom Text Watermarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Opacity & Angle'**
  String get helpFeatureWatermarkTag2;

  /// Features screen: highlight chip 3 of the "Custom Text Watermarks" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Grid Tiling'**
  String get helpFeatureWatermarkTag3;

  /// Features screen: name of the "N-Up Multi-Page Imposition" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'N-Up Multi-Page Imposition'**
  String get helpFeatureNUpTitle;

  /// Features screen: what the "N-Up Multi-Page Imposition" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Place 2, 4, 6, or 9 pages per sheet on A4 or Letter paper with customizable borders and margins.'**
  String get helpFeatureNUpBody;

  /// Features screen: highlight chip 1 of the "N-Up Multi-Page Imposition" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'2/4/6/9 Up'**
  String get helpFeatureNUpTag1;

  /// Features screen: highlight chip 2 of the "N-Up Multi-Page Imposition" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Page Borders'**
  String get helpFeatureNUpTag2;

  /// Features screen: highlight chip 3 of the "N-Up Multi-Page Imposition" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Sheet Orientation'**
  String get helpFeatureNUpTag3;

  /// Features screen: name of the "Printable Booklet Creator" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Printable Booklet Creator'**
  String get helpFeatureBookletTitle;

  /// Features screen: what the "Printable Booklet Creator" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Imposes pages into foldable saddle-stitch booklet order with automatic 4-page padding.'**
  String get helpFeatureBookletBody;

  /// Features screen: highlight chip 1 of the "Printable Booklet Creator" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Saddle-Stitch'**
  String get helpFeatureBookletTag1;

  /// Features screen: highlight chip 2 of the "Printable Booklet Creator" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Fold Guidelines'**
  String get helpFeatureBookletTag2;

  /// Features screen: highlight chip 3 of the "Printable Booklet Creator" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Auto-Padding'**
  String get helpFeatureBookletTag3;

  /// Features screen: name of the "Merge, Split & Compress" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Merge, Split & Compress'**
  String get helpFeatureMergeSplitTitle;

  /// Features screen: what the "Merge, Split & Compress" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Combine multiple PDFs, split pages into individual files, and compress PDFs to reduce file size.'**
  String get helpFeatureMergeSplitBody;

  /// Features screen: highlight chip 1 of the "Merge, Split & Compress" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Merge Multiple'**
  String get helpFeatureMergeSplitTag1;

  /// Features screen: highlight chip 2 of the "Merge, Split & Compress" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Page Splitter'**
  String get helpFeatureMergeSplitTag2;

  /// Features screen: highlight chip 3 of the "Merge, Split & Compress" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Smart Compression'**
  String get helpFeatureMergeSplitTag3;

  /// Features screen: name of the "PDF Encryption & Decryption" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'PDF Encryption & Decryption'**
  String get helpFeatureEncryptionTitle;

  /// Features screen: what the "PDF Encryption & Decryption" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Protect documents with AES-256 passwords or unlock encrypted files into unencrypted copies.'**
  String get helpFeatureEncryptionBody;

  /// Features screen: highlight chip 1 of the "PDF Encryption & Decryption" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'AES-256 Protection'**
  String get helpFeatureEncryptionTag1;

  /// Features screen: highlight chip 2 of the "PDF Encryption & Decryption" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Owner Passwords'**
  String get helpFeatureEncryptionTag2;

  /// Features screen: highlight chip 3 of the "PDF Encryption & Decryption" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Unlock Decryption'**
  String get helpFeatureEncryptionTag3;

  /// Features screen: name of the "Batch Operations Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Batch Operations Engine'**
  String get helpFeatureBatchTitle;

  /// Features screen: what the "Batch Operations Engine" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Execute watermarking, compression, encryption, decryption, and extraction across multiple files at once.'**
  String get helpFeatureBatchBody;

  /// Features screen: highlight chip 1 of the "Batch Operations Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Multi-File Batch'**
  String get helpFeatureBatchTag1;

  /// Features screen: highlight chip 2 of the "Batch Operations Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Step Progress'**
  String get helpFeatureBatchTag2;

  /// Features screen: highlight chip 3 of the "Batch Operations Engine" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'SAF Output'**
  String get helpFeatureBatchTag3;

  /// Features screen: name of the "Text & Image Extraction" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Text & Image Extraction'**
  String get helpFeatureExtractionTitle;

  /// Features screen: what the "Text & Image Extraction" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Extract plain text and save embedded PNG/JPEG images from any page range without quality loss.'**
  String get helpFeatureExtractionBody;

  /// Features screen: highlight chip 1 of the "Text & Image Extraction" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Plain Text Export'**
  String get helpFeatureExtractionTag1;

  /// Features screen: highlight chip 2 of the "Text & Image Extraction" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Embedded Images'**
  String get helpFeatureExtractionTag2;

  /// Features screen: highlight chip 3 of the "Text & Image Extraction" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Page Ranges'**
  String get helpFeatureExtractionTag3;

  /// Features screen: name of the "Interactive Form Fields Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Interactive Form Fields Inspector'**
  String get helpFeatureFormFieldsTitle;

  /// Features screen: what the "Interactive Form Fields Inspector" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Detect and inspect interactive form field values, checkboxes, radio groups, and export as JSON.'**
  String get helpFeatureFormFieldsBody;

  /// Features screen: highlight chip 1 of the "Interactive Form Fields Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Form Parser'**
  String get helpFeatureFormFieldsTag1;

  /// Features screen: highlight chip 2 of the "Interactive Form Fields Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'JSON Export'**
  String get helpFeatureFormFieldsTag2;

  /// Features screen: highlight chip 3 of the "Interactive Form Fields Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Field Inspector'**
  String get helpFeatureFormFieldsTag3;

  /// Features screen: name of the "Render Pages to High-DPI Images" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Render Pages to High-DPI Images'**
  String get helpFeatureRenderImagesTitle;

  /// Features screen: what the "Render Pages to High-DPI Images" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Export PDF pages as crisp PNG or JPEG images with customizable DPI resolution up to 300 DPI.'**
  String get helpFeatureRenderImagesBody;

  /// Features screen: highlight chip 1 of the "Render Pages to High-DPI Images" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'High-DPI PNG/JPEG'**
  String get helpFeatureRenderImagesTag1;

  /// Features screen: highlight chip 2 of the "Render Pages to High-DPI Images" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'100-300 DPI'**
  String get helpFeatureRenderImagesTag2;

  /// Features screen: highlight chip 3 of the "Render Pages to High-DPI Images" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Batch Rendering'**
  String get helpFeatureRenderImagesTag3;

  /// Features screen: name of the "Document Metadata Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Document Metadata Inspector'**
  String get helpFeatureMetadataTitle;

  /// Features screen: what the "Document Metadata Inspector" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'View detailed document metadata including title, author, producer, creation date, and encryption state.'**
  String get helpFeatureMetadataBody;

  /// Features screen: highlight chip 1 of the "Document Metadata Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'PDF Metadata'**
  String get helpFeatureMetadataTag1;

  /// Features screen: highlight chip 2 of the "Document Metadata Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Creation Dates'**
  String get helpFeatureMetadataTag2;

  /// Features screen: highlight chip 3 of the "Document Metadata Inspector" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Security State'**
  String get helpFeatureMetadataTag3;

  /// Features screen: name of the "Android System Virtual Printer" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Android System Virtual Printer'**
  String get helpFeatureVirtualPrinterTitle;

  /// Features screen: what the "Android System Virtual Printer" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Receives print jobs from any Android app to generate crisp PDFs with full Indic font shaping.'**
  String get helpFeatureVirtualPrinterBody;

  /// Features screen: highlight chip 1 of the "Android System Virtual Printer" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'System Spooler'**
  String get helpFeatureVirtualPrinterTag1;

  /// Features screen: highlight chip 2 of the "Android System Virtual Printer" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Font Embedding'**
  String get helpFeatureVirtualPrinterTag2;

  /// Features screen: highlight chip 3 of the "Android System Virtual Printer" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Indic Shaping'**
  String get helpFeatureVirtualPrinterTag3;

  /// Features screen: name of the "Web Content Cleaner (Reader Mode)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Web Content Cleaner (Reader Mode)'**
  String get helpFeatureWebCleanerTitle;

  /// Features screen: what the "Web Content Cleaner (Reader Mode)" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Strips ads, tracking, banners, sidebars, and scripts from shared web pages before converting to PDF.'**
  String get helpFeatureWebCleanerBody;

  /// Features screen: highlight chip 1 of the "Web Content Cleaner (Reader Mode)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Ad & Clutter Stripping'**
  String get helpFeatureWebCleanerTag1;

  /// Features screen: highlight chip 2 of the "Web Content Cleaner (Reader Mode)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Reader View'**
  String get helpFeatureWebCleanerTag2;

  /// Features screen: highlight chip 3 of the "Web Content Cleaner (Reader Mode)" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Clean PDFs'**
  String get helpFeatureWebCleanerTag3;

  /// Features screen: name of the "Images & Text to PDF Converter" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Images & Text to PDF Converter'**
  String get helpFeatureImagesToPdfTitle;

  /// Features screen: what the "Images & Text to PDF Converter" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Convert up to 100 gallery images or shared plain text into formatted multi-page PDF documents.'**
  String get helpFeatureImagesToPdfBody;

  /// Features screen: highlight chip 1 of the "Images & Text to PDF Converter" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Up to 100 Images'**
  String get helpFeatureImagesToPdfTag1;

  /// Features screen: highlight chip 2 of the "Images & Text to PDF Converter" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Plain Text Importer'**
  String get helpFeatureImagesToPdfTag2;

  /// Features screen: highlight chip 3 of the "Images & Text to PDF Converter" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Custom Margins'**
  String get helpFeatureImagesToPdfTag3;

  /// Features screen: name of the "Cryptographic Signature Verification" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Cryptographic Signature Verification'**
  String get helpFeatureSignatureCheckTitle;

  /// Features screen: what the "Cryptographic Signature Verification" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Validates document integrity, byte coverage, and certificate validity offline using Bouncy Castle.'**
  String get helpFeatureSignatureCheckBody;

  /// Features screen: highlight chip 1 of the "Cryptographic Signature Verification" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Byte Integrity'**
  String get helpFeatureSignatureCheckTag1;

  /// Features screen: highlight chip 2 of the "Cryptographic Signature Verification" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Byte Coverage Scope'**
  String get helpFeatureSignatureCheckTag2;

  /// Features screen: highlight chip 3 of the "Cryptographic Signature Verification" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Offline Validation'**
  String get helpFeatureSignatureCheckTag3;

  /// Features screen: name of the "Custom Trust Store & EU Lists" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Custom Trust Store & EU Lists'**
  String get helpFeatureTrustStoreTitle;

  /// Features screen: what the "Custom Trust Store & EU Lists" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Bundled EU Trusted Lists root certificates with support for importing custom CA/root certificates.'**
  String get helpFeatureTrustStoreBody;

  /// Features screen: highlight chip 1 of the "Custom Trust Store & EU Lists" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'EU Trusted Lists'**
  String get helpFeatureTrustStoreTag1;

  /// Features screen: highlight chip 2 of the "Custom Trust Store & EU Lists" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Import X.509 PEM'**
  String get helpFeatureTrustStoreTag2;

  /// Features screen: highlight chip 3 of the "Custom Trust Store & EU Lists" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'PEM Export'**
  String get helpFeatureTrustStoreTag3;

  /// Features screen: name of the "Visual Signature Stamp Overlay" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Visual Signature Stamp Overlay'**
  String get helpFeatureSignatureStampsTitle;

  /// Features screen: what the "Visual Signature Stamp Overlay" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Interactive signature stamp badges on PDF pages with one-tap access to certificate chain details.'**
  String get helpFeatureSignatureStampsBody;

  /// Features screen: highlight chip 1 of the "Visual Signature Stamp Overlay" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'On-Page Badges'**
  String get helpFeatureSignatureStampsTag1;

  /// Features screen: highlight chip 2 of the "Visual Signature Stamp Overlay" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Certificate Chains'**
  String get helpFeatureSignatureStampsTag2;

  /// Features screen: highlight chip 3 of the "Visual Signature Stamp Overlay" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Signer Details'**
  String get helpFeatureSignatureStampsTag3;

  /// Features screen: name of the "Light, Dark & OLED Pitch-Black" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Light, Dark & OLED Pitch-Black'**
  String get helpFeatureThemesTitle;

  /// Features screen: what the "Light, Dark & OLED Pitch-Black" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Support for Light, Dark, Sepia, and OLED Pitch-Black (#000000) for maximum battery savings.'**
  String get helpFeatureThemesBody;

  /// Features screen: highlight chip 1 of the "Light, Dark & OLED Pitch-Black" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'OLED Pitch-Black'**
  String get helpFeatureThemesTag1;

  /// Features screen: highlight chip 2 of the "Light, Dark & OLED Pitch-Black" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Sepia Reading'**
  String get helpFeatureThemesTag2;

  /// Features screen: highlight chip 3 of the "Light, Dark & OLED Pitch-Black" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'System Adaptive'**
  String get helpFeatureThemesTag3;

  /// Features screen: name of the "Custom Typography & Scale" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Custom Typography & Scale'**
  String get helpFeatureTypographyTitle;

  /// Features screen: what the "Custom Typography & Scale" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Switch between Manjari, Anek Malayalam, Noto Sans Malayalam, and System font with text scaling.'**
  String get helpFeatureTypographyBody;

  /// Features screen: highlight chip 1 of the "Custom Typography & Scale" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Malayalam Fonts'**
  String get helpFeatureTypographyTag1;

  /// Features screen: highlight chip 2 of the "Custom Typography & Scale" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Font Scaling'**
  String get helpFeatureTypographyTag2;

  /// Features screen: highlight chip 3 of the "Custom Typography & Scale" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Switch'**
  String get helpFeatureTypographyTag3;

  /// Features screen: name of the "Interactive Accent Color Picker" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Interactive Accent Color Picker'**
  String get helpFeatureAccentTitle;

  /// Features screen: what the "Interactive Accent Color Picker" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'Custom color presets and full HSV color wheel with real-time app theme preview.'**
  String get helpFeatureAccentBody;

  /// Features screen: highlight chip 1 of the "Interactive Accent Color Picker" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'HSV Color Wheel'**
  String get helpFeatureAccentTag1;

  /// Features screen: highlight chip 2 of the "Interactive Accent Color Picker" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'8 Presets'**
  String get helpFeatureAccentTag2;

  /// Features screen: highlight chip 3 of the "Interactive Accent Color Picker" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Live Preview'**
  String get helpFeatureAccentTag3;

  /// Features screen: name of the "6 Dedicated Step-by-Step Guides" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'6 Dedicated Step-by-Step Guides'**
  String get helpFeatureGuidesTitle;

  /// Features screen: what the "6 Dedicated Step-by-Step Guides" feature does. Help content.
  ///
  /// In en, this message translates to:
  /// **'In-depth guides covering PDF printer setup, Unicode printing, TTS voice configuration, page operations, signatures, and privacy.'**
  String get helpFeatureGuidesBody;

  /// Features screen: highlight chip 1 of the "6 Dedicated Step-by-Step Guides" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'100% Offline Guides'**
  String get helpFeatureGuidesTag1;

  /// Features screen: highlight chip 2 of the "6 Dedicated Step-by-Step Guides" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get helpFeatureGuidesTag2;

  /// Features screen: highlight chip 3 of the "6 Dedicated Step-by-Step Guides" feature. Help content.
  ///
  /// In en, this message translates to:
  /// **'Step-by-Step'**
  String get helpFeatureGuidesTag3;

  /// Color name for a grey swatch (tooltip and screen-reader label). Keep to one word.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get labelColorGrey;

  /// Screen-reader label of the accent color wheel. Keep short.
  ///
  /// In en, this message translates to:
  /// **'Color wheel'**
  String get labelAccentColorWheel;

  /// Screen-reader hint for the accent color wheel. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'Drag on the wheel to choose the accent color.'**
  String get helpAccentColorWheelHint;

  /// Settings → Storage section heading for the delete-all-data row. Keep short.
  ///
  /// In en, this message translates to:
  /// **'App data'**
  String get titleAppData;

  /// Row title and confirm button that deletes all app data. Keep to two or three words.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get actionDeleteAllData;

  /// Subtitle explaining what Delete all data removes. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'Removes recent files, reading positions, notes and marks, certificates you trusted, saved settings, printed files and cached files. Your own PDF files are not touched.'**
  String get descDeleteAllData;

  /// Title of the confirm dialog for deleting all app data. Keep short.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get titleDeleteAllDataConfirm;

  /// Body of the confirm dialog for deleting all app data. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. The app will start again from the home screen with default settings.'**
  String get bodyDeleteAllDataConfirm;

  /// Error when deleting all app data fails. Descriptive text.
  ///
  /// In en, this message translates to:
  /// **'Some data could not be deleted. Please try again.'**
  String get errorDeleteAllData;

  /// Button that clears the temporary cache. One word.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// Subtitle under the System default language option: the language follows the phone
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get labelLanguageAuto;

  /// Paper size option name: ISO A4
  ///
  /// In en, this message translates to:
  /// **'A4'**
  String get labelPaperA4;

  /// Paper size option name: US Letter
  ///
  /// In en, this message translates to:
  /// **'US Letter'**
  String get labelPaperLetter;

  /// Paper size option name: US Legal
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get labelPaperLegal;

  /// Size of A4 paper, shown under the option name
  ///
  /// In en, this message translates to:
  /// **'210 × 297 mm'**
  String get descPaperA4;

  /// Size of US Letter paper in inches, shown under the option name
  ///
  /// In en, this message translates to:
  /// **'8.5 × 11 in'**
  String get descPaperLetter;

  /// Size of US Legal paper in inches, shown under the option name
  ///
  /// In en, this message translates to:
  /// **'8.5 × 14 in'**
  String get descPaperLegal;

  /// Hint next to the image resolution slider for 150 DPI or lower
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get labelQualityStandard;

  /// Hint next to the image resolution slider for more than 150 DPI
  ///
  /// In en, this message translates to:
  /// **'High Quality'**
  String get labelQualityHigh;

  /// Shown in the text preview when the extracted text is empty
  ///
  /// In en, this message translates to:
  /// **'No text found.'**
  String get emptyExtractedText;

  /// Watermark preset and default watermark text, stamped onto PDF pages. Capitals in English.
  ///
  /// In en, this message translates to:
  /// **'CONFIDENTIAL'**
  String get labelWatermarkConfidential;

  /// Watermark preset text: an unfinished version
  ///
  /// In en, this message translates to:
  /// **'DRAFT'**
  String get labelWatermarkDraft;

  /// Watermark preset text: a copy, not the original
  ///
  /// In en, this message translates to:
  /// **'COPY'**
  String get labelWatermarkCopy;

  /// Watermark preset text: a specimen or example
  ///
  /// In en, this message translates to:
  /// **'SAMPLE'**
  String get labelWatermarkSample;

  /// Watermark preset text: the original document
  ///
  /// In en, this message translates to:
  /// **'ORIGINAL'**
  String get labelWatermarkOriginal;

  /// Title of the Device sync screen and its Settings entry
  ///
  /// In en, this message translates to:
  /// **'Device sync'**
  String get titleDeviceSync;

  /// Subtitle of the Device sync entry in Settings
  ///
  /// In en, this message translates to:
  /// **'Copy settings or send PDFs to another phone by QR code or WiFi'**
  String get descDeviceSyncSubtitle;

  /// Intro text at the top of the Device sync screen
  ///
  /// In en, this message translates to:
  /// **'Copy your Folio settings to another phone, or send PDFs. The phone that has them shows a code. The other phone scans it.'**
  String get descDeviceSyncIntro;

  /// Note on the Device sync screen: what is and is not copied
  ///
  /// In en, this message translates to:
  /// **'Only settings are copied. Recent files, reading places, notes, bookmarks and trusted certificates stay on this phone. The Malayalam voice choice and the PDF printer switch also stay, because they depend on each phone.'**
  String get descDeviceSyncWhatIsCopied;

  /// Title of the screen that shows a code to share settings
  ///
  /// In en, this message translates to:
  /// **'Share my settings'**
  String get titleShareSettings;

  /// Subtitle of the Share my settings option
  ///
  /// In en, this message translates to:
  /// **'Show a code for the other phone to scan'**
  String get descShareSettingsSubtitle;

  /// Segment: send settings inside the QR code, no network
  ///
  /// In en, this message translates to:
  /// **'QR only'**
  String get labelSyncModeQr;

  /// Segment: send settings over local WiFi
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get labelSyncModeWifi;

  /// Help text for the QR only mode
  ///
  /// In en, this message translates to:
  /// **'The settings are inside the code. No network is needed.'**
  String get descSyncModeQrHelp;

  /// Help text for the WiFi mode
  ///
  /// In en, this message translates to:
  /// **'The code joins the two phones over your local WiFi. Both phones must be on the same WiFi, or one phone can join the other\'s hotspot. Nothing goes to the internet.'**
  String get descSyncModeWifiHelp;

  /// Countdown under a WiFi code; time is minutes:seconds
  ///
  /// In en, this message translates to:
  /// **'This code works for {time}.'**
  String descWifiCodeExpires(String time);

  /// Shown when the other phone connected; address is its local IP address
  ///
  /// In en, this message translates to:
  /// **'Connected to {address}. Waiting for the other phone to confirm…'**
  String descWifiGuestConnected(String address);

  /// The other phone accepted the settings
  ///
  /// In en, this message translates to:
  /// **'The other phone applied your settings.'**
  String get descWifiShareAccepted;

  /// The other phone cancelled
  ///
  /// In en, this message translates to:
  /// **'The other phone cancelled. Nothing was changed there.'**
  String get descWifiShareDeclined;

  /// WiFi mode cannot start: no WiFi or hotspot address
  ///
  /// In en, this message translates to:
  /// **'This phone is not on a WiFi network. Connect both phones to the same WiFi, turn on a hotspot on one phone, or use QR only.'**
  String get errorNoLanAddress;

  /// WiFi session stopped because the app was hidden
  ///
  /// In en, this message translates to:
  /// **'The WiFi session ended because Folio went to the background. Start again when you are ready.'**
  String get descWifiSessionEnded;

  /// Title of the camera screen that scans a Device sync code
  ///
  /// In en, this message translates to:
  /// **'Scan code'**
  String get titleScanCode;

  /// Help above the camera view
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the code on the other phone.'**
  String get descScanCodeHelp;

  /// Camera could not start (permission refused or no camera)
  ///
  /// In en, this message translates to:
  /// **'The camera could not start. Allow camera access for Folio in the system settings, then try again. A phone without a camera can still send settings and PDFs.'**
  String get errorCameraUnavailable;

  /// Scanned a QR code from another app
  ///
  /// In en, this message translates to:
  /// **'This is not a Folio code.'**
  String get errorCodeNotFolio;

  /// Scanned Folio code is damaged
  ///
  /// In en, this message translates to:
  /// **'This Folio code could not be read. Make a new code and try again.'**
  String get errorCodeDamaged;

  /// Scanned code uses a newer format
  ///
  /// In en, this message translates to:
  /// **'This code was made by a newer Folio. Update Folio on this phone.'**
  String get errorCodeNewerVersion;

  /// Scanned code has a non-local address and is refused
  ///
  /// In en, this message translates to:
  /// **'This code points outside your local network, so Folio will not use it.'**
  String get errorCodeUnsafeAddress;

  /// Shown while connecting over WiFi
  ///
  /// In en, this message translates to:
  /// **'Connecting to the other phone…'**
  String get descReceiveConnecting;

  /// Heading of the list of settings that will change
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 setting will change:} other{{count} settings will change:}}'**
  String descReviewSettingsChanges(int count);

  /// Nothing to change
  ///
  /// In en, this message translates to:
  /// **'Your settings are already the same as the other phone\'s.'**
  String get descReviewSettingsSame;

  /// Some received values were unknown or invalid
  ///
  /// In en, this message translates to:
  /// **'Some values were skipped because this version of Folio cannot use them.'**
  String get descReviewSettingsSkipped;

  /// Button: apply the received settings
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApplySettings;

  /// Received settings were applied
  ///
  /// In en, this message translates to:
  /// **'Settings applied.'**
  String get descSettingsApplied;

  /// User cancelled; nothing changed
  ///
  /// In en, this message translates to:
  /// **'Nothing was changed.'**
  String get descSettingsNotApplied;

  /// Could not connect to the other phone
  ///
  /// In en, this message translates to:
  /// **'Could not reach the other phone. Use the same WiFi on both phones, or turn on a hotspot on one phone and join it from the other. Some office and hotel WiFi networks block this.'**
  String get errorTransferUnreachable;

  /// Session timed out
  ///
  /// In en, this message translates to:
  /// **'Nothing happened in time. Make a new code and try again.'**
  String get errorTransferTimedOut;

  /// Pairing key did not match
  ///
  /// In en, this message translates to:
  /// **'The code did not work. It may be old or already used. Make a new code and try again.'**
  String get errorTransferWrongCode;

  /// Received data was invalid
  ///
  /// In en, this message translates to:
  /// **'The data from the other phone was damaged. Try again.'**
  String get errorTransferBadData;

  /// Other phone uses an unknown format
  ///
  /// In en, this message translates to:
  /// **'The other phone runs a different version of Folio. Update Folio on both phones.'**
  String get errorTransferUnsupportedVersion;

  /// Connection closed mid-way
  ///
  /// In en, this message translates to:
  /// **'The connection was lost. Try again.'**
  String get errorTransferConnectionLost;

  /// Name of the light-theme accent color setting in the review list
  ///
  /// In en, this message translates to:
  /// **'Light accent color'**
  String get labelSyncAccentLight;

  /// Name of the dark-theme accent color setting in the review list
  ///
  /// In en, this message translates to:
  /// **'Dark accent color'**
  String get labelSyncAccentDark;

  /// Permissions screen: camera
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get titlePermCamera;

  /// Why the camera permission is used
  ///
  /// In en, this message translates to:
  /// **'Used only on the Scan code screen, to read a Device sync QR code. Asked the first time you scan. No photos or videos are taken or saved.'**
  String get descPermCameraReason;

  /// What the camera permission achieves
  ///
  /// In en, this message translates to:
  /// **'Lets you receive settings or PDFs from another phone by scanning its code.'**
  String get descPermCameraWhatItAchieves;

  /// Permissions screen: the INTERNET permission, used for local WiFi only
  ///
  /// In en, this message translates to:
  /// **'Local WiFi only'**
  String get titlePermLocalNetwork;

  /// Why the INTERNET permission is declared
  ///
  /// In en, this message translates to:
  /// **'android.permission.INTERNET is needed for any network connection, even between two phones on the same WiFi. Folio uses it only for Device sync, only while that screen is open, and only with a private local address read from the QR code.'**
  String get descPermLocalNetworkReason;

  /// What the local WiFi permission achieves
  ///
  /// In en, this message translates to:
  /// **'The phones talk directly to each other, encrypted with a one-time key. Folio never contacts an internet server.'**
  String get descPermLocalNetworkWhatItAchieves;

  /// Title of the receive option and screen (settings or PDFs)
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get titleReceive;

  /// Subtitle of the Receive option
  ///
  /// In en, this message translates to:
  /// **'Scan the code on the other phone to get settings or PDFs'**
  String get descReceiveSubtitle;

  /// How to start sending PDFs, shown on the Device sync screen
  ///
  /// In en, this message translates to:
  /// **'To send PDFs: on Home, long-press a recent file to select it (tap more to add them), or open a PDF and choose Send to nearby phone from the menu.'**
  String get descDeviceSyncSendPdfsHint;

  /// Menu item and button: send the PDF(s) to another phone over local WiFi
  ///
  /// In en, this message translates to:
  /// **'Send to nearby phone'**
  String get actionSendNearby;

  /// Title of the screen that sends PDFs to a nearby phone
  ///
  /// In en, this message translates to:
  /// **'Send PDFs'**
  String get titleSendFiles;

  /// Progress while copying and checking files before sending
  ///
  /// In en, this message translates to:
  /// **'Getting files ready… {done} of {total}'**
  String descSendPreparing(int done, int total);

  /// Instruction under the QR code when sending PDFs; also its screen-reader label
  ///
  /// In en, this message translates to:
  /// **'On the other phone, open Folio › Settings › Device sync › Receive, and scan this code.'**
  String get descSendScanPrompt;

  /// How many PDFs are ready to send
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 PDF ready to send} other{{count} PDFs ready to send}}'**
  String descSendFileCount(int count);

  /// Files left out because they could not be read; names is a comma-separated list
  ///
  /// In en, this message translates to:
  /// **'These files could not be read and will not be sent: {names}'**
  String descSendSkipped(String names);

  /// No chosen file could be read
  ///
  /// In en, this message translates to:
  /// **'None of the chosen files could be read. They may have been moved or deleted. Open them again, then try once more.'**
  String get errorSendNothing;

  /// Sending PDFs cannot start: no WiFi or hotspot address
  ///
  /// In en, this message translates to:
  /// **'This phone is not on a WiFi network. Connect both phones to the same WiFi, or turn on a hotspot on one phone.'**
  String get errorSendNoNetwork;

  /// Sending progress; sent and total are formatted sizes like 4.2 MB
  ///
  /// In en, this message translates to:
  /// **'Sending… {sent} of {total}'**
  String descSendTransferring(String sent, String total);

  /// Result on the sending phone
  ///
  /// In en, this message translates to:
  /// **'{received} of {count} PDFs arrived safely on the other phone.'**
  String descSendFinished(int received, int count);

  /// The receiving phone declined the PDFs
  ///
  /// In en, this message translates to:
  /// **'The other phone cancelled. Nothing was sent.'**
  String get descSendDeclined;

  /// Heading of the list of offered PDFs
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 PDF from the other phone:} other{{count} PDFs from the other phone:}}'**
  String descReceiveFilesHeader(int count);

  /// Total size of offered PDFs; size is formatted like 12 MB
  ///
  /// In en, this message translates to:
  /// **'Total size: {size}'**
  String descReceiveFilesTotal(String size);

  /// Shows the remembered folder for received PDFs
  ///
  /// In en, this message translates to:
  /// **'Saving to: {folder}'**
  String descSavingTo(String folder);

  /// No receive folder chosen yet
  ///
  /// In en, this message translates to:
  /// **'Choose a folder to save the PDFs in. Folio will remember it.'**
  String get descNoFolderYet;

  /// The remembered receive folder is gone or not accessible
  ///
  /// In en, this message translates to:
  /// **'The folder you chose before can no longer be used. It may have been deleted, or access to it was removed. Choose a folder again.'**
  String get errorFolderLost;

  /// Button: pick another receive folder
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get actionChangeFolder;

  /// Button: pick the receive folder
  ///
  /// In en, this message translates to:
  /// **'Choose folder'**
  String get actionChooseFolder;

  /// Button: accept and receive the PDFs
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get actionAcceptFiles;

  /// Receiving progress; formatted sizes
  ///
  /// In en, this message translates to:
  /// **'Receiving… {received} of {total}'**
  String descReceiveTransferring(String received, String total);

  /// Copying received PDFs into the folder
  ///
  /// In en, this message translates to:
  /// **'Saving to the folder…'**
  String get descReceiveSaving;

  /// Result on the receiving phone
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No PDFs were saved.} =1{1 PDF saved in {folder}.} other{{count} PDFs saved in {folder}.}}'**
  String descReceiveFilesSaved(int count, String folder);

  /// Files not saved; names is a comma-separated list
  ///
  /// In en, this message translates to:
  /// **'Not saved (damaged on the way, not a PDF, or could not be written): {names}'**
  String descReceiveFilesFailed(String names);

  /// Received files could not be written
  ///
  /// In en, this message translates to:
  /// **'Could not save the files. The phone may be out of space, or the folder can no longer be written to.'**
  String get errorTransferCannotSave;

  /// Home app bar title while selecting recent files
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String labelSelectedCount(int count);

  /// Tooltip: leave selection mode on Home
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get tooltipCancelSelection;

  /// Instruction under the shown QR code; also its screen-reader label
  ///
  /// In en, this message translates to:
  /// **'On the other phone, open Folio › Settings › Device sync › Receive, and scan this code.'**
  String get descShowCodeScanPrompt;
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
      <String>['en', 'ml', 'sa'].contains(locale.languageCode);

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
    case 'sa':
      return AppLocalizationsSa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
