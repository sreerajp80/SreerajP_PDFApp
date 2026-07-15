import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/viewer_error_view.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('shows the corrupt message', (tester) async {
    await tester.pumpWidget(
      wrap(const ViewerErrorView(kind: ViewerErrorKind.corrupt)),
    );
    await tester.pumpAndSettle();
    expect(find.text("Can't open this PDF"), findsOneWidget);
  });

  testWidgets('shows the empty message', (tester) async {
    await tester.pumpWidget(
      wrap(const ViewerErrorView(kind: ViewerErrorKind.empty)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nothing to show'), findsOneWidget);
  });

  testWidgets('shows the password message', (tester) async {
    await tester.pumpWidget(
      wrap(const ViewerErrorView(kind: ViewerErrorKind.password)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Locked PDF'), findsOneWidget);
  });

  testWidgets('retry button appears only when a callback is given', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        ViewerErrorView(
          kind: ViewerErrorKind.corrupt,
          onRetry: () => tapped = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = find.text('Try again');
    expect(button, findsOneWidget);
    await tester.tap(button);
    expect(tapped, isTrue);
  });

  testWidgets('no retry button without a callback', (tester) async {
    await tester.pumpWidget(
      wrap(const ViewerErrorView(kind: ViewerErrorKind.corrupt)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Try again'), findsNothing);
  });
}
