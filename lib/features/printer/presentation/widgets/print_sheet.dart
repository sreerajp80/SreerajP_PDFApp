import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/extraction/data/extraction_service.dart';
import 'package:pdfapp/features/printer/presentation/providers.dart';
import 'package:pdfapp/features/printer/presentation/widgets/print_range_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Opens the Phase 6 "Print" bottom sheet for the open document.
Future<void> showPrintSheet(
  BuildContext context, {
  required String path,
  required String jobName,
  required int pageCount,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) =>
        _PrintSheet(path: path, jobName: jobName, pageCount: pageCount),
  );
}

class _PrintSheet extends ConsumerWidget {
  const _PrintSheet({
    required this.path,
    required this.jobName,
    required this.pageCount,
  });

  final String path;
  final String jobName;
  final int pageCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(l10n.printTitle, style: theme.textTheme.titleLarge),
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: Text(l10n.printWholeAction),
            subtitle: Text(l10n.printWholeDescription),
            onTap: () => _printWhole(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.filter_none),
            title: Text(l10n.printRangeAction),
            subtitle: Text(l10n.printRangeDescription),
            onTap: () => _printRange(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.subject),
            title: Text(l10n.printTextAction),
            subtitle: Text(l10n.printTextDescription),
            onTap: () => _printText(context, ref),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _printWhole(BuildContext context, WidgetRef ref) async {
    final job = _Job.from(context);
    Navigator.of(context).pop();
    await _run(
      job,
      ref,
      () => ref.read(printServiceProvider).printDocument(path, jobName),
    );
  }

  Future<void> _printRange(BuildContext context, WidgetRef ref) async {
    final range = await showDialog<PrintRange>(
      context: context,
      builder: (_) => PrintRangeDialog(pageCount: pageCount),
    );
    if (range == null || !context.mounted) return;
    final job = _Job.from(context);
    Navigator.of(context).pop();
    await _run(
      job,
      ref,
      () => ref
          .read(printServiceProvider)
          .printRange(path, jobName, from: range.from, to: range.to),
      // Slicing the range writes a new copy first, which takes a moment.
      showProgress: true,
    );
  }

  Future<void> _printText(BuildContext context, WidgetRef ref) async {
    final job = _Job.from(context);
    Navigator.of(context).pop();
    await _run(job, ref, () async {
      final text = await ref
          .read(extractionServiceProvider)
          .extractText(path, startPage: 1, endPage: pageCount);
      if (text.trim().isEmpty) {
        // A scanned PDF has no text layer. Say so rather than print blank pages.
        throw PdfEmptyException(job.l10n.printNoText);
      }
      await ref.read(printServiceProvider).printText(text, jobName);
    }, showProgress: true);
  }

  /// Runs a print action, turning any failure into a friendly message.
  ///
  /// Everything it needs is captured in [job] before the sheet closes: the
  /// sheet's own `BuildContext` dies with it, so using it here would silently
  /// abandon the print. [showProgress] covers the actions that build a file
  /// first.
  Future<void> _run(
    _Job job,
    WidgetRef ref,
    Future<void> Function() run, {
    bool showProgress = false,
  }) async {
    if (!await _ensureAvailable(ref, job)) return;
    // The whole screen could have gone away while we asked.
    if (!job.navigator.mounted) return;

    var progressShown = false;
    if (showProgress) {
      progressShown = true;
      unawaited(
        showDialog<void>(
          context: job.navigator.context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(job.l10n.printPreparing),
              ],
            ),
          ),
        ),
      );
    }
    try {
      await run();
    } on PdfUnsupportedTextException {
      job.messenger.showSnackBar(
        SnackBar(content: Text(job.l10n.importUnsupportedTextDetail)),
      );
    } on AppException catch (e) {
      job.messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (progressShown) job.navigator.pop();
    }
  }

  /// Checks the device can print before promising a dialog that never comes.
  Future<bool> _ensureAvailable(WidgetRef ref, _Job job) async {
    final available = await ref.read(printServiceProvider).isAvailable();
    if (!available) {
      job.messenger.showSnackBar(
        SnackBar(content: Text(job.l10n.printUnavailable)),
      );
    }
    return available;
  }
}

/// The bits of the sheet's context a print action still needs after the sheet
/// itself has closed.
class _Job {
  const _Job(this.messenger, this.navigator, this.l10n);

  factory _Job.from(BuildContext context) => _Job(
    ScaffoldMessenger.of(context),
    // The root navigator outlives the sheet, so it can still host the progress
    // dialog and hand back a live context.
    Navigator.of(context, rootNavigator: true),
    AppLocalizations.of(context),
  );

  final ScaffoldMessengerState messenger;
  final NavigatorState navigator;
  final AppLocalizations l10n;
}
