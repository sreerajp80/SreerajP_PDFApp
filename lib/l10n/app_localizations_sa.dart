// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sanskrit (`sa`).
class AppLocalizationsSa extends AppLocalizations {
  AppLocalizationsSa([String locale = 'sa']) : super(locale);

  @override
  String get appTitle => 'श्रीराजपि PDF अनुप्रयोगः';

  @override
  String get homeTitle => 'श्रीराजपि PDF अनुप्रयोगः';

  @override
  String get homeEmptyMessage =>
      'अद्यापि किमपि PDF न उद्घाटितम्। सञ्चिकानामुद्घाटनम् अग्रिमचरणे भविष्यति।';

  @override
  String get settingsTitle => 'विन्यासः';

  @override
  String get settingsThemeLabel => 'वर्णपरिपार्टी';

  @override
  String get themeSystem => 'तन्त्रमूलम्';

  @override
  String get themeLight => 'प्रकाशमयम्';

  @override
  String get themeDark => 'अन्धकारमयम्';

  @override
  String get themeSepia => 'कपिशम् (Sepia)';

  @override
  String get themeOled => 'गाढान्धकारमयम् (OLED)';

  @override
  String get aboutTitle => 'विषयपरिचयः';

  @override
  String get openSettings => 'विन्यासः';

  @override
  String get openAbout => 'विषयपरिचयः';

  @override
  String get openPdf => 'PDF उद्घात्यताम्';

  @override
  String get recentFilesTitle => 'सद्यस्तनसञ्चिकाः';

  @override
  String get noRecentFiles =>
      'न कापि सद्यस्तनसञ्चिका वर्तते। पठनाय \"PDF उद्घात्यताम्\" स्पृश्यताम्।';

  @override
  String get removeFromRecents => 'निष्कास्यताम्';

  @override
  String get openFailed => 'सञ्चिकोद्घाटनं न शक्तम्।';

  @override
  String get reopenFailed =>
      'इयं सञ्चिका पुनरुद्घाटयितुं न शक्ता। इयं चालिता वा विलोपिता वा स्यात्।';

