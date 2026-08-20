import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:pdfapp/core/constants/app_constants.dart';

/// The bundled "globally trusted" signing certificates (Phase 7).
///
/// **What this is.** A read-only asset holding the EU Trusted Lists (EUTL)
/// certificates in PEM form. A signature whose chain reaches one of these is
/// trusted without the user adding anything.
///
/// **What it is not.** It is deliberately *not* the Android system CA store.
/// That store exists for TLS — for proving a website is who it says it is — and
/// using it to vouch for document signers would trust a completely different set
/// of people for a completely different purpose. `docs/security.md` calls
/// this out because it is an easy and serious mistake.
///
/// **Adobe's AATL is not bundled**, on purpose. It is distributed through
/// Adobe's own updater and its redistribution terms are not clearly open, so
/// project rule 1 ("check the licence before adding it") says no.
///
/// **This list goes stale.** The app is offline and never refreshes it, so it is
/// a convenience, not the backbone. The backbone is the user's own trust store:
/// the certificate they added because they actually know the signer.
class EutlTrustList {
  EutlTrustList({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  List<String>? _cached;

  /// The base64 DER of each bundled certificate.
  ///
  /// Loaded once and kept, since it never changes while the app runs. A missing
  /// or unreadable asset yields an empty list rather than throwing: no bundled
  /// list means nothing is globally trusted, which is a safe, honest state — the
  /// user can still trust certificates themselves.
  Future<List<String>> certificates() async {
    final cached = _cached;
    if (cached != null) return cached;
    try {
      final pem = await _bundle.loadString(AppConstants.eutlAssetPath);
      return _cached = parsePem(pem);
    } catch (_) {
      return _cached = const [];
    }
  }

  /// Pulls the base64 body out of each `-----BEGIN CERTIFICATE-----` block.
  ///
  /// Whitespace inside a block is dropped, so the result is what the native side
  /// can decode directly. Anything outside the markers (comments, provenance
  /// notes) is ignored, which is what lets the asset document itself.
  static List<String> parsePem(String pem) {
    final blocks = RegExp(
      r'-----BEGIN CERTIFICATE-----(.*?)-----END CERTIFICATE-----',
      dotAll: true,
    ).allMatches(pem);
    final out = <String>[];
    for (final block in blocks) {
      final body = block.group(1)?.replaceAll(RegExp(r'\s'), '') ?? '';
      if (body.isNotEmpty) out.add(body);
    }
    return out;
  }
}
