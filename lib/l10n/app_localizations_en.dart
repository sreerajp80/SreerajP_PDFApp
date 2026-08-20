// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SreerajP PDF App';

  @override
  String get homeTitle => 'SreerajP PDF App';

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
  String get themeOled => 'OLED Pitch-Black';

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
  String get pageFit => 'Page fit';

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
  String get searchOptionSandhi => 'Sandhi compound search';

  @override
  String get searchOptionSandhiNote =>
      'Find joined or split compound words (Malayalam & Sanskrit)';

  @override
  String get searchOptionPhonetic => 'Phonetic matching';

  @override
  String get searchOptionPhoneticNote =>
      'Match sound-alike letters, anusvara nasals, and chillu variations';

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

  @override
  String get extractAndConvert => 'Extract & Convert';

  @override
  String get extractTextAction => 'Extract text';

  @override
  String get extractImagesAction => 'Extract images';

  @override
  String get convertPdfAction => 'Convert to images';

  @override
  String get formFieldsAction => 'Form fields';

  @override
  String get extractionSuccess => 'Extraction successful';

  @override
  String get extractionFailed => 'Extraction failed';

  @override
  String get extractingProgress => 'Extracting content…';

  @override
  String get rangeAll => 'All pages';

  @override
  String rangeCurrent(int page) {
    return 'Current page (Page $page)';
  }

  @override
  String get rangeCustom => 'Custom range';

  @override
  String get startPageLabel => 'Start page';

  @override
  String get endPageLabel => 'End page';

  @override
  String get invalidPageRange => 'Invalid page range';

  @override
  String get imageFormatLabel => 'Image format';

  @override
  String resolutionLabel(int dpi) {
    return 'Resolution: $dpi DPI';
  }

  @override
  String get fieldsNameHeader => 'Field Name';

  @override
  String get fieldsValueHeader => 'Value';

  @override
  String get noFormFieldsFound =>
      'No interactive form fields found in this PDF.';

  @override
  String get noImagesFound => 'No images were found in the selected range.';

  @override
  String get shareAction => 'Share';

  @override
  String get shareFileAction => 'Share as file';

  @override
  String get copyClipboardAction => 'Copy to clipboard';

  @override
  String get copySuccess => 'Copied to clipboard';

  @override
  String get previewTextTitle => 'Extracted Text Preview';

  @override
  String get formFieldsTitle => 'Interactive Form Fields';

  @override
  String get pageToolsTitle => 'Page tools';

  @override
  String get mergeAction => 'Merge PDFs';

  @override
  String get mergeDescription => 'Join this PDF with others into one new file';

  @override
  String get mergeDoneTitle => 'PDFs merged';

  @override
  String get splitAction => 'Split into pages';

  @override
  String get splitDescription => 'Make one new file for each page';

  @override
  String get splitDoneTitle => 'PDF split';

  @override
  String get organizeAction => 'Organize pages';

  @override
  String get organizeDescription => 'Reorder, rotate, or delete pages';

  @override
  String get organizeTitle => 'Organize pages';

  @override
  String get organizeHint =>
      'Drag to reorder. Use the buttons to rotate or delete a page. Save writes a new file.';

  @override
  String get organizeDoneTitle => 'Pages organized';

  @override
  String get compressAction => 'Compress';

  @override
  String get compressDescription => 'Make a smaller copy (best-effort)';

  @override
  String get compressDoneTitle => 'PDF compressed';

  @override
  String get compressBestEffortNote =>
      'Compression is best-effort. Already-optimized files may not shrink much.';

  @override
  String get protectAction => 'Protect with password';

  @override
  String get protectDescription => 'Add a password to a new copy';

  @override
  String get protectTitle => 'Protect PDF';

  @override
  String get protectDoneTitle => 'PDF protected';

  @override
  String get removePasswordAction => 'Remove password';

  @override
  String get unlockDescription =>
      'Make an unlocked copy (needs the current password)';

  @override
  String get unlockTitle => 'Remove password';

  @override
  String get unlockDoneTitle => 'Password removed';

  @override
  String get userPasswordLabel => 'Password (to open the file)';

  @override
  String get ownerPasswordLabel => 'Owner password (optional)';

  @override
  String get ownerPasswordHelp =>
      'Controls printing and editing. Leave blank to match the open password.';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get passwordRequiredError => 'Please enter a password.';

  @override
  String get workingProgress => 'Working…';

  @override
  String get opFailed => 'Operation failed';

  @override
  String get saveAction => 'Save';

  @override
  String get saveFailed => 'Could not save the file';

  @override
  String savedFileMessage(String name) {
    return 'Saved $name';
  }

  @override
  String resultOneFile(String name) {
    return 'New file: $name';
  }

  @override
  String resultManyFiles(int count) {
    return '$count new files were created.';
  }

  @override
  String pageLabel(int page) {
    return 'Page $page';
  }

  @override
  String rotatedBy(int degrees) {
    return 'Rotated $degrees°';
  }

  @override
  String pageDeletedMessage(int page) {
    return 'Page $page removed';
  }

  @override
  String get undoAction => 'Undo';

  @override
  String get rotateAction => 'Rotate';

  @override
  String get deletePageAction => 'Delete page';

  @override
  String get noPagesLeftError => 'Keep at least one page.';

  @override
  String get annotateAction => 'Annotate';

  @override
  String get annotationHighlight => 'Highlight';

  @override
  String get annotationUnderline => 'Underline';

  @override
  String get annotationStrikethrough => 'Strikethrough';

  @override
  String get annotationInk => 'Draw';

  @override
  String get annotationNote => 'Note';

  @override
  String get annotationEraser => 'Eraser';

  @override
  String get annotationClearAll => 'Clear all marks';

  @override
  String get annotationExport => 'Export annotated copy';

  @override
  String get annotationOverlayNotice =>
      'These marks are saved only inside this app. Export an annotated copy to keep them in the PDF.';

  @override
  String get annotationTextMarkupUnavailable =>
      'This PDF has no selectable text to mark.';

  @override
  String get annotationExporting => 'Making an annotated copy…';

  @override
  String get annotationExportFailed => 'Could not export the annotated copy.';

  @override
  String get annotationNothingToExport => 'Add a mark first.';

  @override
  String get annotationClearAllTitle => 'Clear all marks?';

  @override
  String get annotationClearAllMessage =>
      'This removes every mark on this file. It cannot be undone.';

  @override
  String get noteTitle => 'Note';

  @override
  String get noteHint => 'Write your note';

  @override
  String get deleteAction => 'Delete';

  @override
  String get bookmarksTitle => 'Bookmarks';

  @override
  String get bookmarksAction => 'Bookmarks';

  @override
  String get bookmarksEmpty => 'No bookmarks yet.';

  @override
  String bookmarkAddCurrent(int page) {
    return 'Bookmark page $page';
  }

  @override
  String bookmarkRemoveCurrent(int page) {
    return 'Remove bookmark on page $page';
  }

  @override
  String bookmarkPageLabel(int page) {
    return 'Page $page';
  }

  @override
  String get shareFailed => 'Could not share this file.';

  @override
  String get importTitle => 'Save as PDF';

  @override
  String get importBuilding => 'Making your PDF…';

  @override
  String get importReadyTitle => 'Your PDF is ready';

  @override
  String importImagesSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Made from $count pictures',
      one: 'Made from 1 picture',
    );
    return '$_temp0';
  }

  @override
  String get importTextSummary => 'Made from the text you shared.';

  @override
  String importSize(String size) {
    return 'Size: $size';
  }

  @override
  String get importSaveAction => 'Save as PDF';

  @override
  String get importShareAction => 'Share';

  @override
  String importSaved(String name) {
    return 'Saved $name';
  }

  @override
  String get importFailedTitle => 'Could not make the PDF';

  @override
  String get importUnsupportedTextTitle => 'These letters cannot be saved yet';

  @override
  String get importUnsupportedTextDetail =>
      'This app can only write English letters and numbers into a PDF. Malayalam and other scripts are not supported yet. A picture of the text will save fine.';

  @override
  String get printAction => 'Print';

  @override
  String get printTitle => 'Print';

  @override
  String get printWholeAction => 'Whole document';

  @override
  String get printWholeDescription => 'Print every page of this PDF.';

  @override
  String get printRangeAction => 'Page range';

  @override
  String get printRangeDescription => 'Choose which pages to print.';

  @override
  String get printTextAction => 'Text only';

  @override
  String get printTextDescription =>
      'Print the words of this PDF as plain pages.';

  @override
  String get printRangeTitle => 'Pages to print';

  @override
  String get printFromLabel => 'From page';

  @override
  String get printToLabel => 'To page';

  @override
  String printRangeInvalid(int pageCount) {
    return 'Enter a page range inside 1 to $pageCount.';
  }

  @override
  String get printPreparing => 'Getting the pages ready…';

  @override
  String get printUnavailable => 'This device cannot print.';

  @override
  String get printFailed => 'Could not start printing.';

  @override
  String get printNoText => 'This PDF has no text to print.';

  @override
  String get signaturesAction => 'Signatures';

  @override
  String get signaturesTitle => 'Signatures';

  @override
  String get signaturesChecking => 'Checking signatures…';

  @override
  String get signaturesNone => 'This PDF is not signed.';

  @override
  String get signaturesFailed => 'These signatures could not be checked.';

  @override
  String get signaturesFailedDetail =>
      'This does not mean the signatures are bad. It means the app could not read them, so it will not say either way.';

  @override
  String get signatureStatusTrusted => 'Signed and trusted';

  @override
  String get signatureStatusTrustedDetail =>
      'The document has not changed since it was signed, and you trust the signer\'s certificate.';

  @override
  String get signatureStatusValidNotTrusted => 'Signed, but signer unknown';

  @override
  String get signatureStatusValidNotTrustedDetail =>
      'The document has not changed since it was signed. But the app does not know the signer, so it cannot vouch for who they are.';

  @override
  String get signatureStatusInvalid => 'Signature is not valid';

  @override
  String get signatureStatusInvalidDetail =>
      'The document changed after it was signed, or the signature does not match. Do not rely on it.';

  @override
  String get signatureStatusUnknown => 'Signature could not be read';

  @override
  String get signatureStatusUnknownDetail =>
      'The app could not make sense of this signature, so it will not say whether it is good or bad.';

  @override
  String get signatureNotePartialCoverage => 'Covers only part of the file';

  @override
  String get signatureNotePartialCoverageDetail =>
      'Something was added to this file after it was signed. The signature says nothing about that part.';

  @override
  String get signatureNoteRevoked => 'The certificate was cancelled';

  @override
  String get signatureNoteRevokedDetail =>
      'Whoever issued this certificate has since cancelled it. It should not be trusted.';

  @override
  String get signatureNoteRevocationNotChecked =>
      'Could not check if the certificate was cancelled';

  @override
  String get signatureNoteRevocationNotCheckedDetail =>
      'Checking that needs the internet, which this app never uses, and this PDF does not carry the proof inside it.';

  @override
  String get signatureNoteCertExpired =>
      'The certificate had expired when it signed';

  @override
  String get signatureNoteCertExpiredDetail =>
      'The signing certificate was outside its valid dates at the time of signing.';

  @override
  String get signatureNoteUnverifiedTime => 'The signing time is only a claim';

  @override
  String get signatureNoteUnverifiedTimeDetail =>
      'This time is stored outside the signed part of the file, so anyone could have changed it.';

  @override
  String get signatureSignerLabel => 'Signed by';

  @override
  String get signatureSignerUnknown => 'Not stated';

  @override
  String get signatureSignedAtLabel => 'Signed on';

  @override
  String get signatureReasonLabel => 'Reason';

  @override
  String get signatureLocationLabel => 'Location';

  @override
  String get signatureCertificateTitle => 'Certificate';

  @override
  String get signatureIssuedToLabel => 'Issued to';

  @override
  String get signatureIssuedByLabel => 'Issued by';

  @override
  String get signatureValidFromLabel => 'Valid from';

  @override
  String get signatureValidUntilLabel => 'Valid until';

  @override
  String get signatureSelfSignedNote =>
      'This certificate vouches for itself. Nobody else backs it, so trust it only if you know the signer.';

  @override
  String get signatureTrustAction => 'Trust this certificate';

  @override
  String get signatureTrustTitle => 'Trust this signer?';

  @override
  String get signatureTrustExplain =>
      'From now on, any PDF signed with this certificate will show as trusted. Only do this if you know who the signer is.';

  @override
  String get signatureTrustConfirm => 'Trust';

  @override
  String get signatureTrustedToast => 'Certificate trusted.';

  @override
  String get trustStoreTitle => 'Trusted certificates';

  @override
  String get trustStoreEmpty => 'You have not trusted any certificates yet.';

  @override
  String get trustStoreEmptyDetail =>
      'When you trust a signer\'s certificate, it is listed here. You can remove it at any time.';

  @override
  String get trustStoreAddAction => 'Add a certificate';

  @override
  String get trustStoreRemoveAction => 'Remove';

  @override
  String get trustStoreRemoveTitle => 'Stop trusting this certificate?';

  @override
  String get trustStoreRemoveExplain =>
      'PDFs signed with it will stop showing as trusted.';

  @override
  String get trustStoreInvalidFile =>
      'That file is not a certificate the app can read.';

  @override
  String get trustStoreExpiredWarning => 'This certificate has expired.';

  @override
  String get trimMarginsAction => 'Trim margins';

  @override
  String get trimMarginsTitle => 'Smart Margin Trim';

  @override
  String get trimMarginsDescription =>
      'Crops blank page margins for mobile reading.';

  @override
  String get trimMarginsWorking => 'Trimming blank page margins…';

  @override
  String get trimMarginsDoneTitle => 'Margins trimmed';

  @override
  String get trimMarginsDoneNote =>
      'Blank margins cropped to fit mobile screens.';

  @override
  String get trimPaddingLabel => 'Margin padding';

  @override
  String get trimPaddingTight => 'Tight (4 pt)';

  @override
  String get trimPaddingStandard => 'Standard (12 pt)';

  @override
  String get trimPaddingComfortable => 'Comfortable (24 pt)';

  @override
  String get trimSymmetricLabel => 'Symmetric margins';

  @override
  String get trimSymmetricHelp => 'Keeps left and right margins balanced.';

  @override
  String get bookletAction => 'Create booklet';

  @override
  String get bookletTitle => 'Foldable Booklet (2-Up)';

  @override
  String get bookletDescription =>
      'Generates a 2-Up foldable booklet imposition layout for double-sided printing.';

  @override
  String get bookletWorking => 'Generating booklet layout…';

  @override
  String get bookletDoneTitle => 'Booklet generated';

  @override
  String get bookletDoneNote =>
      'Print double-sided (flip on short edge) and fold in half along the center spine.';

  @override
  String get bookletSummaryTitle => 'Booklet layout summary';

  @override
  String bookletSummaryPages(int source, int padded) {
    return '$source original pages -> $padded booklet pages';
  }

  @override
  String bookletSummarySheets(int sheets, int faces) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets physical landscape sheets',
      one: '1 physical landscape sheet',
    );
    return '$_temp0 ($faces printable sides)';
  }

  @override
  String bookletSummaryBlanks(int blanks) {
    String _temp0 = intl.Intl.pluralLogic(
      blanks,
      locale: localeName,
      other: '$blanks blank filler pages added at end',
      one: '1 blank filler page added at end',
    );
    return '$_temp0';
  }

  @override
  String get bookletBindingLabel => 'Binding direction';

  @override
  String get bookletBindingLtr => 'Left to Right (LTR)';

  @override
  String get bookletBindingRtl => 'Right to Left (RTL)';

  @override
  String get bookletPaperSizeLabel => 'Paper size';

  @override
  String get bookletPaperAuto => 'Match source';

  @override
  String get bookletPaperA4 => 'A4 Landscape';

  @override
  String get bookletPaperLetter => 'US Letter';

  @override
  String get bookletFoldGuideLabel => 'Center fold guide';

  @override
  String get bookletFoldGuideHelp =>
      'Draws a faint dotted guideline showing where to fold the booklet.';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceSubtitle => 'Theme mode, typography, and colors';

  @override
  String get themeModeTitle => 'Theme Mode';

  @override
  String get themeModeSubtitle =>
      'Choose between Light, Dark, System, or Sepia mode';

  @override
  String get themeModeCardSubtitle => 'Select Light, Dark, or System';

  @override
  String get themeModeDescription =>
      'System mode automatically follows your device\'s system-wide dark mode setting. Sepia mode provides a warm, eye-comfort reading background.';

  @override
  String get typographyTitle => 'Typography & Text Size';

  @override
  String get typographySubtitle => 'App font family and text size';

  @override
  String get typographyDescription =>
      'Customize the app font family and reading text size for better readability across screens.';

  @override
  String get typographyFontLabel => 'Font';

  @override
  String get typographyTextSizeLabel => 'Text Size';

  @override
  String get fontSystemDefault => 'System Default';

  @override
  String get fontManjari => 'Manjari';

  @override
  String get fontAnekMalayalam => 'Anek Malayalam';

  @override
  String get fontNotoSansMalayalam => 'Noto Sans Malayalam';

  @override
  String get textSizeSmall => 'Small';

  @override
  String get textSizeDefault => 'Default';

  @override
  String get textSizeLarge => 'Large';

  @override
  String get textSizeLarger => 'Larger';

  @override
  String get typographySampleLatin => 'The quick brown fox 0123';

  @override
  String get typographySampleMalayalam => 'മലയാളം സുന്ദരമാണ്';

  @override
  String get accentColorTitle => 'Accent Color';

  @override
  String get accentColorSubtitle => 'Presets, color wheel, live preview';

  @override
  String get accentAppliesToLight =>
      'This color is used while the app is in light mode.';

  @override
  String get accentAppliesToDark =>
      'This color is used while the app is in dark mode.';

  @override
  String get livePreviewLabel => 'LIVE PREVIEW';

  @override
  String get sampleText => 'Sample text';

  @override
  String get presetsLabel => 'PRESETS';

  @override
  String get customColorWheelLabel => 'CUSTOM COLOR WHEEL';

  @override
  String get resetToDefault => 'Reset to default';

  @override
  String get resetLightToDefault => 'Reset Light to default';

  @override
  String get resetDarkToDefault => 'Reset Dark to default';

  @override
  String get contrastNotice =>
      'Text contrast is adjusted automatically for readability.';

  @override
  String get permissionsTitle => 'Permissions';

  @override
  String get permissionsSubtitle =>
      'Storage, virtual print service and privacy capabilities';

  @override
  String get permissionsOpenSettings => 'Open system settings';

  @override
  String get permissionsExplicitHeader => 'Capabilities';

  @override
  String get permissionsExplicitSubtitle =>
      'Features and system roles designed for safe document access.';

  @override
  String get permissionsImplicitHeader => 'Privacy & System Declarations';

  @override
  String get permissionsImplicitSubtitle =>
      'Declared in the manifest; 100% safe offline processing.';

  @override
  String get permScopedStorageTitle => 'Scoped Storage (SAF)';

  @override
  String get permScopedStorageReason =>
      'Open and save documents securely via the Android system file picker without broad device storage permissions.';

  @override
  String get permPrintServiceTitle => 'Virtual Print Service';

  @override
  String get permPrintServiceReason =>
      'Allows other Android apps to print documents directly to SreerajP PDF App.';

  @override
  String get permOfflineTitle => '100% Offline & Private';

  @override
  String get permOfflineReason =>
      'Zero internet permissions. Your documents and data never leave this device.';

  @override
  String get permTtsTitle => 'Text-to-Speech Engine';

  @override
  String get permTtsReason =>
      'Queries installed speech engines for reading documents aloud in English and Malayalam.';

  @override
  String get permProcessTextTitle => 'Process Text Action';

  @override
  String get permProcessTextReason =>
      'Enables quick searching and text actions when selecting text in other applications.';

  @override
  String get statusActive => 'Active';

  @override
  String get statusSystem => 'System';

  @override
  String get statusOffline => 'Offline';

  @override
  String get trustStoreSubtitle => 'Manage digital signature root certificates';

  @override
  String get aboutSubtitle => 'App version, licenses, and legal info';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpSubtitle => 'Guides, setup instructions, and tips';

  @override
  String get helpPdfPrinterTitle => 'PDF Printer Setup';

  @override
  String get helpPdfPrinterSubtitle =>
      'How to enable and use the virtual print service';

  @override
  String get helpPdfPrinterTopicHeader =>
      '1. How to Enable the PDF Printer on Android';

  @override
  String get helpPdfPrinterIntro =>
      'On Android, virtual print services are managed at the system level. To enable SreerajP PDF App as a system-wide printer:';

  @override
  String get helpPdfPrinterStep1 => 'Open your Android device\'s Settings.';

  @override
  String get helpPdfPrinterStep2 =>
      'Go to Connected devices → Connection preferences → Printing (or search for \"Printing\" in your Settings search bar).';

  @override
  String get helpPdfPrinterStep3 =>
      'Under Print services, find SreerajP PDF App (or your app\'s name).';

  @override
  String get helpPdfPrinterStep4 => 'Tap it and switch the toggle to On.';

  @override
  String get helpOpenPrintSettings => 'Open Print Settings';

  @override
  String get helpUnicodePrintingTitle => 'Unicode & Malayalam PDF Printing';

  @override
  String get helpUnicodePrintingSubtitle =>
      'Printing complex Indic scripts without broken characters';

  @override
  String get helpUnicodePrintingTopicHeader =>
      'Printing Unicode & Malayalam Text Accurately';

  @override
  String get helpUnicodePrintingIntro =>
      'Standard Android printing can sometimes garble complex scripts (such as Malayalam, Hindi, or Sanskrit), resulting in broken chillu characters, disconnected conjuncts, or missing fonts. SreerajP PDF App handles complex script shaping and font embedding to generate pristine PDFs.';

  @override
  String get helpUnicodePrintingStep1 =>
      'Enable the PDF Virtual Printer in Android Settings if you haven\'t already.';

  @override
  String get helpUnicodePrintingStep2 =>
      'In any app (such as Chrome, WhatsApp, or Office), select Print from the menu.';

  @override
  String get helpUnicodePrintingStep3 =>
      'Select \'SreerajP PDF App\' as the target printer instead of the standard Android \'Save as PDF\'.';

  @override
  String get helpUnicodePrintingStep4 =>
      'The app captures the print spool, resolves Unicode glyphs and fonts, and creates a crisp, readable PDF file.';

  @override
  String get helpUnicodePrintingTip =>
      'Tip: For web articles with complex layouts, enable \'Clean Web Content\' in Printer Settings to strip unwanted ads and headers automatically.';

  @override
  String get helpOpenPrinterSettings => 'Open Printer Settings';

  @override
  String get helpTtsTitle => 'Read Aloud (TTS) & Malayalam Voice';

  @override
  String get helpTtsSubtitle =>
      'Configure speech engine, voice speed, and Malayalam support';

  @override
  String get helpTtsTopicHeader =>
      'How to Use Read Aloud and Install Malayalam Voices';

  @override
  String get helpTtsIntro =>
      'The app can read PDF text aloud using your device\'s Text-to-Speech (TTS) engine. It supports both English and Malayalam.';

  @override
  String get helpTtsStep1 =>
      'Open any text-based PDF and tap the \'Read Aloud\' (speaker) button in the top bar.';

  @override
  String get helpTtsStep2 =>
      'If the Malayalam voice is not installed, go to Settings → Read Aloud (TTS) and tap \'Get the Malayalam voice\'.';

  @override
  String get helpTtsStep3 =>
      'You can customize speech speed, voice pitch, sentence-ending pauses, and auto-scrolling to match your reading style.';

  @override
  String get helpTtsTip =>
      'Note: Scanned documents containing only images without a selectable text layer cannot be read aloud. OCR is not supported.';

  @override
  String get helpOpenTtsSettings => 'Open TTS Settings';

  @override
  String get helpPageOpsTitle => 'Organizing & Modifying Pages';

  @override
  String get helpPageOpsSubtitle =>
      'Merge, split, reorder, rotate, booklet, and N-Up layouts';

  @override
  String get helpPageOpsTopicHeader => 'Page Operations & Copy-on-Write Safety';

  @override
  String get helpPageOpsIntro =>
      'Easily reorganize or transform pages in your PDF documents. Every operation strictly adheres to Copy-on-Write — your original document is never modified in place.';

  @override
  String get helpPageOpsStep1 =>
      'Open a document and tap the Page Operations menu (or use the Organizer view).';

  @override
  String get helpPageOpsStep2 =>
      'Select desired actions: Reorder pages by dragging, Rotate individual or all pages, or Delete unwanted pages.';

  @override
  String get helpPageOpsStep3 =>
      'Use \'Booklet Creation\' for foldable 2-up booklets or \'N-Up Layout\' to fit multiple pages (2, 4, 6, 9) onto a single sheet.';

  @override
  String get helpPageOpsStep4 =>
      'Tap Save / Export to generate a brand new PDF file in your chosen location.';

  @override
  String get helpPageOpsTip =>
      'Safety Guarantee: Because operations create a new file, you can experiment freely without risking loss or damage to your original PDFs.';

  @override
  String get helpSignaturesTitle => 'Digital Signatures & Trust Store';

  @override
  String get helpSignaturesSubtitle =>
      'Offline cryptographic verification and certificate management';

  @override
  String get helpSignaturesTopicHeader =>
      'Verifying Digital Signatures Offline';

  @override
  String get helpSignaturesIntro =>
      'SreerajP PDF App verifies digital signatures completely offline using cryptographic algorithms (SHA-256 digests and X.509 certificate chains) with zero network requests.';

  @override
  String get helpSignaturesStep1 =>
      'When opening a signed PDF, tap the Signature Badge in the top bar to inspect signer details and byte coverage.';

  @override
  String get helpSignaturesStep2 =>
      'The app checks if the document has been altered or tampered with since it was signed.';

  @override
  String get helpSignaturesStep3 =>
      'If a certificate shows as untrusted, you can inspect the certificate chain and add trusted root certificates in the Trust Store.';

  @override
  String get helpSignaturesTip =>
      'Security Note: All cryptographic checking runs locally in Kotlin using Bouncy Castle and CertPathValidator without sending documents to any remote server.';

  @override
  String get helpOpenTrustStore => 'Open Trust Store';

  @override
  String get helpPrivacyStorageTitle => 'Privacy & Scoped Storage';

  @override
  String get helpPrivacyStorageSubtitle =>
      'Zero internet permissions and Scoped Storage security';

  @override
  String get helpPrivacyStorageTopicHeader => '100% Offline Privacy Guarantee';

  @override
  String get helpPrivacyStorageIntro =>
      'Your privacy is paramount. SreerajP PDF App is built from the ground up to operate in total isolation without internet connectivity.';

  @override
  String get helpPrivacyStorageStep1 =>
      'Zero Internet: The app\'s manifest contains no INTERNET permission. It cannot transmit data or collect analytics.';

  @override
  String get helpPrivacyStorageStep2 =>
      'Scoped Storage (SAF): The app only accesses files you explicitly pick via Android\'s system file picker.';

  @override
  String get helpPrivacyStorageStep3 =>
      'Temporary Cache Management: Render caches and printer spool files can be cleared at any time from Storage Settings.';

  @override
  String get helpPrivacyStorageTip =>
      'Password Safety: Passwords entered for encrypted PDFs are kept in volatile memory only and are never saved to disk or logged.';

  @override
  String get helpOpenStorageSettings => 'Open Storage & Privacy Settings';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Choose app language';

  @override
  String get languageSystem => 'System Default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageMalayalam => 'മലയാളം (Malayalam)';

  @override
  String get languageSelectTitle => 'App Language';

  @override
  String get languageSelectSubtitle =>
      'Changes apply immediately across the entire application.';

  @override
  String get readerSettingsTitle => 'Reader & Viewer';

  @override
  String get readerSettingsSubtitle =>
      'Reading position, layout, zoom, and display';

  @override
  String get saveLastPositionTitle => 'Remember Reading Position';

  @override
  String get saveLastPositionSubtitle =>
      'Automatically resume from the last viewed page and zoom level';

  @override
  String get defaultPageLayoutTitle => 'Default Page Layout';

  @override
  String get defaultPageLayoutSubtitle =>
      'Choose how pages are presented when opening documents';

  @override
  String get layoutContinuous => 'Continuous Scroll';

  @override
  String get layoutSinglePage => 'Single Page';

  @override
  String get doubleTapZoomTitle => 'Double-Tap Zoom';

  @override
  String get doubleTapZoomSubtitle =>
      'Action performed on double-tapping a PDF page';

  @override
  String get zoomFitWidth => 'Fit to Width';

  @override
  String get zoom200 => 'Zoom to 200%';

  @override
  String get showPageIndicatorTitle => 'Page Number Indicator';

  @override
  String get showPageIndicatorSubtitle =>
      'Display page indicator pill overlay while reading';

  @override
  String get invertColorsTitle => 'Invert PDF Colors';

  @override
  String get invertColorsSubtitle =>
      'Inverts document colors for night-time reading';

  @override
  String get ttsSettingsTitle => 'Read Aloud (TTS)';

  @override
  String get ttsSettingsSubtitle =>
      'Voice, speech speed, pitch, and playback options';

  @override
  String get ttsSpeechRateTitle => 'Speech Rate';

  @override
  String ttsSpeechRateSubtitle(String rate) {
    return '${rate}x speed';
  }

  @override
  String get ttsPitchTitle => 'Voice Pitch';

  @override
  String ttsPitchSubtitle(String pitch) {
    return '${pitch}x pitch';
  }

  @override
  String get ttsAutoScrollTitle => 'Auto-Scroll with Speech';

  @override
  String get ttsAutoScrollSubtitle =>
      'Automatically scroll the document as sentences are spoken';

  @override
  String get printerSettingsTitle => 'PDF Virtual Printer';

  @override
  String get printerSettingsSubtitle =>
      'Print service integration, paper size, and cache';

  @override
  String get printerEnableTitle => 'Enable PDF Printer Integration';

  @override
  String get printerEnableSubtitle =>
      'Accept print jobs from other apps and save them as PDF';

  @override
  String get defaultPaperSizeTitle => 'Default Paper Size';

  @override
  String get defaultPaperSizeSubtitle =>
      'Default page dimensions for generated PDFs';

  @override
  String get defaultColorModeTitle => 'Default Color Mode';

  @override
  String get defaultColorModeSubtitle => 'Color output for printed documents';

  @override
  String get colorModeColor => 'Color';

  @override
  String get colorModeGrayscale => 'Grayscale';

  @override
  String get colorModeMonochrome => 'Monochrome (Black & White)';

  @override
  String get defaultOrientationTitle => 'Default Orientation';

  @override
  String get defaultOrientationSubtitle => 'Page orientation for print jobs';

  @override
  String get orientationAuto => 'Auto (Match Source)';

  @override
  String get orientationPortrait => 'Portrait';

  @override
  String get orientationLandscape => 'Landscape';

  @override
  String get clearPrinterCacheTitle => 'Clear Printer Cache';

  @override
  String clearPrinterCacheSubtitle(String size) {
    return 'Purge temporary PDF spool files ($size)';
  }

  @override
  String get printerCacheCleared => 'Printer cache cleared.';

  @override
  String get storageSettingsTitle => 'Storage & Privacy';

  @override
  String get storageSettingsSubtitle =>
      'Recent files history and cache cleanup';

  @override
  String get rememberRecentFilesTitle => 'Remember Recent Files';

  @override
  String get rememberRecentFilesSubtitle =>
      'Save opened documents to the recents list on Home';

  @override
  String get clearRecentFilesTitle => 'Clear Recent Files History';

  @override
  String get clearRecentFilesSubtitle =>
      'Remove all opened document records and saved positions';

  @override
  String get clearRecentFilesConfirmTitle => 'Clear recent files?';

  @override
  String get clearRecentFilesConfirmMessage =>
      'This will clear your recent files list and reading progress. The original PDF files on your device will NOT be deleted.';

  @override
  String get clearRecentFilesAction => 'Clear History';

  @override
  String get recentFilesCleared => 'Recent files history cleared.';

  @override
  String get clearTempCacheTitle => 'Clear App Cache';

  @override
  String clearTempCacheSubtitle(String size) {
    return 'Free up temporary space without losing data ($size)';
  }

  @override
  String get tempCacheCleared => 'Temporary cache cleared.';

  @override
  String get securitySettingsTitle => 'Signatures & Trust';

  @override
  String get securitySettingsSubtitle =>
      'Digital signature verification and custom certificates';

  @override
  String get autoVerifySignaturesTitle => 'Auto-Verify Signatures';

  @override
  String get autoVerifySignaturesSubtitle =>
      'Automatically check digital signatures when opening signed PDFs';

  @override
  String get permFileProviderTitle => 'Secure File Provider';

  @override
  String get permFileProviderReason =>
      'Shares temporary PDFs and extracted files with external apps without exposing private file paths.';

  @override
  String get permFileProviderWhatItAchieves =>
      'Enables safe sharing and printing of PDFs to external apps without compromising storage security.';

  @override
  String get permTtsInstallTitle => 'Voice Data Installer';

  @override
  String get permTtsInstallReason =>
      'Opens system voice package download screens if required language voices are missing.';

  @override
  String get permTtsInstallWhatItAchieves =>
      'Enables guided installation of Malayalam and English speech voices without dead-ends.';

  @override
  String get permSendShareTitle => 'Receive Shares & \'Open with\'';

  @override
  String get permSendShareReason =>
      'Receives images, plain text, and PDF files shared from other applications.';

  @override
  String get permSendShareWhatItAchieves =>
      'Enables direct conversion of shared images and text into PDFs and opening PDFs from any app.';

  @override
  String get permZeroInternetTitle => 'Zero Internet Guarantee';

  @override
  String get permZeroInternetReason =>
      'No android.permission.INTERNET is requested. The app runs 100% offline.';

  @override
  String get permZeroInternetWhatItAchieves =>
      'Guarantees complete privacy with zero data leakage, tracking, or remote telemetry.';

  @override
  String get permScopedStorageWhatItAchieves =>
      'Allows reading and saving PDFs selected by the user while keeping the rest of the device private.';

  @override
  String get permPrintServiceWhatItAchieves =>
      'Allows other Android apps to send print jobs directly to SreerajP PDF App to save as PDF.';

  @override
  String get permOfflineWhatItAchieves =>
      'Ensures document contents and personal information never leave your device.';

  @override
  String get permTtsWhatItAchieves =>
      'Discovers installed speech engines to read documents aloud in English and Malayalam.';

  @override
  String get permProcessTextWhatItAchieves =>
      'Allows selected text in any app to be processed or searched directly in SreerajP PDF App.';

  @override
  String get permWhyNeededHeader => 'Why it is needed';

  @override
  String get permWhatItAchievesHeader => 'What this achieves';

  @override
  String get permTypeExplicit => 'Explicit Capability';

  @override
  String get permTypeImplicit => 'Implicit / System Query';

  @override
  String get permTypePrivacy => 'Privacy Guarantee';

  @override
  String get readingVelocityTitle => 'Reading Velocity & Time Estimates';

  @override
  String get readingVelocitySubtitle =>
      'Calculates remaining reading time based on your reading speed';

  @override
  String readingSpeedLabel(int wpm) {
    return '$wpm wpm';
  }

  @override
  String readingTimeLeftChapter(int minutes) {
    return '$minutes min left in chapter';
  }

  @override
  String readingTimeLeftDoc(int minutes) {
    return '$minutes min left';
  }

  @override
  String get readingTimeLessMinute => '< 1 min left';

  @override
  String get readingTimeEstimatesToggle => 'Reading Time Estimates';

  @override
  String get readingTimeEstimatesToggleSubtitle =>
      'Display remaining chapter and document reading time in the reader bar';

  @override
  String get viewModeAuto => 'Auto (Dual-page on wide / foldables)';

  @override
  String get viewModeAutoSubtitle =>
      'Single-page on phones; dual-page book view on foldables and tablets';

  @override
  String get malayalamHelperTitle => 'Malayalam Keyboard Helper';

  @override
  String get malayalamHelperTooltip =>
      'Malayalam input helper (Manglish typing & keypad)';

  @override
  String get malayalamKeypadTabTranslit => 'Manglish';

  @override
  String get malayalamKeypadTabVowels => 'Vowels';

  @override
  String get malayalamKeypadTabConsonants => 'Consonants';

  @override
  String get malayalamKeypadTabSigns => 'Signs & Chillu';

  @override
  String get ttsSentencePauseTitle => 'Sentence-Ending Pause';

  @override
  String ttsSentencePauseSubtitle(String seconds) {
    return '${seconds}s pause between sentences';
  }

  @override
  String ttsReadingPage(int page) {
    return 'Reading page $page...';
  }

  @override
  String get ttsPaused => 'Paused';

  @override
  String ttsReadyToRead(int page) {
    return 'Ready to read page $page';
  }

  @override
  String get watermarkAction => 'Custom watermark';

  @override
  String get watermarkDescription => 'Add text or image watermark onto pages';

  @override
  String get watermarkDialogTitle => 'Custom Watermark';

  @override
  String get watermarkTextLabel => 'Watermark Text';

  @override
  String get watermarkEmptyTextError => 'Please enter watermark text.';

  @override
  String get watermarkDoneTitle => 'Watermarked PDF Created';

  @override
  String get watermarkOpacityLabel => 'Opacity';

  @override
  String get watermarkRotationLabel => 'Rotation Angle';

  @override
  String get watermarkFontSizeLabel => 'Font Size';

  @override
  String get watermarkColorLabel => 'Color';

  @override
  String get watermarkTiledLabel => 'Tile across page';

  @override
  String get watermarkTiledDescription =>
      'Repeats watermark pattern across entire page';

  @override
  String get watermarkPageRangeLabel => 'Apply to';

  @override
  String get watermarkAllPages => 'All pages';

  @override
  String get watermarkOddPages => 'Odd pages only';

  @override
  String get watermarkEvenPages => 'Even pages only';

  @override
  String get watermarkApplyAction => 'Apply Watermark';

  @override
  String get batchOperationsTitle => 'Batch Operations';

  @override
  String get batchOperationsDescription => 'Process multiple PDF files at once';

  @override
  String get batchOperationLabel => 'Select Operation';

  @override
  String get batchOpEncrypt => 'Batch Encrypt / Protect';

  @override
  String get batchOpMerge => 'Batch Merge';

  @override
  String get batchOpExtractText => 'Batch Extract Text (.txt)';

  @override
  String get batchOpTrimMargins => 'Batch Trim Margins';

  @override
  String get batchOpCompress => 'Batch Compress';

  @override
  String batchSelectedFilesCount(int count) {
    return 'Selected Files ($count)';
  }

  @override
  String get batchAddFilesAction => 'Add Files';

  @override
  String get batchNoFilesSelected =>
      'No PDF files selected. Tap Add Files to select PDFs.';

  @override
  String batchProgressLabel(int current, int total, String name) {
    return 'Processing $current of $total: $name';
  }

  @override
  String get batchStartAction => 'Start Batch Operation';

  @override
  String batchDoneSummary(int success, int total) {
    return 'Successfully processed $success of $total documents.';
  }

  @override
  String get batchFailedAll => 'Batch processing failed for all documents.';

  @override
  String get nUpAction => 'N-Up multi-page layout';

  @override
  String get nUpDescription => 'Fit 2, 4, 6, or 9 pages onto each sheet';

  @override
  String get nUpDialogTitle => 'N-Up Multi-Page Layout';

  @override
  String get nUpGridLabel => 'Grid Layout';

  @override
  String get nUpSheetSizeLabel => 'Sheet Size';

  @override
  String get nUpSheetA4 => 'A4';

  @override
  String get nUpSheetLetter => 'US Letter';

  @override
  String get nUpOrientationLabel => 'Sheet Orientation';

  @override
  String get nUpOrientationAuto => 'Auto';

  @override
  String get nUpOrientationPortrait => 'Portrait';

  @override
  String get nUpOrientationLandscape => 'Landscape';

  @override
  String get nUpBordersLabel => 'Draw Page Borders';

  @override
  String get nUpBordersDescription =>
      'Draws subtle grid boundary line around each page slot';

  @override
  String get nUpMarginLabel => 'Margin Padding';

  @override
  String get nUpDoneTitle => 'N-Up Multi-Page PDF Created';

  @override
  String get printNUpAction => 'Print N-Up multi-page grid';

  @override
  String get printNUpDescription =>
      'Print multiple pages per sheet (2-in-1, 4-in-1, etc.)';

  @override
  String get cleanWebContentTitle => 'Clean Web Content (Reader Mode)';

  @override
  String get cleanWebContentSubtitle =>
      'Removes headers, footers, sidebars, scripts, and ads before saving';

  @override
  String pagesDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages deleted',
      one: '1 page deleted',
    );
    return '$_temp0';
  }

  @override
  String organizeSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectAllAction => 'Select all';

  @override
  String get deselectAllAction => 'Deselect';

  @override
  String get invertSelectionAction => 'Invert';

  @override
  String get trustStoreExportAction => 'Export Certificate';

  @override
  String get trustStoreExportAllAction => 'Export All Certificates';

  @override
  String trustStoreExportSuccess(String name) {
    return 'Certificate exported to $name';
  }

  @override
  String get signatureTrustSignerAction => 'Trust Signer';

  @override
  String get signatureUnnamed => 'Digital Signature';

  @override
  String get signatureTimeLabel => 'Signing Time';

  @override
  String get signatureTimeClaimOnly => 'unverified claim';

  @override
  String get signatureIntegrityLabel => 'Document Integrity';

  @override
  String get signatureIntegrityValid => 'Document unmodified since signing';

  @override
  String get signatureIntegrityInvalid => 'Document modified after signing';

  @override
  String get signatureIntegrityUnknown => 'Integrity could not be verified';

  @override
  String get signatureCoverageLabel => 'Byte Coverage';

  @override
  String get signatureCoversWholeFile => 'Signature covers the entire document';

  @override
  String get signatureCoversPartialFile =>
      'Signature covers only part of the document';

  @override
  String get signatureCertificateHeader => 'Signer Certificate Details';

  @override
  String get featuresTitle => 'Features';

  @override
  String get featuresSubtitle => 'Explore all features of SreerajP PDF App';

  @override
  String get featuresHeaderTitle => 'SreerajP PDF App Features';

  @override
  String get featuresHeaderSubtitle =>
      'Explore every intelligent tool, privacy safeguard, and PDF feature designed for you.';

  @override
  String get featuresCategoryViewing => 'PDF Viewing & Navigation Engine';

  @override
  String get featuresCategoryViewingSubtitle =>
      'High-performance rendering, continuous scrolling, book view, and smart navigation';

  @override
  String get featuresCategorySearch => 'Search, Indic Phonetics & Speech';

  @override
  String get featuresCategorySearchSubtitle =>
      'Sandhi-aware Indic search, Malayalam transliteration, and text-to-speech';

  @override
  String get featuresCategoryAnnotations => 'Annotation Overlay & Markups';

  @override
  String get featuresCategoryAnnotationsSubtitle =>
      'Non-destructive markups, ink drawing, notes, and PDF flattening';

  @override
  String get featuresCategoryPageOps => 'Page Operations & Reorganization';

  @override
  String get featuresCategoryPageOpsSubtitle =>
      'Visual page organizer, booklet imposition, watermarks, and batch tools';

  @override
  String get featuresCategoryExtraction => 'Data Extraction & Utilities';

  @override
  String get featuresCategoryExtractionSubtitle =>
      'Extract plain text, embedded images, form fields, and metadata';

  @override
  String get featuresCategoryPrinter => 'Virtual Printer & Share Hub';

  @override
  String get featuresCategoryPrinterSubtitle =>
      'System-wide virtual PDF printer, web cleaner, and image/text conversion';

  @override
  String get featuresCategorySignatures => 'Digital Signatures & Trust Store';

  @override
  String get featuresCategorySignaturesSubtitle =>
      'Native cryptographic verification, visual stamp badges, and custom trust store';

  @override
  String get featuresCategoryThemes => 'Themes & Customization';

  @override
  String get featuresCategoryThemesSubtitle =>
      'OLED dark mode, custom typography, HSV accent color picker, and settings hubs';

  @override
  String get featuresCategoryGuides => 'Built-In User Guides';

  @override
  String get featuresCategoryGuidesSubtitle =>
      'Comprehensive offline tutorials and troubleshooting guides';

  @override
  String get helpHeaderTitle => 'Help Center & Knowledge Base';

  @override
  String get helpHeaderSubtitle =>
      'Browse in-depth guides and solutions for all features of SreerajP PDF App.';

  @override
  String get helpSectionPrinting => 'Printing & Conversion';

  @override
  String get helpSectionReading => 'Reading & Speech';

  @override
  String get helpSectionPageOps => 'Document Operations';

  @override
  String get helpSectionSecurity => 'Security & Privacy';
}
