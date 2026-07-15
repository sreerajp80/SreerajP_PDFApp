import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/core/platform/tts_channel.dart';
import 'package:pdfapp/features/reading/data/tts_engine.dart';
import 'package:pdfapp/features/reading/data/tts_service.dart';

/// The PdfBox-Android bridge (PDF data the renderer does not expose).
final pdfBoxChannelProvider = Provider<PdfBoxChannel>((ref) => PdfBoxChannel());

/// Document information for the PDF at a given cache path.
///
/// Keyed by cache path (a plain String) so the family compares cheaply. Errors
/// are left on the `AsyncValue` on purpose: a locked or unreadable PDF still has
/// file facts worth showing, so the sheet renders the failure as
/// "details unavailable" instead of hiding everything.
final pdfMetadataProvider = FutureProvider.family<PdfMetadata, String>(
  (ref, cachePath) => ref.watch(pdfBoxChannelProvider).readMetadata(cachePath),
);

/// The doors to installing a missing speech voice.
final ttsChannelProvider = Provider<TtsChannel>((ref) => TtsChannel());

/// The read-aloud module, shared by the reader and Settings.
///
/// App-wide on purpose: only one thing can speak at a time, and the Malayalam
/// setting has to mean the same thing in both places. It checks its voices once
/// on creation, so whoever asks first gets a real answer.
final ttsServiceProvider = ChangeNotifierProvider<TtsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final service = TtsService(
    engine: FlutterTtsEngine(),
    malayalamEnabled: prefs.getBool(AppConstants.prefMalayalamTts) ?? false,
    saveMalayalamEnabled: ({required enabled}) =>
        prefs.setBool(AppConstants.prefMalayalamTts, enabled),
  );
  unawaited(service.refreshVoices());
  return service;
});
