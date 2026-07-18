// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'പി.ഡി.എഫ്. ആപ്പ്';

  @override
  String get homeTitle => 'പി.ഡി.എഫ്. ആപ്പ്';

  @override
  String get homeEmptyMessage =>
      'ഇതുവരെ പി.ഡി.എഫ്. ഒന്നും തുറന്നിട്ടില്ല. ഫയലുകൾ തുറക്കൽ അടുത്ത ഘട്ടത്തിൽ വരും.';

  @override
  String get settingsTitle => 'ക്രമീകരണങ്ങൾ';

  @override
  String get settingsThemeLabel => 'തീം';

  @override
  String get themeSystem => 'സിസ്റ്റം';

  @override
  String get themeLight => 'വെളിച്ചം';

  @override
  String get themeDark => 'ഇരുട്ട്';

  @override
  String get themeSepia => 'സെപിയ';

  @override
  String get aboutTitle => 'കുറിച്ച്';

  @override
  String get openSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get openAbout => 'കുറിച്ച്';

  @override
  String get openPdf => 'പി.ഡി.എഫ്. തുറക്കുക';

  @override
  String get recentFilesTitle => 'സമീപകാല ഫയലുകൾ';

  @override
  String get noRecentFiles =>
      'ഇതുവരെ സമീപകാല ഫയലുകൾ ഇല്ല. വായിക്കാൻ \"പി.ഡി.എഫ്. തുറക്കുക\" അമർത്തുക.';

  @override
  String get removeFromRecents => 'നീക്കം ചെയ്യുക';

  @override
  String get openFailed => 'ഫയൽ തുറക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get reopenFailed =>
      'ഈ ഫയൽ വീണ്ടും തുറക്കാൻ കഴിഞ്ഞില്ല. അത് മാറ്റുകയോ ഇല്ലാതാക്കുകയോ ചെയ്തിരിക്കാം.';

  @override
  String pagesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count പേജുകൾ',
      one: '1 പേജ്',
    );
    return '$_temp0';
  }

  @override
  String get viewModeContinuous => 'തുടർച്ചയായി';

  @override
  String get viewModeSingle => 'ഒറ്റ പേജ്';

  @override
  String get viewModeBook => 'രണ്ട് പേജുകൾ';

  @override
  String get viewModeTooltip => 'കാഴ്ച രീതി';

  @override
  String get fitWidth => 'വീതിക്ക് ഒപ്പിക്കുക';

  @override
  String get fitPage => 'പേജിന് ഒപ്പിക്കുക';

  @override
  String get zoomIn => 'വലുതാക്കുക';

  @override
  String get zoomOut => 'ചെറുതാക്കുക';

  @override
  String get resetZoom => 'സൂം പുനഃക്രമീകരിക്കുക';

  @override
  String get invertColors => 'രാത്രി നിറങ്ങൾ';

  @override
  String get contentsTitle => 'ഉള്ളടക്കം';

  @override
  String get noOutline => 'ഈ പി.ഡി.എഫിന് ഉള്ളടക്കപ്പട്ടിക ഇല്ല.';

  @override
  String get thumbnailsTitle => 'പേജുകൾ';

  @override
  String get goToPage => 'പേജിലേക്ക് പോകുക';

  @override
  String pageOfPages(int current, int total) {
    return 'പേജ് $current / $total';
  }

  @override
  String get pageNumberHint => 'പേജ് നമ്പർ';

  @override
  String get goAction => 'പോകുക';

  @override
  String get cancelAction => 'റദ്ദാക്കുക';

  @override
  String get passwordTitle => 'പാസ്‌വേഡ് ആവശ്യമാണ്';

  @override
  String get passwordMessage =>
      'ഈ പി.ഡി.എഫ്. സംരക്ഷിതമാണ്. വായിക്കാൻ പാസ്‌വേഡ് നൽകുക.';

  @override
  String get passwordHint => 'പാസ്‌വേഡ്';

  @override
  String get unlockAction => 'പാസ്‌വേഡ് നീക്കുക';

  @override
  String get tryAgainAction => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get errorCorruptTitle => 'ഈ പി.ഡി.എഫ്. തുറക്കാൻ കഴിയുന്നില്ല';

  @override
  String get errorCorruptBody =>
      'ഫയൽ കേടായതായി തോന്നുന്നു അല്ലെങ്കിൽ അത് സാധുവായ പി.ഡി.എഫ്. അല്ല.';

  @override
  String get errorEmptyTitle => 'കാണിക്കാൻ ഒന്നുമില്ല';

  @override
  String get errorEmptyBody => 'ഈ പി.ഡി.എഫ്. ശൂന്യമാണ് — അതിൽ പേജുകളില്ല.';

  @override
  String get errorPasswordTitle => 'പൂട്ടിയ പി.ഡി.എഫ്.';

  @override
  String get errorPasswordBody =>
      'ഈ പി.ഡി.എഫ്. പാസ്‌വേഡ് ഉപയോഗിച്ച് സംരക്ഷിച്ചിരിക്കുന്നു. വായിക്കാൻ പാസ്‌വേഡ് നൽകുക.';

  @override
  String get errorGenericTitle => 'എന്തോ കുഴപ്പം സംഭവിച്ചു';

  @override
  String get errorGenericBody => 'ഈ പി.ഡി.എഫ്. തുറക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get largeFileWarning =>
      'ഇത് വലിയ പി.ഡി.എഫ്. ആണ്, അതിനാൽ സുഗമമായ വായനയ്ക്കായി ഒരു പേജ് വീതം തുറക്കുന്നു.';

  @override
  String get loadingPdf => 'തുറക്കുന്നു…';

  @override
  String get yes => 'അതെ';

  @override
  String get metadataTitle => 'വിവരങ്ങൾ';

  @override
  String get metadataAction => 'വിവരങ്ങൾ';

  @override
  String get metadataFileSection => 'ഫയൽ';

  @override
  String get metadataFileName => 'പേര്';

  @override
  String get metadataFileSize => 'വലുപ്പം';

  @override
  String get metadataPdfSection => 'പി.ഡി.എഫ്. വിവരങ്ങൾ';

  @override
  String get metadataUnavailable => 'ഈ വിവരങ്ങൾ വായിക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get metadataNoFields => 'ഈ പി.ഡി.എഫ്. സ്വയം വിവരണം നൽകുന്നില്ല.';

  @override
  String get metadataTitleField => 'തലക്കെട്ട്';

  @override
  String get metadataAuthor => 'രചയിതാവ്';

  @override
  String get metadataSubject => 'വിഷയം';

  @override
  String get metadataKeywords => 'മുഖ്യവാക്കുകൾ';

  @override
  String get metadataCreator => 'ഉണ്ടാക്കിയത്';

  @override
  String get metadataProducer => 'സേവ് ചെയ്തത്';

  @override
  String get metadataCreated => 'ഉണ്ടാക്കിയ തീയതി';

  @override
  String get metadataModified => 'മാറ്റിയ തീയതി';

  @override
  String get metadataPages => 'പേജുകൾ';

  @override
  String get metadataPdfVersion => 'പി.ഡി.എഫ്. പതിപ്പ്';

  @override
  String get metadataProtected => 'പാസ്‌വേഡ് സംരക്ഷിതം';

  @override
  String get searchAction => 'തിരയുക';

  @override
  String get searchHint => 'ഈ പി.ഡി.എഫ്. ഇൽ തിരയുക';

  @override
  String get searchClose => 'തിരയൽ അടയ്ക്കുക';

  @override
  String get searchClear => 'മായ്ക്കുക';

  @override
  String get searchNextMatch => 'അടുത്ത ഫലം';

  @override
  String get searchPreviousMatch => 'മുൻ ഫലം';

  @override
  String get searchSearching => 'തിരയുന്നു…';

  @override
  String get searchNoMatches => 'ഫലങ്ങൾ ഒന്നുമില്ല';

  @override
  String searchMatchOf(int current, int total) {
    return '$total ൽ $current';
  }

  @override
  String searchLimitReached(int count) {
    return 'ആദ്യത്തെ $count ഫലങ്ങൾ കാണിക്കുന്നു. നീളമുള്ള വാക്ക് പരീക്ഷിക്കുക.';
  }

  @override
  String get searchOptionsTooltip => 'തിരയൽ ക്രമീകരണങ്ങൾ';

  @override
  String get searchOptionStrict => 'കൃത്യമായ അക്ഷരവിന്യാസം';

  @override
  String get searchOptionStrictNote =>
      'കൂട്ടിച്ചേർത്തതും അല്ലാത്തതുമായ രൂപങ്ങൾ വേർതിരിക്കുക';

  @override
  String get searchOptionIgnoreAccents => 'സ്വരചിഹ്നങ്ങൾ അവഗണിക്കുക';

  @override
  String get searchOptionIgnoreAccentsNote =>
      'സംസ്കൃത സ്വരചിഹ്നങ്ങൾക്ക് ഉപകാരപ്രദം';

  @override
  String get noTextTitle => 'തിരഞ്ഞെടുക്കാവുന്ന എഴുത്ത് ഇല്ല';

  @override
  String get noTextBody =>
      'ഈ പി.ഡി.എഫ്. ഇൽ എഴുത്ത് പാളി ഇല്ല, അതിനാൽ ഇത് സ്കാൻ ചെയ്തതാണെന്ന് തോന്നുന്നു. തിരയൽ, പകർത്തൽ, ഉറക്കെ വായിക്കൽ എന്നിവ ലഭ്യമല്ല. ഈ ആപ്പ് ചിത്രങ്ങളിൽ നിന്ന് എഴുത്ത് വായിക്കില്ല.';

  @override
  String get garbledTextTitle => 'എഴുത്ത് ശരിയായി വായിക്കാൻ കഴിയുന്നില്ല';

  @override
  String get garbledTextBody =>
      'ഈ പി.ഡി.എഫ്. ഇലെ ഫോണ്ടുകൾ ഏത് അക്ഷരമാണ് കാണിക്കുന്നതെന്ന് പറയുന്നില്ല, അതിനാൽ തിരയലും ഉറക്കെ വായിക്കലും തെറ്റായ ഫലം നൽകും. പേജുകൾ വായിക്കുന്നത് പ്രവർത്തിക്കും.';

  @override
  String get searchUnavailableNoText =>
      'തിരയലിന് തിരഞ്ഞെടുക്കാവുന്ന എഴുത്ത് വേണം, ഈ പി.ഡി.എഫ്. ഇൽ അതില്ല.';

  @override
  String get searchUnavailableGarbled =>
      'ഈ പി.ഡി.എഫ്. ഇലെ എഴുത്ത് ശരിയായി വായിക്കാൻ കഴിയാത്തതിനാൽ തിരയൽ ഓഫാണ്.';

  @override
  String get dismissAction => 'ശരി';

  @override
  String get ttsReadAloud => 'ഉറക്കെ വായിക്കുക';

  @override
  String get ttsPause => 'താൽക്കാലികമായി നിർത്തുക';

  @override
  String get ttsStop => 'നിർത്തുക';

  @override
  String get ttsUnavailableNoText =>
      'ഉറക്കെ വായിക്കാൻ തിരഞ്ഞെടുക്കാവുന്ന എഴുത്ത് വേണം, ഈ പി.ഡി.എഫ്. ഇൽ അതില്ല.';

  @override
  String get ttsUnavailableGarbled =>
      'ഈ പി.ഡി.എഫ്. ഇലെ എഴുത്ത് ശരിയായി വായിക്കാൻ കഴിയാത്തതിനാൽ ഉറക്കെ വായിക്കൽ ഓഫാണ്.';

  @override
  String get ttsUnavailableNoVoice =>
      'ഈ ഉപകരണത്തിൽ സംസാര ശബ്ദം ഒന്നും ഇൻസ്റ്റാൾ ചെയ്തിട്ടില്ല.';

  @override
  String get ttsNothingToRead => 'ഈ പേജിൽ വായിക്കാൻ ഒന്നുമില്ല.';

  @override
  String get settingsReadAloudLabel => 'ഉറക്കെ വായിക്കൽ';

  @override
  String get settingsMalayalamVoice => 'മലയാളം ശബ്ദം';

  @override
  String get settingsMalayalamVoiceReady =>
      'തയ്യാർ. മലയാളം എഴുത്ത് മലയാളത്തിൽ വായിക്കും.';

  @override
  String get settingsMalayalamVoiceOff =>
      'മലയാളം എഴുത്ത് ഇംഗ്ലീഷ് ശബ്ദത്തിൽ വായിക്കും.';

  @override
  String get settingsMalayalamVoiceNeedsInstall =>
      'മലയാളം ശബ്ദം ഇതുവരെ ഡൗൺലോഡ് ചെയ്തിട്ടില്ല.';

  @override
  String get settingsMalayalamVoiceUnavailable =>
      'ഈ ഉപകരണത്തിലെ സംസാര എൻജിൻ മലയാളം നൽകുന്നില്ല.';

  @override
  String get settingsMalayalamVoiceChecking => 'പരിശോധിക്കുന്നു…';

  @override
  String get ttsInstallTitle => 'മലയാളം ശബ്ദം നേടുക';

  @override
  String get ttsInstallBody =>
      'ഈ ഫോണിൽ മലയാളം ശബ്ദം ഇതുവരെ ഇല്ല. ഇവയിൽ ഒന്ന് പരീക്ഷിക്കുക:';

  @override
  String get ttsInstallVoiceData => 'ശബ്ദ ഡാറ്റ ഡൗൺലോഡ് ചെയ്യുക';

  @override
  String get ttsOpenTtsSettings => 'സംസാര ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get ttsOpenPlayStore => 'ഗൂഗിൾ സ്പീച്ച് സേവനങ്ങൾ നേടുക';

  @override
  String get ttsInstallDoneNote =>
      'ഇൻസ്റ്റാൾ ചെയ്ത ശേഷം ഇവിടെ മടങ്ങിവരുക — ശബ്ദം തയ്യാറാകുമ്പോൾ ക്രമീകരണം സ്വയം ഓണാകും.';

  @override
  String get ttsInstallCannotOpen => 'ആ സ്ക്രീൻ തുറക്കാൻ ഈ ഫോണിന് കഴിഞ്ഞില്ല.';

  @override
  String get ttsVoiceLostNotice =>
      'മലയാളം ശബ്ദം ഇനി ഇൻസ്റ്റാൾ ചെയ്തിട്ടില്ല, അതിനാൽ ക്രമീകരണം ഓഫാക്കി.';

  @override
  String get extractAndConvert => 'എക്‌സ്‌ട്രാക്റ്റും കൺവേർട്ടും';

  @override
  String get extractTextAction => 'എഴുത്ത് വേർതിരിക്കുക';

  @override
  String get extractImagesAction => 'ചിത്രങ്ങൾ വേർതിരിക്കുക';

  @override
  String get convertPdfAction => 'ചിത്രങ്ങളാക്കി മാറ്റുക';

  @override
  String get formFieldsAction => 'ഫോം ഫീൽഡുകൾ';

  @override
  String get extractionSuccess => 'വേർതിരിക്കൽ വിജയിച്ചു';

  @override
  String get extractionFailed => 'വേർതിരിക്കൽ പരാജയപ്പെട്ടു';

  @override
  String get extractingProgress => 'വേർതിരിക്കുന്നു…';

  @override
  String get rangeAll => 'എല്ലാ പേജുകളും';

  @override
  String rangeCurrent(int page) {
    return 'ഈ പേജ് മാത്രം (പേജ് $page)';
  }

  @override
  String get rangeCustom => 'നിശ്ചിത പേജുകൾ';

  @override
  String get startPageLabel => 'ആരംഭ പേജ്';

  @override
  String get endPageLabel => 'അവസാന പേജ്';

  @override
  String get invalidPageRange => 'തെറ്റായ പേജ് പരിധി';

  @override
  String get imageFormatLabel => 'ചിത്രത്തിന്റെ ഫോർമാറ്റ്';

  @override
  String resolutionLabel(int dpi) {
    return 'റെസലൂഷൻ: $dpi DPI';
  }

  @override
  String get fieldsNameHeader => 'ഫീൽഡിന്റെ പേര്';

  @override
  String get fieldsValueHeader => 'മൂല്യം';

  @override
  String get noFormFieldsFound =>
      'ഈ പി.ഡി.എഫ്.-ൽ ഫോം ഫീൽഡുകൾ ഒന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get noImagesFound => 'ഈ പേജുകളിൽ ചിത്രങ്ങൾ ഒന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get shareAction => 'പങ്കുവെക്കുക';

  @override
  String get shareFileAction => 'ഫയലായി പങ്കുവെക്കുക';

  @override
  String get copyClipboardAction => 'പകർപ്പെടുക്കുക';

  @override
  String get copySuccess => 'പകർപ്പ് എടുത്തു കഴിഞ്ഞു';

  @override
  String get previewTextTitle => 'എഴുത്തിന്റെ പ്രിവ്യൂ';

  @override
  String get formFieldsTitle => 'ഫോം ഫീൽഡുകൾ കാണുക';

  @override
  String get pageToolsTitle => 'പേജ് ഉപകരണങ്ങൾ';

  @override
  String get mergeAction => 'PDF-കൾ ഒന്നാക്കുക';

  @override
  String get mergeDescription =>
      'ഈ PDF മറ്റുള്ളവയുമായി ചേർത്ത് ഒരു പുതിയ ഫയൽ ഉണ്ടാക്കുക';

  @override
  String get mergeDoneTitle => 'PDF-കൾ ചേർത്തു';

  @override
  String get splitAction => 'പേജുകളായി വേർതിരിക്കുക';

  @override
  String get splitDescription => 'ഓരോ പേജിനും ഒരു പുതിയ ഫയൽ ഉണ്ടാക്കുക';

  @override
  String get splitDoneTitle => 'PDF വേർതിരിച്ചു';

  @override
  String get organizeAction => 'പേജുകൾ ക്രമീകരിക്കുക';

  @override
  String get organizeDescription =>
      'പേജുകൾ വീണ്ടും ക്രമീകരിക്കുക, തിരിക്കുക അല്ലെങ്കിൽ നീക്കം ചെയ്യുക';

  @override
  String get organizeTitle => 'പേജുകൾ ക്രമീകരിക്കുക';

  @override
  String get organizeHint =>
      'വീണ്ടും ക്രമീകരിക്കാൻ വലിച്ചിടുക. തിരിക്കാനോ നീക്കാനോ ബട്ടണുകൾ ഉപയോഗിക്കുക. സേവ് ചെയ്യുമ്പോൾ പുതിയ ഫയൽ ഉണ്ടാകും.';

  @override
  String get organizeDoneTitle => 'പേജുകൾ ക്രമീകരിച്ചു';

  @override
  String get compressAction => 'ചെറുതാക്കുക';

  @override
  String get compressDescription =>
      'ചെറിയ ഒരു പകർപ്പ് ഉണ്ടാക്കുക (കഴിയുന്നത്ര)';

  @override
  String get compressDoneTitle => 'PDF ചെറുതാക്കി';

  @override
  String get compressBestEffortNote =>
      'ചെറുതാക്കൽ കഴിയുന്നത്ര മാത്രമാണ്. നേരത്തെ ഒപ്റ്റിമൈസ് ചെയ്ത ഫയലുകൾ അധികം ചെറുതാകില്ല.';

  @override
  String get protectAction => 'പാസ്‌വേഡ് ഇടുക';

  @override
  String get protectDescription => 'പുതിയ പകർപ്പിന് ഒരു പാസ്‌വേഡ് ചേർക്കുക';

  @override
  String get protectTitle => 'PDF-ന് പാസ്‌വേഡ് ഇടുക';

  @override
  String get protectDoneTitle => 'PDF-ന് പാസ്‌വേഡ് ഇട്ടു';

  @override
  String get unlockDescription =>
      'പാസ്‌വേഡ് ഇല്ലാത്ത പകർപ്പ് ഉണ്ടാക്കുക (ഇപ്പോഴത്തെ പാസ്‌വേഡ് വേണം)';

  @override
  String get unlockTitle => 'പാസ്‌വേഡ് നീക്കുക';

  @override
  String get unlockDoneTitle => 'പാസ്‌വേഡ് നീക്കി';

  @override
  String get userPasswordLabel => 'പാസ്‌വേഡ് (ഫയൽ തുറക്കാൻ)';

  @override
  String get ownerPasswordLabel => 'ഉടമ പാസ്‌വേഡ് (നിർബന്ധമല്ല)';

  @override
  String get ownerPasswordHelp =>
      'പ്രിന്റും എഡിറ്റും നിയന്ത്രിക്കുന്നു. ഒഴിച്ചിട്ടാൽ തുറക്കൽ പാസ്‌വേഡ് തന്നെ ഉപയോഗിക്കും.';

  @override
  String get currentPasswordLabel => 'ഇപ്പോഴത്തെ പാസ്‌വേഡ്';

  @override
  String get passwordRequiredError => 'ദയവായി ഒരു പാസ്‌വേഡ് നൽകുക.';

  @override
  String get workingProgress => 'ചെയ്യുന്നു…';

  @override
  String get opFailed => 'പ്രവർത്തനം പരാജയപ്പെട്ടു';

  @override
  String get saveAction => 'സേവ് ചെയ്യുക';

  @override
  String get saveFailed => 'ഫയൽ സേവ് ചെയ്യാൻ കഴിഞ്ഞില്ല';

  @override
  String savedFileMessage(String name) {
    return '$name സേവ് ചെയ്തു';
  }

  @override
  String resultOneFile(String name) {
    return 'പുതിയ ഫയൽ: $name';
  }

  @override
  String resultManyFiles(int count) {
    return '$count പുതിയ ഫയലുകൾ ഉണ്ടാക്കി.';
  }

  @override
  String pageLabel(int page) {
    return 'പേജ് $page';
  }

  @override
  String rotatedBy(int degrees) {
    return '$degrees° തിരിച്ചു';
  }

  @override
  String pageDeletedMessage(int page) {
    return 'പേജ് $page നീക്കി';
  }

  @override
  String get undoAction => 'പഴയപടിയാക്കുക';

  @override
  String get rotateAction => 'തിരിക്കുക';

  @override
  String get deletePageAction => 'പേജ് നീക്കുക';

  @override
  String get noPagesLeftError => 'കുറഞ്ഞത് ഒരു പേജെങ്കിലും വേണം.';

  @override
  String get annotateAction => 'അടയാളപ്പെടുത്തുക';

  @override
  String get annotationHighlight => 'ഹൈലൈറ്റ്';

  @override
  String get annotationUnderline => 'അടിവര';

  @override
  String get annotationStrikethrough => 'വെട്ടിവര';

  @override
  String get annotationInk => 'വരയ്ക്കുക';

  @override
  String get annotationNote => 'കുറിപ്പ്';

  @override
  String get annotationEraser => 'മായ്ക്കുക';

  @override
  String get annotationClearAll => 'എല്ലാ അടയാളങ്ങളും മായ്ക്കുക';

  @override
  String get annotationExport => 'അടയാളങ്ങളോടെ പകർപ്പ് കയറ്റുമതി ചെയ്യുക';

  @override
  String get annotationOverlayNotice =>
      'ഈ അടയാളങ്ങൾ ഈ ആപ്പിനുള്ളിൽ മാത്രമേ സൂക്ഷിക്കൂ. PDF-ൽ നിലനിർത്താൻ അടയാളങ്ങളോടെ ഒരു പകർപ്പ് കയറ്റുമതി ചെയ്യുക.';

  @override
  String get annotationTextMarkupUnavailable =>
      'ഈ PDF-ൽ അടയാളപ്പെടുത്താൻ തിരഞ്ഞെടുക്കാവുന്ന വാചകം ഇല്ല.';

  @override
  String get annotationExporting => 'അടയാളങ്ങളോടെ പകർപ്പ് ഉണ്ടാക്കുന്നു…';

  @override
  String get annotationExportFailed =>
      'അടയാളങ്ങളോടെ പകർപ്പ് ഉണ്ടാക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get annotationNothingToExport => 'ആദ്യം ഒരു അടയാളം ചേർക്കുക.';

  @override
  String get annotationClearAllTitle => 'എല്ലാ അടയാളങ്ങളും മായ്ക്കണോ?';

  @override
  String get annotationClearAllMessage =>
      'ഇത് ഈ ഫയലിലെ എല്ലാ അടയാളങ്ങളും നീക്കും. ഇത് പഴയപടിയാക്കാൻ കഴിയില്ല.';

  @override
  String get noteTitle => 'കുറിപ്പ്';

  @override
  String get noteHint => 'നിങ്ങളുടെ കുറിപ്പ് എഴുതുക';

  @override
  String get deleteAction => 'നീക്കുക';

  @override
  String get bookmarksTitle => 'ബുക്ക്‌മാർക്കുകൾ';

  @override
  String get bookmarksAction => 'ബുക്ക്‌മാർക്കുകൾ';

  @override
  String get bookmarksEmpty => 'ബുക്ക്‌മാർക്കുകൾ ഇല്ല.';

  @override
  String bookmarkAddCurrent(int page) {
    return 'പേജ് $page ബുക്ക്‌മാർക്ക് ചെയ്യുക';
  }

  @override
  String bookmarkRemoveCurrent(int page) {
    return 'പേജ് $page-ലെ ബുക്ക്‌മാർക്ക് നീക്കുക';
  }

  @override
  String bookmarkPageLabel(int page) {
    return 'പേജ് $page';
  }

  @override
  String get shareFailed => 'ഈ ഫയൽ പങ്കിടാൻ കഴിഞ്ഞില്ല.';

  @override
  String get importTitle => 'PDF ആയി സേവ് ചെയ്യുക';

  @override
  String get importBuilding => 'നിങ്ങളുടെ PDF ഉണ്ടാക്കുന്നു…';

  @override
  String get importReadyTitle => 'നിങ്ങളുടെ PDF തയ്യാറാണ്';

  @override
  String importImagesSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ചിത്രങ്ങളിൽ നിന്ന് ഉണ്ടാക്കി',
      one: '1 ചിത്രത്തിൽ നിന്ന് ഉണ്ടാക്കി',
    );
    return '$_temp0';
  }

  @override
  String get importTextSummary => 'നിങ്ങൾ പങ്കിട്ട എഴുത്തിൽ നിന്ന് ഉണ്ടാക്കി.';

  @override
  String importSize(String size) {
    return 'വലുപ്പം: $size';
  }

  @override
  String get importSaveAction => 'PDF ആയി സേവ് ചെയ്യുക';

  @override
  String get importShareAction => 'പങ്കിടുക';

  @override
  String importSaved(String name) {
    return '$name സേവ് ചെയ്തു';
  }

  @override
  String get importFailedTitle => 'PDF ഉണ്ടാക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get importUnsupportedTextTitle =>
      'ഈ അക്ഷരങ്ങൾ ഇപ്പോൾ സേവ് ചെയ്യാൻ കഴിയില്ല';

  @override
  String get importUnsupportedTextDetail =>
      'ഈ ആപ്പിന് ഇംഗ്ലീഷ് അക്ഷരങ്ങളും അക്കങ്ങളും മാത്രമേ PDF-ൽ എഴുതാൻ കഴിയൂ. മലയാളവും മറ്റു ലിപികളും ഇപ്പോൾ പിന്തുണയ്ക്കുന്നില്ല. എഴുത്തിന്റെ ഒരു ചിത്രം സേവ് ചെയ്യാൻ കുഴപ്പമില്ല.';

  @override
  String get printAction => 'പ്രിന്റ് ചെയ്യുക';

  @override
  String get printTitle => 'പ്രിന്റ്';

  @override
  String get printWholeAction => 'മുഴുവൻ ഡോക്യുമെന്റ്';

  @override
  String get printWholeDescription =>
      'ഈ PDF-ന്റെ എല്ലാ പേജുകളും പ്രിന്റ് ചെയ്യുക.';

  @override
  String get printRangeAction => 'പേജ് പരിധി';

  @override
  String get printRangeDescription =>
      'ഏതു പേജുകൾ പ്രിന്റ് ചെയ്യണമെന്ന് തിരഞ്ഞെടുക്കുക.';

  @override
  String get printTextAction => 'എഴുത്ത് മാത്രം';

  @override
  String get printTextDescription =>
      'ഈ PDF-ലെ വാക്കുകൾ സാധാരണ പേജുകളായി പ്രിന്റ് ചെയ്യുക.';

  @override
  String get printRangeTitle => 'പ്രിന്റ് ചെയ്യേണ്ട പേജുകൾ';

  @override
  String get printFromLabel => 'ഈ പേജ് മുതൽ';

  @override
  String get printToLabel => 'ഈ പേജ് വരെ';

  @override
  String printRangeInvalid(int pageCount) {
    return '1 മുതൽ $pageCount വരെയുള്ള പേജ് പരിധി നൽകുക.';
  }

  @override
  String get printPreparing => 'പേജുകൾ തയ്യാറാക്കുന്നു…';

  @override
  String get printUnavailable => 'ഈ ഉപകരണത്തിന് പ്രിന്റ് ചെയ്യാൻ കഴിയില്ല.';

  @override
  String get printFailed => 'പ്രിന്റ് തുടങ്ങാൻ കഴിഞ്ഞില്ല.';

  @override
  String get printNoText => 'ഈ PDF-ൽ പ്രിന്റ് ചെയ്യാൻ എഴുത്തില്ല.';

  @override
  String get signaturesAction => 'ഒപ്പുകൾ';

  @override
  String get signaturesTitle => 'ഒപ്പുകൾ';

  @override
  String get signaturesChecking => 'ഒപ്പുകൾ പരിശോധിക്കുന്നു…';

  @override
  String get signaturesNone => 'ഈ PDF-ൽ ഒപ്പില്ല.';

  @override
  String get signaturesFailed => 'ഈ ഒപ്പുകൾ പരിശോധിക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get signaturesFailedDetail =>
      'ഒപ്പുകൾ മോശമാണെന്ന് ഇതിനർത്ഥമില്ല. ആപ്പിന് അവ വായിക്കാൻ കഴിഞ്ഞില്ല, അതിനാൽ ഒന്നും പറയുന്നില്ല.';

  @override
  String get signatureStatusTrusted => 'ഒപ്പിട്ടത്, വിശ്വസിക്കാം';

  @override
  String get signatureStatusTrustedDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം ഈ രേഖ മാറിയിട്ടില്ല. ഒപ്പിട്ടയാളുടെ സർട്ടിഫിക്കറ്റ് നിങ്ങൾ വിശ്വസിക്കുന്നു.';

  @override
  String get signatureStatusValidNotTrusted =>
      'ഒപ്പിട്ടത്, പക്ഷേ ഒപ്പിട്ടയാളെ അറിയില്ല';

  @override
  String get signatureStatusValidNotTrustedDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം ഈ രേഖ മാറിയിട്ടില്ല. പക്ഷേ ഒപ്പിട്ടയാൾ ആരാണെന്ന് ആപ്പിന് അറിയില്ല.';

  @override
  String get signatureStatusInvalid => 'ഒപ്പ് ശരിയല്ല';

  @override
  String get signatureStatusInvalidDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം രേഖ മാറി, അല്ലെങ്കിൽ ഒപ്പ് ചേരുന്നില്ല. ഇതിനെ ആശ്രയിക്കരുത്.';

  @override
  String get signatureStatusUnknown => 'ഒപ്പ് വായിക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get signatureStatusUnknownDetail =>
      'ഈ ഒപ്പ് ആപ്പിന് മനസ്സിലായില്ല, അതിനാൽ അത് നല്ലതോ ചീത്തയോ എന്ന് പറയുന്നില്ല.';

  @override
  String get signatureNotePartialCoverage =>
      'ഫയലിന്റെ ഒരു ഭാഗം മാത്രം ഉൾക്കൊള്ളുന്നു';

  @override
  String get signatureNotePartialCoverageDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം ഈ ഫയലിൽ എന്തോ ചേർത്തിട്ടുണ്ട്. ആ ഭാഗത്തെക്കുറിച്ച് ഒപ്പ് ഒന്നും പറയുന്നില്ല.';

  @override
  String get signatureNoteRevoked => 'സർട്ടിഫിക്കറ്റ് റദ്ദാക്കി';

  @override
  String get signatureNoteRevokedDetail =>
      'ഈ സർട്ടിഫിക്കറ്റ് നൽകിയവർ അത് റദ്ദാക്കിയിട്ടുണ്ട്. ഇത് വിശ്വസിക്കരുത്.';

  @override
  String get signatureNoteRevocationNotChecked =>
      'സർട്ടിഫിക്കറ്റ് റദ്ദാക്കിയോ എന്ന് പരിശോധിക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get signatureNoteRevocationNotCheckedDetail =>
      'അത് പരിശോധിക്കാൻ ഇന്റർനെറ്റ് വേണം, ഈ ആപ്പ് ഒരിക്കലും അത് ഉപയോഗിക്കില്ല. ഈ PDF-ൽ ആ തെളിവ് ഇല്ല.';

  @override
  String get signatureNoteCertExpired =>
      'ഒപ്പിടുമ്പോൾ സർട്ടിഫിക്കറ്റിന്റെ കാലാവധി കഴിഞ്ഞിരുന്നു';

  @override
  String get signatureNoteCertExpiredDetail =>
      'ഒപ്പിട്ട സമയത്ത് സർട്ടിഫിക്കറ്റ് അതിന്റെ സാധുവായ തീയതികൾക്ക് പുറത്തായിരുന്നു.';

  @override
  String get signatureNoteUnverifiedTime =>
      'ഒപ്പിട്ട സമയം ഒരു അവകാശവാദം മാത്രം';

  @override
  String get signatureNoteUnverifiedTimeDetail =>
      'ഈ സമയം ഫയലിന്റെ ഒപ്പിട്ട ഭാഗത്തിന് പുറത്താണ്, അതിനാൽ ആർക്കും അത് മാറ്റാമായിരുന്നു.';

  @override
  String get signatureSignerLabel => 'ഒപ്പിട്ടത്';

  @override
  String get signatureSignerUnknown => 'പറഞ്ഞിട്ടില്ല';

  @override
  String get signatureSignedAtLabel => 'ഒപ്പിട്ട തീയതി';

  @override
  String get signatureReasonLabel => 'കാരണം';

  @override
  String get signatureLocationLabel => 'സ്ഥലം';

  @override
  String get signatureCertificateTitle => 'സർട്ടിഫിക്കറ്റ്';

  @override
  String get signatureIssuedToLabel => 'നൽകിയത്';

  @override
  String get signatureIssuedByLabel => 'നൽകിയവർ';

  @override
  String get signatureValidFromLabel => 'സാധുവായ തുടക്കം';

  @override
  String get signatureValidUntilLabel => 'സാധുവായ അവസാനം';

  @override
  String get signatureSelfSignedNote =>
      'ഈ സർട്ടിഫിക്കറ്റ് സ്വയം ഉറപ്പുനൽകുന്നു. മറ്റാരും ഇതിന് പിന്തുണ നൽകുന്നില്ല, അതിനാൽ ഒപ്പിട്ടയാളെ അറിയാമെങ്കിൽ മാത്രം വിശ്വസിക്കുക.';

  @override
  String get signatureTrustAction => 'ഈ സർട്ടിഫിക്കറ്റ് വിശ്വസിക്കുക';

  @override
  String get signatureTrustTitle => 'ഈ ഒപ്പിട്ടയാളെ വിശ്വസിക്കണോ?';

  @override
  String get signatureTrustExplain =>
      'ഇനി മുതൽ ഈ സർട്ടിഫിക്കറ്റ് ഉപയോഗിച്ച് ഒപ്പിട്ട ഏത് PDF-ഉം വിശ്വസനീയമായി കാണിക്കും. ഒപ്പിട്ടയാൾ ആരാണെന്ന് അറിയാമെങ്കിൽ മാത്രം ഇത് ചെയ്യുക.';

  @override
  String get signatureTrustConfirm => 'വിശ്വസിക്കുക';

  @override
  String get signatureTrustedToast => 'സർട്ടിഫിക്കറ്റ് വിശ്വസിച്ചു.';

  @override
  String get trustStoreTitle => 'വിശ്വസിക്കുന്ന സർട്ടിഫിക്കറ്റുകൾ';

  @override
  String get trustStoreEmpty =>
      'നിങ്ങൾ ഇതുവരെ ഒരു സർട്ടിഫിക്കറ്റും വിശ്വസിച്ചിട്ടില്ല.';

  @override
  String get trustStoreEmptyDetail =>
      'ഒപ്പിട്ടയാളുടെ സർട്ടിഫിക്കറ്റ് വിശ്വസിക്കുമ്പോൾ അത് ഇവിടെ കാണാം. എപ്പോൾ വേണമെങ്കിലും നീക്കം ചെയ്യാം.';

  @override
  String get trustStoreAddAction => 'ഒരു സർട്ടിഫിക്കറ്റ് ചേർക്കുക';

  @override
  String get trustStoreRemoveAction => 'നീക്കം ചെയ്യുക';

  @override
  String get trustStoreRemoveTitle =>
      'ഈ സർട്ടിഫിക്കറ്റ് വിശ്വസിക്കുന്നത് നിർത്തണോ?';

  @override
  String get trustStoreRemoveExplain =>
      'ഇത് ഉപയോഗിച്ച് ഒപ്പിട്ട PDF-കൾ ഇനി വിശ്വസനീയമായി കാണിക്കില്ല.';

  @override
  String get trustStoreInvalidFile =>
      'ആ ഫയൽ ആപ്പിന് വായിക്കാൻ കഴിയുന്ന സർട്ടിഫിക്കറ്റല്ല.';

  @override
  String get trustStoreExpiredWarning =>
      'ഈ സർട്ടിഫിക്കറ്റിന്റെ കാലാവധി കഴിഞ്ഞു.';
}