  @override
  String pagesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पृष्ठानि',
      one: '१ पृष्ठम्',
    );
    return '$_temp0';
  }

  @override
  String get viewModeContinuous => 'निरन्तरम्';

  @override
  String get viewModeSingle => 'एकपृष्ठम्';

  @override
  String get viewModeBook => 'द्विपृष्ठम्';

  @override
  String get viewModeTooltip => 'दर्शनरीतिः';

  @override
  String get fitWidth => 'विस्तारानुकूलम्';

  @override
  String get fitPage => 'पृष्ठानुकूलम्';

  @override
  String get pageFit => 'पृष्ठसङ्कोचः';

  @override
  String get zoomIn => 'विस्तार्यताम्';

  @override
  String get zoomOut => 'सङ्कोच्यताम्';

  @override
  String get resetZoom => 'आकारः प्रत्यवस्थाप्यताम्';

  @override
  String get invertColors => 'नक्तं वर्णाः';

  @override
  String get contentsTitle => 'विषयसूची';

  @override
  String get noOutline => 'अस्य PDF-पत्रस्य विषयसूची न विद्यते।';

  @override
  String get thumbnailsTitle => 'पृष्ठानि';

  @override
  String get goToPage => 'पृष्ठं गम्यताम्';

  @override
  String pageOfPages(int current, int total) {
    return '$total-मध्ये $current पृष्ठम्';
  }

  @override
  String get pageNumberHint => 'पृष्ठसङ्ख्या';

  @override
  String get goAction => 'गम्यताम्';

  @override
  String get cancelAction => 'निरस्यताम्';

  @override
  String get passwordTitle => 'कूटशब्दोऽपेक्षितः';

  @override
  String get passwordMessage =>
      'इदं PDF रक्षितं वर्तते। पठनाय कूटशब्दः प्रविश्यताम्।';

  @override
  String get passwordHint => 'कूटशब्दः';

  @override
  String get unlockAction => 'उद्घात्यताम्';

  @override
  String get tryAgainAction => 'पुनः प्रयतताम्';

  @override
  String get errorCorruptTitle => 'PDF उद्घाटयितुं न शक्यते';

  @override
  String get errorCorruptBody => 'सञ्चिका विकृता अथवा अमान्यं PDF वर्तते।';

  @override
  String get errorEmptyTitle => 'न किमपि दृश्यते';

  @override
  String get errorEmptyBody => 'इदं PDF रिक्तं वर्तते — अत्र पृष्ठानि न सन्ति।';

  @override
  String get errorPasswordTitle => 'कीलितं PDF';

  @override
  String get errorPasswordBody =>
      'इदं PDF कूटशब्देन रक्षितम्। पठनाय कूटशब्दः प्रविश्यताम्।';

  @override
  String get errorGenericTitle => 'दोषः सञ्जातः';

  @override
  String get errorGenericBody => 'इदं PDF उद्घाटयितुं न शक्तम्।';

  @override
  String get largeFileWarning =>
      'इदं बृहत् PDF वर्तते, अतः सुगमपठनाय युगपदेकमेव पृष्ठमुद्घाट्यते।';

  @override
  String get loadingPdf => 'उद्घाट्यते…';

  @override
  String get yes => 'आम्';

  @override
  String get metadataTitle => 'विवरणानि';

  @override
  String get metadataAction => 'विवरणानि';

  @override
  String get metadataFileSection => 'सञ्चिका';

  @override
  String get metadataFileName => 'नाम';

  @override
  String get metadataFileSize => 'परिमाणम्';

  @override
  String get metadataPdfSection => 'PDF विवरणानि';

  @override
  String get metadataUnavailable => 'एतानि विवरणानि पठितुं न शक्तानि।';

  @override
  String get metadataNoFields => 'इदं PDF स्वविवरणं न ददाति।';

  @override
  String get metadataTitleField => 'शीर्षकम्';

  @override
  String get metadataAuthor => 'रचयिता';

  @override
  String get metadataSubject => 'विषयः';

  @override
  String get metadataKeywords => 'मुख्यपदानि';

  @override
  String get metadataCreator => 'निर्माता';

  @override
  String get metadataProducer => 'उत्पादकः';

  @override
  String get metadataCreated => 'रचितम्';

  @override
  String get metadataModified => 'परिवर्तितम्';

  @override
  String get metadataPages => 'पृष्ठानि';

  @override
  String get metadataPdfVersion => 'PDF संस्करणम्';

  @override
  String get metadataProtected => 'कूटशब्देन रक्षितम्';

  @override
  String get searchAction => 'अन्वेषणम्';

  @override
  String get searchHint => 'अस्मिन् PDF-पत्रेऽन्विष्यताम्';

  @override
  String get searchClose => 'अन्वेषणं पिधीयताम्';

  @override
  String get searchClear => 'अपमृज्यताम्';

  @override
  String get searchNextMatch => 'अग्रिमपरिणामः';

  @override
  String get searchPreviousMatch => 'पूर्वपरिणामः';

  @override
  String get searchSearching => 'अन्विष्यते…';

  @override
  String get searchNoMatches => 'परिणामाः न लब्धाः';

  @override
  String searchMatchOf(int current, int total) {
    return '$total-मध्ये $current';
  }

  @override
  String searchLimitReached(int count) {
    return 'प्राथमिकाः $count परिणामाः दृश्यन्ते। दीर्घतरं पदं प्रयुज्यताम्।';
  }

  @override
  String get searchOptionsTooltip => 'अन्वेषणविकल्पाः';

  @override
  String get searchOptionStrict => 'सटीकाक्षरविन्यासः';

  @override
  String get searchOptionStrictNote => 'संयुक्त-असंयुक्त-रूपयोर्भेदः क्रियताम्';

  @override
  String get searchOptionIgnoreAccents => 'स्वरचिह्नान्युपेक्ष्यन्ताम्';

  @override
  String get searchOptionIgnoreAccentsNote =>
      'संस्कृतवैदिकस्वरचिह्नोपेक्षायामुपयुक्तम्';

  @override
  String get searchOptionSandhi => 'सन्धियुक्तपदान्वेषणम्';

  @override
  String get searchOptionSandhiNote =>
      'सन्धियुक्त-पदच्छेद-रूपान्वेषणम् (मलयाल-संस्कृतयोः)';

  @override
  String get searchOptionPhonetic => 'ध्वनिसाम्यान्वेषणम्';

  @override
  String get searchOptionPhoneticNote =>
      'समानोच्चारण-अनुस्वार-चिल्लुभेदान्वेषणम्';

  @override
  String get noTextTitle => 'न कोऽपि चयनयोग्यः पाठ्यांशः';

  @override
  String get noTextBody =>
      'अस्मिन् PDF-पत्रे पाठ्यांशपटलः न वर्तते, अतः चित्रवद् दृश्यते। अन्वेषणं, प्रतिलिपिः, उच्चैःपठनं च न लभ्यते। अयं प्रयोगः चित्रेभ्यः पाठ्यांशं न पठति।';

  @override
  String get garbledTextTitle => 'पाठ्यांशः साधु पठितुं न शक्यते';

  @override
  String get garbledTextBody =>
      'अस्य PDF-पत्रस्य लिपिमुद्राः अक्षराणि स्पष्टं न सूचयन्ति, अतः अन्वेषणमुच्चैःपठनं च अशुद्धफलं दद्यात्। तथापि पृष्ठपठनं प्रवर्तते।';

  @override
  String get searchUnavailableNoText =>
      'अन्वेषणाय चयनयोग्यः पाठ्यांशोऽपेक्षितः, यश्चास्मिन् न विद्यते।';

  @override
  String get searchUnavailableGarbled =>
      'पाठ्यांशस्य साधु पठनाभावात् अन्वेषणं स्तम्भितम्।';

  @override
  String get dismissAction => 'अवगतम्';

  @override
  String get ttsReadAloud => 'उच्चैः पठ्यताम्';

  @override
  String get ttsPause => 'विरामः';

  @override
  String get ttsStop => 'स्थग्यताम्';

  @override
  String get ttsUnavailableNoText =>
      'उच्चैःपठनाय चयनयोग्यः पाठ्यांशोऽपेक्षितः, यश्चास्मिन् न विद्यते।';

  @override
  String get ttsUnavailableGarbled =>
      'पाठ्यांशस्य साधु पठनाभावात् उच्चैःपठनं स्तम्भितम्।';

  @override
  String get ttsUnavailableNoVoice =>
      'अस्मिन् यन्त्रे न कापि वाग्युक्तिः संस्थापिता।';

  @override
  String get ttsNothingToRead => 'अस्मिन् पृष्ठे पठनाय न किमपि विद्यते।';

  @override
  String get settingsReadAloudLabel => 'उच्चैःपठनम्';

  @override
  String get settingsMalayalamVoice => 'मलयालवाणी';

  @override
  String get settingsMalayalamVoiceReady =>
      'सज्जा। मलयालपाठ्यांशः मलयालवाण्या पठिष्यते।';

  @override
  String get settingsMalayalamVoiceOff => 'मलयालपाठ्यांशः आङ्ग्लवाण्या पठ्यते।';

  @override
  String get settingsMalayalamVoiceNeedsInstall =>
      'मलयालवाणी अद्यापि नावतारिता।';

  @override
  String get settingsMalayalamVoiceUnavailable =>
      'अस्य यन्त्रस्य वाग्यन्त्रं मलयालं न समर्थयति।';

  @override
  String get settingsMalayalamVoiceChecking => 'परीक्ष्यते…';

  @override
  String get ttsInstallTitle => 'मलयालवाणी प्राप्यताम्';

  @override
  String get ttsInstallBody =>
      'अस्मिन् दूरवाणी-यन्त्रे अद्यापि मलयालवाणी नास्ति। एतेषु एकं प्रयुज्यताम्:';

  @override
  String get ttsInstallVoiceData => 'वाणीदत्तांशः अवतार्यताम्';

  @override
  String get ttsOpenTtsSettings => 'वाग्विन्यासः उद्घात्यताम्';

  @override
  String get ttsOpenPlayStore => 'गूगल-वाक्सेवाः प्राप्यन्ताम्';

  @override
  String get ttsInstallDoneNote =>
      'संस्थापनानन्तरम् अत्रागच्छतु — वाणीसज्जतायां सत्यां विन्यासः स्वयमेव प्रवर्तते।';

  @override
  String get ttsInstallCannotOpen =>
      'इदं दूरवाणी-यन्त्रं तत्पटलमुद्घाटयितुं न शक्तम्।';

  @override
  String get ttsVoiceLostNotice =>
      'मलयालवाणी न संस्थापिता वर्तते, अतः विन्यासः स्तम्भितः।';

  @override
  String get extractAndConvert => 'निष्कासनं रूपान्तरणं च';

  @override
  String get extractTextAction => 'पाठ्यांशः निष्कास्यताम्';

  @override
  String get extractImagesAction => 'चित्राणि निष्कास्यन्ताम्';

  @override
  String get convertPdfAction => 'चित्रेषु रूपान्तर्यताम्';

  @override
  String get formFieldsAction => 'प्रपत्रक्षेत्राणि';

  @override
  String get extractionSuccess => 'निष्कासनं सम्पन्नम्';

  @override
  String get extractionFailed => 'निष्कासनं विफलम्';

  @override
  String get extractingProgress => 'विषयः निष्कास्यते…';

  @override
  String get rangeAll => 'सर्वाणि पृष्ठानि';

  @override
  String rangeCurrent(int page) {
    return 'वर्तमानपृष्ठम् ($page पृष्ठम्)';
  }

  @override
  String get rangeCustom => 'इच्छानुगुणं पृष्ठक्षेत्रम्';

  @override
  String get startPageLabel => 'आरम्भपृष्ठम्';

  @override
  String get endPageLabel => 'अन्तिमपृष्ठम्';

  @override
  String get invalidPageRange => 'अमान्यं पृष्ठक्षेत्रम्';

  @override
  String get imageFormatLabel => 'चित्रप्रारूपम्';

  @override
  String resolutionLabel(int dpi) {
    return 'विभेदनम्: $dpi DPI';
  }

  @override
  String get fieldsNameHeader => 'क्षेत्रनाम';

  @override
  String get fieldsValueHeader => 'मूल्यम्';

  @override
  String get noFormFieldsFound =>
      'अस्मिन् PDF-पत्रे न कानिचित् प्रपत्रक्षेत्राणि लब्धानि।';

  @override
  String get noImagesFound => 'चयनितपृष्ठेषु न कानिचित् चित्राणि लब्धानि।';

  @override
  String get shareAction => 'विभज्यताम्';

  @override
  String get shareFileAction => 'सञ्चिकारूपेण विभज्यताम्';

  @override
  String get copyClipboardAction => 'फलके प्रतिलिप्यताम्';

  @override
  String get copySuccess => 'फलके प्रतिलिपिः कृता';

  @override
  String get previewTextTitle => 'निष्कासितपाठ्यांशप्राग्दर्शनम्';

  @override
  String get formFieldsTitle => 'संवादप्रपत्रक्षेत्राणि';

  @override
  String get pageToolsTitle => 'पृष्ठसाधनानि';

  @override
  String get mergeAction => 'PDF-सञ्चिकाः संयोज्यन्ताम्';

  @override
  String get mergeDescription =>
      'इमां PDF-सञ्चिकामन्याभिः सह नूतनसञ्चिकारूपेण योजयतु';

  @override
  String get mergeDoneTitle => 'PDF-सञ्चिकाः योजिताः';

  @override
  String get splitAction => 'पृष्ठेषु विभज्यताम्';

  @override
  String get splitDescription => 'प्रत्येकपृष्ठायैकां नूतनसञ्चिकां रचयतु';

  @override
  String get splitDoneTitle => 'PDF विभक्तम्';

  @override
  String get organizeAction => 'पृष्ठानि व्यवस्थाप्यन्ताम्';

  @override
  String get organizeDescription =>
      'पृष्ठानि पुनर्व्यवस्थाप्यन्तां भ्राम्यन्तां लुप्यन्तां वा';

  @override
  String get organizeTitle => 'पृष्ठानि व्यवस्थाप्यन्ताम्';

  @override
  String get organizeHint =>
      'पुनर्व्यवस्थापनायाकर्षतु। पृष्ठस्य भ्रमणाय विलोपनाय वा पिञ्जानि प्रयुञ्जीत। रक्षणेन नूतनसञ्चिका निर्मीयते।';

  @override
  String get organizeDoneTitle => 'पृष्ठानि व्यवस्थापितानि';

  @override
  String get compressAction => 'सङ्कुच्यताम्';

  @override
  String get compressDescription => 'लघुतरा प्रतिलिपिः क्रियताम् (यथामति)';

  @override
  String get compressDoneTitle => 'PDF सङ्कुचितम्';

  @override
  String get compressBestEffortNote =>
      'सङ्कोचः साध्यप्रयत्नेन भवति। पूर्वमनुकूलिताः सञ्चिकाः बहु न सङ्कुचन्ति।';

  @override
  String get protectAction => 'कूटशब्देन रक्ष्यताम्';

  @override
  String get protectDescription => 'नूतनप्रतिलिपये कूटशब्दं योजयतु';

  @override
  String get protectTitle => 'PDF रक्ष्यताम्';

  @override
  String get protectDoneTitle => 'PDF रक्षितम्';

  @override
  String get removePasswordAction => 'कूटशब्दो निष्कास्यताम्';

  @override
  String get unlockDescription =>
      'कूटशब्दरहितां प्रतिलिपिं रचयतु (वर्तमानकूटशब्दोऽपेक्षितः)';

  @override
  String get unlockTitle => 'कूटशब्दो निष्कास्यताम्';

  @override
  String get unlockDoneTitle => 'कूटशब्दो निष्कासितः';

  @override
  String get userPasswordLabel => 'कूटशब्दः (सञ्चिकोद्घाटनाय)';

  @override
  String get ownerPasswordLabel => 'स्वामिकूटशब्दः (ऐच्छिकः)';

  @override
  String get ownerPasswordHelp =>
      'मुद्रणं सम्पादनं च नियन्त्रयति। उद्घाटनकूटशब्दानुरूपाय रिक्तं त्यज्यताम्।';

  @override
  String get currentPasswordLabel => 'वर्तमानकूटशब्दः';

  @override
  String get passwordRequiredError => 'कूटशब्दः प्रविश्यताम्।';

  @override
  String get workingProgress => 'क्रियते…';

  @override
  String get opFailed => 'कार्यं विफलम्';

  @override
  String get saveAction => 'रक्ष्यताम्';

  @override
  String get saveFailed => 'सञ्चिकां रक्षितुं न शक्तम्';

  @override
  String savedFileMessage(String name) {
    return '$name रक्षितम्';
  }

  @override
  String resultOneFile(String name) {
    return 'नूतनसञ्चिका: $name';
  }

  @override
  String resultManyFiles(int count) {
    return '$count नूतनसञ्चिकाः रचिताः।';
  }

  @override
  String pageLabel(int page) {
    return '$page पृष्ठम्';
  }

  @override
  String rotatedBy(int degrees) {
    return '$degrees° भ्रमितम्';
  }

  @override
  String pageDeletedMessage(int page) {
    return '$page पृष्ठं निष्कासितम्';
  }

  @override
  String get undoAction => 'पूर्ववत् क्रियताम्';

  @override
  String get rotateAction => 'भ्राम्यताम्';

  @override
  String get deletePageAction => 'पृष्ठं लुप्यताम्';

  @override
  String get noPagesLeftError => 'न्यूनातिन्यूनमेकं पृष्ठं धार्यताम्।';

  @override
  String get annotateAction => 'अङ्क्यताम्';

  @override
  String get annotationHighlight => 'उद्भासनम्';

  @override
  String get annotationUnderline => 'अधोरेखाङ्कनम्';

  @override
  String get annotationStrikethrough => 'मध्यरेखाङ्कनम्';

  @override
  String get annotationInk => 'आलेखनम्';

  @override
  String get annotationNote => 'टिप्पणी';

  @override
  String get annotationEraser => 'मार्जनम्';

  @override
  String get annotationClearAll => 'सर्वाङ्कनानि मार्ज्यन्ताम्';

  @override
  String get annotationExport => 'साङ्कनप्रतिलिपिः निर्यात्यताम्';

  @override
  String get annotationOverlayNotice =>
      'एतानि अङ्कनानि अस्मिन्नेवानुप्रयोगे रक्ष्यन्ते। PDF-पत्रे रक्षणाय साङ्कनप्रतिलिपिं निर्यापयतु।';

  @override
  String get annotationTextMarkupUnavailable =>
      'अस्मिन् PDF-पत्रे अङ्कनाय न कोऽपि चयनयोग्यः पाठ्यांशो वर्तते।';

  @override
  String get annotationExporting => 'साङ्कनप्रतिलिपिः निर्मीयते…';

  @override
  String get annotationExportFailed =>
      'साङ्कनप्रतिलिपिं निर्यापयितुं न शक्तम्।';

  @override
  String get annotationNothingToExport => 'प्रथममङ्कनं योज्यताम्।';

  @override
  String get annotationClearAllTitle => 'सर्वाङ्कनानि मार्ज्यन्ताम् किम्?';

  @override
  String get annotationClearAllMessage =>
      'अनेन अस्याः सञ्चिकायाः सर्वाङ्कनानि लुप्यन्ते। इदं पूर्ववत् कर्तुं न शक्यते।';

  @override
  String get noteTitle => 'टिप्पणी';

  @override
  String get noteHint => 'टिप्पणीं लिखतु';

  @override
  String get deleteAction => 'लुप्यताम्';

  @override
  String get bookmarksTitle => 'पत्रचिह्नानि';

  @override
  String get bookmarksAction => 'पत्रचिह्नानि';

  @override
  String get bookmarksEmpty => 'न कानिचित् पत्रचिह्नानि वर्तन्ते।';

  @override
  String bookmarkAddCurrent(int page) {
    return '$page पृष्ठे पत्रचिह्नं योज्यताम्';
  }

  @override
  String bookmarkRemoveCurrent(int page) {
    return '$page पृष्ठस्य पत्रचिह्नं निष्कास्यताम्';
  }

  @override
  String bookmarkPageLabel(int page) {
    return '$page पृष्ठम्';
  }

  @override
  String get shareFailed => 'इमां सञ्चिकां विभक्तुं न शक्तम्।';

  @override
  String get importTitle => 'PDF रूपेण रक्ष्यताम्';

  @override
  String get importBuilding => 'भवतः PDF निर्मीयते…';

  @override
  String get importReadyTitle => 'भवतः PDF सज्जम्';

  @override
  String importImagesSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चित्रेभ्यो निर्मितम्',
      one: '१ चित्रात् निर्मितम्',
    );
    return '$_temp0';
  }

  @override
  String get importTextSummary => 'भवता विभक्तपाठ्यांशेन निर्मितम्।';

  @override
  String importSize(String size) {
    return 'परिमाणम्: $size';
  }

  @override
  String get importSaveAction => 'PDF रूपेण रक्ष्यताम्';

  @override
  String get importShareAction => 'विभज्यताम्';

  @override
  String importSaved(String name) {
    return '$name रक्षितम्';
  }

  @override
  String get importFailedTitle => 'PDF निर्मातुं न शक्तम्';

  @override
  String get importUnsupportedTextTitle => 'एतान्यक्षराणि रक्षितुं न शक्यन्ते';

  @override
  String get importUnsupportedTextDetail =>
      'अयं प्रयोगः केवलमाङ्ग्लवर्णान् सङ्ख्याश्च PDF-पत्रे लेखितुं शक्नोति। मलयालमन्याश्च लिपयोऽद्यापि न समर्थिताः। पाठ्यांशस्य चित्रं साधु रक्षिष्यते।';

  @override
  String get printAction => 'मुद्र्यताम्';

  @override
  String get printTitle => 'मुद्रणम्';

  @override
  String get printWholeAction => 'समग्रलेख्यम्';

  @override
  String get printWholeDescription =>
      'अस्य PDF-पत्रस्य सर्वाणि पृष्ठानि मुद्र्यन्ताम्।';

  @override
  String get printRangeAction => 'पृष्ठक्षेत्रम्';

  @override
  String get printRangeDescription => 'कानि पृष्ठानि मुद्रणीयानीति वृणुताम्।';

  @override
  String get printTextAction => 'केवलपाठ्यांशः';

  @override
  String get printTextDescription =>
      'अस्य PDF-पत्रस्य पदानि सरलपृष्ठरूपेण मुद्र्यन्ताम्।';

  @override
  String get printRangeTitle => 'मुद्रणीयानि पृष्ठानि';

  @override
  String get printFromLabel => 'अस्मात् पृष्ठात्';

  @override
  String get printToLabel => 'अस्मिन् पृष्ठे';

  @override
  String printRangeInvalid(int pageCount) {
    return '१ तः $pageCount यावत् पृष्ठक्षेत्रं प्रविशतु।';
  }

  @override
  String get printPreparing => 'पृष्ठानि सज्जीक्रियन्ते…';

  @override
  String get printUnavailable => 'इदं यन्त्रं मुद्रयितुं न शक्नोति।';

  @override
  String get printFailed => 'मुद्रणारम्भो न जातः।';

  @override
  String get printNoText => 'अस्मिन् PDF-पत्रे मुद्रणाय पाठ्यांशो नास्ति।';

  @override
  String get signaturesAction => 'हस्ताक्षराणि';

  @override
  String get signaturesTitle => 'हस्ताक्षराणि';

  @override
  String get signaturesChecking => 'हस्ताक्षराणि परीक्ष्यन्ते…';

  @override
  String get signaturesNone => 'इदं PDF न हस्ताक्षरितम्।';

  @override
  String get signaturesFailed => 'एतानि हस्ताक्षराणि परीक्षितुं न शक्तानि।';

  @override
  String get signaturesFailedDetail =>
      'अनेन हस्ताक्षराणि दुष्टानीति न ज्ञायते। अनुप्रयोगः तानि पठितुं न शक्तः, अतः किमपि न कथयति।';

  @override
  String get signatureStatusTrusted => 'हस्ताक्षरितं विश्वस्तं च';

  @override
  String get signatureStatusTrustedDetail =>
      'हस्ताक्षरकरणानन्तरं लेख्यं न परिवर्तितम्, भवान् हस्ताक्षरकर्तुः प्रमाणपत्रं विश्वसिति च।';

  @override
  String get signatureStatusValidNotTrusted =>
      'हस्ताक्षरितं, किन्तु हस्ताक्षरकर्ता अज्ञातः';

  @override
  String get signatureStatusValidNotTrustedDetail =>
      'हस्ताक्षरकरणानन्तरं लेख्यं न परिवर्तितम्। किन्तु अनुप्रयोगः हस्ताक्षरकर्तारं न जानाति, अतः तस्य सत्यतां न वदति।';

  @override
  String get signatureStatusInvalid => 'अमान्यं हस्ताक्षरम्';

  @override
  String get signatureStatusInvalidDetail =>
      'हस्ताक्षरकरणानन्तरं लेख्यं परिवर्तितम्, हस्ताक्षरं वा न सङ्गच्छते। अस्मिन् विश्वासो न कार्यः।';

  @override
  String get signatureStatusUnknown => 'अज्ञातं हस्ताक्षरम्';

  @override
  String get signatureStatusUnknownDetail =>
      'अनुप्रयोगः अस्य हस्ताक्षरस्यार्थं ज्ञातुं न शक्तः, अतः इदं साधु वा दुष्टं वेति न कथयति।';

  @override
  String get signatureNotePartialCoverage => 'सञ्चिकाया एकभागमात्रमन्तर्भवति';

  @override
  String get signatureNotePartialCoverageDetail =>
      'हस्ताक्षरकरणानन्तरमस्यां सञ्चिकायां किमपि योजितम्। हस्ताक्षरं तद्भागं न वर्णयति।';

  @override
  String get signatureNoteRevoked => 'प्रमाणपत्रं निरस्तम्';

  @override
  String get signatureNoteRevokedDetail =>
      'येनेदं प्रमाणपत्रं दत्तं तेनैव निरस्तम्। अत्र विश्वासो न कर्तव्यः।';

  @override
  String get signatureNoteRevocationNotChecked =>
      'प्रमाणपत्रं निरस्तं न वेति परीक्षितुं न शक्तम्';

  @override
  String get signatureNoteRevocationNotCheckedDetail =>
      'तस्य परीक्षाया अन्तर्जालमपेक्षितम्, यदयं प्रयोगः कदापि न प्रयुङ्क्ते। अस्मिन् PDF-पत्रे च तत्प्रमाणं नास्ति।';

  @override
  String get signatureNoteCertExpired =>
      'हस्ताक्षरकरणकाले प्रमाणपत्रमतीतकालं वर्तते स्म';

  @override
  String get signatureNoteCertExpiredDetail =>
      'हस्ताक्षरकाले प्रमाणपत्रं स्वमान्यदिनाङ्केभ्यो बहिरासीत्।';

  @override
  String get signatureNoteUnverifiedTime => 'हस्ताक्षरसमयः केवलमुद्घोषः';

  @override
  String get signatureNoteUnverifiedTimeDetail =>
      'अयं समयः सञ्चिकाया हस्ताक्षरितभागाद् बहिर्न्यस्तः, अतः येन केनापि परिवर्तितः स्यात्।';

  @override
  String get signatureSignerLabel => 'हस्ताक्षरकर्ता';

  @override
  String get signatureSignerUnknown => 'न निर्दिष्टः';

  @override
  String get signatureSignedAtLabel => 'हस्ताक्षरदिनाङ्कः';

  @override
  String get signatureReasonLabel => 'कारणम्';

  @override
  String get signatureLocationLabel => 'स्थानम्';

  @override
  String get signatureCertificateTitle => 'प्रमाणपत्रम्';

  @override
  String get signatureIssuedToLabel => 'दत्तम्';

  @override
  String get signatureIssuedByLabel => 'दातारः';

  @override
  String get signatureValidFromLabel => 'मान्यारम्भः';

  @override
  String get signatureValidUntilLabel => 'मान्यावसानम्';

  @override
  String get signatureSelfSignedNote =>
      'इदं प्रमाणपत्रं स्वयमेव प्रमाणयति। अन्यः कोऽपि न समर्थयति, अतः हस्ताक्षरकर्तारं जानाति चेदेव विश्वसितु।';

  @override
  String get signatureTrustAction => 'इदं प्रमाणपत्रं विश्वस्यताम्';

  @override
  String get signatureTrustTitle =>
      'अस्मिन् हस्ताक्षरकर्तरि विश्वस्यताम् किम्?';

  @override
  String get signatureTrustExplain =>
      'इतः परम् अनेन प्रमाणपत्राङ्कितं यत्किमपि PDF विश्वसनीयत्वेन दृश्यते। हस्ताक्षरकर्तारं जानाति चेदेवैतत् करोतु।';

  @override
  String get signatureTrustConfirm => 'विश्वस्यताम्';

  @override
  String get signatureTrustedToast => 'प्रमाणपत्रं विश्वस्तम्।';

  @override
  String get trustStoreTitle => 'विश्वस्तप्रमाणपत्राणि';

  @override
  String get trustStoreEmpty => 'भवता अद्यापि किमपि प्रमाणपत्रं न विश्वस्तम्।';

  @override
  String get trustStoreEmptyDetail =>
      'यदा भवान् कस्यचित् प्रमाणपत्रं विश्वसिति, तदिहागच्छति। यदा कदापि तत् निष्कासयितुं शक्यते।';

  @override
  String get trustStoreAddAction => 'प्रमाणपत्रं योज्यताम्';

  @override
  String get trustStoreRemoveAction => 'निष्कास्यताम्';

  @override
  String get trustStoreRemoveTitle =>
      'अस्मिन् प्रमाणपत्राविश्वासः क्रियताम् किम्?';

  @override
  String get trustStoreRemoveExplain =>
      'अनेनाङ्कितानि PDF-पत्राणि विश्वस्तत्वेन न दर्शयिष्यन्ते।';

  @override
  String get trustStoreInvalidFile =>
      'सा सञ्चिका अस्यानुप्रयोगस्य पठनाहं प्रमाणपत्रं न भवति।';

  @override
  String get trustStoreExpiredWarning => 'अस्य प्रमाणपत्रस्य कालोऽतीतः।';

  @override
  String get trimMarginsAction => 'अनावृतसीमान्तः कर्त्यताम्';

  @override
  String get trimMarginsTitle => 'दक्षसीमान्तकर्तनम्';

  @override
  String get trimMarginsDescription => 'दूरवाणीपठनाय रिक्तसीमान्तान् कर्तयति।';

  @override
  String get trimMarginsWorking => 'रिक्तसीमान्ताः कृत्यन्ते…';

  @override
  String get trimMarginsDoneTitle => 'सीमान्ताः कर्तिताः';

  @override
  String get trimMarginsDoneNote =>
      'दूरवाणीपटलेभ्योऽनुकूलाः कृत्वा रिक्तसीमान्ताः कर्तिताः।';

  @override
  String get trimPaddingLabel => 'सीमान्तपूरणम्';

  @override
  String get trimPaddingTight => 'सङ्कीर्णम् (4 pt)';

  @override
  String get trimPaddingStandard => 'प्रमाणभूतम् (12 pt)';

  @override
  String get trimPaddingComfortable => 'सुखप्रदम् (24 pt)';

  @override
  String get trimSymmetricLabel => 'सममितसीमान्ताः';

  @override
  String get trimSymmetricHelp => 'वामदक्षिणसीमान्तयोः साम्यं रक्षति।';

  @override
  String get bookletAction => 'पुस्तिका रच्यताम्';

  @override
  String get bookletTitle => 'द्विपुटपुस्तिका (2-Up)';

  @override
  String get bookletDescription =>
      'उभयपक्षमुद्रणाय द्विपुटपुस्तिकाविन्यासं जनयति।';

  @override
  String get bookletWorking => 'पुस्तिकाविन्यासो निर्मीयते…';

  @override
  String get bookletDoneTitle => 'पुस्तिका रचिता';

  @override
  String get bookletDoneNote =>
      'उभयपक्षे मुद्रयित्वा (लघुसीम्नि परावृत्य) मध्यमेव पुटीक्रियताम्।';

  @override
  String get bookletSummaryTitle => 'पुस्तिकाविन्यासविवरणम्';

  @override
  String bookletSummaryPages(int source, int padded) {
    return '$source मूलपृष्ठानि -> $padded पुस्तिकापृष्ठानि';
  }

  @override
  String bookletSummarySheets(int sheets, int faces) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets भौततिर्यक्पत्राणि',
      one: '१ भौततिर्यक्पत्रम्',
    );
    return '$_temp0 ($faces मुद्रणपक्षेषु)';
  }

  @override
  String bookletSummaryBlanks(int blanks) {
    String _temp0 = intl.Intl.pluralLogic(
      blanks,
      locale: localeName,
      other: '$blanks रिक्तपूरकपृष्ठान्यन्ते योजितानि',
      one: '१ रिक्तपूरकपृष्ठमन्ते योजितम्',
    );
    return '$_temp0';
  }

  @override
  String get bookletBindingLabel => 'बन्धनदिक्';

  @override
  String get bookletBindingLtr => 'वामाद् दक्षिणम् (LTR)';

  @override
  String get bookletBindingRtl => 'दक्षिणाद् वामम् (RTL)';

  @override
  String get bookletPaperSizeLabel => 'पत्रपरिमाणम्';

  @override
  String get bookletPaperAuto => 'मूलानुकूलम्';

  @override
  String get bookletPaperA4 => 'A4 तिर्यक्';

  @override
  String get bookletPaperLetter => 'US Letter';

  @override
  String get bookletFoldGuideLabel => 'पुटरेखादर्शकम्';

  @override
  String get bookletFoldGuideHelp =>
      'यत्र पुस्तिका पुटीकरणीया तद्दर्शयितुं सूक्ष्मं बिन्दुरेखां लिखति।';

  @override
  String get appearanceTitle => 'स्वरूपम्';

  @override
  String get appearanceSubtitle => 'वर्णपरिपार्टी, लिपिमुद्रा, वर्णाश्च';

  @override
  String get themeModeTitle => 'वर्णपरिपार्टीप्रकारः';

  @override
  String get themeModeSubtitle =>
      'प्रकाशमय-अन्धकारमय-तन्त्रमूल-कपिशप्रकारेषु वृणुताम्';

  @override
  String get themeModeCardSubtitle =>
      'प्रकाशमयं, अन्धकारमयं, तन्त्रमूलं वा वृणुताम्';

  @override
  String get themeModeDescription =>
      'तन्त्रमूलप्रकारः यन्त्रस्य अन्धकारविन्यासमन्वेति। कपिशप्रकारस्तु नेत्रसुखाय सुखदपठनतलं ददाति।';

  @override
  String get typographyTitle => 'लिपिमुद्रा पाठ्यांशपरिमाणं च';

  @override
  String get typographySubtitle => 'अनुप्रयोगस्य लिपिमुद्रा पाठ्यांशपरिमाणं च';

  @override
  String get typographyDescription =>
      'पटलेषु सुगमपठनाय लिपिमुद्रां पाठ्यांशपरिमाणं चानुकूलयतु।';

  @override
  String get typographyFontLabel => 'लिपिमुद्रा';

  @override
  String get typographyTextSizeLabel => 'पाठ्यांशपरिमाणम्';

  @override
  String get fontSystemDefault => 'तन्त्रमूलम्';

  @override
  String get fontManjari => 'Manjari';

  @override
  String get fontAnekMalayalam => 'Anek Malayalam';

  @override
  String get fontNotoSansMalayalam => 'Noto Sans Malayalam';

  @override
  String get textSizeSmall => 'लघु';

  @override
  String get textSizeDefault => 'प्रमाणभूतम्';

  @override
  String get textSizeLarge => 'बृहत्';

  @override
  String get textSizeLarger => 'बृहत्तरम्';

  @override
  String get typographySampleLatin => 'The quick brown fox 0123';

  @override
  String get typographySampleMalayalam => 'മലയാളം സുന്ദരമാണ്';

  @override
  String get accentColorTitle => 'दीप्तवर्णः (Accent)';

  @override
  String get accentColorSubtitle =>
      'पूर्वनिर्दिष्टाः, वर्णचक्रम्, प्रत्यक्षमवलोकनम्';

  @override
  String get accentAppliesToLight =>
      'अयं वर्णः प्रकाशमयपरिपार्ट्यां प्रयुज्यते।';

  @override
  String get accentAppliesToDark =>
      'अयं वर्णः अन्धकारमयपरिपार्ट्यां प्रयुज्यते।';

  @override
  String get livePreviewLabel => 'प्रत्यक्षमवलोकनम्';

  @override
  String get sampleText => 'मातृकापाठ्यांशः';

  @override
  String get presetsLabel => 'पूर्वनिर्दिष्टानि';

  @override
  String get customColorWheelLabel => 'इच्छानुगुणवर्णचक्रम्';

  @override
  String get resetToDefault => 'मूलरूपं प्रत्यवस्थाप्यताम्';

  @override
  String get resetLightToDefault => 'प्रकाशमयपरिपार्टी प्रत्यवस्थाप्यताम्';

  @override
  String get resetDarkToDefault => 'अन्धकारमयपरिपार्टी प्रत्यवस्थाप्यताम्';

  @override
  String get contrastNotice => 'सुगमपठनाय पाठ्यांशवैषम्यं स्वयमेव साध्यते।';

  @override
  String get permissionsTitle => 'अनुमतयः';

  @override
  String get permissionsSubtitle =>
      'सङ्ग्रहः, काल्पनिकमुद्रणसेवा, गोपनीयतासामर्थ्यानि च';

  @override
  String get permissionsOpenSettings => 'तन्त्रविन्यासः उद्घात्यताम्';

  @override
  String get permissionsExplicitHeader => 'सामर्थ्यानि';

  @override
  String get permissionsExplicitSubtitle =>
      'सुरक्षितलेख्यप्रवेशाय रचिता विशेषास्तन्त्रभूमिकाश्च।';

  @override
  String get permissionsImplicitHeader => 'गोपनीयता तन्त्रोद्घोषाश्च';

  @override
  String get permissionsImplicitSubtitle =>
      'घोषणापत्रे उद्घोषितानि; शतप्रतिशतं सुरक्षितम् ऑफ्‌लाइन-कार्यम्।';

  @override
  String get permScopedStorageTitle => 'परिसीमितसङ्ग्रहः (SAF)';

  @override
  String get permScopedStorageReason =>
      'Android-तन्त्रस्य सञ्चिकाचायकेनोद्घाटित-PDF-पत्राणि केवलं पठति रक्षति च।';

  @override
  String get permPrintServiceTitle => 'PDF मुद्रणसेवा';

  @override
  String get permPrintServiceReason =>
      'अन्यानुप्रयोगेभ्यो मुद्रणकार्यं प्राप्य PDF रूपेण रक्षति।';

  @override
  String get permOfflineTitle => 'शतप्रतिशतम् ऑफ्‌लाइन गोपनीयं च';

  @override
  String get permOfflineReason =>
      'अन्तर्जालानुमतिरहिता। भवतः पत्राणि दत्तांशश्च कदापि यन्त्राद् बहिर्न गच्छन्ति।';

  @override
  String get permTtsTitle => 'पाठ्यांशोच्चारणयन्त्रम् (TTS)';

  @override
  String get permTtsReason =>
      'आङ्ग्ल-मलयाल-भाषाभ्यां लेख्यपठनाय संस्थापितवाग्यन्त्राणि पृच्छति।';

  @override
  String get permProcessTextTitle => 'पाठ्यांशप्रक्रियाकार्यम्';

  @override
  String get permProcessTextReason =>
      'अन्यानुप्रयोगेषु पाठ्यांशचयने शीघ्रावेषणं पाठ्यक्रियां च समर्थयति।';

  @override
  String get statusActive => 'सक्रियम्';

  @override
  String get statusSystem => 'तन्त्रमूलम्';

  @override
  String get statusOffline => 'ओफ्‌लाइन';

  @override
  String get trustStoreSubtitle =>
      'अङ्कीयहस्ताक्षरमूलप्रमाणपत्राणां प्रबन्धनम्';

  @override
  String get aboutSubtitle =>
      'अनुप्रयोगसंस्करणम्, अनुज्ञापत्राणि, विधिकविवरणं च';

  @override
  String get helpTitle => 'साहाय्यम्';

  @override
  String get helpSubtitle => 'मार्गदर्शिकाः, स्थापनाविन्यासाः, सूत्राणि च';

  @override
  String get helpPdfPrinterTitle => 'PDF मुद्रकसंस्थापनम्';

  @override
  String get helpPdfPrinterSubtitle =>
      'काल्पनिकमुद्रणसेवा कथं प्रवर्त्यते प्रयुज्यते च';

  @override
  String get helpPdfPrinterTopicHeader =>
      '१. Android-मध्ये PDF मुद्रकः कथं प्रवर्त्यते';

  @override
  String get helpPdfPrinterIntro =>
      'Android-तन्त्रे काल्पनिकमुद्रणसेवाः तन्त्रस्तरे नियम्यन्ते। SreerajP PDF App तन्त्रमुद्रकरूपेण प्रवर्तयितुम्:';

  @override
  String get helpPdfPrinterStep1 =>
      'भवतः Android-यन्त्रस्य विन्यासः (Settings) उद्घात्यताम्।';

  @override
  String get helpPdfPrinterStep2 =>
      'Connected devices → Connection preferences → Printing प्रति गम्यताम्।';

  @override
  String get helpPdfPrinterStep3 =>
      'Print services इत्यस्य चाधः SreerajP PDF App अन्विष्यताम्।';

  @override
  String get helpPdfPrinterStep4 => 'तत् स्पृष्ट्वा \'On\' इति परिवर्तयतु।';

  @override
  String get helpOpenPrintSettings => 'मुद्रणविन्यासः उद्घात्यताम्';

  @override
  String get helpUnicodePrintingTitle => 'यूनिकोड-मलयाल-PDF-मुद्रणम्';

  @override
  String get helpUnicodePrintingSubtitle => 'जटिलभारतीयलिपीनामखण्डितमुद्रणम्';

  @override
  String get helpUnicodePrintingTopicHeader =>
      'यूनिकोड-मलयालपाठ्यांशस्य यथार्थमुद्रणम्';

  @override
  String get helpUnicodePrintingIntro =>
      'मानक-Android-मुद्रणं कदाचित् जटिललिपीः (मलयाल-हिन्दी-संस्कृतादीः) विकरोति, येन खण्डिताक्षराणि लुप्ताक्षराणि वा भवन्ति। SreerajP PDF App लिपिगठनं मुद्रासंयोजनं च विधाय शुद्धं PDF जनयति।';

  @override
  String get helpUnicodePrintingStep1 =>
      'पूर्वं न कृतं चेत् Android-विन्यासे काल्पनिकमुद्रकः प्रवर्त्यताम्।';

  @override
  String get helpUnicodePrintingStep2 =>
      'यस्मिन् कस्मिन्नप्यनुप्रयोगे (Chrome, WhatsApp, Office) मुद्रणं (Print) वृणुताम्।';

  @override
  String get helpUnicodePrintingStep3 =>
      'मानक-\'Save as PDF\' स्थाने \'SreerajP PDF App\' मुद्रकरूपेण वृणुताम्।';

  @override
  String get helpUnicodePrintingStep4 =>
      'अनुप्रयोगः मुद्रणदत्तांशं गृहीत्वा यूनिकोड-वर्णान् संयोज्य स्पष्टं पठनीयं PDF रचयति।';

  @override
  String get helpUnicodePrintingTip =>
      'सूत्रम्: जालरचनानां मुद्रणे विज्ञापनशीर्षकाद्यपोहाय मुद्रकविन्यासे \'स्वच्छजालविषयः\' प्रवर्त्यताम्।';

  @override
  String get helpOpenPrinterSettings => 'मुद्रकविन्यासः उद्घात्यताम्';

  @override
  String get helpTtsTitle => 'उच्चैःपठनम् (TTS) मलयालवाणी च';

  @override
  String get helpTtsSubtitle =>
      'वाग्यन्त्रं, वाग्गतिं, मलयालसमर्थनं च विनिधत्त';

  @override
  String get helpTtsTopicHeader =>
      'उच्चैःपठनस्य प्रयोगः मलयालवाण्याः संस्थापनं च';

  @override
  String get helpTtsIntro =>
      'अनुप्रयोगः यन्त्रस्य पाठ्यांशोच्चारणयन्त्रेण (TTS) PDF पाठ्यांशमुच्चैः पठितुं शक्नोति। इदम् आङ्ग्लं मलयालं च समर्थयति।';

  @override
  String get helpTtsStep1 =>
      'पाठ्यांशयुक्तं PDF उद्घाट्य उपरितनपट्टिकायां \'उच्चैः पठ्यताम्\' (ध्वनिवर्धक) पिञ्जं स्पृशतु।';

  @override
  String get helpTtsStep2 =>
      'मलयालवाणी न संस्थापिता चेत् विन्यासः → उच्चैःपठनम् (TTS) गत्वा \'मलयालवाणी प्राप्यताम्\' स्पृशतु।';

  @override
  String get helpTtsStep3 =>
      'स्वपठनरीत्या सह सङ्गमनाय वाग्गतिं, स्वरतारतां, वाक्यावसानविरामं, स्वयञ्चलनं चानुकूलयितुं शक्यते।';

  @override
  String get helpTtsTip =>
      'सूचना: चयनयोग्यपाठ्यांशपटलहीनानि केवलचित्रयुक्तानि स्फुटितानि पत्राण्युच्चैः पठितुं न शक्यन्ते। OCR न समर्थितम्।';

  @override
  String get helpOpenTtsSettings => 'TTS विन्यासः उद्घात्यताम्';

  @override
  String get helpPageOpsTitle => 'पृष्ठकर्म सङ्घटनं च';

  @override
  String get helpPageOpsSubtitle =>
      'पृष्ठसंयोजन-विभाजन-पुनर्व्यवस्थापन-सङ्कोच-सुरक्षाः';

  @override
  String get helpPageOpsTopicHeader => 'PDF पृष्ठकर्मणां प्रयोगः';

  @override
  String get helpPageOpsIntro =>
      'SreerajP PDF App प्रतिलिपिकरणरीत्या (Copy-on-write) पृष्ठकर्म करोति। मूलसञ्चिका कदापि न विक्रियते।';

  @override
  String get helpPageOpsStep1 =>
      'PDF उद्घाट्य अधः स्थितसाधनपट्टिकायां \'पृष्ठसाधनानि\' स्पृशतु।';

  @override
  String get helpPageOpsStep2 =>
      'कर्म वृणुताम्: संयोजनं, विभाजनं, व्यवस्थापनं, सङ्कोचः, कूटशब्दरक्षणं, जलचिह्नं वा।';

  @override
  String get helpPageOpsStep3 =>
      'पृष्ठव्यवस्थापने पृष्ठानि चालयितुं, भ्रामयितुं, लोप्तुं च शक्यते।';

  @override
  String get helpPageOpsStep4 =>
      '\'रक्ष्यताम्\' स्पृश्य नूतनसञ्चिकाया नाम स्थानं च वृणुताम्।';

  @override
  String get helpPageOpsTip =>
      'सुरक्षानिश्चयः: कर्माणि नूतनसञ्चिकां रचयन्तीति हेतोः मूलसञ्चिकाविनाशभयं विना स्वच्छन्दं प्रयोक्तुं शक्यते।';

  @override
  String get helpSignaturesTitle => 'अङ्कीयहस्ताक्षराणि विश्वस्तसङ्ग्रहश्च';

  @override
  String get helpSignaturesSubtitle =>
      'ओफ्‌लाइन गूढलेखपरीक्षा प्रमाणपत्रप्रबन्धनं च';

  @override
  String get helpSignaturesTopicHeader => 'ओफ्‌लाइन-अङ्कीयहस्ताक्षरपरीक्षा';

  @override
  String get helpSignaturesIntro =>
      'SreerajP PDF App जालानुरोधं विनैव गूढलेखविधिना (SHA-256, X.509) हस्ताक्षराणि पूर्णतया ऑफ्‌लाइन परीक्षते।';

  @override
  String get helpSignaturesStep1 =>
      'हस्ताक्षरित-PDF-पत्रेोद्घाटने उपरितनपट्टिकायां हस्ताक्षरचिह्नं स्पृष्ट्वा विवरणानि पश्यतु।';

  @override
  String get helpSignaturesStep2 =>
      'हस्ताक्षरकरणानन्तरं लेख्यं परिवर्तितं न वेत्यनुप्रयोगः परीक्षते।';

  @override
  String get helpSignaturesStep3 =>
      'प्रमाणपत्रमविश्वस्तं चेत् मूलप्रमाणपत्रं विश्वस्तसङ्ग्रहे योजयितुं शक्यते।';

  @override
  String get helpSignaturesTip =>
      'सुरक्षासूचना: सर्वा परीक्षा यन्त्रे एव Kotlin-Bouncy Castle द्वारा क्रियते, बाह्यसर्वरे किमपि न प्रेष्यते।';

  @override
  String get helpOpenTrustStore => 'विश्वस्तसङ्ग्रहः उद्घात्यताम्';

  @override
  String get helpPrivacyStorageTitle => 'गोपनीयता परिसीमितसङ्ग्रहश्च';

  @override
  String get helpPrivacyStorageSubtitle =>
      'अन्तर्जालानुमतिराहित्यं परिसीमितसङ्ग्रहसुरक्षा च';

  @override
  String get helpPrivacyStorageTopicHeader =>
      'शतप्रतिशतम् ऑफ्‌लाइन गोपनीयताप्रतिज्ञा';

  @override
  String get helpPrivacyStorageIntro =>
      'भवतां गोपनीयता सर्वोपरि वर्तते। SreerajP PDF App अन्तर्जालसम्पर्कं विना एकान्ततया कार्यं कर्तुं निर्मितम्।';

  @override
  String get helpPrivacyStorageStep1 =>
      'शून्यान्तर्जालम्: अनुप्रयोगे INTERNET अनुमतिर्नास्ति। दत्तांशप्रेषणं विश्लेषणसङ्ग्रहो वा न सम्भवति।';

  @override
  String get helpPrivacyStorageStep2 =>
      'परिसीमितसङ्ग्रहः (SAF): Android-सञ्चिकाचायकेन चयनितसञ्चिका एवोद्घाट्यन्ते।';

  @override
  String get helpPrivacyStorageStep3 =>
      'क्षणिकसञ्चयप्रबन्धनम्: संस्मृतिसञ्चयाः सङ्ग्रहविन्यासाद् यदा कदापि शोधयितुं शक्यन्ते।';

  @override
  String get helpPrivacyStorageTip =>
      'कूटशब्दसुरक्षा: रक्षित-PDF-पत्राणां कूटशब्दाः क्षणिकस्मृतौ एव तिष्ठन्ति, चक्रे न रक्ष्यन्ते न वा लिख्यन्ते।';

  @override
  String get helpOpenStorageSettings => 'सङ्ग्रहगोपनीयता-विन्यासः उद्घात्यताम्';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageSubtitle => 'अनुप्रयोगभाषा वृणुताम्';

  @override
  String get languageSystem => 'तन्त्रमूलम्';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageMalayalam => 'മലയാളം (Malayalam)';

  @override
  String get languageSanskrit => 'संस्कृतम् (Sanskrit)';

  @override
  String get languageSelectTitle => 'अनुप्रयोगभाषा';

  @override
  String get languageSelectSubtitle =>
      'परिवर्तनं तत्क्षणमेव समग्रानुप्रयोगे फलति।';

  @override
  String get readerSettingsTitle => 'पाठकः दर्शकश्च';

  @override
  String get readerSettingsSubtitle =>
      'पठनस्थानं, विन्यासः, विस्तारः, प्रदर्शनं च';

  @override
  String get saveLastPositionTitle => 'पठनस्थानं स्मर्यताम्';

  @override
  String get saveLastPositionSubtitle =>
      'उद्घाटने अन्तिमवारं दृष्टं पृष्ठं विस्तारं च स्वयमेवानुसरति';

  @override
  String get defaultPageLayoutTitle => 'मूलभूतपृष्ठविन्यासः';

  @override
  String get defaultPageLayoutSubtitle =>
      'लेख्योद्घाटने पृष्ठप्रदर्शनावस्था वृणुताम्';

  @override
  String get layoutContinuous => 'निरन्तरप्रवाहः';

  @override
  String get layoutSinglePage => 'एकपृष्ठम्';

  @override
  String get doubleTapZoomTitle => 'द्विस्पर्शविस्तारः';

  @override
  String get doubleTapZoomSubtitle => 'PDF-पृष्ठे द्विस्पर्शेन कर्तव्यं कर्म';

  @override
  String get zoomFitWidth => 'विस्तारानुकूलम्';

  @override
  String get zoom200 => '२००% विस्तारः';

  @override
  String get showPageIndicatorTitle => 'पृष्ठसङ्ख्यासूचकम्';

  @override
  String get showPageIndicatorSubtitle =>
      'पठनसमये पटलोपरि पृष्ठसङ्ख्यागुटिकां दर्शयतु';

  @override
  String get invertColorsTitle => 'PDF वर्णा विपरीताः क्रियन्ताम्';

  @override
  String get invertColorsSubtitle =>
      'रात्रौ सुखपठनाय लेख्यवर्णा विपरीताः क्रियन्ते';

  @override
  String get ttsSettingsTitle => 'उच्चैःपठनम् (TTS)';

  @override
  String get ttsSettingsSubtitle => 'वाणी, वाग्गतिः, स्वरतारता, वाचनविकल्पाश्च';

  @override
  String get ttsSpeechRateTitle => 'वाग्गतिः';

  @override
  String ttsSpeechRateSubtitle(String rate) {
    return '${rate}x गतिः';
  }

  @override
  String get ttsPitchTitle => 'स्वरतारता';

  @override
  String ttsPitchSubtitle(String pitch) {
    return '${pitch}x तारता';
  }

  @override
  String get ttsAutoScrollTitle => 'वाक्प्रवाहेण सह स्वयञ्चलनम्';

  @override
  String get ttsAutoScrollSubtitle => 'वाक्यपठनेन सह लेख्यं स्वयमेव चालयतु';

  @override
  String get printerSettingsTitle => 'काल्पनिक-PDF-मुद्रकः';

  @override
  String get printerSettingsSubtitle =>
      'मुद्रणसंयोजनं, पत्रपरिमाणं, क्षणिकसञ्चयश्च';

  @override
  String get printerEnableTitle => 'PDF मुद्रकसंयोजनं प्रवर्त्यताम्';

  @override
  String get printerEnableSubtitle =>
      'अन्यानुप्रयोगेभ्यो मुद्रणकार्याणि स्वीकृत्य PDF रूपेण रक्षतु';

  @override
  String get defaultPaperSizeTitle => 'मूलभूतपत्रपरिमाणम्';

  @override
  String get defaultPaperSizeSubtitle =>
      'निर्मितानां PDF-पत्राणां मूलभूतायतनम्';

  @override
  String get defaultColorModeTitle => 'मूलभूतवर्णप्रकारः';

  @override
  String get defaultColorModeSubtitle => 'मुद्रितपत्राणां वर्णनिर्गमः';

  @override
  String get colorModeColor => 'सवर्णम्';

  @override
  String get colorModeGrayscale => 'धूसरचित्रम् (Grayscale)';

  @override
  String get colorModeMonochrome => 'एकवर्णम् (श्यामश्वेतम्)';

  @override
  String get defaultOrientationTitle => 'मूलभूतदिक्';

  @override
  String get defaultOrientationSubtitle => 'मुद्रणकार्याय पृष्ठदिक्';

  @override
  String get orientationAuto => 'स्वयम् (मूलानुकूलम्)';

  @override
  String get orientationPortrait => 'ऋजुदिक् (Portrait)';

  @override
  String get orientationLandscape => 'तिर्यग्दिक् (Landscape)';

  @override
  String get clearPrinterCacheTitle => 'मुद्रकक्षणिकसञ्चयः शोध्यताम्';

  @override
  String clearPrinterCacheSubtitle(String size) {
    return 'तात्कालिकानि मुद्रणसञ्चिकानि अपमृज्यताम् ($size)';
  }

  @override
  String get printerCacheCleared => 'मुद्रकक्षणिकसञ्चयः शोधितः।';

  @override
  String get storageSettingsTitle => 'सङ्ग्रहः गोपनीयता च';

  @override
  String get storageSettingsSubtitle => 'सद्यस्तनसञ्चिकेतिहासः संस्मृतिशोधनं च';

  @override
  String get rememberRecentFilesTitle => 'सद्यस्तनसञ्चिकाः स्मर्यन्ताम्';

  @override
  String get rememberRecentFilesSubtitle =>
      'उद्घाटितानि पत्राणि मुख्यपटले सद्यस्तनसूच्यां दर्शयतु';

  @override
  String get clearRecentFilesTitle => 'सद्यस्तनसञ्चिकेतिहासः शोध्यताम्';

  @override
  String get clearRecentFilesSubtitle =>
      'सर्वाण्युद्घाटितपत्रवृत्तानि रक्षितस्थानानि चापमृज्यताम्';

  @override
  String get clearRecentFilesConfirmTitle =>
      'सद्यस्तनसञ्चिकाः शोध्यन्ताम् किम्?';

  @override
  String get clearRecentFilesConfirmMessage =>
      'अनेन सद्यस्तनसूची पठनप्रगतिश्च शोधिष्येते। यन्त्रे स्थितानि मूल-PDF-पत्राणि न लुप्यन्ते।';

  @override
  String get clearRecentFilesAction => 'इतिहासः शोध्यताम्';

  @override
  String get recentFilesCleared => 'सद्यस्तनसञ्चिकेतिहासः शोधितः।';

  @override
  String get clearTempCacheTitle => 'अनुप्रयोगक्षणिकसञ्चयः शोध्यताम्';

  @override
  String clearTempCacheSubtitle(String size) {
    return 'दत्तांशलोपं विना तात्कालिकस्थानं मुच्यताम् ($size)';
  }

  @override
  String get tempCacheCleared => 'अनुप्रयोगक्षणिकसञ्चयः शोधितः।';

  @override
  String get securitySettingsTitle => 'हस्ताक्षराणि विश्वासश्च';

  @override
  String get securitySettingsSubtitle =>
      'अङ्कीयहस्ताक्षरपरीक्षा इच्छानुगुणप्रमाणपत्राणि च';

  @override
  String get autoVerifySignaturesTitle => 'हस्ताक्षराणां स्वयम्परीक्षा';

  @override
  String get autoVerifySignaturesSubtitle =>
      'हस्ताक्षरित-PDF-पत्राणामुद्घाटनेऽङ्कीयहस्ताक्षराणि स्वयमेव परीक्षन्ताम्';

  @override
  String get permFileProviderTitle => 'सुरक्षितसञ्चिकाप्रदाता';

  @override
  String get permFileProviderReason =>
      'रहस्यसञ्चिकामार्गाणां प्रकाशनेन विना तात्कालिक-PDF-पत्राणि निष्कासितानि पत्राणि च बाह्यानुप्रयोगैः सह विभजते।';

  @override
  String get permFileProviderWhatItAchieves =>
      'सङ्ग्रहसुरक्षाभङ्गेन विना बाह्यानुप्रयोगैः सह PDF-पत्राणां सुरक्षितविभजनं मुद्रणं च साधयति।';

  @override
  String get permTtsInstallTitle => 'वाणीदत्तांशावतारकम्';

  @override
  String get permTtsInstallReason =>
      'अपेक्षिता भाषावाणी न वर्तते चेत् तन्त्रावतारणपटलमुद्घाटयति।';

  @override
  String get permTtsInstallWhatItAchieves =>
      'मार्गभ्रंशं विना मलयाल-आङ्ग्लवाण्याः संस्थापनं सुगमं करोति।';

  @override
  String get permSendShareTitle =>
      'विभजनानाम् \'Open with\' इत्यस्य च स्वीकरणम्';

  @override
  String get permSendShareReason =>
      'अन्यानुप्रयोगेभ्यो विभक्तानि चित्राणि, सरलपाठ्यांशं, PDF-पत्राणि च प्राप्नोति।';

  @override
  String get permSendShareWhatItAchieves =>
      'विभक्तचित्राणां पाठ्यांशस्य च साक्षात् PDF रूपेण रूपान्तरणं यस्मात् कस्मादप्यनुप्रयोगात् PDF उद्घाटनानुमतिं च ददाति।';

  @override
  String get permZeroInternetTitle => 'शून्यान्तर्जालनिश्चयः';

  @override
  String get permZeroInternetReason =>
      'android.permission.INTERNET न याच्यते। अयं प्रयोगः शतप्रतिशतम् ऑफ्‌लाइन प्रवर्तते।';

  @override
  String get permZeroInternetWhatItAchieves =>
      'दत्तांशस्रावं, पदचिह्नान्वेषणं, दूरस्थदूरमापनं च विना पूर्णां गोपनीयतां निश्चिनोति।';

  @override
  String get permScopedStorageWhatItAchieves =>
      'यन्त्रस्य इतरभागानां गोपनीयतां रक्षता उपयोक्तृचयनित-PDF-पत्राणां पठनं रक्षणं च करोति।';

  @override
  String get permPrintServiceWhatItAchieves =>
      'अन्येभ्यः अनुप्रयोगेभ्यः SreerajP PDF App प्रति मुद्रणं प्रेषयित्वा PDF रूपेण रक्षितुमनुमन्यते।';

  @override
  String get permOfflineWhatItAchieves =>
      'भवतः पत्राणि व्यैक्तिकविवरणानि चास्माद् यन्त्रात् कदापि न बहिर्यान्तीति निश्चिनोति।';

  @override
  String get permTtsWhatItAchieves =>
      'आङ्ग्ल-मलयाल-भाषाभ्यां लेख्यपठनाय संस्थापितवाग्यन्त्राणि सम्प्रेक्षते।';

  @override
  String get permProcessTextWhatItAchieves =>
      'यस्मिन् कस्मिन्नप्यनुप्रयोगे चयनितपाठ्यांशं SreerajP PDF App मध्ये साक्षादन्वेष्टुमनुमन्यते।';

  @override
  String get permWhyNeededHeader => 'किमर्थमपेक्षितम्';

  @override
  String get permWhatItAchievesHeader => 'अनेन किं लभ्यते';

  @override
  String get permTypeExplicit => 'प्रत्यक्षसामर्थ्यम्';

  @override
  String get permTypeImplicit => 'परोक्षम् / तन्त्रानुरोधः';

  @override
  String get permTypePrivacy => 'गोपनीयतानिश्चयः';

  @override
  String get permissionsPrivacyHeader => 'गोपनीयता शून्यानुमतिनिश्चयश्च';

  @override
  String get permissionsPrivacySubtitle =>
      'घोषणापत्रात् सङ्कल्पपूर्वकं निष्कासिताः संकटास्पदानुमतयः।';

  @override
  String get permBindPrintServiceTitle => 'BIND_PRINT_SERVICE';

  @override
  String get permBindPrintServiceReason =>
      'केवलं Android-तन्त्रस्य मुद्रणप्रेषकः एव बद्धः स्यात् तथा काल्पनिकमुद्रणसेवां रक्षति।';

  @override
  String get permBindPrintServiceWhatItAchieves =>
      'अनधिकृतानुप्रयोगाः मुद्रणसेवाया दुरुप्रयोगं मुद्रणपत्राणां हरणं वा न कुर्युरिति निश्चिनोति।';

  @override
  String get permStoreQueriesTitle => 'अनुप्रयोगविपणि-जालानुरोधाः';

  @override
  String get permStoreQueriesReason =>
      'market://, https:// च सङ्केतद्वारा Google Play विपण्यां जालगवेषके चान्विष्यति।';

  @override
  String get permStoreQueriesWhatItAchieves =>
      'वाग्यन्त्रस्यानुपस्थितौ Google वाग्यन्त्रस्य साक्षात्संस्थापनं सुगमं करोति।';

  @override
  String get permViewPdfTitle => 'मूल-PDF-दर्शकम् (\'Open with\')';

  @override
  String get permViewPdfReason =>
      'PDF सञ्चिकाप्रकाराणामुद्घाटनाय तन्त्रेऽनुप्रयोगं पञ्जीकरोति।';

  @override
  String get permViewPdfWhatItAchieves =>
      'सञ्चिकाप्रबन्धकात्, ई-मेल-संलग्नात्, अवतरणस्थानाच्च साक्षात् PDF उद्घाटयितुमनुमन्यते।';

  @override
  String get permPrintManagerTitle => 'Android मुद्रणतन्त्रम्';

  @override
  String get permPrintManagerReason =>
      'Android-तन्त्रस्य PrintManager इत्यनेन मुद्रणप्रेषकेण च सह सम्भाषते।';

  @override
  String get permPrintManagerWhatItAchieves =>
      'यथार्थमुद्रकयन्त्रेषु मुद्रणाय तन्त्रमुद्रणपूर्वावलोकनाय च रूपसज्जित-PDF-पत्राणि प्रेषयति।';

  @override
  String get permNoBroadStorageTitle => 'विस्तृतसङ्ग्रहानुमतिराहित्यम्';

  @override
  String get permNoBroadStorageReason =>
      'READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, MANAGE_EXTERNAL_STORAGE वा न याच्यते।';

  @override
  String get permNoBroadStorageWhatItAchieves =>
      'यन्त्रे स्थितानि अन्यानि चित्राणि, पत्राणि, वैयक्तिकदत्तांशश्च सर्वथाऽप्रवेश्या भवन्तीति निश्चिनोति।';

  @override
  String get readingVelocityTitle => 'पठनगतिः समयगणनं च';

  @override
  String get readingVelocitySubtitle =>
      'भवतः पठनगतिमाधृत्य अवशिष्टपठनसमयं गणयति';

  @override
  String readingSpeedLabel(int wpm) {
    return '$wpm wpm';
  }

  @override
  String readingTimeLeftChapter(int minutes) {
    return 'अध्याये $minutes निमेषाः अवशिष्टाः';
  }

  @override
  String readingTimeLeftDoc(int minutes) {
    return '$minutes निमेषाः अवशिष्टाः';
  }

  @override
  String get readingTimeLessMinute => '< १ निमेषः अवशिष्टः';

  @override
  String get readingTimeEstimatesToggle => 'पठनसमयगणनम्';

  @override
  String get readingTimeEstimatesToggleSubtitle =>
      'पठनपट्टिकायामध्यायस्य लेख्यस्य चावशिष्टपठनसमयं दर्शयतु';

  @override
  String get viewModeAuto => 'स्वयम् (विस्तृते द्विपृष्ठम्)';

  @override
  String get viewModeAutoSubtitle =>
      'दूरवाण्यामेकपृष्ठं; फलके पुटपटले च पुस्तकवद् द्विपृष्ठम्';

  @override
  String get malayalamHelperTitle => 'मलयालकुञ्जीपटलसाहाय्यकम्';

  @override
  String get malayalamHelperTooltip =>
      'मलयाललेखनसाहाय्यकम् (मङ्ग्लिश-लेखनं कुञ्जीपटलश्च)';

  @override
  String get malayalamKeypadTabTranslit => 'मङ्ग्लिश';

  @override
  String get malayalamKeypadTabVowels => 'स्वराः';

  @override
  String get malayalamKeypadTabConsonants => 'व्यञ्जनानि';

  @override
  String get malayalamKeypadTabSigns => 'मात्राः चिल्लु च';

  @override
  String get ttsSentencePauseTitle => 'वाक्यावसाने विरामः';

  @override
  String ttsSentencePauseSubtitle(String seconds) {
    return 'वाक्ययोर्मध्ये $seconds क्षणविरामः';
  }

  @override
  String ttsReadingPage(int page) {
    return '$page पृष्ठं पठ्यते…';
  }

  @override
  String get ttsPaused => 'विरामः कृतः';

  @override
  String ttsReadyToRead(int page) {
    return '$page पृष्ठं पठितुं सज्जम्';
  }

  @override
  String get watermarkAction => 'इच्छानुगुणजलचिह्नम्';

  @override
  String get watermarkDescription =>
      'पृष्ठेषु पाठ्यांशस्य चित्रस्य वा जलचिह्नं योजयतु';

  @override
  String get watermarkDialogTitle => 'इच्छानुगुणजलचिह्नम्';

  @override
  String get watermarkTextLabel => 'जलचिह्नपाठ्यांशः';

  @override
  String get watermarkEmptyTextError => 'जलचिह्नपाठ्यांशः प्रविश्यताम्।';

  @override
  String get watermarkDoneTitle => 'जलचिह्नाङ्कित-PDF निर्मितम्';

  @override
  String get watermarkOpacityLabel => 'पारदर्शिता';

  @override
  String get watermarkRotationLabel => 'भ्रमणकोणः';

  @override
  String get watermarkFontSizeLabel => 'अक्षरपरिमाणम्';

  @override
  String get watermarkColorLabel => 'वर्णः';

  @override
  String get watermarkTiledLabel => 'पृष्ठव्यापिपौनःपुन्यम्';

  @override
  String get watermarkTiledDescription => 'समग्रे पृष्ठे जलचिह्नरूपमावर्तयति';

  @override
  String get watermarkPageRangeLabel => 'प्रयोक्तव्यपृष्ठानि';

  @override
  String get watermarkAllPages => 'सर्वाणि पृष्ठानि';

  @override
  String get watermarkOddPages => 'विषमपृष्ठानि केवलम्';

  @override
  String get watermarkEvenPages => 'समपृष्ठानि केवलम्';

  @override
  String get watermarkApplyAction => 'जलचिह्नं योज्यताम्';

  @override
  String get batchOperationsTitle => 'सङ्घकर्माणि';

  @override
  String get batchOperationsDescription => 'युगपदनेकानि PDF-पत्राणि संसाधयतु';

  @override
  String get batchOperationLabel => 'कर्म वृणुताम्';

  @override
  String get batchOpEncrypt => 'सङ्घगूढलेखनम् / रक्षणम्';

  @override
  String get batchOpMerge => 'सङ्घसंयोजनम्';

  @override
  String get batchOpExtractText => 'सङ्घपाठ्यांशनिष्कासनम् (.txt)';

  @override
  String get batchOpTrimMargins => 'सङ्घसीमान्तकर्तनम्';

  @override
  String get batchOpCompress => 'सङ्घसङ्कोचः';

  @override
  String batchSelectedFilesCount(int count) {
    return 'चयनितसञ्चिकाः ($count)';
  }

  @override
  String get batchAddFilesAction => 'सञ्चिकाः योज्यन्ताम्';

  @override
  String get batchNoFilesSelected =>
      'न कापि PDF-सञ्चिका चयिता। सञ्चिकाचयनार्थं \'सञ्चिकाः योज्यन्ताम्\' स्पृशतु।';

  @override
  String batchProgressLabel(int current, int total, String name) {
    return '$total-मध्ये $current संसाध्यते: $name';
  }

  @override
  String get batchStartAction => 'सङ्घकर्म प्रारभ्यताम्';

  @override
  String batchDoneSummary(int success, int total) {
    return '$total-मध्ये $success पत्राणि सफलं संसाधितानि।';
  }

  @override
  String get batchFailedAll => 'सर्वेषां पत्राणां सङ्घकर्म विफलम्।';

  @override
  String get nUpAction => 'N-Up बहुपृष्ठविन्यासः';

  @override
  String get nUpDescription => 'प्रत्येकपत्रे २, ४, ६, ९ वा पृष्ठानि संयोजयतु';

  @override
  String get nUpDialogTitle => 'N-Up बहुपृष्ठविन्यासः';

  @override
  String get nUpGridLabel => 'जालकविन्यासः';

  @override
  String get nUpSheetSizeLabel => 'पत्रपरिमाणम्';

  @override
  String get nUpSheetA4 => 'A4';

  @override
  String get nUpSheetLetter => 'US Letter';

  @override
  String get nUpOrientationLabel => 'पत्रदिक्';

  @override
  String get nUpOrientationAuto => 'स्वयम्';

  @override
  String get nUpOrientationPortrait => 'ऋजुदिक्';

  @override
  String get nUpOrientationLandscape => 'तिर्यग्दिक्';

  @override
  String get nUpBordersLabel => 'पृष्ठसीमाः लिख्यन्ताम्';

  @override
  String get nUpBordersDescription =>
      'प्रत्येकपृष्ठस्थानस्य परितः सूक्ष्मां सीमारेखां लिखति';

  @override
  String get nUpMarginLabel => 'सीमान्तपूरणम्';

  @override
  String get nUpDoneTitle => 'N-Up बहुपृष्ठ-PDF निर्मितम्';

  @override
  String get printNUpAction => 'N-Up बहुपृष्ठजालकं मुद्र्यताम्';

  @override
  String get printNUpDescription =>
      'एकस्मिन् पत्रे बहुपृष्ठानि मुद्रयतु (२-मध्ये-१, ४-मध्ये-१ इत्यादयः)';

  @override
  String get cleanWebContentTitle => 'स्वच्छजालविषयः (पाठकप्रकारः)';

  @override
  String get cleanWebContentSubtitle =>
      'रक्षणात् पूर्वं शीर्षकाणि, पादाः, पार्श्वपट्टिकाः, विज्ञापनानि चापसारयति';

  @override
  String pagesDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पृष्ठानि विलोपितानि',
      one: '१ पृष्ठं विलोपितम्',
    );
    return '$_temp0';
  }

  @override
  String organizeSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पृष्ठानि चयितानि',
      one: '१ पृष्ठं चयनितम्',
    );
    return '$_temp0';
  }

  @override
  String get selectAllAction => 'सर्वं चिनोतु';

  @override
  String get deselectAllAction => 'चयनं मुञ्चतु';

  @override
  String get invertSelectionAction => 'चयनं विपरिवर्तयतु';

  @override
  String get trustStoreExportAction => 'प्रमाणपत्रं निर्यात्यताम्';

  @override
  String get trustStoreExportAllAction => 'सर्वप्रमाणपत्राणि निर्यात्यन्ताम्';

  @override
  String trustStoreExportSuccess(String name) {
    return 'प्रमाणपत्रं $name मध्ये निर्यातितम्';
  }

  @override
  String get signatureTrustSignerAction => 'हस्ताक्षरकर्तरि विश्वस्यताम्';

  @override
  String get signatureUnnamed => 'अङ्कीयहस्ताक्षरम्';

  @override
  String get signatureTimeLabel => 'हस्ताक्षरकालः';

  @override
  String get signatureTimeClaimOnly => 'अपुष्टोद्घोषः';

  @override
  String get signatureIntegrityLabel => 'लेख्यशुद्धता';

  @override
  String get signatureIntegrityValid =>
      'हस्ताक्षरकरणानन्तरं लेख्यं न परिवर्तितम्';

  @override
  String get signatureIntegrityInvalid =>
      'हस्ताक्षरकरणानन्तरं लेख्यं परिवर्तितम्';

  @override
  String get signatureIntegrityUnknown => 'लेख्यशुद्धता ज्ञातुं न शक्ता';

  @override
  String get signatureCoverageLabel => 'व्याप्तिः';

  @override
  String get signatureCoversWholeFile => 'हस्ताक्षरं समग्रलेख्यं व्याप्नोति';

  @override
  String get signatureCoversPartialFile =>
      'हस्ताक्षरं लेख्यस्यैकभागमात्रं व्याप्नोति';

  @override
  String get signatureCertificateHeader => 'हस्ताक्षरकर्तृप्रमाणपत्रविवरणम्';

  @override
  String get featuresTitle => 'विशेषाः';

  @override
  String get featuresSubtitle =>
      'SreerajP PDF App अनुप्रयोगस्य सर्वविशेषाणां परिज्ञानम्';

  @override
  String get featuresHeaderTitle => 'SreerajP PDF App विशेषाः';

  @override
  String get featuresHeaderSubtitle =>
      'भवदर्थं निर्मितानां बुद्धिमत्साधनानां, गोपनीयताकवचानां, PDF-विशेषाणां चावलोकनं कुर्वन्तु।';

  @override
  String get featuresCategoryViewing => 'PDF दर्शनसञ्चालनतन्त्रम्';

  @override
  String get featuresCategoryViewingSubtitle =>
      'शीघ्रप्रस्तुतिः, निरन्तरप्रवाहः, पुस्तकदर्शनं, दक्षसञ्चालनं च';

  @override
  String get featuresCategorySearch => 'अन्वेषणम्, भारतीयध्वनिशास्त्रं, वाक् च';

  @override
  String get featuresCategorySearchSubtitle =>
      'सन्धियुक्तान्येवेषणम्, मलयाललिपिलेखनं, पाठ्यांशोच्चारणं च';

  @override
  String get featuresCategoryAnnotations => 'अङ्कनपटलः चिह्नानि च';

  @override
  String get featuresCategoryAnnotationsSubtitle =>
      'अविनाश्यङ्कनानि, तूलिकालेखनं, टिप्पण्यः, PDF-निर्यातः';

  @override
  String get featuresCategoryPageOps => 'पृष्ठकर्माणि पुनस्सङ्घटनं च';

  @override
  String get featuresCategoryPageOpsSubtitle =>
      'दृश्यपृष्ठव्यवस्थापकः, द्विपुटपुस्तिका, जलचिह्नानि, सङ्घसाधनानि च';

  @override
  String get featuresCategoryExtraction => 'दत्तांशनिष्कासनं साधनानि च';

  @override
  String get featuresCategoryExtractionSubtitle =>
      'सरलपाठ्यांशः, अन्तर्निहितचित्राणि, प्रपत्रक्षेत्राणि, विवरणानि च निष्कास्यन्ताम्';

  @override
  String get featuresCategoryPrinter => 'काल्पनिकमुद्रकः विभजनकेन्द्रं च';

  @override
  String get featuresCategoryPrinterSubtitle =>
      'तन्त्रव्यापी काल्पनिकमुद्रकः, जालशोधकः, चित्रपाठ्यरूपान्तरणं च';

  @override
  String get featuresCategorySignatures =>
      'अङ्कीयहस्ताक्षराणि विश्वस्तसङ्ग्रहश्च';

  @override
  String get featuresCategorySignaturesSubtitle =>
      'गूढलेखपरीक्षा, दर्शनमुद्राचिह्नानि, इच्छानुगुणविश्वस्तसङ्ग्रहश्च';

  @override
  String get featuresCategoryThemes => 'वर्णपरिपार्ट्यः विन्यासश्च';

  @override
  String get featuresCategoryThemesSubtitle =>
      'OLED अन्धकारपरिपार्टी, इच्छानुगुणलिपिमुद्रा, HSV वर्णचक्रं, विन्यासकेन्द्राणि च';

  @override
  String get featuresCategoryGuides => 'अन्तर्निर्मितमार्गदर्शिकाः';

  @override
  String get featuresCategoryGuidesSubtitle =>
      'विस्तृताः ऑफ्‌लाइन-पाठ्यक्रमाः दोषदूरीकरणसूत्राणि च';

  @override
  String get helpHeaderTitle => 'साहाय्यकेन्द्रं ज्ञानकोशश्च';

  @override
  String get helpHeaderSubtitle =>
      'SreerajP PDF App अनुप्रयोगस्य सर्वविशेषाणां विस्तृता मार्गदर्शिकाः समाधानानि च पश्यन्तु।';

  @override
  String get helpSectionPrinting => 'मुद्रणं रूपान्तरणं च';

  @override
  String get helpSectionReading => 'पठनं वाक् च';

  @override
  String get helpSectionPageOps => 'लेख्यकर्माणि';

  @override
  String get helpSectionSecurity => 'सुरक्षा गोपनीयता च';

  @override
  String get aboutVersionLabel => 'संस्करणम्';

  @override
  String get aboutBuildDateLabel => 'निर्माणदिनाङ्कः';

  @override
  String get imageFormatPngLossless => 'PNG (अक्षयम्)';

  @override
  String get imageFormatJpeg => 'JPEG';

  @override
  String nUpPagesPerSheet(int count) {
    return 'एकस्मिन् $count';
  }

  @override
  String pageJumpRangeHint(int min, int max) {
    return '$min – $max';
  }

  @override
  String get aboutDetailAuthor => 'रचयिता';

  @override
  String get aboutDetailEmail => 'विद्युत्पत्रम्';

  @override
  String get aboutDetailLicense => 'अनुज्ञापत्रम्';

  @override
  String get aboutDetailAiUsed => 'प्रयुक्त-AI';

  @override
  String get aboutDetailIdeUsed => 'प्रयुक्त-IDE';

  @override
  String madeWithLove(String heart) {
    return 'सस्नेहं निर्मितम् $heart भारततः';
  }

  @override
  String get madeWithLoveA11y => 'सस्नेहं निर्मितम् भारततः';

  @override
  String get menuTooltip => 'सूची';

  @override
  String get tooltipShowPassword => 'कूटशब्दः दृश्यताम्';

  @override
  String get tooltipHidePassword => 'कूटशब्दः गोप्यताम्';

  @override
  String get colorYellow => 'पीतः';

  @override
  String get colorGreen => 'हरितः';

  @override
  String get colorBlue => 'नीलः';

  @override
  String get colorRed => 'रक्तः';

  @override
  String get colorPurple => 'धूम्रः';

  @override
  String get colorOrange => 'काषायः';

  @override
  String aboutVersionBuild(String version, String build) {
    return '$version (निर्मितिसङ्ख्या $build)';
  }

  @override
  String get closeAction => 'पिदधातु';

  @override
  String get removeAction => 'निष्कासयतु';

  @override
  String get rotateScreenTooltip => 'पटं भ्रामयतु';

  @override
  String get screenOrientationTitle => 'पटदिक्';
}
