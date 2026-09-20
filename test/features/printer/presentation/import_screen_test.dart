import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/printer/presentation/import_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Phase 6: the screen that turns shared content into a PDF. Every state must
/// say something honest — especially the one where the letters cannot be
/// written at all.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pdfBoxChannel = MethodChannel('in.sreerajp.pdfapp/pdfbox');
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    messenger.setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getTemporaryDirectory') {
        return Directory.systemTemp.path;
      }
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(pdfBoxChannel, null);
    messenger.setMockMethodCallHandler(pathProviderChannel, null);
  });

  Future<void> pumpImport(WidgetTester tester, IncomingContent content) async {
    // The screen does real work on open (cache clean-up, platform calls, file
    // writes) that the fake test clock cannot advance, so the first frames must
    // run in the real zone. A plain pumpAndSettle would spin on the progress
    // indicator for ever.
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ImportScreen(content: content),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
  }

  testWidgets('a built PDF from pictures offers to save it', (tester) async {
    messenger.setMockMethodCallHandler(pdfBoxChannel, (call) async {
      // Write a real file so the size line has something to read.
      final out = call.arguments['outputPath'] as String;
      await File(out).writeAsBytes(List.filled(2048, 0));
      return out;
    });

    await pumpImport(
      tester,
      const IncomingImages(
        paths: ['/a.jpg', '/b.jpg'],
        suggestedName: 'holiday',
      ),
    );

    expect(find.text('Your PDF is ready'), findsOneWidget);
    expect(find.text('Made from 2 pictures'), findsOneWidget);
    expect(find.text('Size: 2.0 KB'), findsOneWidget);
    expect(find.text('Save as PDF'), findsWidgets);
    expect(find.text('Share'), findsOneWidget);
  });

  testWidgets('one picture is described in the singular', (tester) async {
    messenger.setMockMethodCallHandler(pdfBoxChannel, (call) async {
      final out = call.arguments['outputPath'] as String;
      await File(out).writeAsBytes([1, 2, 3]);
      return out;
    });

    await pumpImport(
      tester,
      const IncomingImages(paths: ['/a.jpg'], suggestedName: 'shot'),
    );

    expect(find.text('Made from 1 picture'), findsOneWidget);
  });

  testWidgets('shared text says where the PDF came from', (tester) async {
    messenger.setMockMethodCallHandler(pdfBoxChannel, (call) async {
      final out = call.arguments['outputPath'] as String;
      await File(out).writeAsBytes([1]);
      return out;
    });

    await pumpImport(
      tester,
      const IncomingText(text: 'hello there', suggestedName: 'note'),
    );

    expect(find.text('Your PDF is ready'), findsOneWidget);
    expect(find.text('Made from the text you shared.'), findsOneWidget);
  });

  testWidgets('text in an unsupported script is explained, not failed', (
    tester,
  ) async {
    messenger.setMockMethodCallHandler(pdfBoxChannel, (call) async {
      throw PlatformException(code: 'unsupported_text');
    });

    await pumpImport(
      tester,
      const IncomingText(text: 'മലയാളം', suggestedName: 'note'),
    );

    expect(find.text('These letters cannot be saved yet'), findsOneWidget);
    expect(find.textContaining('Malayalam'), findsOneWidget);
    // Nothing was built, so there must be no save button to press. (The screen
    // title reads "Save as PDF" too, so look for the button itself.)
    expect(find.widgetWithText(FilledButton, 'Save as PDF'), findsNothing);
  });

  testWidgets('a build failure shows the reason', (tester) async {
    messenger.setMockMethodCallHandler(pdfBoxChannel, (call) async {
      throw PlatformException(code: 'op_failed', message: 'disk full');
    });

    await pumpImport(
      tester,
      const IncomingImages(paths: ['/a.jpg'], suggestedName: 'shot'),
    );

    expect(find.text('Could not make the PDF'), findsOneWidget);
    expect(find.textContaining('disk full'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Save as PDF'), findsNothing);
  });
}
