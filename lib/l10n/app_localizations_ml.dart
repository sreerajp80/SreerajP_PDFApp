// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get titleApp => 'ഗ്രന്ഥം';

  @override
  String get titleHome => 'ഗ്രന്ഥം';

  @override
  String get bodyHomeEmpty =>
      'ഇതുവരെ പി.ഡി.എഫ്. ഒന്നും തുറന്നിട്ടില്ല. ഫയലുകൾ തുറക്കൽ അടുത്ത ഘട്ടത്തിൽ വരും.';

  @override
  String get titleSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get labelSettingsTheme => 'തീം';

  @override
  String get labelThemeSystem => 'സിസ്റ്റം';

  @override
  String get labelThemeLight => 'വെളിച്ചം';

  @override
  String get labelThemeDark => 'ഇരുട്ട്';

  @override
  String get labelThemeSepia => 'സെപിയ';

  @override
  String get labelThemeOled => 'ഒലെഡ് പിച്ച്-ബ്ലാക്ക്';

  @override
  String get titleAbout => 'കുറിച്ച്';

  @override
  String get labelOpenSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get labelOpenAbout => 'കുറിച്ച്';

  @override
  String get labelOpenPdf => 'പി.ഡി.എഫ്. തുറക്കുക';

  @override
  String get titleRecentFiles => 'സമീപകാല ഫയലുകൾ';

  @override
  String get emptyRecentFiles =>
      'ഇതുവരെ സമീപകാല ഫയലുകൾ ഇല്ല. വായിക്കാൻ \"പി.ഡി.എഫ്. തുറക്കുക\" അമർത്തുക.';

  @override
  String get labelRemoveFromRecents => 'നീക്കം ചെയ്യുക';

  @override
  String get errorOpenFailed => 'ഫയൽ തുറക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get errorReopenFailed =>
      'ഈ ഫയൽ വീണ്ടും തുറക്കാൻ കഴിഞ്ഞില്ല. ഇത് തുറക്കാനുള്ള അനുമതി ആപ്പിന് ഇല്ലാതായിരിക്കാം, അല്ലെങ്കിൽ ഫയൽ മാറ്റുകയോ ഇല്ലാതാക്കുകയോ ചെയ്തിരിക്കാം.';

  @override
  String get titleReopenFailed => 'ഈ ഫയൽ വീണ്ടും തുറക്കാനാവില്ല';

  @override
  String get helpReopenFailed =>
      'മറ്റൊരു ആപ്പ് വഴി തുറന്ന ഫയലുകൾ (\"Open with\" വഴിയോ, ഫയൽ പിക്കറിൽ മറ്റൊരു ആപ്പ് തിരഞ്ഞെടുത്തോ) ഈ ആപ്പ് അടയ്ക്കുന്നതുവരെ മാത്രമേ വീണ്ടും തുറക്കാനാകൂ. ലിസ്റ്റിൽ നിലനിർത്താൻ, ഫയൽ പിക്കറിന്റെ സ്വന്തം ഫോൾഡറുകളിൽ നിന്ന് ഫയൽ ഒരിക്കൽ കൂടി തിരഞ്ഞെടുക്കുക.';

  @override
  String get labelFindFileAgain => 'ഫയൽ കണ്ടെത്തുക';

  @override
  String descPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count താളുകൾ',
      one: '1 താൾ',
    );
    return '$_temp0';
  }

  @override
  String get labelViewModeContinuous => 'തുടർച്ചയായി';

  @override
  String get labelViewModeSingle => 'ഒറ്റ താൾ';

  @override
  String get labelViewModeBook => 'രണ്ട് പേജുകൾ';

  @override
  String get tooltipViewMode => 'കാഴ്ച രീതി';

  @override
  String get labelFitWidth => 'വീതിക്ക് ഒപ്പിക്കുക';

  @override
  String get labelFitPage => 'പേജിന് ഒപ്പിക്കുക';

  @override
  String get labelPageFit => 'താൾ ക്രമീകരണം';

  @override
  String get labelZoomIn => 'വലുതാക്കുക';

  @override
  String get labelZoomOut => 'ചെറുതാക്കുക';

  @override
  String get labelResetZoom => 'സൂം പുനഃക്രമീകരിക്കുക';

  @override
  String get labelInvertColors => 'രാത്രി നിറങ്ങൾ';

  @override
  String get titleContents => 'ഉള്ളടക്കം';

  @override
  String get emptyOutline => 'ഈ പി.ഡി.എഫിന് ഉള്ളടക്കപ്പട്ടിക ഇല്ല.';

  @override
  String get titleThumbnails => 'പേജുകൾ';

  @override
  String get labelGoToPage => 'പേജിലേക്ക് പോകുക';

  @override
  String descPageOfPages(int current, int total) {
    return 'താൾ $current / $total';
  }

  @override
  String get labelPageNumberHint => 'താൾ സംഖ്യ';

  @override
  String get actionGo => 'പോകുക';

  @override
  String get actionCancel => 'റദ്ദാക്കുക';

  @override
  String get titlePassword => 'പാസ്‌വേഡ് ആവശ്യമാണ്';

  @override
  String get bodyPassword =>
      'ഈ പി.ഡി.എഫ്. സംരക്ഷിതമാണ്. വായിക്കാൻ പാസ്‌വേഡ് നൽകുക.';

  @override
  String get labelPasswordHint => 'പാസ്‌വേഡ്';

  @override
  String get actionUnlock => 'തുറക്കുക';

  @override
  String get actionTryAgain => 'വീണ്ടും ശ്രമിക്കുക';

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
  String get descLargeFileWarning =>
      'ഇത് വലിയ പി.ഡി.എഫ്. ആണ്, അതിനാൽ സുഗമമായ വായനയ്ക്കായി ഒരു താൾ വീതം തുറക്കുന്നു.';

  @override
  String get labelLoadingPdf => 'തുറക്കുന്നു…';

  @override
  String get labelYes => 'അതെ';

  @override
  String get titleMetadata => 'വിവരങ്ങൾ';

  @override
  String get actionMetadata => 'വിവരങ്ങൾ';

  @override
  String get labelMetadataFileSection => 'ഫയൽ';

  @override
  String get labelMetadataFileName => 'പേര്';

  @override
  String get labelMetadataFileSize => 'വലുപ്പം';

  @override
  String get labelMetadataPdfSection => 'പി.ഡി.എഫ്. വിവരങ്ങൾ';

  @override
  String get errorMetadataUnavailable => 'ഈ വിവരങ്ങൾ വായിക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get descMetadataNoFields => 'ഈ പി.ഡി.എഫ്. സ്വയം വിവരണം നൽകുന്നില്ല.';

  @override
  String get labelMetadataTitleField => 'തലക്കെട്ട്';

  @override
  String get labelMetadataAuthor => 'രചയിതാവ്';

  @override
  String get labelMetadataSubject => 'വിഷയം';

  @override
  String get labelMetadataKeywords => 'മുഖ്യവാക്കുകൾ';

  @override
  String get labelMetadataCreator => 'ഉണ്ടാക്കിയത്';

  @override
  String get labelMetadataProducer => 'നിർമ്മിച്ച പ്രോഗ്രാം';

  @override
  String get labelMetadataCreated => 'ഉണ്ടാക്കിയ തീയതി';

  @override
  String get labelMetadataModified => 'മാറ്റിയ തീയതി';

  @override
  String get labelMetadataPages => 'പേജുകൾ';

  @override
  String get labelMetadataPdfVersion => 'പി.ഡി.എഫ്. പതിപ്പ്';

  @override
  String get labelMetadataProtected => 'പാസ്‌വേഡ് സംരക്ഷിതം';

  @override
  String get actionSearch => 'തിരയുക';

  @override
  String get labelSearchHint => 'ഈ പി.ഡി.എഫ്. ഇൽ തിരയുക';

  @override
  String get labelSearchClose => 'തിരയൽ അടയ്ക്കുക';

  @override
  String get labelSearchClear => 'മായ്ക്കുക';

  @override
  String get labelSearchNextMatch => 'അടുത്ത ഫലം';

  @override
  String get labelSearchPreviousMatch => 'മുൻ ഫലം';

  @override
  String get labelSearchSearching => 'തിരയുന്നു…';

  @override
  String get labelSearchNoMatches => 'ഫലങ്ങൾ ഒന്നുമില്ല';

  @override
  String labelSearchMatchOf(int current, int total) {
    return '$total ൽ $current';
  }

  @override
  String descSearchLimitReached(int count) {
    return 'ആദ്യത്തെ $count ഫലങ്ങൾ കാണിക്കുന്നു. നീളമുള്ള വാക്ക് പരീക്ഷിക്കുക.';
  }

  @override
  String get tooltipSearchOptions => 'തിരയൽ ക്രമീകരണങ്ങൾ';

  @override
  String get labelSearchOptionStrict => 'കൃത്യമായ അക്ഷരവിന്യാസം';

  @override
  String get descSearchOptionStrictNote =>
      'കൂട്ടിച്ചേർത്തതും അല്ലാത്തതുമായ രൂപങ്ങൾ വേർതിരിക്കുക';

  @override
  String get labelSearchOptionIgnoreAccents => 'സ്വരചിഹ്നങ്ങൾ അവഗണിക്കുക';

  @override
  String get descSearchOptionIgnoreAccentsNote =>
      'സംസ്കൃത സ്വരചിഹ്നങ്ങൾക്ക് ഉപകാരപ്രദം';

  @override
  String get descSearchOptionSandhi => 'സന്ധി തിരയൽ';

  @override
  String get descSearchOptionSandhiNote =>
      'കൂടിച്ചേർന്നതും പിരിച്ചെഴുതിയതുമായ പദങ്ങൾ കണ്ടെത്തുക';

  @override
  String get labelSearchOptionPhonetic => 'ഉച്ചാരണ സാമ്യ തിരയൽ';

  @override
  String get descSearchOptionPhoneticNote =>
      'അനുസ്വാര-വർഗ്ഗാക്ഷരങ്ങളും ചില്ലക്ഷര വ്യത്യാസങ്ങളും ഉൾപ്പെടുത്തുക';

  @override
  String get titleNoText => 'തിരഞ്ഞെടുക്കാവുന്ന എഴുത്ത് ഇല്ല';

  @override
  String get bodyNoText =>
      'ഈ പി.ഡി.എഫ്. ഇൽ എഴുത്ത് പാളി ഇല്ല, അതിനാൽ ഇത് സ്കാൻ ചെയ്തതാണെന്ന് തോന്നുന്നു. തിരയൽ, പകർത്തൽ, ഉറക്കെ വായിക്കൽ എന്നിവ ലഭ്യമല്ല. ഈ ആപ്പ് ചിത്രങ്ങളിൽ നിന്ന് എഴുത്ത് വായിക്കില്ല.';

  @override
  String get titleGarbledText => 'എഴുത്ത് ശരിയായി വായിക്കാൻ കഴിയുന്നില്ല';

  @override
  String get bodyGarbledText =>
      'ഈ പി.ഡി.എഫ്. ഇലെ ഫോണ്ടുകൾ ഏത് അക്ഷരമാണ് കാണിക്കുന്നതെന്ന് പറയുന്നില്ല, അതിനാൽ തിരയലും ഉറക്കെ വായിക്കലും തെറ്റായ ഫലം നൽകും. പേജുകൾ വായിക്കുന്നത് പ്രവർത്തിക്കും.';

  @override
  String get descSearchUnavailableNoText =>
      'തിരയലിന് തിരഞ്ഞെടുക്കാവുന്ന എഴുത്ത് വേണം, ഈ പി.ഡി.എഫ്. ഇൽ അതില്ല.';

  @override
  String get descSearchUnavailableGarbled =>
      'ഈ പി.ഡി.എഫ്. ഇലെ എഴുത്ത് ശരിയായി വായിക്കാൻ കഴിയാത്തതിനാൽ തിരയൽ ഓഫാണ്.';

  @override
  String get titleUnreliableText => 'എഴുത്ത് തെറ്റാകാം';

  @override
  String get bodyUnreliableText =>
      'ഈ പി.ഡി.എഫ്. ഇലെ എഴുത്ത് ശരിയായ യൂണിക്കോഡിൽ ആയിരിക്കില്ല. തിരയുമ്പോൾ ചില വാക്കുകൾ കിട്ടാതെ പോകുകയോ ഉറക്കെ വായിക്കുമ്പോൾ തെറ്റായി വായിക്കുകയോ ചെയ്യാം. പേജുകൾ വായിക്കുന്നത് പ്രവർത്തിക്കും.';

  @override
  String get descSearchUnreliable =>
      'ഈ പി.ഡി.എഫ്. ഇലെ എഴുത്ത് ശരിയായ യൂണിക്കോഡിൽ ആയിരിക്കില്ല; ചില ഫലങ്ങൾ കിട്ടാതെ പോകുകയോ തെറ്റുകയോ ചെയ്യാം.';

  @override
  String get actionDismiss => 'ശരി';

  @override
  String get labelTtsReadAloud => 'ഉറക്കെ വായിക്കുക';

  @override
  String get labelTtsPause => 'താൽക്കാലികമായി നിർത്തുക';

  @override
  String get labelTtsStop => 'നിർത്തുക';

  @override
  String get tooltipTtsSpeed => 'വായനാ വേഗം';

  @override
  String labelTtsSpeedValue(String rate) {
    return '$rate×';
  }

  @override
  String get descTtsUnavailableNoText =>
      'ഉറക്കെ വായിക്കാൻ തിരഞ്ഞെടുക്കാവുന്ന എഴുത്ത് വേണം, ഈ പി.ഡി.എഫ്. ഇൽ അതില്ല.';

  @override
  String get descTtsUnavailableGarbled =>
      'ഈ പി.ഡി.എഫ്. ഇലെ എഴുത്ത് ശരിയായി വായിക്കാൻ കഴിയാത്തതിനാൽ ഉറക്കെ വായിക്കൽ ഓഫാണ്.';

  @override
  String get descTtsUnavailableNoVoice =>
      'ഈ ഉപകരണത്തിൽ സംസാര ശബ്ദം ഒന്നും ഇൻസ്റ്റാൾ ചെയ്തിട്ടില്ല.';

  @override
  String get descTtsNothingToRead => 'ഈ പേജിൽ വായിക്കാൻ ഒന്നുമില്ല.';

  @override
  String get descTtsMalayalamVoiceOff =>
      'ഈ പേജ് മലയാളത്തിലാണ്. ക്രമീകരണങ്ങൾ › ഉറക്കെ വായിക്കുക എന്നതിൽ മലയാളം ശബ്ദം ഓണാക്കുക.';

  @override
  String get descTtsMalayalamVoiceMissing =>
      'ഈ പേജ് മലയാളത്തിലാണ്, പക്ഷേ മലയാളം ശബ്ദം ഇൻസ്റ്റാൾ ചെയ്തിട്ടില്ല.';

  @override
  String get descTtsNoSanskritVoice =>
      'ഈ പേജ് സംസ്കൃതത്തിലാണ്. സംസ്കൃത ശബ്ദം ഇല്ലാത്തതിനാൽ ഇത് ഉറക്കെ വായിക്കാൻ കഴിയില്ല.';

  @override
  String get actionTtsOpenSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get labelSettingsReadAloud => 'ഉറക്കെ വായിക്കൽ';

  @override
  String get labelSettingsMalayalamVoice => 'മലയാളം ശബ്ദം';

  @override
  String get descSettingsMalayalamVoiceReady =>
      'തയ്യാർ. മലയാളം എഴുത്ത് മലയാളത്തിൽ വായിക്കും.';

  @override
  String get descSettingsMalayalamVoiceOff =>
      'മലയാളം എഴുത്ത് ഇംഗ്ലീഷ് ശബ്ദത്തിൽ വായിക്കും.';

  @override
  String get descSettingsMalayalamVoiceNeedsInstall =>
      'മലയാളം ശബ്ദം ഇതുവരെ ഡൗൺലോഡ് ചെയ്തിട്ടില്ല.';

  @override
  String get errorSettingsMalayalamVoiceUnavailable =>
      'ഈ ഉപകരണത്തിലെ സംസാര എൻജിൻ മലയാളം നൽകുന്നില്ല.';

  @override
  String get labelSettingsMalayalamVoiceChecking => 'പരിശോധിക്കുന്നു…';

  @override
  String get titleTtsInstall => 'മലയാളം ശബ്ദം നേടുക';

  @override
  String get bodyTtsInstall =>
      'ഈ ഫോണിൽ മലയാളം ശബ്ദം ഇതുവരെ ഇല്ല. ഇവയിൽ ഒന്ന് പരീക്ഷിക്കുക:';

  @override
  String get labelTtsInstallVoiceData => 'ശബ്ദ ഡാറ്റ ഡൗൺലോഡ് ചെയ്യുക';

  @override
  String get labelTtsOpenTtsSettings => 'സംസാര ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get descTtsOpenPlayStore => 'ഗൂഗിൾ സ്പീച്ച് സേവനങ്ങൾ നേടുക';

  @override
  String get descTtsInstallDoneNote =>
      'ഇൻസ്റ്റാൾ ചെയ്ത ശേഷം ഇവിടെ മടങ്ങിവരുക — ശബ്ദം തയ്യാറാകുമ്പോൾ ക്രമീകരണം സ്വയം ഓണാകും.';

  @override
  String get descTtsInstallCannotOpen =>
      'ആ സ്ക്രീൻ തുറക്കാൻ ഈ ഫോണിന് കഴിഞ്ഞില്ല.';

  @override
  String get descTtsVoiceLostNotice =>
      'മലയാളം ശബ്ദം ഇനി ഇൻസ്റ്റാൾ ചെയ്തിട്ടില്ല, അതിനാൽ ക്രമീകരണം ഓഫാക്കി.';

  @override
  String get labelExtractAndConvert => 'എക്‌സ്‌ട്രാക്റ്റും കൺവേർട്ടും';

  @override
  String get actionExtractText => 'എഴുത്ത് വേർതിരിക്കുക';

  @override
  String get actionExtractImages => 'ചിത്രങ്ങൾ വേർതിരിക്കുക';

  @override
  String get actionConvertPdf => 'ചിത്രങ്ങളാക്കി മാറ്റുക';

  @override
  String get actionFormFields => 'ഫോം ഫീൽഡുകൾ';

  @override
  String get descExtractionSuccess => 'വേർതിരിക്കൽ വിജയിച്ചു';

  @override
  String get errorExtractionFailed => 'വേർതിരിക്കൽ പരാജയപ്പെട്ടു';

  @override
  String get labelExtractingProgress => 'വേർതിരിക്കുന്നു…';

  @override
  String get labelRangeAll => 'എല്ലാ പേജുകളും';

  @override
  String descRangeCurrent(int page) {
    return 'ഈ താൾ മാത്രം (താൾ $page)';
  }

  @override
  String get labelRangeCustom => 'നിശ്ചിത പേജുകൾ';

  @override
  String get labelStartPage => 'ആരംഭ താൾ';

  @override
  String get labelEndPage => 'അവസാന താൾ';

  @override
  String get labelInvalidPageRange => 'തെറ്റായ താൾ പരിധി';

  @override
  String get labelImageFormat => 'ചിത്രത്തിന്റെ ഫോർമാറ്റ്';

  @override
  String descResolution(int dpi) {
    return 'റെസലൂഷൻ: $dpi DPI';
  }

  @override
  String get labelFieldsNameHeader => 'ഫീൽഡിന്റെ പേര്';

  @override
  String get labelFieldsValueHeader => 'മൂല്യം';

  @override
  String get emptyFormFieldsFound =>
      'ഈ പി.ഡി.എഫ്.-ൽ ഫോം ഫീൽഡുകൾ ഒന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get emptyImagesFound => 'ഈ പേജുകളിൽ ചിത്രങ്ങൾ ഒന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get actionShare => 'പങ്കുവെക്കുക';

  @override
  String get actionShareFile => 'ഫയലായി പങ്കുവെക്കുക';

  @override
  String get actionCopyClipboard => 'പകർപ്പെടുക്കുക';

  @override
  String get labelCopySuccess => 'പകർപ്പ് എടുത്തു കഴിഞ്ഞു';

  @override
  String get titlePreviewText => 'എഴുത്തിന്റെ പ്രിവ്യൂ';

  @override
  String get titleFormFields => 'ഫോം ഫീൽഡുകൾ കാണുക';

  @override
  String get titlePageTools => 'താൾ ഉപകരണങ്ങൾ';

  @override
  String get actionMerge => 'PDF-കൾ ഒന്നാക്കുക';

  @override
  String get descMerge =>
      'ഈ PDF മറ്റുള്ളവയുമായി ചേർത്ത് ഒരു പുതിയ ഫയൽ ഉണ്ടാക്കുക';

  @override
  String get titleMergeDone => 'PDF-കൾ ചേർത്തു';

  @override
  String get actionSplit => 'പേജുകളായി വേർതിരിക്കുക';

  @override
  String get descSplit => 'ഓരോ പേജിനും ഒരു പുതിയ ഫയൽ ഉണ്ടാക്കുക';

  @override
  String get titleSplitDone => 'PDF വേർതിരിച്ചു';

  @override
  String get actionOrganize => 'പേജുകൾ ക്രമീകരിക്കുക';

  @override
  String get descOrganize =>
      'പേജുകൾ വീണ്ടും ക്രമീകരിക്കുക, തിരിക്കുക അല്ലെങ്കിൽ നീക്കം ചെയ്യുക';

  @override
  String get titleOrganize => 'പേജുകൾ ക്രമീകരിക്കുക';

  @override
  String get helpOrganize =>
      'വീണ്ടും ക്രമീകരിക്കാൻ വലിച്ചിടുക. തിരിക്കാനോ നീക്കാനോ ബട്ടണുകൾ ഉപയോഗിക്കുക. സൂക്ഷിക്കുമ്പോൾ പുതിയ ഫയൽ ഉണ്ടാകും.';

  @override
  String get titleOrganizeDone => 'പേജുകൾ ക്രമീകരിച്ചു';

  @override
  String get actionCompress => 'ചെറുതാക്കുക';

  @override
  String get descCompress => 'ചെറിയ ഒരു പകർപ്പ് ഉണ്ടാക്കുക (കഴിയുന്നത്ര)';

  @override
  String get titleCompressDone => 'PDF ചെറുതാക്കി';

  @override
  String get descCompressBestEffortNote =>
      'ചെറുതാക്കൽ കഴിയുന്നത്ര മാത്രമാണ്. നേരത്തെ ഒപ്റ്റിമൈസ് ചെയ്ത ഫയലുകൾ അധികം ചെറുതാകില്ല.';

  @override
  String get actionProtect => 'പാസ്‌വേഡ് ഇടുക';

  @override
  String get descProtect => 'പുതിയ പകർപ്പിന് ഒരു പാസ്‌വേഡ് ചേർക്കുക';

  @override
  String get titleProtect => 'PDF-ന് പാസ്‌വേഡ് ഇടുക';

  @override
  String get titleProtectDone => 'PDF-ന് പാസ്‌വേഡ് ഇട്ടു';

  @override
  String get actionRemovePassword => 'പാസ്‌വേഡ് നീക്കുക';

  @override
  String get descUnlock =>
      'പാസ്‌വേഡ് ഇല്ലാത്ത പകർപ്പ് ഉണ്ടാക്കുക (ഇപ്പോഴത്തെ പാസ്‌വേഡ് വേണം)';

  @override
  String get titleUnlock => 'പാസ്‌വേഡ് നീക്കുക';

  @override
  String get titleUnlockDone => 'പാസ്‌വേഡ് നീക്കി';

  @override
  String get labelUserPassword => 'പാസ്‌വേഡ് (ഫയൽ തുറക്കാൻ)';

  @override
  String get labelOwnerPassword => 'ഉടമ പാസ്‌വേഡ് (നിർബന്ധമല്ല)';

  @override
  String get helpOwnerPassword =>
      'പ്രിന്റും എഡിറ്റും നിയന്ത്രിക്കുന്നു. ഒഴിച്ചിട്ടാൽ തുറക്കൽ പാസ്‌വേഡ് തന്നെ ഉപയോഗിക്കും.';

  @override
  String get labelCurrentPassword => 'ഇപ്പോഴത്തെ പാസ്‌വേഡ്';

  @override
  String get errorPasswordRequired => 'ദയവായി ഒരു പാസ്‌വേഡ് നൽകുക.';

  @override
  String get labelWorkingProgress => 'ചെയ്യുന്നു…';

  @override
  String get errorOpFailed => 'പ്രവർത്തനം പരാജയപ്പെട്ടു';

  @override
  String get actionSave => 'സൂക്ഷിക്കുക';

  @override
  String get errorSaveFailed => 'ഫയൽ സൂക്ഷിക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String bodySavedFile(String name) {
    return '$name സൂക്ഷിച്ചു';
  }

  @override
  String labelResultOneFile(String name) {
    return 'പുതിയ ഫയൽ: $name';
  }

  @override
  String descResultManyFiles(int count) {
    return '$count പുതിയ ഫയലുകൾ ഉണ്ടാക്കി.';
  }

  @override
  String labelPage(int page) {
    return 'താൾ $page';
  }

  @override
  String labelRotatedBy(int degrees) {
    return '$degrees° തിരിച്ചു';
  }

  @override
  String bodyPageDeleted(int page) {
    return 'താൾ $page നീക്കി';
  }

  @override
  String get actionUndo => 'പഴയപടിയാക്കുക';

  @override
  String get actionRotate => 'തിരിക്കുക';

  @override
  String get actionDeletePage => 'താൾ നീക്കുക';

  @override
  String get errorNoPagesLeft => 'കുറഞ്ഞത് ഒരു പേജെങ്കിലും വേണം.';

  @override
  String get actionAnnotate => 'അടയാളപ്പെടുത്തുക';

  @override
  String get labelAnnotationHighlight => 'ഹൈലൈറ്റ്';

  @override
  String get labelAnnotationUnderline => 'അടിവര';

  @override
  String get labelAnnotationStrikethrough => 'വെട്ടിവര';

  @override
  String get labelAnnotationInk => 'വരയ്ക്കുക';

  @override
  String get descAnnotationNote => 'കുറിപ്പ്';

  @override
  String get labelAnnotationEraser => 'മായ്ക്കുക';

  @override
  String get labelAnnotationClearAll => 'എല്ലാ അടയാളങ്ങളും മായ്ക്കുക';

  @override
  String get descAnnotationExport => 'അടയാളങ്ങളോടെ പകർപ്പ് കയറ്റുമതി ചെയ്യുക';

  @override
  String get descAnnotationOverlayNotice =>
      'ഈ അടയാളങ്ങൾ ഈ ആപ്പിനുള്ളിൽ മാത്രമേ സൂക്ഷിക്കൂ. PDF-ൽ നിലനിർത്താൻ അടയാളങ്ങളോടെ ഒരു പകർപ്പ് കയറ്റുമതി ചെയ്യുക.';

  @override
  String get errorAnnotationTextMarkupUnavailable =>
      'ഈ PDF-ൽ അടയാളപ്പെടുത്താൻ തിരഞ്ഞെടുക്കാവുന്ന വാചകം ഇല്ല.';

  @override
  String get descAnnotationExporting => 'അടയാളങ്ങളോടെ പകർപ്പ് ഉണ്ടാക്കുന്നു…';

  @override
  String get errorAnnotationExportFailed =>
      'അടയാളങ്ങളോടെ പകർപ്പ് ഉണ്ടാക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get descAnnotationNothingToExport => 'ആദ്യം ഒരു അടയാളം ചേർക്കുക.';

  @override
  String get titleAnnotationClearAll => 'എല്ലാ അടയാളങ്ങളും മായ്ക്കണോ?';

  @override
  String get bodyAnnotationClearAll =>
      'ഇത് ഈ ഫയലിലെ എല്ലാ അടയാളങ്ങളും നീക്കും. ഇത് പഴയപടിയാക്കാൻ കഴിയില്ല.';

  @override
  String get titleNote => 'കുറിപ്പ്';

  @override
  String get labelNoteHint => 'നിങ്ങളുടെ കുറിപ്പ് എഴുതുക';

  @override
  String get actionDelete => 'നീക്കുക';

  @override
  String get titleBookmarks => 'ബുക്ക്‌മാർക്കുകൾ';

  @override
  String get actionBookmarks => 'ബുക്ക്‌മാർക്കുകൾ';

  @override
  String get emptyBookmarks => 'ബുക്ക്‌മാർക്കുകൾ ഇല്ല.';

  @override
  String labelBookmarkAddCurrent(int page) {
    return 'താൾ $page ബുക്ക്‌മാർക്ക് ചെയ്യുക';
  }

  @override
  String descBookmarkRemoveCurrent(int page) {
    return 'താൾ $page-ലെ ബുക്ക്‌മാർക്ക് നീക്കുക';
  }

  @override
  String labelBookmarkPage(int page) {
    return 'താൾ $page';
  }

  @override
  String get errorShareFailed => 'ഈ ഫയൽ പങ്കിടാൻ കഴിഞ്ഞില്ല.';

  @override
  String get titleImport => 'PDF ആയി സൂക്ഷിക്കുക';

  @override
  String get labelImportBuilding => 'നിങ്ങളുടെ PDF ഉണ്ടാക്കുന്നു…';

  @override
  String get titleImportReady => 'നിങ്ങളുടെ PDF തയ്യാറാണ്';

  @override
  String descImportImagesSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ചിത്രങ്ങളിൽ നിന്ന് ഉണ്ടാക്കി',
      one: '1 ചിത്രത്തിൽ നിന്ന് ഉണ്ടാക്കി',
    );
    return '$_temp0';
  }

  @override
  String get descImportTextSummary =>
      'നിങ്ങൾ പങ്കിട്ട എഴുത്തിൽ നിന്ന് ഉണ്ടാക്കി.';

  @override
  String labelImportSize(String size) {
    return 'വലുപ്പം: $size';
  }

  @override
  String get actionImportSave => 'PDF ആയി സൂക്ഷിക്കുക';

  @override
  String get actionImportShare => 'പങ്കിടുക';

  @override
  String labelImportSaved(String name) {
    return '$name സൂക്ഷിച്ചു';
  }

  @override
  String get titleImportFailed => 'PDF ഉണ്ടാക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get titleImportUnsupportedText => 'പിന്തുണയില്ലാത്ത അക്ഷരങ്ങൾ';

  @override
  String get descImportUnsupportedTextDetail =>
      'ഈ ആപ്പിന് ഇംഗ്ലീഷ് അക്ഷരങ്ങളും അക്കങ്ങളും മാത്രമേ PDF-ൽ എഴുതാൻ കഴിയൂ. മലയാളവും മറ്റു ലിപികളും ഇപ്പോൾ പിന്തുണയ്ക്കുന്നില്ല. എഴുത്തിന്റെ ഒരു ചിത്രം സൂക്ഷിക്കാൻ കുഴപ്പമില്ല.';

  @override
  String get actionPrint => 'അച്ചടിക്കുക';

  @override
  String get titlePrint => 'അച്ചടി';

  @override
  String get actionPrintWhole => 'മുഴുവൻ ഡോക്യുമെന്റ്';

  @override
  String get descPrintWhole => 'ഈ PDF-ന്റെ എല്ലാ താളുകളും അച്ചടിക്കുക.';

  @override
  String get actionPrintRange => 'താൾ പരിധി';

  @override
  String get descPrintRange => 'ഏതു താളുകൾ അച്ചടിക്കണമെന്ന് തിരഞ്ഞെടുക്കുക.';

  @override
  String get actionPrintText => 'എഴുത്ത് മാത്രം';

  @override
  String get descPrintText => 'ഈ PDF-ലെ വാക്കുകൾ സാധാരണ താളുകളായി അച്ചടിക്കുക.';

  @override
  String get titlePrintRange => 'അച്ചടിക്കേണ്ട താളുകൾ';

  @override
  String get labelPrintFrom => 'ഈ താൾ മുതൽ';

  @override
  String get labelPrintTo => 'ഈ താൾ വരെ';

  @override
  String descPrintRangeInvalid(int pageCount) {
    return '1 മുതൽ $pageCount വരെയുള്ള താൾ പരിധി നൽകുക.';
  }

  @override
  String get descPrintPreparing => 'പേജുകൾ തയ്യാറാക്കുന്നു…';

  @override
  String get errorPrintUnavailable => 'ഈ ഉപകരണത്തിന് അച്ചടിക്കാൻ കഴിയില്ല.';

  @override
  String get errorPrintFailed => 'അച്ചടി തുടങ്ങാൻ കഴിഞ്ഞില്ല.';

  @override
  String get descPrintNoText => 'ഈ PDF-ൽ അച്ചടിക്കാൻ എഴുത്തില്ല.';

  @override
  String get actionSignatures => 'ഒപ്പുകൾ';

  @override
  String get titleSignatures => 'ഒപ്പുകൾ';

  @override
  String get labelSignaturesChecking => 'ഒപ്പുകൾ പരിശോധിക്കുന്നു…';

  @override
  String get descSignaturesNone => 'ഈ PDF-ൽ ഒപ്പില്ല.';

  @override
  String get errorSignaturesFailed => 'ഈ ഒപ്പുകൾ പരിശോധിക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get descSignaturesFailedDetail =>
      'ഒപ്പുകൾ മോശമാണെന്ന് ഇതിനർത്ഥമില്ല. ആപ്പിന് അവ വായിക്കാൻ കഴിഞ്ഞില്ല, അതിനാൽ ഒന്നും പറയുന്നില്ല.';

  @override
  String get labelSignatureStatusTrusted => 'ഒപ്പിട്ടത്, വിശ്വസിക്കാം';

  @override
  String get descSignatureStatusTrustedDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം ഈ രേഖ മാറിയിട്ടില്ല. ഒപ്പിട്ടയാളുടെ സർട്ടിഫിക്കറ്റ് നിങ്ങൾ വിശ്വസിക്കുന്നു.';

  @override
  String get descSignatureStatusValidNotTrusted =>
      'ഒപ്പിട്ടത്, പക്ഷേ ഒപ്പിട്ടയാളെ അറിയില്ല';

  @override
  String get descSignatureStatusValidNotTrustedDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം ഈ രേഖ മാറിയിട്ടില്ല. പക്ഷേ ഒപ്പിട്ടയാൾ ആരാണെന്ന് ആപ്പിന് അറിയില്ല.';

  @override
  String get descSignatureStatusInvalid => 'ഒപ്പ് ശരിയല്ല';

  @override
  String get descSignatureStatusInvalidDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം രേഖ മാറി, അല്ലെങ്കിൽ ഒപ്പ് ചേരുന്നില്ല. ഇതിനെ ആശ്രയിക്കരുത്.';

  @override
  String get descSignatureStatusUnknown => 'ഒപ്പ് വായിക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get descSignatureStatusUnknownDetail =>
      'ഈ ഒപ്പ് ആപ്പിന് മനസ്സിലായില്ല, അതിനാൽ അത് നല്ലതോ ചീത്തയോ എന്ന് പറയുന്നില്ല.';

  @override
  String get descSignatureNotePartialCoverage =>
      'ഫയലിന്റെ ഒരു ഭാഗം മാത്രം ഉൾക്കൊള്ളുന്നു';

  @override
  String get descSignatureNotePartialCoverageDetail =>
      'ഒപ്പിട്ടതിനു ശേഷം ഈ ഫയലിൽ എന്തോ ചേർത്തിട്ടുണ്ട്. ആ ഭാഗത്തെക്കുറിച്ച് ഒപ്പ് ഒന്നും പറയുന്നില്ല.';

  @override
  String get descSignatureNoteRevoked => 'സർട്ടിഫിക്കറ്റ് റദ്ദാക്കി';

  @override
  String get descSignatureNoteRevokedDetail =>
      'ഈ സർട്ടിഫിക്കറ്റ് നൽകിയവർ അത് റദ്ദാക്കിയിട്ടുണ്ട്. ഇത് വിശ്വസിക്കരുത്.';

  @override
  String get descSignatureNoteRevocationNotChecked =>
      'സർട്ടിഫിക്കറ്റ് റദ്ദാക്കിയോ എന്ന് പരിശോധിക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get descSignatureNoteRevocationNotCheckedDetail =>
      'അത് പരിശോധിക്കാൻ ഇന്റർനെറ്റ് വേണം, ഈ ആപ്പ് ഒരിക്കലും അത് ഉപയോഗിക്കില്ല. ഈ PDF-ൽ ആ തെളിവ് ഇല്ല.';

  @override
  String get descSignatureNoteCertExpired =>
      'ഒപ്പിടുമ്പോൾ സർട്ടിഫിക്കറ്റിന്റെ കാലാവധി കഴിഞ്ഞിരുന്നു';

  @override
  String get descSignatureNoteCertExpiredDetail =>
      'ഒപ്പിട്ട സമയത്ത് സർട്ടിഫിക്കറ്റ് അതിന്റെ സാധുവായ തീയതികൾക്ക് പുറത്തായിരുന്നു.';

  @override
  String get descSignatureNoteUnverifiedTime =>
      'ഒപ്പിട്ട സമയം ഒരു അവകാശവാദം മാത്രം';

  @override
  String get descSignatureNoteUnverifiedTimeDetail =>
      'ഈ സമയം ഫയലിന്റെ ഒപ്പിട്ട ഭാഗത്തിന് പുറത്താണ്, അതിനാൽ ആർക്കും അത് മാറ്റാമായിരുന്നു.';

  @override
  String get labelSignatureSigner => 'ഒപ്പിട്ടത്';

  @override
  String get labelSignatureSignerUnknown => 'പറഞ്ഞിട്ടില്ല';

  @override
  String get labelSignatureSignedAt => 'ഒപ്പിട്ട തീയതി';

  @override
  String get labelSignatureReason => 'കാരണം';

  @override
  String get labelSignatureLocation => 'സ്ഥലം';

  @override
  String get titleSignatureCertificate => 'സർട്ടിഫിക്കറ്റ്';

  @override
  String get labelSignatureIssuedTo => 'നൽകിയത്';

  @override
  String get labelSignatureIssuedBy => 'നൽകിയവർ';

  @override
  String get labelSignatureValidFrom => 'സാധുവായ തുടക്കം';

  @override
  String get labelSignatureValidUntil => 'സാധുവായ അവസാനം';

  @override
  String get descSignatureSelfSignedNote =>
      'ഈ സർട്ടിഫിക്കറ്റ് സ്വയം ഉറപ്പുനൽകുന്നു. മറ്റാരും ഇതിന് പിന്തുണ നൽകുന്നില്ല, അതിനാൽ ഒപ്പിട്ടയാളെ അറിയാമെങ്കിൽ മാത്രം വിശ്വസിക്കുക.';

  @override
  String get actionSignatureTrust => 'ഈ സർട്ടിഫിക്കറ്റ് വിശ്വസിക്കുക';

  @override
  String get titleSignatureTrust => 'ഈ ഒപ്പിട്ടയാളെ വിശ്വസിക്കണോ?';

  @override
  String get descSignatureTrustExplain =>
      'ഇനി മുതൽ ഈ സർട്ടിഫിക്കറ്റ് ഉപയോഗിച്ച് ഒപ്പിട്ട ഏത് PDF-ഉം വിശ്വസനീയമായി കാണിക്കും. ഒപ്പിട്ടയാൾ ആരാണെന്ന് അറിയാമെങ്കിൽ മാത്രം ഇത് ചെയ്യുക.';

  @override
  String get labelSignatureTrustConfirm => 'വിശ്വസിക്കുക';

  @override
  String get descSignatureTrustedToast => 'സർട്ടിഫിക്കറ്റ് വിശ്വസിച്ചു.';

  @override
  String get titleTrustStore => 'വിശ്വസിക്കുന്ന സർട്ടിഫിക്കറ്റുകൾ';

  @override
  String get emptyTrustStore =>
      'നിങ്ങൾ ഇതുവരെ ഒരു സർട്ടിഫിക്കറ്റും വിശ്വസിച്ചിട്ടില്ല.';

  @override
  String get descTrustStoreEmptyDetail =>
      'ഒപ്പിട്ടയാളുടെ സർട്ടിഫിക്കറ്റ് വിശ്വസിക്കുമ്പോൾ അത് ഇവിടെ കാണാം. എപ്പോൾ വേണമെങ്കിലും നീക്കം ചെയ്യാം.';

  @override
  String get actionTrustStoreAdd => 'ഒരു സർട്ടിഫിക്കറ്റ് ചേർക്കുക';

  @override
  String get actionTrustStoreRemove => 'നീക്കം ചെയ്യുക';

  @override
  String get titleTrustStoreRemove =>
      'ഈ സർട്ടിഫിക്കറ്റ് വിശ്വസിക്കുന്നത് നിർത്തണോ?';

  @override
  String get descTrustStoreRemoveExplain =>
      'ഇത് ഉപയോഗിച്ച് ഒപ്പിട്ട PDF-കൾ ഇനി വിശ്വസനീയമായി കാണിക്കില്ല.';

  @override
  String get descTrustStoreInvalidFile =>
      'ആ ഫയൽ ആപ്പിന് വായിക്കാൻ കഴിയുന്ന സർട്ടിഫിക്കറ്റല്ല.';

  @override
  String get descTrustStoreExpiredWarning =>
      'ഈ സർട്ടിഫിക്കറ്റിന്റെ കാലാവധി കഴിഞ്ഞു.';

  @override
  String get actionTrimMargins => 'മാർജിനുകൾ ക്രോപ്പ് ചെയ്യുക';

  @override
  String get titleTrimMargins => 'സ്മാർട്ട് മാർജിൻ ട്രിം';

  @override
  String get descTrimMargins =>
      'മൊബൈൽ വായനക്കായി വെളുത്ത മാർജിനുകൾ ക്രോപ്പ് ചെയ്യുന്നു.';

  @override
  String get descTrimMarginsWorking => 'മാർജിനുകൾ ക്രോപ്പ് ചെയ്യുന്നു…';

  @override
  String get titleTrimMarginsDone => 'മാർജിനുകൾ ക്രോപ്പ് ചെയ്തു';

  @override
  String get descTrimMarginsDoneNote =>
      'മൊബൈൽ സ്‌ക്രീനുകൾക്ക് അനുയോജ്യമായ രീതിയിൽ മാർജിനുകൾ ക്രോപ്പ് ചെയ്തു.';

  @override
  String get labelTrimPadding => 'മാർജിൻ പാഡിംഗ്';

  @override
  String get labelTrimPaddingTight => 'കുറഞ്ഞത് (4 pt)';

  @override
  String get labelTrimPaddingStandard => 'സാധാരണം (12 pt)';

  @override
  String get labelTrimPaddingComfortable => 'കൂടുതൽ (24 pt)';

  @override
  String get labelTrimSymmetric => 'തുല്യമായ മാർജിനുകൾ';

  @override
  String get helpTrimSymmetric =>
      'ഇടതും വലതും മാർജിനുകൾ തുല്യമായി സൂക്ഷിക്കുന്നു.';

  @override
  String get actionBooklet => 'ബുക്ക്‌ലെറ്റ് നിർമ്മിക്കുക';

  @override
  String get titleBooklet => 'ഫോൾഡബിൾ ബുക്ക്‌ലെറ്റ് (2-Up)';

  @override
  String get descBooklet =>
      'ഇരുവശത്തും അച്ചടിച്ച് മടക്കാൻ കഴിയുന്ന 2-Up ബുക്ക്‌ലെറ്റ് ലേഔട്ട് നിർമ്മിക്കുന്നു.';

  @override
  String get descBookletWorking => 'ബുക്ക്‌ലെറ്റ് ലേഔട്ട് നിർമ്മിക്കുന്നു…';

  @override
  String get titleBookletDone => 'ബുക്ക്‌ലെറ്റ് നിർമ്മിച്ചു';

  @override
  String get descBookletDoneNote =>
      'ഇരുവശത്തും അച്ചടിക്കുക (ചെറിയ അരികിൽ മറിക്കുക), നടുവിൽ മടക്കുക.';

  @override
  String get titleBookletSummary => 'ബുക്ക്‌ലെറ്റ് വിവരങ്ങൾ';

  @override
  String descBookletSummaryPages(int source, int padded) {
    return '$source യഥാർത്ഥ പേജുകൾ -> $padded ബുക്ക്‌ലെറ്റ് പേജുകൾ';
  }

  @override
  String descBookletSummarySheets(int sheets, int faces) {
    return '$sheets ലാൻഡ്‌സ്‌കേപ്പ് ഷീറ്റുകൾ ($faces പ്രിന്റബിൾ വശങ്ങൾ)';
  }

  @override
  String descBookletSummaryBlanks(int blanks) {
    return '$blanks ശൂന്യ പേജുകൾ അവസാനം ചേർത്തു';
  }

  @override
  String get labelBookletBinding => 'ബൈൻഡിംഗ് ദിശ';

  @override
  String get labelBookletBindingLtr => 'ഇടത്തുനിന്ന് വലത്തോട്ട് (LTR)';

  @override
  String get labelBookletBindingRtl => 'വലത്തുനിന്ന് ഇടത്തോട്ട് (RTL)';

  @override
  String get labelBookletPaperSize => 'പേപ്പർ വലുപ്പം';

  @override
  String get labelBookletPaperAuto => 'യഥാർത്ഥ വലുപ്പം';

  @override
  String get labelBookletPaperA4 => 'A4 ലാൻഡ്‌സ്‌കേപ്പ്';

  @override
  String get labelBookletPaperLetter => 'US ലെറ്റർ';

  @override
  String get labelBookletFoldGuide => 'മടക്കാനുള്ള ഗൈഡ് ലൈൻ';

  @override
  String get helpBookletFoldGuide =>
      'ബുക്ക്‌ലെറ്റ് എവിടെ മടക്കണമെന്ന് കാണിക്കുന്ന ഒരു ചെറിയ ഡോട്ടഡ് വര വരയ്ക്കുന്നു.';

  @override
  String get titleAppearance => 'രൂപം';

  @override
  String get descAppearanceSubtitle => 'തീം മോഡ്, ടൈപോഗ്രാഫി, ആക്സന്റ് നിറം';

  @override
  String get titleThemeMode => 'തീം മോഡ്';

  @override
  String get descThemeModeSubtitle =>
      'ലൈറ്റ്, ഡാർക്ക്, സിസ്റ്റം, സെപിയ എന്നിവയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get descThemeModeCardSubtitle =>
      'ലൈറ്റ്, ഡാർക്ക്, അല്ലെങ്കിൽ സിസ്റ്റം തിരഞ്ഞെടുക്കുക';

  @override
  String get descThemeMode =>
      'സിസ്റ്റം മോഡ് നിങ്ങളുടെ ഉപകരണത്തിന്റെ ഡാർക്ക് മോഡ് ക്രമീകരണത്തെ സ്വയം പിന്തുടരും. സെപിയ മോഡ് സുഖകരമായ വായനാനുഭവം നൽകുന്നു.';

  @override
  String get titleTypography => 'ടൈപോഗ്രാഫിയും ടെക്സ്റ്റ് വലിപ്പവും';

  @override
  String get descTypographySubtitle =>
      'ആപ്പിന്റെ ഫോണ്ട് കുടുംബവും ടെക്സ്റ്റ് വലിപ്പവും';

  @override
  String get descTypography =>
      'വ്യക്തമായ വായനാനുഭവത്തിനായി ഫോണ്ടും അക്ഷരങ്ങളുടെ വലുപ്പവും ക്രമീകരിക്കുക.';

  @override
  String get labelTypographyFont => 'ഫോണ്ട്';

  @override
  String get labelTypographyTextSize => 'ടെക്സ്റ്റ് വലിപ്പം';

  @override
  String get labelFontSystemDefault => 'സിസ്റ്റം സ്ഥിരസ്ഥിതി';

  @override
  String get labelFontManjari => 'Manjari';

  @override
  String get labelFontAnekMalayalam => 'Anek Malayalam';

  @override
  String get labelFontNotoSansMalayalam => 'Noto Sans Malayalam';

  @override
  String get labelTextSizeSmall => 'ചെറുത്';

  @override
  String get labelTextSizeDefault => 'ഡിഫോൾട്ട്';

  @override
  String get labelTextSizeLarge => 'വലുത്';

  @override
  String get labelTextSizeLarger => 'കൂടുതൽ വലുത്';

  @override
  String get descTypographySampleLatin => 'The quick brown fox 0123';

  @override
  String get labelTypographySampleMalayalam => 'മലയാളം സുന്ദരമാണ്';

  @override
  String get titleAccentColor => 'ആക്സന്റ് നിറം';

  @override
  String get descAccentColorSubtitle =>
      'പ്രീസെറ്റുകൾ, കലർ വീൽ, തത്സമയ പ്രിവ്യൂ';

  @override
  String get descAccentAppliesToLight =>
      'ആപ്പ് ലൈറ്റ് മോഡിലായിരിക്കുമ്പോൾ ഈ നിറം ഉപയോഗിക്കുന്നു.';

  @override
  String get descAccentAppliesToDark =>
      'ആപ്പ് ഡാർക്ക് മോഡിലായിരിക്കുമ്പോൾ ഈ നിറം ഉപയോഗിക്കുന്നു.';

  @override
  String get labelLivePreview => 'തത്സമയ പ്രിവ്യൂ';

  @override
  String get labelSampleText => 'മാതൃകാ വാചകം';

  @override
  String get labelPresets => 'പ്രീസെറ്റുകൾ';

  @override
  String get labelCustomColorWheel => 'കളർ വീൽ';

  @override
  String get labelResetToDefault => 'പഴയപടിയാക്കുക';

  @override
  String get descResetLightToDefault => 'ലൈറ്റ് തീം പഴയപടിയാക്കുക';

  @override
  String get descResetDarkToDefault => 'ഡാർക്ക് തീം പഴയപടിയാക്കുക';

  @override
  String get descContrastNotice =>
      'എളുപ്പത്തിൽ വായിക്കാനായി ടെക്സ്റ്റ് കോൺട്രാസ്റ്റ് സ്വയം ക്രമീകരിക്കപ്പെടുന്നു.';

  @override
  String get titlePermissions => 'അനുമതികൾ';

  @override
  String get descPermissionsSubtitle =>
      'സ്റ്റോറേജ്, സാങ്കൽപ്പിക അച്ചടി സേവനം, സ്വകാര്യത';

  @override
  String get labelPermissionsOpenSettings => 'സിസ്റ്റം ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get labelPermissionsExplicitHeader => 'പ്രത്യേക സൗകര്യങ്ങൾ';

  @override
  String get descPermissionsExplicitSubtitle =>
      'സുരക്ഷിതമായി ഫയലുകൾ കൈകാര്യം ചെയ്യാനുള്ള സംവിധാനങ്ങൾ.';

  @override
  String get descPermissionsImplicitHeader =>
      'സ്വകാര്യതയും സിസ്റ്റം വിവരങ്ങളും';

  @override
  String get descPermissionsImplicitSubtitle =>
      'മാനിഫെസ്റ്റിൽ ഡിക്ലയർ ചെയ്തവ; എല്ലാ പ്രവർത്തനവും ഈ ഫോണിൽത്തന്നെ.';

  @override
  String get titlePermScopedStorage => 'സ്കോപ്പ്ഡ് സ്റ്റോറേജ് (SAF)';

  @override
  String get descPermScopedStorageReason =>
      'സിസ്റ്റം ഫയൽ പിക്കർ വഴി സുരക്ഷിതമായി രേഖകൾ തുറക്കാനും സൂക്ഷിക്കാനും.';

  @override
  String get titlePermPrintService => 'സാങ്കൽപ്പിക അച്ചടിയന്ത്രം';

  @override
  String get descPermPrintServiceReason =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് നേരിട്ട് PDF ആയി അച്ചടിക്കാൻ സഹായിക്കുന്നു.';

  @override
  String get titlePermOffline => 'സ്വകാര്യം, ഇന്റർനെറ്റില്ല';

  @override
  String get descPermOfflineReason =>
      'ഇന്റർനെറ്റ് ഉപയോഗമില്ല. ഉപകരണ സമന്വയം വഴി നിങ്ങളുടെ മറ്റേ ഫോണിലേക്ക് അയയ്ക്കുമ്പോൾ മാത്രമേ പ്രമാണങ്ങൾ ഈ ഫോൺ വിട്ടുപോകൂ.';

  @override
  String get titlePermTts => 'ടെക്സ്റ്റ്-ടു-സ്പീച്ച് എൻജിൻ';

  @override
  String get descPermTtsReason =>
      'മലയാളത്തിലും ഇംഗ്ലീഷിലും ഉറക്കെ വായിക്കാനായി സ്പീച്ച് എൻജിൻ ഉപയോഗിക്കുന്നു.';

  @override
  String get titlePermProcessText => 'പ്രോസസ് ടെക്സ്റ്റ് ആക്ഷൻ';

  @override
  String get descPermProcessTextReason =>
      'മറ്റ് ആപ്പുകളിൽ ടെക്സ്റ്റ് സെലക്ട് ചെയ്യുമ്പോൾ എളുപ്പത്തിൽ തിരയാൻ സഹായിക്കുന്നു.';

  @override
  String get labelStatusActive => 'സജീവം';

  @override
  String get labelStatusSystem => 'സിസ്റ്റം';

  @override
  String get labelStatusOffline => 'ഓഫ്‌ലൈൻ';

  @override
  String get descTrustStoreSubtitle =>
      'ഡിജിറ്റൽ സിഗ്നേച്ചർ റൂട്ട് സർട്ടിഫിക്കറ്റുകൾ കൈകാര്യം ചെയ്യുക';

  @override
  String get descAboutSubtitle => 'ആപ്പ് പതിപ്പ്, ലൈസൻസുകൾ, നിയമ വിവരങ്ങൾ';

  @override
  String get helpTitle => 'സഹായം';

  @override
  String get helpSubtitle => 'ഗൈഡുകൾ, നിർദ്ദേശങ്ങൾ, സഹായക്കുറിപ്പുകൾ';

  @override
  String get helpPdfPrinterTitle => 'PDF അച്ചടിയന്ത്ര ക്രമീകരണം';

  @override
  String get helpPdfPrinterSubtitle =>
      'സാങ്കൽപ്പിക അച്ചടി സേവനം എങ്ങനെ സജീവമാക്കാം';

  @override
  String get helpPdfPrinterTopicHeader =>
      '1. ആൻഡ്രോയിഡിൽ PDF അച്ചടിയന്ത്രം എങ്ങനെ സജീവമാക്കാം';

  @override
  String get helpPdfPrinterIntro =>
      'ആൻഡ്രോയിഡിൽ സാങ്കൽപ്പിക അച്ചടി സേവനങ്ങൾ സിസ്റ്റം തലത്തിലാണ് നിയന്ത്രിക്കുന്നത്. ഗ്രന്ഥം ആപ്പിനെ സിസ്റ്റം മുഴുവൻ ഉപയോഗിക്കാവുന്ന അച്ചടിയന്ത്രമായി സജീവമാക്കാൻ:';

  @override
  String get helpPdfPrinterStep1 =>
      'നിങ്ങളുടെ ആൻഡ്രോയിഡ് ഉപകരണത്തിലെ ക്രമീകരണങ്ങൾ (Settings) തുറക്കുക.';

  @override
  String get helpPdfPrinterStep2 =>
      'Connected devices → Connection preferences → Printing എന്നതിലേക്ക് പോവുക (അല്ലെങ്കിൽ Settings സെർച്ചിൽ \"Printing\" എന്ന് തിരയുക).';

  @override
  String get helpPdfPrinterStep3 =>
      'Print services എന്നതിന് കീഴിൽ ഗ്രന്ഥം (Folio) കണ്ടെത്തുക.';

  @override
  String get helpPdfPrinterStep4 => 'അതിൽ ടാപ്പ് ചെയ്ത് ടോഗിൾ On ആക്കുക.';

  @override
  String get helpOpenPrintSettings => 'അച്ചടി ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get helpUnicodePrintingTitle => 'യൂണികോഡ് & മലയാളം PDF പ്രിന്റിംഗ്';

  @override
  String get helpUnicodePrintingSubtitle =>
      'മലയാളം അക്ഷരങ്ങൾ തെറ്റാതെ PDF ആക്കി മാറ്റുക';

  @override
  String get helpUnicodePrintingTopicHeader =>
      'യൂണികോഡ് & മലയാളം ശരിയായി അച്ചടിക്കാം';

  @override
  String get helpUnicodePrintingIntro =>
      'ആൻഡ്രോയിഡിന്റെ സാധാരണ PDF-ലേക്കുള്ള അച്ചടി സംവിധാനത്തിൽ ചിലപ്പോൾ മലയാളം, സംസ്കൃതം, ഹിന്ദി തുടങ്ങിയ ഭാഷകളിലെ കൂട്ടക്ഷരങ്ങളും ചില്ലക്ഷരങ്ങളും വിട്ടുപോവുകയോ വികലമാവുകയോ ചെയ്യാറുണ്ട്. ഗ്രന്ഥം ആപ്പ് ഈ അക്ഷരങ്ങളും ഫോണ്ടുകളും കൃത്യമായി ഉൾച്ചേർത്ത് വ്യക്തതയുള്ള PDF ഉണ്ടാക്കുന്നു.';

  @override
  String get helpUnicodePrintingStep1 =>
      'ആൻഡ്രോയിഡ് ക്രമീകരണങ്ങളിൽ PDF സാങ്കൽപ്പിക അച്ചടിയന്ത്രം ഓൺ ചെയ്തിട്ടുണ്ടെന്ന് ഉറപ്പാക്കുക.';

  @override
  String get helpUnicodePrintingStep2 =>
      'ബ്രൗസർ, വാട്ട്സ്ആപ്പ് അല്ലെങ്കിൽ ഓഫീസ് ആപ്പുകളിൽ നിന്ന് Print തിരഞ്ഞെടുക്കുക.';

  @override
  String get helpUnicodePrintingStep3 =>
      'സാധാരണ \'Save as PDF\' എന്നതിന് പകരം \'ഗ്രന്ഥം (Folio)\' അച്ചടിയന്ത്രമായി തിരഞ്ഞെടുക്കുക.';

  @override
  String get helpUnicodePrintingStep4 =>
      'ആപ്പ് അച്ചടി വിവരങ്ങൾ ശേഖരിച്ച് മലയാളം അക്ഷരക്കൂട്ടുകൾ സുന്ദരമായി ചേർത്ത് പുതിയ PDF ഫയൽ നിർമ്മിക്കുന്നു.';

  @override
  String get helpUnicodePrintingTip =>
      'സഹായക്കുറിപ്പ്: വെബ് താളുകൾ അച്ചടിക്കുമ്പോൾ പരസ്യങ്ങളും മറ്റ് അനാവശ്യ ഭാഗങ്ങളും ഒഴിവാക്കാൻ അച്ചടിയന്ത്ര ക്രമീകരണങ്ങളിൽ \'വെബ് ഉള്ളടക്ക ശുചീകരണം\' ഓൺ ചെയ്യുക.';

  @override
  String get helpOpenPrinterSettings => 'അച്ചടിയന്ത്ര ക്രമീകരണങ്ങൾ തുറക്കുക';

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
      'താൾ മാറ്റങ്ങളും സുരക്ഷിതമായ പുതിയ പകർപ്പും';

  @override
  String get helpPageOpsIntro =>
      'നിങ്ങളുടെ PDF-ലെ താളുകൾ എളുപ്പത്തിൽ മാറ്റിമറിക്കാം. എല്ലാ മാറ്റങ്ങളും പുതിയ ഫയലായി മാത്രമേ സൂക്ഷിക്കപ്പെടൂ — നിങ്ങളുടെ മൂലഫയലിൽ മാറ്റം വരില്ല.';

  @override
  String get helpPageOpsStep1 =>
      'രേഖ തുറന്ന് താൾ പ്രവർത്തനങ്ങളുടെ മെനു അല്ലെങ്കിൽ ക്രമീകരണ കാഴ്ച എടുക്കുക.';

  @override
  String get helpPageOpsStep2 =>
      'പേജുകൾ ഡ്രാഗ് ചെയ്ത് സ്ഥാനം മാറ്റാം, തിരിക്കാം (Rotate), അല്ലെങ്കിൽ വേണ്ടാത്ത പേജുകൾ നീക്കം ചെയ്യാം.';

  @override
  String get helpPageOpsStep3 =>
      'മടക്കാവുന്ന ബുക്ക്‌ലെറ്റുകൾക്കായി \'Booklet\' ഓപ്ഷനും, ഒരു ഷീറ്റിൽ പല പേജുകൾക്കായി \'N-Up\' ഓപ്ഷനും ഉപയോഗിക്കുക.';

  @override
  String get helpPageOpsStep4 =>
      'സൂക്ഷിക്കുക / കയറ്റുമതി ചെയ്യുക അമർത്തി പുതിയ PDF ഫയൽ സൂക്ഷിക്കുക.';

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
      'ഗ്രന്ഥം ആപ്പ് ഇന്റർനെറ്റ് സഹായമില്ലാതെ തന്നെ ക്രിപ്റ്റോഗ്രാഫിക് അൽഗോരിതങ്ങൾ (SHA-256, X.509) ഉപയോഗിച്ച് പൂർണ്ണമായും ഓഫ്‌ലൈനായി ഒപ്പുകൾ പരിശോധിക്കുന്നു.';

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
      'ഇന്റർനെറ്റ് സെർവറുകളില്ല, സ്കോപ്പ്ഡ് സ്റ്റോറേജ് സുരക്ഷയും';

  @override
  String get helpPrivacyStorageTopicHeader =>
      'ഇന്റർനെറ്റില്ലാത്ത സ്വകാര്യതാ ഉറപ്പ്';

  @override
  String get helpPrivacyStorageIntro =>
      'നിങ്ങളുടെ സ്വകാര്യത പൂർണ്ണമായി സംരക്ഷിക്കപ്പെടുന്നു. ഗ്രന്ഥം ആപ്പ് ഒരിക്കലും ഇന്റർനെറ്റുമായി ബന്ധപ്പെടുന്നില്ല. പ്രാദേശിക വൈഫൈയിൽ നിങ്ങളുടെ സ്വന്തം ഫോണുകൾ തമ്മിൽ നേരിട്ടുള്ള ഉപകരണ സമന്വയം മാത്രമാണ് ഏക നെറ്റ്‌വർക്ക് ഉപയോഗം.';

  @override
  String get helpPrivacyStorageStep1 =>
      'ഇന്റർനെറ്റില്ല: ഗ്രന്ഥം ആപ്പ് ഒരിക്കലും ഇന്റർനെറ്റ് സെർവറുമായി ബന്ധപ്പെടുന്നില്ല, ഒരു വിവരവും ശേഖരിക്കുന്നില്ല. INTERNET അനുമതി പ്രാദേശിക വൈഫൈയിലെ ഉപകരണ സമന്വയത്തിന് മാത്രം, ആ സ്ക്രീൻ തുറന്നിരിക്കുമ്പോൾ മാത്രം ഉപയോഗിക്കുന്നു.';

  @override
  String get helpPrivacyStorageStep2 =>
      'സ്കോപ്പ്ഡ് സ്റ്റോറേജ്: നിങ്ങൾ തിരഞ്ഞെടുക്കുന്ന ഫയലുകൾ മാത്രമേ ആപ്പ് തുറക്കുകയുള്ളൂ.';

  @override
  String get helpPrivacyStorageStep3 =>
      'കാഷെ നീക്കം ചെയ്യൽ: താൽക്കാലിക ഫയലുകൾ ഏതു സമയത്തും സ്റ്റോറേജ് ക്രമീകരണങ്ങളിൽ നിന്ന് ഒഴിവാക്കാം.';

  @override
  String get helpPrivacyStorageTip =>
      'പാസ്‌വേഡ് സുരക്ഷ: പാസ്‌വേഡ് ഉള്ള PDF തുറക്കുമ്പോൾ നൽകുന്ന പാസ്‌വേഡുകൾ മെമ്മറിയിൽ സൂക്ഷിക്കാറില്ല, ഡിസ്കിൽ എഴുതുകയുമില്ല.';

  @override
  String get helpOpenStorageSettings =>
      'സ്റ്റോറേജ് & പ്രൈവസി ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get titleLanguage => 'ഭാഷ';

  @override
  String get descLanguageSubtitle => 'ആപ്പ് ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get labelLanguageSystem => 'സിസ്റ്റം ഡിഫോൾട്ട്';

  @override
  String get labelLanguageEnglish => 'English';

  @override
  String get labelLanguageMalayalam => 'മലയാളം';

  @override
  String get labelLanguageSanskrit => 'സംസ്കൃതം (Sanskrit)';

  @override
  String get titleLanguageSelect => 'ആപ്പ് ഭാഷ';

  @override
  String get descLanguageSelectSubtitle =>
      'തിരഞ്ഞെടുക്കുന്ന ഭാഷ ആപ്പിൽ ഉടനടി ലഭ്യമാകും.';

  @override
  String get titleReaderSettings => 'റീഡറും വ്യൂവറും';

  @override
  String get descReaderSettingsSubtitle =>
      'വായനാ സ്ഥാനം, ലേഔട്ട്, സൂം, ഡിസ്പ്ലേ';

  @override
  String get titleSaveLastPosition => 'അവസാന വായനാ സ്ഥാനം ഓർക്കുക';

  @override
  String get descSaveLastPositionSubtitle =>
      'തുറക്കുമ്പോൾ അവസാനമായി വായിച്ച പേജും സൂമും സ്വയം ക്രമീകരിക്കും';

  @override
  String get titleDefaultPageLayout => 'സ്വതവേയുള്ള താൾ വിന്യാസം';

  @override
  String get descDefaultPageLayoutSubtitle =>
      'ഡോക്യുമെന്റുകൾ തുറക്കുമ്പോൾ പേജുകൾ പ്രദർശിപ്പിക്കേണ്ട രീതി';

  @override
  String get labelLayoutContinuous => 'തുടർച്ചയായ സ്ക്രോൾ';

  @override
  String get labelLayoutSinglePage => 'ഒറ്റ താൾ';

  @override
  String get titleDoubleTapZoom => 'ഡബിൾ-ടാപ്പ് സൂം';

  @override
  String get descDoubleTapZoomSubtitle =>
      'പേജിൽ ഇരട്ട ടാപ്പ് ചെയ്യുമ്പോൾ ചെയ്യേണ്ട പ്രവർത്തനം';

  @override
  String get labelZoomFitWidth => 'വീതിക്ക് അനുയോജ്യമാക്കുക';

  @override
  String get labelZoom200 => '200% സൂം';

  @override
  String get titleShowPageIndicator => 'താൾ സൂചിക';

  @override
  String get descShowPageIndicatorSubtitle =>
      'വായിക്കുമ്പോൾ സ്ക്രീനിൽ താൾ സംഖ്യ കാണിക്കുക';

  @override
  String get titleInvertColors => 'PDF നിറങ്ങൾ വിപരീതമാക്കുക';

  @override
  String get descInvertColorsSubtitle =>
      'രാത്രി വായനയ്ക്കായി ഡോക്യുമെന്റ് നിറങ്ങൾ മാറ്റുക';

  @override
  String get titleTtsSettings => 'ഉറക്കെ വായിക്കുക (TTS)';

  @override
  String get descTtsSettingsSubtitle => 'ശബ്ദം, വായനാ വേഗത, പിച്ച്, ഓപ്ഷനുകൾ';

  @override
  String get titleTtsSpeechRate => 'വായനാ വേഗത';

  @override
  String descTtsSpeechRateSubtitle(String rate) {
    return '${rate}x വേഗത';
  }

  @override
  String get titleTtsPitch => 'വോയ്സ് പിച്ച്';

  @override
  String descTtsPitchSubtitle(String pitch) {
    return '${pitch}x പിച്ച്';
  }

  @override
  String get titleTtsAutoScroll => 'വായനയ്ക്കൊപ്പം സ്വയം സ്ക്രോൾ ചെയ്യുക';

  @override
  String get descTtsAutoScrollSubtitle =>
      'വായിക്കുന്ന വാചകങ്ങൾക്കൊപ്പം ഡോക്യുമെന്റ് സ്വയം നീങ്ങുന്നു';

  @override
  String get titlePrinterSettings => 'PDF സാങ്കൽപ്പിക അച്ചടിയന്ത്രം';

  @override
  String get descPrinterSettingsSubtitle =>
      'അച്ചടി സേവന സംയോജനം, കടലാസ് വലുപ്പം, കാഷെ';

  @override
  String get titlePrinterEnable => 'PDF അച്ചടിയന്ത്രം ഓണാക്കുക';

  @override
  String get descPrinterEnableSubtitle =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് അച്ചടി ജോലികൾ സ്വീകരിച്ച് PDF ആയി സൂക്ഷിക്കുക';

  @override
  String get titleDefaultPaperSize => 'ഡിഫോൾട്ട് പേപ്പർ വലുപ്പം';

  @override
  String get descDefaultPaperSizeSubtitle =>
      'തയ്യാറാക്കുന്ന PDF-കളുടെ പേപ്പർ അളവ്';

  @override
  String get titleDefaultColorMode => 'ഡിഫോൾട്ട് കളർ മോഡ്';

  @override
  String get descDefaultColorModeSubtitle => 'അച്ചടിക്കുന്ന ഫയലുകളുടെ നിറം';

  @override
  String get labelColorModeColor => 'നിറമുള്ളത്';

  @override
  String get labelColorModeGrayscale => 'ഗ്രേസ്കെയിൽ';

  @override
  String get descColorModeMonochrome => 'മോണോക്രോം (കറുപ്പും വെളുപ്പും)';

  @override
  String get titleDefaultOrientation => 'ഡിഫോൾട്ട് ഓറിയന്റേഷൻ';

  @override
  String get descDefaultOrientationSubtitle => 'താൾ പ്രദർശന ദിശ';

  @override
  String get labelOrientationAuto => 'സ്വയം (ഫയലിനനുസരിച്ച്)';

  @override
  String get labelOrientationPortrait => 'പോർട്രയിറ്റ്';

  @override
  String get labelOrientationLandscape => 'ലാൻഡ്‌സ്കേപ്പ്';

  @override
  String get titleClearPrinterCache => 'അച്ചടി കാഷെ മായ്ക്കുക';

  @override
  String descClearPrinterCacheSubtitle(String size) {
    return 'താൽക്കാലിക അച്ചടി ഫയലുകൾ നീക്കം ചെയ്യുക ($size)';
  }

  @override
  String get descPrinterCacheCleared => 'അച്ചടി കാഷെ മായ്ച്ചു.';

  @override
  String get titleStorageSettings => 'സ്റ്റോറേജും സ്വകാര്യതയും';

  @override
  String get descStorageSettingsSubtitle =>
      'റീസെന്റ് ഫയലുകളുടെ ചരിത്രവും കാഷെ വിവരങ്ങളും';

  @override
  String get titleRememberRecentFiles => 'റീസെന്റ് ഫയലുകൾ ഓർക്കുക';

  @override
  String get descRememberRecentFilesSubtitle =>
      'തുറന്ന ഡോക്യുമെന്റുകൾ ഹോം സ്ക്രീനിൽ കാണിക്കുക';

  @override
  String get titleClearRecentFiles => 'റീസെന്റ് ഫയലുകളുടെ ചരിത്രം മായ്ക്കുക';

  @override
  String get descClearRecentFilesSubtitle =>
      'തുറന്ന ഫയലുകളുടെ പട്ടികയും വായനാ സ്ഥാനങ്ങളും മായ്ക്കുന്നു';

  @override
  String get titleClearRecentFilesConfirm => 'റീസെന്റ് ഫയലുകൾ മായ്ക്കണോ?';

  @override
  String get bodyClearRecentFilesConfirm =>
      'ഇത് നിങ്ങളുടെ സമീപകാല ഫയലുകളുടെ ലിസ്റ്റും വായനാ പുരോഗതിയും മായ്ക്കും. ഫോണിലെ യഥാർത്ഥ PDF ഫയലുകൾ ഇല്ലാതാകില്ല.';

  @override
  String get actionClearRecentFiles => 'ചരിത്രം മായ്ക്കുക';

  @override
  String get descRecentFilesCleared => 'റീസെന്റ് ഫയലുകളുടെ ചരിത്രം മായ്ച്ചു.';

  @override
  String get titleClearTempCache => 'ആപ്പ് കാഷെ മായ്ക്കുക';

  @override
  String descClearTempCacheSubtitle(String size) {
    return 'വിവരങ്ങൾ നഷ്ടപ്പെടാതെ താൽക്കാലിക ഫയലുകൾ ഒഴിവാക്കുക ($size)';
  }

  @override
  String get descTempCacheCleared => 'താൽക്കാലിക കാഷെ മായ്ച്ചു.';

  @override
  String get titleSecuritySettings => 'സിഗ്നേച്ചറുകളും സുരക്ഷയും';

  @override
  String get descSecuritySettingsSubtitle =>
      'ഡിജിറ്റൽ സിഗ്നേച്ചർ പരിശോധനയും സർട്ടിഫിക്കറ്റുകളും';

  @override
  String get titleAutoVerifySignatures => 'സിഗ്നേച്ചർ സ്വയം പരിശോധിക്കുക';

  @override
  String get descAutoVerifySignaturesSubtitle =>
      'ഒപ്പിട്ട PDF തുറക്കുമ്പോൾ ഡിജിറ്റൽ ഒപ്പുകൾ സ്വയം പരിശോധിക്കുക';

  @override
  String get titlePermFileProvider => 'സുരക്ഷിത ഫയൽ പ്രൊവൈഡർ';

  @override
  String get descPermFileProviderReason =>
      'സ്വകാര്യ ഫയൽ പാതകൾ വെളിപ്പെടുത്താതെ താൽക്കാലിക PDF-കൾ മറ്റ് ആപ്പുകളുമായി പങ്കിടാൻ സഹായിക്കുന്നു.';

  @override
  String get descPermFileProviderWhatItAchieves =>
      'സ്റ്റോറേജ് സുരക്ഷ നഷ്ടപ്പെടുത്താതെ PDF ഫയലുകൾ സുരക്ഷിതമായി പങ്കിടാനും അച്ചടിക്കാനും സാധിക്കുന്നു.';

  @override
  String get titlePermTtsInstall => 'വോയ്സ് ഡാറ്റ ഇൻസ്റ്റാളർ';

  @override
  String get descPermTtsInstallReason =>
      'ആവശ്യമായ ഭാഷാ ശബ്ദങ്ങൾ ലഭ്യമല്ലെങ്കിൽ സിസ്റ്റം ഡൗൺലോഡ് സ്ക്രീൻ തുറക്കുന്നു.';

  @override
  String get descPermTtsInstallWhatItAchieves =>
      'മലയാളം, ഇംഗ്ലീഷ് സംസാര ശബ്ദങ്ങൾ എളുപ്പത്തിൽ ഇൻസ്റ്റാൾ ചെയ്യാൻ സഹായിക്കുന്നു.';

  @override
  String get titlePermSendShare => 'പങ്കിട്ടവ സ്വീകരിക്കൽ';

  @override
  String get descPermSendShareReason =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് ഷെയർ ചെയ്യുന്ന ചിത്രങ്ങളും വാചകങ്ങളും PDF ഫയലുകളും സ്വീകരിക്കുന്നു.';

  @override
  String get descPermSendShareWhatItAchieves =>
      'ഷെയർ ചെയ്യുന്ന ചിത്രങ്ങളും വാചകങ്ങളും നേരിട്ട് PDF ആക്കി മാറ്റാനും ഏത് ആപ്പിൽ നിന്നും PDF തുറക്കാനും സാധിക്കുന്നു.';

  @override
  String get titlePermZeroInternet => 'ഇന്റർനെറ്റ് സെർവറുകളില്ല';

  @override
  String get descPermZeroInternetReason =>
      'ഗ്രന്ഥം ആപ്പ് ഒരിക്കലും ഇന്റർനെറ്റ് സെർവറുമായി ബന്ധപ്പെടുന്നില്ല. പ്രാദേശിക വൈഫൈയിൽ നിങ്ങളുടെ സ്വന്തം ഫോണുകൾ തമ്മിലുള്ള ഉപകരണ സമന്വയം മാത്രമാണ് ഏക നെറ്റ്‌വർക്ക് ഉപയോഗം.';

  @override
  String get descPermZeroInternetWhatItAchieves =>
      'യാതൊരു വിവരങ്ങളും പുറത്തുപോകാതെ പൂർണ്ണ സ്വകാര്യത ഉറപ്പാക്കുന്നു.';

  @override
  String get descPermScopedStorageWhatItAchieves =>
      'ഫോണിലെ മറ്റ് ഫയലുകളുടെ സ്വകാര്യത നിലനിർത്തിക്കൊണ്ട് ഉപയോക്താവ് തിരഞ്ഞെടുത്ത PDF മാത്രം കൈകാര്യം ചെയ്യുന്നു.';

  @override
  String get descPermPrintServiceWhatItAchieves =>
      'മറ്റ് ആപ്പുകളിൽ നിന്ന് ഗ്രന്ഥം ആപ്പ് വഴി നേരിട്ട് PDF ആയി സൂക്ഷിക്കാൻ സഹായിക്കുന്നു.';

  @override
  String get descPermOfflineWhatItAchieves =>
      'നിങ്ങളുടെ രേഖകളും വിവരങ്ങളും ഒരിക്കലും ഈ ഉപകരണത്തിൽ നിന്ന് പുറത്തുപോകില്ലെന്ന് ഉറപ്പാക്കുന്നു.';

  @override
  String get descPermTtsWhatItAchieves =>
      'മലയാളത്തിലും ഇംഗ്ലീഷിലും രേഖകൾ ഉറക്കെ വായിക്കാനായി ലഭ്യമായ സ്പീച്ച് എൻജിനുകൾ കണ്ടെത്തുന്നു.';

  @override
  String get descPermProcessTextWhatItAchieves =>
      'ഏതെങ്കിലും ആപ്പിൽ സെലക്ട് ചെയ്ത വാചകങ്ങൾ നേരിട്ട് ഈ ആപ്പിൽ തിരയാൻ സഹായിക്കുന്നു.';

  @override
  String get labelPermWhyNeededHeader => 'എന്തുകൊണ്ട് ആവശ്യമാണ്';

  @override
  String get labelPermWhatItAchievesHeader => 'ഇതുകൊണ്ട് ലഭ്യമാകുന്ന സൗകര്യം';

  @override
  String get labelPermTypeExplicit => 'പ്രത്യേക സൗകര്യം';

  @override
  String get descPermTypeImplicit => 'ഇംപ്ലിസിറ്റ് / സിസ്റ്റം ക്വറി';

  @override
  String get labelPermTypePrivacy => 'സ്വകാര്യത ഉറപ്പ്';

  @override
  String get descPermissionsPrivacyHeader =>
      'സ്വകാര്യതയും സീറോ-പെർമിഷൻ ഉറപ്പുകളും';

  @override
  String get descPermissionsPrivacySubtitle =>
      'മാനിഫെസ്റ്റിൽ നിന്ന് ബോധപൂർവ്വം ഒഴിവാക്കിയ അപകടകരമായ അനുമതികൾ.';

  @override
  String get titlePermBindPrintService => 'BIND_PRINT_SERVICE';

  @override
  String get descPermBindPrintServiceReason =>
      'ആൻഡ്രോയിഡ് സിസ്റ്റത്തിന്റെ അച്ചടി നിരയ്ക്ക് മാത്രം ബന്ധപ്പെടാനാകും വിധം സാങ്കൽപ്പിക അച്ചടി സേവനത്തിന് സുരക്ഷയൊരുക്കുന്നു.';

  @override
  String get descPermBindPrintServiceWhatItAchieves =>
      'അനധികൃത ആപ്പുകൾക്ക് അച്ചടി സേവനം ദുരുപയോഗം ചെയ്യാനോ അച്ചടി ഫയലുകൾ ചോർത്താനോ സാധിക്കില്ലെന്ന് ഉറപ്പാക്കുന്നു.';

  @override
  String get titlePermStoreQueries => 'ആപ്പ് സ്റ്റോർ & വെബ് ക്വറികൾ';

  @override
  String get descPermStoreQueriesReason =>
      'market://, https:// ലിങ്കുകൾ വഴി ഗൂഗിൾ പ്ലേ സ്റ്റോറിലെയും ബ്രൗസറിലെയും ആക്ടിവിറ്റികൾ തിരയുന്നു.';

  @override
  String get descPermStoreQueriesWhatItAchieves =>
      'സ്പീച്ച് സർവീസസ് ലഭ്യമല്ലെങ്കിൽ ഗൂഗിൾ സ്പീച്ച് എൻജിൻ എളുപ്പത്തിൽ ഇൻസ്റ്റാൾ ചെയ്യാൻ സഹായിക്കുന്നു.';

  @override
  String get titlePermViewPdf => 'PDF തുറക്കുന്ന ആപ്പ്';

  @override
  String get descPermViewPdfReason =>
      'PDF ഫയൽ തരങ്ങൾ തുറക്കാനുള്ള ആപ്പായി സിസ്റ്റത്തിൽ രജിസ്റ്റർ ചെയ്യുന്നു.';

  @override
  String get descPermViewPdfWhatItAchieves =>
      'ഫയൽ മാനേജർ, ഡൗൺലോഡ്സ്, ഇമെയിൽ എന്നിവയിൽ നിന്ന് നേരിട്ട് PDF ഫയലുകൾ തുറക്കാൻ സഹായിക്കുന്നു.';

  @override
  String get titlePermPrintManager => 'ആൻഡ്രോയിഡ് അച്ചടി';

  @override
  String get descPermPrintManagerReason =>
      'ആൻഡ്രോയിഡിന്റെ സിസ്റ്റം അച്ചടി നിയന്ത്രണവുമായും അച്ചടി നിരയുമായും സംവദിക്കുന്നു.';

  @override
  String get descPermPrintManagerWhatItAchieves =>
      'യഥാർത്ഥ അച്ചടിയന്ത്രങ്ങളിലേക്ക് അച്ചടിക്കാനും സിസ്റ്റത്തിന്റെ അച്ചടി മുൻകാഴ്ച കാണാനും സഹായിക്കുന്നു.';

  @override
  String get titlePermNoBroadStorage =>
      'സ്റ്റോറേജ് അനുമതി പൂർണ്ണമായി ഒഴിവാക്കി';

  @override
  String get descPermNoBroadStorageReason =>
      'READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, MANAGE_EXTERNAL_STORAGE എന്നിവ ആവശ്യപ്പെടുന്നില്ല.';

  @override
  String get descPermNoBroadStorageWhatItAchieves =>
      'ഉപകരണത്തിലെ മറ്റ് ഫോട്ടോകളും രേഖകളും പൂർണ്ണമായും സുരക്ഷിതമായി നിലനിർത്തുന്നു.';

  @override
  String get titleReadingVelocity => 'വായനാ വേഗതയും സമയവും';

  @override
  String get descReadingVelocitySubtitle =>
      'വായനാ വേഗത അടിസ്ഥാനമാക്കി അധ്യായം തീരാനുള്ള സമയം കണക്കാക്കുന്നു';

  @override
  String labelReadingSpeed(int wpm) {
    return '$wpm wpm';
  }

  @override
  String descReadingTimeLeftChapter(int minutes) {
    return 'അധ്യായത്തിൽ $minutes മിനിറ്റ് ബാക്കി';
  }

  @override
  String labelReadingTimeLeftDoc(int minutes) {
    return '$minutes മിനിറ്റ് ബാക്കി';
  }

  @override
  String get labelReadingTimeLessMinute => '< 1 മിനിറ്റ് ബാക്കി';

  @override
  String get descReadingTimeEstimatesToggle => 'വായനാ സമയ കണക്കുകൂട്ടൽ';

  @override
  String get descReadingTimeEstimatesToggleSubtitle =>
      'റീഡർ ബാറിൽ ശേഷിക്കുന്ന വായനാ സമയം കാണിക്കുക';

  @override
  String get descViewModeAuto => 'സ്വയം (മടക്കാവുന്നവയിൽ രണ്ട് താൾ)';

  @override
  String get descViewModeAutoSubtitle =>
      'ടാബ്‌ലെറ്റുകളിലും മടക്കാവുന്ന സ്ക്രീനുകളിലും സ്വയം രണ്ട് താൾ കാഴ്ചയിലേക്ക് മാറുന്നു';

  @override
  String get titleMalayalamHelper => 'മലയാളം കീബോർഡ് സഹായി';

  @override
  String get tooltipMalayalamHelper => 'മലയാളം ടൈപ്പിംഗ് സഹായി';

  @override
  String get labelMalayalamKeypadTabTranslit => 'മംഗ്ലീഷ്';

  @override
  String get labelMalayalamKeypadTabVowels => 'സ്വരാക്ഷരങ്ങൾ';

  @override
  String get labelMalayalamKeypadTabConsonants => 'വ്യഞ്ജനാക്ഷരങ്ങൾ';

  @override
  String get labelMalayalamKeypadTabSigns => 'ചില്ല് & ചിഹ്നങ്ങൾ';

  @override
  String get titleTtsSentencePause => 'വാക്യങ്ങൾക്കിടയിലെ ഇടവേള';

  @override
  String descTtsSentencePauseSubtitle(String seconds) {
    return 'വാക്യങ്ങൾക്കിടയിൽ $seconds സെക്കൻഡ് ഇടവേള';
  }

  @override
  String descTtsReadingPage(int page) {
    return 'താൾ $page വായിക്കുന്നു...';
  }

  @override
  String get labelTtsPaused => 'താൽക്കാലികമായി നിർത്തി';

  @override
  String descTtsReadyToRead(int page) {
    return 'താൾ $page വായിക്കാൻ തയ്യാറാണ്';
  }

  @override
  String get tooltipTtsReadWholeDocument => 'മുഴുവൻ രേഖ വായിക്കുക';

  @override
  String get tooltipTtsReadThisPage => 'ഈ താൾ മാത്രം വായിക്കുക';

  @override
  String get descTtsDocumentFinished => 'രേഖ മുഴുവൻ വായിച്ചുകഴിഞ്ഞു.';

  @override
  String get actionWatermark => 'കസ്റ്റം വാട്ടർമാർക്ക്';

  @override
  String get descWatermark =>
      'പേജുകളിൽ ടെക്സ്റ്റ് അല്ലെങ്കിൽ ഇമേജ് വാട്ടർമാർക്ക് ചേർക്കുക';

  @override
  String get titleWatermarkDialog => 'കസ്റ്റം വാട്ടർമാർക്ക്';

  @override
  String get labelWatermarkText => 'വാട്ടർമാർക്ക് ടെക്സ്റ്റ്';

  @override
  String get errorWatermarkEmptyText =>
      'ദയവായി വാട്ടർമാർക്ക് ടെക്സ്റ്റ് നൽകുക.';

  @override
  String get titleWatermarkDone => 'വാട്ടർമാർക്ക് ചേർത്ത PDF തയ്യാറായി';

  @override
  String get labelWatermarkOpacity => 'സുതാര്യത (Opacity)';

  @override
  String get labelWatermarkRotation => 'തിരിക്കൽ കോൺ';

  @override
  String get labelWatermarkFontSize => 'അക്ഷര വലിപ്പം';

  @override
  String get labelWatermarkColor => 'നിറം';

  @override
  String get labelWatermarkTiled => 'പേജിലുടനീളം ആവർത്തിക്കുക (Tile)';

  @override
  String get descWatermarkTiled =>
      'മുഴുവൻ പേജിലും വാട്ടർമാർക്ക് ആവർത്തിച്ച് നൽകുന്നു';

  @override
  String get labelWatermarkPageRange => 'ബാധകമാക്കേണ്ട പേജുകൾ';

  @override
  String get labelWatermarkAllPages => 'എല്ലാ പേജുകളും';

  @override
  String get labelWatermarkOddPages => 'ഒറ്റയക്ക പേജുകൾ മാത്രം';

  @override
  String get labelWatermarkEvenPages => 'ഇരട്ടയക്ക പേജുകൾ മാത്രം';

  @override
  String get actionWatermarkApply => 'വാട്ടർമാർക്ക് ചേർക്കുക';

  @override
  String get titleBatchOperations => 'ബാച്ച് പ്രവർത്തനങ്ങൾ';

  @override
  String get descBatchOperations =>
      'ഒന്നിലധികം PDF ഫയലുകൾ ഒരേസമയം പ്രോസസ്സ് ചെയ്യുക';

  @override
  String get labelBatchOperation => 'പ്രവർത്തനം തിരഞ്ഞെടുക്കുക';

  @override
  String get descBatchOpEncrypt => 'ബാച്ച് എൻക്രിപ്റ്റ് / ലോക്ക് ചെയ്യുക';

  @override
  String get labelBatchOpMerge => 'ബാച്ച് ലയനം (Merge)';

  @override
  String get descBatchOpExtractText => 'ബാച്ച് ടെക്സ്റ്റ് എക്സ്ട്രാക്ഷൻ (.txt)';

  @override
  String get labelBatchOpTrimMargins => 'ബാച്ച് മാർജിൻ ട്രിം ചെയ്യുക';

  @override
  String get labelBatchOpCompress => 'ബാച്ച് കംപ്രസ് ചെയ്യുക';

  @override
  String descBatchSelectedFilesCount(int count) {
    return 'തിരഞ്ഞെടുത്ത ഫയലുകൾ ($count)';
  }

  @override
  String get actionBatchAddFiles => 'ഫയലുകൾ ചേർക്കുക';

  @override
  String get descBatchNoFilesSelected =>
      'PDF ഫയലുകൾ തിരഞ്ഞെടുത്തിട്ടില്ല. ചേർക്കാൻ \'ഫയലുകൾ ചേർക്കുക\' ടാപ്പ് ചെയ്യുക.';

  @override
  String descBatchProgress(int current, int total, String name) {
    return 'പ്രോസസ്സ് ചെയ്യുന്നു ($current/$total): $name';
  }

  @override
  String get actionBatchStart => 'ബാച്ച് പ്രവർത്തനം ആരംഭിക്കുക';

  @override
  String descBatchDoneSummary(int success, int total) {
    return '$total ഡോക്യുമെന്റുകളിൽ $success എണ്ണം വിജയകരമായി പ്രോസസ്സ് ചെയ്തു.';
  }

  @override
  String get descBatchFailedAll =>
      'എല്ലാ ഡോക്യുമെന്റുകളുടെയും ബാച്ച് പ്രോസസ്സിംഗ് പരാജയപ്പെട്ടു.';

  @override
  String get actionNUp => 'ഒരു ഷീറ്റിൽ പല താളുകൾ';

  @override
  String get descNUp =>
      'ഓരോ ഷീറ്റിലും 2, 4, 6, അല്ലെങ്കിൽ 9 പേജുകൾ വീതം ഉൾപ്പെടുത്തുക';

  @override
  String get titleNUpDialog => 'ഒരു ഷീറ്റിൽ പല താളുകൾ';

  @override
  String get labelNUpGrid => 'ഗ്രിഡ് ലേഔട്ട്';

  @override
  String get labelNUpSheetSize => 'ഷീറ്റ് വലിപ്പം';

  @override
  String get labelNUpSheetA4 => 'A4';

  @override
  String get labelNUpSheetLetter => 'US Letter';

  @override
  String get labelNUpOrientation => 'ഷീറ്റ് ഓറിയന്റേഷൻ';

  @override
  String get labelNUpOrientationAuto => 'ഓട്ടോ';

  @override
  String get labelNUpOrientationPortrait => 'പോർട്രെയ്റ്റ്';

  @override
  String get labelNUpOrientationLandscape => 'ലാൻഡ്‌സ്കേപ്പ്';

  @override
  String get labelNUpBorders => 'താൾ അതിരുകൾ വരയ്ക്കുക';

  @override
  String get descNUpBorders => 'ഓരോ താളിനും ചുറ്റും അതിർത്തി രേഖ വരയ്ക്കുന്നു';

  @override
  String get labelNUpMargin => 'മാർജിൻ സ്പേസ്';

  @override
  String get titleNUpDone => 'N-Up PDF തയ്യാറായി';

  @override
  String get actionPrintNUp => 'പല താളുകൾ അച്ചടിക്കുക';

  @override
  String get descPrintNUp =>
      'ഒരു ഷീറ്റിൽ ഒന്നിലധികം പേജുകൾ അച്ചടിക്കുക (2-in-1, 4-in-1, etc.)';

  @override
  String get titleCleanWebContent => 'വെബ് കണ്ടന്റ് ക്ലീനർ (റീഡർ മോഡ്)';

  @override
  String get descCleanWebContentSubtitle =>
      'സൂക്ഷിക്കുന്നതിന് മുമ്പ് ഹെഡറുകൾ, ഫൂട്ടറുകൾ, പരസ്യങ്ങൾ എന്നിവ നീക്കം ചെയ്യുന്നു';

  @override
  String descPagesDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count താളുകൾ നീക്കം ചെയ്തു',
      one: '1 താൾ നീക്കം ചെയ്തു',
    );
    return '$_temp0';
  }

  @override
  String descOrganizeSelectedCount(int count) {
    return '$count എണ്ണം തിരഞ്ഞെടുത്തു';
  }

  @override
  String get actionSelectAll => 'എല്ലാം തിരഞ്ഞെടുക്കുക';

  @override
  String get actionDeselectAll => 'തിരഞ്ഞെടുക്കൽ ഒഴിവാക്കുക';

  @override
  String get actionInvertSelection => 'തിരഞ്ഞെടുക്കൽ വിപരീതമാക്കുക';

  @override
  String get actionTrustStoreExport => 'കയറ്റുമതി ചെയ്യുക';

  @override
  String get actionTrustStoreExportAll => 'എല്ലാം കയറ്റുമതി ചെയ്യുക';

  @override
  String descTrustStoreExportSuccess(String name) {
    return 'സർട്ടിഫിക്കറ്റ് $name എന്നതിലേക്ക് കയറ്റുമതി ചെയ്തു';
  }

  @override
  String get actionSignatureTrustSigner => 'സൈനറെ വിശ്വസിക്കുക';

  @override
  String get labelSignatureUnnamed => 'ഡിജിറ്റൽ ഒപ്പ്';

  @override
  String get labelSignatureTime => 'ഒപ്പിട്ട സമയം';

  @override
  String get labelSignatureTimeClaimOnly => 'സ്ഥിരീകരിക്കാത്ത അവകാശവാദം';

  @override
  String get labelSignatureIntegrity => 'ഡോക്യുമെന്റ് കൃത്യത';

  @override
  String get descSignatureIntegrityValid =>
      'ഒപ്പിട്ടതിന് ശേഷം ഡോക്യുമെന്റിൽ മാറ്റം വരുത്തിയിട്ടില്ല';

  @override
  String get descSignatureIntegrityInvalid =>
      'ഒപ്പിട്ടതിന് ശേഷം ഡോക്യുമെന്റിൽ മാറ്റം വരുത്തിയിട്ടുണ്ട്';

  @override
  String get descSignatureIntegrityUnknown =>
      'ഡോക്യുമെന്റ് കൃത്യത പരിശോധിക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get labelSignatureCoverage => 'ബൈറ്റ് പരിധി';

  @override
  String get descSignatureCoversWholeFile =>
      'മുഴുവൻ ഡോക്യുമെന്റും ഒപ്പിൽ ഉൾപ്പെടുന്നു';

  @override
  String get descSignatureCoversPartialFile =>
      'ഡോക്യുമെന്റിന്റെ ഒരു ഭാഗം മാത്രമേ ഒപ്പിൽ ഉൾപ്പെടുന്നുള്ളൂ';

  @override
  String get descSignatureCertificateHeader => 'സൈനർ സർട്ടിഫിക്കറ്റ് വിവരങ്ങൾ';

  @override
  String get titleFeatures => 'ഫീച്ചറുകൾ';

  @override
  String get descFeaturesSubtitle => 'ഗ്രന്ഥം ആപ്പിലെ എല്ലാ സവിശേഷതകളും അറിയുക';

  @override
  String get titleFeaturesHeader => 'ഗ്രന്ഥം ആപ്പ് ഫീച്ചറുകൾ';

  @override
  String get descFeaturesHeaderSubtitle =>
      'നിങ്ങൾക്കായി രൂപകൽപ്പന ചെയ്ത എല്ലാ ടൂളുകളും, സുരക്ഷാ സംവിധാനങ്ങളും, ഫീച്ചറുകളും പരിശോധിക്കുക.';

  @override
  String get descFeaturesCategoryViewing => 'PDF വായനയും നാവിഗേഷനും';

  @override
  String get descFeaturesCategoryViewingSubtitle =>
      'വേഗതയേറിയ റെൻഡറിംഗ്, സ്ക്രോളിംഗ്, ബുക്ക് വ്യൂ, സ്മാർട്ട് നാവിഗേഷൻ';

  @override
  String get descFeaturesCategorySearch =>
      'തിരച്ചിൽ, ഇൻഡിക് സ്വരസന്ധി & സ്പീച്ച്';

  @override
  String get descFeaturesCategorySearchSubtitle =>
      'സന്ധി തിരിച്ചറിയുന്ന തിരച്ചിൽ, മലയാളം ടൈപ്പിംഗ്, ടെക്സ്റ്റ്-ടു-സ്പീച്ച്';

  @override
  String get descFeaturesCategoryAnnotations =>
      'അടയാളപ്പെടുത്തലുകളും കുറിപ്പുകളും';

  @override
  String get descFeaturesCategoryAnnotationsSubtitle =>
      'ഹൈലൈറ്റുകൾ, കൈയെഴുത്ത് വരകൾ, ഒട്ടുകുറിപ്പുകൾ, കയറ്റുമതി';

  @override
  String get descFeaturesCategoryPageOps => 'താൾ ക്രമീകരണങ്ങളും മാറ്റങ്ങളും';

  @override
  String get descFeaturesCategoryPageOpsSubtitle =>
      'താൾ പുനഃക്രമീകരണം, ബുക്ക്‌ലെറ്റ്, ജലമുദ്ര, കൂട്ട പ്രവർത്തനങ്ങൾ';

  @override
  String get descFeaturesCategoryExtraction =>
      'ഡാറ്റ വേർതിരിച്ചെടുക്കലും ടൂളുകളും';

  @override
  String get descFeaturesCategoryExtractionSubtitle =>
      'ടെക്സ്റ്റ്, ചിത്രങ്ങൾ, ഫോം ഫീൽഡുകൾ, മെറ്റാഡാറ്റ എന്നിവ വേർതിരിക്കൽ';

  @override
  String get descFeaturesCategoryPrinter =>
      'സാങ്കൽപ്പിക അച്ചടിയന്ത്രവും പങ്കിടലും';

  @override
  String get descFeaturesCategoryPrinterSubtitle =>
      'സിസ്റ്റം അച്ചടിയന്ത്രം, വെബ് ശുചീകരണം, ചിത്രം/പാഠം PDF ആക്കൽ';

  @override
  String get descFeaturesCategorySignatures =>
      'ഡിജിറ്റൽ ഒപ്പുകളും ട്രസ്റ്റ് സ്റ്റോറും';

  @override
  String get descFeaturesCategorySignaturesSubtitle =>
      'ഓഫ്‌ലൈൻ ഒപ്പ് പരിശോധന, വിഷ്വൽ ബാഡ്ജുകൾ, സർട്ടിഫിക്കറ്റ് മാനേജർ';

  @override
  String get descFeaturesCategoryThemes => 'തീമുകളും ക്രമീകരണങ്ങളും';

  @override
  String get descFeaturesCategoryThemesSubtitle =>
      'OLED ഇരുണ്ട രൂപം, അക്ഷരരൂപങ്ങൾ, പ്രധാന നിറം, വിശദമായ ക്രമീകരണങ്ങൾ';

  @override
  String get labelFeaturesCategoryGuides => 'ഉപയോക്തൃ സഹായ ഗൈഡുകൾ';

  @override
  String get descFeaturesCategoryGuidesSubtitle =>
      'വിശദമായ ഓഫ്‌ലൈൻ ട്യൂട്ടോറിയലുകളും നിർദ്ദേശങ്ങളും';

  @override
  String get helpHeaderTitle => 'സഹായ കേന്ദ്രവും വഴികാട്ടിയും';

  @override
  String get helpHeaderSubtitle =>
      'ഗ്രന്ഥം ആപ്പിന്റെ എല്ലാ സവിശേഷതകളെയും കുറിച്ചുള്ള സമഗ്രമായ ഗൈഡുകൾ.';

  @override
  String get helpSectionPrinting => 'പ്രിന്റിംഗും പരിവർത്തനവും';

  @override
  String get helpSectionReading => 'വായനയും ശബ്ദവും';

  @override
  String get helpSectionPageOps => 'ഡോക്യുമെന്റ് പ്രവർത്തനങ്ങൾ';

  @override
  String get helpSectionSecurity => 'സുരക്ഷയും സ്വകാര്യതയും';

  @override
  String get labelAboutVersion => 'പതിപ്പ്';

  @override
  String get labelAboutBuildDate => 'ബിൽഡ് തീയതി';

  @override
  String get labelImageFormatPngLossless => 'PNG (നഷ്ടരഹിതം)';

  @override
  String get labelImageFormatJpeg => 'JPEG';

  @override
  String labelNUpPagesPerSheet(int count) {
    return 'ഒന്നിൽ $count';
  }

  @override
  String labelPageJumpRangeHint(int min, int max) {
    return '$min – $max';
  }

  @override
  String get aboutDetailAuthor => 'രചയിതാവ്';

  @override
  String get aboutDetailEmail => 'ഇമെയിൽ';

  @override
  String get aboutDetailLicense => 'ലൈസൻസ്';

  @override
  String get aboutDetailAiUsed => 'ഉപയോഗിച്ച AI';

  @override
  String get aboutDetailIdeUsed => 'ഉപയോഗിച്ച IDE';

  @override
  String madeWithLove(String heart) {
    return 'സ്നേഹത്തോടെ $heart ഇന്ത്യയിൽ നിന്ന്';
  }

  @override
  String get madeWithLoveA11y => 'സ്നേഹത്തോടെ ഇന്ത്യയിൽ നിന്ന്';

  @override
  String get tooltipMenu => 'മെനു';

  @override
  String get tooltipShowPassword => 'പാസ്‌വേഡ് കാണിക്കുക';

  @override
  String get tooltipHidePassword => 'പാസ്‌വേഡ് മറയ്ക്കുക';

  @override
  String get labelColorYellow => 'മഞ്ഞ';

  @override
  String get labelColorGreen => 'പച്ച';

  @override
  String get labelColorBlue => 'നീല';

  @override
  String get labelColorRed => 'ചുവപ്പ്';

  @override
  String get labelColorPurple => 'വയലറ്റ്';

  @override
  String get labelColorOrange => 'ഓറഞ്ച്';

  @override
  String descAboutVersionBuild(String version, String build) {
    return '$version (നിർമ്മിതി $build)';
  }

  @override
  String get actionClose => 'അടയ്ക്കുക';

  @override
  String get actionRemove => 'നീക്കം ചെയ്യുക';

  @override
  String get tooltipRotateScreen => 'സ്ക്രീൻ തിരിക്കുക';

  @override
  String get titleScreenOrientation => 'സ്ക്രീൻ ഓറിയന്റേഷൻ';

  @override
  String get errorScreenFallback =>
      'ഈ സ്ക്രീനിൽ ഒരു പിശക് സംഭവിച്ചു. ദയവായി പിന്നോട്ട് പോയി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorInvalidCertificate =>
      'ഈ ഫയൽ ആപ്പിന് വായിക്കാൻ കഴിയുന്ന ഒരു സർട്ടിഫിക്കറ്റ് അല്ല.';

  @override
  String get errorCertificateExport =>
      'സർട്ടിഫിക്കറ്റ് കയറ്റുമതി ചെയ്യാൻ കഴിഞ്ഞില്ല.';

  @override
  String get errorTrustStoreLoad =>
      'വിശ്വസിച്ച സർട്ടിഫിക്കറ്റുകൾ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല.';

  @override
  String get errorImportBuild =>
      'PDF ഉണ്ടാക്കുന്നതിനിടെ ഒരു പിശക് സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get helpFeatureRenderingTitle => 'അതിവേഗ താൾ പ്രദർശനം';

  @override
  String get helpFeatureRenderingBody =>
      'നേറ്റീവ് pdfium എഞ്ചിൻ ഉപയോഗിച്ച് PDF താളുകൾ വേഗത്തിലും വ്യക്തമായും കാണിക്കുന്നു; നെറ്റ്‌വർക്ക് ആവശ്യമില്ല.';

  @override
  String get helpFeatureRenderingTag1 => 'pdfium എഞ്ചിൻ';

  @override
  String get helpFeatureRenderingTag2 => 'വ്യക്തമായ വലുതാക്കൽ';

  @override
  String get helpFeatureRenderingTag3 => 'ഓഫ്‌ലൈനിലും വേഗം';

  @override
  String get helpFeatureViewModesTitle => 'വിവിധ കാഴ്ചാരീതികൾ';

  @override
  String get helpFeatureViewModesBody =>
      'ഒറ്റ താൾ, തുടർച്ചയായ ലംബ സ്ക്രോൾ, രണ്ടു താളുള്ള പുസ്തകക്കാഴ്ച എന്നിവയ്ക്കിടയിൽ മാറാം; വീതിക്ക് ഒതുക്കുക, താളിന് ഒതുക്കുക എന്നീ സൗകര്യങ്ങളും ഉണ്ട്.';

  @override
  String get helpFeatureViewModesTag1 => 'ഒറ്റ താൾ';

  @override
  String get helpFeatureViewModesTag2 => 'തുടർച്ചയായ സ്ക്രോൾ';

  @override
  String get helpFeatureViewModesTag3 => 'പുസ്തകക്കാഴ്ച';

  @override
  String get helpFeatureViewModesTag4 => 'ഒതുക്കൽ രീതികൾ';

  @override
  String get helpFeatureFoldableTitle => 'മടക്കാവുന്ന, ഇരട്ട സ്ക്രീൻ പിന്തുണ';

  @override
  String get helpFeatureFoldableBody =>
      'മടക്കാവുന്ന ഫോണുകളിലും ടാബ്‌ലെറ്റുകളിലും, മടക്കുഭാഗത്തെ വിടവ് കണക്കിലെടുത്ത് രണ്ടു താളുകൾ ഒരുമിച്ച് കാണിക്കുന്നു.';

  @override
  String get helpFeatureFoldableTag1 => 'മടക്ക് തിരിച്ചറിയൽ';

  @override
  String get helpFeatureFoldableTag2 => 'മടക്കുവിടവ്';

  @override
  String get helpFeatureFoldableTag3 => 'ടാബ്‌ലെറ്റിന് അനുയോജ്യം';

  @override
  String get helpFeatureVelocityTitle => 'വായനാവേഗവും സമയ കണക്കും';

  @override
  String get helpFeatureVelocityBody =>
      'വായനയുടെ വേഗം തത്സമയം അളന്ന്, അധ്യായങ്ങൾക്കും മുഴുവൻ രേഖയ്ക്കും ബാക്കിയുള്ള വായനാസമയം കണക്കാക്കുന്നു.';

  @override
  String get helpFeatureVelocityTag1 => 'മിനിറ്റിലെ വാക്കുകൾ';

  @override
  String get helpFeatureVelocityTag2 => 'അധ്യായ കണക്ക്';

  @override
  String get helpFeatureVelocityTag3 => 'ആകെ സമയം';

  @override
  String get helpFeatureThumbnailsTitle =>
      'ലഘുചിത്ര നിരയും നേരിട്ടുള്ള പോക്കും';

  @override
  String get helpFeatureThumbnailsBody =>
      'രേഖയിലെ എല്ലാ താളുകളും ഒരു ലഘുചിത്ര നിരയിൽ വേഗം കാണാം, അല്ലെങ്കിൽ ഏത് താൾ സംഖ്യയിലേക്കും നേരിട്ട് പോകാം.';

  @override
  String get helpFeatureThumbnailsTag1 => 'ലഘുചിത്ര നിര';

  @override
  String get helpFeatureThumbnailsTag2 => 'താളുകളിലൂടെ നീക്കൽ';

  @override
  String get helpFeatureThumbnailsTag3 => 'വേഗത്തിൽ പോകൽ';

  @override
  String get helpFeatureOutlineTitle => 'ഉള്ളടക്കപ്പട്ടികയും അടയാളങ്ങളും';

  @override
  String get helpFeatureOutlineBody =>
      'രേഖയുടെ ഉള്ളടക്കപ്പട്ടിക തട്ടുകളായി കാണാം, ഒറ്റ സ്പർശത്തിൽ ഭാഗങ്ങളിലേക്ക് പോകാം, താളുകൾ അടയാളപ്പെടുത്താം.';

  @override
  String get helpFeatureOutlineTag1 => 'ഉള്ളടക്കത്തട്ടുകൾ';

  @override
  String get helpFeatureOutlineTag2 => 'ഒറ്റ സ്പർശ ചാട്ടം';

  @override
  String get helpFeatureOutlineTag3 => 'താൾ അടയാളങ്ങൾ';

  @override
  String get helpFeatureFingerprintTitle =>
      'ഉള്ളടക്ക വിരലടയാളവും സമീപകാല ഫയലുകളും';

  @override
  String get helpFeatureFingerprintBody =>
      'ഫയലിന്റെ പേര് മാറ്റിയാലും സ്ഥലം മാറ്റിയാലും, SHA-256 വിരലടയാളം വഴി വായനാസ്ഥാനം, വലുതാക്കൽ നില, കുറിപ്പുകൾ എന്നിവ നിലനിർത്തുന്നു.';

  @override
  String get helpFeatureFingerprintTag1 => 'SHA-256 വിരലടയാളം';

  @override
  String get helpFeatureFingerprintTag2 => 'അവസാനം വായിച്ച സ്ഥാനം';

  @override
  String get helpFeatureFingerprintTag3 => 'സമീപകാല ഫയലുകൾ';

  @override
  String get helpFeatureSearchTitle => 'താളിലെ പൂർണ്ണ പാഠ തിരച്ചിൽ';

  @override
  String get helpFeatureSearchBody =>
      'പൊരുത്തങ്ങളുടെ എണ്ണം, തിളക്കമുള്ള അടയാളപ്പെടുത്തൽ, അക്ഷരക്കൂട്ടങ്ങൾക്ക് ഒത്ത നീക്കം എന്നിവയോടെ ഉടനടി വാക്കുകൾ തിരയാം.';

  @override
  String get helpFeatureSearchTag1 => 'ഉടനടി തിരച്ചിൽ';

  @override
  String get helpFeatureSearchTag2 => 'പൊരുത്ത എണ്ണം';

  @override
  String get helpFeatureSearchTag3 => 'അക്ഷരക്കൂട്ട ക്രമീകരണം';

  @override
  String get helpFeatureSandhiTitle => 'സന്ധി അറിയുന്ന ഭാരതീയ ഭാഷാ തിരച്ചിൽ';

  @override
  String get helpFeatureSandhiBody =>
      'മലയാളം, സംസ്കൃതം, ദേവനാഗരി നിയമങ്ങൾ പാലിച്ച് സന്ധി ചേർന്ന പദങ്ങൾ പിരിക്കുകയും ചേർക്കുകയും ചെയ്യുന്നു.';

  @override
  String get helpFeatureSandhiTag1 => 'സന്ധി പിരിക്കൽ';

  @override
  String get helpFeatureSandhiTag2 => 'പദം ചേർക്കൽ';

  @override
  String get helpFeatureSandhiTag3 => 'സംസ്കൃതം, മലയാളം';

  @override
  String get helpFeaturePhoneticTitle => 'ഭാരതീയ ഉച്ചാരണ സാമ്യ തിരച്ചിൽ';

  @override
  String get helpFeaturePhoneticBody =>
      'അനുസ്വാര-അനുനാസിക കൂട്ടക്ഷരങ്ങൾ, ചില്ലും ചന്ദ്രക്കലയും, ന്റ കൂട്ടക്ഷരം, സംവൃതോകാരം എന്നിവ ഏകീകരിക്കുന്നു.';

  @override
  String get helpFeaturePhoneticTag1 => 'ഉച്ചാരണ സാമ്യം';

  @override
  String get helpFeaturePhoneticTag2 => 'ചില്ല് ഏകീകരണം';

  @override
  String get helpFeaturePhoneticTag3 => 'NFC ഏകീകരണം';

  @override
  String get helpFeatureMalayalamInputTitle => 'മലയാളം എഴുത്തുസഹായിയും കീപാഡും';

  @override
  String get helpFeatureMalayalamInputBody =>
      'മംഗ്ലീഷിൽ ടൈപ്പ് ചെയ്യുമ്പോൾ തത്സമയ മലയാളം നിർദ്ദേശങ്ങളും, സ്വരം, വ്യഞ്ജനം, ചിഹ്നം എന്നിവയ്ക്കായി മൂന്നു ടാബുള്ള കീപാഡും.';

  @override
  String get helpFeatureMalayalamInputTag1 => 'മംഗ്ലീഷ് നിർദ്ദേശങ്ങൾ';

  @override
  String get helpFeatureMalayalamInputTag2 => 'ഓൺസ്ക്രീൻ കീപാഡ്';

  @override
  String get helpFeatureMalayalamInputTag3 => 'അധിക ക്രമീകരണമില്ല';

  @override
  String get helpFeatureTtsTitle => 'ഓഫ്‌ലൈൻ വായിച്ചുകേൾപ്പിക്കൽ (TTS)';

  @override
  String get helpFeatureTtsBody =>
      'PDF പാഠം ഇംഗ്ലീഷിലും മലയാളത്തിലും ഉറക്കെ വായിക്കുന്നു; സംസാരവേഗം, സ്വരസ്ഥായി, വാക്യാന്ത ഇടവേള എന്നിവ ക്രമീകരിക്കാം, മീഡിയ അറിയിപ്പുകളും ഉണ്ട്.';

  @override
  String get helpFeatureTtsTag1 => 'ഇംഗ്ലീഷ്, മലയാളം';

  @override
  String get helpFeatureTtsTag2 => 'വേഗവും സ്ഥായിയും';

  @override
  String get helpFeatureTtsTag3 => 'പശ്ചാത്തലത്തിലും വായന';

  @override
  String get helpFeatureMarkupsTitle => 'പാഠം അടയാളപ്പെടുത്തലും നിറങ്ങളും';

  @override
  String get helpFeatureMarkupsBody =>
      'ഏഴ് തിളക്കമുള്ള നിറങ്ങളും മാറ്റാവുന്ന സുതാര്യതയും ഉപയോഗിച്ച് പാഠം എടുത്തുകാട്ടാം, അടിവരയിടാം, വെട്ടിക്കളയാം.';

  @override
  String get helpFeatureMarkupsTag1 => 'എടുത്തുകാട്ടൽ';

  @override
  String get helpFeatureMarkupsTag2 => 'അടിവര';

  @override
  String get helpFeatureMarkupsTag3 => 'വെട്ടിക്കളയൽ';

  @override
  String get helpFeatureMarkupsTag4 => '7 നിറങ്ങൾ';

  @override
  String get helpFeatureInkTitle => 'കൈയെഴുത്ത് വരയും ഒട്ടുകുറിപ്പുകളും';

  @override
  String get helpFeatureInkBody =>
      'പേന ഉപകരണം കൊണ്ട് സുഗമമായി വരയ്ക്കാം; നീക്കാവുന്ന ഒട്ടുകുറിപ്പുകൾ താളിൽ എവിടെയും പതിപ്പിക്കാം.';

  @override
  String get helpFeatureInkTag1 => 'കൈയെഴുത്ത് വര';

  @override
  String get helpFeatureInkTag2 => 'പതിച്ച കുറിപ്പുകൾ';

  @override
  String get helpFeatureInkTag3 => 'മായ്ക്കൽ ഉപകരണം';

  @override
  String get helpFeatureFlattenTitle =>
      'കുറിപ്പുകൾ ഉറപ്പിച്ച് കയറ്റുമതി ചെയ്യൽ';

  @override
  String get helpFeatureFlattenBody =>
      'കുറിപ്പുകൾ സാധാരണ PDF അടയാള രൂപത്തിൽ, രേഖയുടെ ഒരു പുതിയ പകർപ്പിലേക്ക് സ്ഥിരമായി കയറ്റുമതി ചെയ്യുന്നു.';

  @override
  String get helpFeatureFlattenTag1 => 'പുതിയ പകർപ്പിൽ മാത്രം';

  @override
  String get helpFeatureFlattenTag2 => 'സാധാരണ PDF അടയാളങ്ങൾ';

  @override
  String get helpFeatureFlattenTag3 => 'മൂലഫയൽ സുരക്ഷിതം';

  @override
  String get helpFeatureOrganizeTitle => 'താളുകൾ ക്രമീകരിക്കാനുള്ള ദൃശ്യനിര';

  @override
  String get helpFeatureOrganizeBody =>
      'വലിച്ചിട്ട് താളുകളുടെ ക്രമം മാറ്റാം, 90 ഡിഗ്രി തിരിക്കാം, ഇല്ലാതാക്കാം; പലതും ഒരുമിച്ച് തിരഞ്ഞെടുക്കാം.';

  @override
  String get helpFeatureOrganizeTag1 => 'വലിച്ചിടൽ';

  @override
  String get helpFeatureOrganizeTag2 => 'തിരിക്കലും ഇല്ലാതാക്കലും';

  @override
  String get helpFeatureOrganizeTag3 => 'ഒന്നിലേറെ തിരഞ്ഞെടുക്കൽ';

  @override
  String get helpFeatureWatermarkTitle => 'ഇഷ്ടാനുസൃത ജലമുദ്രകൾ';

  @override
  String get helpFeatureWatermarkBody =>
      'സുതാര്യത, നിറം, ആവർത്തിക്കുന്ന നിരവിന്യാസം എന്നിവയോടെ ചരിഞ്ഞോ നേരെയോ ഉള്ള പാഠ ജലമുദ്രകൾ ചേർക്കാം.';

  @override
  String get helpFeatureWatermarkTag1 => 'ഇഷ്ടമുള്ള പാഠം';

  @override
  String get helpFeatureWatermarkTag2 => 'സുതാര്യതയും കോണും';

  @override
  String get helpFeatureWatermarkTag3 => 'നിരയായി ആവർത്തനം';

  @override
  String get helpFeatureNUpTitle => 'ഒരു ഷീറ്റിൽ പല താളുകൾ';

  @override
  String get helpFeatureNUpBody =>
      'A4 അല്ലെങ്കിൽ Letter കടലാസിന്റെ ഓരോ ഷീറ്റിലും 2, 4, 6, അല്ലെങ്കിൽ 9 താളുകൾ; അതിരുകളും അരികുകളും മാറ്റാം.';

  @override
  String get helpFeatureNUpTag1 => '2/4/6/9 താളുകൾ';

  @override
  String get helpFeatureNUpTag2 => 'താൾ അതിരുകൾ';

  @override
  String get helpFeatureNUpTag3 => 'ഷീറ്റിന്റെ ദിശ';

  @override
  String get helpFeatureBookletTitle => 'അച്ചടിക്കാവുന്ന ലഘുപുസ്തക നിർമ്മാണം';

  @override
  String get helpFeatureBookletBody =>
      'മടക്കി നടുവിൽ തുന്നാവുന്ന ലഘുപുസ്തക ക്രമത്തിൽ താളുകൾ ഒരുക്കുന്നു; 4 താളിന്റെ ഗുണിതമാക്കാൻ ശൂന്യതാളുകൾ സ്വയം ചേർക്കുന്നു.';

  @override
  String get helpFeatureBookletTag1 => 'നടുത്തുന്നൽ';

  @override
  String get helpFeatureBookletTag2 => 'മടക്കുവരകൾ';

  @override
  String get helpFeatureBookletTag3 => 'സ്വയം ശൂന്യതാൾ';

  @override
  String get helpFeatureMergeSplitTitle => 'ലയിപ്പിക്കൽ, വിഭജനം, ചുരുക്കൽ';

  @override
  String get helpFeatureMergeSplitBody =>
      'പല PDF-കൾ ഒന്നാക്കാം, താളുകൾ വെവ്വേറെ ഫയലുകളാക്കാം, ഫയൽ വലുപ്പം കുറയ്ക്കാൻ PDF ചുരുക്കാം.';

  @override
  String get helpFeatureMergeSplitTag1 => 'പലതും ഒന്നാക്കൽ';

  @override
  String get helpFeatureMergeSplitTag2 => 'താൾ വിഭജനം';

  @override
  String get helpFeatureMergeSplitTag3 => 'ബുദ്ധിപരമായ ചുരുക്കൽ';

  @override
  String get helpFeatureEncryptionTitle => 'PDF പൂട്ടലും തുറക്കലും';

  @override
  String get helpFeatureEncryptionBody =>
      'AES-256 പാസ്‌വേഡ് കൊണ്ട് രേഖകൾ സംരക്ഷിക്കാം, അല്ലെങ്കിൽ പൂട്ടിയ ഫയലുകൾ തുറന്ന് പൂട്ടില്ലാത്ത പകർപ്പാക്കാം.';

  @override
  String get helpFeatureEncryptionTag1 => 'AES-256 സംരക്ഷണം';

  @override
  String get helpFeatureEncryptionTag2 => 'ഉടമ പാസ്‌വേഡ്';

  @override
  String get helpFeatureEncryptionTag3 => 'പൂട്ട് നീക്കൽ';

  @override
  String get helpFeatureBatchTitle => 'കൂട്ടമായ പ്രവർത്തനങ്ങൾ';

  @override
  String get helpFeatureBatchBody =>
      'ജലമുദ്ര, ചുരുക്കൽ, പൂട്ടൽ, പൂട്ട് നീക്കൽ, വേർതിരിക്കൽ എന്നിവ പല ഫയലുകളിൽ ഒരേസമയം ചെയ്യാം.';

  @override
  String get helpFeatureBatchTag1 => 'പല ഫയലുകൾ ഒരുമിച്ച്';

  @override
  String get helpFeatureBatchTag2 => 'ഘട്ടം തിരിച്ചുള്ള പുരോഗതി';

  @override
  String get helpFeatureBatchTag3 => 'SAF വഴി സൂക്ഷിക്കൽ';

  @override
  String get helpFeatureExtractionTitle => 'പാഠവും ചിത്രങ്ങളും വേർതിരിക്കൽ';

  @override
  String get helpFeatureExtractionBody =>
      'ഏത് താൾ പരിധിയിൽ നിന്നും ലളിത പാഠം വേർതിരിക്കാം, ഉള്ളിലെ PNG/JPEG ചിത്രങ്ങൾ ഗുണം കുറയാതെ സൂക്ഷിക്കാം.';

  @override
  String get helpFeatureExtractionTag1 => 'ലളിത പാഠം';

  @override
  String get helpFeatureExtractionTag2 => 'ഉള്ളിലെ ചിത്രങ്ങൾ';

  @override
  String get helpFeatureExtractionTag3 => 'താൾ പരിധികൾ';

  @override
  String get helpFeatureFormFieldsTitle => 'ഫോം കളങ്ങളുടെ പരിശോധന';

  @override
  String get helpFeatureFormFieldsBody =>
      'ഫോമിലെ കളങ്ങളുടെ മൂല്യങ്ങൾ, ചെക്ക്ബോക്സുകൾ, റേഡിയോ കൂട്ടങ്ങൾ എന്നിവ കണ്ടെത്തി പരിശോധിക്കാം, JSON ആയി കയറ്റുമതി ചെയ്യാം.';

  @override
  String get helpFeatureFormFieldsTag1 => 'ഫോം വായന';

  @override
  String get helpFeatureFormFieldsTag2 => 'JSON കയറ്റുമതി';

  @override
  String get helpFeatureFormFieldsTag3 => 'കള പരിശോധന';

  @override
  String get helpFeatureRenderImagesTitle => 'താളുകൾ ഉയർന്ന DPI ചിത്രങ്ങളാക്കൽ';

  @override
  String get helpFeatureRenderImagesBody =>
      'PDF താളുകൾ 300 DPI വരെ മാറ്റാവുന്ന വ്യക്തതയിൽ PNG അല്ലെങ്കിൽ JPEG ചിത്രങ്ങളായി കയറ്റുമതി ചെയ്യാം.';

  @override
  String get helpFeatureRenderImagesTag1 => 'ഉയർന്ന DPI PNG/JPEG';

  @override
  String get helpFeatureRenderImagesTag2 => '100 മുതൽ 300 DPI വരെ';

  @override
  String get helpFeatureRenderImagesTag3 => 'കൂട്ടമായി ചിത്രീകരണം';

  @override
  String get helpFeatureMetadataTitle => 'രേഖാവിവരങ്ങളുടെ പരിശോധന';

  @override
  String get helpFeatureMetadataBody =>
      'ശീർഷകം, രചയിതാവ്, നിർമ്മാതാവ്, നിർമ്മിച്ച തീയതി, പൂട്ട് നില എന്നിവയുൾപ്പെടെ രേഖയുടെ വിശദാംശങ്ങൾ കാണാം.';

  @override
  String get helpFeatureMetadataTag1 => 'PDF വിവരങ്ങൾ';

  @override
  String get helpFeatureMetadataTag2 => 'നിർമ്മിച്ച തീയതി';

  @override
  String get helpFeatureMetadataTag3 => 'സുരക്ഷാ നില';

  @override
  String get helpFeatureVirtualPrinterTitle =>
      'ആൻഡ്രോയിഡിലെ സാങ്കൽപ്പിക അച്ചടിയന്ത്രം';

  @override
  String get helpFeatureVirtualPrinterBody =>
      'ഏത് ആൻഡ്രോയിഡ് ആപ്പിൽ നിന്നുമുള്ള അച്ചടി ജോലികൾ സ്വീകരിച്ച്, ഭാരതീയ ലിപികൾ ശരിയായി രൂപപ്പെടുത്തിയ വ്യക്തമായ PDF-കൾ ഉണ്ടാക്കുന്നു.';

  @override
  String get helpFeatureVirtualPrinterTag1 => 'സിസ്റ്റം അച്ചടി നിര';

  @override
  String get helpFeatureVirtualPrinterTag2 => 'അക്ഷരരൂപം ഉൾച്ചേർക്കൽ';

  @override
  String get helpFeatureVirtualPrinterTag3 => 'ഭാരതീയ ലിപി രൂപീകരണം';

  @override
  String get helpFeatureWebCleanerTitle => 'വെബ് ഉള്ളടക്ക ശുചീകരണം (വായനാരീതി)';

  @override
  String get helpFeatureWebCleanerBody =>
      'പങ്കിട്ട വെബ് താളുകൾ PDF ആക്കുന്നതിനു മുമ്പ് പരസ്യങ്ങൾ, പിന്തുടരൽ, ബാനറുകൾ, വശപ്പട്ടികകൾ, സ്ക്രിപ്റ്റുകൾ എന്നിവ നീക്കുന്നു.';

  @override
  String get helpFeatureWebCleanerTag1 => 'പരസ്യവും അലങ്കോലവും നീക്കൽ';

  @override
  String get helpFeatureWebCleanerTag2 => 'വായനാക്കാഴ്ച';

  @override
  String get helpFeatureWebCleanerTag3 => 'വൃത്തിയുള്ള PDF';

  @override
  String get helpFeatureImagesToPdfTitle => 'ചിത്രങ്ങളും പാഠവും PDF ആക്കൽ';

  @override
  String get helpFeatureImagesToPdfBody =>
      'ഗാലറിയിലെ 100 വരെ ചിത്രങ്ങളോ പങ്കിട്ട ലളിത പാഠമോ ക്രമീകരിച്ച പല താളുള്ള PDF രേഖകളാക്കാം.';

  @override
  String get helpFeatureImagesToPdfTag1 => '100 ചിത്രങ്ങൾ വരെ';

  @override
  String get helpFeatureImagesToPdfTag2 => 'ലളിത പാഠം ഇറക്കുമതി';

  @override
  String get helpFeatureImagesToPdfTag3 => 'ഇഷ്ടാനുസൃത അരികുകൾ';

  @override
  String get helpFeatureSignatureCheckTitle => 'ഡിജിറ്റൽ ഒപ്പ് പരിശോധന';

  @override
  String get helpFeatureSignatureCheckBody =>
      'Bouncy Castle ഉപയോഗിച്ച് രേഖയുടെ അഖണ്ഡത, ബൈറ്റ് വ്യാപ്തി, സർട്ടിഫിക്കറ്റിന്റെ സാധുത എന്നിവ ഓഫ്‌ലൈനായി പരിശോധിക്കുന്നു.';

  @override
  String get helpFeatureSignatureCheckTag1 => 'ബൈറ്റ് അഖണ്ഡത';

  @override
  String get helpFeatureSignatureCheckTag2 => 'ബൈറ്റ് വ്യാപ്തി';

  @override
  String get helpFeatureSignatureCheckTag3 => 'ഓഫ്‌ലൈൻ പരിശോധന';

  @override
  String get helpFeatureTrustStoreTitle =>
      'സ്വന്തം വിശ്വസ്ത ശേഖരവും EU പട്ടികകളും';

  @override
  String get helpFeatureTrustStoreBody =>
      'EU വിശ്വസ്ത പട്ടികകളിലെ മൂല സർട്ടിഫിക്കറ്റുകൾ ഉൾപ്പെടുത്തിയിരിക്കുന്നു; സ്വന്തം CA/മൂല സർട്ടിഫിക്കറ്റുകൾ ഇറക്കുമതി ചെയ്യാനും കഴിയും.';

  @override
  String get helpFeatureTrustStoreTag1 => 'EU വിശ്വസ്ത പട്ടികകൾ';

  @override
  String get helpFeatureTrustStoreTag2 => 'X.509 PEM ഇറക്കുമതി';

  @override
  String get helpFeatureTrustStoreTag3 => 'PEM കയറ്റുമതി';

  @override
  String get helpFeatureSignatureStampsTitle => 'താളിലെ ഒപ്പുമുദ്രകൾ';

  @override
  String get helpFeatureSignatureStampsBody =>
      'PDF താളുകളിൽ സ്പർശിക്കാവുന്ന ഒപ്പുമുദ്രകൾ; ഒറ്റ സ്പർശത്തിൽ സർട്ടിഫിക്കറ്റ് ശൃംഖലയുടെ വിശദാംശങ്ങൾ കാണാം.';

  @override
  String get helpFeatureSignatureStampsTag1 => 'താളിലെ മുദ്രകൾ';

  @override
  String get helpFeatureSignatureStampsTag2 => 'സർട്ടിഫിക്കറ്റ് ശൃംഖല';

  @override
  String get helpFeatureSignatureStampsTag3 => 'ഒപ്പിട്ടയാളുടെ വിവരം';

  @override
  String get helpFeatureThemesTitle => 'തെളിഞ്ഞ, ഇരുണ്ട, OLED കറുപ്പ് രൂപങ്ങൾ';

  @override
  String get helpFeatureThemesBody =>
      'തെളിഞ്ഞ, ഇരുണ്ട, സെപിയ രൂപങ്ങളും, ബാറ്ററി പരമാവധി ലാഭിക്കാൻ OLED കടുംകറുപ്പ് (#000000) രൂപവും.';

  @override
  String get helpFeatureThemesTag1 => 'OLED കടുംകറുപ്പ്';

  @override
  String get helpFeatureThemesTag2 => 'സെപിയ വായന';

  @override
  String get helpFeatureThemesTag3 => 'സിസ്റ്റത്തിനൊത്ത്';

  @override
  String get helpFeatureTypographyTitle => 'അക്ഷരരൂപവും വലുപ്പവും';

  @override
  String get helpFeatureTypographyBody =>
      'മഞ്ജരി, അനേക് മലയാളം, നോട്ടോ സാൻസ് മലയാളം, സിസ്റ്റം അക്ഷരരൂപം എന്നിവയ്ക്കിടയിൽ മാറാം; പാഠത്തിന്റെ വലുപ്പവും മാറ്റാം.';

  @override
  String get helpFeatureTypographyTag1 => 'മലയാളം അക്ഷരരൂപങ്ങൾ';

  @override
  String get helpFeatureTypographyTag2 => 'അക്ഷരവലുപ്പം';

  @override
  String get helpFeatureTypographyTag3 => 'തൽക്ഷണ മാറ്റം';

  @override
  String get helpFeatureAccentTitle => 'പ്രധാന നിറം തിരഞ്ഞെടുക്കൽ';

  @override
  String get helpFeatureAccentBody =>
      'തയ്യാറാക്കിയ നിറങ്ങളും പൂർണ്ണ HSV നിറചക്രവും; ആപ്പിന്റെ രൂപം തത്സമയം കാണാം.';

  @override
  String get helpFeatureAccentTag1 => 'HSV നിറചക്രം';

  @override
  String get helpFeatureAccentTag2 => '8 തയ്യാർ നിറങ്ങൾ';

  @override
  String get helpFeatureAccentTag3 => 'തത്സമയ കാഴ്ച';

  @override
  String get helpFeatureGuidesTitle => 'ഘട്ടം ഘട്ടമായുള്ള 6 സഹായികൾ';

  @override
  String get helpFeatureGuidesBody =>
      'PDF അച്ചടിയന്ത്ര ക്രമീകരണം, യൂണികോഡ് അച്ചടി, TTS ശബ്ദ ക്രമീകരണം, താൾ പ്രവർത്തനങ്ങൾ, ഒപ്പുകൾ, സ്വകാര്യത എന്നിവയെക്കുറിച്ചുള്ള വിശദമായ സഹായികൾ.';

  @override
  String get helpFeatureGuidesTag1 => 'പൂർണ്ണമായും ഓഫ്‌ലൈൻ';

  @override
  String get helpFeatureGuidesTag2 => 'പ്രശ്നപരിഹാരം';

  @override
  String get helpFeatureGuidesTag3 => 'ഘട്ടം ഘട്ടമായി';

  @override
  String get labelColorGrey => 'ചാരനിറം';

  @override
  String get labelAccentColorWheel => 'നിറചക്രം';

  @override
  String get helpAccentColorWheelHint =>
      'പ്രധാന നിറം തിരഞ്ഞെടുക്കാൻ ചക്രത്തിൽ വലിക്കുക.';

  @override
  String get titleAppData => 'ആപ്പ് വിവരങ്ങൾ';

  @override
  String get actionDeleteAllData => 'എല്ലാം ഇല്ലാതാക്കുക';

  @override
  String get descDeleteAllData =>
      'സമീപകാല ഫയലുകൾ, വായനാസ്ഥാനങ്ങൾ, കുറിപ്പുകളും അടയാളങ്ങളും, നിങ്ങൾ വിശ്വസിച്ച സർട്ടിഫിക്കറ്റുകൾ, സൂക്ഷിച്ച ക്രമീകരണങ്ങൾ, അച്ചടിച്ച ഫയലുകൾ, താൽക്കാലിക ഫയലുകൾ എന്നിവ നീക്കുന്നു. നിങ്ങളുടെ സ്വന്തം PDF ഫയലുകളെ ഇത് ബാധിക്കില്ല.';

  @override
  String get titleDeleteAllDataConfirm => 'എല്ലാം ഇല്ലാതാക്കണോ?';

  @override
  String get bodyDeleteAllDataConfirm =>
      'ഇത് പിന്നീട് തിരികെ കൊണ്ടുവരാൻ കഴിയില്ല. ആപ്പ് സ്വതവേയുള്ള ക്രമീകരണങ്ങളോടെ ഹോം സ്ക്രീനിൽ നിന്ന് വീണ്ടും തുടങ്ങും.';

  @override
  String get errorDeleteAllData =>
      'ചില വിവരങ്ങൾ ഇല്ലാതാക്കാൻ കഴിഞ്ഞില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get actionClear => 'മായ്ക്കുക';

  @override
  String get labelLanguageAuto => 'സ്വയം';

  @override
  String get labelPaperA4 => 'A4';

  @override
  String get labelPaperLetter => 'US ലെറ്റർ';

  @override
  String get labelPaperLegal => 'ലീഗൽ';

  @override
  String get descPaperA4 => '210 × 297 മി.മീ.';

  @override
  String get descPaperLetter => '8.5 × 11 ഇഞ്ച്';

  @override
  String get descPaperLegal => '8.5 × 14 ഇഞ്ച്';

  @override
  String get labelQualityStandard => 'സാധാരണം';

  @override
  String get labelQualityHigh => 'ഉയർന്ന നിലവാരം';

  @override
  String get emptyExtractedText => 'വാചകമൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get labelWatermarkConfidential => 'രഹസ്യം';

  @override
  String get labelWatermarkDraft => 'കരട്';

  @override
  String get labelWatermarkCopy => 'പകർപ്പ്';

  @override
  String get labelWatermarkSample => 'മാതൃക';

  @override
  String get labelWatermarkOriginal => 'മൂലപ്രതി';

  @override
  String get titleDeviceSync => 'ഉപകരണ സമന്വയം';

  @override
  String get descDeviceSyncSubtitle =>
      'QR കോഡ് വഴിയോ വൈഫൈ വഴിയോ ക്രമീകരണങ്ങൾ പകർത്തുക, PDF-കൾ അയയ്ക്കുക';

  @override
  String get descDeviceSyncIntro =>
      'ഗ്രന്ഥം ആപ്പിലെ നിങ്ങളുടെ ക്രമീകരണങ്ങൾ മറ്റൊരു ഫോണിലേക്ക് പകർത്താം, അല്ലെങ്കിൽ PDF-കൾ അയയ്ക്കാം. അവയുള്ള ഫോൺ ഒരു കോഡ് കാണിക്കും. മറ്റേ ഫോൺ അത് സ്കാൻ ചെയ്യും.';

  @override
  String get descDeviceSyncWhatIsCopied =>
      'ക്രമീകരണങ്ങൾ മാത്രമേ പകർത്തൂ. സമീപകാല ഫയലുകൾ, വായിച്ചുനിർത്തിയ സ്ഥാനങ്ങൾ, കുറിപ്പുകൾ, ബുക്ക്മാർക്കുകൾ, വിശ്വസ്ത സർട്ടിഫിക്കറ്റുകൾ എന്നിവ ഈ ഫോണിൽത്തന്നെ തുടരും. മലയാളം ശബ്ദത്തിന്റെ തിരഞ്ഞെടുപ്പും PDF പ്രിന്റർ ക്രമീകരണവും ഓരോ ഫോണിനെയും ആശ്രയിക്കുന്നതിനാൽ അവയും പകർത്തില്ല.';

  @override
  String get titleShareSettings => 'ക്രമീകരണങ്ങൾ പങ്കിടുക';

  @override
  String get descShareSettingsSubtitle =>
      'മറ്റേ ഫോണിന് സ്കാൻ ചെയ്യാൻ ഒരു കോഡ് കാണിക്കുക';

  @override
  String get labelSyncModeQr => 'QR മാത്രം';

  @override
  String get labelSyncModeWifi => 'വൈഫൈ';

  @override
  String get descSyncModeQrHelp =>
      'ക്രമീകരണങ്ങൾ കോഡിനുള്ളിൽത്തന്നെയുണ്ട്. നെറ്റ്‌വർക്ക് ആവശ്യമില്ല.';

  @override
  String get descSyncModeWifiHelp =>
      'ഈ കോഡ് നിങ്ങളുടെ പ്രാദേശിക വൈഫൈ വഴി രണ്ടു ഫോണുകളെയും ബന്ധിപ്പിക്കുന്നു. രണ്ടു ഫോണുകളും ഒരേ വൈഫൈയിലായിരിക്കണം, അല്ലെങ്കിൽ ഒരു ഫോൺ മറ്റേതിന്റെ ഹോട്ട്‌സ്പോട്ടിൽ ചേരാം. ഒന്നും ഇന്റർനെറ്റിലേക്ക് പോകുന്നില്ല.';

  @override
  String descWifiCodeExpires(String time) {
    return 'ഈ കോഡ് $time നേരത്തേക്ക് പ്രവർത്തിക്കും.';
  }

  @override
  String descWifiGuestConnected(String address) {
    return '$address-മായി ബന്ധിപ്പിച്ചു. മറ്റേ ഫോൺ സ്ഥിരീകരിക്കുന്നതിനായി കാത്തിരിക്കുന്നു…';
  }

  @override
  String get descWifiShareAccepted =>
      'മറ്റേ ഫോൺ നിങ്ങളുടെ ക്രമീകരണങ്ങൾ പ്രയോഗിച്ചു.';

  @override
  String get descWifiShareDeclined =>
      'മറ്റേ ഫോൺ റദ്ദാക്കി. അവിടെ ഒന്നും മാറ്റിയിട്ടില്ല.';

  @override
  String get errorNoLanAddress =>
      'ഈ ഫോൺ ഒരു വൈഫൈ നെറ്റ്‌വർക്കിലല്ല. രണ്ടു ഫോണുകളും ഒരേ വൈഫൈയിൽ ചേർക്കുക, ഒരു ഫോണിൽ ഹോട്ട്‌സ്പോട്ട് ഓണാക്കുക, അല്ലെങ്കിൽ \'QR മാത്രം\' ഉപയോഗിക്കുക.';

  @override
  String get descWifiSessionEnded =>
      'ഗ്രന്ഥം ആപ്പ് പശ്ചാത്തലത്തിലേക്ക് പോയതിനാൽ വൈഫൈ സെഷൻ അവസാനിച്ചു. തയ്യാറാകുമ്പോൾ വീണ്ടും ആരംഭിക്കുക.';

  @override
  String get titleScanCode => 'കോഡ് സ്കാൻ ചെയ്യുക';

  @override
  String get descScanCodeHelp => 'മറ്റേ ഫോണിലെ കോഡിലേക്ക് ക്യാമറ ചൂണ്ടുക.';

  @override
  String get errorCameraUnavailable =>
      'ക്യാമറ ആരംഭിക്കാനായില്ല. സിസ്റ്റം ക്രമീകരണങ്ങളിൽ ഗ്രന്ഥം (Folio) ആപ്പിന് ക്യാമറ അനുമതി നൽകി വീണ്ടും ശ്രമിക്കുക. ക്യാമറയില്ലാത്ത ഫോണിനും ക്രമീകരണങ്ങളും PDF-കളും അയയ്ക്കാം.';

  @override
  String get errorCodeNotFolio => 'ഇതൊരു ഗ്രന്ഥം കോഡ് അല്ല.';

  @override
  String get errorCodeDamaged =>
      'ഈ ഗ്രന്ഥം കോഡ് വായിക്കാനായില്ല. പുതിയൊരു കോഡ് ഉണ്ടാക്കി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorCodeNewerVersion =>
      'ഈ കോഡ് ഗ്രന്ഥം ആപ്പിന്റെ പുതിയ പതിപ്പിൽ നിർമ്മിച്ചതാണ്. ഈ ഫോണിലെ ഗ്രന്ഥം ആപ്പ് നവീകരിക്കുക.';

  @override
  String get errorCodeUnsafeAddress =>
      'ഈ കോഡ് നിങ്ങളുടെ പ്രാദേശിക നെറ്റ്‌വർക്കിന് പുറത്തേക്കാണ് ചൂണ്ടുന്നത്, അതിനാൽ ഗ്രന്ഥം ആപ്പ് ഇത് ഉപയോഗിക്കില്ല.';

  @override
  String get descReceiveConnecting => 'മറ്റേ ഫോണുമായി ബന്ധിപ്പിക്കുന്നു…';

  @override
  String descReviewSettingsChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ക്രമീകരണങ്ങൾ മാറും:',
      one: '1 ക്രമീകരണം മാറും:',
    );
    return '$_temp0';
  }

  @override
  String get descReviewSettingsSame =>
      'നിങ്ങളുടെ ക്രമീകരണങ്ങൾ ഇതിനകം മറ്റേ ഫോണിലേതിന് സമാനമാണ്.';

  @override
  String get descReviewSettingsSkipped =>
      'ഗ്രന്ഥം ആപ്പിന്റെ ഈ പതിപ്പിന് ഉപയോഗിക്കാനാകാത്തതിനാൽ ചില മൂല്യങ്ങൾ ഒഴിവാക്കി.';

  @override
  String get actionApplySettings => 'പ്രയോഗിക്കുക';

  @override
  String get descSettingsApplied => 'ക്രമീകരണങ്ങൾ പ്രയോഗിച്ചു.';

  @override
  String get descSettingsNotApplied => 'ഒന്നും മാറ്റിയിട്ടില്ല.';

  @override
  String get errorTransferUnreachable =>
      'മറ്റേ ഫോണുമായി ബന്ധപ്പെടാനായില്ല. രണ്ടു ഫോണിലും ഒരേ വൈഫൈ ഉപയോഗിക്കുക, അല്ലെങ്കിൽ ഒരു ഫോണിൽ ഹോട്ട്‌സ്പോട്ട് ഓണാക്കി മറ്റേതിൽനിന്ന് അതിൽ ചേരുക. ചില ഓഫീസ്, ഹോട്ടൽ വൈഫൈ നെറ്റ്‌വർക്കുകൾ ഇത് തടയാറുണ്ട്.';

  @override
  String get errorTransferTimedOut =>
      'നിശ്ചിത സമയത്തിനുള്ളിൽ ഒന്നും സംഭവിച്ചില്ല. പുതിയൊരു കോഡ് ഉണ്ടാക്കി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorTransferWrongCode =>
      'കോഡ് പ്രവർത്തിച്ചില്ല. അത് പഴയതോ ഇതിനകം ഉപയോഗിച്ചതോ ആകാം. പുതിയൊരു കോഡ് ഉണ്ടാക്കി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorTransferBadData =>
      'മറ്റേ ഫോണിൽനിന്നുള്ള വിവരങ്ങൾ കേടായിരുന്നു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorTransferUnsupportedVersion =>
      'മറ്റേ ഫോണിൽ ഗ്രന്ഥം ആപ്പിന്റെ വേറൊരു പതിപ്പാണ്. രണ്ടു ഫോണിലും ഗ്രന്ഥം ആപ്പ് നവീകരിക്കുക.';

  @override
  String get errorTransferConnectionLost =>
      'ബന്ധം നഷ്ടപ്പെട്ടു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get labelSyncAccentLight => 'തെളിഞ്ഞ രൂപത്തിലെ നിറം';

  @override
  String get labelSyncAccentDark => 'ഇരുണ്ട രൂപത്തിലെ നിറം';

  @override
  String get titlePermCamera => 'ക്യാമറ';

  @override
  String get descPermCameraReason =>
      'ഉപകരണ സമന്വയത്തിനുള്ള QR കോഡ് വായിക്കാൻ \'കോഡ് സ്കാൻ ചെയ്യുക\' സ്ക്രീനിൽ മാത്രം ഉപയോഗിക്കുന്നു. ആദ്യമായി സ്കാൻ ചെയ്യുമ്പോൾ അനുമതി ചോദിക്കും. ഫോട്ടോകളോ വീഡിയോകളോ എടുക്കുകയോ സൂക്ഷിക്കുകയോ ചെയ്യുന്നില്ല.';

  @override
  String get descPermCameraWhatItAchieves =>
      'മറ്റൊരു ഫോണിന്റെ കോഡ് സ്കാൻ ചെയ്ത് അതിൽനിന്ന് ക്രമീകരണങ്ങളോ PDF-കളോ സ്വീകരിക്കാൻ സഹായിക്കുന്നു.';

  @override
  String get titlePermLocalNetwork => 'പ്രാദേശിക വൈഫൈ മാത്രം';

  @override
  String get descPermLocalNetworkReason =>
      'ഒരേ വൈഫൈയിലുള്ള രണ്ടു ഫോണുകൾ തമ്മിലുള്ള ബന്ധത്തിനുപോലും android.permission.INTERNET ആവശ്യമാണ്. ഗ്രന്ഥം ആപ്പ് ഇത് ഉപകരണ സമന്വയത്തിന് മാത്രം, ആ സ്ക്രീൻ തുറന്നിരിക്കുമ്പോൾ മാത്രം, QR കോഡിൽനിന്നുള്ള സ്വകാര്യ പ്രാദേശിക വിലാസത്തിലേക്ക് മാത്രം ഉപയോഗിക്കുന്നു.';

  @override
  String get descPermLocalNetworkWhatItAchieves =>
      'ഒറ്റത്തവണ താക്കോൽ ഉപയോഗിച്ച് എൻക്രിപ്റ്റ് ചെയ്ത്, ഫോണുകൾ നേരിട്ട് പരസ്പരം സംസാരിക്കുന്നു. ഗ്രന്ഥം ആപ്പ് ഒരിക്കലും ഇന്റർനെറ്റ് സെർവറുമായി ബന്ധപ്പെടുന്നില്ല.';

  @override
  String get titleReceive => 'സ്വീകരിക്കുക';

  @override
  String get descReceiveSubtitle =>
      'ക്രമീകരണങ്ങളോ PDF-കളോ ലഭിക്കാൻ മറ്റേ ഫോണിലെ കോഡ് സ്കാൻ ചെയ്യുക';

  @override
  String get descDeviceSyncSendPdfsHint =>
      'PDF-കൾ അയയ്ക്കാൻ: ഹോമിൽ ഒരു സമീപകാല ഫയലിൽ അമർത്തിപ്പിടിച്ച് തിരഞ്ഞെടുക്കുക (കൂടുതൽ ചേർക്കാൻ അവയിൽ തൊടുക), അല്ലെങ്കിൽ ഒരു PDF തുറന്ന് മെനുവിൽനിന്ന് \'സമീപ ഫോണിലേക്ക് അയയ്ക്കുക\' തിരഞ്ഞെടുക്കുക.';

  @override
  String get actionSendNearby => 'സമീപ ഫോണിലേക്ക് അയയ്ക്കുക';

  @override
  String get titleSendFiles => 'PDF-കൾ അയയ്ക്കുക';

  @override
  String descSendPreparing(int done, int total) {
    return 'ഫയലുകൾ തയ്യാറാക്കുന്നു… $total-ൽ $done';
  }

  @override
  String get descSendScanPrompt =>
      'മറ്റേ ഫോണിൽ ഗ്രന്ഥം (Folio) › ക്രമീകരണങ്ങൾ › ഉപകരണ സമന്വയം › സ്വീകരിക്കുക തുറന്ന് ഈ കോഡ് സ്കാൻ ചെയ്യുക.';

  @override
  String descSendFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'അയയ്ക്കാൻ $count PDF-കൾ തയ്യാർ',
      one: 'അയയ്ക്കാൻ 1 PDF തയ്യാർ',
    );
    return '$_temp0';
  }

  @override
  String descSendSkipped(String names) {
    return 'ഈ ഫയലുകൾ വായിക്കാനായില്ല, അവ അയയ്ക്കില്ല: $names';
  }

  @override
  String get errorSendNothing =>
      'തിരഞ്ഞെടുത്ത ഫയലുകളൊന്നും വായിക്കാനായില്ല. അവ മാറ്റുകയോ ഇല്ലാതാക്കുകയോ ചെയ്തിരിക്കാം. അവ വീണ്ടും തുറന്ന ശേഷം ഒരിക്കൽക്കൂടി ശ്രമിക്കുക.';

  @override
  String get errorSendNoNetwork =>
      'ഈ ഫോൺ ഒരു വൈഫൈ നെറ്റ്‌വർക്കിലല്ല. രണ്ടു ഫോണുകളും ഒരേ വൈഫൈയിൽ ചേർക്കുക, അല്ലെങ്കിൽ ഒരു ഫോണിൽ ഹോട്ട്‌സ്പോട്ട് ഓണാക്കുക.';

  @override
  String descSendTransferring(String sent, String total) {
    return 'അയയ്ക്കുന്നു… $total-ൽ $sent';
  }

  @override
  String descSendFinished(int received, int count) {
    return '$count PDF-കളിൽ $received എണ്ണം മറ്റേ ഫോണിൽ സുരക്ഷിതമായി എത്തി.';
  }

  @override
  String get descSendDeclined => 'മറ്റേ ഫോൺ റദ്ദാക്കി. ഒന്നും അയച്ചിട്ടില്ല.';

  @override
  String descReceiveFilesHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'മറ്റേ ഫോണിൽനിന്ന് $count PDF-കൾ:',
      one: 'മറ്റേ ഫോണിൽനിന്ന് 1 PDF:',
    );
    return '$_temp0';
  }

  @override
  String descReceiveFilesTotal(String size) {
    return 'ആകെ വലുപ്പം: $size';
  }

  @override
  String descSavingTo(String folder) {
    return 'സൂക്ഷിക്കുന്നത്: $folder';
  }

  @override
  String get descNoFolderYet =>
      'PDF-കൾ സൂക്ഷിക്കാൻ ഒരു ഫോൾഡർ തിരഞ്ഞെടുക്കുക. ഗ്രന്ഥം ആപ്പ് അത് ഓർത്തുവയ്ക്കും.';

  @override
  String get errorFolderLost =>
      'മുമ്പ് തിരഞ്ഞെടുത്ത ഫോൾഡർ ഇനി ഉപയോഗിക്കാനാവില്ല. അത് ഇല്ലാതാക്കിയിരിക്കാം, അല്ലെങ്കിൽ അതിലേക്കുള്ള അനുമതി നീക്കിയിരിക്കാം. വീണ്ടും ഒരു ഫോൾഡർ തിരഞ്ഞെടുക്കുക.';

  @override
  String get actionChangeFolder => 'മാറ്റുക';

  @override
  String get actionChooseFolder => 'ഫോൾഡർ തിരഞ്ഞെടുക്കുക';

  @override
  String get actionAcceptFiles => 'സ്വീകരിക്കുക';

  @override
  String descReceiveTransferring(String received, String total) {
    return 'സ്വീകരിക്കുന്നു… $total-ൽ $received';
  }

  @override
  String get descReceiveSaving => 'ഫോൾഡറിലേക്ക് സൂക്ഷിക്കുന്നു…';

  @override
  String descReceiveFilesSaved(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF-കൾ $folder-ൽ സൂക്ഷിച്ചു.',
      one: '1 PDF $folder-ൽ സൂക്ഷിച്ചു.',
      zero: 'ഒരു PDF-ഉം സൂക്ഷിച്ചില്ല.',
    );
    return '$_temp0';
  }

  @override
  String descReceiveFilesFailed(String names) {
    return 'സൂക്ഷിച്ചില്ല (വഴിയിൽ കേടായി, PDF അല്ല, അല്ലെങ്കിൽ എഴുതാനായില്ല): $names';
  }

  @override
  String get errorTransferCannotSave =>
      'ഫയലുകൾ സൂക്ഷിക്കാനായില്ല. ഫോണിൽ സ്ഥലം തീർന്നിരിക്കാം, അല്ലെങ്കിൽ ഫോൾഡറിൽ ഇനി എഴുതാനാവില്ല.';

  @override
  String labelSelectedCount(int count) {
    return '$count തിരഞ്ഞെടുത്തു';
  }

  @override
  String get tooltipCancelSelection => 'തിരഞ്ഞെടുപ്പ് റദ്ദാക്കുക';

  @override
  String get descShowCodeScanPrompt =>
      'മറ്റേ ഫോണിൽ ഗ്രന്ഥം (Folio) › ക്രമീകരണങ്ങൾ › ഉപകരണ സമന്വയം › സ്വീകരിക്കുക തുറന്ന് ഈ കോഡ് സ്കാൻ ചെയ്യുക.';
}
