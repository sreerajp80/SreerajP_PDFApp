import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// The user-facing name of a synced setting. Reuses the names the settings
/// screens already show, so the review list matches what the user knows.
String syncedSettingName(AppLocalizations l10n, SyncedSetting setting) =>
    switch (setting) {
      SyncedSetting.themeMode => l10n.titleThemeMode,
      SyncedSetting.accentLight => l10n.labelSyncAccentLight,
      SyncedSetting.accentDark => l10n.labelSyncAccentDark,
      SyncedSetting.appFont => l10n.labelTypographyFont,
      SyncedSetting.textScale => l10n.labelTypographyTextSize,
      SyncedSetting.appLocale => l10n.titleLanguage,
      SyncedSetting.rememberReadingPosition => l10n.titleSaveLastPosition,
      SyncedSetting.showReadingEstimates => l10n.descReadingTimeEstimatesToggle,
      SyncedSetting.defaultPageLayout => l10n.titleDefaultPageLayout,
      SyncedSetting.showPageIndicator => l10n.titleShowPageIndicator,
      SyncedSetting.pdfInvertColors => l10n.titleInvertColors,
      SyncedSetting.doubleTapZoom => l10n.titleDoubleTapZoom,
      SyncedSetting.defaultPaperSize => l10n.titleDefaultPaperSize,
      SyncedSetting.defaultPrintColorMode => l10n.titleDefaultColorMode,
      SyncedSetting.defaultPrintOrientation => l10n.titleDefaultOrientation,
      SyncedSetting.ttsSpeechRate => l10n.titleTtsSpeechRate,
      SyncedSetting.ttsPitch => l10n.titleTtsPitch,
      SyncedSetting.ttsSentencePause => l10n.titleTtsSentencePause,
      SyncedSetting.ttsAutoScroll => l10n.titleTtsAutoScroll,
      SyncedSetting.rememberRecentFiles => l10n.titleRememberRecentFiles,
      SyncedSetting.autoVerifySignatures => l10n.titleAutoVerifySignatures,
    };

String transferFailureMessage(AppLocalizations l10n, TransferFailure reason) =>
    switch (reason) {
      TransferFailure.unreachable => l10n.errorTransferUnreachable,
      TransferFailure.timedOut => l10n.errorTransferTimedOut,
      TransferFailure.wrongCode => l10n.errorTransferWrongCode,
      TransferFailure.badData => l10n.errorTransferBadData,
      TransferFailure.unsupportedVersion =>
        l10n.errorTransferUnsupportedVersion,
      TransferFailure.connectionLost => l10n.errorTransferConnectionLost,
      TransferFailure.cannotSave => l10n.errorTransferCannotSave,
    };

String rejectReasonMessage(AppLocalizations l10n, RejectReason reason) =>
    switch (reason) {
      RejectReason.notFolio => l10n.errorCodeNotFolio,
      RejectReason.damaged => l10n.errorCodeDamaged,
      RejectReason.newerVersion => l10n.errorCodeNewerVersion,
      RejectReason.unsafeAddress => l10n.errorCodeUnsafeAddress,
    };
