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
  String get unlockAction => 'Remove password';

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
}
