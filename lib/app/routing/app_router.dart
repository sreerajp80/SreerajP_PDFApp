import 'package:go_router/go_router.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/about/presentation/about_screen.dart';
import 'package:pdfapp/features/printer/presentation/import_screen.dart';
import 'package:pdfapp/features/settings/presentation/settings_screen.dart';
import 'package:pdfapp/features/settings/presentation/theme_screen.dart';
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
  theme,
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
    AppRoute.theme => '/theme',
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
      name: AppRoute.theme.name,
      path: AppRoute.theme.path,
      builder: (context, state) => const ThemeScreen(),
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
