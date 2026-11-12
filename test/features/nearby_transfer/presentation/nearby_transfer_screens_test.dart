import 'dart:io';

import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/nearby_transfer/data/lan_address_service.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/device_sync_screen.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/providers.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/receive_screen.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/share_settings_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/tooltip_checks.dart';

class _NoLan extends LanAddressService {
  const _NoLan();
  @override
  Future<InternetAddress?> findLanAddress() async => null;
}

void main() {
  late SharedPreferences prefs;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefThemeMode: 'light',
      AppConstants.prefAppLocale: 'ml',
    });
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        lanAddressServiceProvider.overrideWithValue(const _NoLan()),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> pump(WidgetTester tester, Widget home) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expectAllIconButtonsHaveTooltips(tester);
  }

  testWidgets('hub shows share and receive options', (tester) async {
    await pump(tester, const DeviceSyncScreen());
    expect(find.text('Device sync'), findsOneWidget);
    expect(find.text('Share my settings'), findsOneWidget);
    expect(find.text('Receive'), findsOneWidget);
  });

  testWidgets('share screen shows a settings QR code by default', (
    tester,
  ) async {
    await pump(tester, const ShareSettingsScreen());
    expect(find.byType(QrImageView), findsOneWidget);
    final qr = tester.widget<QrImageView>(find.byType(QrImageView));
    expect(qr, isNotNull);
    final state = container.read(shareSettingsControllerProvider);
    final text = (state as ShareShowingCode).qrText;
    final parsed = ScannedCode.parse(text) as SettingsCode;
    expect(parsed.snapshot[SyncedSetting.themeMode], 'light');
  });

  testWidgets('WiFi mode with no WiFi says so instead of failing quietly', (
    tester,
  ) async {
    await pump(tester, const ShareSettingsScreen());
    await tester.tap(find.text('WiFi'));
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsNothing);
    expect(find.textContaining('not on a WiFi network'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('receive: review lists changes and Apply updates the app', (
    tester,
  ) async {
    const incoming = SettingsSnapshot({
      SyncedSetting.themeMode: 'dark',
      SyncedSetting.appLocale: 'ml',
      SyncedSetting.ttsPitch: 1.5,
    });
    await pump(tester, const ReceiveScreen(code: SettingsCode(incoming)));
    expect(find.text('2 settings will change:'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('Voice Pitch'), findsOneWidget);
    // The language is already Malayalam here, so it is not listed.
    expect(find.text('Language'), findsNothing);

    // Nothing changes before the user taps Apply.
    expect(prefs.getString(AppConstants.prefThemeMode), 'light');

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(find.text('Settings applied.'), findsOneWidget);
    expect(prefs.getString(AppConstants.prefThemeMode), 'dark');
    expect(prefs.getDouble(AppConstants.prefTtsPitch), 1.5);
    // The provider was refreshed, so the app shows the new theme at once.
    expect(container.read(themeModeProvider), AppThemeMode.dark);
  });

  testWidgets('receive: Cancel changes nothing', (tester) async {
    await pump(tester, const Scaffold(body: _OpenReceive()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(prefs.getString(AppConstants.prefThemeMode), 'light');
  });

  testWidgets('receive: same settings says so', (tester) async {
    await pump(
      tester,
      const ReceiveScreen(
        code: SettingsCode(
          SettingsSnapshot({SyncedSetting.themeMode: 'light'}),
        ),
      ),
    );
    expect(find.textContaining('already the same'), findsOneWidget);
  });
}

class _OpenReceive extends StatelessWidget {
  const _OpenReceive();

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ReceiveScreen(
          code: SettingsCode(
            SettingsSnapshot({SyncedSetting.themeMode: 'sepia'}),
          ),
        ),
      ),
    ),
    child: const Text('open'),
  );
}
