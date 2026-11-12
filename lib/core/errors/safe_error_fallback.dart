import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/theme/tokens.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Neutral widget shown in **release** builds when a widget fails to build
/// (wired via `ErrorWidget.builder` in `main()`) — engineering standard §11.1.
/// It shows no exception text and has no controls that could fail the same way.
class SafeErrorFallback extends StatelessWidget {
  const SafeErrorFallback({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter puts this widget where the failed one was, so it usually sits
    // under MaterialApp and gets the user's language. If it does not (the
    // failure was above the app's localizations), fall back to the template
    // language rather than failing again.
    final l10n =
        Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        lookupAppLocalizations(const Locale('en'));
    // Its own colors and direction, so it works even outside a MaterialApp.
    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: ColoredBox(
        color: AppTokens.errorFallbackBackground,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.spaceLg),
            child: Text(
              l10n.errorScreenFallback,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTokens.errorFallbackForeground,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
