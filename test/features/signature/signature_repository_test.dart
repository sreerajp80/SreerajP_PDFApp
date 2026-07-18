import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/signature_channel.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/signature/data/eutl_trust_list.dart';
import 'package:pdfapp/features/signature/data/signature_repository.dart';
import 'package:pdfapp/features/signature/data/trust_store_dao.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A stand-in for the native verifier.
///
/// The real cryptography is Kotlin and cannot run on the host, so these tests
/// cover the part that *is* testable: that the app gathers the right trust
/// anchors, hands them over, and turns the reply into an honest verdict.
class _FakeChannel {
  _FakeChannel(this.name);

  final String name;
  final List<MethodCall> calls = [];

  Object? Function(MethodCall call)? handler;

  SignatureChannel build() {
    final channel = MethodChannel(name);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return handler?.call(call);
        });
    return SignatureChannel(method: channel);
  }

  /// The trust anchors passed to the last verify call.
  List<String> get lastAnchors =>
      (calls.last.arguments['trustAnchors'] as List).cast<String>();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late TrustStoreDao dao;
  late _FakeChannel fake;

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    dao = TrustStoreDao(await appDb.open());
    fake = _FakeChannel(AppConstants.channelSignature);
  });

  tearDown(() => appDb.close());

  SignatureRepository build({String bundled = ''}) => SignatureRepository(
    channel: fake.build(),
    trustStore: dao,
    bundledList: EutlTrustList(bundle: _FakeBundle(bundled)),
  );

  CertificateInfo cert({String sha256 = 'aa', String der = 'ZGVy'}) =>
      CertificateInfo(
        sha256: sha256,
        subject: 'CN=Jane',
        issuer: 'CN=CA',
        serial: '01',
        notBefore: DateTime(2020),
        notAfter: DateTime(2030),
        der: der,
      );

  Map<String, Object?> nativeSignature({
    String integrity = 'valid',
    bool coversWholeFile = true,
    bool chainTrusted = true,
  }) => {
    'integrity': integrity,
    'coversWholeFile': coversWholeFile,
    'chainTrusted': chainTrusted,
    'revocationChecked': true,
    'revoked': false,
    'name': 'Jane',
    'signedAt': DateTime(2024).millisecondsSinceEpoch,
    'chain': [
      {
        'sha256': 'aa',
        'subject': 'CN=Jane',
        'issuer': 'CN=CA',
        'serial': '01',
        'notBefore': DateTime(2020).millisecondsSinceEpoch,
        'notAfter': DateTime(2030).millisecondsSinceEpoch,
        'der': 'ZGVy',
      },
    ],
  };

  group('trust anchors', () {
    test('the user\'s trusted certificates are sent to the verifier', () async {
      await dao.add(cert(der: 'AAAA'));
      await dao.add(cert(sha256: 'bb', der: 'BBBB'));
      fake.handler = (_) => [nativeSignature()];

      await build().verify('/tmp/a.pdf');

      expect(fake.lastAnchors, containsAll(['AAAA', 'BBBB']));
    });

    test('bundled certificates are sent alongside the user\'s', () async {
      await dao.add(cert(der: 'USERCERT'));
      fake.handler = (_) => [nativeSignature()];

      await build(
        bundled:
            '-----BEGIN CERTIFICATE-----\nBUNDLED\n-----END CERTIFICATE-----',
      ).verify('/tmp/a.pdf');

      expect(fake.lastAnchors, containsAll(['USERCERT', 'BUNDLED']));
    });

    test('with nothing trusted, no anchors are sent', () async {
      // Correct, not a bug: with no anchors nothing can come back trusted.
      fake.handler = (_) => [nativeSignature()];

      await build().verify('/tmp/a.pdf');

      expect(fake.lastAnchors, isEmpty);
    });
  });

  group('verify', () {
    test('a native reply becomes an evaluated verdict', () async {
      fake.handler = (_) => [nativeSignature()];

      final verdicts = await build().verify('/tmp/a.pdf');

      expect(verdicts.length, 1);
      expect(verdicts.first.status, SignatureStatus.trusted);
      expect(verdicts.first.signature.name, 'Jane');
    });

    test('the trust rules are applied, not the native chainTrusted alone', () {
      // The evaluator has the final say. Native says the chain is trusted, but
      // the signature covers only part of the file, so it must not go green.
      fake.handler = (_) => [nativeSignature(coversWholeFile: false)];

      expectLater(
        build().verify('/tmp/a.pdf').then((v) => v.first.status),
        completion(SignatureStatus.validNotTrusted),
      );
    });

    test('a locked PDF fails as a password problem, not a bad signature', () {
      fake.handler = (_) => throw PlatformException(code: 'password_required');

      expectLater(
        build().verify('/tmp/a.pdf'),
        throwsA(isA<PdfPasswordRequiredException>()),
      );
    });

    test('a native failure is typed, never a crash', () {
      fake.handler = (_) => throw PlatformException(code: 'signature_failed');

      expectLater(
        build().verify('/tmp/a.pdf'),
        throwsA(isA<SignatureCheckException>()),
      );
    });

    test('an unsigned PDF returns no verdicts', () async {
      fake.handler = (_) => <Object?>[];

      expect(await build().verify('/tmp/a.pdf'), isEmpty);
    });
  });

  group('hasSignatures', () {
    test('true when the document carries signatures', () async {
      fake.handler = (_) => 2;

      expect(await build().hasSignatures('/tmp/a.pdf'), isTrue);
    });

    test('false when it carries none', () async {
      fake.handler = (_) => 0;

      expect(await build().hasSignatures('/tmp/a.pdf'), isFalse);
    });

    test('false when the count fails, so the menu entry stays hidden', () async {
      // This only decides whether to *offer* the screen. A document that fails
      // here fails again inside the screen, where there is room to explain.
      fake.handler = (_) => throw PlatformException(code: 'signature_failed');

      expect(await build().hasSignatures('/tmp/a.pdf'), isFalse);
    });
  });

  group('readCertificateFile', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('certtest'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('a missing file fails clearly', () {
      expectLater(
        build().readCertificateFile('${dir.path}/nope.cer'),
        throwsA(isA<InvalidCertificateException>()),
      );
    });

    test('an oversized file is refused before it reaches the parser', () async {
      // A real certificate is a few kilobytes. Anything this big is either not
      // a certificate or is trying to be a problem — picked files are untrusted
      // input like any other.
      final file = File(
        '${dir.path}/big.cer',
      )..writeAsBytesSync(List.filled(AppConstants.maxCertificateBytes + 1, 0));

      await expectLater(
        build().readCertificateFile(file.path),
        throwsA(isA<InvalidCertificateException>()),
      );
      expect(fake.calls, isEmpty);
    });
  });

  group('trust store', () {
    test('trusting a certificate makes it an anchor next time', () async {
      fake.handler = (_) => [nativeSignature()];
      final repository = build();

      await repository.verify('/tmp/a.pdf');
      expect(fake.lastAnchors, isEmpty);

      await repository.trust(cert(der: 'NEWLYTRUSTED'));
      await repository.verify('/tmp/a.pdf');

      expect(fake.lastAnchors, ['NEWLYTRUSTED']);
    });

    test('untrusting removes it from the anchors', () async {
      fake.handler = (_) => [nativeSignature()];
      final repository = build();
      await repository.trust(cert(der: 'GONE'));

      await repository.untrust('aa');
      await repository.verify('/tmp/a.pdf');

      expect(fake.lastAnchors, isEmpty);
      expect(await repository.isTrusted('aa'), isFalse);
    });
  });
}

/// Serves a fixed string as the bundled certificate asset.
class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.contents);

  final String contents;

  @override
  Future<ByteData> load(String key) async {
    if (contents.isEmpty) throw FlutterError('missing asset');
    return ByteData.sublistView(Uint8List.fromList(contents.codeUnits));
  }
}
