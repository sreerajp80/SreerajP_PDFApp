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
  static const String prefMalayalamTts = 'settings.malayalam_tts'; // Phase 2

  // Size thresholds (bytes). Above this a PDF is treated as "large" (Phase 1).
  static const int largePdfThresholdBytes = 50 * 1024 * 1024; // 50 MB

  // How many recent files Home keeps (older entries are trimmed).
  static const int recentFilesLimit = 30;

  // --- Reading / search (Phase 2) ---

  // How many pages to sample when deciding whether a PDF has usable text.
  // Enough to see past a picture-only cover page, small enough to stay quick.
  static const int textQualitySamplePages = 5;

  // Below this many characters there is too little evidence to call a PDF
  // garbled, so we assume it is fine (never accuse a good PDF).
  static const int minCharsForTextQualityCheck = 20;

  // Share of undecodable characters above which extracted text is "garbled"
  // (a font with no ToUnicode map). A few odd glyphs are normal; a fifth is not.
  static const double garbledTextRatioThreshold = 0.2;

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
