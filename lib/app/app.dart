import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/l10n/sa_material_localizations.dart';

/// Root widget: `MaterialApp.router` wired with theme, localization, and routes.
class PdfApp extends ConsumerWidget {
  const PdfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(themeModeProvider);
    final lightAccent = ref.watch(lightAccentProvider);
    final darkAccent = ref.watch(darkAccentProvider);
    final appFont = ref.watch(appFontProvider);
    final appTextScale = ref.watch(appTextScaleProvider);

    final theme = ResolvedTheme.of(
      selected,
      lightAccent: lightAccent,
      darkAccent: darkAccent,
      fontFamily: appFont.family,
    );

    final appLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).titleApp,
      locale: appLocale,
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: theme.mode,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(appTextScale.scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: appRouter,
      // Sanskrit fallbacks first so they win for `sa` (engineering standard
      // §8.3.1). Since Flutter 3.47 `GlobalMaterialLocalizations.delegates`
      // (from material_ui) covers Material, Cupertino and Widgets.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        SaMaterialLocalizationsDelegate(),
        SaCupertinoLocalizationsDelegate(),
        SaWidgetsLocalizationsDelegate(),
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
