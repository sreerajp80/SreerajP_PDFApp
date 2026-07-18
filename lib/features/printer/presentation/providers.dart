import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/printer/data/pdf_builder_service.dart';
import 'package:pdfapp/features/printer/data/print_service.dart';
import 'package:pdfapp/features/printer/data/printer_channel.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';

/// Providers for the Phase 6 printer feature.

final printerChannelProvider = Provider<PrinterChannel>(
  (ref) => PrinterChannel(),
);

final pdfBuilderServiceProvider = Provider<PdfBuilderService>(
  (ref) => PdfBuilderService(
    ref.watch(pdfBoxChannelProvider),
    ref.watch(openDocumentChannelProvider),
  ),
);

final printServiceProvider = Provider<PrintService>(
  (ref) => PrintService(
    ref.watch(printerChannelProvider),
    ref.watch(pageOpsServiceProvider),
    ref.watch(pdfBuilderServiceProvider),
  ),
);

/// Whether this device can print. Drives the Print menu entry so it is never a
/// dead button (project rule 6).
final printingAvailableProvider = FutureProvider<bool>(
  (ref) => ref.watch(printServiceProvider).isAvailable(),
);
