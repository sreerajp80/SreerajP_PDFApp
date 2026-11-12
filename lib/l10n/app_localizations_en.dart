// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleApp => 'Folio';

  @override
  String get titleHome => 'Folio';

  @override
  String get bodyHomeEmpty =>
      'No PDF open yet. Opening files comes in the next phase.';

  @override
  String get titleSettings => 'Settings';

  @override
  String get labelSettingsTheme => 'Theme';

  @override
  String get labelThemeSystem => 'System';

  @override
  String get labelThemeLight => 'Light';

  @override
  String get labelThemeDark => 'Dark';

  @override
  String get labelThemeSepia => 'Sepia';

  @override
  String get labelThemeOled => 'OLED Pitch-Black';

  @override
  String get titleAbout => 'About';

  @override
  String get labelOpenSettings => 'Settings';

  @override
  String get labelOpenAbout => 'About';

  @override
  String get labelOpenPdf => 'Open PDF';

  @override
  String get titleRecentFiles => 'Recent files';

  @override
  String get emptyRecentFiles =>
      'No recent files yet. Tap \"Open PDF\" to read one.';

  @override
  String get labelRemoveFromRecents => 'Remove';

  @override
  String get descFileUnavailable => 'Not available';

  @override
  String get errorOpenFailed => 'Could not open the file.';

  @override
  String get errorReopenFailed =>
      'This file could not be reopened. The app may no longer have permission to open it, or it was moved or deleted.';

  @override
  String get titleReopenFailed => 'Can\'t reopen file';

  @override
  String get helpReopenFailed =>
      'Files opened from another app with \"Open with\" can only be reopened until this app closes. Pick the file once more to keep it in the list.';

  @override
  String get labelFindFileAgain => 'Find file';

  @override
  String descPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get labelViewModeContinuous => 'Continuous';

  @override
  String get labelViewModeSingle => 'Single page';

  @override
  String get labelViewModeBook => 'Two pages';

  @override
  String get tooltipViewMode => 'View mode';

  @override
  String get labelFitWidth => 'Fit width';

  @override
  String get labelFitPage => 'Fit page';

  @override
  String get labelPageFit => 'Page fit';

  @override
  String get labelZoomIn => 'Zoom in';

  @override
  String get labelZoomOut => 'Zoom out';

  @override
  String get labelResetZoom => 'Reset zoom';

  @override
  String get labelInvertColors => 'Night colors';

  @override
  String get titleContents => 'Contents';

  @override
  String get emptyOutline => 'This PDF has no contents.';

  @override
  String get titleThumbnails => 'Pages';

  @override
  String get labelGoToPage => 'Go to page';

  @override
  String descPageOfPages(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get labelPageNumberHint => 'Page number';

  @override
  String get actionGo => 'Go';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get titlePassword => 'Password required';

  @override
  String get bodyPassword =>
      'This PDF is protected. Enter its password to read it.';

  @override
  String get labelPasswordHint => 'Password';

  @override
  String get actionUnlock => 'Unlock';

  @override
  String get actionTryAgain => 'Try again';

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
  String get descLargeFileWarning =>
      'This is a large PDF, so it opens one page at a time for smoother reading.';

  @override
  String get labelLoadingPdf => 'Opening…';

  @override
  String get labelYes => 'Yes';

  @override
  String get titleMetadata => 'Details';

  @override
  String get actionMetadata => 'Details';

  @override
  String get labelMetadataFileSection => 'File';

  @override
  String get labelMetadataFileName => 'Name';

  @override
  String get labelMetadataFileSize => 'Size';

  @override
  String get labelMetadataPdfSection => 'PDF details';

  @override
  String get errorMetadataUnavailable => 'These details could not be read.';

  @override
  String get descMetadataNoFields => 'This PDF does not describe itself.';

  @override
  String get labelMetadataTitleField => 'Title';

  @override
  String get labelMetadataAuthor => 'Author';

  @override
  String get labelMetadataSubject => 'Subject';

  @override
  String get labelMetadataKeywords => 'Keywords';

  @override
  String get labelMetadataCreator => 'Made with';

  @override
  String get labelMetadataProducer => 'Saved by';

  @override
  String get labelMetadataCreated => 'Created';

  @override
  String get labelMetadataModified => 'Changed';

  @override
  String get labelMetadataPages => 'Pages';

  @override
  String get labelMetadataPdfVersion => 'PDF version';

  @override
  String get labelMetadataProtected => 'Password protected';

  @override
  String get actionSearch => 'Search';

  @override
  String get labelSearchHint => 'Search in this PDF';

  @override
  String get labelSearchClose => 'Close search';

  @override
  String get labelSearchClear => 'Clear';

  @override
  String get labelSearchNextMatch => 'Next match';

  @override
  String get labelSearchPreviousMatch => 'Previous match';

  @override
  String get labelSearchSearching => 'Searching…';

  @override
  String get labelSearchNoMatches => 'No matches';

  @override
  String labelSearchMatchOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String descSearchLimitReached(int count) {
    return 'Showing the first $count matches. Try a longer word.';
  }

  @override
  String get tooltipSearchOptions => 'Search options';

  @override
  String get labelSearchOptionStrict => 'Exact spelling';

  @override
  String get descSearchOptionStrictNote =>
      'Tell joined and unjoined spellings apart';

  @override
  String get labelSearchOptionIgnoreAccents => 'Ignore accent marks';

  @override
  String get descSearchOptionIgnoreAccentsNote =>
      'Useful for Sanskrit chant accents';

  @override
  String get descSearchOptionSandhi => 'Sandhi compound search';

  @override
  String get descSearchOptionSandhiNote =>
      'Find joined or split compound words (Malayalam & Sanskrit)';

  @override
  String get labelSearchOptionPhonetic => 'Phonetic matching';

  @override
  String get descSearchOptionPhoneticNote =>
      'Match sound-alike letters, anusvara nasals, and chillu variations';

  @override
  String get titleNoText => 'No selectable text';

  @override
  String get bodyNoText =>
      'This PDF has no text layer, so it looks scanned. Search, copy, and read aloud are not available. This app does not read text from pictures.';

  @override
  String get titleGarbledText => 'Text unreadable';

  @override
  String get bodyGarbledText =>
      'This PDF\'s fonts do not say which letters they show, so search and read aloud would give wrong results. Reading the pages still works.';

  @override
  String get descSearchUnavailableNoText =>
      'Search needs selectable text, and this PDF has none.';

  @override
  String get descSearchUnavailableGarbled =>
      'Search is off because this PDF\'s text cannot be read properly.';

  @override
  String get titleUnreliableText => 'Text may be wrong';

  @override
  String get bodyUnreliableText =>
      'This PDF\'s text may not be stored as proper Unicode. Search and read aloud may miss words or read them wrongly. Reading the pages still works.';

  @override
  String get descSearchUnreliable =>
      'This PDF\'s text may not be proper Unicode, so some matches may be missing or wrong.';

  @override
  String get actionDismiss => 'Got it';

  @override
  String get labelTtsReadAloud => 'Read aloud';

  @override
  String get labelTtsPause => 'Pause';

  @override
  String get labelTtsStop => 'Stop';

  @override
  String get descTtsUnavailableNoText =>
      'Read aloud needs selectable text, and this PDF has none.';

  @override
  String get descTtsUnavailableGarbled =>
      'Read aloud is off because this PDF\'s text cannot be read properly.';

  @override
  String get descTtsUnavailableNoVoice =>
      'No speech voice is installed on this device.';

  @override
  String get descTtsNothingToRead => 'There is nothing to read on this page.';

  @override
  String get labelSettingsReadAloud => 'Read aloud';

  @override
  String get labelSettingsMalayalamVoice => 'Malayalam voice';

  @override
  String get descSettingsMalayalamVoiceReady =>
      'Ready. Malayalam text will be read in Malayalam.';

  @override
  String get descSettingsMalayalamVoiceOff =>
      'Malayalam text is read with the English voice.';

  @override
  String get descSettingsMalayalamVoiceNeedsInstall =>
      'The Malayalam voice is not downloaded yet.';

  @override
  String get errorSettingsMalayalamVoiceUnavailable =>
      'This device\'s speech engine does not offer Malayalam.';

  @override
  String get labelSettingsMalayalamVoiceChecking => 'Checking…';

  @override
  String get titleTtsInstall => 'Get Malayalam voice';

  @override
  String get bodyTtsInstall =>
      'This phone does not have the Malayalam voice yet. Try one of these:';

  @override
  String get labelTtsInstallVoiceData => 'Download voice data';

  @override
  String get labelTtsOpenTtsSettings => 'Open speech settings';

  @override
  String get descTtsOpenPlayStore => 'Get Google speech services';

  @override
  String get descTtsInstallDoneNote =>
      'Come back here after installing — the setting turns on by itself once the voice is ready.';

  @override
  String get descTtsInstallCannotOpen =>
      'This phone could not open that screen.';

  @override
  String get descTtsVoiceLostNotice =>
      'The Malayalam voice is no longer installed, so the setting was turned off.';

  @override
  String get labelExtractAndConvert => 'Extract & Convert';

  @override
  String get actionExtractText => 'Extract text';

  @override
  String get actionExtractImages => 'Extract images';

  @override
  String get actionConvertPdf => 'Convert to images';

  @override
  String get actionFormFields => 'Form fields';

  @override
  String get descExtractionSuccess => 'Extraction successful';

  @override
  String get errorExtractionFailed => 'Extraction failed';

  @override
  String get labelExtractingProgress => 'Extracting content…';

  @override
  String get labelRangeAll => 'All pages';

  @override
  String descRangeCurrent(int page) {
    return 'Current page (Page $page)';
  }

  @override
  String get labelRangeCustom => 'Custom range';

  @override
  String get labelStartPage => 'Start page';

  @override
  String get labelEndPage => 'End page';

  @override
  String get labelInvalidPageRange => 'Invalid page range';

  @override
  String get labelImageFormat => 'Image format';

  @override
  String descResolution(int dpi) {
    return 'Resolution: $dpi DPI';
  }

  @override
  String get labelFieldsNameHeader => 'Field Name';

  @override
  String get labelFieldsValueHeader => 'Value';

  @override
  String get emptyFormFieldsFound =>
      'No interactive form fields found in this PDF.';

  @override
  String get emptyImagesFound => 'No images were found in the selected range.';

  @override
  String get actionShare => 'Share';

  @override
  String get actionShareFile => 'Share as file';

  @override
  String get actionCopyClipboard => 'Copy to clipboard';

  @override
  String get labelCopySuccess => 'Copied to clipboard';

  @override
  String get titlePreviewText => 'Extracted text';

  @override
  String get titleFormFields => 'Form fields';

  @override
  String get titlePageTools => 'Page tools';

  @override
  String get actionMerge => 'Merge PDFs';

  @override
  String get descMerge => 'Join this PDF with others into one new file';

  @override
  String get titleMergeDone => 'PDFs merged';

  @override
  String get actionSplit => 'Split into pages';

  @override
  String get descSplit => 'Make one new file for each page';

  @override
  String get titleSplitDone => 'PDF split';

  @override
  String get actionOrganize => 'Organize pages';

  @override
  String get descOrganize => 'Reorder, rotate, or delete pages';

  @override
  String get titleOrganize => 'Organize pages';

  @override
  String get helpOrganize =>
      'Drag to reorder. Use the buttons to rotate or delete a page. Save writes a new file.';

  @override
  String get titleOrganizeDone => 'Pages organized';

  @override
  String get actionCompress => 'Compress';

  @override
  String get descCompress => 'Make a smaller copy (best-effort)';

  @override
  String get titleCompressDone => 'PDF compressed';

  @override
  String get descCompressBestEffortNote =>
      'Compression is best-effort. Already-optimized files may not shrink much.';

  @override
  String get actionProtect => 'Add password';

  @override
  String get descProtect => 'Add a password to a new copy';

  @override
  String get titleProtect => 'Protect PDF';

  @override
  String get titleProtectDone => 'PDF protected';

  @override
  String get actionRemovePassword => 'Remove password';

  @override
  String get descUnlock => 'Make an unlocked copy (needs the current password)';

  @override
  String get titleUnlock => 'Remove password';

  @override
  String get titleUnlockDone => 'Password removed';

  @override
  String get labelUserPassword => 'Open password';

  @override
  String get labelOwnerPassword => 'Owner password';

  @override
  String get helpOwnerPassword =>
      'Controls printing and editing. Leave blank to match the open password.';

  @override
  String get labelCurrentPassword => 'Current password';

  @override
  String get errorPasswordRequired => 'Please enter a password.';

  @override
  String get labelWorkingProgress => 'Working…';

  @override
  String get errorOpFailed => 'Operation failed';

  @override
  String get actionSave => 'Save';

  @override
  String get errorSaveFailed => 'Could not save the file';

  @override
  String bodySavedFile(String name) {
    return 'Saved $name';
  }

  @override
  String labelResultOneFile(String name) {
    return 'New file: $name';
  }

  @override
  String descResultManyFiles(int count) {
    return '$count new files were created.';
  }

  @override
  String labelPage(int page) {
    return 'Page $page';
  }

  @override
  String labelRotatedBy(int degrees) {
    return 'Rotated $degrees°';
  }

  @override
  String bodyPageDeleted(int page) {
    return 'Page $page removed';
  }

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionRotate => 'Rotate';

  @override
  String get actionDeletePage => 'Delete page';

  @override
  String get errorNoPagesLeft => 'Keep at least one page.';

  @override
  String get actionAnnotate => 'Annotate';

  @override
  String get labelAnnotationHighlight => 'Highlight';

  @override
  String get labelAnnotationUnderline => 'Underline';

  @override
  String get labelAnnotationStrikethrough => 'Strikethrough';

  @override
  String get labelAnnotationInk => 'Draw';

  @override
  String get descAnnotationNote => 'Note';

  @override
  String get labelAnnotationEraser => 'Eraser';

  @override
  String get labelAnnotationClearAll => 'Clear all marks';

  @override
  String get descAnnotationExport => 'Export annotated copy';

  @override
  String get descAnnotationOverlayNotice =>
      'These marks are saved only inside this app. Export an annotated copy to keep them in the PDF.';

  @override
  String get errorAnnotationTextMarkupUnavailable =>
      'This PDF has no selectable text to mark.';

  @override
  String get descAnnotationExporting => 'Making an annotated copy…';

  @override
  String get errorAnnotationExportFailed =>
      'Could not export the annotated copy.';

  @override
  String get descAnnotationNothingToExport => 'Add a mark first.';

  @override
  String get titleAnnotationClearAll => 'Clear all marks?';

  @override
  String get bodyAnnotationClearAll =>
      'This removes every mark on this file. It cannot be undone.';

  @override
  String get titleNote => 'Note';

  @override
  String get labelNoteHint => 'Write your note';

  @override
  String get actionDelete => 'Delete';

  @override
  String get titleBookmarks => 'Bookmarks';

  @override
  String get actionBookmarks => 'Bookmarks';

  @override
  String get emptyBookmarks => 'No bookmarks yet.';

  @override
  String labelBookmarkAddCurrent(int page) {
    return 'Bookmark page $page';
  }

  @override
  String descBookmarkRemoveCurrent(int page) {
    return 'Remove bookmark on page $page';
  }

  @override
  String labelBookmarkPage(int page) {
    return 'Page $page';
  }

  @override
  String get errorShareFailed => 'Could not share this file.';

  @override
  String get titleImport => 'Save as PDF';

  @override
  String get labelImportBuilding => 'Making your PDF…';

  @override
  String get titleImportReady => 'Your PDF is ready';

  @override
  String descImportImagesSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Made from $count pictures',
      one: 'Made from 1 picture',
    );
    return '$_temp0';
  }

  @override
  String get descImportTextSummary => 'Made from the text you shared.';

  @override
  String labelImportSize(String size) {
    return 'Size: $size';
  }

  @override
  String get actionImportSave => 'Save as PDF';

  @override
  String get actionImportShare => 'Share';

  @override
  String labelImportSaved(String name) {
    return 'Saved $name';
  }

  @override
  String get titleImportFailed => 'PDF not created';

  @override
  String get titleImportUnsupportedText => 'Unsupported letters';

  @override
  String get descImportUnsupportedTextDetail =>
      'This app can only write English letters and numbers into a PDF. Malayalam and other scripts are not supported yet. A picture of the text will save fine.';

  @override
  String get actionPrint => 'Print';

  @override
  String get titlePrint => 'Print';

  @override
  String get actionPrintWhole => 'Whole document';

  @override
  String get descPrintWhole => 'Print every page of this PDF.';

  @override
  String get actionPrintRange => 'Page range';

  @override
  String get descPrintRange => 'Choose which pages to print.';

  @override
  String get actionPrintText => 'Text only';

  @override
  String get descPrintText => 'Print the words of this PDF as plain pages.';

  @override
  String get titlePrintRange => 'Pages to print';

  @override
  String get labelPrintFrom => 'From page';

  @override
  String get labelPrintTo => 'To page';

  @override
  String descPrintRangeInvalid(int pageCount) {
    return 'Enter a page range inside 1 to $pageCount.';
  }

  @override
  String get descPrintPreparing => 'Getting the pages ready…';

  @override
  String get errorPrintUnavailable => 'This device cannot print.';

  @override
  String get errorPrintFailed => 'Could not start printing.';

  @override
  String get descPrintNoText => 'This PDF has no text to print.';

  @override
  String get actionSignatures => 'Signatures';

  @override
  String get titleSignatures => 'Signatures';

  @override
  String get labelSignaturesChecking => 'Checking signatures…';

  @override
  String get descSignaturesNone => 'This PDF is not signed.';

  @override
  String get errorSignaturesFailed => 'These signatures could not be checked.';

  @override
  String get descSignaturesFailedDetail =>
      'This does not mean the signatures are bad. It means the app could not read them, so it will not say either way.';

  @override
  String get labelSignatureStatusTrusted => 'Signed and trusted';

  @override
  String get descSignatureStatusTrustedDetail =>
      'The document has not changed since it was signed, and you trust the signer\'s certificate.';

  @override
  String get descSignatureStatusValidNotTrusted => 'Signed, but signer unknown';

  @override
  String get descSignatureStatusValidNotTrustedDetail =>
      'The document has not changed since it was signed. But the app does not know the signer, so it cannot vouch for who they are.';

  @override
  String get descSignatureStatusInvalid => 'Signature is not valid';

  @override
  String get descSignatureStatusInvalidDetail =>
      'The document changed after it was signed, or the signature does not match. Do not rely on it.';

  @override
  String get descSignatureStatusUnknown => 'Signature could not be read';

  @override
  String get descSignatureStatusUnknownDetail =>
      'The app could not make sense of this signature, so it will not say whether it is good or bad.';

  @override
  String get descSignatureNotePartialCoverage => 'Covers only part of the file';

  @override
  String get descSignatureNotePartialCoverageDetail =>
      'Something was added to this file after it was signed. The signature says nothing about that part.';

  @override
  String get descSignatureNoteRevoked => 'The certificate was cancelled';

  @override
  String get descSignatureNoteRevokedDetail =>
      'Whoever issued this certificate has since cancelled it. It should not be trusted.';

  @override
  String get descSignatureNoteRevocationNotChecked =>
      'Could not check if the certificate was cancelled';

  @override
  String get descSignatureNoteRevocationNotCheckedDetail =>
      'Checking that needs the internet, which this app never uses, and this PDF does not carry the proof inside it.';

  @override
  String get descSignatureNoteCertExpired =>
      'The certificate had expired when it signed';

  @override
  String get descSignatureNoteCertExpiredDetail =>
      'The signing certificate was outside its valid dates at the time of signing.';

  @override
  String get descSignatureNoteUnverifiedTime =>
      'The signing time is only a claim';

  @override
  String get descSignatureNoteUnverifiedTimeDetail =>
      'This time is stored outside the signed part of the file, so anyone could have changed it.';

  @override
  String get labelSignatureSigner => 'Signed by';

  @override
  String get labelSignatureSignerUnknown => 'Not stated';

  @override
  String get labelSignatureSignedAt => 'Signed on';

  @override
  String get labelSignatureReason => 'Reason';

  @override
  String get labelSignatureLocation => 'Location';

  @override
  String get titleSignatureCertificate => 'Certificate';

  @override
  String get labelSignatureIssuedTo => 'Issued to';

  @override
  String get labelSignatureIssuedBy => 'Issued by';

  @override
  String get labelSignatureValidFrom => 'Valid from';

  @override
  String get labelSignatureValidUntil => 'Valid until';

  @override
  String get descSignatureSelfSignedNote =>
      'This certificate vouches for itself. Nobody else backs it, so trust it only if you know the signer.';

  @override
  String get actionSignatureTrust => 'Trust certificate';

  @override
  String get titleSignatureTrust => 'Trust this signer?';

  @override
  String get descSignatureTrustExplain =>
      'From now on, any PDF signed with this certificate will show as trusted. Only do this if you know who the signer is.';

  @override
  String get labelSignatureTrustConfirm => 'Trust';

  @override
  String get descSignatureTrustedToast => 'Certificate trusted.';

  @override
  String get titleTrustStore => 'Trusted certificates';

  @override
  String get emptyTrustStore => 'You have not trusted any certificates yet.';

  @override
  String get descTrustStoreEmptyDetail =>
      'When you trust a signer\'s certificate, it is listed here. You can remove it at any time.';

  @override
  String get actionTrustStoreAdd => 'Add a certificate';

  @override
  String get actionTrustStoreRemove => 'Remove';

  @override
  String get titleTrustStoreRemove => 'Stop trusting?';

  @override
  String get descTrustStoreRemoveExplain =>
      'PDFs signed with it will stop showing as trusted.';

  @override
  String get descTrustStoreInvalidFile =>
      'That file is not a certificate the app can read.';

  @override
  String get descTrustStoreExpiredWarning => 'This certificate has expired.';

  @override
  String get actionTrimMargins => 'Trim margins';

  @override
  String get titleTrimMargins => 'Smart Margin Trim';

  @override
  String get descTrimMargins => 'Crops blank page margins for mobile reading.';

  @override
  String get descTrimMarginsWorking => 'Trimming blank page margins…';

  @override
  String get titleTrimMarginsDone => 'Margins trimmed';

  @override
  String get descTrimMarginsDoneNote =>
      'Blank margins cropped to fit mobile screens.';

  @override
  String get labelTrimPadding => 'Margin padding';

  @override
  String get labelTrimPaddingTight => 'Tight (4 pt)';

  @override
  String get labelTrimPaddingStandard => 'Standard (12 pt)';

  @override
  String get labelTrimPaddingComfortable => 'Comfortable (24 pt)';

  @override
  String get labelTrimSymmetric => 'Symmetric margins';

  @override
  String get helpTrimSymmetric => 'Keeps left and right margins balanced.';

  @override
  String get actionBooklet => 'Create booklet';

  @override
  String get titleBooklet => 'Foldable booklet';

  @override
  String get descBooklet =>
      'Generates a 2-Up foldable booklet imposition layout for double-sided printing.';

  @override
  String get descBookletWorking => 'Generating booklet layout…';

  @override
  String get titleBookletDone => 'Booklet generated';

  @override
  String get descBookletDoneNote =>
      'Print double-sided (flip on short edge) and fold in half along the center spine.';

  @override
  String get titleBookletSummary => 'Booklet layout';

  @override
  String descBookletSummaryPages(int source, int padded) {
    return '$source original pages -> $padded booklet pages';
  }

  @override
  String descBookletSummarySheets(int sheets, int faces) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets physical landscape sheets',
      one: '1 physical landscape sheet',
    );
    return '$_temp0 ($faces printable sides)';
  }

  @override
  String descBookletSummaryBlanks(int blanks) {
    String _temp0 = intl.Intl.pluralLogic(
      blanks,
      locale: localeName,
      other: '$blanks blank filler pages added at end',
      one: '1 blank filler page added at end',
    );
    return '$_temp0';
  }

  @override
  String get labelBookletBinding => 'Binding direction';

  @override
  String get labelBookletBindingLtr => 'Left to Right (LTR)';

  @override
  String get labelBookletBindingRtl => 'Right to Left (RTL)';

  @override
  String get labelBookletPaperSize => 'Paper size';

  @override
  String get labelBookletPaperAuto => 'Match source';

  @override
  String get labelBookletPaperA4 => 'A4 Landscape';

  @override
  String get labelBookletPaperLetter => 'US Letter';

  @override
  String get labelBookletFoldGuide => 'Center fold guide';

  @override
  String get helpBookletFoldGuide =>
      'Draws a faint dotted guideline showing where to fold the booklet.';

  @override
  String get titleAppearance => 'Appearance';

  @override
  String get descAppearanceSubtitle => 'Theme mode, typography, and colors';

  @override
  String get titleThemeMode => 'Theme Mode';

  @override
  String get descThemeModeSubtitle =>
      'Choose between Light, Dark, System, or Sepia mode';

  @override
  String get descThemeModeCardSubtitle => 'Select Light, Dark, or System';

  @override
  String get descThemeMode =>
      'System mode automatically follows your device\'s system-wide dark mode setting. Sepia mode provides a warm, eye-comfort reading background.';

  @override
  String get titleTypography => 'Fonts & text size';

  @override
  String get descTypographySubtitle => 'App font family and text size';

  @override
  String get descTypography =>
      'Customize the app font family and reading text size for better readability across screens.';

  @override
  String get labelTypographyFont => 'Font';

  @override
  String get labelTypographyTextSize => 'Text Size';

  @override
  String get labelFontSystemDefault => 'System Default';

  @override
  String get labelFontManjari => 'Manjari';

  @override
  String get labelFontAnekMalayalam => 'Anek Malayalam';

  @override
  String get labelFontNotoSansMalayalam => 'Noto Sans Malayalam';

  @override
  String get labelTextSizeSmall => 'Small';

  @override
  String get labelTextSizeDefault => 'Default';

  @override
  String get labelTextSizeLarge => 'Large';

  @override
  String get labelTextSizeLarger => 'Larger';

  @override
  String get descTypographySampleLatin => 'The quick brown fox 0123';

  @override
  String get labelTypographySampleMalayalam => 'മലയാളം സുന്ദരമാണ്';

  @override
  String get titleAccentColor => 'Accent Color';

  @override
  String get descAccentColorSubtitle => 'Presets, color wheel, live preview';

  @override
  String get descAccentAppliesToLight =>
      'This color is used while the app is in light mode.';

  @override
  String get descAccentAppliesToDark =>
      'This color is used while the app is in dark mode.';

  @override
  String get labelLivePreview => 'LIVE PREVIEW';

  @override
  String get labelSampleText => 'Sample text';

  @override
  String get labelPresets => 'PRESETS';

  @override
  String get labelCustomColorWheel => 'CUSTOM COLOR WHEEL';

  @override
  String get labelResetToDefault => 'Reset to default';

  @override
  String get descResetLightToDefault => 'Reset Light to default';

  @override
  String get descResetDarkToDefault => 'Reset Dark to default';

  @override
  String get descContrastNotice =>
      'Text contrast is adjusted automatically for readability.';

  @override
  String get titlePermissions => 'Permissions';

  @override
  String get descPermissionsSubtitle =>
      'Storage, virtual print service and privacy capabilities';

  @override
  String get labelPermissionsOpenSettings => 'Open system settings';

  @override
  String get labelPermissionsExplicitHeader => 'Capabilities';

  @override
  String get descPermissionsExplicitSubtitle =>
      'Features and system roles designed for safe document access.';

  @override
  String get descPermissionsImplicitHeader => 'Privacy & System Declarations';

  @override
  String get descPermissionsImplicitSubtitle =>
      'Declared in the manifest; all processing stays on this phone.';

  @override
  String get titlePermScopedStorage => 'Scoped Storage (SAF)';

  @override
  String get descPermScopedStorageReason =>
      'Open and save documents securely via the Android system file picker without broad device storage permissions.';

  @override
  String get titlePermPrintService => 'Virtual printer';

  @override
  String get descPermPrintServiceReason =>
      'Allows other Android apps to print documents directly to Folio.';

  @override
  String get titlePermOffline => 'Private, no internet';

  @override
  String get descPermOfflineReason =>
      'No internet use. Your documents leave this phone only when you send them to your other phone with Device sync.';

  @override
  String get titlePermTts => 'Speech engine';

  @override
  String get descPermTtsReason =>
      'Queries installed speech engines for reading documents aloud in English and Malayalam.';

  @override
  String get titlePermProcessText => 'Process Text Action';

  @override
  String get descPermProcessTextReason =>
      'Enables quick searching and text actions when selecting text in other applications.';

  @override
  String get labelStatusActive => 'Active';

  @override
  String get labelStatusSystem => 'System';

  @override
  String get labelStatusOffline => 'Offline';

  @override
  String get descTrustStoreSubtitle =>
      'Manage digital signature root certificates';

  @override
  String get descAboutSubtitle => 'App version, licenses, and legal info';

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
      'On Android, virtual print services are managed at the system level. To enable Folio as a system-wide printer:';

  @override
  String get helpPdfPrinterStep1 => 'Open your Android device\'s Settings.';

  @override
  String get helpPdfPrinterStep2 =>
      'Go to Connected devices → Connection preferences → Printing (or search for \"Printing\" in your Settings search bar).';

  @override
  String get helpPdfPrinterStep3 =>
      'Under Print services, find Folio (or your app\'s name).';

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
      'Standard Android printing can sometimes garble complex scripts (such as Malayalam, Hindi, or Sanskrit), resulting in broken chillu characters, disconnected conjuncts, or missing fonts. Folio handles complex script shaping and font embedding to generate pristine PDFs.';

  @override
  String get helpUnicodePrintingStep1 =>
      'Enable the PDF Virtual Printer in Android Settings if you haven\'t already.';

  @override
  String get helpUnicodePrintingStep2 =>
      'In any app (such as Chrome, WhatsApp, or Office), select Print from the menu.';

  @override
  String get helpUnicodePrintingStep3 =>
      'Select \'Folio\' as the target printer instead of the standard Android \'Save as PDF\'.';

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
      'Folio verifies digital signatures completely offline using cryptographic algorithms (SHA-256 digests and X.509 certificate chains) with zero network requests.';

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
      'No internet servers, and Scoped Storage security';

  @override
  String get helpPrivacyStorageTopicHeader => 'No-Internet Privacy Guarantee';

  @override
  String get helpPrivacyStorageIntro =>
      'Your privacy is paramount. Folio never connects to the internet. Its only network use is Device sync, directly between your own phones on local WiFi.';

  @override
  String get helpPrivacyStorageStep1 =>
      'No internet: Folio never contacts an internet server and collects no analytics. The INTERNET permission is used only by Device sync on your local WiFi, and only while that screen is open.';

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
  String get titleLanguage => 'Language';

  @override
  String get descLanguageSubtitle => 'Choose app language';

  @override
  String get labelLanguageSystem => 'System Default';

  @override
  String get labelLanguageEnglish => 'English';

  @override
  String get labelLanguageMalayalam => 'മലയാളം (Malayalam)';

  @override
  String get labelLanguageSanskrit => 'संस्कृतम् (Sanskrit)';

  @override
  String get titleLanguageSelect => 'App Language';

  @override
  String get descLanguageSelectSubtitle =>
      'Changes apply immediately across the entire application.';

  @override
  String get titleReaderSettings => 'Reader & Viewer';

  @override
  String get descReaderSettingsSubtitle =>
      'Reading position, layout, zoom, and display';

  @override
  String get titleSaveLastPosition => 'Remember position';

  @override
  String get descSaveLastPositionSubtitle =>
      'Automatically resume from the last viewed page and zoom level';

  @override
  String get titleDefaultPageLayout => 'Default Page Layout';

  @override
  String get descDefaultPageLayoutSubtitle =>
      'Choose how pages are presented when opening documents';

  @override
  String get labelLayoutContinuous => 'Continuous Scroll';

  @override
  String get labelLayoutSinglePage => 'Single Page';

  @override
  String get titleDoubleTapZoom => 'Double-Tap Zoom';

  @override
  String get descDoubleTapZoomSubtitle =>
      'Action performed on double-tapping a PDF page';

  @override
  String get labelZoomFitWidth => 'Fit to Width';

  @override
  String get labelZoom200 => 'Zoom to 200%';

  @override
  String get titleShowPageIndicator => 'Page indicator';

  @override
  String get descShowPageIndicatorSubtitle =>
      'Display page indicator pill overlay while reading';

  @override
  String get titleInvertColors => 'Invert PDF Colors';

  @override
  String get descInvertColorsSubtitle =>
      'Inverts document colors for night-time reading';

  @override
  String get titleTtsSettings => 'Read Aloud (TTS)';

  @override
  String get descTtsSettingsSubtitle =>
      'Voice, speech speed, pitch, and playback options';

  @override
  String get titleTtsSpeechRate => 'Speech Rate';

  @override
  String descTtsSpeechRateSubtitle(String rate) {
    return '${rate}x speed';
  }

  @override
  String get titleTtsPitch => 'Voice Pitch';

  @override
  String descTtsPitchSubtitle(String pitch) {
    return '${pitch}x pitch';
  }

  @override
  String get titleTtsAutoScroll => 'Scroll with speech';

  @override
  String get descTtsAutoScrollSubtitle =>
      'Automatically scroll the document as sentences are spoken';

  @override
  String get titlePrinterSettings => 'PDF Virtual Printer';

  @override
  String get descPrinterSettingsSubtitle =>
      'Print service integration, paper size, and cache';

  @override
  String get titlePrinterEnable => 'Enable PDF printer';

  @override
  String get descPrinterEnableSubtitle =>
      'Accept print jobs from other apps and save them as PDF';

  @override
  String get titleDefaultPaperSize => 'Default Paper Size';

  @override
  String get descDefaultPaperSizeSubtitle =>
      'Default page dimensions for generated PDFs';

  @override
  String get titleDefaultColorMode => 'Default Color Mode';

  @override
  String get descDefaultColorModeSubtitle =>
      'Color output for printed documents';

  @override
  String get labelColorModeColor => 'Color';

  @override
  String get labelColorModeGrayscale => 'Grayscale';

  @override
  String get descColorModeMonochrome => 'Monochrome (Black & White)';

  @override
  String get titleDefaultOrientation => 'Default Orientation';

  @override
  String get descDefaultOrientationSubtitle =>
      'Page orientation for print jobs';

  @override
  String get labelOrientationAuto => 'Auto (Match Source)';

  @override
  String get labelOrientationPortrait => 'Portrait';

  @override
  String get labelOrientationLandscape => 'Landscape';

  @override
  String get titleClearPrinterCache => 'Clear Printer Cache';

  @override
  String descClearPrinterCacheSubtitle(String size) {
    return 'Purge temporary PDF spool files ($size)';
  }

  @override
  String get descPrinterCacheCleared => 'Printer cache cleared.';

  @override
  String get titleStorageSettings => 'Storage & Privacy';

  @override
  String get descStorageSettingsSubtitle =>
      'Recent files history and cache cleanup';

  @override
  String get titleRememberRecentFiles => 'Remember recents';

  @override
  String get descRememberRecentFilesSubtitle =>
      'Save opened documents to the recents list on Home';

  @override
  String get titleClearRecentFiles => 'Clear recent files';

  @override
  String get descClearRecentFilesSubtitle =>
      'Remove all opened document records and saved positions';

  @override
  String get titleClearRecentFilesConfirm => 'Clear recent files?';

  @override
  String get bodyClearRecentFilesConfirm =>
      'This will clear your recent files list and reading progress. The original PDF files on your device will NOT be deleted.';

  @override
  String get actionClearRecentFiles => 'Clear History';

  @override
  String get descRecentFilesCleared => 'Recent files history cleared.';

  @override
  String get titleClearTempCache => 'Clear App Cache';

  @override
  String descClearTempCacheSubtitle(String size) {
    return 'Free up temporary space without losing data ($size)';
  }

  @override
  String get descTempCacheCleared => 'Temporary cache cleared.';

  @override
  String get titleSecuritySettings => 'Signatures & Trust';

  @override
  String get descSecuritySettingsSubtitle =>
      'Digital signature verification and custom certificates';

  @override
  String get titleAutoVerifySignatures => 'Auto signature check';

  @override
  String get descAutoVerifySignaturesSubtitle =>
      'Automatically check digital signatures when opening signed PDFs';

  @override
  String get titlePermFileProvider => 'Secure File Provider';

  @override
  String get descPermFileProviderReason =>
      'Shares temporary PDFs and extracted files with external apps without exposing private file paths.';

  @override
  String get descPermFileProviderWhatItAchieves =>
      'Enables safe sharing and printing of PDFs to external apps without compromising storage security.';

  @override
  String get titlePermTtsInstall => 'Voice Data Installer';

  @override
  String get descPermTtsInstallReason =>
      'Opens system voice package download screens if required language voices are missing.';

  @override
  String get descPermTtsInstallWhatItAchieves =>
      'Enables guided installation of Malayalam and English speech voices without dead-ends.';

  @override
  String get titlePermSendShare => 'Receive shares';

  @override
  String get descPermSendShareReason =>
      'Receives images, plain text, and PDF files shared from other applications.';

  @override
  String get descPermSendShareWhatItAchieves =>
      'Enables direct conversion of shared images and text into PDFs and opening PDFs from any app.';

  @override
  String get titlePermZeroInternet => 'No internet servers';

  @override
  String get descPermZeroInternetReason =>
      'Folio never contacts an internet server. Its only network use is Device sync between your own phones on local WiFi.';

  @override
  String get descPermZeroInternetWhatItAchieves =>
      'Guarantees complete privacy with zero data leakage, tracking, or remote telemetry.';

  @override
  String get descPermScopedStorageWhatItAchieves =>
      'Allows reading and saving PDFs selected by the user while keeping the rest of the device private.';

  @override
  String get descPermPrintServiceWhatItAchieves =>
      'Allows other Android apps to send print jobs directly to Folio to save as PDF.';

  @override
  String get descPermOfflineWhatItAchieves =>
      'Ensures document contents and personal information never leave your device.';

  @override
  String get descPermTtsWhatItAchieves =>
      'Discovers installed speech engines to read documents aloud in English and Malayalam.';

  @override
  String get descPermProcessTextWhatItAchieves =>
      'Allows selected text in any app to be processed or searched directly in Folio.';

  @override
  String get labelPermWhyNeededHeader => 'Why it is needed';

  @override
  String get labelPermWhatItAchievesHeader => 'What this achieves';

  @override
  String get labelPermTypeExplicit => 'Explicit Capability';

  @override
  String get descPermTypeImplicit => 'Implicit / System Query';

  @override
  String get labelPermTypePrivacy => 'Privacy Guarantee';

  @override
  String get descPermissionsPrivacyHeader =>
      'Privacy & Zero-Permission Guarantees';

  @override
  String get descPermissionsPrivacySubtitle =>
      'Dangerous permissions intentionally omitted from the manifest.';

  @override
  String get titlePermBindPrintService => 'BIND_PRINT_SERVICE';

  @override
  String get descPermBindPrintServiceReason =>
      'Guards the Virtual Print Service so only the Android system print spooler can bind to it.';

  @override
  String get descPermBindPrintServiceWhatItAchieves =>
      'Ensures untrusted third-party apps cannot invoke the print service or intercept spooled documents.';

  @override
  String get titlePermStoreQueries => 'Store & web links';

  @override
  String get descPermStoreQueriesReason =>
      'Queries Google Play Store and browser activities via market:// and https:// intent schemes.';

  @override
  String get descPermStoreQueriesWhatItAchieves =>
      'Enables direct installation of speech engines (such as Speech Services by Google) if missing.';

  @override
  String get titlePermViewPdf => 'Default PDF viewer';

  @override
  String get descPermViewPdfReason =>
      'Registers the app as a handler for PDF MIME types and file extensions.';

  @override
  String get descPermViewPdfWhatItAchieves =>
      'Allows opening PDF files directly from file managers, email attachments, and downloads.';

  @override
  String get titlePermPrintManager => 'Android printing';

  @override
  String get descPermPrintManagerReason =>
      'Communicates with Android\'s system PrintManager and print spooler.';

  @override
  String get descPermPrintManagerWhatItAchieves =>
      'Sends formatted PDF pages to physical printers and system print preview dialogs.';

  @override
  String get titlePermNoBroadStorage => 'No broad storage';

  @override
  String get descPermNoBroadStorageReason =>
      'No READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, or MANAGE_EXTERNAL_STORAGE permissions are requested.';

  @override
  String get descPermNoBroadStorageWhatItAchieves =>
      'Ensures all other photos, documents, and private data on your device remain completely inaccessible.';

  @override
  String get titleReadingVelocity => 'Reading speed';

  @override
  String get descReadingVelocitySubtitle =>
      'Calculates remaining reading time based on your reading speed';

  @override
  String labelReadingSpeed(int wpm) {
    return '$wpm wpm';
  }

  @override
  String descReadingTimeLeftChapter(int minutes) {
    return '$minutes min left in chapter';
  }

  @override
  String labelReadingTimeLeftDoc(int minutes) {
    return '$minutes min left';
  }

  @override
  String get labelReadingTimeLessMinute => '< 1 min left';

  @override
  String get descReadingTimeEstimatesToggle => 'Reading Time Estimates';

  @override
  String get descReadingTimeEstimatesToggleSubtitle =>
      'Display remaining chapter and document reading time in the reader bar';

  @override
  String get descViewModeAuto => 'Auto (Dual-page on wide / foldables)';

  @override
  String get descViewModeAutoSubtitle =>
      'Single-page on phones; dual-page book view on foldables and tablets';

  @override
  String get titleMalayalamHelper => 'Malayalam keyboard';

  @override
  String get tooltipMalayalamHelper => 'Malayalam typing';

  @override
  String get labelMalayalamKeypadTabTranslit => 'Manglish';

  @override
  String get labelMalayalamKeypadTabVowels => 'Vowels';

  @override
  String get labelMalayalamKeypadTabConsonants => 'Consonants';

  @override
  String get labelMalayalamKeypadTabSigns => 'Signs & Chillu';

  @override
  String get titleTtsSentencePause => 'Sentence pause';

  @override
  String descTtsSentencePauseSubtitle(String seconds) {
    return '${seconds}s pause between sentences';
  }

  @override
  String descTtsReadingPage(int page) {
    return 'Reading page $page...';
  }

  @override
  String get labelTtsPaused => 'Paused';

  @override
  String descTtsReadyToRead(int page) {
    return 'Ready to read page $page';
  }

  @override
  String get actionWatermark => 'Custom watermark';

  @override
  String get descWatermark => 'Add text or image watermark onto pages';

  @override
  String get titleWatermarkDialog => 'Custom Watermark';

  @override
  String get labelWatermarkText => 'Watermark Text';

  @override
  String get errorWatermarkEmptyText => 'Please enter watermark text.';

  @override
  String get titleWatermarkDone => 'Watermark added';

  @override
  String get labelWatermarkOpacity => 'Opacity';

  @override
  String get labelWatermarkRotation => 'Rotation Angle';

  @override
  String get labelWatermarkFontSize => 'Font Size';

  @override
  String get labelWatermarkColor => 'Color';

  @override
  String get labelWatermarkTiled => 'Tile across page';

  @override
  String get descWatermarkTiled =>
      'Repeats watermark pattern across entire page';

  @override
  String get labelWatermarkPageRange => 'Apply to';

  @override
  String get labelWatermarkAllPages => 'All pages';

  @override
  String get labelWatermarkOddPages => 'Odd pages only';

  @override
  String get labelWatermarkEvenPages => 'Even pages only';

  @override
  String get actionWatermarkApply => 'Apply Watermark';

  @override
  String get titleBatchOperations => 'Batch Operations';

  @override
  String get descBatchOperations => 'Process multiple PDF files at once';

  @override
  String get labelBatchOperation => 'Select Operation';

  @override
  String get descBatchOpEncrypt => 'Batch Encrypt / Protect';

  @override
  String get labelBatchOpMerge => 'Batch Merge';

  @override
  String get descBatchOpExtractText => 'Batch Extract Text (.txt)';

  @override
  String get labelBatchOpTrimMargins => 'Batch Trim Margins';

  @override
  String get labelBatchOpCompress => 'Batch Compress';

  @override
  String descBatchSelectedFilesCount(int count) {
    return 'Selected Files ($count)';
  }

  @override
  String get actionBatchAddFiles => 'Add Files';

  @override
  String get descBatchNoFilesSelected =>
      'No PDF files selected. Tap Add Files to select PDFs.';

  @override
  String descBatchProgress(int current, int total, String name) {
    return 'Processing $current of $total: $name';
  }

  @override
  String get actionBatchStart => 'Start batch';

  @override
  String descBatchDoneSummary(int success, int total) {
    return 'Successfully processed $success of $total documents.';
  }

  @override
  String get descBatchFailedAll => 'Batch processing failed for all documents.';

  @override
  String get actionNUp => 'Pages per sheet';

  @override
  String get descNUp => 'Fit 2, 4, 6, or 9 pages onto each sheet';

  @override
  String get titleNUpDialog => 'Pages per sheet';

  @override
  String get labelNUpGrid => 'Grid Layout';

  @override
  String get labelNUpSheetSize => 'Sheet Size';

  @override
  String get labelNUpSheetA4 => 'A4';

  @override
  String get labelNUpSheetLetter => 'US Letter';

  @override
  String get labelNUpOrientation => 'Sheet Orientation';

  @override
  String get labelNUpOrientationAuto => 'Auto';

  @override
  String get labelNUpOrientationPortrait => 'Portrait';

  @override
  String get labelNUpOrientationLandscape => 'Landscape';

  @override
  String get labelNUpBorders => 'Draw Page Borders';

  @override
  String get descNUpBorders =>
      'Draws subtle grid boundary line around each page slot';

  @override
  String get labelNUpMargin => 'Margin Padding';

  @override
  String get titleNUpDone => 'N-up PDF created';

  @override
  String get actionPrintNUp => 'Print N-up';

  @override
  String get descPrintNUp =>
      'Print multiple pages per sheet (2-in-1, 4-in-1, etc.)';

  @override
  String get titleCleanWebContent => 'Clean web pages';

  @override
  String get descCleanWebContentSubtitle =>
      'Removes headers, footers, sidebars, scripts, and ads before saving';

  @override
  String descPagesDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages deleted',
      one: '1 page deleted',
    );
    return '$_temp0';
  }

  @override
  String descOrganizeSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get actionSelectAll => 'Select all';

  @override
  String get actionDeselectAll => 'Deselect';

  @override
  String get actionInvertSelection => 'Invert';

  @override
  String get actionTrustStoreExport => 'Export Certificate';

  @override
  String get actionTrustStoreExportAll => 'Export all';

  @override
  String descTrustStoreExportSuccess(String name) {
    return 'Certificate exported to $name';
  }

  @override
  String get actionSignatureTrustSigner => 'Trust Signer';

  @override
  String get labelSignatureUnnamed => 'Digital Signature';

  @override
  String get labelSignatureTime => 'Signing Time';

  @override
  String get labelSignatureTimeClaimOnly => 'unverified claim';

  @override
  String get labelSignatureIntegrity => 'Document Integrity';

  @override
  String get descSignatureIntegrityValid => 'Document unmodified since signing';

  @override
  String get descSignatureIntegrityInvalid => 'Document modified after signing';

  @override
  String get descSignatureIntegrityUnknown => 'Integrity could not be verified';

  @override
  String get labelSignatureCoverage => 'Byte Coverage';

  @override
  String get descSignatureCoversWholeFile =>
      'Signature covers the entire document';

  @override
  String get descSignatureCoversPartialFile =>
      'Signature covers only part of the document';

  @override
  String get descSignatureCertificateHeader => 'Signer Certificate Details';

  @override
  String get titleFeatures => 'Features';

  @override
  String get descFeaturesSubtitle => 'Explore all features of Folio';

  @override
  String get titleFeaturesHeader => 'App features';

  @override
  String get descFeaturesHeaderSubtitle =>
      'Explore every intelligent tool, privacy safeguard, and PDF feature designed for you.';

  @override
  String get descFeaturesCategoryViewing => 'PDF Viewing & Navigation Engine';

  @override
  String get descFeaturesCategoryViewingSubtitle =>
      'High-performance rendering, continuous scrolling, book view, and smart navigation';

  @override
  String get descFeaturesCategorySearch => 'Search, Indic Phonetics & Speech';

  @override
  String get descFeaturesCategorySearchSubtitle =>
      'Sandhi-aware Indic search, Malayalam transliteration, and text-to-speech';

  @override
  String get descFeaturesCategoryAnnotations => 'Annotation Overlay & Markups';

  @override
  String get descFeaturesCategoryAnnotationsSubtitle =>
      'Non-destructive markups, ink drawing, notes, and PDF flattening';

  @override
  String get descFeaturesCategoryPageOps => 'Page Operations & Reorganization';

  @override
  String get descFeaturesCategoryPageOpsSubtitle =>
      'Visual page organizer, booklet imposition, watermarks, and batch tools';

  @override
  String get descFeaturesCategoryExtraction => 'Data Extraction & Utilities';

  @override
  String get descFeaturesCategoryExtractionSubtitle =>
      'Extract plain text, embedded images, form fields, and metadata';

  @override
  String get descFeaturesCategoryPrinter => 'Virtual Printer & Share Hub';

  @override
  String get descFeaturesCategoryPrinterSubtitle =>
      'System-wide virtual PDF printer, web cleaner, and image/text conversion';

  @override
  String get descFeaturesCategorySignatures =>
      'Digital Signatures & Trust Store';

  @override
  String get descFeaturesCategorySignaturesSubtitle =>
      'Native cryptographic verification, visual stamp badges, and custom trust store';

  @override
  String get descFeaturesCategoryThemes => 'Themes & Customization';

  @override
  String get descFeaturesCategoryThemesSubtitle =>
      'OLED dark mode, custom typography, HSV accent color picker, and settings hubs';

  @override
  String get labelFeaturesCategoryGuides => 'Built-In User Guides';

  @override
  String get descFeaturesCategoryGuidesSubtitle =>
      'Comprehensive offline tutorials and troubleshooting guides';

  @override
  String get helpHeaderTitle => 'Help Center & Knowledge Base';

  @override
  String get helpHeaderSubtitle =>
      'Browse in-depth guides and solutions for all features of Folio.';

  @override
  String get helpSectionPrinting => 'Printing & Conversion';

  @override
  String get helpSectionReading => 'Reading & Speech';

  @override
  String get helpSectionPageOps => 'Document Operations';

  @override
  String get helpSectionSecurity => 'Security & Privacy';

  @override
  String get labelAboutVersion => 'Version';

  @override
  String get labelAboutBuildDate => 'Build date';

  @override
  String get labelImageFormatPngLossless => 'PNG (Lossless)';

  @override
  String get labelImageFormatJpeg => 'JPEG';

  @override
  String labelNUpPagesPerSheet(int count) {
    return '$count-in-1';
  }

  @override
  String labelPageJumpRangeHint(int min, int max) {
    return '$min – $max';
  }

  @override
  String get aboutDetailAuthor => 'Author';

  @override
  String get aboutDetailEmail => 'Email';

  @override
  String get aboutDetailLicense => 'License';

  @override
  String get aboutDetailAiUsed => 'AI used';

  @override
  String get aboutDetailIdeUsed => 'IDE used';

  @override
  String madeWithLove(String heart) {
    return 'Made with $heart from India';
  }

  @override
  String get madeWithLoveA11y => 'Made with love from India';

  @override
  String get tooltipMenu => 'Menu';

  @override
  String get tooltipShowPassword => 'Show password';

  @override
  String get tooltipHidePassword => 'Hide password';

  @override
  String get labelColorYellow => 'Yellow';

  @override
  String get labelColorGreen => 'Green';

  @override
  String get labelColorBlue => 'Blue';

  @override
  String get labelColorRed => 'Red';

  @override
  String get labelColorPurple => 'Purple';

  @override
  String get labelColorOrange => 'Orange';

  @override
  String descAboutVersionBuild(String version, String build) {
    return '$version (build $build)';
  }

  @override
  String get actionClose => 'Close';

  @override
  String get actionRemove => 'Remove';

  @override
  String get tooltipRotateScreen => 'Rotate screen';

  @override
  String get titleScreenOrientation => 'Screen Orientation';

  @override
  String get errorScreenFallback =>
      'Something went wrong on this screen. Please go back and try again.';

  @override
  String get errorInvalidCertificate =>
      'This file is not a certificate the app can read.';

  @override
  String get errorCertificateExport => 'Could not export the certificate.';

  @override
  String get errorTrustStoreLoad => 'Could not load the trusted certificates.';

  @override
  String get errorImportBuild =>
      'Something went wrong while making the PDF. Please try again.';

  @override
  String get helpFeatureRenderingTitle => 'High-Performance Rendering';

  @override
  String get helpFeatureRenderingBody =>
      'Fast, crisp PDF page rendering powered by native pdfium engine with zero network overhead.';

  @override
  String get helpFeatureRenderingTag1 => 'pdfium Engine';

  @override
  String get helpFeatureRenderingTag2 => 'Crisp Scaling';

  @override
  String get helpFeatureRenderingTag3 => 'Offline Fast';

  @override
  String get helpFeatureViewModesTitle => 'Flexible Viewing & Fit Modes';

  @override
  String get helpFeatureViewModesBody =>
      'Switch between Single Page, Continuous Vertical Scrolling, and Two-Page Book view with Fit to Width or Fit to Page options.';

  @override
  String get helpFeatureViewModesTag1 => 'Single Page';

  @override
  String get helpFeatureViewModesTag2 => 'Continuous Scroll';

  @override
  String get helpFeatureViewModesTag3 => 'Book View';

  @override
  String get helpFeatureViewModesTag4 => 'Fit Modes';

  @override
  String get helpFeatureFoldableTitle => 'Foldable & Dual-Screen Support';

  @override
  String get helpFeatureFoldableBody =>
      'Adaptive dual-page layout on foldable devices and tablets with display hinge gap spacing.';

  @override
  String get helpFeatureFoldableTag1 => 'Foldable Aware';

  @override
  String get helpFeatureFoldableTag2 => 'Hinge Gap';

  @override
  String get helpFeatureFoldableTag3 => 'Tablet Optimized';

  @override
  String get helpFeatureVelocityTitle => 'Reading Velocity & Time Estimates';

  @override
  String get helpFeatureVelocityBody =>
      'Tracks reading speed in real time to calculate remaining reading time for chapters and the entire document.';

  @override
  String get helpFeatureVelocityTag1 => 'WPM Tracking';

  @override
  String get helpFeatureVelocityTag2 => 'Chapter Estimates';

  @override
  String get helpFeatureVelocityTag3 => 'Total Time';

  @override
  String get helpFeatureThumbnailsTitle => 'Thumbnail Grid & Direct Jump';

  @override
  String get helpFeatureThumbnailsBody =>
      'Quickly preview all document pages in an interactive grid or jump directly to any page number.';

  @override
  String get helpFeatureThumbnailsTag1 => 'Thumbnail Grid';

  @override
  String get helpFeatureThumbnailsTag2 => 'Page Slider';

  @override
  String get helpFeatureThumbnailsTag3 => 'Quick Jump';

  @override
  String get helpFeatureOutlineTitle => 'Document Outline & Bookmarks';

  @override
  String get helpFeatureOutlineBody =>
      'Browse document table of contents hierarchies with one-tap section jumping and page bookmarking.';

  @override
  String get helpFeatureOutlineTag1 => 'TOC Hierarchy';

  @override
  String get helpFeatureOutlineTag2 => '1-Tap Jump';

  @override
  String get helpFeatureOutlineTag3 => 'Page Bookmarks';

  @override
  String get helpFeatureFingerprintTitle => 'Content Fingerprinting & Recents';

  @override
  String get helpFeatureFingerprintBody =>
      'SHA-256 fingerprinting preserves reading positions, zoom, and annotations even if files are renamed or moved.';

  @override
  String get helpFeatureFingerprintTag1 => 'SHA-256 Fingerprint';

  @override
  String get helpFeatureFingerprintTag2 => 'Last Read State';

  @override
  String get helpFeatureFingerprintTag3 => 'Recent Files';

  @override
  String get helpFeatureSearchTitle => 'On-Page Full-Text Search';

  @override
  String get helpFeatureSearchBody =>
      'Instant keyword search with match counting, bright highlight overlays, and grapheme-aligned navigation.';

  @override
  String get helpFeatureSearchTag1 => 'Instant Search';

  @override
  String get helpFeatureSearchTag2 => 'Match Counter';

  @override
  String get helpFeatureSearchTag3 => 'Grapheme Alignment';

  @override
  String get helpFeatureSandhiTitle => 'Sandhi-Aware Indic Search';

  @override
  String get helpFeatureSandhiBody =>
      'Rule-based Sandhi compound splitting and joining supporting Malayalam, Sanskrit, and Devanagari rules.';

  @override
  String get helpFeatureSandhiTag1 => 'Sandhi Splitting';

  @override
  String get helpFeatureSandhiTag2 => 'Compound Joining';

  @override
  String get helpFeatureSandhiTag3 => 'Sanskrit & Malayalam';

  @override
  String get helpFeaturePhoneticTitle => 'Indic Phonetic Sound-Alike Engine';

  @override
  String get helpFeaturePhoneticBody =>
      'Unifies Anusvara nasal conjuncts, chillu and virama forms, NTA ligatures, and Samvruthokaram endings.';

  @override
  String get helpFeaturePhoneticTag1 => 'Sound-Alike Matching';

  @override
  String get helpFeaturePhoneticTag2 => 'Chillu Unification';

  @override
  String get helpFeaturePhoneticTag3 => 'NFC Normalization';

  @override
  String get helpFeatureMalayalamInputTitle =>
      'Malayalam Input Helper & Virtual Keypad';

  @override
  String get helpFeatureMalayalamInputBody =>
      'Live Manglish transliteration suggestions and a 3-tab virtual keypad for vowels, consonants, and signs.';

  @override
  String get helpFeatureMalayalamInputTag1 => 'Manglish Suggestions';

  @override
  String get helpFeatureMalayalamInputTag2 => 'Virtual Keypad';

  @override
  String get helpFeatureMalayalamInputTag3 => 'Zero Extra Setup';

  @override
  String get helpFeatureTtsTitle => 'Offline Text-to-Speech (TTS)';

  @override
  String get helpFeatureTtsBody =>
      'Read PDF text aloud in English and Malayalam with speech rate, pitch, sentence pause sliders, and media notifications.';

  @override
  String get helpFeatureTtsTag1 => 'English & Malayalam';

  @override
  String get helpFeatureTtsTag2 => 'Speed & Pitch Controls';

  @override
  String get helpFeatureTtsTag3 => 'Background Playback';

  @override
  String get helpFeatureMarkupsTitle => 'Text Markups & Color Presets';

  @override
  String get helpFeatureMarkupsBody =>
      'Highlight, underline, and strikethrough text with 7 vibrant color presets and customizable opacity.';

  @override
  String get helpFeatureMarkupsTag1 => 'Highlight';

  @override
  String get helpFeatureMarkupsTag2 => 'Underline';

  @override
  String get helpFeatureMarkupsTag3 => 'Strikethrough';

  @override
  String get helpFeatureMarkupsTag4 => '7 Colors';

  @override
  String get helpFeatureInkTitle => 'Freehand Ink Drawing & Sticky Notes';

  @override
  String get helpFeatureInkBody =>
      'Draw smooth sketches with the pen tool and anchor movable sticky notes anywhere on pages.';

  @override
  String get helpFeatureInkTag1 => 'Freehand Ink';

  @override
  String get helpFeatureInkTag2 => 'Anchored Notes';

  @override
  String get helpFeatureInkTag3 => 'Eraser Tool';

  @override
  String get helpFeatureFlattenTitle => 'Flatten & Export Annotations';

  @override
  String get helpFeatureFlattenBody =>
      'Export annotations permanently into standard PDF annotation objects in a new copy of your document.';

  @override
  String get helpFeatureFlattenTag1 => 'Copy-on-Write';

  @override
  String get helpFeatureFlattenTag2 => 'Standard PDF Annotations';

  @override
  String get helpFeatureFlattenTag3 => 'Non-Destructive';

  @override
  String get helpFeatureOrganizeTitle => 'Visual Organize Pages Grid';

  @override
  String get helpFeatureOrganizeBody =>
      'Drag-and-drop page reordering, 90-degree rotations, and page deletion with multi-selection support.';

  @override
  String get helpFeatureOrganizeTag1 => 'Drag & Drop';

  @override
  String get helpFeatureOrganizeTag2 => 'Rotate & Delete';

  @override
  String get helpFeatureOrganizeTag3 => 'Multi-Select Mode';

  @override
  String get helpFeatureWatermarkTitle => 'Custom Text Watermarks';

  @override
  String get helpFeatureWatermarkBody =>
      'Add customizable diagonal or horizontal text watermarks with opacity, color, and repeating grid tiling.';

  @override
  String get helpFeatureWatermarkTag1 => 'Custom Text';

  @override
  String get helpFeatureWatermarkTag2 => 'Opacity & Angle';

  @override
  String get helpFeatureWatermarkTag3 => 'Grid Tiling';

  @override
  String get helpFeatureNUpTitle => 'N-Up Multi-Page Imposition';

  @override
  String get helpFeatureNUpBody =>
      'Place 2, 4, 6, or 9 pages per sheet on A4 or Letter paper with customizable borders and margins.';

  @override
  String get helpFeatureNUpTag1 => '2/4/6/9 Up';

  @override
  String get helpFeatureNUpTag2 => 'Page Borders';

  @override
  String get helpFeatureNUpTag3 => 'Sheet Orientation';

  @override
  String get helpFeatureBookletTitle => 'Printable Booklet Creator';

  @override
  String get helpFeatureBookletBody =>
      'Imposes pages into foldable saddle-stitch booklet order with automatic 4-page padding.';

  @override
  String get helpFeatureBookletTag1 => 'Saddle-Stitch';

  @override
  String get helpFeatureBookletTag2 => 'Fold Guidelines';

  @override
  String get helpFeatureBookletTag3 => 'Auto-Padding';

  @override
  String get helpFeatureMergeSplitTitle => 'Merge, Split & Compress';

  @override
  String get helpFeatureMergeSplitBody =>
      'Combine multiple PDFs, split pages into individual files, and compress PDFs to reduce file size.';

  @override
  String get helpFeatureMergeSplitTag1 => 'Merge Multiple';

  @override
  String get helpFeatureMergeSplitTag2 => 'Page Splitter';

  @override
  String get helpFeatureMergeSplitTag3 => 'Smart Compression';

  @override
  String get helpFeatureEncryptionTitle => 'PDF Encryption & Decryption';

  @override
  String get helpFeatureEncryptionBody =>
      'Protect documents with AES-256 passwords or unlock encrypted files into unencrypted copies.';

  @override
  String get helpFeatureEncryptionTag1 => 'AES-256 Protection';

  @override
  String get helpFeatureEncryptionTag2 => 'Owner Passwords';

  @override
  String get helpFeatureEncryptionTag3 => 'Unlock Decryption';

  @override
  String get helpFeatureBatchTitle => 'Batch Operations Engine';

  @override
  String get helpFeatureBatchBody =>
      'Execute watermarking, compression, encryption, decryption, and extraction across multiple files at once.';

  @override
  String get helpFeatureBatchTag1 => 'Multi-File Batch';

  @override
  String get helpFeatureBatchTag2 => 'Step Progress';

  @override
  String get helpFeatureBatchTag3 => 'SAF Output';

  @override
  String get helpFeatureExtractionTitle => 'Text & Image Extraction';

  @override
  String get helpFeatureExtractionBody =>
      'Extract plain text and save embedded PNG/JPEG images from any page range without quality loss.';

  @override
  String get helpFeatureExtractionTag1 => 'Plain Text Export';

  @override
  String get helpFeatureExtractionTag2 => 'Embedded Images';

  @override
  String get helpFeatureExtractionTag3 => 'Page Ranges';

  @override
  String get helpFeatureFormFieldsTitle => 'Interactive Form Fields Inspector';

  @override
  String get helpFeatureFormFieldsBody =>
      'Detect and inspect interactive form field values, checkboxes, radio groups, and export as JSON.';

  @override
  String get helpFeatureFormFieldsTag1 => 'Form Parser';

  @override
  String get helpFeatureFormFieldsTag2 => 'JSON Export';

  @override
  String get helpFeatureFormFieldsTag3 => 'Field Inspector';

  @override
  String get helpFeatureRenderImagesTitle => 'Render Pages to High-DPI Images';

  @override
  String get helpFeatureRenderImagesBody =>
      'Export PDF pages as crisp PNG or JPEG images with customizable DPI resolution up to 300 DPI.';

  @override
  String get helpFeatureRenderImagesTag1 => 'High-DPI PNG/JPEG';

  @override
  String get helpFeatureRenderImagesTag2 => '100-300 DPI';

  @override
  String get helpFeatureRenderImagesTag3 => 'Batch Rendering';

  @override
  String get helpFeatureMetadataTitle => 'Document Metadata Inspector';

  @override
  String get helpFeatureMetadataBody =>
      'View detailed document metadata including title, author, producer, creation date, and encryption state.';

  @override
  String get helpFeatureMetadataTag1 => 'PDF Metadata';

  @override
  String get helpFeatureMetadataTag2 => 'Creation Dates';

  @override
  String get helpFeatureMetadataTag3 => 'Security State';

  @override
  String get helpFeatureVirtualPrinterTitle => 'Android System Virtual Printer';

  @override
  String get helpFeatureVirtualPrinterBody =>
      'Receives print jobs from any Android app to generate crisp PDFs with full Indic font shaping.';

  @override
  String get helpFeatureVirtualPrinterTag1 => 'System Spooler';

  @override
  String get helpFeatureVirtualPrinterTag2 => 'Font Embedding';

  @override
  String get helpFeatureVirtualPrinterTag3 => 'Indic Shaping';

  @override
  String get helpFeatureWebCleanerTitle => 'Web Content Cleaner (Reader Mode)';

  @override
  String get helpFeatureWebCleanerBody =>
      'Strips ads, tracking, banners, sidebars, and scripts from shared web pages before converting to PDF.';

  @override
  String get helpFeatureWebCleanerTag1 => 'Ad & Clutter Stripping';

  @override
  String get helpFeatureWebCleanerTag2 => 'Reader View';

  @override
  String get helpFeatureWebCleanerTag3 => 'Clean PDFs';

  @override
  String get helpFeatureImagesToPdfTitle => 'Images & Text to PDF Converter';

  @override
  String get helpFeatureImagesToPdfBody =>
      'Convert up to 100 gallery images or shared plain text into formatted multi-page PDF documents.';

  @override
  String get helpFeatureImagesToPdfTag1 => 'Up to 100 Images';

  @override
  String get helpFeatureImagesToPdfTag2 => 'Plain Text Importer';

  @override
  String get helpFeatureImagesToPdfTag3 => 'Custom Margins';

  @override
  String get helpFeatureSignatureCheckTitle =>
      'Cryptographic Signature Verification';

  @override
  String get helpFeatureSignatureCheckBody =>
      'Validates document integrity, byte coverage, and certificate validity offline using Bouncy Castle.';

  @override
  String get helpFeatureSignatureCheckTag1 => 'Byte Integrity';

  @override
  String get helpFeatureSignatureCheckTag2 => 'Byte Coverage Scope';

  @override
  String get helpFeatureSignatureCheckTag3 => 'Offline Validation';

  @override
  String get helpFeatureTrustStoreTitle => 'Custom Trust Store & EU Lists';

  @override
  String get helpFeatureTrustStoreBody =>
      'Bundled EU Trusted Lists root certificates with support for importing custom CA/root certificates.';

  @override
  String get helpFeatureTrustStoreTag1 => 'EU Trusted Lists';

  @override
  String get helpFeatureTrustStoreTag2 => 'Import X.509 PEM';

  @override
  String get helpFeatureTrustStoreTag3 => 'PEM Export';

  @override
  String get helpFeatureSignatureStampsTitle =>
      'Visual Signature Stamp Overlay';

  @override
  String get helpFeatureSignatureStampsBody =>
      'Interactive signature stamp badges on PDF pages with one-tap access to certificate chain details.';

  @override
  String get helpFeatureSignatureStampsTag1 => 'On-Page Badges';

  @override
  String get helpFeatureSignatureStampsTag2 => 'Certificate Chains';

  @override
  String get helpFeatureSignatureStampsTag3 => 'Signer Details';

  @override
  String get helpFeatureThemesTitle => 'Light, Dark & OLED Pitch-Black';

  @override
  String get helpFeatureThemesBody =>
      'Support for Light, Dark, Sepia, and OLED Pitch-Black (#000000) for maximum battery savings.';

  @override
  String get helpFeatureThemesTag1 => 'OLED Pitch-Black';

  @override
  String get helpFeatureThemesTag2 => 'Sepia Reading';

  @override
  String get helpFeatureThemesTag3 => 'System Adaptive';

  @override
  String get helpFeatureTypographyTitle => 'Custom Typography & Scale';

  @override
  String get helpFeatureTypographyBody =>
      'Switch between Manjari, Anek Malayalam, Noto Sans Malayalam, and System font with text scaling.';

  @override
  String get helpFeatureTypographyTag1 => 'Malayalam Fonts';

  @override
  String get helpFeatureTypographyTag2 => 'Font Scaling';

  @override
  String get helpFeatureTypographyTag3 => 'Dynamic Switch';

  @override
  String get helpFeatureAccentTitle => 'Interactive Accent Color Picker';

  @override
  String get helpFeatureAccentBody =>
      'Custom color presets and full HSV color wheel with real-time app theme preview.';

  @override
  String get helpFeatureAccentTag1 => 'HSV Color Wheel';

  @override
  String get helpFeatureAccentTag2 => '8 Presets';

  @override
  String get helpFeatureAccentTag3 => 'Live Preview';

  @override
  String get helpFeatureGuidesTitle => '6 Dedicated Step-by-Step Guides';

  @override
  String get helpFeatureGuidesBody =>
      'In-depth guides covering PDF printer setup, Unicode printing, TTS voice configuration, page operations, signatures, and privacy.';

  @override
  String get helpFeatureGuidesTag1 => '100% Offline Guides';

  @override
  String get helpFeatureGuidesTag2 => 'Troubleshooting';

  @override
  String get helpFeatureGuidesTag3 => 'Step-by-Step';

  @override
  String get labelColorGrey => 'Grey';

  @override
  String get labelAccentColorWheel => 'Color wheel';

  @override
  String get helpAccentColorWheelHint =>
      'Drag on the wheel to choose the accent color.';

  @override
  String get titleAppData => 'App data';

  @override
  String get actionDeleteAllData => 'Delete all data';

  @override
  String get descDeleteAllData =>
      'Removes recent files, reading positions, notes and marks, certificates you trusted, saved settings, printed files and cached files. Your own PDF files are not touched.';

  @override
  String get titleDeleteAllDataConfirm => 'Delete all data?';

  @override
  String get bodyDeleteAllDataConfirm =>
      'This cannot be undone. The app will start again from the home screen with default settings.';

  @override
  String get errorDeleteAllData =>
      'Some data could not be deleted. Please try again.';

  @override
  String get actionClear => 'Clear';

  @override
  String get labelLanguageAuto => 'Auto';

  @override
  String get labelPaperA4 => 'A4';

  @override
  String get labelPaperLetter => 'US Letter';

  @override
  String get labelPaperLegal => 'Legal';

  @override
  String get descPaperA4 => '210 × 297 mm';

  @override
  String get descPaperLetter => '8.5 × 11 in';

  @override
  String get descPaperLegal => '8.5 × 14 in';

  @override
  String get labelQualityStandard => 'Standard';

  @override
  String get labelQualityHigh => 'High Quality';

  @override
  String get emptyExtractedText => 'No text found.';

  @override
  String get labelWatermarkConfidential => 'CONFIDENTIAL';

  @override
  String get labelWatermarkDraft => 'DRAFT';

  @override
  String get labelWatermarkCopy => 'COPY';

  @override
  String get labelWatermarkSample => 'SAMPLE';

  @override
  String get labelWatermarkOriginal => 'ORIGINAL';

  @override
  String get titleDeviceSync => 'Device sync';

  @override
  String get descDeviceSyncSubtitle =>
      'Copy settings or send PDFs to another phone by QR code or WiFi';

  @override
  String get descDeviceSyncIntro =>
      'Copy your Folio settings to another phone, or send PDFs. The phone that has them shows a code. The other phone scans it.';

  @override
  String get descDeviceSyncWhatIsCopied =>
      'Only settings are copied. Recent files, reading places, notes, bookmarks and trusted certificates stay on this phone. The Malayalam voice choice and the PDF printer switch also stay, because they depend on each phone.';

  @override
  String get titleShareSettings => 'Share my settings';

  @override
  String get descShareSettingsSubtitle =>
      'Show a code for the other phone to scan';

  @override
  String get labelSyncModeQr => 'QR only';

  @override
  String get labelSyncModeWifi => 'WiFi';

  @override
  String get descSyncModeQrHelp =>
      'The settings are inside the code. No network is needed.';

  @override
  String get descSyncModeWifiHelp =>
      'The code joins the two phones over your local WiFi. Both phones must be on the same WiFi, or one phone can join the other\'s hotspot. Nothing goes to the internet.';

  @override
  String descWifiCodeExpires(String time) {
    return 'This code works for $time.';
  }

  @override
  String descWifiGuestConnected(String address) {
    return 'Connected to $address. Waiting for the other phone to confirm…';
  }

  @override
  String get descWifiShareAccepted => 'The other phone applied your settings.';

  @override
  String get descWifiShareDeclined =>
      'The other phone cancelled. Nothing was changed there.';

  @override
  String get errorNoLanAddress =>
      'This phone is not on a WiFi network. Connect both phones to the same WiFi, turn on a hotspot on one phone, or use QR only.';

  @override
  String get descWifiSessionEnded =>
      'The WiFi session ended because Folio went to the background. Start again when you are ready.';

  @override
  String get titleScanCode => 'Scan code';

  @override
  String get descScanCodeHelp =>
      'Point the camera at the code on the other phone.';

  @override
  String get errorCameraUnavailable =>
      'The camera could not start. Allow camera access for Folio in the system settings, then try again. A phone without a camera can still send settings and PDFs.';

  @override
  String get errorCodeNotFolio => 'This is not a Folio code.';

  @override
  String get errorCodeDamaged =>
      'This Folio code could not be read. Make a new code and try again.';

  @override
  String get errorCodeNewerVersion =>
      'This code was made by a newer Folio. Update Folio on this phone.';

  @override
  String get errorCodeUnsafeAddress =>
      'This code points outside your local network, so Folio will not use it.';

  @override
  String get descReceiveConnecting => 'Connecting to the other phone…';

  @override
  String descReviewSettingsChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count settings will change:',
      one: '1 setting will change:',
    );
    return '$_temp0';
  }

  @override
  String get descReviewSettingsSame =>
      'Your settings are already the same as the other phone\'s.';

  @override
  String get descReviewSettingsSkipped =>
      'Some values were skipped because this version of Folio cannot use them.';

  @override
  String get actionApplySettings => 'Apply';

  @override
  String get descSettingsApplied => 'Settings applied.';

  @override
  String get descSettingsNotApplied => 'Nothing was changed.';

  @override
  String get errorTransferUnreachable =>
      'Could not reach the other phone. Use the same WiFi on both phones, or turn on a hotspot on one phone and join it from the other. Some office and hotel WiFi networks block this.';

  @override
  String get errorTransferTimedOut =>
      'Nothing happened in time. Make a new code and try again.';

  @override
  String get errorTransferWrongCode =>
      'The code did not work. It may be old or already used. Make a new code and try again.';

  @override
  String get errorTransferBadData =>
      'The data from the other phone was damaged. Try again.';

  @override
  String get errorTransferUnsupportedVersion =>
      'The other phone runs a different version of Folio. Update Folio on both phones.';

  @override
  String get errorTransferConnectionLost =>
      'The connection was lost. Try again.';

  @override
  String get labelSyncAccentLight => 'Light accent color';

  @override
  String get labelSyncAccentDark => 'Dark accent color';

  @override
  String get titlePermCamera => 'Camera';

  @override
  String get descPermCameraReason =>
      'Used only on the Scan code screen, to read a Device sync QR code. Asked the first time you scan. No photos or videos are taken or saved.';

  @override
  String get descPermCameraWhatItAchieves =>
      'Lets you receive settings or PDFs from another phone by scanning its code.';

  @override
  String get titlePermLocalNetwork => 'Local WiFi only';

  @override
  String get descPermLocalNetworkReason =>
      'android.permission.INTERNET is needed for any network connection, even between two phones on the same WiFi. Folio uses it only for Device sync, only while that screen is open, and only with a private local address read from the QR code.';

  @override
  String get descPermLocalNetworkWhatItAchieves =>
      'The phones talk directly to each other, encrypted with a one-time key. Folio never contacts an internet server.';

  @override
  String get titleReceive => 'Receive';

  @override
  String get descReceiveSubtitle =>
      'Scan the code on the other phone to get settings or PDFs';

  @override
  String get descDeviceSyncSendPdfsHint =>
      'To send PDFs: on Home, long-press a recent file to select it (tap more to add them), or open a PDF and choose Send to nearby phone from the menu.';

  @override
  String get actionSendNearby => 'Send to nearby phone';

  @override
  String get titleSendFiles => 'Send PDFs';

  @override
  String descSendPreparing(int done, int total) {
    return 'Getting files ready… $done of $total';
  }

  @override
  String get descSendScanPrompt =>
      'On the other phone, open Folio › Settings › Device sync › Receive, and scan this code.';

  @override
  String descSendFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDFs ready to send',
      one: '1 PDF ready to send',
    );
    return '$_temp0';
  }

  @override
  String descSendSkipped(String names) {
    return 'These files could not be read and will not be sent: $names';
  }

  @override
  String get errorSendNothing =>
      'None of the chosen files could be read. They may have been moved or deleted. Open them again, then try once more.';

  @override
  String get errorSendNoNetwork =>
      'This phone is not on a WiFi network. Connect both phones to the same WiFi, or turn on a hotspot on one phone.';

  @override
  String descSendTransferring(String sent, String total) {
    return 'Sending… $sent of $total';
  }

  @override
  String descSendFinished(int received, int count) {
    return '$received of $count PDFs arrived safely on the other phone.';
  }

  @override
  String get descSendDeclined => 'The other phone cancelled. Nothing was sent.';

  @override
  String descReceiveFilesHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDFs from the other phone:',
      one: '1 PDF from the other phone:',
    );
    return '$_temp0';
  }

  @override
  String descReceiveFilesTotal(String size) {
    return 'Total size: $size';
  }

  @override
  String descSavingTo(String folder) {
    return 'Saving to: $folder';
  }

  @override
  String get descNoFolderYet =>
      'Choose a folder to save the PDFs in. Folio will remember it.';

  @override
  String get errorFolderLost =>
      'The folder you chose before can no longer be used. It may have been deleted, or access to it was removed. Choose a folder again.';

  @override
  String get actionChangeFolder => 'Change';

  @override
  String get actionChooseFolder => 'Choose folder';

  @override
  String get actionAcceptFiles => 'Accept';

  @override
  String descReceiveTransferring(String received, String total) {
    return 'Receiving… $received of $total';
  }

  @override
  String get descReceiveSaving => 'Saving to the folder…';

  @override
  String descReceiveFilesSaved(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDFs saved in $folder.',
      one: '1 PDF saved in $folder.',
      zero: 'No PDFs were saved.',
    );
    return '$_temp0';
  }

  @override
  String descReceiveFilesFailed(String names) {
    return 'Not saved (damaged on the way, not a PDF, or could not be written): $names';
  }

  @override
  String get errorTransferCannotSave =>
      'Could not save the files. The phone may be out of space, or the folder can no longer be written to.';

  @override
  String labelSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get tooltipCancelSelection => 'Cancel selection';

  @override
  String get descShowCodeScanPrompt =>
      'On the other phone, open Folio › Settings › Device sync › Receive, and scan this code.';
}
