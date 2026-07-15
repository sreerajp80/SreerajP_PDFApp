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
}
