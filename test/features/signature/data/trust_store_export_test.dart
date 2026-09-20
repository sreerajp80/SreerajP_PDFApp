import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/signature_channel.dart';
import 'package:pdfapp/features/signature/data/eutl_trust_list.dart';
import 'package:pdfapp/features/signature/data/signature_repository.dart';
import 'package:pdfapp/features/signature/data/trust_store_dao.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:sqflite/sqflite.dart';

class _FakeDatabaseExecutor implements DatabaseExecutor {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSignatureChannel extends SignatureChannel {
  @override
  Future<int> countSignatures(String path, {String? password}) async => 0;
}

class _FakeTrustStoreDao extends TrustStoreDao {
  _FakeTrustStoreDao() : super(_FakeDatabaseExecutor());

  final List<CertificateInfo> _certs = [];

  @override
  Future<List<CertificateInfo>> all() async => List.unmodifiable(_certs);

  @override
  Future<void> add(CertificateInfo cert, {DateTime? addedAt}) async {
    _certs.add(cert);
  }
}

class _FakeEutlTrustList extends EutlTrustList {
  @override
  Future<List<String>> certificates() async => [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SignatureRepository Export', () {
    late SignatureRepository repository;
    late _FakeTrustStoreDao dao;

    setUp(() {
      dao = _FakeTrustStoreDao();
      repository = SignatureRepository(
        channel: _FakeSignatureChannel(),
        trustStore: dao,
        bundledList: _FakeEutlTrustList(),
      );
    });

    test('exportCertificate creates valid PEM formatted file', () async {
      final cert = CertificateInfo(
        sha256: 'abc123sha256',
        subject: 'CN=Test Signer, O=Enterprise, C=IN',
        issuer: 'CN=Test CA, O=Enterprise, C=IN',
        serial: '1001',
        notBefore: DateTime(2026),
        notAfter: DateTime(2030),
        der:
            'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0TestCertificateBase64DataString',
      );

      final path = await repository.exportCertificate(cert);
      final file = File(path);
      expect(await file.exists(), isTrue);

      final content = await file.readAsString();
      expect(content, startsWith('-----BEGIN CERTIFICATE-----'));
      expect(content.trim(), endsWith('-----END CERTIFICATE-----'));
      expect(
        content,
        contains(
          'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0TestCertificateBase\n64DataString',
        ),
      );

      await file.delete();
    });

    test(
      'exportAllCertificates creates bundle with all trusted certificates',
      () async {
        final cert1 = CertificateInfo(
          sha256: 'sha1',
          subject: 'CN=Signer One',
          issuer: 'CN=Signer One',
          serial: '1',
          notBefore: DateTime(2026),
          notAfter: DateTime(2030),
          der: 'Cert1DerData',
        );
        final cert2 = CertificateInfo(
          sha256: 'sha2',
          subject: 'CN=Signer Two',
          issuer: 'CN=Signer Two',
          serial: '2',
          notBefore: DateTime(2026),
          notAfter: DateTime(2030),
          der: 'Cert2DerData',
        );

        await dao.add(cert1);
        await dao.add(cert2);

        final path = await repository.exportAllCertificates();
        final file = File(path);
        expect(await file.exists(), isTrue);

        final content = await file.readAsString();
        expect(content, contains('Subject: CN=Signer One'));
        expect(content, contains('Subject: CN=Signer Two'));
        expect(content, contains('Cert1DerData'));
        expect(content, contains('Cert2DerData'));

        await file.delete();
      },
    );
  });
}
