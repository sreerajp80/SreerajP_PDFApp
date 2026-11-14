// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sanskrit (`sa`).
class AppLocalizationsSa extends AppLocalizations {
  AppLocalizationsSa([String locale = 'sa']) : super(locale);

  @override
  String get titleApp => 'ग्रन्थः';

  @override
  String get titleHome => 'ग्रन्थः';

  @override
  String get bodyHomeEmpty =>
      'अद्यापि किमपि PDF न उद्घाटितम्। सञ्चिकानामुद्घाटनम् अग्रिमचरणे भविष्यति।';

  @override
  String get titleSettings => 'विन्यासः';

  @override
  String get labelSettingsTheme => 'वर्णपरिपार्टी';

  @override
  String get labelThemeSystem => 'तन्त्रमूलम्';

  @override
  String get labelThemeLight => 'प्रकाशमयम्';

  @override
  String get labelThemeDark => 'अन्धकारमयम्';

  @override
  String get labelThemeSepia => 'कपिशम् (Sepia)';

  @override
  String get labelThemeOled => 'गाढान्धकारमयम् (OLED)';

  @override
  String get titleAbout => 'विषयपरिचयः';

  @override
  String get labelOpenSettings => 'विन्यासः';

  @override
  String get labelOpenAbout => 'विषयपरिचयः';

  @override
  String get labelOpenPdf => 'PDF उद्घात्यताम्';

  @override
  String get titleRecentFiles => 'सद्यस्तनसञ्चिकाः';

  @override
  String get emptyRecentFiles =>
      'न कापि सद्यस्तनसञ्चिका वर्तते। पठनाय \"PDF उद्घात्यताम्\" स्पृश्यताम्।';

  @override
  String get labelRemoveFromRecents => 'निष्कास्यताम्';

  @override
  String get errorOpenFailed => 'सञ्चिकोद्घाटनं न शक्तम्।';

  @override
  String get errorReopenFailed =>
      'इयं सञ्चिका पुनरुद्घाटयितुं न शक्ता। अस्याः उद्घाटनस्य अनुमतिः नष्टा स्यात्, अथवा इयं चालिता वा विलोपिता वा स्यात्।';

  @override
  String get titleReopenFailed => 'इयं सञ्चिका पुनः उद्घाटयितुं न शक्यते';

  @override
  String get helpReopenFailed =>
      'अन्येन अनुप्रयोगेण उद्घाटिताः सञ्चिकाः (\"Open with\" द्वारा, सञ्चिकाचायके अन्यम् अनुप्रयोगं चित्वा वा) अयम् अनुप्रयोगः यावत् न पिधीयते तावदेव पुनः उद्घाटयितुं शक्यन्ते। सूच्यां स्थापयितुं सञ्चिकाचायकस्य स्वकीयेभ्यः संपुटेभ्यः सञ्चिकां पुनरेकवारं चिनुत।';

  @override
  String get labelFindFileAgain => 'सञ्चिकां अन्विष्यताम्';

