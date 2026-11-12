import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/nearby_transfer/data/file_transfer_services.dart';
import 'package:pdfapp/features/nearby_transfer/data/lan_address_service.dart';
import 'package:pdfapp/features/nearby_transfer/data/settings_sync_service.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_guest.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_host.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/send_item.dart';
import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';

final lanAddressServiceProvider = Provider<LanAddressService>(
  (ref) => const LanAddressService(),
);

final settingsSyncServiceProvider = Provider<SettingsSyncService>(
  (ref) => SettingsSyncService(ref.watch(sharedPreferencesProvider)),
);

final receiveFolderServiceProvider = Provider<ReceiveFolderService>(
  (ref) => ReceiveFolderService(
    ref.watch(sharedPreferencesProvider),
    ref.watch(openDocumentChannelProvider),
  ),
);

final outgoingFilesServiceProvider = Provider<OutgoingFilesService>(
  (ref) => OutgoingFilesService(ref.watch(openDocumentChannelProvider)),
);

final receivedFilesStoreProvider = Provider<ReceivedFilesStore>(
  (ref) => ReceivedFilesStore(
    ref.watch(openDocumentChannelProvider),
    ref.watch(recentFilesDaoProvider),
    ref.watch(sharedPreferencesProvider),
  ),
);

// ---------------------------------------------------------------------------
// Sharing side (the phone that has the settings and shows the code).
// ---------------------------------------------------------------------------

/// How the settings travel.
enum ShareMode {
  /// The settings are inside the QR code. No network at all.
  qrOnly,

  /// The QR code pairs the phones; the settings go over local WiFi.
  wifi,
}

sealed class ShareState {
  const ShareState(this.mode);
  final ShareMode mode;
}

final class SharePreparing extends ShareState {
  const SharePreparing(super.mode);
}

/// Showing a code. [expiresAt] is set for a WiFi code only.
final class ShareShowingCode extends ShareState {
  const ShareShowingCode(super.mode, this.qrText, {this.expiresAt});
  final String qrText;
  final DateTime? expiresAt;
}

/// This phone has no WiFi or hotspot address, so WiFi mode cannot start.
final class ShareNoNetwork extends ShareState {
  const ShareNoNetwork() : super(ShareMode.wifi);
}

final class ShareGuestConnected extends ShareState {
  const ShareGuestConnected(this.address) : super(ShareMode.wifi);
  final String address;
}

final class ShareFinished extends ShareState {
  const ShareFinished({required this.accepted}) : super(ShareMode.wifi);
  final bool accepted;
}

final class ShareFailed extends ShareState {
  const ShareFailed(this.reason) : super(ShareMode.wifi);
  final TransferFailure reason;
}

/// The WiFi session was stopped because the app went to the background.
final class ShareStopped extends ShareState {
  const ShareStopped() : super(ShareMode.wifi);
}

/// Runs the sharing screen. Leaving the screen disposes this controller,
/// which ends any WiFi session at once.
class ShareSettingsController extends Notifier<ShareState> {
  TransferHost? _host;
  StreamSubscription<HostEvent>? _events;

  @override
  ShareState build() {
    ref.onDispose(_endSession);
    return _qrOnlyState();
  }

  ShareState _qrOnlyState() => ShareShowingCode(
    ShareMode.qrOnly,
    ref.read(settingsSyncServiceProvider).readCurrent().toQrText(),
  );

  Future<void> select(ShareMode mode) async {
    await _endSession();
    if (mode == ShareMode.qrOnly) {
      state = _qrOnlyState();
      return;
    }
    state = const SharePreparing(ShareMode.wifi);
    final address = await ref.read(lanAddressServiceProvider).findLanAddress();
    if (!ref.mounted || state is! SharePreparing) return;
    if (address == null) {
      state = const ShareNoNetwork();
      return;
    }
    try {
      final host = await TransferHost.start(
        bindAddress: address,
        offer: SettingsOffer(
          ref.read(settingsSyncServiceProvider).readCurrent(),
        ),
      );
      if (!ref.mounted || state is! SharePreparing) {
        await host.close();
        return;
      }
      _host = host;
      _events = host.events.listen(_onHostEvent);
      state = ShareShowingCode(
        ShareMode.wifi,
        host.pairing.toQrText(),
        expiresAt: host.expiresAt,
      );
    } on TransferException catch (e) {
      if (ref.mounted) state = ShareFailed(e.reason);
    }
  }

