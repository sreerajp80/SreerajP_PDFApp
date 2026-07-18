import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/signature/data/trust_store_dao.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late TrustStoreDao dao;

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    dao = TrustStoreDao(await appDb.open());
  });

  tearDown(() => appDb.close());

  CertificateInfo cert({
    String sha256 = 'aa11',
    String subject = 'CN=Jane Doe, O=Example Ltd',
    String der = 'ZGVy',
  }) => CertificateInfo(
    sha256: sha256,
    subject: subject,
    issuer: 'CN=Example CA',
    serial: '01',
    notBefore: DateTime(2020),
    notAfter: DateTime(2030),
    der: der,
  );

  test('a certificate round-trips through the store', () async {
    await dao.add(cert());

    final all = await dao.all();
    expect(all.length, 1);
    expect(all.first.sha256, 'aa11');
    expect(all.first.subject, 'CN=Jane Doe, O=Example Ltd');
    expect(all.first.issuer, 'CN=Example CA');
    expect(all.first.der, 'ZGVy');
    expect(all.first.notBefore, DateTime(2020));
    expect(all.first.notAfter, DateTime(2030));
  });

  test('allDer returns the raw bytes the native verifier needs', () async {
    await dao.add(cert(sha256: 'aa', der: 'ZGVyMQ=='));
    await dao.add(cert(sha256: 'bb', der: 'ZGVyMg=='));

    expect(await dao.allDer(), containsAll(['ZGVyMQ==', 'ZGVyMg==']));
  });

  test('trusting the same certificate twice keeps one entry', () async {
    await dao.add(cert());
    await dao.add(cert());

    expect((await dao.all()).length, 1);
  });

  test('contains reports what is trusted', () async {
    await dao.add(cert());

    expect(await dao.contains('aa11'), isTrue);
    expect(await dao.contains('nothere'), isFalse);
  });

  test('removing withdraws trust', () async {
    await dao.add(cert());
    await dao.remove('aa11');

    expect(await dao.contains('aa11'), isFalse);
    expect(await dao.all(), isEmpty);
    // The anchors handed to the verifier must drop it too, or the signature
    // would stay green after the user said to stop trusting it.
    expect(await dao.allDer(), isEmpty);
  });

  test('newest trusted certificate is listed first', () async {
    await dao.add(cert(sha256: 'old'), addedAt: DateTime(2024));
    await dao.add(cert(sha256: 'new'), addedAt: DateTime(2026));

    expect((await dao.all()).map((c) => c.sha256).toList(), ['new', 'old']);
  });

  test('an empty store trusts nothing', () async {
    expect(await dao.allDer(), isEmpty);
  });
}
