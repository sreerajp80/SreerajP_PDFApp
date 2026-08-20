import 'package:go_router/go_router.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/about/presentation/about_screen.dart';
import 'package:pdfapp/features/help/presentation/help_screen.dart';
import 'package:pdfapp/features/help/presentation/page_ops_help_screen.dart';
import 'package:pdfapp/features/help/presentation/pdf_printer_help_screen.dart';
import 'package:pdfapp/features/help/presentation/privacy_storage_help_screen.dart';
import 'package:pdfapp/features/help/presentation/signatures_help_screen.dart';
import 'package:pdfapp/features/help/presentation/tts_help_screen.dart';
import 'package:pdfapp/features/help/presentation/unicode_printing_help_screen.dart';
import 'package:pdfapp/features/printer/presentation/import_screen.dart';
import 'package:pdfapp/features/settings/presentation/accent_color_screen.dart';
import 'package:pdfapp/features/settings/presentation/appearance_screen.dart';
import 'package:pdfapp/features/settings/presentation/features_screen.dart';
import 'package:pdfapp/features/settings/presentation/language_screen.dart';
import 'package:pdfapp/features/settings/presentation/permissions_screen.dart';
import 'package:pdfapp/features/settings/presentation/printer_settings_screen.dart';
import 'package:pdfapp/features/settings/presentation/reader_settings_screen.dart';
import 'package:pdfapp/features/settings/presentation/settings_screen.dart';
import 'package:pdfapp/features/settings/presentation/storage_settings_screen.dart';
import 'package:pdfapp/features/settings/presentation/theme_screen.dart';
import 'package:pdfapp/features/settings/presentation/tts_settings_screen.dart';
import 'package:pdfapp/features/settings/presentation/typography_screen.dart';
import 'package:pdfapp/features/signature/presentation/signatures_screen.dart';
import 'package:pdfapp/features/signature/presentation/trust_store_screen.dart';
import 'package:pdfapp/features/viewer/domain/pdf_document_ref.dart';
import 'package:pdfapp/features/viewer/presentation/home_screen.dart';
import 'package:pdfapp/features/viewer/presentation/viewer_screen.dart';

/// Centralized route names (engineering standard §6.9). Use the enum name with
/// `context.goNamed` / `context.pushNamed` so paths stay in one place.
enum AppRoute {
  home,
  viewer,
  settings,
  appearance,
  theme,
  typography,
  accentColor,
  features,
  language,
  readerSettings,
  ttsSettings,
  printerSettings,
  storageSettings,
  permissions,
  help,
  helpPdfPrinter,
  helpUnicodePrinting,
  helpTts,
  helpPageOps,
  helpSignatures,
  helpPrivacyStorage,
  about,
  import,
  signatures,
  trustStore,
}

extension AppRoutePath on AppRoute {
  String get path => switch (this) {
    AppRoute.home => '/',
    AppRoute.viewer => '/viewer',
    AppRoute.settings => '/settings',
    AppRoute.appearance => '/appearance',
    AppRoute.theme => '/theme',
    AppRoute.typography => '/settings/typography',
    AppRoute.accentColor => '/accent-color',
    AppRoute.features => '/features',
    AppRoute.language => '/settings/language',
    AppRoute.readerSettings => '/settings/reader',
    AppRoute.ttsSettings => '/settings/tts',
    AppRoute.printerSettings => '/settings/printer',
    AppRoute.storageSettings => '/settings/storage',
    AppRoute.permissions => '/permissions',
    AppRoute.help => '/help',
    AppRoute.helpPdfPrinter => '/help/pdf-printer',
    AppRoute.helpUnicodePrinting => '/help/unicode-printing',
    AppRoute.helpTts => '/help/tts',
    AppRoute.helpPageOps => '/help/page-ops',
    AppRoute.helpSignatures => '/help/signatures',
    AppRoute.helpPrivacyStorage => '/help/privacy-storage',
    AppRoute.about => '/about',
    AppRoute.import => '/import',
    AppRoute.signatures => '/signatures',
    AppRoute.trustStore => '/trust-store',
  };
}