  void _onHostEvent(HostEvent event) {
    if (!ref.mounted) return;
    state = switch (event) {
      HostGuestConnected(:final address) => ShareGuestConnected(address),
      HostFinished(:final accepted) => ShareFinished(accepted: accepted),
      HostFailed(:final reason) => ShareFailed(reason),
      HostSending() => state, // settings have no file content
    };
  }

  /// Called when the app goes to the background: a WiFi session never stays
  /// open while the user is not looking at it.
  Future<void> stopForBackground() async {
    if (_host == null) return;
    await _endSession();
    if (ref.mounted &&
        state.mode == ShareMode.wifi &&
        state is! ShareFinished) {
      state = const ShareStopped();
    }
  }

  Future<void> _endSession() async {
    final host = _host;
    _host = null;
    await _events?.cancel();
    _events = null;
    await host?.close();
  }
}

final shareSettingsControllerProvider =
    NotifierProvider.autoDispose<ShareSettingsController, ShareState>(
      ShareSettingsController.new,
    );

// ---------------------------------------------------------------------------
// Receiving side (the phone that scanned the code).
// ---------------------------------------------------------------------------

sealed class ReceiveState {
  const ReceiveState();
}

final class ReceiveConnecting extends ReceiveState {
  const ReceiveConnecting();
}

/// Waiting for the user to look at what will change and confirm.
final class ReceiveReviewing extends ReceiveState {
  const ReceiveReviewing(this.snapshot, this.changes);
  final SettingsSnapshot snapshot;
  final List<SyncedSetting> changes;
}

final class ReceiveApplying extends ReceiveState {
  const ReceiveApplying();
}

final class ReceiveDone extends ReceiveState {
  const ReceiveDone({required this.applied});
  final bool applied;
}

final class ReceiveFailed extends ReceiveState {
  const ReceiveFailed(this.reason);
  final TransferFailure reason;
}

/// PDFs are on offer: the user sees the list and where they will be saved.
///
/// [folder] is the remembered folder, or null when none is chosen yet.
/// [folderLost] is true when one was chosen but can no longer be used.
final class ReceiveReviewingFiles extends ReceiveState {
  const ReceiveReviewingFiles(
    this.offer, {
    this.folder,
    this.folderLost = false,
    this.choosingFolder = false,
  });
  final FileOffer offer;
  final ReceiveFolder? folder;
  final bool folderLost;
  final bool choosingFolder;

  ReceiveReviewingFiles copyWith({
    ReceiveFolder? folder,
    bool? folderLost,
    bool? choosingFolder,
  }) => ReceiveReviewingFiles(
    offer,
    folder: folder ?? this.folder,
    folderLost: folderLost ?? this.folderLost,
    choosingFolder: choosingFolder ?? this.choosingFolder,
  );
}

/// File content is arriving.
final class ReceiveTransferring extends ReceiveState {
  const ReceiveTransferring(this.receivedBytes, this.totalBytes);
  final int receivedBytes;
  final int totalBytes;
}

/// Copying the checked files into the chosen folder.
final class ReceiveSaving extends ReceiveState {
  const ReceiveSaving();
}

/// Files are saved. [failed] lists files that failed a check or could not
/// be written.
final class ReceiveFilesDone extends ReceiveState {
  const ReceiveFilesDone({
    required this.saved,
    required this.failed,
    required this.folderName,
  });
  final List<String> saved;
  final List<String> failed;
  final String folderName;
}

