import 'package:go_router/go_router.dart';
import 'package:pdfapp/features/about/presentation/about_screen.dart';
import 'package:pdfapp/features/settings/presentation/settings_screen.dart';
import 'package:pdfapp/features/viewer/domain/pdf_document_ref.dart';
import 'package:pdfapp/features/viewer/presentation/home_screen.dart';
import 'package:pdfapp/features/viewer/presentation/viewer_screen.dart';

/// Centralized route names (engineering standard §6.9). Use the enum name with
/// `context.goNamed` / `context.pushNamed` so paths stay in one place.
enum AppRoute { home, viewer, settings, about }

extension AppRoutePath on AppRoute {
  String get path => switch (this) {
    AppRoute.home => '/',
    AppRoute.viewer => '/viewer',
    AppRoute.settings => '/settings',
    AppRoute.about => '/about',
  };
}

/// The app's router. The Viewer route takes the [PdfDocumentRef] to open via
/// `extra` (Phase 1).
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
      name: AppRoute.about.name,
      path: AppRoute.about.path,
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
