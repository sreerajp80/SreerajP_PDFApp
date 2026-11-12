import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/settings/presentation/permissions_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

import '../../../helpers/tooltip_checks.dart';

void main() {
  testWidgets('renders all explicit and implicit capability items', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: PermissionsScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expectAllIconButtonsHaveTooltips(tester);

    expect(find.text('Permissions'), findsOneWidget);
    expect(find.text('CAPABILITIES'), findsOneWidget);
    expect(find.text('Scoped Storage (SAF)'), findsOneWidget);
    expect(find.text('Virtual printer (BIND_PRINT_SERVICE)'), findsOneWidget);
    expect(find.text('Secure File Provider'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Local WiFi only'), findsOneWidget);
    expect(find.text('PRIVACY & SYSTEM DECLARATIONS'), findsOneWidget);
    expect(find.text('Speech engine'), findsOneWidget);
    expect(find.text('Voice Data Installer'), findsOneWidget);
    expect(find.text('Store & web links'), findsOneWidget);
    expect(find.text('Process Text Action'), findsOneWidget);
    expect(find.text('Default PDF viewer'), findsOneWidget);
    expect(find.text('Receive shares'), findsOneWidget);
    expect(find.text('Android printing'), findsOneWidget);
    expect(find.text('PRIVACY & ZERO-PERMISSION GUARANTEES'), findsOneWidget);
    expect(find.text('No internet servers'), findsOneWidget);
    expect(find.text('No broad storage'), findsOneWidget);
  });
}