class ReceiveController extends Notifier<ReceiveState> {
  TransferGuest? _guest;
  bool _started = false;

  @override
  ReceiveState build() {
    ref.onDispose(() => unawaited(_guest?.close()));
    return const ReceiveConnecting();
  }

  /// Starts from a scanned code. Safe to call more than once; only the first
  /// call counts.
  Future<void> begin(ScannedCode code) async {
    if (_started) return;
    _started = true;
    switch (code) {
      case SettingsCode(:final snapshot):
        _review(snapshot);
      case WifiCode(:final pairing):
        await _receiveOverWifi(pairing);
      case RejectedCode():
        state = const ReceiveFailed(TransferFailure.badData);
    }
  }

  Future<void> _receiveOverWifi(WifiPairing pairing) async {
    try {
      final guest = await TransferGuest.connect(pairing);
      if (!ref.mounted) {
        await guest.close();
        return;
      }
      _guest = guest;
      final offer = await guest.receiveOffer();
      if (!ref.mounted) return;
      switch (offer) {
        case SettingsOffer(:final snapshot):
          _review(snapshot);
        case FileOffer():
          state = ReceiveReviewingFiles(offer);
          final status = await ref.read(receiveFolderServiceProvider).current();
          final now = state;
          if (ref.mounted &&
              now is ReceiveReviewingFiles &&
              now.folder == null) {
            state = now.copyWith(
              folder: status.folder,
              folderLost: status.lost,
            );
          }
      }
    } on TransferException catch (e) {
      AppLogger.warning('Device sync: receiving failed (${e.reason.name}).');
      await _closeGuest();
      if (ref.mounted) state = ReceiveFailed(e.reason);
    }
  }

  void _review(SettingsSnapshot incoming) {
    final current = ref.read(settingsSyncServiceProvider).readCurrent();
    state = ReceiveReviewing(incoming, incoming.changesFrom(current));
  }

  Future<void> apply() async {
    final reviewing = state;
    if (reviewing is! ReceiveReviewing) return;
    state = const ReceiveApplying();
    await ref.read(settingsSyncServiceProvider).apply(reviewing.snapshot);
    _refreshSettingsProviders();
    await _answer(accepted: true);
    if (ref.mounted) state = const ReceiveDone(applied: true);
  }

  /// Opens the system folder picker. Cancelling keeps the current folder.
  Future<void> chooseFolder() async {
    final reviewing = state;
    if (reviewing is! ReceiveReviewingFiles || reviewing.choosingFolder) return;
    state = reviewing.copyWith(choosingFolder: true);
    ReceiveFolder? picked;
    try {
      picked = await ref.read(receiveFolderServiceProvider).choose();
    } on AppException catch (e) {
      AppLogger.warning('Device sync: folder picker failed.', error: e);
    }
    final now = state;
    if (!ref.mounted || now is! ReceiveReviewingFiles) return;
    state = picked == null
        ? now.copyWith(choosingFolder: false)
        : ReceiveReviewingFiles(now.offer, folder: picked);
  }

