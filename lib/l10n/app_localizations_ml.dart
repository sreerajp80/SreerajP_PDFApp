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
  String get themeOled => 'ഒലെഡ് പിച്ച്-ബ്ലാക്ക്';

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
  String get pageFit => 'പേജ് ക്രമീകരണം';

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
  String get unlockAction => 'തുറക്കുക';

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
  String get searchOptionSandhi => 'സന്ധി തിരയൽ';

  @override
  String get searchOptionSandhiNote =>
      'കൂടിച്ചേർന്നതും പിരിച്ചെഴുതിയതുമായ പദങ്ങൾ കണ്ടെത്തുക';

  @override
  String get searchOptionPhonetic => 'ഉച്ചാരണ സാമ്യ തിരയൽ';

  @override
  String get searchOptionPhoneticNote =>
      'അനുസ്വാര-വർഗ്ഗാക്ഷരങ്ങളും ചില്ലക്ഷര വ്യത്യാസങ്ങളും ഉൾപ്പെടുത്തുക';

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
  String get removePasswordAction => 'പാസ്‌വേഡ് നീക്കുക';

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

  @override
  String get trimMarginsAction => 'മാർജിനുകൾ ക്രോപ്പ് ചെയ്യുക';

  @override
  String get trimMarginsTitle => 'സ്മാർട്ട് മാർജിൻ ട്രിം';

  @override
  String get trimMarginsDescription =>
      'മൊബൈൽ വായനക്കായി വെളുത്ത മാർജിനുകൾ ക്രോപ്പ് ചെയ്യുന്നു.';

  @override
  String get trimMarginsWorking => 'മാർജിനുകൾ ക്രോപ്പ് ചെയ്യുന്നു…';

  @override
  String get trimMarginsDoneTitle => 'മാർജിനുകൾ ക്രോപ്പ് ചെയ്തു';

  @override
  String get trimMarginsDoneNote =>
      'മൊബൈൽ സ്‌ക്രീനുകൾക്ക് അനുയോജ്യമായ രീതിയിൽ മാർജിനുകൾ ക്രോപ്പ് ചെയ്തു.';

  @override
  String get trimPaddingLabel => 'മാർജിൻ പാഡിംഗ്';

  @override
  String get trimPaddingTight => 'കുറഞ്ഞത് (4 pt)';

  @override
  String get trimPaddingStandard => 'സാധാരണം (12 pt)';

  @override
  String get trimPaddingComfortable => 'കൂടുതൽ (24 pt)';

  @override
  String get trimSymmetricLabel => 'തുല്യമായ മാർജിനുകൾ';

  @override
  String get trimSymmetricHelp =>
      'ഇടതും വലതും മാർജിനുകൾ തുല്യമായി സൂക്ഷിക്കുന്നു.';

  @override
  String get bookletAction => 'ബുക്ക്‌ലെറ്റ് നിർമ്മിക്കുക';

  @override
  String get bookletTitle => 'ഫോൾഡബിൾ ബുക്ക്‌ലെറ്റ് (2-Up)';

  @override
  String get bookletDescription =>
      'ഇരുവശത്തും പ്രിന്റ് ചെയ്ത് മടക്കാൻ കഴിയുന്ന 2-Up ബുക്ക്‌ലെറ്റ് ലേഔട്ട് നിർമ്മിക്കുന്നു.';

  @override
  String get bookletWorking => 'ബുക്ക്‌ലെറ്റ് ലേഔട്ട് നിർമ്മിക്കുന്നു…';

  @override
  String get bookletDoneTitle => 'ബുക്ക്‌ലെറ്റ് നിർമ്മിച്ചു';

  @override
  String get bookletDoneNote =>
      'ഇരുവശത്തും പ്രിന്റ് ചെയ്യുക (ഷോർട്ട് എഡ്ജിൽ മറിക്കുക), നടുവിൽ മടക്കുക.';

  @override
  String get bookletSummaryTitle => 'ബുക്ക്‌ലെറ്റ് വിവരങ്ങൾ';

  @override
  String bookletSummaryPages(int source, int padded) {
    return '$source യഥാർത്ഥ പേജുകൾ -> $padded ബുക്ക്‌ലെറ്റ് പേജുകൾ';
  }

  @override
  String bookletSummarySheets(int sheets, int faces) {
    return '$sheets ലാൻഡ്‌സ്‌കേപ്പ് ഷീറ്റുകൾ ($faces പ്രിന്റബിൾ വശങ്ങൾ)';
  }

  @override
  String bookletSummaryBlanks(int blanks) {
    return '$blanks ശൂന്യ പേജുകൾ അവസാനം ചേർത്തു';
  }

  @override
  String get bookletBindingLabel => 'ബൈൻഡിംഗ് ദിശ';

  @override
  String get bookletBindingLtr => 'ഇടത്തുനിന്ന് വലത്തോട്ട് (LTR)';

  @override
  String get bookletBindingRtl => 'വലത്തുനിന്ന് ഇടത്തോട്ട് (RTL)';

  @override
  String get bookletPaperSizeLabel => 'പേപ്പർ വലുപ്പം';

  @override
  String get bookletPaperAuto => 'യഥാർത്ഥ വലുപ്പം';

  @override
  String get bookletPaperA4 => 'A4 ലാൻഡ്‌സ്‌കേപ്പ്';

  @override
  String get bookletPaperLetter => 'US ലെറ്റർ';

  @override
  String get bookletFoldGuideLabel => 'മടക്കാനുള്ള ഗൈഡ് ലൈൻ';

  @override
  String get bookletFoldGuideHelp =>
      'ബുക്ക്‌ലെറ്റ് എവിടെ മടക്കണമെന്ന് കാണിക്കുന്ന ഒരു ചെറിയ ഡോട്ടഡ് വര വരയ്ക്കുന്നു.';

  @override
  String get appearanceTitle => 'രൂപം';

  @override
  String get appearanceSubtitle => 'തീം മോഡ്, ടൈപോഗ്രാഫി, ആക്സന്റ് നിറം';

  @override
  String get themeModeTitle => 'തീം മോഡ്';

  @override
  String get themeModeSubtitle =>
      'ലൈറ്റ്, ഡാർക്ക്, സിസ്റ്റം, സെപിയ എന്നിവയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get themeModeCardSubtitle =>
      'ലൈറ്റ്, ഡാർക്ക്, അല്ലെങ്കിൽ സിസ്റ്റം തിരഞ്ഞെടുക്കുക';

  @override
  String get themeModeDescription =>
      'സിസ്റ്റം മോഡ് നിങ്ങളുടെ ഉപകരണത്തിന്റെ ഡാർക്ക് മോഡ് ക്രമീകരണത്തെ സ്വയം പിന്തുടരും. സെപിയ മോഡ് സുഖകരമായ വായനാനുഭവം നൽകുന്നു.';

  @override
  String get typographyTitle => 'ടൈപോഗ്രാഫിയും ടെക്സ്റ്റ് വലിപ്പവും';

  @override
  String get typographySubtitle =>
      'ആപ്പിന്റെ ഫോണ്ട് കുടുംബവും ടെക്സ്റ്റ് വലിപ്പവും';

  @override
  String get typographyDescription =>
      'വ്യക്തമായ വായനാനുഭവത്തിനായി ഫോണ്ടും അക്ഷരങ്ങളുടെ വലുപ്പവും ക്രമീകരിക്കുക.';

  @override
  String get typographyFontLabel => 'ഫോണ്ട്';

  @override
  String get typographyTextSizeLabel => 'ടെക്സ്റ്റ് വലിപ്പം';

  @override
  String get fontSystemDefault => 'സിസ്റ്റം സ്ഥിരസ്ഥിതി';

  @override
  String get fontManjari => 'Manjari';

  @override
  String get fontAnekMalayalam => 'Anek Malayalam';

  @override
  String get fontNotoSansMalayalam => 'Noto Sans Malayalam';

  @override
  String get textSizeSmall => 'ചെറുത്';

  @override
  String get textSizeDefault => 'ഡിഫോൾട്ട്';

  @override
  String get textSizeLarge => 'വലുത്';

  @override
  String get textSizeLarger => 'കൂടുതൽ വലുത്';

  @override
  String get typographySampleLatin => 'The quick brown fox 0123';

  @override
  String get typographySampleMalayalam => 'മലയാളം സുന്ദരമാണ്';

  @override
  String get accentColorTitle => 'ആക്സന്റ് നിറം';

  @override
  String get accentColorSubtitle => 'പ്രീസെറ്റുകൾ, കലർ വീൽ, തത്സമയ പ്രിവ്യൂ';

  @override
  String get accentAppliesToLight =>
      'ആപ്പ് ലൈറ്റ് മോഡിലായിരിക്കുമ്പോൾ ഈ നിറം ഉപയോഗിക്കുന്നു.';

  @override
  String get accentAppliesToDark =>
      'ആപ്പ് ഡാർക്ക് മോഡിലായിരിക്കുമ്പോൾ ഈ നിറം ഉപയോഗിക്കുന്നു.';

  @override
  String get livePreviewLabel => 'തത്സമയ പ്രിവ്യൂ';

  @override
  String get sampleText => 'മാതൃകാ വാചകം';

  @override
  String get presetsLabel => 'പ്രീസെറ്റുകൾ';

  @override
  String get customColorWheelLabel => 'കളർ വീൽ';

  @override
  String get resetToDefault => 'പഴയപടിയാക്കുക';

  @override
  String get resetLightToDefault => 'ലൈറ്റ് തീം പഴയപടിയാക്കുക';

  @override
  String get resetDarkToDefault => 'ഡാർക്ക് തീം പഴയപടിയാക്കുക';

  @override
  String get contrastNotice =>
      'എളുപ്പത്തിൽ വായിക്കാനായി ടെക്സ്റ്റ് കോൺട്രാസ്റ്റ് സ്വയം ക്രമീകരിക്കപ്പെടുന്നു.';

  @override
  String get permissionsTitle => 'അനുമതികൾ';

  @override
  String get permissionsSubtitle =>
      'സ്റ്റോറേജ്, വെർച്വൽ പ്രിന്റ് സർവീസ്, സ്വകാര്യത';

  @override
  String get permissionsOpenSettings => 'സിസ്റ്റം ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get permissionsExplicitHeader => 'പ്രത്യേക സൗകര്യങ്ങൾ';

  @override
  String get permissionsExplicitSubtitle =>
      'സുരക്ഷിതമായി ഫയലുകൾ കൈകാര്യം ചെയ്യാനുള്ള സംവിധാനങ്ങൾ.';

  @override
  String get permissionsImplicitHeader => 'സ്വകാര്യതയും സിസ്റ്റം വിവരങ്ങളും';

  @override
  String get permissionsImplicitSubtitle =>
      'ഡിക്ലയർ ചെയ്തവ; 100% സുരക്ഷിതമായ ഓഫ്‌ലൈൻ പ്രവർത്തനം.';

  @override
  String get permScopedStorageTitle => 'സ്കോപ്പ്ഡ് സ്റ്റോറേജ് (SAF)';

  @override
  String get permScopedStorageReason =>
      'സിസ്റ്റം ഫയൽ പിക്കർ വഴി സുരക്ഷിതമായി ഡോക്യുമെന്റുകൾ തുറക്കാനും സേവ് ചെയ്യാനും.';

  @override
  String get permPrintServiceTitle => 'വെർച്വൽ പ്രിന്റ് സർവീസ്';

  @override
  String get permPrintServiceReason =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് നേരിട്ട് PDF ആയി പ്രിന്റ് ചെയ്യാൻ സഹായിക്കുന്നു.';

  @override
  String get permOfflineTitle => '100% ഓഫ്‌ലൈനും സ്വകാര്യവും';

  @override
  String get permOfflineReason =>
      'ഇന്റർനെറ്റ് അനുമതികളില്ല. നിങ്ങളുടെ വിവരങ്ങൾ ഫോണിൽ മാത്രം സുരക്ഷിതമായിരിക്കും.';

  @override
  String get permTtsTitle => 'ടെക്സ്റ്റ്-ടു-സ്പീച്ച് എൻജിൻ';

  @override
  String get permTtsReason =>
      'മലയാളത്തിലും ഇംഗ്ലീഷിലും ഉറക്കെ വായിക്കാനായി സ്പീച്ച് എൻജിൻ ഉപയോഗിക്കുന്നു.';

  @override
  String get permProcessTextTitle => 'പ്രോസസ് ടെക്സ്റ്റ് ആക്ഷൻ';

  @override
  String get permProcessTextReason =>
      'മറ്റ് ആപ്പുകളിൽ ടെക്സ്റ്റ് സെലക്ട് ചെയ്യുമ്പോൾ എളുപ്പത്തിൽ തിരയാൻ സഹായിക്കുന്നു.';

  @override
  String get statusActive => 'സജീവം';

  @override
  String get statusSystem => 'സിസ്റ്റം';

  @override
  String get statusOffline => 'ഓഫ്‌ലൈൻ';

  @override
  String get trustStoreSubtitle =>
      'ഡിജിറ്റൽ സിഗ്നേച്ചർ റൂട്ട് സർട്ടിഫിക്കറ്റുകൾ കൈകാര്യം ചെയ്യുക';

  @override
  String get aboutSubtitle => 'ആപ്പ് പതിപ്പ്, ലൈസൻസുകൾ, നിയമ വിവരങ്ങൾ';

  @override
  String get helpTitle => 'സഹായം';

  @override
  String get helpSubtitle => 'ഗൈഡുകൾ, നിർദ്ദേശങ്ങൾ, സഹായക്കുറിപ്പുകൾ';

  @override
  String get helpPdfPrinterTitle => 'PDF പ്രിന്റർ ക്രമീകരണം';

  @override
  String get helpPdfPrinterSubtitle =>
      'വെർച്വൽ പ്രിന്റ് സർവീസ് എങ്ങനെ സജീവമാക്കാം';

  @override
  String get helpPdfPrinterTopicHeader =>
      '1. ആൻഡ്രോയിഡിൽ PDF പ്രിന്റർ എങ്ങനെ സജീവമാക്കാം';

  @override
  String get helpPdfPrinterIntro =>
      'ആൻഡ്രോയിഡിൽ വെർച്വൽ പ്രിന്റ് സർവീസുകൾ സിസ്റ്റം തലത്തിലാണ് നിയന്ത്രിക്കുന്നത്. സിസ്റ്റം-വൈഡ് പ്രിന്ററായി SreerajP PDF App സജീവമാക്കാൻ:';

  @override
  String get helpPdfPrinterStep1 =>
      'നിങ്ങളുടെ ആൻഡ്രോയിഡ് ഉപകരണത്തിലെ ക്രമീകരണങ്ങൾ (Settings) തുറക്കുക.';

  @override
  String get helpPdfPrinterStep2 =>
      'Connected devices → Connection preferences → Printing എന്നതിലേക്ക് പോവുക (അല്ലെങ്കിൽ Settings സെർച്ചിൽ \"Printing\" എന്ന് തിരയുക).';

  @override
  String get helpPdfPrinterStep3 =>
      'Print services എന്നതിന് കീഴിൽ SreerajP PDF App കണ്ടെത്തുക.';

  @override
  String get helpPdfPrinterStep4 => 'അതിൽ ടാപ്പ് ചെയ്ത് ടോഗിൾ On ആക്കുക.';

  @override
  String get helpOpenPrintSettings => 'പ്രിന്റ് ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get helpUnicodePrintingTitle => 'യൂണികോഡ് & മലയാളം PDF പ്രിന്റിംഗ്';

  @override
  String get helpUnicodePrintingSubtitle =>
      'മലയാളം അക്ഷരങ്ങൾ തെറ്റാതെ PDF ആക്കി മാറ്റുക';

  @override
  String get helpUnicodePrintingTopicHeader =>
      'യൂണികോഡ് & മലയാളം ശരിയായി പ്രിന്റ് ചെയ്യാം';

  @override
  String get helpUnicodePrintingIntro =>
      'ആൻഡ്രോയിഡിന്റെ സാധാരണ പ്രിന്റ്-ടു-PDF സംവിധാനത്തിൽ ചിലപ്പോൾ മലയാളം, സംസ്കൃതം, ഹിന്ദി തുടങ്ങിയ ഭാഷകളിലെ കൂട്ടക്ഷരങ്ങളും ചില്ലക്ഷരങ്ങളും വിട്ടുപോവുകയോ വികലമാവുകയോ ചെയ്യാറുണ്ട്. SreerajP PDF App ഈ അക്ഷരങ്ങളും ഫോണ്ടുകളും കൃത്യമായി എംബഡ് ചെയ്ത് വ്യക്തതയുള്ള PDF ഉണ്ടാക്കുന്നു.';

  @override
  String get helpUnicodePrintingStep1 =>
      'ആൻഡ്രോയിഡ് സെറ്റിങ്സിൽ PDF വെർച്വൽ പ്രിന്റർ ഓൺ ചെയ്തിട്ടുണ്ടെന്ന് ഉറപ്പാക്കുക.';

  @override
  String get helpUnicodePrintingStep2 =>
      'ബ്രൗസർ, വാട്ട്സ്ആപ്പ് അല്ലെങ്കിൽ ഓഫീസ് ആപ്പുകളിൽ നിന്ന് Print തിരഞ്ഞെടുക്കുക.';

  @override
  String get helpUnicodePrintingStep3 =>
      'സാധാരണ \'Save as PDF\' എന്നതിന് പകരം \'SreerajP PDF App\' പ്രിന്ററായി തിരഞ്ഞെടുക്കുക.';

  @override
  String get helpUnicodePrintingStep4 =>
      'ആപ്പ് പ്രിന്റ് വിവരങ്ങൾ ശേഖരിച്ച് മലയാളം അക്ഷരക്കൂട്ടുകൾ സുന്ദരമായി ചേർത്ത് പുതിയ PDF ഫയൽ നിർമ്മിക്കുന്നു.';

  @override
  String get helpUnicodePrintingTip =>
      'സഹായക്കുറിപ്പ്: വെബ് പേജുകൾ പ്രിന്റ് ചെയ്യുമ്പോൾ പരസ്യങ്ങളും മറ്റ് അനാവശ്യ ഭാഗങ്ങളും ഒഴിവാക്കാൻ പ്രിന്റർ സെറ്റിങ്സിൽ \'വെബ് കണ്ടന്റ് ക്ലീനർ\' ഓൺ ചെയ്യുക.';

  @override
  String get helpOpenPrinterSettings => 'പ്രിന്റർ ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get helpTtsTitle => 'ഉറക്കെ വായിക്കുക (TTS) & മലയാളം വോയ്സ്';

  @override
  String get helpTtsSubtitle =>
      'സ്പീച്ച് എൻജിൻ, വായനാ വേഗത, മലയാളം ശബ്ദം സജ്ജീകരിക്കുക';

  @override
  String get helpTtsTopicHeader =>
      'ഉറക്കെ വായിക്കുന്നതും മലയാളം വോയ്സ് ഇൻസ്റ്റാൾ ചെയ്യുന്നതും';

  @override
  String get helpTtsIntro =>
      'ഫോണിലെ ടെക്സ്റ്റ്-ടു-സ്പീച്ച് (TTS) എൻജിൻ ഉപയോഗിച്ച് PDF ഡോക്യുമെന്റുകൾ ഉറക്കെ വായിക്കാൻ സാധിക്കും. ഇത് ഇംഗ്ലീഷും മലയാളവും പിന്തുണയ്ക്കുന്നു.';

  @override
  String get helpTtsStep1 =>
      'ടെക്സ്റ്റ് ഉള്ള PDF തുറന്ന് മുകളിലെ \'ഉറക്കെ വായിക്കുക\' (സ്പീക്കർ) ഐക്കൺ ടാപ്പ് ചെയ്യുക.';

  @override
  String get helpTtsStep2 =>
      'മലയാളം വോയ്സ് ഇല്ലെങ്കിൽ, ക്രമീകരണങ്ങൾ → ഉറക്കെ വായിക്കുക (TTS) എന്നതിൽ പോയി \'മലയാളം വോയ്സ് ഡൗൺലോഡ് ചെയ്യുക\' ടാപ്പ് ചെയ്യുക.';

  @override
  String get helpTtsStep3 =>
      'വായനാ വേഗത, വോയ്സ് പിച്ച്, വാചകങ്ങൾക്ക് ഇടയിലെ ഇടവേള എന്നിവ നിങ്ങളുടെ സൗകര്യത്തിനനുസരിച്ച് മാറ്റാം.';

  @override
  String get helpTtsTip =>
      'ശ്രദ്ധിക്കുക: അക്ഷരങ്ങൾ തിരഞ്ഞെടുക്കാൻ കഴിയാത്ത സ്കാൻ ചെയ്ത ചിത്രങ്ങളുള്ള PDF-കൾ ഉറക്കെ വായിക്കാൻ സാധിക്കില്ല. OCR പിന്തുണ ലഭ്യമല്ല.';

  @override
  String get helpOpenTtsSettings => 'TTS ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get helpPageOpsTitle => 'പേജുകൾ ക്രമീകരിക്കലും മാറ്റം വരുത്തലും';

  @override
  String get helpPageOpsSubtitle =>
      'Merge, Split, പുനഃക്രമീകരിക്കൽ, റൊട്ടേഷൻ, ബുക്ക്‌ലെറ്റ്, N-Up';

  @override
  String get helpPageOpsTopicHeader =>
      'പേജ് മാറ്റങ്ങളും സുരക്ഷിതമായ കോപ്പി-ഓൺ-റൈറ്റും';

  @override
  String get helpPageOpsIntro =>
      'നിങ്ങളുടെ PDF-ലെ പേജുകൾ എളുപ്പത്തിൽ മാറ്റിമറിക്കാം. എല്ലാ മാറ്റങ്ങളും പുതിയ ഫയലായി മാത്രമേ സേവ് ചെയ്യപ്പെടൂ — നിങ്ങളുടെ ഒറിജിനൽ ഫയലിൽ മാറ്റം വരില്ല.';

  @override
  String get helpPageOpsStep1 =>
      'ഡോക്യുമെന്റ് തുറന്ന് പേജ് ഓപ്പറേഷൻസ് മെനു അല്ലെങ്കിൽ ഓർഗനൈസർ വ്യൂ എടുക്കുക.';

  @override
  String get helpPageOpsStep2 =>
      'പേജുകൾ ഡ്രാഗ് ചെയ്ത് സ്ഥാനം മാറ്റാം, തിരിക്കാം (Rotate), അല്ലെങ്കിൽ വേണ്ടാത്ത പേജുകൾ നീക്കം ചെയ്യാം.';

  @override
  String get helpPageOpsStep3 =>
      'മടക്കാവുന്ന ബുക്ക്‌ലെറ്റുകൾക്കായി \'Booklet\' ഓപ്ഷനും, ഒരു ഷീറ്റിൽ പല പേജുകൾക്കായി \'N-Up\' ഓപ്ഷനും ഉപയോഗിക്കുക.';

  @override
  String get helpPageOpsStep4 =>
      'സേവ് / എക്സ്പോർട്ട് ടാപ്പ് ചെയ്ത് പുതിയ PDF ഫയൽ സേവ് ചെയ്യുക.';

  @override
  String get helpPageOpsTip =>
      'സുരക്ഷാ ഉറപ്പ്: യഥാർത്ഥ ഫയൽ ഒരിക്കലും തിരുത്തപ്പെടാത്തതിനാൽ പേജുകൾ ധൈര്യമായി പുനഃക്രമീകരിക്കാം.';

  @override
  String get helpSignaturesTitle => 'ഡിജിറ്റൽ ഒപ്പുകളും ട്രസ്റ്റ് സ്റ്റോറും';

  @override
  String get helpSignaturesSubtitle =>
      'ഓഫ്‌ലൈൻ ക്രിപ്റ്റോഗ്രാഫിക് പരിശോധനയും സർട്ടിഫിക്കറ്റുകളും';

  @override
  String get helpSignaturesTopicHeader =>
      'ഡിജിറ്റൽ ഒപ്പുകൾ ഓഫ്‌ലൈനായി പരിശോധിക്കാം';

  @override
  String get helpSignaturesIntro =>
      'SreerajP PDF App ഇന്റർനെറ്റ് സഹായമില്ലാതെ തന്നെ ക്രിപ്റ്റോഗ്രാഫിക് അൽഗോരിതങ്ങൾ (SHA-256, X.509) ഉപയോഗിച്ച് പൂർണ്ണമായും ഓഫ്‌ലൈനായി ഒപ്പുകൾ പരിശോധിക്കുന്നു.';

  @override
  String get helpSignaturesStep1 =>
      'ഒപ്പുള്ള PDF തുറക്കുമ്പോൾ മുകളിലെ സിഗ്നേച്ചർ ബാഡ്ജിൽ ടാപ്പ് ചെയ്ത് വിവരങ്ങൾ കാണാം.';

  @override
  String get helpSignaturesStep2 =>
      'ഒപ്പിട്ടതിനു ശേഷം ഡോക്യുമെന്റിൽ മാറ്റങ്ങൾ വന്നിട്ടുണ്ടോ എന്ന് ആപ്പ് പരിശോധിക്കും.';

  @override
  String get helpSignaturesStep3 =>
      'അപരിചിതമായ സർട്ടിഫിക്കറ്റുകൾ ഉണ്ടെങ്കിൽ ട്രസ്റ്റ് സ്റ്റോറിലേക്ക് റൂട്ട് സർട്ടിഫിക്കറ്റ് ചേർക്കാവുന്നതാണ്.';

  @override
  String get helpSignaturesTip =>
      'സുരക്ഷാ വിവരം: ഒപ്പുകൾ പരിശോധിക്കുന്നത് ഫോണിനുള്ളിൽ മാത്രമാണ്. വിവരങ്ങൾ ഒരിടത്തേക്കും അയക്കുന്നില്ല.';

  @override
  String get helpOpenTrustStore => 'ട്രസ്റ്റ് സ്റ്റോർ തുറക്കുക';

  @override
  String get helpPrivacyStorageTitle => 'സ്വകാര്യതയും സ്കോപ്പ്ഡ് സ്റ്റോറേജും';

  @override
  String get helpPrivacyStorageSubtitle =>
      'പൂർണ്ണ ഓഫ്‌ലൈൻ സുരക്ഷയും സ്കോപ്പ്ഡ് സ്റ്റോറേജും';

  @override
  String get helpPrivacyStorageTopicHeader => '100% ഓഫ്‌ലൈൻ സ്വകാര്യതാ ഉറപ്പ്';

  @override
  String get helpPrivacyStorageIntro =>
      'നിങ്ങളുടെ സ്വകാര്യത പൂർണ്ണമായി സംരക്ഷിക്കപ്പെടുന്നു. ഇന്റർനെറ്റ് ബന്ധമില്ലാതെ ഒറ്റപ്പെട്ട് പ്രവർത്തിക്കുന്ന രീതിയിലാണ് ആപ്പ് നിർമ്മിച്ചിരിക്കുന്നത്.';

  @override
  String get helpPrivacyStorageStep1 =>
      'ഇന്റർനെറ്റ് അനുമതികളില്ല: ആപ്പിന്റെ മാനിഫെസ്റ്റിൽ INTERNET അനുമതിയില്ല. വിവരങ്ങൾ ചോരില്ല.';

  @override
  String get helpPrivacyStorageStep2 =>
      'സ്കോപ്പ്ഡ് സ്റ്റോറേജ്: നിങ്ങൾ തിരഞ്ഞെടുക്കുന്ന ഫയലുകൾ മാത്രമേ ആപ്പ് തുറക്കുകയുള്ളൂ.';

  @override
  String get helpPrivacyStorageStep3 =>
      'കാഷെ നീക്കം ചെയ്യൽ: താൽക്കാലിക റെൻഡറിംഗ് ഫയലുകൾ ഏതു സമയത്തും സ്റ്റോറേജ് സെറ്റിങ്സിൽ നിന്ന് ഒഴിവാക്കാം.';

  @override
  String get helpPrivacyStorageTip =>
      'പാസ്‌വേഡ് സുരക്ഷ: പാസ്‌വേഡ് ഉള്ള PDF തുറക്കുമ്പോൾ നൽകുന്ന പാസ്‌വേഡുകൾ മെമ്മറിയിൽ സൂക്ഷിക്കാറില്ല, ഡിസ്കിൽ സേവ് ചെയ്യുകയുമില്ല.';

  @override
  String get helpOpenStorageSettings =>
      'സ്റ്റോറേജ് & പ്രൈവസി ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get languageTitle => 'ഭാഷ';

  @override
  String get languageSubtitle => 'ആപ്പ് ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get languageSystem => 'സിസ്റ്റം ഡിഫോൾട്ട്';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageMalayalam => 'മലയാളം';

  @override
  String get languageSelectTitle => 'ആപ്പ് ഭാഷ';

  @override
  String get languageSelectSubtitle =>
      'തിരഞ്ഞെടുക്കുന്ന ഭാഷ ആപ്പിൽ ഉടനടി ലഭ്യമാകും.';

  @override
  String get readerSettingsTitle => 'റീഡറും വ്യൂവറും';

  @override
  String get readerSettingsSubtitle => 'വായനാ സ്ഥാനം, ലേഔട്ട്, സൂം, ഡിസ്പ്ലേ';

  @override
  String get saveLastPositionTitle => 'അവസാന വായനാ സ്ഥാനം ഓർക്കുക';

  @override
  String get saveLastPositionSubtitle =>
      'തുറക്കുമ്പോൾ അവസാനമായി വായിച്ച പേജും സൂമും സ്വയം ക്രമീകരിക്കും';

  @override
  String get defaultPageLayoutTitle => 'ഡിഫോൾട്ട് പേജ് ലേഔട്ട്';

  @override
  String get defaultPageLayoutSubtitle =>
      'ഡോക്യുമെന്റുകൾ തുറക്കുമ്പോൾ പേജുകൾ പ്രദർശിപ്പിക്കേണ്ട രീതി';

  @override
  String get layoutContinuous => 'തുടർച്ചയായ സ്ക്രോൾ';

  @override
  String get layoutSinglePage => 'ഒറ്റ പേജ്';

  @override
  String get doubleTapZoomTitle => 'ഡബിൾ-ടാപ്പ് സൂം';

  @override
  String get doubleTapZoomSubtitle =>
      'പേജിൽ ഇരട്ട ടാപ്പ് ചെയ്യുമ്പോൾ ചെയ്യേണ്ട പ്രവർത്തനം';

  @override
  String get zoomFitWidth => 'വീതിക്ക് അനുയോജ്യമാക്കുക';

  @override
  String get zoom200 => '200% സൂം';

  @override
  String get showPageIndicatorTitle => 'പേജ് നമ്പർ സൂചിക';

  @override
  String get showPageIndicatorSubtitle =>
      'വായിക്കുമ്പോൾ സ്ക്രീനിൽ പേജ് നമ്പർ കാണിക്കുക';

  @override
  String get invertColorsTitle => 'PDF നിറങ്ങൾ വിപരീതമാക്കുക';

  @override
  String get invertColorsSubtitle =>
      'രാത്രി വായനയ്ക്കായി ഡോക്യുമെന്റ് നിറങ്ങൾ മാറ്റുക';

  @override
  String get ttsSettingsTitle => 'ഉറക്കെ വായിക്കുക (TTS)';

  @override
  String get ttsSettingsSubtitle => 'ശബ്ദം, വായനാ വേഗത, പിച്ച്, ഓപ്ഷനുകൾ';

  @override
  String get ttsSpeechRateTitle => 'വായനാ വേഗത';

  @override
  String ttsSpeechRateSubtitle(String rate) {
    return '${rate}x വേഗത';
  }

  @override
  String get ttsPitchTitle => 'വോയ്സ് പിച്ച്';

  @override
  String ttsPitchSubtitle(String pitch) {
    return '${pitch}x പിച്ച്';
  }

  @override
  String get ttsAutoScrollTitle => 'വായനയ്ക്കൊപ്പം സ്വയം സ്ക്രോൾ ചെയ്യുക';

  @override
  String get ttsAutoScrollSubtitle =>
      'വായിക്കുന്ന വാചകങ്ങൾക്കൊപ്പം ഡോക്യുമെന്റ് സ്വയം നീങ്ങുന്നു';

  @override
  String get printerSettingsTitle => 'PDF വെർച്വൽ പ്രിന്റർ';

  @override
  String get printerSettingsSubtitle =>
      'പ്രിന്റ് സർവീസ് സംയോജനം, പേപ്പർ വലുപ്പം, കാഷെ';

  @override
  String get printerEnableTitle => 'PDF പ്രിന്റർ സജീവമാക്കുക';

  @override
  String get printerEnableSubtitle =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് പ്രിന്റ് സ്വീകരിച്ച് PDF ആയി സേവ് ചെയ്യുക';

  @override
  String get defaultPaperSizeTitle => 'ഡിഫോൾട്ട് പേപ്പർ വലുപ്പം';

  @override
  String get defaultPaperSizeSubtitle => 'തയ്യാറാക്കുന്ന PDF-കളുടെ പേപ്പർ അളവ്';

  @override
  String get defaultColorModeTitle => 'ഡിഫോൾട്ട് കളർ മോഡ്';

  @override
  String get defaultColorModeSubtitle => 'പ്രിന്റ് ചെയ്യുന്ന ഫയലുകളുടെ നിറം';

  @override
  String get colorModeColor => 'നിറമുള്ളത്';

  @override
  String get colorModeGrayscale => 'ഗ്രേസ്കെയിൽ';

  @override
  String get colorModeMonochrome => 'മോണോക്രോം (കറുപ്പും വെളുപ്പും)';

  @override
  String get defaultOrientationTitle => 'ഡിഫോൾട്ട് ഓറിയന്റേഷൻ';

  @override
  String get defaultOrientationSubtitle => 'പേജ് പ്രദർശന ദിശ';

  @override
  String get orientationAuto => 'സ്വയം (ഫയലിനനുസരിച്ച്)';

  @override
  String get orientationPortrait => 'പോർട്രയിറ്റ്';

  @override
  String get orientationLandscape => 'ലാൻഡ്‌സ്കേപ്പ്';

  @override
  String get clearPrinterCacheTitle => 'പ്രിന്റർ കാഷെ നീക്കം ചെയ്യുക';

  @override
  String clearPrinterCacheSubtitle(String size) {
    return 'താൽക്കാലിക പ്രിന്റ് ഫയലുകൾ നീക്കം ചെയ്യുക ($size)';
  }

  @override
  String get printerCacheCleared => 'പ്രിന്റർ കാഷെ നീക്കം ചെയ്തു.';

  @override
  String get storageSettingsTitle => 'സ്റ്റോറേജും സ്വകാര്യതയും';

  @override
  String get storageSettingsSubtitle =>
      'റീസെന്റ് ഫയലുകളുടെ ചരിത്രവും കാഷെ വിവരങ്ങളും';

  @override
  String get rememberRecentFilesTitle => 'റീസെന്റ് ഫയലുകൾ ഓർക്കുക';

  @override
  String get rememberRecentFilesSubtitle =>
      'തുറന്ന ഡോക്യുമെന്റുകൾ ഹോം സ്ക്രീനിൽ കാണിക്കുക';

  @override
  String get clearRecentFilesTitle => 'റീസെന്റ് ഫയലുകളുടെ ചരിത്രം മായ്ക്കുക';

  @override
  String get clearRecentFilesSubtitle =>
      'തുറന്ന ഫയലുകളുടെ പട്ടികയും വായനാ സ്ഥാനങ്ങളും മായ്ക്കുന്നു';

  @override
  String get clearRecentFilesConfirmTitle => 'റീസെന്റ് ഫയലുകൾ മായ്ക്കണോ?';

  @override
  String get clearRecentFilesConfirmMessage =>
      'ഇത് നിങ്ങളുടെ സമീപകാല ഫയലുകളുടെ ലിസ്റ്റും വായനാ പുരോഗതിയും മായ്ക്കും. ഫോണിലെ യഥാർത്ഥ PDF ഫയലുകൾ ഇല്ലാതാകില്ല.';

  @override
  String get clearRecentFilesAction => 'ചരിത്രം മായ്ക്കുക';

  @override
  String get recentFilesCleared => 'റീസെന്റ് ഫയലുകളുടെ ചരിത്രം മായ്ച്ചു.';

  @override
  String get clearTempCacheTitle => 'ആപ്പ് കാഷെ മായ്ക്കുക';

  @override
  String clearTempCacheSubtitle(String size) {
    return 'വിവരങ്ങൾ നഷ്ടപ്പെടാതെ താൽക്കാലിക ഫയലുകൾ ഒഴിവാക്കുക ($size)';
  }

  @override
  String get tempCacheCleared => 'താൽക്കാലിക കാഷെ മായ്ച്ചു.';

  @override
  String get securitySettingsTitle => 'സിഗ്നേച്ചറുകളും സുരക്ഷയും';

  @override
  String get securitySettingsSubtitle =>
      'ഡിജിറ്റൽ സിഗ്നേച്ചർ പരിശോധനയും സർട്ടിഫിക്കറ്റുകളും';

  @override
  String get autoVerifySignaturesTitle => 'സിഗ്നേച്ചർ സ്വയം പരിശോധിക്കുക';

  @override
  String get autoVerifySignaturesSubtitle =>
      'ഒപ്പിട്ട PDF തുറക്കുമ്പോൾ ഡിജിറ്റൽ ഒപ്പുകൾ സ്വയം പരിശോധിക്കുക';

  @override
  String get permFileProviderTitle => 'സുരക്ഷിത ഫയൽ പ്രൊവൈഡർ';

  @override
  String get permFileProviderReason =>
      'സ്വകാര്യ ഫയൽ പാതകൾ വെളിപ്പെടുത്താതെ താൽക്കാലിക PDF-കൾ മറ്റ് ആപ്പുകളുമായി പങ്കിടാൻ സഹായിക്കുന്നു.';

  @override
  String get permFileProviderWhatItAchieves =>
      'സ്റ്റോറേജ് സുരക്ഷ നഷ്ടപ്പെടുത്താതെ PDF ഫയലുകൾ സുരക്ഷിതമായി ഷെയർ ചെയ്യാനും പ്രിന്റ് ചെയ്യാനും സാധിക്കുന്നു.';

  @override
  String get permTtsInstallTitle => 'വോയ്സ് ഡാറ്റ ഇൻസ്റ്റാളർ';

  @override
  String get permTtsInstallReason =>
      'ആവശ്യമായ ഭാഷാ ശബ്ദങ്ങൾ ലഭ്യമല്ലെങ്കിൽ സിസ്റ്റം ഡൗൺലോഡ് സ്ക്രീൻ തുറക്കുന്നു.';

  @override
  String get permTtsInstallWhatItAchieves =>
      'മലയാളം, ഇംഗ്ലീഷ് സംസാര ശബ്ദങ്ങൾ എളുപ്പത്തിൽ ഇൻസ്റ്റാൾ ചെയ്യാൻ സഹായിക്കുന്നു.';

  @override
  String get permSendShareTitle => 'ഷെയറുകൾ സ്വീകരിക്കലും \'Open with\' ഉം';

  @override
  String get permSendShareReason =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് ഷെയർ ചെയ്യുന്ന ചിത്രങ്ങളും വാചകങ്ങളും PDF ഫയലുകളും സ്വീകരിക്കുന്നു.';

  @override
  String get permSendShareWhatItAchieves =>
      'ഷെയർ ചെയ്യുന്ന ചിത്രങ്ങളും വാചകങ്ങളും നേരിട്ട് PDF ആക്കി മാറ്റാനും ഏത് ആപ്പിൽ നിന്നും PDF തുറക്കാനും സാധിക്കുന്നു.';

  @override
  String get permZeroInternetTitle => 'ഇന്റർനെറ്റ് ഉപയോഗമില്ല';

  @override
  String get permZeroInternetReason =>
      'ഇന്റർനെറ്റ് അനുമതി ആവശ്യപ്പെടുന്നില്ല. ആപ്പ് 100% ഓഫ്‌ലൈനായി പ്രവർത്തിക്കുന്നു.';

  @override
  String get permZeroInternetWhatItAchieves =>
      'യാതൊരു വിവരങ്ങളും പുറത്തുപോകാതെ പൂർണ്ണ സ്വകാര്യത ഉറപ്പാക്കുന്നു.';

  @override
  String get permScopedStorageWhatItAchieves =>
      'ഫോണിലെ മറ്റ് ഫയലുകളുടെ സ്വകാര്യത നിലനിർത്തിക്കൊണ്ട് ഉപയോക്താവ് തിരഞ്ഞെടുത്ത PDF മാത്രം കൈകാര്യം ചെയ്യുന്നു.';

  @override
  String get permPrintServiceWhatItAchieves =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് SreerajP PDF App വഴി നേരിട്ട് PDF ആയി സേവ് ചെയ്യാൻ സഹായിക്കുന്നു.';

  @override
  String get permOfflineWhatItAchieves =>
      'നിങ്ങളുടെ രേഖകളും വിവരങ്ങളും ഒരിക്കലും ഈ ഉപകരണത്തിൽ നിന്ന് പുറത്തുപോകില്ലെന്ന് ഉറപ്പാക്കുന്നു.';

  @override
  String get permTtsWhatItAchieves =>
      'മലയാളത്തിലും ഇംഗ്ലീഷിലും രേഖകൾ ഉറക്കെ വായിക്കാനായി ലഭ്യമായ സ്പീച്ച് എൻജിനുകൾ കണ്ടെത്തുന്നു.';

  @override
  String get permProcessTextWhatItAchieves =>
      'ഏതെങ്കിലും ആപ്പിൽ സെലക്ട് ചെയ്ത വാചകങ്ങൾ നേരിട്ട് ഈ ആപ്പിൽ തിരയാൻ സഹായിക്കുന്നു.';

  @override
  String get permWhyNeededHeader => 'എന്തുകൊണ്ട് ആവശ്യമാണ്';

  @override
  String get permWhatItAchievesHeader => 'ഇതുകൊണ്ട് ലഭ്യമാകുന്ന സൗകര്യം';

  @override
  String get permTypeExplicit => 'പ്രത്യേക സൗകര്യം';

  @override
  String get permTypeImplicit => 'ഇംപ്ലിസിറ്റ് / സിസ്റ്റം ക്വറി';

  @override
  String get permTypePrivacy => 'സ്വകാര്യത ഉറപ്പ്';

  @override
  String get readingVelocityTitle => 'വായനാ വേഗതയും സമയവും';

  @override
  String get readingVelocitySubtitle =>
      'വായനാ വേഗത അടിസ്ഥാനമാക്കി അധ്യായം തീരാനുള്ള സമയം കണക്കാക്കുന്നു';

  @override
  String readingSpeedLabel(int wpm) {
    return '$wpm wpm';
  }

  @override
  String readingTimeLeftChapter(int minutes) {
    return 'അധ്യായത്തിൽ $minutes മിനിറ്റ് ബാക്കി';
  }

  @override
  String readingTimeLeftDoc(int minutes) {
    return '$minutes മിനിറ്റ് ബാക്കി';
  }

  @override
  String get readingTimeLessMinute => '< 1 മിനിറ്റ് ബാക്കി';

  @override
  String get readingTimeEstimatesToggle => 'വായനാ സമയ കണക്കുകൂട്ടൽ';

  @override
  String get readingTimeEstimatesToggleSubtitle =>
      'റീഡർ ബാറിൽ ശേഷിക്കുന്ന വായനാ സമയം കാണിക്കുക';

  @override
  String get viewModeAuto => 'ഓട്ടോ (ഫോൾഡബിളിൽ രണ്ട് പേജ്)';

  @override
  String get viewModeAutoSubtitle =>
      'ടാബ്‌ലെറ്റുകളിലും ഫോൾഡബിൾ സ്ക്രീനുകളിലും സ്വയം രണ്ട് പേജ് വ്യൂവിലേക്ക് മാറുന്നു';

  @override
  String get malayalamHelperTitle => 'മലയാളം കീബോർഡ് സഹായി';

  @override
  String get malayalamHelperTooltip =>
      'മലയാളം ടൈപ്പിംഗ് സഹായി (മംഗ്ലീഷ് & കീപാഡ്)';

  @override
  String get malayalamKeypadTabTranslit => 'മംഗ്ലീഷ്';

  @override
  String get malayalamKeypadTabVowels => 'സ്വരാക്ഷരങ്ങൾ';

  @override
  String get malayalamKeypadTabConsonants => 'വ്യഞ്ജനാക്ഷരങ്ങൾ';

  @override
  String get malayalamKeypadTabSigns => 'ചില്ല് & ചിഹ്നങ്ങൾ';

  @override
  String get ttsSentencePauseTitle => 'വാക്യങ്ങൾക്കിടയിലെ ഇടവേള';

  @override
  String ttsSentencePauseSubtitle(String seconds) {
    return 'വാക്യങ്ങൾക്കിടയിൽ $seconds സെക്കൻഡ് ഇടവേള';
  }

  @override
  String ttsReadingPage(int page) {
    return 'പേജ് $page വായിക്കുന്നു...';
  }

  @override
  String get ttsPaused => 'താൽക്കാലികമായി നിർത്തി';

  @override
  String ttsReadyToRead(int page) {
    return 'പേജ് $page വായിക്കാൻ തയ്യാറാണ്';
  }

  @override
  String get watermarkAction => 'കസ്റ്റം വാട്ടർമാർക്ക്';

  @override
  String get watermarkDescription =>
      'പേജുകളിൽ ടെക്സ്റ്റ് അല്ലെങ്കിൽ ഇമേജ് വാട്ടർമാർക്ക് ചേർക്കുക';

  @override
  String get watermarkDialogTitle => 'കസ്റ്റം വാട്ടർമാർക്ക്';

  @override
  String get watermarkTextLabel => 'വാട്ടർമാർക്ക് ടെക്സ്റ്റ്';

  @override
  String get watermarkEmptyTextError =>
      'ദയവായി വാട്ടർമാർക്ക് ടെക്സ്റ്റ് നൽകുക.';

  @override
  String get watermarkDoneTitle => 'വാട്ടർമാർക്ക് ചേർത്ത PDF തയ്യാറായി';

  @override
  String get watermarkOpacityLabel => 'സുതാര്യത (Opacity)';

  @override
  String get watermarkRotationLabel => 'തിരിക്കൽ കോൺ';

  @override
  String get watermarkFontSizeLabel => 'അക്ഷര വലിപ്പം';

  @override
  String get watermarkColorLabel => 'നിറം';

  @override
  String get watermarkTiledLabel => 'പേജിലുടനീളം ആവർത്തിക്കുക (Tile)';

  @override
  String get watermarkTiledDescription =>
      'മുഴുവൻ പേജിലും വാട്ടർമാർക്ക് ആവർത്തിച്ച് നൽകുന്നു';

  @override
  String get watermarkPageRangeLabel => 'ബാധകമാക്കേണ്ട പേജുകൾ';

  @override
  String get watermarkAllPages => 'എല്ലാ പേജുകളും';

  @override
  String get watermarkOddPages => 'ഒറ്റയക്ക പേജുകൾ മാത്രം';

  @override
  String get watermarkEvenPages => 'ഇരട്ടയക്ക പേജുകൾ മാത്രം';

  @override
  String get watermarkApplyAction => 'വാട്ടർമാർക്ക് ചേർക്കുക';

  @override
  String get batchOperationsTitle => 'ബാച്ച് പ്രവർത്തനങ്ങൾ';

  @override
  String get batchOperationsDescription =>
      'ഒന്നിലധികം PDF ഫയലുകൾ ഒരേസമയം പ്രോസസ്സ് ചെയ്യുക';

  @override
  String get batchOperationLabel => 'പ്രവർത്തനം തിരഞ്ഞെടുക്കുക';

  @override
  String get batchOpEncrypt => 'ബാച്ച് എൻക്രിപ്റ്റ് / ലോക്ക് ചെയ്യുക';

  @override
  String get batchOpMerge => 'ബാച്ച് ലയനം (Merge)';

  @override
  String get batchOpExtractText => 'ബാച്ച് ടെക്സ്റ്റ് എക്സ്ട്രാക്ഷൻ (.txt)';

  @override
  String get batchOpTrimMargins => 'ബാച്ച് മാർജിൻ ട്രിം ചെയ്യുക';

  @override
  String get batchOpCompress => 'ബാച്ച് കംപ്രസ് ചെയ്യുക';

  @override
  String batchSelectedFilesCount(int count) {
    return 'തിരഞ്ഞെടുത്ത ഫയലുകൾ ($count)';
  }

  @override
  String get batchAddFilesAction => 'ഫയലുകൾ ചേർക്കുക';

  @override
  String get batchNoFilesSelected =>
      'PDF ഫയലുകൾ തിരഞ്ഞെടുത്തിട്ടില്ല. ചേർക്കാൻ \'ഫയലുകൾ ചേർക്കുക\' ടാപ്പ് ചെയ്യുക.';

  @override
  String batchProgressLabel(int current, int total, String name) {
    return 'പ്രോസസ്സ് ചെയ്യുന്നു ($current/$total): $name';
  }

  @override
  String get batchStartAction => 'ബാച്ച് പ്രവർത്തനം ആരംഭിക്കുക';

  @override
  String batchDoneSummary(int success, int total) {
    return '$total ഡോക്യുമെന്റുകളിൽ $success എണ്ണം വിജയകരമായി പ്രോസസ്സ് ചെയ്തു.';
  }

  @override
  String get batchFailedAll =>
      'എല്ലാ ഡോക്യുമെന്റുകളുടെയും ബാച്ച് പ്രോസസ്സിംഗ് പരാജയപ്പെട്ടു.';

  @override
  String get nUpAction => 'N-Up മൾട്ടി-പേജ് ലേഔട്ട്';

  @override
  String get nUpDescription =>
      'ഓരോ ഷീറ്റിലും 2, 4, 6, അല്ലെങ്കിൽ 9 പേജുകൾ വീതം ഉൾപ്പെടുത്തുക';

  @override
  String get nUpDialogTitle => 'N-Up മൾട്ടി-പേജ് ലേഔട്ട്';

  @override
  String get nUpGridLabel => 'ഗ്രിഡ് ലേഔട്ട്';

  @override
  String get nUpSheetSizeLabel => 'ഷീറ്റ് വലിപ്പം';

  @override
  String get nUpSheetA4 => 'A4';

  @override
  String get nUpSheetLetter => 'US Letter';

  @override
  String get nUpOrientationLabel => 'ഷീറ്റ് ഓറിയന്റേഷൻ';

  @override
  String get nUpOrientationAuto => 'ഓട്ടോ';

  @override
  String get nUpOrientationPortrait => 'പോർട്രെയ്റ്റ്';

  @override
  String get nUpOrientationLandscape => 'ലാൻഡ്‌സ്കേപ്പ്';

  @override
  String get nUpBordersLabel => 'പേജ് ബോർഡറുകൾ വരയ്ക്കുക';

  @override
  String get nUpBordersDescription =>
      'ഓരോ പേജ് സ്ലോട്ടിനും ചുറ്റും അതിർത്തി രേഖ വരയ്ക്കുന്നു';

  @override
  String get nUpMarginLabel => 'മാർജിൻ സ്പേസ്';

  @override
  String get nUpDoneTitle => 'N-Up PDF തയ്യാറായി';

  @override
  String get printNUpAction => 'N-Up മൾട്ടി-പേജ് പ്രിന്റ്';

  @override
  String get printNUpDescription =>
      'ഒരു ഷീറ്റിൽ ഒന്നിലധികം പേജുകൾ അച്ചടിക്കുക (2-in-1, 4-in-1, etc.)';

  @override
  String get cleanWebContentTitle => 'വെബ് കണ്ടന്റ് ക്ലീനർ (റീഡർ മോഡ്)';

  @override
  String get cleanWebContentSubtitle =>
      'സേവ് ചെയ്യുന്നതിന് മുമ്പ് ഹെഡറുകൾ, ഫൂട്ടറുകൾ, പരസ്യങ്ങൾ എന്നിവ നീക്കം ചെയ്യുന്നു';

  @override
  String pagesDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count പേജുകൾ നീക്കം ചെയ്തു',
      one: '1 പേജ് നീക്കം ചെയ്തു',
    );
    return '$_temp0';
  }

  @override
  String organizeSelectedCount(int count) {
    return '$count എണ്ണം തിരഞ്ഞെടുത്തു';
  }

  @override
  String get selectAllAction => 'എല്ലാം തിരഞ്ഞെടുക്കുക';

  @override
  String get deselectAllAction => 'തിരഞ്ഞെടുക്കൽ ഒഴിവാക്കുക';

  @override
  String get invertSelectionAction => 'തിരഞ്ഞെടുക്കൽ വിപരീതമാക്കുക';

  @override
  String get trustStoreExportAction => 'സർട്ടിഫിക്കറ്റ് എക്സ്പോർട്ട് ചെയ്യുക';

  @override
  String get trustStoreExportAllAction =>
      'എല്ലാ സർട്ടിഫിക്കറ്റുകളും എക്സ്പോർട്ട് ചെയ്യുക';

  @override
  String trustStoreExportSuccess(String name) {
    return 'സർട്ടിഫിക്കറ്റ് $name എന്നതിലേക്ക് എക്സ്പോർട്ട് ചെയ്തു';
  }

  @override
  String get signatureTrustSignerAction => 'സൈനറെ വിശ്വസിക്കുക';

  @override
  String get signatureUnnamed => 'ഡിജിറ്റൽ ഒപ്പ്';

  @override
  String get signatureTimeLabel => 'ഒപ്പിട്ട സമയം';

  @override
  String get signatureTimeClaimOnly => 'സ്ഥിരീകരിക്കാത്ത അവകാശവാദം';

  @override
  String get signatureIntegrityLabel => 'ഡോക്യുമെന്റ് കൃത്യത';

  @override
  String get signatureIntegrityValid =>
      'ഒപ്പിട്ടതിന് ശേഷം ഡോക്യുമെന്റിൽ മാറ്റം വരുത്തിയിട്ടില്ല';

  @override
  String get signatureIntegrityInvalid =>
      'ഒപ്പിട്ടതിന് ശേഷം ഡോക്യുമെന്റിൽ മാറ്റം വരുത്തിയിട്ടുണ്ട്';

  @override
  String get signatureIntegrityUnknown =>
      'ഡോക്യുമെന്റ് കൃത്യത പരിശോധിക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get signatureCoverageLabel => 'ബൈറ്റ് പരിധി';

  @override
  String get signatureCoversWholeFile =>
      'മുഴുവൻ ഡോക്യുമെന്റും ഒപ്പിൽ ഉൾപ്പെടുന്നു';

  @override
  String get signatureCoversPartialFile =>
      'ഡോക്യുമെന്റിന്റെ ഒരു ഭാഗം മാത്രമേ ഒപ്പിൽ ഉൾപ്പെടുന്നുള്ളൂ';

  @override
  String get signatureCertificateHeader => 'സൈനർ സർട്ടിഫിക്കറ്റ് വിവരങ്ങൾ';

  @override
  String get featuresTitle => 'ഫീച്ചറുകൾ';

  @override
  String get featuresSubtitle =>
      'SreerajP PDF ആപ്പിലെ എല്ലാ സവിശേഷതകളും അറിയുക';

  @override
  String get featuresHeaderTitle => 'SreerajP PDF ആപ്പ് ഫീച്ചറുകൾ';

  @override
  String get featuresHeaderSubtitle =>
      'നിങ്ങൾക്കായി രൂപകൽപ്പന ചെയ്ത എല്ലാ ടൂളുകളും, സുരക്ഷാ സംവിധാനങ്ങളും, ഫീച്ചറുകളും പരിശോധിക്കുക.';

  @override
  String get featuresCategoryViewing => 'PDF വായനയും നാവിഗേഷനും';

  @override
  String get featuresCategoryViewingSubtitle =>
      'വേഗതയേറിയ റെൻഡറിംഗ്, സ്ക്രോളിംഗ്, ബുക്ക് വ്യൂ, സ്മാർട്ട് നാവിഗേഷൻ';

  @override
  String get featuresCategorySearch => 'തിരച്ചിൽ, ഇൻഡിക് സ്വരസന്ധി & സ്പീച്ച്';

  @override
  String get featuresCategorySearchSubtitle =>
      'സന്ധി തിരിച്ചറിയുന്ന തിരച്ചിൽ, മലയാളം ടൈപ്പിംഗ്, ടെക്സ്റ്റ്-ടു-സ്പീച്ച്';

  @override
  String get featuresCategoryAnnotations => 'അടയാളപ്പെടുത്തലുകളും കുറിപ്പുകളും';

  @override
  String get featuresCategoryAnnotationsSubtitle =>
      'ഹൈലൈറ്റുകൾ, ഫ്രീഹാൻഡ് ചിത്രങ്ങൾ, സ്റ്റിക്കി നോട്ടുകൾ, എക്സ്പോർട്ട്';

  @override
  String get featuresCategoryPageOps => 'പേജ് ക്രമീകരണങ്ങളും മാറ്റങ്ങളും';

  @override
  String get featuresCategoryPageOpsSubtitle =>
      'പേജ് പുനഃക്രമീകരണം, ബുക്ക്‌ലെറ്റ്, വാട്ടർമാർക്ക്, ബാച്ച് ടൂളുകൾ';

  @override
  String get featuresCategoryExtraction => 'ഡാറ്റ വേർതിരിച്ചെടുക്കലും ടൂളുകളും';

  @override
  String get featuresCategoryExtractionSubtitle =>
      'ടെക്സ്റ്റ്, ചിത്രങ്ങൾ, ഫോം ഫീൽഡുകൾ, മെറ്റാഡാറ്റ എന്നിവ വേർതിരിക്കൽ';

  @override
  String get featuresCategoryPrinter => 'വെർച്വൽ പ്രിന്ററും ഷെയറിംഗും';

  @override
  String get featuresCategoryPrinterSubtitle =>
      'സിസ്റ്റം പ്രിന്റർ, വെബ് ക്ലീനർ, ഇമേജ്/ടെക്സ്റ്റ് PDF ആക്കൽ';

  @override
  String get featuresCategorySignatures =>
      'ഡിജിറ്റൽ ഒപ്പുകളും ട്രസ്റ്റ് സ്റ്റോറും';

  @override
  String get featuresCategorySignaturesSubtitle =>
      'ഓഫ്‌ലൈൻ ഒപ്പ് പരിശോധന, വിഷ്വൽ ബാഡ്ജുകൾ, സർട്ടിഫിക്കറ്റ് മാനേജർ';

  @override
  String get featuresCategoryThemes => 'തീമുകളും ക്രമീകരണങ്ങളും';

  @override
  String get featuresCategoryThemesSubtitle =>
      'OLED ഡാർക്ക് മോഡ്, ഫോണ്ടുകൾ, ആക്സന്റ് കളർ, വിശദമായ സെറ്റിംഗ്സ്';

  @override
  String get featuresCategoryGuides => 'ഉപയോക്തൃ സഹായ ഗൈഡുകൾ';

  @override
  String get featuresCategoryGuidesSubtitle =>
      'വിശദമായ ഓഫ്‌ലൈൻ ട്യൂട്ടോറിയലുകളും നിർദ്ദേശങ്ങളും';

  @override
  String get helpHeaderTitle => 'സഹായ കേന്ദ്രവും വഴികാട്ടിയും';

  @override
  String get helpHeaderSubtitle =>
      'SreerajP PDF ആപ്പിന്റെ എല്ലാ സവിശേഷതകളെയും കുറിച്ചുള്ള സമഗ്രമായ ഗൈഡുകൾ.';

  @override
  String get helpSectionPrinting => 'പ്രിന്റിംഗും പരിവർത്തനവും';

  @override
  String get helpSectionReading => 'വായനയും ശബ്ദവും';

  @override
  String get helpSectionPageOps => 'ഡോക്യുമെന്റ് പ്രവർത്തനങ്ങൾ';

  @override
  String get helpSectionSecurity => 'സുരക്ഷയും സ്വകാര്യതയും';
}
