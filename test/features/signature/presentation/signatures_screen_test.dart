import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/signature_channel.dart';
import 'package:pdfapp/features/signature/data/eutl_trust_list.dart';
import 'package:pdfapp/features/signature/data/signature_repository.dart';
import 'package:pdfapp/features/signature/data/trust_store_dao.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:pdfapp/features/signature/presentation/providers.dart';
import 'package:pdfapp/features/signature/presentation/signatures_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class _FakeDatabaseExecutor implements DatabaseExecutor {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    throw FlutterError('missing asset');
  }
}

class _FakeSignatureRepository extends SignatureRepository {
  _FakeSignatureRepository()
    : super(
        channel: SignatureChannel(method: const MethodChannel('fake')),
        trustStore: TrustStoreDao(_FakeDatabaseExecutor()),
        bundledList: EutlTrustList(bundle: _FakeBundle()),
      );

  final List<CertificateInfo> trusted = [];

  @override
  Future<void> trust(CertificateInfo certificate) async {
    trusted.add(certificate);
  }
}

class _FakeSignatureVerdictsNotifier extends SignatureVerdictsNotifier {
  _FakeSignatureVerdictsNotifier(
    this._verdicts, {
    this.error,
    this.loading = false,
  });

  final List<SignatureVerdict> _verdicts;
  final Object? error;
  final bool loading;

  @override
  Future<List<SignatureVerdict>> build(String arg) async {
    if (loading) {
      return Completer<List<SignatureVerdict>>().future;
    }
    final err = error;
    if (err != null) {
      throw err;
    }
    return _verdicts;
  }

  @override
  Future<void> refresh() async {}
}

void main() {
  const path = 'test.pdf';

  CertificateInfo cert() => CertificateInfo(
    sha256: 'aa',
    subject: 'CN=Jane',
    issuer: 'CN=CA',
    serial: '01',
    notBefore: DateTime(2020),
    notAfter: DateTime(2030),
    der: 'der_bytes',
  );

  SignatureVerdict verdict({
    SignatureStatus status = SignatureStatus.validNotTrusted,
    bool chainTrusted = false,
  }) => SignatureVerdict(
    status: status,
    signature: PdfSignature(
      integrity: SignatureIntegrity.valid,
      coversWholeFile: true,
      chainTrusted: chainTrusted,
      name: 'Jane',
      signedAt: DateTime(2024),
      chain: [cert()],
    ),
    notes: const [],
  );

  Future<void> pumpScreen(
    WidgetTester tester, {
    required _FakeSignatureRepository repository,
    List<SignatureVerdict>? verdicts,
    Object? error,
    bool loading = false,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signatureRepositoryProvider.overrideWithValue(repository),
          if (loading)
            signatureVerdictsProvider.overrideWith(
              () => _FakeSignatureVerdictsNotifier(const [], loading: true),
            )
          else if (error != null)
            signatureVerdictsProvider.overrideWith(
              () => _FakeSignatureVerdictsNotifier(const [], error: error),
            )
          else if (verdicts != null)
            signatureVerdictsProvider.overrideWith(
              () => _FakeSignatureVerdictsNotifier(verdicts),
            ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SignaturesScreen(path: path),
        ),
      ),
    );
    if (loading) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }

  testWidgets('shows loading state initially', (tester) async {
    final repository = _FakeSignatureRepository();
    await pumpScreen(tester, repository: repository, loading: true);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Checking signatures…'), findsOneWidget);
  });

  testWidgets('shows empty state when no signatures', (tester) async {
    final repository = _FakeSignatureRepository();
    await pumpScreen(tester, repository: repository, verdicts: const []);

    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    expect(find.text('This PDF is not signed.'), findsOneWidget);
  });

  testWidgets('shows error state when check fails', (tester) async {
    final repository = _FakeSignatureRepository();
    await pumpScreen(tester, repository: repository, error: 'Failed');

    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    expect(find.text('These signatures could not be checked.'), findsOneWidget);
    expect(
      find.text(
        'This does not mean the signatures are bad. It means the app could not read them, so it will not say either way.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows signature list and allows trusting cert', (tester) async {
    final repository = _FakeSignatureRepository();
    final v = verdict();

    await pumpScreen(tester, repository: repository, verdicts: [v]);

    expect(find.text('Jane'), findsOneWidget);
    expect(find.text('Signed, but signer unknown'), findsOneWidget);
    expect(find.text('Trust this certificate'), findsOneWidget);

    // Tap the button
    await tester.tap(find.text('Trust this certificate'));
    await tester.pumpAndSettle();

    // Verify trust confirmation dialog is shown
    expect(find.text('Trust this signer?'), findsOneWidget);
    expect(find.text('Trust'), findsOneWidget);

    await tester.tap(find.text('Trust'));
    await tester.pumpAndSettle();

    // Verify trust was recorded on repository
    expect(repository.trusted.length, 1);
    expect(repository.trusted.first.sha256, 'aa');
  });
}