  /// Accepts the files: asks for a folder first if none is ready, then
  /// receives, checks and saves them.
  Future<void> acceptFiles() async {
    var reviewing = state;
    if (reviewing is! ReceiveReviewingFiles) return;
    if (reviewing.folder == null) {
      await chooseFolder();
      reviewing = state;
      if (reviewing is! ReceiveReviewingFiles || reviewing.folder == null) {
        return; // still no folder: stay on the review screen
      }
    }
    final guest = _guest;
    if (guest == null) return;
    final folder = reviewing.folder!;
    final offer = reviewing.offer;
    state = ReceiveTransferring(0, offer.totalBytes);
    var lastShown = DateTime.fromMillisecondsSinceEpoch(0);
    try {
      await guest.answer(accepted: true);
      final cache = await ReceivedFilesStore.newCacheFolder();
      final received = await guest.receiveFiles(
        offer,
        cache,
        onProgress: (done, total) {
          final now = DateTime.now();
          if (!ref.mounted) return;
          if (done == total || now.difference(lastShown).inMilliseconds > 150) {
            lastShown = now;
            state = ReceiveTransferring(done, total);
          }
        },
      );
      await guest.sendResult(received: received.where((f) => f.ok).length);
      await _closeGuest();
      if (ref.mounted) state = const ReceiveSaving();
      final result = await ref
          .read(receivedFilesStoreProvider)
          .save(folder, received);
      try {
        await cache.delete(recursive: true);
      } on Object {
        // Startup cleanup removes it later.
      }
      if (ref.mounted) {
        unawaited(ref.read(recentFilesProvider.notifier).refresh());
        state = ReceiveFilesDone(
          saved: result.saved,
          failed: result.failed,
          folderName: folder.name,
        );
      }
    } on TransferException catch (e) {
      AppLogger.warning(
        'Device sync: receiving files failed (${e.reason.name}).',
      );
      await _closeGuest();
      if (ref.mounted) state = ReceiveFailed(e.reason);
    } on AppException catch (e) {
      AppLogger.warning('Device sync: saving received files failed.', error: e);
      await _closeGuest();
      if (ref.mounted) state = const ReceiveFailed(TransferFailure.cannotSave);
    }
  }

  Future<void> decline() async {
    await _answer(accepted: false);
    if (ref.mounted) state = const ReceiveDone(applied: false);
  }

  Future<void> _answer({required bool accepted}) async {
    final guest = _guest;
    if (guest == null) return;
    try {
      await guest.answer(accepted: accepted);
    } on TransferException {
      // The settings are already applied here; the other phone just will not
      // hear the answer. Not worth failing the whole step for.
    }
    await _closeGuest();
  }

  Future<void> _closeGuest() async {
    final guest = _guest;
    _guest = null;
    await guest?.close();
  }

  /// Makes every settings provider read shared_preferences again, so the new
  /// theme, language and other values show at once with no restart.
  void _refreshSettingsProviders() {
    ref
      ..invalidate(themeModeProvider)
      ..invalidate(lightAccentProvider)
      ..invalidate(darkAccentProvider)
      ..invalidate(appFontProvider)
      ..invalidate(appTextScaleProvider)
      ..invalidate(appLocaleProvider)
      ..invalidate(rememberReadingPositionProvider)
      ..invalidate(showReadingEstimatesProvider)
      ..invalidate(defaultPageLayoutProvider)
      ..invalidate(showPageIndicatorProvider)
      ..invalidate(pdfInvertColorsProvider)
      ..invalidate(doubleTapZoomProvider)
      ..invalidate(defaultPaperSizeProvider)
      ..invalidate(defaultPrintColorModeProvider)
      ..invalidate(defaultPrintOrientationProvider)
      ..invalidate(ttsSpeechRateProvider)
      ..invalidate(ttsPitchProvider)
      ..invalidate(ttsSentencePauseProvider)
      ..invalidate(ttsAutoScrollProvider)
      ..invalidate(rememberRecentFilesProvider)
      ..invalidate(autoVerifySignaturesProvider);
  }
}

final receiveControllerProvider =
    NotifierProvider.autoDispose<ReceiveController, ReceiveState>(
      ReceiveController.new,
    );

// ---------------------------------------------------------------------------
// Sending PDFs (the phone that has the files and shows the code).
// ---------------------------------------------------------------------------

sealed class SendState {
  const SendState();
}

/// Copying and checking the chosen files ([done] of [total]).
final class SendPreparing extends SendState {
  const SendPreparing(this.done, this.total);
  final int done;
  final int total;
}

/// None of the chosen files could be read.
final class SendNothingToSend extends SendState {
  const SendNothingToSend(this.skipped);
  final List<String> skipped;
}

final class SendNoNetwork extends SendState {
  const SendNoNetwork();
}

