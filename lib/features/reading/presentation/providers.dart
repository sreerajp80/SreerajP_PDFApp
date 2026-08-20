import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/core/platform/tts_channel.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';
import 'package:pdfapp/features/reading/data/reading_velocity_service.dart';
import 'package:pdfapp/features/reading/data/tts_engine.dart';
import 'package:pdfapp/features/reading/data/tts_service.dart';

/// The PdfBox-Android bridge (PDF data the renderer does not expose).
final pdfBoxChannelProvider = Provider<PdfBoxChannel>((ref) => PdfBoxChannel());

/// Document information for the PDF at a given cache path.
final pdfMetadataProvider = FutureProvider.family<PdfMetadata, String>(
  (ref, cachePath) => ref.watch(pdfBoxChannelProvider).readMetadata(cachePath),
);

/// The doors to installing a missing speech voice and managing notifications.
final ttsChannelProvider = Provider<TtsChannel>((ref) => TtsChannel());

/// The read-aloud module, shared by the reader and Settings.
final ttsServiceProvider = ChangeNotifierProvider<TtsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final channel = ref.watch(ttsChannelProvider);
  final service = TtsService(
    engine: FlutterTtsEngine(),
    ttsChannel: channel,
    malayalamEnabled: prefs.getBool(AppConstants.prefMalayalamTts) ?? false,
    saveMalayalamEnabled: ({required enabled}) =>
        prefs.setBool(AppConstants.prefMalayalamTts, enabled),
  );
  unawaited(service.refreshVoices());
  return service;
});

/// Reading velocity tracker provider for real-time speed & time calculation.
final readingVelocityProvider = ChangeNotifierProvider.autoDispose
    .family<ReadingVelocityService, PdfTextSource?>((ref, textSource) {
      return ReadingVelocityService(textSource: textSource);
    });