  @override
  String descPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पृष्ठानि',
      one: '१ पृष्ठम्',
    );
    return '$_temp0';
  }

  @override
  String get labelViewModeContinuous => 'निरन्तरम्';

  @override
  String get labelViewModeSingle => 'एकपृष्ठम्';

  @override
  String get labelViewModeBook => 'द्विपृष्ठम्';

  @override
  String get tooltipViewMode => 'दर्शनरीतिः';

  @override
  String get labelFitWidth => 'विस्तारानुकूलम्';

  @override
  String get labelFitPage => 'पृष्ठानुकूलम्';

  @override
  String get labelPageFit => 'पृष्ठसङ्कोचः';

  @override
  String get labelZoomIn => 'विस्तार्यताम्';

  @override
  String get labelZoomOut => 'सङ्कोच्यताम्';

  @override
  String get labelResetZoom => 'आकारः प्रत्यवस्थाप्यताम्';

  @override
  String get labelInvertColors => 'नक्तं वर्णाः';

  @override
  String get titleContents => 'विषयसूची';

  @override
  String get emptyOutline => 'अस्य PDF-पत्रस्य विषयसूची न विद्यते।';

  @override
  String get titleThumbnails => 'पृष्ठानि';

  @override
  String get labelGoToPage => 'पृष्ठं गम्यताम्';

  @override
  String descPageOfPages(int current, int total) {
    return '$total-मध्ये $current पृष्ठम्';
  }

  @override
  String get labelPageNumberHint => 'पृष्ठसङ्ख्या';

  @override
  String get actionGo => 'गम्यताम्';

  @override
  String get actionCancel => 'निरस्यताम्';

  @override
  String get titlePassword => 'कूटशब्दोऽपेक्षितः';

  @override
  String get bodyPassword =>
      'इदं PDF रक्षितं वर्तते। पठनाय कूटशब्दः प्रविश्यताम्।';

  @override
  String get labelPasswordHint => 'कूटशब्दः';

  @override
  String get actionUnlock => 'उद्घात्यताम्';

  @override
  String get actionTryAgain => 'पुनः प्रयतताम्';

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
  String get descLargeFileWarning =>
      'इदं बृहत् PDF वर्तते, अतः सुगमपठनाय युगपदेकमेव पृष्ठमुद्घाट्यते।';

  @override
  String get labelLoadingPdf => 'उद्घाट्यते…';

  @override
  String get labelYes => 'आम्';

  @override
  String get titleMetadata => 'विवरणानि';

  @override
  String get actionMetadata => 'विवरणानि';

  @override
  String get labelMetadataFileSection => 'सञ्चिका';

  @override
  String get labelMetadataFileName => 'नाम';

  @override
  String get labelMetadataFileSize => 'परिमाणम्';

  @override
  String get labelMetadataPdfSection => 'PDF विवरणानि';

  @override
  String get errorMetadataUnavailable => 'एतानि विवरणानि पठितुं न शक्तानि।';

  @override
  String get descMetadataNoFields => 'इदं PDF स्वविवरणं न ददाति।';

  @override
  String get labelMetadataTitleField => 'शीर्षकम्';

  @override
  String get labelMetadataAuthor => 'रचयिता';

  @override
  String get labelMetadataSubject => 'विषयः';

  @override
  String get labelMetadataKeywords => 'मुख्यपदानि';

  @override
  String get labelMetadataCreator => 'निर्माता';

  @override
  String get labelMetadataProducer => 'उत्पादकः';

  @override
  String get labelMetadataCreated => 'रचितम्';

  @override
  String get labelMetadataModified => 'परिवर्तितम्';

  @override
  String get labelMetadataPages => 'पृष्ठानि';

  @override
  String get labelMetadataPdfVersion => 'PDF संस्करणम्';

  @override
  String get labelMetadataProtected => 'कूटशब्देन रक्षितम्';

  @override
  String get actionSearch => 'अन्वेषणम्';

  @override
  String get labelSearchHint => 'अस्मिन् PDF-पत्रेऽन्विष्यताम्';

  @override
  String get labelSearchClose => 'अन्वेषणं पिधीयताम्';

  @override
  String get labelSearchClear => 'अपमृज्यताम्';

  @override
  String get labelSearchNextMatch => 'अग्रिमपरिणामः';

  @override
  String get labelSearchPreviousMatch => 'पूर्वपरिणामः';

  @override
  String get labelSearchSearching => 'अन्विष्यते…';

  @override
  String get labelSearchNoMatches => 'परिणामाः न लब्धाः';

  @override
  String labelSearchMatchOf(int current, int total) {
    return '$total-मध्ये $current';
  }

  @override
  String descSearchLimitReached(int count) {
    return 'प्राथमिकाः $count परिणामाः दृश्यन्ते। दीर्घतरं पदं प्रयुज्यताम्।';
  }

  @override
  String get tooltipSearchOptions => 'अन्वेषणविकल्पाः';

  @override
  String get labelSearchOptionStrict => 'सटीकाक्षरविन्यासः';

  @override
  String get descSearchOptionStrictNote =>
      'संयुक्त-असंयुक्त-रूपयोर्भेदः क्रियताम्';

  @override
  String get labelSearchOptionIgnoreAccents => 'स्वरचिह्नान्युपेक्ष्यन्ताम्';

  @override
  String get descSearchOptionIgnoreAccentsNote =>
      'संस्कृतवैदिकस्वरचिह्नोपेक्षायामुपयुक्तम्';

  @override
  String get descSearchOptionSandhi => 'सन्धियुक्तपदान्वेषणम्';

  @override
  String get descSearchOptionSandhiNote =>
      'सन्धियुक्त-पदच्छेद-रूपान्वेषणम् (मलयाल-संस्कृतयोः)';

  @override
  String get labelSearchOptionPhonetic => 'ध्वनिसाम्यान्वेषणम्';

  @override
  String get descSearchOptionPhoneticNote =>
      'समानोच्चारण-अनुस्वार-चिल्लुभेदान्वेषणम्';

  @override
  String get titleNoText => 'न कोऽपि चयनयोग्यः पाठ्यांशः';

  @override
  String get bodyNoText =>
      'अस्मिन् PDF-पत्रे पाठ्यांशपटलः न वर्तते, अतः चित्रवद् दृश्यते। अन्वेषणं, प्रतिलिपिः, उच्चैःपठनं च न लभ्यते। अयं प्रयोगः चित्रेभ्यः पाठ्यांशं न पठति।';

  @override
  String get titleGarbledText => 'पाठ्यांशः साधु पठितुं न शक्यते';

  @override
  String get bodyGarbledText =>
      'अस्य PDF-पत्रस्य लिपिमुद्राः अक्षराणि स्पष्टं न सूचयन्ति, अतः अन्वेषणमुच्चैःपठनं च अशुद्धफलं दद्यात्। तथापि पृष्ठपठनं प्रवर्तते।';

  @override
  String get descSearchUnavailableNoText =>
      'अन्वेषणाय चयनयोग्यः पाठ्यांशोऽपेक्षितः, यश्चास्मिन् न विद्यते।';

  @override
  String get descSearchUnavailableGarbled =>
      'पाठ्यांशस्य साधु पठनाभावात् अन्वेषणं स्तम्भितम्।';

  @override
  String get titleUnreliableText => 'पाठ्यांशः अशुद्धः स्यात्';

  @override
  String get bodyUnreliableText =>
      'अस्य PDF-पत्रस्य पाठ्यांशः शुद्धे यूनिकोड-रूपे न स्यात्। अन्वेषणे केचन शब्दाः न लभ्येरन्, उच्चैःपठने च अशुद्धं पठ्येत। तथापि पृष्ठपठनं प्रवर्तते।';

  @override
  String get descSearchUnreliable =>
      'अस्य पाठ्यांशः शुद्धे यूनिकोड-रूपे न स्यात्, अतः केचन परिणामाः लुप्ताः अशुद्धाः वा स्युः।';

  @override
  String get actionDismiss => 'अवगतम्';

  @override
  String get labelTtsReadAloud => 'उच्चैः पठ्यताम्';

  @override
  String get labelTtsPause => 'विरामः';

  @override
  String get labelTtsStop => 'स्थग्यताम्';

  @override
  String get tooltipTtsSpeed => 'पठनवेगः';

  @override
  String labelTtsSpeedValue(String rate) {
    return '$rate×';
  }

  @override
  String get descTtsUnavailableNoText =>
      'उच्चैःपठनाय चयनयोग्यः पाठ्यांशोऽपेक्षितः, यश्चास्मिन् न विद्यते।';

  @override
  String get descTtsUnavailableGarbled =>
      'पाठ्यांशस्य साधु पठनाभावात् उच्चैःपठनं स्तम्भितम्।';

  @override
  String get descTtsUnavailableNoVoice =>
      'अस्मिन् यन्त्रे न कापि वाग्युक्तिः संस्थापिता।';

  @override
  String get descTtsNothingToRead => 'अस्मिन् पृष्ठे पठनाय न किमपि विद्यते।';

  @override
  String get descTtsMalayalamVoiceOff =>
      'इदं पृष्ठं मलयाळभाषायाम् अस्ति। विन्यासः › उच्चैःपठनम् इत्यत्र मलयाळवाणी सक्रिया क्रियताम्।';

  @override
  String get descTtsMalayalamVoiceMissing =>
      'इदं पृष्ठं मलयाळभाषायाम् अस्ति, किन्तु मलयाळवाणी न संस्थापिता।';

  @override
  String get descTtsNoSanskritVoice =>
      'इदं पृष्ठं संस्कृतभाषायाम् अस्ति। संस्कृतवाणी नास्ति, अतः एतद् उच्चैः पठितुं न शक्यते।';

  @override
  String get actionTtsOpenSettings => 'विन्यासः';

  @override
  String get labelSettingsReadAloud => 'उच्चैःपठनम्';

  @override
  String get labelSettingsMalayalamVoice => 'मलयालवाणी';

  @override
  String get descSettingsMalayalamVoiceReady =>
      'सज्जा। मलयालपाठ्यांशः मलयालवाण्या पठिष्यते।';

  @override
  String get descSettingsMalayalamVoiceOff =>
      'मलयालपाठ्यांशः आङ्ग्लवाण्या पठ्यते।';

  @override
  String get descSettingsMalayalamVoiceNeedsInstall =>
      'मलयालवाणी अद्यापि नावतारिता।';

  @override
  String get errorSettingsMalayalamVoiceUnavailable =>
      'अस्य यन्त्रस्य वाग्यन्त्रं मलयालं न समर्थयति।';

  @override
  String get labelSettingsMalayalamVoiceChecking => 'परीक्ष्यते…';

  @override
  String get titleTtsInstall => 'मलयालवाणी प्राप्यताम्';

  @override
  String get bodyTtsInstall =>
      'अस्मिन् दूरवाणी-यन्त्रे अद्यापि मलयालवाणी नास्ति। एतेषु एकं प्रयुज्यताम्:';

  @override
  String get labelTtsInstallVoiceData => 'वाणीदत्तांशः अवतार्यताम्';

  @override
  String get labelTtsOpenTtsSettings => 'वाग्विन्यासः उद्घात्यताम्';

  @override
  String get descTtsOpenPlayStore => 'गूगल-वाक्सेवाः प्राप्यन्ताम्';

  @override
  String get descTtsInstallDoneNote =>
      'संस्थापनानन्तरम् अत्रागच्छतु — वाणीसज्जतायां सत्यां विन्यासः स्वयमेव प्रवर्तते।';

  @override
  String get descTtsInstallCannotOpen =>
      'इदं दूरवाणी-यन्त्रं तत्पटलमुद्घाटयितुं न शक्तम्।';

  @override
  String get descTtsVoiceLostNotice =>
      'मलयालवाणी न संस्थापिता वर्तते, अतः विन्यासः स्तम्भितः।';

  @override
  String get labelExtractAndConvert => 'निष्कासनं रूपान्तरणं च';

  @override
  String get actionExtractText => 'पाठ्यांशः निष्कास्यताम्';

  @override
  String get actionExtractImages => 'चित्राणि निष्कास्यन्ताम्';

  @override
  String get actionConvertPdf => 'चित्रेषु रूपान्तर्यताम्';

  @override
  String get actionFormFields => 'प्रपत्रक्षेत्राणि';

  @override
  String get descExtractionSuccess => 'निष्कासनं सम्पन्नम्';

  @override
  String get errorExtractionFailed => 'निष्कासनं विफलम्';

  @override
  String get labelExtractingProgress => 'विषयः निष्कास्यते…';

  @override
  String get labelRangeAll => 'सर्वाणि पृष्ठानि';

  @override
  String descRangeCurrent(int page) {
    return 'वर्तमानपृष्ठम् ($page पृष्ठम्)';
  }

  @override
  String get labelRangeCustom => 'इच्छानुगुणं पृष्ठक्षेत्रम्';

  @override
  String get labelStartPage => 'आरम्भपृष्ठम्';

  @override
  String get labelEndPage => 'अन्तिमपृष्ठम्';

  @override
  String get labelInvalidPageRange => 'अमान्यं पृष्ठक्षेत्रम्';

  @override
  String get labelImageFormat => 'चित्रप्रारूपम्';

  @override
  String descResolution(int dpi) {
    return 'विभेदनम्: $dpi DPI';
  }

  @override
  String get labelFieldsNameHeader => 'क्षेत्रनाम';

  @override
  String get labelFieldsValueHeader => 'मूल्यम्';

  @override
  String get emptyFormFieldsFound =>
      'अस्मिन् PDF-पत्रे न कानिचित् प्रपत्रक्षेत्राणि लब्धानि।';

  @override
  String get emptyImagesFound => 'चयनितपृष्ठेषु न कानिचित् चित्राणि लब्धानि।';

  @override
  String get actionShare => 'विभज्यताम्';

  @override
  String get actionShareFile => 'सञ्चिकारूपेण विभज्यताम्';

  @override
  String get actionCopyClipboard => 'फलके प्रतिलिप्यताम्';

  @override
  String get labelCopySuccess => 'फलके प्रतिलिपिः कृता';

  @override
  String get titlePreviewText => 'निष्कासितपाठ्यांशप्राग्दर्शनम्';

  @override
  String get titleFormFields => 'संवादप्रपत्रक्षेत्राणि';

  @override
  String get titlePageTools => 'पृष्ठसाधनानि';

  @override
  String get actionMerge => 'PDF-सञ्चिकाः संयोज्यन्ताम्';

  @override
  String get descMerge => 'इमां PDF-सञ्चिकामन्याभिः सह नूतनसञ्चिकारूपेण योजयतु';

  @override
  String get titleMergeDone => 'PDF-सञ्चिकाः योजिताः';

  @override
  String get actionSplit => 'पृष्ठेषु विभज्यताम्';

  @override
  String get descSplit => 'प्रत्येकपृष्ठायैकां नूतनसञ्चिकां रचयतु';

  @override
  String get titleSplitDone => 'PDF विभक्तम्';

  @override
  String get actionOrganize => 'पृष्ठानि व्यवस्थाप्यन्ताम्';

  @override
  String get descOrganize =>
      'पृष्ठानि पुनर्व्यवस्थाप्यन्तां भ्राम्यन्तां लुप्यन्तां वा';

  @override
  String get titleOrganize => 'पृष्ठानि व्यवस्थाप्यन्ताम्';

  @override
  String get helpOrganize =>
      'पुनर्व्यवस्थापनायाकर्षतु। पृष्ठस्य भ्रमणाय विलोपनाय वा पिञ्जानि प्रयुञ्जीत। रक्षणेन नूतनसञ्चिका निर्मीयते।';

  @override
  String get titleOrganizeDone => 'पृष्ठानि व्यवस्थापितानि';

  @override
  String get actionCompress => 'सङ्कुच्यताम्';

  @override
  String get descCompress => 'लघुतरा प्रतिलिपिः क्रियताम् (यथामति)';

  @override
  String get titleCompressDone => 'PDF सङ्कुचितम्';

  @override
  String get descCompressBestEffortNote =>
      'सङ्कोचः साध्यप्रयत्नेन भवति। पूर्वमनुकूलिताः सञ्चिकाः बहु न सङ्कुचन्ति।';

  @override
  String get actionProtect => 'कूटशब्देन रक्ष्यताम्';

  @override
  String get descProtect => 'नूतनप्रतिलिपये कूटशब्दं योजयतु';

  @override
  String get titleProtect => 'PDF रक्ष्यताम्';

  @override
  String get titleProtectDone => 'PDF रक्षितम्';

  @override
  String get actionRemovePassword => 'कूटशब्दो निष्कास्यताम्';

  @override
  String get descUnlock =>
      'कूटशब्दरहितां प्रतिलिपिं रचयतु (वर्तमानकूटशब्दोऽपेक्षितः)';

  @override
  String get titleUnlock => 'कूटशब्दो निष्कास्यताम्';

  @override
  String get titleUnlockDone => 'कूटशब्दो निष्कासितः';

  @override
  String get labelUserPassword => 'कूटशब्दः (सञ्चिकोद्घाटनाय)';

  @override
  String get labelOwnerPassword => 'स्वामिकूटशब्दः (ऐच्छिकः)';

  @override
  String get helpOwnerPassword =>
      'मुद्रणं सम्पादनं च नियन्त्रयति। उद्घाटनकूटशब्दानुरूपाय रिक्तं त्यज्यताम्।';

  @override
  String get labelCurrentPassword => 'वर्तमानकूटशब्दः';

  @override
  String get errorPasswordRequired => 'कूटशब्दः प्रविश्यताम्।';

  @override
  String get labelWorkingProgress => 'क्रियते…';

  @override
  String get errorOpFailed => 'कार्यं विफलम्';

  @override
  String get actionSave => 'रक्ष्यताम्';

  @override
  String get errorSaveFailed => 'सञ्चिकां रक्षितुं न शक्तम्';

  @override
  String bodySavedFile(String name) {
    return '$name रक्षितम्';
  }

  @override
  String labelResultOneFile(String name) {
    return 'नूतनसञ्चिका: $name';
  }

  @override
  String descResultManyFiles(int count) {
    return '$count नूतनसञ्चिकाः रचिताः।';
  }

  @override
  String labelPage(int page) {
    return '$page पृष्ठम्';
  }

  @override
  String labelRotatedBy(int degrees) {
    return '$degrees° भ्रमितम्';
  }

  @override
  String bodyPageDeleted(int page) {
    return '$page पृष्ठं निष्कासितम्';
  }

  @override
  String get actionUndo => 'पूर्ववत् क्रियताम्';

  @override
  String get actionRotate => 'भ्राम्यताम्';

  @override
  String get actionDeletePage => 'पृष्ठं लुप्यताम्';

  @override
  String get errorNoPagesLeft => 'न्यूनातिन्यूनमेकं पृष्ठं धार्यताम्।';

  @override
  String get actionAnnotate => 'अङ्क्यताम्';

  @override
  String get labelAnnotationHighlight => 'उद्भासनम्';

  @override
  String get labelAnnotationUnderline => 'अधोरेखाङ्कनम्';

  @override
  String get labelAnnotationStrikethrough => 'मध्यरेखाङ्कनम्';

  @override
  String get labelAnnotationInk => 'आलेखनम्';

  @override
  String get descAnnotationNote => 'टिप्पणी';

  @override
  String get labelAnnotationEraser => 'मार्जनम्';

  @override
  String get labelAnnotationClearAll => 'सर्वाङ्कनानि मार्ज्यन्ताम्';

  @override
  String get descAnnotationExport => 'साङ्कनप्रतिलिपिः निर्यात्यताम्';

  @override
  String get descAnnotationOverlayNotice =>
      'एतानि अङ्कनानि अस्मिन्नेवानुप्रयोगे रक्ष्यन्ते। PDF-पत्रे रक्षणाय साङ्कनप्रतिलिपिं निर्यापयतु।';

  @override
  String get errorAnnotationTextMarkupUnavailable =>
      'अस्मिन् PDF-पत्रे अङ्कनाय न कोऽपि चयनयोग्यः पाठ्यांशो वर्तते।';

  @override
  String get descAnnotationExporting => 'साङ्कनप्रतिलिपिः निर्मीयते…';

  @override
  String get errorAnnotationExportFailed =>
      'साङ्कनप्रतिलिपिं निर्यापयितुं न शक्तम्।';

  @override
  String get descAnnotationNothingToExport => 'प्रथममङ्कनं योज्यताम्।';

  @override
  String get titleAnnotationClearAll => 'सर्वाङ्कनानि मार्ज्यन्ताम् किम्?';

  @override
  String get bodyAnnotationClearAll =>
      'अनेन अस्याः सञ्चिकायाः सर्वाङ्कनानि लुप्यन्ते। इदं पूर्ववत् कर्तुं न शक्यते।';

  @override
  String get titleNote => 'टिप्पणी';

  @override
  String get labelNoteHint => 'टिप्पणीं लिखतु';

  @override
  String get actionDelete => 'लुप्यताम्';

  @override
  String get titleBookmarks => 'पत्रचिह्नानि';

  @override
  String get actionBookmarks => 'पत्रचिह्नानि';

  @override
  String get emptyBookmarks => 'न कानिचित् पत्रचिह्नानि वर्तन्ते।';

  @override
  String labelBookmarkAddCurrent(int page) {
    return '$page पृष्ठे पत्रचिह्नं योज्यताम्';
  }

  @override
  String descBookmarkRemoveCurrent(int page) {
    return '$page पृष्ठस्य पत्रचिह्नं निष्कास्यताम्';
  }

  @override
  String labelBookmarkPage(int page) {
    return '$page पृष्ठम्';
  }

  @override
  String get errorShareFailed => 'इमां सञ्चिकां विभक्तुं न शक्तम्।';

  @override
  String get titleImport => 'PDF रूपेण रक्ष्यताम्';

  @override
  String get labelImportBuilding => 'भवतः PDF निर्मीयते…';

  @override
  String get titleImportReady => 'भवतः PDF सज्जम्';

  @override
  String descImportImagesSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चित्रेभ्यो निर्मितम्',
      one: '१ चित्रात् निर्मितम्',
    );
    return '$_temp0';
  }

  @override
  String get descImportTextSummary => 'भवता विभक्तपाठ्यांशेन निर्मितम्।';

  @override
  String labelImportSize(String size) {
    return 'परिमाणम्: $size';
  }

  @override
  String get actionImportSave => 'PDF रूपेण रक्ष्यताम्';

  @override
  String get actionImportShare => 'विभज्यताम्';

  @override
  String labelImportSaved(String name) {
    return '$name रक्षितम्';
  }

  @override
  String get titleImportFailed => 'PDF निर्मातुं न शक्तम्';

  @override
  String get titleImportUnsupportedText => 'असमर्थितानि अक्षराणि';

  @override
  String get descImportUnsupportedTextDetail =>
      'अयं प्रयोगः केवलमाङ्ग्लवर्णान् सङ्ख्याश्च PDF-पत्रे लेखितुं शक्नोति। मलयालमन्याश्च लिपयोऽद्यापि न समर्थिताः। पाठ्यांशस्य चित्रं साधु रक्षिष्यते।';

  @override
  String get actionPrint => 'मुद्र्यताम्';

  @override
  String get titlePrint => 'मुद्रणम्';

  @override
  String get actionPrintWhole => 'समग्रलेख्यम्';

  @override
  String get descPrintWhole =>
      'अस्य PDF-पत्रस्य सर्वाणि पृष्ठानि मुद्र्यन्ताम्।';

  @override
  String get actionPrintRange => 'पृष्ठक्षेत्रम्';

  @override
  String get descPrintRange => 'कानि पृष्ठानि मुद्रणीयानीति वृणुताम्।';

  @override
  String get actionPrintText => 'केवलपाठ्यांशः';

  @override
  String get descPrintText =>
      'अस्य PDF-पत्रस्य पदानि सरलपृष्ठरूपेण मुद्र्यन्ताम्।';

  @override
  String get titlePrintRange => 'मुद्रणीयानि पृष्ठानि';

  @override
  String get labelPrintFrom => 'अस्मात् पृष्ठात्';

  @override
  String get labelPrintTo => 'अस्मिन् पृष्ठे';

  @override
  String descPrintRangeInvalid(int pageCount) {
    return '१ तः $pageCount यावत् पृष्ठक्षेत्रं प्रविशतु।';
  }

  @override
  String get descPrintPreparing => 'पृष्ठानि सज्जीक्रियन्ते…';

  @override
  String get errorPrintUnavailable => 'इदं यन्त्रं मुद्रयितुं न शक्नोति।';

  @override
  String get errorPrintFailed => 'मुद्रणारम्भो न जातः।';

  @override
  String get descPrintNoText => 'अस्मिन् PDF-पत्रे मुद्रणाय पाठ्यांशो नास्ति।';

  @override
  String get actionSignatures => 'हस्ताक्षराणि';

  @override
  String get titleSignatures => 'हस्ताक्षराणि';

  @override
  String get labelSignaturesChecking => 'हस्ताक्षराणि परीक्ष्यन्ते…';

  @override
  String get descSignaturesNone => 'इदं PDF न हस्ताक्षरितम्।';

  @override
  String get errorSignaturesFailed =>
      'एतानि हस्ताक्षराणि परीक्षितुं न शक्तानि।';

  @override
  String get descSignaturesFailedDetail =>
      'अनेन हस्ताक्षराणि दुष्टानीति न ज्ञायते। अनुप्रयोगः तानि पठितुं न शक्तः, अतः किमपि न कथयति।';

  @override
  String get labelSignatureStatusTrusted => 'हस्ताक्षरितं विश्वस्तं च';

  @override
  String get descSignatureStatusTrustedDetail =>
      'हस्ताक्षरकरणानन्तरं लेख्यं न परिवर्तितम्, भवान् हस्ताक्षरकर्तुः प्रमाणपत्रं विश्वसिति च।';

  @override
  String get descSignatureStatusValidNotTrusted =>
      'हस्ताक्षरितं, किन्तु हस्ताक्षरकर्ता अज्ञातः';

  @override
  String get descSignatureStatusValidNotTrustedDetail =>
      'हस्ताक्षरकरणानन्तरं लेख्यं न परिवर्तितम्। किन्तु अनुप्रयोगः हस्ताक्षरकर्तारं न जानाति, अतः तस्य सत्यतां न वदति।';

  @override
  String get descSignatureStatusInvalid => 'अमान्यं हस्ताक्षरम्';

  @override
  String get descSignatureStatusInvalidDetail =>
      'हस्ताक्षरकरणानन्तरं लेख्यं परिवर्तितम्, हस्ताक्षरं वा न सङ्गच्छते। अस्मिन् विश्वासो न कार्यः।';

  @override
  String get descSignatureStatusUnknown => 'अज्ञातं हस्ताक्षरम्';

  @override
  String get descSignatureStatusUnknownDetail =>
      'अनुप्रयोगः अस्य हस्ताक्षरस्यार्थं ज्ञातुं न शक्तः, अतः इदं साधु वा दुष्टं वेति न कथयति।';

  @override
  String get descSignatureNotePartialCoverage =>
      'सञ्चिकाया एकभागमात्रमन्तर्भवति';

  @override
  String get descSignatureNotePartialCoverageDetail =>
      'हस्ताक्षरकरणानन्तरमस्यां सञ्चिकायां किमपि योजितम्। हस्ताक्षरं तद्भागं न वर्णयति।';

  @override
  String get descSignatureNoteRevoked => 'प्रमाणपत्रं निरस्तम्';

  @override
  String get descSignatureNoteRevokedDetail =>
      'येनेदं प्रमाणपत्रं दत्तं तेनैव निरस्तम्। अत्र विश्वासो न कर्तव्यः।';

  @override
  String get descSignatureNoteRevocationNotChecked =>
      'प्रमाणपत्रं निरस्तं न वेति परीक्षितुं न शक्तम्';

  @override
  String get descSignatureNoteRevocationNotCheckedDetail =>
      'तस्य परीक्षाया अन्तर्जालमपेक्षितम्, यदयं प्रयोगः कदापि न प्रयुङ्क्ते। अस्मिन् PDF-पत्रे च तत्प्रमाणं नास्ति।';

  @override
  String get descSignatureNoteCertExpired =>
      'हस्ताक्षरकरणकाले प्रमाणपत्रमतीतकालं वर्तते स्म';

  @override
  String get descSignatureNoteCertExpiredDetail =>
      'हस्ताक्षरकाले प्रमाणपत्रं स्वमान्यदिनाङ्केभ्यो बहिरासीत्।';

  @override
  String get descSignatureNoteUnverifiedTime => 'हस्ताक्षरसमयः केवलमुद्घोषः';

  @override
  String get descSignatureNoteUnverifiedTimeDetail =>
      'अयं समयः सञ्चिकाया हस्ताक्षरितभागाद् बहिर्न्यस्तः, अतः येन केनापि परिवर्तितः स्यात्।';

  @override
  String get labelSignatureSigner => 'हस्ताक्षरकर्ता';

  @override
  String get labelSignatureSignerUnknown => 'न निर्दिष्टः';

  @override
  String get labelSignatureSignedAt => 'हस्ताक्षरदिनाङ्कः';

  @override
  String get labelSignatureReason => 'कारणम्';

  @override
  String get labelSignatureLocation => 'स्थानम्';

  @override
  String get titleSignatureCertificate => 'प्रमाणपत्रम्';

  @override
  String get labelSignatureIssuedTo => 'दत्तम्';

  @override
  String get labelSignatureIssuedBy => 'दातारः';

  @override
  String get labelSignatureValidFrom => 'मान्यारम्भः';

  @override
  String get labelSignatureValidUntil => 'मान्यावसानम्';

  @override
  String get descSignatureSelfSignedNote =>
      'इदं प्रमाणपत्रं स्वयमेव प्रमाणयति। अन्यः कोऽपि न समर्थयति, अतः हस्ताक्षरकर्तारं जानाति चेदेव विश्वसितु।';

  @override
  String get actionSignatureTrust => 'इदं प्रमाणपत्रं विश्वस्यताम्';

  @override
  String get titleSignatureTrust =>
      'अस्मिन् हस्ताक्षरकर्तरि विश्वस्यताम् किम्?';

  @override
  String get descSignatureTrustExplain =>
      'इतः परम् अनेन प्रमाणपत्राङ्कितं यत्किमपि PDF विश्वसनीयत्वेन दृश्यते। हस्ताक्षरकर्तारं जानाति चेदेवैतत् करोतु।';

  @override
  String get labelSignatureTrustConfirm => 'विश्वस्यताम्';

  @override
  String get descSignatureTrustedToast => 'प्रमाणपत्रं विश्वस्तम्।';

  @override
  String get titleTrustStore => 'विश्वस्तप्रमाणपत्राणि';

  @override
  String get emptyTrustStore => 'भवता अद्यापि किमपि प्रमाणपत्रं न विश्वस्तम्।';

  @override
  String get descTrustStoreEmptyDetail =>
      'यदा भवान् कस्यचित् प्रमाणपत्रं विश्वसिति, तदिहागच्छति। यदा कदापि तत् निष्कासयितुं शक्यते।';

  @override
  String get actionTrustStoreAdd => 'प्रमाणपत्रं योज्यताम्';

  @override
  String get actionTrustStoreRemove => 'निष्कास्यताम्';

  @override
  String get titleTrustStoreRemove =>
      'अस्मिन् प्रमाणपत्राविश्वासः क्रियताम् किम्?';

  @override
  String get descTrustStoreRemoveExplain =>
      'अनेनाङ्कितानि PDF-पत्राणि विश्वस्तत्वेन न दर्शयिष्यन्ते।';

  @override
  String get descTrustStoreInvalidFile =>
      'सा सञ्चिका अस्यानुप्रयोगस्य पठनाहं प्रमाणपत्रं न भवति।';

  @override
  String get descTrustStoreExpiredWarning => 'अस्य प्रमाणपत्रस्य कालोऽतीतः।';

  @override
  String get actionTrimMargins => 'अनावृतसीमान्तः कर्त्यताम्';

  @override
  String get titleTrimMargins => 'दक्षसीमान्तकर्तनम्';

  @override
  String get descTrimMargins => 'दूरवाणीपठनाय रिक्तसीमान्तान् कर्तयति।';

  @override
  String get descTrimMarginsWorking => 'रिक्तसीमान्ताः कृत्यन्ते…';

  @override
  String get titleTrimMarginsDone => 'सीमान्ताः कर्तिताः';

  @override
  String get descTrimMarginsDoneNote =>
      'दूरवाणीपटलेभ्योऽनुकूलाः कृत्वा रिक्तसीमान्ताः कर्तिताः।';

  @override
  String get labelTrimPadding => 'सीमान्तपूरणम्';

  @override
  String get labelTrimPaddingTight => 'सङ्कीर्णम् (4 pt)';

  @override
  String get labelTrimPaddingStandard => 'प्रमाणभूतम् (12 pt)';

  @override
  String get labelTrimPaddingComfortable => 'सुखप्रदम् (24 pt)';

  @override
  String get labelTrimSymmetric => 'सममितसीमान्ताः';

  @override
  String get helpTrimSymmetric => 'वामदक्षिणसीमान्तयोः साम्यं रक्षति।';

  @override
  String get actionBooklet => 'पुस्तिका रच्यताम्';

  @override
  String get titleBooklet => 'द्विपुटपुस्तिका (2-Up)';

  @override
  String get descBooklet => 'उभयपक्षमुद्रणाय द्विपुटपुस्तिकाविन्यासं जनयति।';

  @override
  String get descBookletWorking => 'पुस्तिकाविन्यासो निर्मीयते…';

  @override
  String get titleBookletDone => 'पुस्तिका रचिता';

  @override
  String get descBookletDoneNote =>
      'उभयपक्षे मुद्रयित्वा (लघुसीम्नि परावृत्य) मध्यमेव पुटीक्रियताम्।';

  @override
  String get titleBookletSummary => 'पुस्तिकाविन्यासविवरणम्';

  @override
  String descBookletSummaryPages(int source, int padded) {
    return '$source मूलपृष्ठानि -> $padded पुस्तिकापृष्ठानि';
  }

  @override
  String descBookletSummarySheets(int sheets, int faces) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets भौततिर्यक्पत्राणि',
      one: '१ भौततिर्यक्पत्रम्',
    );
    return '$_temp0 ($faces मुद्रणपक्षेषु)';
  }

  @override
  String descBookletSummaryBlanks(int blanks) {
    String _temp0 = intl.Intl.pluralLogic(
      blanks,
      locale: localeName,
      other: '$blanks रिक्तपूरकपृष्ठान्यन्ते योजितानि',
      one: '१ रिक्तपूरकपृष्ठमन्ते योजितम्',
    );
    return '$_temp0';
  }

  @override
  String get labelBookletBinding => 'बन्धनदिक्';

  @override
  String get labelBookletBindingLtr => 'वामाद् दक्षिणम् (LTR)';

  @override
  String get labelBookletBindingRtl => 'दक्षिणाद् वामम् (RTL)';

  @override
  String get labelBookletPaperSize => 'पत्रपरिमाणम्';

  @override
  String get labelBookletPaperAuto => 'मूलानुकूलम्';

  @override
  String get labelBookletPaperA4 => 'A4 तिर्यक्';

  @override
  String get labelBookletPaperLetter => 'US Letter';

  @override
  String get labelBookletFoldGuide => 'पुटरेखादर्शकम्';

  @override
  String get helpBookletFoldGuide =>
      'यत्र पुस्तिका पुटीकरणीया तद्दर्शयितुं सूक्ष्मं बिन्दुरेखां लिखति।';

  @override
  String get titleAppearance => 'स्वरूपम्';

  @override
  String get descAppearanceSubtitle => 'वर्णपरिपार्टी, लिपिमुद्रा, वर्णाश्च';

  @override
  String get titleThemeMode => 'वर्णपरिपार्टीप्रकारः';

  @override
  String get descThemeModeSubtitle =>
      'प्रकाशमय-अन्धकारमय-तन्त्रमूल-कपिशप्रकारेषु वृणुताम्';

  @override
  String get descThemeModeCardSubtitle =>
      'प्रकाशमयं, अन्धकारमयं, तन्त्रमूलं वा वृणुताम्';

  @override
  String get descThemeMode =>
      'तन्त्रमूलप्रकारः यन्त्रस्य अन्धकारविन्यासमन्वेति। कपिशप्रकारस्तु नेत्रसुखाय सुखदपठनतलं ददाति।';

  @override
  String get titleTypography => 'लिपिमुद्रा पाठ्यांशपरिमाणं च';

  @override
  String get descTypographySubtitle =>
      'अनुप्रयोगस्य लिपिमुद्रा पाठ्यांशपरिमाणं च';

  @override
  String get descTypography =>
      'पटलेषु सुगमपठनाय लिपिमुद्रां पाठ्यांशपरिमाणं चानुकूलयतु।';

  @override
  String get labelTypographyFont => 'लिपिमुद्रा';

  @override
  String get labelTypographyTextSize => 'पाठ्यांशपरिमाणम्';

  @override
  String get labelFontSystemDefault => 'तन्त्रमूलम्';

  @override
  String get labelFontManjari => 'Manjari';

  @override
  String get labelFontAnekMalayalam => 'Anek Malayalam';

  @override
  String get labelFontNotoSansMalayalam => 'Noto Sans Malayalam';

  @override
  String get labelTextSizeSmall => 'लघु';

  @override
  String get labelTextSizeDefault => 'प्रमाणभूतम्';

  @override
  String get labelTextSizeLarge => 'बृहत्';

  @override
  String get labelTextSizeLarger => 'बृहत्तरम्';

  @override
  String get descTypographySampleLatin => 'The quick brown fox 0123';

  @override
  String get labelTypographySampleMalayalam => 'മലയാളം സുന്ദരമാണ്';

  @override
  String get titleAccentColor => 'दीप्तवर्णः (Accent)';

  @override
  String get descAccentColorSubtitle =>
      'पूर्वनिर्दिष्टाः, वर्णचक्रम्, प्रत्यक्षमवलोकनम्';

  @override
  String get descAccentAppliesToLight =>
      'अयं वर्णः प्रकाशमयपरिपार्ट्यां प्रयुज्यते।';

  @override
  String get descAccentAppliesToDark =>
      'अयं वर्णः अन्धकारमयपरिपार्ट्यां प्रयुज्यते।';

  @override
  String get labelLivePreview => 'प्रत्यक्षमवलोकनम्';

  @override
  String get labelSampleText => 'मातृकापाठ्यांशः';

  @override
  String get labelPresets => 'पूर्वनिर्दिष्टानि';

  @override
  String get labelCustomColorWheel => 'इच्छानुगुणवर्णचक्रम्';

  @override
  String get labelResetToDefault => 'मूलरूपं प्रत्यवस्थाप्यताम्';

  @override
  String get descResetLightToDefault => 'प्रकाशमयपरिपार्टी प्रत्यवस्थाप्यताम्';

  @override
  String get descResetDarkToDefault => 'अन्धकारमयपरिपार्टी प्रत्यवस्थाप्यताम्';

  @override
  String get descContrastNotice => 'सुगमपठनाय पाठ्यांशवैषम्यं स्वयमेव साध्यते।';

  @override
  String get titlePermissions => 'अनुमतयः';

  @override
  String get descPermissionsSubtitle =>
      'सङ्ग्रहः, काल्पनिकमुद्रणसेवा, गोपनीयतासामर्थ्यानि च';

  @override
  String get labelPermissionsOpenSettings => 'तन्त्रविन्यासः उद्घात्यताम्';

  @override
  String get labelPermissionsExplicitHeader => 'सामर्थ्यानि';

  @override
  String get descPermissionsExplicitSubtitle =>
      'सुरक्षितलेख्यप्रवेशाय रचिता विशेषास्तन्त्रभूमिकाश्च।';

  @override
  String get descPermissionsImplicitHeader => 'गोपनीयता तन्त्रोद्घोषाश्च';

  @override
  String get descPermissionsImplicitSubtitle =>
      'घोषणापत्रे उद्घोषितानि; सर्वं कार्यम् अस्मिन्नेव दूरभाषे भवति।';

  @override
  String get titlePermScopedStorage => 'परिसीमितसङ्ग्रहः (SAF)';

  @override
  String get descPermScopedStorageReason =>
      'Android-तन्त्रस्य सञ्चिकाचायकेनोद्घाटित-PDF-पत्राणि केवलं पठति रक्षति च।';

  @override
  String get titlePermPrintService => 'PDF मुद्रणसेवा';

  @override
  String get descPermPrintServiceReason =>
      'अन्यानुप्रयोगेभ्यो मुद्रणकार्यं प्राप्य PDF रूपेण रक्षति।';

  @override
  String get titlePermOffline => 'गोपनीयम्, अन्तर्जालरहितम्';

  @override
  String get descPermOfflineReason =>
      'अन्तर्जालोपयोगः नास्ति। यन्त्रसमन्वयेन भवतः अपरं दूरभाषं प्रति प्रेषणे एव भवतः पत्राणि अस्मात् दूरभाषात् बहिः गच्छन्ति।';

  @override
  String get titlePermTts => 'पाठ्यांशोच्चारणयन्त्रम् (TTS)';

  @override
  String get descPermTtsReason =>
      'आङ्ग्ल-मलयाल-भाषाभ्यां लेख्यपठनाय संस्थापितवाग्यन्त्राणि पृच्छति।';

  @override
  String get titlePermProcessText => 'पाठ्यांशप्रक्रियाकार्यम्';

  @override
  String get descPermProcessTextReason =>
      'अन्यानुप्रयोगेषु पाठ्यांशचयने शीघ्रावेषणं पाठ्यक्रियां च समर्थयति।';

  @override
  String get labelStatusActive => 'सक्रियम्';

  @override
  String get labelStatusSystem => 'तन्त्रमूलम्';

  @override
  String get labelStatusOffline => 'ओफ्‌लाइन';

  @override
  String get descTrustStoreSubtitle =>
      'अङ्कीयहस्ताक्षरमूलप्रमाणपत्राणां प्रबन्धनम्';

  @override
  String get descAboutSubtitle =>
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
      'Android-तन्त्रे काल्पनिकमुद्रणसेवाः तन्त्रस्तरे नियम्यन्ते। ग्रन्थ-अनुप्रयोगं तन्त्रमुद्रकरूपेण प्रवर्तयितुम्:';

  @override
  String get helpPdfPrinterStep1 =>
      'भवतः Android-यन्त्रस्य विन्यासः (Settings) उद्घात्यताम्।';

  @override
  String get helpPdfPrinterStep2 =>
      'Connected devices → Connection preferences → Printing प्रति गम्यताम्।';

  @override
  String get helpPdfPrinterStep3 =>
      'Print services इत्यस्य चाधः ग्रन्थः (Folio) अन्विष्यताम्।';

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
      'मानक-Android-मुद्रणं कदाचित् जटिललिपीः (मलयाल-हिन्दी-संस्कृतादीः) विकरोति, येन खण्डिताक्षराणि लुप्ताक्षराणि वा भवन्ति। ग्रन्थ-अनुप्रयोगः लिपिगठनं मुद्रासंयोजनं च विधाय शुद्धं PDF जनयति।';

  @override
  String get helpUnicodePrintingStep1 =>
      'पूर्वं न कृतं चेत् Android-विन्यासे काल्पनिकमुद्रकः प्रवर्त्यताम्।';

  @override
  String get helpUnicodePrintingStep2 =>
      'यस्मिन् कस्मिन्नप्यनुप्रयोगे (Chrome, WhatsApp, Office) मुद्रणं (Print) वृणुताम्।';

  @override
  String get helpUnicodePrintingStep3 =>
      'मानक-\'Save as PDF\' स्थाने \'ग्रन्थः (Folio)\' मुद्रकरूपेण वृणुताम्।';

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
      'स्वपठनरीत्या सह सङ्गमनाय वाग्गतिं, स्वरतारतां, वाक्यसमाप्तिविरामं, स्वयञ्चलनं चानुकूलयितुं शक्यते।';

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
      'ग्रन्थ-अनुप्रयोगः प्रतिलिपिकरणरीत्या (Copy-on-write) पृष्ठकर्म करोति। मूलसञ्चिका कदापि न विक्रियते।';

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
      'ग्रन्थ-अनुप्रयोगः जालानुरोधं विनैव गूढलेखविधिना (SHA-256, X.509) हस्ताक्षराणि पूर्णतया ऑफ्‌लाइन परीक्षते।';

  @override
  String get helpSignaturesStep1 =>
      'हस्ताक्षरित-PDF-पत्रेोद्घाटने उपरितनपट्टिकायां हस्ताक्षरचिह्नं स्पृष्ट्वा विवरणानि पश्यतु।';

  @override
  String get helpSignaturesStep2 =>
      'हस्ताक्षरकरणानन्तरं लेख्यं परिवर्तितं न वेत्यनुप्रयोगः परीक्षते।';

  @override
  String get helpSignaturesStep3 =>
      'प्रमाणपत्रमविश्वस्तं चेत् मूलप्रमाणपत्रं विश्वस्तसङ्ग्रहस्य अन्तः योजयितुं शक्यते।';

  @override
  String get helpSignaturesTip =>
      'सुरक्षासूचना: सर्वा परीक्षा यन्त्रे एव Kotlin-Bouncy Castle द्वारा क्रियते, बाह्यसर्वरे किमपि न प्रेष्यते।';

  @override
  String get helpOpenTrustStore => 'विश्वस्तसङ्ग्रहः उद्घात्यताम्';

  @override
  String get helpPrivacyStorageTitle => 'गोपनीयता परिसीमितसङ्ग्रहश्च';

  @override
  String get helpPrivacyStorageSubtitle =>
      'अन्तर्जालसेवकराहित्यं परिसीमितसङ्ग्रहसुरक्षा च';

  @override
  String get helpPrivacyStorageTopicHeader => 'अन्तर्जालरहितगोपनीयताप्रतिज्ञा';

  @override
  String get helpPrivacyStorageIntro =>
      'भवतां गोपनीयता सर्वोपरि वर्तते। ग्रन्थ-अनुप्रयोगः कदापि अन्तर्जालेन न संयुज्यते। स्थानीय-Wi-Fi-जाले भवतः स्वदूरभाषयोः मध्ये साक्षात् यन्त्रसमन्वयः एव तस्य एकमात्रं जालोपयोगः।';

  @override
  String get helpPrivacyStorageStep1 =>
      'अन्तर्जालं नास्ति: ग्रन्थ-अनुप्रयोगः कदापि अन्तर्जालसेवकेन सह सम्पर्कं न करोति, विश्लेषणदत्तांशं च न सङ्गृह्णाति। INTERNET अनुमतिः केवलं स्थानीय-Wi-Fi-जाले यन्त्रसमन्वयाय, तस्मिन् पटले उद्घाटिते एव उपयुज्यते।';

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
  String get titleLanguage => 'भाषा';

  @override
  String get descLanguageSubtitle => 'अनुप्रयोगभाषा वृणुताम्';

  @override
  String get labelLanguageSystem => 'तन्त्रमूलम्';

  @override
  String get labelLanguageEnglish => 'English';

  @override
  String get labelLanguageMalayalam => 'മലയാളം (Malayalam)';

  @override
  String get labelLanguageSanskrit => 'संस्कृतम् (Sanskrit)';

  @override
  String get titleLanguageSelect => 'अनुप्रयोगभाषा';

  @override
  String get descLanguageSelectSubtitle =>
      'परिवर्तनं तत्क्षणमेव समग्रानुप्रयोगे फलति।';

  @override
  String get titleReaderSettings => 'पाठकः दर्शकश्च';

  @override
  String get descReaderSettingsSubtitle =>
      'पठनस्थानं, विन्यासः, विस्तारः, प्रदर्शनं च';

  @override
  String get titleSaveLastPosition => 'पठनस्थानं स्मर्यताम्';

  @override
  String get descSaveLastPositionSubtitle =>
      'उद्घाटने अन्तिमवारं दृष्टं पृष्ठं विस्तारं च स्वयमेवानुसरति';

  @override
  String get titleDefaultPageLayout => 'मूलभूतपृष्ठविन्यासः';

  @override
  String get descDefaultPageLayoutSubtitle =>
      'लेख्योद्घाटने पृष्ठप्रदर्शनावस्था वृणुताम्';

  @override
  String get labelLayoutContinuous => 'निरन्तरप्रवाहः';

  @override
  String get labelLayoutSinglePage => 'एकपृष्ठम्';

  @override
  String get titleDoubleTapZoom => 'द्विस्पर्शविस्तारः';

  @override
  String get descDoubleTapZoomSubtitle =>
      'PDF-पृष्ठे द्विस्पर्शेन कर्तव्यं कर्म';

  @override
  String get labelZoomFitWidth => 'विस्तारानुकूलम्';

  @override
  String get labelZoom200 => '२००% विस्तारः';

  @override
  String get titleShowPageIndicator => 'पृष्ठसङ्ख्यासूचकम्';

  @override
  String get descShowPageIndicatorSubtitle =>
      'पठनसमये पटलोपरि पृष्ठसङ्ख्यागुटिकां दर्शयतु';

  @override
  String get titleInvertColors => 'PDF वर्णा विपरीताः क्रियन्ताम्';

  @override
  String get descInvertColorsSubtitle =>
      'रात्रौ सुखपठनाय लेख्यवर्णा विपरीताः क्रियन्ते';

  @override
  String get titleTtsSettings => 'उच्चैःपठनम् (TTS)';

  @override
  String get descTtsSettingsSubtitle =>
      'वाणी, वाग्गतिः, स्वरतारता, वाचनविकल्पाश्च';

  @override
  String get titleTtsSpeechRate => 'वाग्गतिः';

  @override
  String descTtsSpeechRateSubtitle(String rate) {
    return '${rate}x गतिः';
  }

  @override
  String get titleTtsPitch => 'स्वरतारता';

  @override
  String descTtsPitchSubtitle(String pitch) {
    return '${pitch}x तारता';
  }

  @override
  String get titleTtsAutoScroll => 'वाक्प्रवाहेण सह स्वयञ्चलनम्';

  @override
  String get descTtsAutoScrollSubtitle => 'वाक्यपठनेन सह लेख्यं स्वयमेव चालयतु';

  @override
  String get titlePrinterSettings => 'काल्पनिक-PDF-मुद्रकः';

  @override
  String get descPrinterSettingsSubtitle =>
      'मुद्रणसंयोजनं, पत्रपरिमाणं, क्षणिकसञ्चयश्च';

  @override
  String get titlePrinterEnable => 'PDF मुद्रकसंयोजनं प्रवर्त्यताम्';

  @override
  String get descPrinterEnableSubtitle =>
      'अन्यानुप्रयोगेभ्यो मुद्रणकार्याणि स्वीकृत्य PDF रूपेण रक्षतु';

  @override
  String get titleDefaultPaperSize => 'मूलभूतपत्रपरिमाणम्';

  @override
  String get descDefaultPaperSizeSubtitle =>
      'निर्मितानां PDF-पत्राणां मूलभूतायतनम्';

  @override
  String get titleDefaultColorMode => 'मूलभूतवर्णप्रकारः';

  @override
  String get descDefaultColorModeSubtitle => 'मुद्रितपत्राणां वर्णनिर्गमः';

  @override
  String get labelColorModeColor => 'सवर्णम्';

  @override
  String get labelColorModeGrayscale => 'धूसरचित्रम् (Grayscale)';

  @override
  String get descColorModeMonochrome => 'एकवर्णम् (श्यामश्वेतम्)';

  @override
  String get titleDefaultOrientation => 'मूलभूतदिक्';

  @override
  String get descDefaultOrientationSubtitle => 'मुद्रणकार्याय पृष्ठदिक्';

  @override
  String get labelOrientationAuto => 'स्वयम् (मूलानुकूलम्)';

  @override
  String get labelOrientationPortrait => 'ऋजुदिक् (Portrait)';

  @override
  String get labelOrientationLandscape => 'तिर्यग्दिक् (Landscape)';

  @override
  String get titleClearPrinterCache => 'मुद्रकक्षणिकसञ्चयः शोध्यताम्';

  @override
  String descClearPrinterCacheSubtitle(String size) {
    return 'तात्कालिकानि मुद्रणसञ्चिकानि अपमृज्यताम् ($size)';
  }

  @override
  String get descPrinterCacheCleared => 'मुद्रकक्षणिकसञ्चयः शोधितः।';

  @override
  String get titleStorageSettings => 'सङ्ग्रहः गोपनीयता च';

  @override
  String get descStorageSettingsSubtitle =>
      'सद्यस्तनसञ्चिकेतिहासः संस्मृतिशोधनं च';

  @override
  String get titleRememberRecentFiles => 'सद्यस्तनसञ्चिकाः स्मर्यन्ताम्';

  @override
  String get descRememberRecentFilesSubtitle =>
      'उद्घाटितानि पत्राणि मुख्यपटले सद्यस्तनसूच्यां दर्शयतु';

  @override
  String get titleClearRecentFiles => 'सद्यस्तनसञ्चिकेतिहासः शोध्यताम्';

  @override
  String get descClearRecentFilesSubtitle =>
      'सर्वाण्युद्घाटितपत्रवृत्तानि रक्षितस्थानानि चापमृज्यताम्';

  @override
  String get titleClearRecentFilesConfirm =>
      'सद्यस्तनसञ्चिकाः शोध्यन्ताम् किम्?';

  @override
  String get bodyClearRecentFilesConfirm =>
      'अनेन सद्यस्तनसूची पठनप्रगतिश्च शोधिष्येते। यन्त्रे स्थितानि मूल-PDF-पत्राणि न लुप्यन्ते।';

  @override
  String get actionClearRecentFiles => 'इतिहासः शोध्यताम्';

  @override
  String get descRecentFilesCleared => 'सद्यस्तनसञ्चिकेतिहासः शोधितः।';

  @override
  String get titleClearTempCache => 'अनुप्रयोगक्षणिकसञ्चयः शोध्यताम्';

  @override
  String descClearTempCacheSubtitle(String size) {
    return 'दत्तांशलोपं विना तात्कालिकस्थानं मुच्यताम् ($size)';
  }

  @override
  String get descTempCacheCleared => 'अनुप्रयोगक्षणिकसञ्चयः शोधितः।';

  @override
  String get titleSecuritySettings => 'हस्ताक्षराणि विश्वासश्च';

  @override
  String get descSecuritySettingsSubtitle =>
      'अङ्कीयहस्ताक्षरपरीक्षा इच्छानुगुणप्रमाणपत्राणि च';

  @override
  String get titleAutoVerifySignatures => 'हस्ताक्षराणां स्वयम्परीक्षा';

  @override
  String get descAutoVerifySignaturesSubtitle =>
      'हस्ताक्षरित-PDF-पत्राणामुद्घाटनेऽङ्कीयहस्ताक्षराणि स्वयमेव परीक्षन्ताम्';

  @override
  String get titlePermFileProvider => 'सुरक्षितसञ्चिकाप्रदाता';

  @override
  String get descPermFileProviderReason =>
      'रहस्यसञ्चिकामार्गाणां प्रकाशनेन विना तात्कालिक-PDF-पत्राणि निष्कासितानि पत्राणि च बाह्यानुप्रयोगैः सह विभजते।';

  @override
  String get descPermFileProviderWhatItAchieves =>
      'सङ्ग्रहसुरक्षाभङ्गेन विना बाह्यानुप्रयोगैः सह PDF-पत्राणां सुरक्षितविभजनं मुद्रणं च साधयति।';

  @override
  String get titlePermTtsInstall => 'वाणीदत्तांशावतारकम्';

  @override
  String get descPermTtsInstallReason =>
      'अपेक्षिता भाषावाणी न वर्तते चेत् तन्त्रावतारणपटलमुद्घाटयति।';

  @override
  String get descPermTtsInstallWhatItAchieves =>
      'मार्गभ्रंशं विना मलयाल-आङ्ग्लवाण्याः संस्थापनं सुगमं करोति।';

  @override
  String get titlePermSendShare => 'वितीर्णस्वीकरणम्';

  @override
  String get descPermSendShareReason =>
      'अन्यानुप्रयोगेभ्यो विभक्तानि चित्राणि, सरलपाठ्यांशं, PDF-पत्राणि च प्राप्नोति।';

  @override
  String get descPermSendShareWhatItAchieves =>
      'विभक्तचित्राणां पाठ्यांशस्य च साक्षात् PDF रूपेण रूपान्तरणं यस्मात् कस्मादप्यनुप्रयोगात् PDF उद्घाटनानुमतिं च ददाति।';

  @override
  String get titlePermZeroInternet => 'अन्तर्जालसेवकाः न';

  @override
  String get descPermZeroInternetReason =>
      'ग्रन्थ-अनुप्रयोगः कदापि अन्तर्जालसेवकेन सह सम्पर्कं न करोति। स्थानीय-Wi-Fi-जाले भवतः स्वदूरभाषयोः मध्ये यन्त्रसमन्वयः एव तस्य एकमात्रं जालोपयोगः।';

  @override
  String get descPermZeroInternetWhatItAchieves =>
      'दत्तांशस्रावं, पदचिह्नान्वेषणं, दूरस्थदूरमापनं च विना पूर्णां गोपनीयतां निश्चिनोति।';

  @override
  String get descPermScopedStorageWhatItAchieves =>
      'यन्त्रस्य इतरभागानां गोपनीयतां रक्षता उपयोक्तृचयनित-PDF-पत्राणां पठनं रक्षणं च करोति।';

  @override
  String get descPermPrintServiceWhatItAchieves =>
      'अन्येभ्यः अनुप्रयोगेभ्यः ग्रन्थ-अनुप्रयोगं प्रति मुद्रणं प्रेषयित्वा PDF रूपेण रक्षितुमनुमन्यते।';

  @override
  String get descPermOfflineWhatItAchieves =>
      'भवतः पत्राणि व्यैक्तिकविवरणानि चास्माद् यन्त्रात् कदापि न बहिर्यान्तीति निश्चिनोति।';

  @override
  String get descPermTtsWhatItAchieves =>
      'आङ्ग्ल-मलयाल-भाषाभ्यां लेख्यपठनाय संस्थापितवाग्यन्त्राणि सम्प्रेक्षते।';

  @override
  String get descPermProcessTextWhatItAchieves =>
      'यस्मिन् कस्मिन्नप्यनुप्रयोगे चयनितपाठ्यांशं ग्रन्थ-अनुप्रयोगे साक्षादन्वेष्टुमनुमन्यते।';

  @override
  String get labelPermWhyNeededHeader => 'किमर्थमपेक्षितम्';

  @override
  String get labelPermWhatItAchievesHeader => 'अनेन किं लभ्यते';

  @override
  String get labelPermTypeExplicit => 'प्रत्यक्षसामर्थ्यम्';

  @override
  String get descPermTypeImplicit => 'परोक्षम् / तन्त्रानुरोधः';

  @override
  String get labelPermTypePrivacy => 'गोपनीयतानिश्चयः';

  @override
  String get descPermissionsPrivacyHeader => 'गोपनीयता शून्यानुमतिनिश्चयश्च';

  @override
  String get descPermissionsPrivacySubtitle =>
      'घोषणापत्रात् सङ्कल्पपूर्वकं निष्कासिताः संकटास्पदानुमतयः।';

  @override
  String get titlePermBindPrintService => 'BIND_PRINT_SERVICE';

  @override
  String get descPermBindPrintServiceReason =>
      'केवलं Android-तन्त्रस्य मुद्रणप्रेषकः एव बद्धः स्यात् तथा काल्पनिकमुद्रणसेवां रक्षति।';

  @override
  String get descPermBindPrintServiceWhatItAchieves =>
      'अनधिकृतानुप्रयोगाः मुद्रणसेवाया दुरुप्रयोगं मुद्रणपत्राणां हरणं वा न कुर्युरिति निश्चिनोति।';

  @override
  String get titlePermStoreQueries => 'अनुप्रयोगविपणि-जालानुरोधाः';

  @override
  String get descPermStoreQueriesReason =>
      'market://, https:// च सङ्केतद्वारा Google Play विपण्यां जालगवेषके चान्विष्यति।';

  @override
  String get descPermStoreQueriesWhatItAchieves =>
      'वाग्यन्त्रस्यानुपस्थितौ Google वाग्यन्त्रस्य साक्षात्संस्थापनं सुगमं करोति।';

  @override
  String get titlePermViewPdf => 'मूल-PDF-दर्शकम्';

  @override
  String get descPermViewPdfReason =>
      'PDF सञ्चिकाप्रकाराणामुद्घाटनाय तन्त्रेऽनुप्रयोगं पञ्जीकरोति।';

  @override
  String get descPermViewPdfWhatItAchieves =>
      'सञ्चिकाप्रबन्धकात्, ई-मेल-संलग्नात्, अवतरणस्थानाच्च साक्षात् PDF उद्घाटयितुमनुमन्यते।';

  @override
  String get titlePermPrintManager => 'Android मुद्रणतन्त्रम्';

  @override
  String get descPermPrintManagerReason =>
      'Android-तन्त्रस्य PrintManager इत्यनेन मुद्रणप्रेषकेण च सह सम्भाषते।';

  @override
  String get descPermPrintManagerWhatItAchieves =>
      'यथार्थमुद्रकयन्त्रेषु मुद्रणाय तन्त्रमुद्रणपूर्वावलोकनाय च रूपसज्जित-PDF-पत्राणि प्रेषयति।';

  @override
  String get titlePermNoBroadStorage => 'विस्तृतसङ्ग्रहः नास्ति';

  @override
  String get descPermNoBroadStorageReason =>
      'READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, MANAGE_EXTERNAL_STORAGE वा न याच्यते।';

  @override
  String get descPermNoBroadStorageWhatItAchieves =>
      'यन्त्रे स्थितानि अन्यानि चित्राणि, पत्राणि, वैयक्तिकदत्तांशश्च सर्वथाऽप्रवेश्या भवन्तीति निश्चिनोति।';

  @override
  String get titleReadingVelocity => 'पठनगतिः समयगणनं च';

  @override
  String get descReadingVelocitySubtitle =>
      'भवतः पठनगतिमाधृत्य अवशिष्टपठनसमयं गणयति';

  @override
  String labelReadingSpeed(int wpm) {
    return '$wpm wpm';
  }

  @override
  String descReadingTimeLeftChapter(int minutes) {
    return 'अध्याये $minutes निमेषाः अवशिष्टाः';
  }

  @override
  String labelReadingTimeLeftDoc(int minutes) {
    return '$minutes निमेषाः अवशिष्टाः';
  }

  @override
  String get labelReadingTimeLessMinute => '< १ निमेषः अवशिष्टः';

  @override
  String get descReadingTimeEstimatesToggle => 'पठनसमयगणनम्';

  @override
  String get descReadingTimeEstimatesToggleSubtitle =>
      'पठनपट्टिकायामध्यायस्य लेख्यस्य चावशिष्टपठनसमयं दर्शयतु';

  @override
  String get descViewModeAuto => 'स्वयम् (विस्तृते द्विपृष्ठम्)';

  @override
  String get descViewModeAutoSubtitle =>
      'दूरवाण्यामेकपृष्ठं; फलके पुटपटले च पुस्तकवद् द्विपृष्ठम्';

  @override
  String get titleMalayalamHelper => 'मलयालकुञ्जीपटलसाहाय्यकम्';

  @override
  String get tooltipMalayalamHelper => 'मलयाललेखनसाहाय्यम्';

  @override
  String get labelMalayalamKeypadTabTranslit => 'मङ्ग्लिश';

  @override
  String get labelMalayalamKeypadTabVowels => 'स्वराः';

  @override
  String get labelMalayalamKeypadTabConsonants => 'व्यञ्जनानि';

  @override
  String get labelMalayalamKeypadTabSigns => 'मात्राः चिल्लु च';

  @override
  String get titleTtsSentencePause => 'वाक्यसमाप्तौ विरामः';

  @override
  String descTtsSentencePauseSubtitle(String seconds) {
    return 'वाक्ययोर्मध्ये $seconds क्षणविरामः';
  }

  @override
  String descTtsReadingPage(int page) {
    return '$page पृष्ठं पठ्यते…';
  }

  @override
  String get labelTtsPaused => 'विरामः कृतः';

  @override
  String descTtsReadyToRead(int page) {
    return '$page पृष्ठं पठितुं सज्जम्';
  }

  @override
  String get tooltipTtsReadWholeDocument => 'सकलः लेखः पठ्यताम्';

  @override
  String get tooltipTtsReadThisPage => 'इदं पृष्ठमेव पठ्यताम्';

  @override
  String get descTtsDocumentFinished => 'सकलः लेखः पठितः।';

  @override
  String get actionWatermark => 'इच्छानुगुणजलचिह्नम्';

  @override
  String get descWatermark =>
      'पृष्ठेषु पाठ्यांशस्य चित्रस्य वा जलचिह्नं योजयतु';

  @override
  String get titleWatermarkDialog => 'इच्छानुगुणजलचिह्नम्';

  @override
  String get labelWatermarkText => 'जलचिह्नपाठ्यांशः';

  @override
  String get errorWatermarkEmptyText => 'जलचिह्नपाठ्यांशः प्रविश्यताम्।';

  @override
  String get titleWatermarkDone => 'जलचिह्नाङ्कित-PDF निर्मितम्';

  @override
  String get labelWatermarkOpacity => 'पारदर्शिता';

  @override
  String get labelWatermarkRotation => 'भ्रमणकोणः';

  @override
  String get labelWatermarkFontSize => 'अक्षरपरिमाणम्';

  @override
  String get labelWatermarkColor => 'वर्णः';

  @override
  String get labelWatermarkTiled => 'पृष्ठव्यापिपौनःपुन्यम्';

  @override
  String get descWatermarkTiled => 'समग्रे पृष्ठे जलचिह्नरूपमावर्तयति';

  @override
  String get labelWatermarkPageRange => 'प्रयोक्तव्यपृष्ठानि';

  @override
  String get labelWatermarkAllPages => 'सर्वाणि पृष्ठानि';

  @override
  String get labelWatermarkOddPages => 'विषमपृष्ठानि केवलम्';

  @override
  String get labelWatermarkEvenPages => 'समपृष्ठानि केवलम्';

  @override
  String get actionWatermarkApply => 'जलचिह्नं योज्यताम्';

  @override
  String get titleBatchOperations => 'सङ्घकर्माणि';

  @override
  String get descBatchOperations => 'युगपदनेकानि PDF-पत्राणि संसाधयतु';

  @override
  String get labelBatchOperation => 'कर्म वृणुताम्';

  @override
  String get descBatchOpEncrypt => 'सङ्घगूढलेखनम् / रक्षणम्';

  @override
  String get labelBatchOpMerge => 'सङ्घसंयोजनम्';

  @override
  String get descBatchOpExtractText => 'सङ्घपाठ्यांशनिष्कासनम् (.txt)';

  @override
  String get labelBatchOpTrimMargins => 'सङ्घसीमान्तकर्तनम्';

  @override
  String get labelBatchOpCompress => 'सङ्घसङ्कोचः';

  @override
  String descBatchSelectedFilesCount(int count) {
    return 'चयनितसञ्चिकाः ($count)';
  }

  @override
  String get actionBatchAddFiles => 'सञ्चिकाः योज्यन्ताम्';

  @override
  String get descBatchNoFilesSelected =>
      'न कापि PDF-सञ्चिका चयिता। सञ्चिकाचयनार्थं \'सञ्चिकाः योज्यन्ताम्\' स्पृशतु।';

  @override
  String descBatchProgress(int current, int total, String name) {
    return '$total-मध्ये $current संसाध्यते: $name';
  }

  @override
  String get actionBatchStart => 'सङ्घकर्म प्रारभ्यताम्';

  @override
  String descBatchDoneSummary(int success, int total) {
    return '$total-मध्ये $success पत्राणि सफलं संसाधितानि।';
  }

  @override
  String get descBatchFailedAll => 'सर्वेषां पत्राणां सङ्घकर्म विफलम्।';

  @override
  String get actionNUp => 'N-Up बहुपृष्ठविन्यासः';

  @override
  String get descNUp => 'प्रत्येकपत्रे २, ४, ६, ९ वा पृष्ठानि संयोजयतु';

  @override
  String get titleNUpDialog => 'N-Up बहुपृष्ठविन्यासः';

  @override
  String get labelNUpGrid => 'जालकविन्यासः';

  @override
  String get labelNUpSheetSize => 'पत्रपरिमाणम्';

  @override
  String get labelNUpSheetA4 => 'A4';

  @override
  String get labelNUpSheetLetter => 'US Letter';

  @override
  String get labelNUpOrientation => 'पत्रदिक्';

  @override
  String get labelNUpOrientationAuto => 'स्वयम्';

  @override
  String get labelNUpOrientationPortrait => 'ऋजुदिक्';

  @override
  String get labelNUpOrientationLandscape => 'तिर्यग्दिक्';

  @override
  String get labelNUpBorders => 'पृष्ठसीमाः लिख्यन्ताम्';

  @override
  String get descNUpBorders =>
      'प्रत्येकपृष्ठस्थानस्य परितः सूक्ष्मां सीमारेखां लिखति';

  @override
  String get labelNUpMargin => 'सीमान्तपूरणम्';

  @override
  String get titleNUpDone => 'N-Up बहुपृष्ठ-PDF निर्मितम्';

  @override
  String get actionPrintNUp => 'N-Up बहुपृष्ठजालकं मुद्र्यताम्';

  @override
  String get descPrintNUp =>
      'एकस्मिन् पत्रे बहुपृष्ठानि मुद्रयतु (२-मध्ये-१, ४-मध्ये-१ इत्यादयः)';

  @override
  String get titleCleanWebContent => 'स्वच्छजालविषयः (पाठकप्रकारः)';

  @override
  String get descCleanWebContentSubtitle =>
      'रक्षणात् पूर्वं शीर्षकाणि, पादाः, पार्श्वपट्टिकाः, विज्ञापनानि चापसारयति';

  @override
  String descPagesDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पृष्ठानि विलोपितानि',
      one: '१ पृष्ठं विलोपितम्',
    );
    return '$_temp0';
  }

  @override
  String descOrganizeSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पृष्ठानि चयितानि',
      one: '१ पृष्ठं चयनितम्',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'सर्वं चिनोतु';

  @override
  String get actionDeselectAll => 'चयनं मुञ्चतु';

  @override
  String get actionInvertSelection => 'चयनं विपरिवर्तयतु';

  @override
  String get actionTrustStoreExport => 'प्रमाणपत्रं निर्यात्यताम्';

  @override
  String get actionTrustStoreExportAll => 'सर्वप्रमाणपत्राणि निर्यात्यन्ताम्';

  @override
  String descTrustStoreExportSuccess(String name) {
    return 'प्रमाणपत्रं $name मध्ये निर्यातितम्';
  }

  @override
  String get actionSignatureTrustSigner => 'हस्ताक्षरकर्तरि विश्वस्यताम्';

  @override
  String get labelSignatureUnnamed => 'अङ्कीयहस्ताक्षरम्';

  @override
  String get labelSignatureTime => 'हस्ताक्षरकालः';

  @override
  String get labelSignatureTimeClaimOnly => 'अपुष्टोद्घोषः';

  @override
  String get labelSignatureIntegrity => 'लेख्यशुद्धता';

  @override
  String get descSignatureIntegrityValid =>
      'हस्ताक्षरकरणानन्तरं लेख्यं न परिवर्तितम्';

  @override
  String get descSignatureIntegrityInvalid =>
      'हस्ताक्षरकरणानन्तरं लेख्यं परिवर्तितम्';

  @override
  String get descSignatureIntegrityUnknown => 'लेख्यशुद्धता ज्ञातुं न शक्ता';

  @override
  String get labelSignatureCoverage => 'व्याप्तिः';

  @override
  String get descSignatureCoversWholeFile =>
      'हस्ताक्षरं समग्रलेख्यं व्याप्नोति';

  @override
  String get descSignatureCoversPartialFile =>
      'हस्ताक्षरं लेख्यस्यैकभागमात्रं व्याप्नोति';

  @override
  String get descSignatureCertificateHeader =>
      'हस्ताक्षरकर्तृप्रमाणपत्रविवरणम्';

  @override
  String get titleFeatures => 'विशेषाः';

  @override
  String get descFeaturesSubtitle =>
      'ग्रन्थ-अनुप्रयोगस्य सर्वविशेषाणां परिज्ञानम्';

  @override
  String get titleFeaturesHeader => 'ग्रन्थ-अनुप्रयोगस्य विशेषाः';

  @override
  String get descFeaturesHeaderSubtitle =>
      'भवदर्थं निर्मितानां बुद्धिमत्साधनानां, गोपनीयताकवचानां, PDF-विशेषाणां चावलोकनं कुर्वन्तु।';

  @override
  String get descFeaturesCategoryViewing => 'PDF दर्शनसञ्चालनतन्त्रम्';

  @override
  String get descFeaturesCategoryViewingSubtitle =>
      'शीघ्रप्रस्तुतिः, निरन्तरप्रवाहः, पुस्तकदर्शनं, दक्षसञ्चालनं च';

  @override
  String get descFeaturesCategorySearch =>
      'अन्वेषणम्, भारतीयध्वनिशास्त्रं, वाक् च';

  @override
  String get descFeaturesCategorySearchSubtitle =>
      'सन्धियुक्तान्येवेषणम्, मलयाललिपिलेखनं, पाठ्यांशोच्चारणं च';

  @override
  String get descFeaturesCategoryAnnotations => 'अङ्कनपटलः चिह्नानि च';

  @override
  String get descFeaturesCategoryAnnotationsSubtitle =>
      'अविनाश्यङ्कनानि, तूलिकालेखनं, टिप्पण्यः, PDF-निर्यातः';

  @override
  String get descFeaturesCategoryPageOps => 'पृष्ठकर्माणि पुनस्सङ्घटनं च';

  @override
  String get descFeaturesCategoryPageOpsSubtitle =>
      'दृश्यपृष्ठव्यवस्थापकः, द्विपुटपुस्तिका, जलचिह्नानि, सङ्घसाधनानि च';

  @override
  String get descFeaturesCategoryExtraction => 'दत्तांशनिष्कासनं साधनानि च';

  @override
  String get descFeaturesCategoryExtractionSubtitle =>
      'सरलपाठ्यांशः, अन्तर्निहितचित्राणि, प्रपत्रक्षेत्राणि, विवरणानि च निष्कास्यन्ताम्';

  @override
  String get descFeaturesCategoryPrinter => 'काल्पनिकमुद्रकः विभजनकेन्द्रं च';

  @override
  String get descFeaturesCategoryPrinterSubtitle =>
      'तन्त्रव्यापी काल्पनिकमुद्रकः, जालशोधकः, चित्रपाठ्यरूपान्तरणं च';

  @override
  String get descFeaturesCategorySignatures =>
      'अङ्कीयहस्ताक्षराणि विश्वस्तसङ्ग्रहश्च';

  @override
  String get descFeaturesCategorySignaturesSubtitle =>
      'गूढलेखपरीक्षा, दर्शनमुद्राचिह्नानि, इच्छानुगुणविश्वस्तसङ्ग्रहश्च';

  @override
  String get descFeaturesCategoryThemes => 'वर्णपरिपार्ट्यः विन्यासश्च';

  @override
  String get descFeaturesCategoryThemesSubtitle =>
      'OLED अन्धकारपरिपार्टी, इच्छानुगुणलिपिमुद्रा, HSV वर्णचक्रं, विन्यासकेन्द्राणि च';

  @override
  String get labelFeaturesCategoryGuides => 'अन्तर्निर्मितमार्गदर्शिकाः';

  @override
  String get descFeaturesCategoryGuidesSubtitle =>
      'विस्तृताः ऑफ्‌लाइन-पाठ्यक्रमाः दोषदूरीकरणसूत्राणि च';

  @override
  String get helpHeaderTitle => 'साहाय्यकेन्द्रं ज्ञानकोशश्च';

  @override
  String get helpHeaderSubtitle =>
      'ग्रन्थ-अनुप्रयोगस्य सर्वविशेषाणां विस्तृता मार्गदर्शिकाः समाधानानि च पश्यन्तु।';

  @override
  String get helpSectionPrinting => 'मुद्रणं रूपान्तरणं च';

  @override
  String get helpSectionReading => 'पठनं वाक् च';

  @override
  String get helpSectionPageOps => 'लेख्यकर्माणि';

  @override
  String get helpSectionSecurity => 'सुरक्षा गोपनीयता च';

  @override
  String get labelAboutVersion => 'संस्करणम्';

  @override
  String get labelAboutBuildDate => 'निर्माणदिनाङ्कः';

  @override
  String get labelImageFormatPngLossless => 'PNG (अक्षयम्)';

  @override
  String get labelImageFormatJpeg => 'JPEG';

  @override
  String labelNUpPagesPerSheet(int count) {
    return 'एकस्मिन् $count';
  }

  @override
  String labelPageJumpRangeHint(int min, int max) {
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
  String get tooltipMenu => 'सूची';

  @override
  String get tooltipShowPassword => 'कूटशब्दः दृश्यताम्';

  @override
  String get tooltipHidePassword => 'कूटशब्दः गोप्यताम्';

  @override
  String get labelColorYellow => 'पीतः';

  @override
  String get labelColorGreen => 'हरितः';

  @override
  String get labelColorBlue => 'नीलः';

  @override
  String get labelColorRed => 'रक्तः';

  @override
  String get labelColorPurple => 'धूम्रः';

  @override
  String get labelColorOrange => 'काषायः';

  @override
  String descAboutVersionBuild(String version, String build) {
    return '$version (निर्मितिसङ्ख्या $build)';
  }

  @override
  String get actionClose => 'पिदधातु';

  @override
  String get actionRemove => 'निष्कासयतु';

  @override
  String get tooltipRotateScreen => 'पटं भ्रामयतु';

  @override
  String get titleScreenOrientation => 'पटदिक्';

  @override
  String get errorScreenFallback =>
      'अस्मिन् पटले दोषः सञ्जातः। प्रत्यागत्य पुनः प्रयत्यताम्।';

  @override
  String get errorInvalidCertificate =>
      'इयं सञ्चिका अनेन अनुप्रयोगेन पठनीयं प्रमाणपत्रं नास्ति।';

  @override
  String get errorCertificateExport => 'प्रमाणपत्रं निर्यापयितुं न शक्तम्।';

  @override
  String get errorTrustStoreLoad =>
      'विश्वस्तानि प्रमाणपत्राणि आनेतुं न शक्तानि।';

  @override
  String get errorImportBuild =>
      'PDF निर्माणकाले दोषः सञ्जातः। पुनः प्रयत्यताम्।';

  @override
  String get helpFeatureRenderingTitle => 'द्रुतं पृष्ठप्रदर्शनम्';

  @override
  String get helpFeatureRenderingBody =>
      'pdfium-यन्त्रेण PDF-पृष्ठानि शीघ्रं स्पष्टं च प्रदर्श्यन्ते; जालसंयोगस्य आवश्यकता नास्ति।';

  @override
  String get helpFeatureRenderingTag1 => 'pdfium-यन्त्रम्';

  @override
  String get helpFeatureRenderingTag2 => 'स्पष्टं परिमाणनम्';

  @override
  String get helpFeatureRenderingTag3 => 'असंयुक्ते अपि द्रुतम्';

  @override
  String get helpFeatureViewModesTitle => 'विविधाः दर्शनरीतयः';

  @override
  String get helpFeatureViewModesBody =>
      'एकपृष्ठम्, अविरतम् ऊर्ध्वाधरसञ्चलनम्, द्विपृष्ठपुस्तकदर्शनं च इति रीतिषु परिवर्तनं शक्यम्; विस्तारानुरूपं पृष्ठानुरूपं च समायोजनम् अपि लभ्यते।';

  @override
  String get helpFeatureViewModesTag1 => 'एकपृष्ठम्';

  @override
  String get helpFeatureViewModesTag2 => 'अविरतसञ्चलनम्';

  @override
  String get helpFeatureViewModesTag3 => 'पुस्तकदर्शनम्';

  @override
  String get helpFeatureViewModesTag4 => 'समायोजनरीतयः';

  @override
  String get helpFeatureFoldableTitle => 'सङ्कोच्य-द्विपटलसमर्थनम्';

  @override
  String get helpFeatureFoldableBody =>
      'सङ्कोच्ययन्त्रेषु फलकयन्त्रेषु च सन्धिरिक्तस्थानम् अनुसृत्य द्विपृष्ठविन्यासः स्वयं प्रदर्श्यते।';

  @override
  String get helpFeatureFoldableTag1 => 'सङ्कोचज्ञानम्';

  @override
  String get helpFeatureFoldableTag2 => 'सन्धिरिक्तम्';

  @override
  String get helpFeatureFoldableTag3 => 'फलकयन्त्रानुकूलम्';

  @override
  String get helpFeatureVelocityTitle => 'पठनवेगः समयानुमानं च';

  @override
  String get helpFeatureVelocityBody =>
      'पठनवेगः तत्क्षणं मीयते, तेन अध्यायानां सम्पूर्णलेखस्य च अवशिष्टः पठनसमयः गण्यते।';

  @override
  String get helpFeatureVelocityTag1 => 'शब्दगतिमापनम्';

  @override
  String get helpFeatureVelocityTag2 => 'अध्यायानुमानम्';

  @override
  String get helpFeatureVelocityTag3 => 'कुलसमयः';

  @override
  String get helpFeatureThumbnailsTitle => 'लघुचित्रजालं साक्षाद्गमनं च';

  @override
  String get helpFeatureThumbnailsBody =>
      'लेखस्य सर्वाणि पृष्ठानि लघुचित्रजाले शीघ्रं द्रष्टुं शक्यन्ते, अथवा इष्टं पृष्ठाङ्कं साक्षात् गन्तुं शक्यते।';

  @override
  String get helpFeatureThumbnailsTag1 => 'लघुचित्रजालम्';

  @override
  String get helpFeatureThumbnailsTag2 => 'पृष्ठसञ्चालकः';

  @override
  String get helpFeatureThumbnailsTag3 => 'शीघ्रगमनम्';

  @override
  String get helpFeatureOutlineTitle => 'विषयसूची पृष्ठचिह्नानि च';

  @override
  String get helpFeatureOutlineBody =>
      'लेखस्य विषयसूचीक्रमः द्रष्टुं शक्यते, एकस्पर्शेन विभागं गन्तुं पृष्ठानि चिह्नितुं च शक्यते।';

  @override
  String get helpFeatureOutlineTag1 => 'विषयसूचीक्रमः';

  @override
  String get helpFeatureOutlineTag2 => 'एकस्पर्शगमनम्';

  @override
  String get helpFeatureOutlineTag3 => 'पृष्ठचिह्नानि';

  @override
  String get helpFeatureFingerprintTitle => 'विषयाङ्गुलिमुद्रा सद्यःसञ्चिकाः च';

  @override
  String get helpFeatureFingerprintBody =>
      'सञ्चिकायाः नाम स्थानं वा परिवर्तितं चेदपि SHA-256-अङ्गुलिमुद्रया पठनस्थानं, परिमाणवर्धनं, टिप्पण्यः च रक्ष्यन्ते।';

  @override
  String get helpFeatureFingerprintTag1 => 'SHA-256-अङ्गुलिमुद्रा';

  @override
  String get helpFeatureFingerprintTag2 => 'अन्तिमपठनस्थितिः';

  @override
  String get helpFeatureFingerprintTag3 => 'सद्यःसञ्चिकाः';

  @override
  String get helpFeatureSearchTitle => 'पृष्ठे सम्पूर्णपाठान्वेषणम्';

  @override
  String get helpFeatureSearchBody =>
      'मेलनगणनया, दीप्तचिह्नैः, अक्षरसमूहानुसारिसञ्चलनेन च सह शब्दाः तत्क्षणम् अन्विष्यन्ते।';

  @override
  String get helpFeatureSearchTag1 => 'तत्क्षणान्वेषणम्';

  @override
  String get helpFeatureSearchTag2 => 'मेलनगणकः';

  @override
  String get helpFeatureSearchTag3 => 'अक्षरसमूहसंरेखणम्';

  @override
  String get helpFeatureSandhiTitle => 'सन्धिज्ञं भारतीयान्वेषणम्';

  @override
  String get helpFeatureSandhiBody =>
      'मलयाळ-संस्कृत-देवनागरीनियमानुसारं सन्धियुक्तपदानां विच्छेदः संयोजनं च क्रियते।';

  @override
  String get helpFeatureSandhiTag1 => 'सन्धिविच्छेदः';

  @override
  String get helpFeatureSandhiTag2 => 'समाससंयोजनम्';

  @override
  String get helpFeatureSandhiTag3 => 'संस्कृतं मलयाळं च';

  @override
  String get helpFeaturePhoneticTitle => 'भारतीयध्वनिसाम्ययन्त्रम्';

  @override
  String get helpFeaturePhoneticBody =>
      'अनुस्वार-अनुनासिकसंयुक्ताक्षराणि, चिल्लु-विरामरूपाणि, NTA-संयुक्ताक्षराणि, संवृतोकारान्तानि च एकरूपीक्रियन्ते।';

  @override
  String get helpFeaturePhoneticTag1 => 'ध्वनिसाम्यमेलनम्';

  @override
  String get helpFeaturePhoneticTag2 => 'चिल्लु-एकीकरणम्';

  @override
  String get helpFeaturePhoneticTag3 => 'NFC-सामान्यीकरणम्';

  @override
  String get helpFeatureMalayalamInputTitle =>
      'मलयाळलेखनसहायकः आभासीकुञ्जीफलकं च';

  @override
  String get helpFeatureMalayalamInputBody =>
      'मङ्ग्लिश्-लिप्यन्तरणस्य तत्क्षणसूचनाः, स्वर-व्यञ्जन-चिह्नानां कृते त्रिविभागयुक्तम् आभासीकुञ्जीफलकं च।';

  @override
  String get helpFeatureMalayalamInputTag1 => 'मङ्ग्लिश्-सूचनाः';

  @override
  String get helpFeatureMalayalamInputTag2 => 'आभासीकुञ्जीफलकम्';

  @override
  String get helpFeatureMalayalamInputTag3 => 'अतिरिक्तविन्यासः नास्ति';

  @override
  String get helpFeatureTtsTitle => 'असंयुक्तं पाठश्रावणम् (TTS)';

  @override
  String get helpFeatureTtsBody =>
      'PDF-पाठः आङ्ग्ल-मलयाळभाषयोः उच्चैः पठ्यते; वाग्गतिः, स्वरतारता, वाक्यसमाप्तिविरामः च समायोजयितुं शक्यन्ते, माध्यमसूचनाः अपि लभ्यन्ते।';

  @override
  String get helpFeatureTtsTag1 => 'आङ्ग्लं मलयाळं च';

  @override
  String get helpFeatureTtsTag2 => 'गतिस्वरनियन्त्रणम्';

  @override
  String get helpFeatureTtsTag3 => 'पृष्ठभूमौ श्रवणम्';

  @override
  String get helpFeatureMarkupsTitle => 'पाठाङ्कनानि वर्णविकल्पाः च';

  @override
  String get helpFeatureMarkupsBody =>
      'सप्तभिः दीप्तवर्णैः परिवर्तनीयपारदर्शितया च पाठः उद्दीप्यते, अधोरेखया मध्यरेखया वा अङ्क्यते।';

  @override
  String get helpFeatureMarkupsTag1 => 'उद्दीपनम्';

  @override
  String get helpFeatureMarkupsTag2 => 'अधोरेखा';

  @override
  String get helpFeatureMarkupsTag3 => 'मध्यरेखा';

  @override
  String get helpFeatureMarkupsTag4 => '7 वर्णाः';

  @override
  String get helpFeatureInkTitle => 'हस्तरेखनं संलग्नटिप्पण्यः च';

  @override
  String get helpFeatureInkBody =>
      'लेखन्या मसृणानि रेखाचित्राणि लिख्यन्ते; चालनीयाः संलग्नटिप्पण्यः पृष्ठे यत्र कुत्रापि स्थाप्यन्ते।';

  @override
  String get helpFeatureInkTag1 => 'मुक्तहस्तरेखा';

  @override
  String get helpFeatureInkTag2 => 'स्थापितटिप्पण्यः';

  @override
  String get helpFeatureInkTag3 => 'मार्जनसाधनम्';

  @override
  String get helpFeatureFlattenTitle => 'टिप्पणीस्थिरीकरणं निर्यापणं च';

  @override
  String get helpFeatureFlattenBody =>
      'टिप्पण्यः मानक-PDF-टिप्पणीरूपेण लेखस्य नूतनप्रतिलिपौ स्थिरं निर्याप्यन्ते।';

  @override
  String get helpFeatureFlattenTag1 => 'नूतनप्रतिलिपौ लेखनम्';

  @override
  String get helpFeatureFlattenTag2 => 'मानक-PDF-टिप्पण्यः';

  @override
  String get helpFeatureFlattenTag3 => 'मूलं सुरक्षितम्';

  @override
  String get helpFeatureOrganizeTitle => 'दृश्यपृष्ठव्यवस्थापनजालम्';

  @override
  String get helpFeatureOrganizeBody =>
      'आकर्षणपातनेन पृष्ठक्रमः परिवर्त्यते, 90-अंशभ्रमणं पृष्ठलोपः च बहुचयनेन सह क्रियते।';

  @override
  String get helpFeatureOrganizeTag1 => 'आकर्षणपातनम्';

  @override
  String get helpFeatureOrganizeTag2 => 'भ्रमणं लोपः च';

  @override
  String get helpFeatureOrganizeTag3 => 'बहुचयनम्';

  @override
  String get helpFeatureWatermarkTitle => 'स्वेच्छपाठजलचिह्नानि';

  @override
  String get helpFeatureWatermarkBody =>
      'पारदर्शिता-वर्ण-पुनरावृत्तजालविन्यासैः सह तिर्यक् समतलं वा पाठजलचिह्नं योज्यते।';

  @override
  String get helpFeatureWatermarkTag1 => 'स्वेच्छपाठः';

  @override
  String get helpFeatureWatermarkTag2 => 'पारदर्शिता कोणः च';

  @override
  String get helpFeatureWatermarkTag3 => 'जालपुनरावृत्तिः';

  @override
  String get helpFeatureNUpTitle => 'एकपत्रे बहुपृष्ठविन्यासः';

  @override
  String get helpFeatureNUpBody =>
      'A4 Letter वा पत्रे प्रतिपत्रं 2, 4, 6, 9 वा पृष्ठानि स्थाप्यन्ते; सीमाः प्रान्तान्तराणि च परिवर्तनीयानि।';

  @override
  String get helpFeatureNUpTag1 => '2/4/6/9 पृष्ठानि';

  @override
  String get helpFeatureNUpTag2 => 'पृष्ठसीमाः';

  @override
  String get helpFeatureNUpTag3 => 'पत्रदिशा';

  @override
  String get helpFeatureBookletTitle => 'मुद्रणीयपुस्तिकानिर्माणम्';

  @override
  String get helpFeatureBookletBody =>
      'पृष्ठानि मध्यसीवनयोग्यपुस्तिकाक्रमे विन्यस्यन्ते; चतुर्गुणितसङ्ख्यार्थं रिक्तपृष्ठानि स्वयं योज्यन्ते।';

  @override
  String get helpFeatureBookletTag1 => 'मध्यसीवनम्';

  @override
  String get helpFeatureBookletTag2 => 'पुटरेखाः';

  @override
  String get helpFeatureBookletTag3 => 'स्वयंपूरणम्';

  @override
  String get helpFeatureMergeSplitTitle => 'संयोजनं विभाजनं सङ्कोचनं च';

  @override
  String get helpFeatureMergeSplitBody =>
      'बहूनि PDF-पत्राणि एकीक्रियन्ते, पृष्ठानि पृथक्सञ्चिकासु विभज्यन्ते, सञ्चिकापरिमाणं न्यूनीकर्तुं PDF सङ्कोच्यते।';

  @override
  String get helpFeatureMergeSplitTag1 => 'बहुसंयोजनम्';

  @override
  String get helpFeatureMergeSplitTag2 => 'पृष्ठविभाजनम्';

  @override
  String get helpFeatureMergeSplitTag3 => 'कुशलसङ्कोचनम्';

  @override
  String get helpFeatureEncryptionTitle => 'PDF-गूढीकरणं विगूढीकरणं च';

  @override
  String get helpFeatureEncryptionBody =>
      'AES-256-कूटशब्देन लेखाः रक्ष्यन्ते, अथवा गूढसञ्चिकाः उद्घाट्य अगूढप्रतिलिपयः क्रियन्ते।';

  @override
  String get helpFeatureEncryptionTag1 => 'AES-256-रक्षणम्';

  @override
  String get helpFeatureEncryptionTag2 => 'स्वामिकूटशब्दाः';

  @override
  String get helpFeatureEncryptionTag3 => 'तालोद्घाटनम्';

  @override
  String get helpFeatureBatchTitle => 'समूहकार्ययन्त्रम्';

  @override
  String get helpFeatureBatchBody =>
      'जलचिह्नं, सङ्कोचनं, गूढीकरणं, विगूढीकरणं, निष्कासनं च बहुसञ्चिकासु युगपत् क्रियन्ते।';

  @override
  String get helpFeatureBatchTag1 => 'बहुसञ्चिकासमूहः';

  @override
  String get helpFeatureBatchTag2 => 'सोपानप्रगतिः';

  @override
  String get helpFeatureBatchTag3 => 'SAF-द्वारा रक्षणम्';

  @override
  String get helpFeatureExtractionTitle => 'पाठचित्रनिष्कासनम्';

  @override
  String get helpFeatureExtractionBody =>
      'कस्मादपि पृष्ठपरिधेः सरलपाठः निष्कास्यते, अन्तर्निहितानि PNG/JPEG-चित्राणि गुणहानिं विना रक्ष्यन्ते।';

  @override
  String get helpFeatureExtractionTag1 => 'सरलपाठनिर्यापणम्';

  @override
  String get helpFeatureExtractionTag2 => 'अन्तर्निहितचित्राणि';

  @override
  String get helpFeatureExtractionTag3 => 'पृष्ठपरिधयः';

  @override
  String get helpFeatureFormFieldsTitle => 'प्रपत्रक्षेत्रपरीक्षकः';

  @override
  String get helpFeatureFormFieldsBody =>
      'प्रपत्रक्षेत्राणां मूल्यानि, चयनपेटिकाः, विकल्पसमूहाः च अन्विष्य परीक्ष्यन्ते, JSON-रूपेण निर्याप्यन्ते च।';

  @override
  String get helpFeatureFormFieldsTag1 => 'प्रपत्रविश्लेषकः';

  @override
  String get helpFeatureFormFieldsTag2 => 'JSON-निर्यापणम्';

  @override
  String get helpFeatureFormFieldsTag3 => 'क्षेत्रपरीक्षकः';

  @override
  String get helpFeatureRenderImagesTitle => 'पृष्ठानां उच्च-DPI-चित्रीकरणम्';

  @override
  String get helpFeatureRenderImagesBody =>
      'PDF-पृष्ठानि 300 DPI पर्यन्तं परिवर्तनीयस्पष्टतया PNG-JPEG-चित्ररूपेण निर्याप्यन्ते।';

  @override
  String get helpFeatureRenderImagesTag1 => 'उच्च-DPI PNG/JPEG';

  @override
  String get helpFeatureRenderImagesTag2 => '100-300 DPI पर्यन्तम्';

  @override
  String get helpFeatureRenderImagesTag3 => 'समूहचित्रीकरणम्';

  @override
  String get helpFeatureMetadataTitle => 'लेखविवरणपरीक्षकः';

  @override
  String get helpFeatureMetadataBody =>
      'शीर्षकं, लेखकः, निर्मातृतन्त्रं, निर्माणदिनाङ्कः, गूढीकरणस्थितिः इत्यादि लेखस्य विस्तृतं विवरणं द्रष्टुं शक्यते।';

  @override
  String get helpFeatureMetadataTag1 => 'PDF-विवरणम्';

  @override
  String get helpFeatureMetadataTag2 => 'निर्माणदिनाङ्काः';

  @override
  String get helpFeatureMetadataTag3 => 'सुरक्षास्थितिः';

  @override
  String get helpFeatureVirtualPrinterTitle => 'Android-तन्त्रस्य आभासीमुद्रकः';

  @override
  String get helpFeatureVirtualPrinterBody =>
      'कस्मादपि Android-अनुप्रयोगात् मुद्रणकार्याणि स्वीकृत्य सम्पूर्णभारतीयलिपिरूपणेन स्पष्टानि PDF-पत्राणि निर्मीयन्ते।';

  @override
  String get helpFeatureVirtualPrinterTag1 => 'तन्त्रमुद्रणपङ्क्तिः';

  @override
  String get helpFeatureVirtualPrinterTag2 => 'अक्षररूपसन्निवेशः';

  @override
  String get helpFeatureVirtualPrinterTag3 => 'भारतीयलिपिरूपणम्';

  @override
  String get helpFeatureWebCleanerTitle => 'जालविषयशोधकः (पठनरीतिः)';

  @override
  String get helpFeatureWebCleanerBody =>
      'वितीर्णानि जालपृष्ठानि PDF-रूपेण परिवर्तयितुं पूर्वं विज्ञापनानि, अनुसरणं, पताकाः, पार्श्वपट्टिकाः, लिपिकाः च अपनीयन्ते।';

  @override
  String get helpFeatureWebCleanerTag1 => 'विज्ञापनापनयनम्';

  @override
  String get helpFeatureWebCleanerTag2 => 'पठनदर्शनम्';

  @override
  String get helpFeatureWebCleanerTag3 => 'शुद्धानि PDF-पत्राणि';

  @override
  String get helpFeatureImagesToPdfTitle => 'चित्रपाठयोः PDF-परिवर्तकः';

  @override
  String get helpFeatureImagesToPdfBody =>
      'चित्रवीथ्याः 100 पर्यन्तं चित्राणि वितीर्णः सरलपाठः वा सुविन्यस्तेषु बहुपृष्ठ-PDF-लेखेषु परिवर्त्यन्ते।';

  @override
  String get helpFeatureImagesToPdfTag1 => '100 चित्राणि यावत्';

  @override
  String get helpFeatureImagesToPdfTag2 => 'सरलपाठानयनम्';

  @override
  String get helpFeatureImagesToPdfTag3 => 'स्वेच्छप्रान्तान्तराणि';

  @override
  String get helpFeatureSignatureCheckTitle => 'गूढलेखहस्ताक्षरसत्यापनम्';

  @override
  String get helpFeatureSignatureCheckBody =>
      'Bouncy Castle-साधनेन लेखस्य अखण्डता, बाइट्-व्याप्तिः, प्रमाणपत्रस्य प्रामाण्यं च असंयुक्तरूपेण परीक्ष्यन्ते।';

  @override
  String get helpFeatureSignatureCheckTag1 => 'बाइट्-अखण्डता';

  @override
  String get helpFeatureSignatureCheckTag2 => 'बाइट्-व्याप्तिपरिधिः';

  @override
  String get helpFeatureSignatureCheckTag3 => 'असंयुक्तसत्यापनम्';

  @override
  String get helpFeatureTrustStoreTitle => 'स्वविश्वस्तकोशः EU-सूच्यः च';

  @override
  String get helpFeatureTrustStoreBody =>
      'EU-विश्वस्तसूचीनां मूलप्रमाणपत्राणि अन्तर्भूतानि; स्वकीयानि CA/मूलप्रमाणपत्राणि आनेतुम् अपि शक्यन्ते।';

  @override
  String get helpFeatureTrustStoreTag1 => 'EU-विश्वस्तसूच्यः';

  @override
  String get helpFeatureTrustStoreTag2 => 'X.509 PEM-आनयनम्';

  @override
  String get helpFeatureTrustStoreTag3 => 'PEM-निर्यापणम्';

  @override
  String get helpFeatureSignatureStampsTitle => 'दृश्यहस्ताक्षरमुद्राः';

  @override
  String get helpFeatureSignatureStampsBody =>
      'PDF-पृष्ठेषु स्पर्शयोग्याः हस्ताक्षरमुद्राः; एकस्पर्शेन प्रमाणपत्रशृङ्खलायाः विवरणं दृश्यते।';

  @override
  String get helpFeatureSignatureStampsTag1 => 'पृष्ठमुद्राः';

  @override
  String get helpFeatureSignatureStampsTag2 => 'प्रमाणपत्रशृङ्खलाः';

  @override
  String get helpFeatureSignatureStampsTag3 => 'हस्ताक्षरकर्तृविवरणम्';

  @override
  String get helpFeatureThemesTitle => 'दीप्त-श्याम-OLED-कृष्णरूपाणि';

  @override
  String get helpFeatureThemesBody =>
      'दीप्तं, श्यामं, सेपिया, विद्युत्कोशरक्षणार्थम् OLED-घनकृष्णं (#000000) च रूपाणि लभ्यन्ते।';

  @override
  String get helpFeatureThemesTag1 => 'OLED-घनकृष्णम्';

  @override
  String get helpFeatureThemesTag2 => 'सेपियापठनम्';

  @override
  String get helpFeatureThemesTag3 => 'तन्त्रानुसारि';

  @override
  String get helpFeatureTypographyTitle => 'अक्षररूपं परिमाणं च';

  @override
  String get helpFeatureTypographyBody =>
      'मञ्जरी, Anek Malayalam, Noto Sans Malayalam, तन्त्राक्षररूपं च इति एषु परिवर्तनं शक्यम्; पाठपरिमाणम् अपि परिवर्तनीयम्।';

  @override
  String get helpFeatureTypographyTag1 => 'मलयाळाक्षररूपाणि';

  @override
  String get helpFeatureTypographyTag2 => 'अक्षरपरिमाणम्';

  @override
  String get helpFeatureTypographyTag3 => 'तत्क्षणपरिवर्तनम्';

  @override
  String get helpFeatureAccentTitle => 'प्रधानवर्णचयनम्';

  @override
  String get helpFeatureAccentBody =>
      'सज्जीकृताः वर्णाः सम्पूर्णं HSV-वर्णचक्रं च; अनुप्रयोगरूपं तत्क्षणं दृश्यते।';

  @override
  String get helpFeatureAccentTag1 => 'HSV-वर्णचक्रम्';

  @override
  String get helpFeatureAccentTag2 => '8 सज्जवर्णाः';

  @override
  String get helpFeatureAccentTag3 => 'तत्क्षणदर्शनम्';

  @override
  String get helpFeatureGuidesTitle => 'षट् सोपानमार्गदर्शिकाः';

  @override
  String get helpFeatureGuidesBody =>
      'PDF-मुद्रकविन्यासः, Unicode-मुद्रणं, TTS-ध्वनिविन्यासः, पृष्ठकार्याणि, हस्ताक्षराणि, गोपनीयता च इति विषयेषु विस्तृताः मार्गदर्शिकाः।';

  @override
  String get helpFeatureGuidesTag1 => 'पूर्णतया असंयुक्ताः';

  @override
  String get helpFeatureGuidesTag2 => 'समस्यानिवारणम्';

  @override
  String get helpFeatureGuidesTag3 => 'सोपानक्रमेण';

  @override
  String get labelColorGrey => 'धूसरः';

  @override
  String get labelAccentColorWheel => 'वर्णचक्रम्';

  @override
  String get helpAccentColorWheelHint =>
      'प्रधानवर्णचयनाय चक्रे अङ्गुलिः चाल्यताम्।';

  @override
  String get titleAppData => 'अनुप्रयोगदत्तांशः';

  @override
  String get actionDeleteAllData => 'सर्वं लुप्यताम्';

  @override
  String get descDeleteAllData =>
      'सद्यःसञ्चिकाः, पठनस्थानानि, टिप्पण्यः चिह्नानि च, भवता विश्वस्तानि प्रमाणपत्राणि, रक्षितविन्यासाः, मुद्रितसञ्चिकाः, अस्थायिसञ्चिकाः च अपनीयन्ते। भवतः स्वकीयाः PDF-सञ्चिकाः न स्पृश्यन्ते।';

  @override
  String get titleDeleteAllDataConfirm => 'सर्वं लोप्तव्यं किम्?';

  @override
  String get bodyDeleteAllDataConfirm =>
      'इदं पुनः प्रत्यानेतुं न शक्यते। अनुप्रयोगः मूलविन्यासैः सह मुख्यपटलात् पुनः आरप्स्यते।';

  @override
  String get errorDeleteAllData =>
      'कश्चन दत्तांशः लोप्तुं न शक्तः। पुनः प्रयत्यताम्।';

  @override
  String get actionClear => 'मार्ज्यताम्';

  @override
  String get labelLanguageAuto => 'स्वयम्';

  @override
  String get labelPaperA4 => 'A4';

  @override
  String get labelPaperLetter => 'US लेटर्';

  @override
  String get labelPaperLegal => 'लीगल्';

  @override
  String get descPaperA4 => '210 × 297 मि.मी.';

  @override
  String get descPaperLetter => '8.5 × 11 इञ्च्';

  @override
  String get descPaperLegal => '8.5 × 14 इञ्च्';

  @override
  String get labelQualityStandard => 'सामान्यम्';

  @override
  String get labelQualityHigh => 'उत्कृष्टम्';

  @override
  String get emptyExtractedText => 'पाठः न लब्धः।';

  @override
  String get labelWatermarkConfidential => 'गोपनीयम्';

  @override
  String get labelWatermarkDraft => 'प्रारूपम्';

  @override
  String get labelWatermarkCopy => 'प्रतिलिपिः';

  @override
  String get labelWatermarkSample => 'निदर्शनम्';

  @override
  String get labelWatermarkOriginal => 'मूलप्रतिः';

  @override
  String get titleDeviceSync => 'यन्त्रसमन्वयः';

  @override
  String get descDeviceSyncSubtitle =>
      'QR-सङ्केतेन Wi-Fi-द्वारा वा विन्यासः प्रतिलिख्यताम्, PDF-पत्राणि प्रेष्यन्ताम्';

  @override
  String get descDeviceSyncIntro =>
      'भवतः ग्रन्थ-अनुप्रयोगस्य विन्यासः अन्यस्मिन् दूरभाषे प्रतिलेखितुं, PDF-पत्राणि वा प्रेषयितुं शक्यन्ते। यस्मिन् दूरभाषे तानि वर्तन्ते सः सङ्केतं दर्शयति। अपरः दूरभाषः तं सङ्केतं पठति।';

  @override
  String get descDeviceSyncWhatIsCopied =>
      'केवलं विन्यासः प्रतिलिख्यते। सद्यःसञ्चिकाः, पठनस्थानानि, टिप्पण्यः, चिह्नपत्राणि, विश्वस्तप्रमाणपत्राणि च अस्मिन्नेव दूरभाषे तिष्ठन्ति। मलयाळध्वनेः चयनं PDF-मुद्रकस्य सक्रियता च अपि न प्रतिलिख्येते, यतः ते प्रतिदूरभाषं भिन्ने।';

  @override
  String get titleShareSettings => 'विन्यासवितरणम्';

  @override
  String get descShareSettingsSubtitle =>
      'अपरेण दूरभाषेण पठनीयः सङ्केतः दर्श्यताम्';

  @override
  String get labelSyncModeQr => 'केवलं QR';

  @override
  String get labelSyncModeWifi => 'Wi-Fi';

  @override
  String get descSyncModeQrHelp =>
      'विन्यासः सङ्केते एव अन्तर्भवति। जालस्य आवश्यकता नास्ति।';

  @override
  String get descSyncModeWifiHelp =>
      'अयं सङ्केतः स्थानीयेन Wi-Fi-जालेन द्वौ दूरभाषौ संयोजयति। उभौ दूरभाषौ एकस्मिन्नेव Wi-Fi-जाले भवेताम्, अथवा एकः दूरभाषः अपरस्य hotspot-जालं प्रविशेत्। किमपि अन्तर्जालं न गच्छति।';

  @override
  String descWifiCodeExpires(String time) {
    return 'अयं सङ्केतः $time कालं यावत् प्रवर्तते।';
  }

  @override
  String descWifiGuestConnected(String address) {
    return '$address इत्यनेन सह संयुक्तम्। अपरस्य दूरभाषस्य स्थिरीकरणं प्रतीक्ष्यते…';
  }

  @override
  String get descWifiShareAccepted => 'अपरेण दूरभाषेण भवतः विन्यासः प्रयुक्तः।';

  @override
  String get descWifiShareDeclined =>
      'अपरेण दूरभाषेण निरस्तम्। तत्र किमपि न परिवर्तितम्।';

  @override
  String get errorNoLanAddress =>
      'अयं दूरभाषः कस्मिंश्चिद् Wi-Fi-जाले नास्ति। उभौ दूरभाषौ एकस्मिन् Wi-Fi-जाले योज्येताम्, एकस्मिन् दूरभाषे hotspot सक्रियीक्रियताम्, अथवा \'केवलं QR\' उपयुज्यताम्।';

  @override
  String get descWifiSessionEnded =>
      'ग्रन्थ-अनुप्रयोगः पृष्ठभूमिं गतः इति कारणात् Wi-Fi-सत्रं समाप्तम्। सज्जे सति पुनः आरभ्यताम्।';

  @override
  String get titleScanCode => 'सङ्केतपठनम्';

  @override
  String get descScanCodeHelp =>
      'अपरस्य दूरभाषस्य सङ्केतं प्रति छायाचित्रयन्त्रं निर्दिश्यताम्।';

  @override
  String get errorCameraUnavailable =>
      'छायाचित्रयन्त्रम् आरब्धुं न शक्तम्। तन्त्रविन्यासे ग्रन्थ-अनुप्रयोगाय (Folio) छायाचित्रयन्त्रानुमतिः दीयताम्, ततः पुनः प्रयत्यताम्। छायाचित्रयन्त्ररहितः दूरभाषः अपि विन्यासं PDF-पत्राणि च प्रेषयितुं शक्नोति।';

  @override
  String get errorCodeNotFolio => 'अयं ग्रन्थ-सङ्केतः न।';

  @override
  String get errorCodeDamaged =>
      'अयं ग्रन्थ-सङ्केतः पठितुं न शक्तः। नूतनः सङ्केतः सृज्यताम्, पुनः प्रयत्यताम् च।';

  @override
  String get errorCodeNewerVersion =>
      'अयं सङ्केतः ग्रन्थ-अनुप्रयोगस्य नूतनतरेण संस्करणेन सृष्टः। अस्मिन् दूरभाषे ग्रन्थ-अनुप्रयोगः अद्यतनीक्रियताम्।';

  @override
  String get errorCodeUnsafeAddress =>
      'अयं सङ्केतः स्थानीयजालात् बहिः निर्दिशति, अतः ग्रन्थ-अनुप्रयोगः तं न उपयुङ्क्ते।';

  @override
  String get descReceiveConnecting => 'अपरेण दूरभाषेण सह संयोज्यते…';

  @override
  String descReviewSettingsChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count विन्यासाः परिवर्तिष्यन्ते:',
      one: 'एकः विन्यासः परिवर्तिष्यते:',
    );
    return '$_temp0';
  }

  @override
  String get descReviewSettingsSame =>
      'भवतः विन्यासः पूर्वमेव अपरस्य दूरभाषस्य विन्यासेन समानः।';

  @override
  String get descReviewSettingsSkipped =>
      'केचन मूल्यांशाः त्यक्ताः, यतः ग्रन्थ-अनुप्रयोगस्य इदं संस्करणं तान् उपयोक्तुं न शक्नोति।';

  @override
  String get actionApplySettings => 'प्रयुज्यताम्';

  @override
  String get descSettingsApplied => 'विन्यासः प्रयुक्तः।';

  @override
  String get descSettingsNotApplied => 'किमपि न परिवर्तितम्।';

  @override
  String get errorTransferUnreachable =>
      'अपरं दूरभाषं प्राप्तुं न शक्तम्। उभयोः दूरभाषयोः एकमेव Wi-Fi-जालम् उपयुज्यताम्, अथवा एकस्मिन् दूरभाषे hotspot सक्रियीकृत्य अपरेण तत् प्रविश्यताम्। कानिचित् कार्यालय-विश्रामगृह-Wi-Fi-जालानि एतत् निरुन्धन्ति।';

  @override
  String get errorTransferTimedOut =>
      'निर्दिष्टकाले किमपि न अभवत्। नूतनः सङ्केतः सृज्यताम्, पुनः प्रयत्यताम् च।';

  @override
  String get errorTransferWrongCode =>
      'सङ्केतः न सफलः। सः पुरातनः पूर्वमुपयुक्तः वा स्यात्। नूतनः सङ्केतः सृज्यताम्, पुनः प्रयत्यताम् च।';

  @override
  String get errorTransferBadData =>
      'अपरस्मात् दूरभाषात् आगतः दत्तांशः दूषितः आसीत्। पुनः प्रयत्यताम्।';

  @override
  String get errorTransferUnsupportedVersion =>
      'अपरस्मिन् दूरभाषे ग्रन्थ-अनुप्रयोगस्य भिन्नं संस्करणं वर्तते। उभयोः दूरभाषयोः ग्रन्थ-अनुप्रयोगः अद्यतनीक्रियताम्।';

  @override
  String get errorTransferConnectionLost =>
      'सम्पर्कः विच्छिन्नः। पुनः प्रयत्यताम्।';

  @override
  String get labelSyncAccentLight => 'दीप्तरूपस्य वर्णः';

  @override
  String get labelSyncAccentDark => 'श्यामरूपस्य वर्णः';

  @override
  String get titlePermCamera => 'छायाचित्रयन्त्रम्';

  @override
  String get descPermCameraReason =>
      'केवलं सङ्केतपठनपटले यन्त्रसमन्वयस्य QR-सङ्केतं पठितुम् उपयुज्यते। प्रथमपठनसमये अनुमतिः याच्यते। न किमपि छायाचित्रं चलचित्रं वा गृह्यते रक्ष्यते वा।';

  @override
  String get descPermCameraWhatItAchieves =>
      'अन्यस्य दूरभाषस्य सङ्केतं पठित्वा ततः विन्यासं PDF-पत्राणि वा स्वीकर्तुं साहाय्यं करोति।';

  @override
  String get titlePermLocalNetwork => 'केवलं स्थानीय-Wi-Fi';

  @override
  String get descPermLocalNetworkReason =>
      'एकस्मिन् Wi-Fi-जाले स्थितयोः द्वयोः दूरभाषयोः सम्पर्काय अपि android.permission.INTERNET आवश्यकम्। ग्रन्थ-अनुप्रयोगः इदं केवलं यन्त्रसमन्वयाय, तस्मिन् पटले उद्घाटिते एव, QR-सङ्केतात् पठितेन निजस्थानीयसङ्केतस्थानेन सह एव उपयुङ्क्ते।';

  @override
  String get descPermLocalNetworkWhatItAchieves =>
      'एकवारिककुञ्चिकया गूढीकृत्य दूरभाषौ परस्परं साक्षात् संवदतः। ग्रन्थ-अनुप्रयोगः कदापि अन्तर्जालसेवकेन सह सम्पर्कं न करोति।';

  @override
  String get titleReceive => 'स्वीकारः';

  @override
  String get descReceiveSubtitle =>
      'विन्यासं PDF-पत्राणि वा प्राप्तुम् अपरस्य दूरभाषस्य सङ्केतः पठ्यताम्';

  @override
  String get descDeviceSyncSendPdfsHint =>
      'PDF-पत्राणि प्रेषयितुम्: गृहपटले सद्यःसञ्चिकां दीर्घं स्पृष्ट्वा चिनोतु (अधिकानि योजयितुम् तानि स्पृशतु), अथवा PDF उद्घाट्य सूच्याः \'समीपदूरभाषं प्रेष्यताम्\' इति चिनोतु।';

  @override
  String get actionSendNearby => 'समीपदूरभाषं प्रेष्यताम्';

  @override
  String get titleSendFiles => 'PDF-प्रेषणम्';

  @override
  String descSendPreparing(int done, int total) {
    return 'सञ्चिकाः सज्जीक्रियन्ते… $total मध्ये $done';
  }

  @override
  String get descSendScanPrompt =>
      'अपरस्मिन् दूरभाषे ग्रन्थः (Folio) › विन्यासः › यन्त्रसमन्वयः › स्वीकारः उद्घाट्य अयं सङ्केतः पठ्यताम्।';

  @override
  String descSendFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'प्रेषणाय $count PDF-पत्राणि सज्जानि',
      one: 'प्रेषणाय एकं PDF सज्जम्',
    );
    return '$_temp0';
  }

  @override
  String descSendSkipped(String names) {
    return 'एताः सञ्चिकाः पठितुं न शक्ताः, अतः न प्रेष्यन्ते: $names';
  }

  @override
  String get errorSendNothing =>
      'चितासु सञ्चिकासु एकापि पठितुं न शक्ता। ताः स्थानान्तरिताः लुप्ताः वा स्युः। ताः पुनः उद्घाट्य पुनः प्रयत्यताम्।';

  @override
  String get errorSendNoNetwork =>
      'अयं दूरभाषः कस्मिंश्चिद् Wi-Fi-जाले नास्ति। उभौ दूरभाषौ एकस्मिन् Wi-Fi-जाले योज्येताम्, अथवा एकस्मिन् दूरभाषे hotspot सक्रियीक्रियताम्।';

  @override
  String descSendTransferring(String sent, String total) {
    return 'प्रेष्यते… $total मध्ये $sent';
  }

  @override
  String descSendFinished(int received, int count) {
    return '$count PDF-पत्रेषु $received अपरं दूरभाषं सुरक्षितं प्राप्तानि।';
  }

  @override
  String get descSendDeclined => 'अपरेण दूरभाषेण निरस्तम्। किमपि न प्रेषितम्।';

  @override
  String descReceiveFilesHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'अपरस्मात् दूरभाषात् $count PDF-पत्राणि:',
      one: 'अपरस्मात् दूरभाषात् एकं PDF:',
    );
    return '$_temp0';
  }

  @override
  String descReceiveFilesTotal(String size) {
    return 'समग्रपरिमाणम्: $size';
  }

  @override
  String descSavingTo(String folder) {
    return 'रक्षणस्थानम्: $folder';
  }

  @override
  String get descNoFolderYet =>
      'PDF-पत्राणां रक्षणाय एका सञ्चिकाधानी चीयताम्। ग्रन्थ-अनुप्रयोगः तां स्मरिष्यति।';

  @override
  String get errorFolderLost =>
      'पूर्वं चिता सञ्चिकाधानी इदानीम् उपयोक्तुं न शक्यते। सा लुप्ता स्यात्, तस्याः अनुमतिः वा अपनीता स्यात्। पुनः सञ्चिकाधानी चीयताम्।';

  @override
  String get actionChangeFolder => 'परिवर्त्यताम्';

  @override
  String get actionChooseFolder => 'सञ्चिकाधानी चीयताम्';

  @override
  String get actionAcceptFiles => 'स्वीक्रियताम्';

  @override
  String descReceiveTransferring(String received, String total) {
    return 'स्वीक्रियते… $total मध्ये $received';
  }

  @override
  String get descReceiveSaving => 'सञ्चिकाधान्यां रक्ष्यते…';

  @override
  String descReceiveFilesSaved(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF-पत्राणि $folder इत्यत्र रक्षितानि।',
      one: 'एकं PDF $folder इत्यत्र रक्षितम्।',
      zero: 'किमपि PDF न रक्षितम्।',
    );
    return '$_temp0';
  }

  @override
  String descReceiveFilesFailed(String names) {
    return 'न रक्षितानि (मार्गे दूषितानि, PDF न, लेखितुं वा न शक्तानि): $names';
  }

  @override
  String get errorTransferCannotSave =>
      'सञ्चिकाः रक्षितुं न शक्ताः। दूरभाषे स्थानं समाप्तं स्यात्, सञ्चिकाधान्यां लेखनं वा इदानीं न शक्यम्।';

  @override
  String labelSelectedCount(int count) {
    return '$count चितानि';
  }

  @override
  String get tooltipCancelSelection => 'चयनं निरस्यताम्';

  @override
  String get descShowCodeScanPrompt =>
      'अपरस्मिन् दूरभाषे ग्रन्थः (Folio) › विन्यासः › यन्त्रसमन्वयः › स्वीकारः उद्घाट्य अयं सङ्केतः पठ्यताम्।';
}