final class SendShowingCode extends SendState {
  const SendShowingCode({
    required this.qrText,
    required this.expiresAt,
    required this.fileCount,
    required this.skipped,
  });
  final String qrText;
  final DateTime expiresAt;
  final int fileCount;

  /// Files that could not be read and will not be sent.
  final List<String> skipped;
}

final class SendGuestConnected extends SendState {
  const SendGuestConnected(this.address);
  final String address;
}

final class SendTransferring extends SendState {
  const SendTransferring(this.sentBytes, this.totalBytes);
  final int sentBytes;
  final int totalBytes;
}

final class SendFinished extends SendState {
  const SendFinished({
    required this.accepted,
    required this.received,
    required this.fileCount,
  });
  final bool accepted;
  final int received;
  final int fileCount;
}

final class SendFailed extends SendState {
  const SendFailed(this.reason);
  final TransferFailure reason;
}

/// The session was stopped because the app went to the background.
final class SendStopped extends SendState {
  const SendStopped();
}

class SendFilesController extends Notifier<SendState> {
  TransferHost? _host;
  StreamSubscription<HostEvent>? _events;
  List<SendItem> _items = const [];
  int _fileCount = 0;

  @override
  SendState build() {
    ref.onDispose(_endSession);
    return const SendPreparing(0, 0);
  }

  /// Prepares the files and starts a WiFi session. Call again to retry.
  Future<void> start(List<SendItem> items) async {
    _items = items;
    await _endSession();
    state = SendPreparing(0, items.length);
    final prepared = await ref
        .read(outgoingFilesServiceProvider)
        .prepare(
          items,
          onProgress: (done, total) {
            if (ref.mounted) state = SendPreparing(done, total);
          },
        );
    if (!ref.mounted) return;
    if (prepared.ready.isEmpty) {
      state = SendNothingToSend(prepared.skipped);
      return;
    }
    final address = await ref.read(lanAddressServiceProvider).findLanAddress();
    if (!ref.mounted) return;
    if (address == null) {
      state = const SendNoNetwork();
      return;
    }
    try {
      final host = await TransferHost.start(
        bindAddress: address,
        offer: FileOffer([for (final f in prepared.ready) f.offered]),
        filePaths: [for (final f in prepared.ready) f.path],
      );
      if (!ref.mounted) {
        await host.close();
        return;
      }
      _host = host;
      _fileCount = prepared.ready.length;
      _events = host.events.listen(_onHostEvent);
      state = SendShowingCode(
        qrText: host.pairing.toQrText(),
        expiresAt: host.expiresAt,
        fileCount: _fileCount,
        skipped: prepared.skipped,
      );
    } on TransferException catch (e) {
      if (ref.mounted) state = SendFailed(e.reason);
    }
  }

  /// Starts again with the same files.
  Future<void> retry() => start(_items);

  void _onHostEvent(HostEvent event) {
    if (!ref.mounted) return;
    state = switch (event) {
      HostGuestConnected(:final address) => SendGuestConnected(address),
      HostSending(:final sentBytes, :final totalBytes) => SendTransferring(
        sentBytes,
        totalBytes,
      ),
      HostFinished(:final accepted, :final filesReceived) => SendFinished(
        accepted: accepted,
        received: filesReceived ?? 0,
        fileCount: _fileCount,
      ),
      HostFailed(:final reason) => SendFailed(reason),
    };
  }

  /// A WiFi session never stays open while the user is not looking at it.
  Future<void> stopForBackground() async {
    if (_host == null) return;
    await _endSession();
    if (ref.mounted && state is! SendFinished && state is! SendFailed) {
      state = const SendStopped();
    }
  }

  Future<void> _endSession() async {
    final host = _host;
    _host = null;
    await _events?.cancel();
    _events = null;
    await host?.close();
  }
}

final sendFilesControllerProvider =
    NotifierProvider.autoDispose<SendFilesController, SendState>(
      SendFilesController.new,
    );
