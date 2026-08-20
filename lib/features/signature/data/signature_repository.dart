import 'dart:io';

import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/signature_channel.dart';
import 'package:pdfapp/features/signature/data/eutl_trust_list.dart';
import 'package:pdfapp/features/signature/data/trust_store_dao.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/signature_trust_evaluator.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';

/// Ties the three parts of Phase 7 together: the native verifier, the trust
/// store, and the rules.
///
/// It answers one question — "what should we tell the user about this file's
/// signatures?" — by gathering the trust anchors, asking the native side for the
/// facts, and running them through [SignatureTrustEvaluator].
class SignatureRepository {
  SignatureRepository({
    required this.channel,
    required this.trustStore,
    required EutlTrustList bundledList,
    this.evaluator = const SignatureTrustEvaluator(),
  }) : _bundled = bundledList;

  final SignatureChannel channel;
  final TrustStoreDao trustStore;
  final EutlTrustList _bundled;
  final SignatureTrustEvaluator evaluator;

  /// Whether the viewer should offer the Signatures screen at all.
  Future<bool> hasSignatures(String cachePath, {String? password}) async =>
      await channel.countSignatures(cachePath, password: password) > 0;

  /// Every signature in the file, with the app's verdict on each.
  Future<List<SignatureVerdict>> verify(
    String cachePath, {
    String? password,
  }) async {
    final anchors = await _trustAnchors();
    final signatures = await channel.verifySignatures(
      cachePath,
      password: password,
      trustAnchors: anchors,
    );
    return evaluator.evaluateAll(signatures);
  }

  /// The user's own certificates plus the bundled list.
  ///
  /// The user's come first so that if the same certificate is in both, the one
  /// the user chose is the one that matches.
  Future<List<String>> _trustAnchors() async => [
    ...await trustStore.allDer(),
    ...await _bundled.certificates(),
  ];

  /// Reads a certificate file the user picked, so the UI can show what it is
  /// **before** anything is trusted.
  ///
  /// The size cap is the cheap guard: a certificate is a few kilobytes, so a
  /// huge file is either not a certificate or is trying to be a problem. Picked
  /// files are untrusted input like any other (security rules).
  Future<CertificateInfo> readCertificateFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw const InvalidCertificateException('That file is no longer there.');
    }
    if (await file.length() > AppConstants.maxCertificateBytes) {
      throw const InvalidCertificateException(
        'That file is too big to be a certificate.',
      );
    }
    return channel.readCertificate(path);
  }

  /// Records that the user trusts [certificate].
  ///
  /// Callers **must** have shown the certificate and had the user confirm it
  /// first. This is the one write that changes what the app will call trusted,
  /// and nothing else may reach it.
  Future<void> trust(CertificateInfo certificate) =>
      trustStore.add(certificate);

  /// The user withdrawing trust.
  Future<void> untrust(String sha256) => trustStore.remove(sha256);

  Future<List<CertificateInfo>> trustedCertificates() => trustStore.all();

  Future<bool> isTrusted(String sha256) => trustStore.contains(sha256);

  /// Exports a single [certificate] as a PEM file in the cache. Returns the file path.
  Future<String> exportCertificate(CertificateInfo certificate) async {
    final tempDir = await Directory.systemTemp.createTemp('cert_export');
    final safeName = certificate.commonName.replaceAll(
      RegExp(r'[^A-Za-z0-9._-]'),
      '_',
    );
    final file = File('${tempDir.path}/$safeName.crt');
    final pem = _formatPem(certificate.der);
    await file.writeAsString(pem);
    return file.path;
  }

  /// Exports all user-trusted certificates as a PEM bundle. Returns the file path.
  Future<String> exportAllCertificates() async {
    final certs = await trustedCertificates();
    final tempDir = await Directory.systemTemp.createTemp('cert_export');
    final file = File('${tempDir.path}/trusted_certificates_bundle.pem');
    final buffer = StringBuffer();
    for (final cert in certs) {
      buffer.writeln('# Subject: ${cert.subject}');
      buffer.writeln('# Issuer: ${cert.issuer}');
      buffer.writeln(_formatPem(cert.der));
      buffer.writeln();
    }
    await file.writeAsString(buffer.toString());
    return file.path;
  }

  String _formatPem(String derBase64) {
    final clean = derBase64.replaceAll(RegExp(r'\s+'), '');
    final chunks = <String>[];
    for (var i = 0; i < clean.length; i += 64) {
      final end = (i + 64 < clean.length) ? i + 64 : clean.length;
      chunks.add(clean.substring(i, end));
    }
    return '-----BEGIN CERTIFICATE-----\n${chunks.join('\n')}\n-----END CERTIFICATE-----';
  }
}
