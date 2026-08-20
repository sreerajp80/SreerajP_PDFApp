import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/printer/data/pdf_builder_service.dart';
import 'package:pdfapp/features/printer/data/printer_channel.dart';

/// Sends PDFs to the Android print dialog (Phase 6, step 2).
///
/// A page range is printed by first writing a range-only copy with PdfBox and
/// handing *that* to the spooler. Letting the spooler cut the range itself would
/// mean re-cutting the document inside the print adapter, which is fiddly and
/// easy to get subtly wrong; slicing up front reuses the tested, copy-on-write
/// page-op path.
class PrintService {
  PrintService(this._channel, this._pageOps, this._builder);

  final PrinterChannel _channel;
  final PageOpsService _pageOps;
  final PdfBuilderService _builder;

  /// True when this device can print at all.
  Future<bool> isAvailable() => _channel.isPrintingAvailable();

  /// Prints the whole PDF at [path]. [jobName] shows in the print queue.
  Future<void> printDocument(String path, String jobName) =>
      _channel.printPdf(path, jobName);

  /// Prints pages [from]..[to] (1-based, inclusive) of the PDF at [path].
  Future<void> printRange(
    String path,
    String jobName, {
    required int from,
    required int to,
    String? password,
  }) async {
    final pages = [
      for (var page = from; page <= to; page++) {'page': page, 'rotation': 0},
    ];
    final rangeCopy = await _pageOps.organize(path, pages, password: password);
    await _channel.printPdf(rangeCopy, jobName);
  }

  /// Builds a PDF from [text] and prints that.
  /// Throws [PdfUnsupportedTextException] for letters the built-in fonts lack.
  Future<void> printText(String text, String jobName) async {
    final path = await _builder.fromText(
      IncomingText(text: text, suggestedName: jobName),
    );
    await _channel.printPdf(path, jobName);
  }

  /// Generates an N-Up imposition PDF and prints that.
  Future<void> printNUp(
    String path,
    String jobName, {
    String? password,
    int gridCount = 4,
    String sheetSize = 'a4',
    String orientation = 'auto',
    bool addBorders = true,
    double margin = 12.0,
  }) async {
    final nupPath = await _pageOps.generateNUp(
      path,
      password: password,
      gridCount: gridCount,
      sheetSize: sheetSize,
      orientation: orientation,
      addBorders: addBorders,
      margin: margin,
    );
    await _channel.printPdf(nupPath, jobName);
  }
}