/// The app's router. The Viewer route takes the [PdfDocumentRef] to open via
/// `extra` (Phase 1); the Import route takes the shared [IncomingContent] to
/// turn into a PDF (Phase 6).
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: [
    GoRoute(
      name: AppRoute.home.name,
      path: AppRoute.home.path,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: AppRoute.viewer.name,
      path: AppRoute.viewer.path,
      builder: (context, state) =>
          ViewerScreen(docRef: state.extra! as PdfDocumentRef),
    ),
    GoRoute(
      name: AppRoute.settings.name,
      path: AppRoute.settings.path,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      name: AppRoute.appearance.name,
      path: AppRoute.appearance.path,
      builder: (context, state) => const AppearanceScreen(),
    ),
    GoRoute(
      name: AppRoute.theme.name,
      path: AppRoute.theme.path,
      builder: (context, state) => const ThemeScreen(),
    ),
    GoRoute(
      name: AppRoute.typography.name,
      path: AppRoute.typography.path,
      builder: (context, state) => const TypographyScreen(),
    ),
    GoRoute(
      name: AppRoute.accentColor.name,
      path: AppRoute.accentColor.path,
      builder: (context, state) => const AccentColorScreen(),
    ),
    GoRoute(
      name: AppRoute.features.name,
      path: AppRoute.features.path,
      builder: (context, state) => const FeaturesScreen(),
    ),
    GoRoute(
      name: AppRoute.language.name,
      path: AppRoute.language.path,
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      name: AppRoute.readerSettings.name,
      path: AppRoute.readerSettings.path,
      builder: (context, state) => const ReaderSettingsScreen(),
    ),
    GoRoute(
      name: AppRoute.ttsSettings.name,
      path: AppRoute.ttsSettings.path,
      builder: (context, state) => const TtsSettingsScreen(),
    ),
    GoRoute(
      name: AppRoute.printerSettings.name,
      path: AppRoute.printerSettings.path,
      builder: (context, state) => const PrinterSettingsScreen(),
    ),
    GoRoute(
      name: AppRoute.storageSettings.name,
      path: AppRoute.storageSettings.path,
      builder: (context, state) => const StorageSettingsScreen(),
    ),
    GoRoute(
      name: AppRoute.permissions.name,
      path: AppRoute.permissions.path,
      builder: (context, state) => const PermissionsScreen(),
    ),
    GoRoute(
      name: AppRoute.help.name,
      path: AppRoute.help.path,
      builder: (context, state) => const HelpScreen(),
    ),
    GoRoute(
      name: AppRoute.helpPdfPrinter.name,
      path: AppRoute.helpPdfPrinter.path,
      builder: (context, state) => const PdfPrinterHelpScreen(),
    ),
    GoRoute(
      name: AppRoute.helpUnicodePrinting.name,
      path: AppRoute.helpUnicodePrinting.path,
      builder: (context, state) => const UnicodePrintingHelpScreen(),
    ),
    GoRoute(
      name: AppRoute.helpTts.name,
      path: AppRoute.helpTts.path,
      builder: (context, state) => const TtsHelpScreen(),
    ),
    GoRoute(
      name: AppRoute.helpPageOps.name,
      path: AppRoute.helpPageOps.path,
      builder: (context, state) => const PageOpsHelpScreen(),
    ),
    GoRoute(
      name: AppRoute.helpSignatures.name,
      path: AppRoute.helpSignatures.path,
      builder: (context, state) => const SignaturesHelpScreen(),
    ),
    GoRoute(
      name: AppRoute.helpPrivacyStorage.name,
      path: AppRoute.helpPrivacyStorage.path,
      builder: (context, state) => const PrivacyStorageHelpScreen(),
    ),
    GoRoute(
      name: AppRoute.about.name,
      path: AppRoute.about.path,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      name: AppRoute.import.name,
      path: AppRoute.import.path,
      builder: (context, state) =>
          ImportScreen(content: state.extra! as IncomingContent),
    ),
    GoRoute(
      name: AppRoute.signatures.name,
      path: AppRoute.signatures.path,
      builder: (context, state) =>
          SignaturesScreen(path: state.extra! as String),
    ),
    GoRoute(
      name: AppRoute.trustStore.name,
      path: AppRoute.trustStore.path,
      builder: (context, state) => const TrustStoreScreen(),
    ),
  ],
);
