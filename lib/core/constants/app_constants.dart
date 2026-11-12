/// Technical constants (values only, no logic) — guideline.md §1 note.
/// About-screen text lives in `assets/config/app_config.json`, not here.
class AppConstants {
  const AppConstants._();

  // Database.
  static const String databaseName = 'pdfapp.db';
  static const int databaseVersion = 4;

  // Table names (added per phase; keep the list here so it is easy to review).
  static const String tableMeta = 'meta';
  static const String tableRecentFiles = 'recent_files'; // v2 (Phase 1)
  static const String tableReadingPositions =
      'reading_positions'; // v2 (Phase 1)
  static const String tableAnnotations = 'annotations'; // v3 (Phase 5)
  static const String tableTrustStore = 'trust_store'; // v4 (Phase 7)

  // Method-channel ids (native modules built in later phases).
  static const String channelPdfBox = 'in.sreerajp.pdfapp/pdfbox';
  static const String channelSignature = 'in.sreerajp.pdfapp/signature';
  static const String channelPrint = 'in.sreerajp.pdfapp/print';
  // SAF open + "Open with" intent bridge (Phase 1).
  static const String channelOpenDocument = 'in.sreerajp.pdfapp/open';
  static const String eventOpenDocument = 'in.sreerajp.pdfapp/open_events';
  // Guided install for a missing text-to-speech voice (Phase 2).
  static const String channelTts = 'in.sreerajp.pdfapp/tts';

  // shared_preferences keys (non-secret settings).
  static const String prefThemeMode = 'settings.theme_mode';
  static const String prefAccentLight = 'settings.accent_light';
  static const String prefAccentDark = 'settings.accent_dark';
  static const String prefAppFont = 'settings.app_font';
  static const String prefTextScale = 'settings.text_scale';
  static const String prefAppLocale = 'settings.app_locale';
  static const String prefMalayalamTts = 'settings.malayalam_tts'; // Phase 2
  static const String prefTtsSpeechRate = 'settings.tts_speech_rate';
  static const String prefTtsPitch = 'settings.tts_pitch';
  static const String prefTtsSentencePause = 'settings.tts_sentence_pause';
  static const String prefTtsAutoScroll = 'settings.tts_auto_scroll';
  static const String prefRememberReadingPosition =
      'settings.remember_reading_position';
  static const String prefShowReadingEstimates =
      'settings.show_reading_estimates';
  static const String prefDefaultPageLayout = 'settings.default_page_layout';
  static const String prefShowPageIndicator = 'settings.show_page_indicator';
  static const String prefPdfInvertColors = 'settings.pdf_invert_colors';
  static const String prefDoubleTapZoom = 'settings.double_tap_zoom';
  static const String prefPdfPrinterEnabled = 'settings.printer_enabled';
  static const String prefDefaultPaperSize = 'settings.default_paper_size';
  static const String prefDefaultPrintColorMode =
      'settings.default_print_color_mode';
  static const String prefDefaultPrintOrientation =
      'settings.default_print_orientation';
  static const String prefRememberRecentFiles =
      'settings.remember_recent_files';
  static const String prefAutoVerifySignatures =
      'settings.auto_verify_signatures';
  // Device sync: the folder received PDFs are saved into (a SAF tree URI).
  // Belongs to this phone only, so it is NOT in the Device sync allow-list.
  static const String prefReceiveFolderUri = 'device.receive_folder_uri';

  // Size thresholds (bytes). Above this a PDF is treated as "large" (Phase 1).
  static const int largePdfThresholdBytes = 50 * 1024 * 1024; // 50 MB

  // How many recent files Home keeps (older entries are trimmed).
  static const int recentFilesLimit = 30;

  // --- Reading / search (Phase 2) ---

  // How many pages to sample when deciding whether a PDF has usable text.
  // Enough to see past a picture-only cover page, small enough to stay quick.
  static const int textQualitySamplePages = 5;

  // How long to wait for a page that the viewer has not loaded yet before its
  // text is read. pdfrx loads pages one by one in the background; reading a
  // page before it loads gives no text. If it still has not loaded, the page
  // counts as empty for now and is tried again on the next request.
  static const Duration pageTextLoadTimeout = Duration(seconds: 10);

  // Below this many characters there is too little evidence to call a PDF
  // garbled, so we assume it is fine (never accuse a good PDF).
  static const int minCharsForTextQualityCheck = 20;

  // Share of undecodable characters above which extracted text is "garbled"
  // (a font with no ToUnicode map). A few odd glyphs are normal; a fifth is not.
  static const double garbledTextRatioThreshold = 0.2;

  // Share of Indic combining marks (vowel signs, virama, anusvara…) found in a
  // place real Unicode never puts them — at the start of a word, after a space,
  // after an independent vowel. Above it, the PDF most likely stores letters in
  // the order they are drawn, not the order they are read. A first guess.
  static const double misplacedIndicMarkRatioThreshold = 0.05;

  // Fewer Indic marks than this is too little evidence to judge their order.
  static const int minIndicMarksForOrderCheck = 20;

  // Share of rare Latin-1 symbols (¼ ½ ¡ ¢ ¥ ¸ ¿ …) in text with almost no real
  // Indic letters. Old Indic fonts (Kruti Dev, ML-TT style) map their glyphs
  // onto these, so the page shows Indic letters while the text is Latin
  // nonsense. A first guess.
  static const double legacyFontSymbolRatioThreshold = 0.03;

  // Fewer rare symbols than this is not treated as a legacy font.
  static const int minLegacyFontSymbols = 5;

  // Text layout repair (see TextLayoutRepair). pdfium drops a real space glyph
  // when the virama (്, ्) before it overlaps it. Inside a word the next letter
  // always touches the virama (gap <= 0); at a word end the gap was >= 0.15 of
  // the letter height in a 7,892-word test book. A gap above this share of the
  // virama box height means a word ended there.
  static const double textRepairViramaGapRatio = 0.1;

  // How far (in PDF points) a misplaced space's centre may sit outside a gap
  // between two letters and still be put back into that gap.
  static const double textRepairGapTolerance = 1.0;

  // Stop after this many search matches. Guards the UI and memory against a
  // one-letter query on a huge document.
  static const int searchMatchLimit = 500;

  // --- Printer / import (Phase 6) ---

  // Cache folder for PDFs built from shared pictures or text, and for the
  // range-only copies made before printing. Cleared before each new job.
  static const String printerCacheDir = 'printer';

  // Most pictures accepted in one share. Beyond this the PDF is unwieldy and the
  // build would take long enough to feel broken.
  static const int maxImportImages = 100;

  // --- Signatures (Phase 7) ---

  // The bundled "globally trusted" certificate list (EU Trusted Lists). Read-only
  // asset. Adobe's AATL is deliberately not bundled: its redistribution terms are
  // not clearly open, and project rule 1 requires a checked licence.
  static const String eutlAssetPath = 'assets/trust/eutl_certificates.pem';

  // Largest certificate file accepted when the user adds one to the trust store.
  // A real certificate is a few kilobytes; anything this big is not one.
  static const int maxCertificateBytes = 512 * 1024;
}
