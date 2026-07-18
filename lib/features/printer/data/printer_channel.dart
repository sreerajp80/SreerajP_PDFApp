import 'package:flutter/services.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';

/// Dart side of the Android print bridge (Phase 6).
///
/// Hands a finished PDF to the system print dialog. Android owns everything from
/// there — printer choice, copies, paper, and its own "Save as PDF" printer — so
/// there is no job state to follow afterwards.
class PrinterChannel {
  PrinterChannel({MethodChannel? method})
    : _method = method ?? const MethodChannel(AppConstants.channelPrint);

  final MethodChannel _method;

  /// Opens the system print dialog for the PDF at [path]. [jobName] is what the
  /// user sees in the print queue.
  Future<void> printPdf(String path, String jobName) async {
    try {
      await _method.invokeMethod<void>('printPdf', {
        'path': path,
        'jobName': jobName,
      });
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PrintException('Printing is not available here.', cause: e);
    }
  }

  /// True when this device can print. Some Android builds ship without printing,
  /// and the menu entry must say so rather than open a dialog that never comes.
  Future<bool> isPrintingAvailable() async {
    try {
      final result = await _method.invokeMethod<bool>('isPrintingAvailable');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  AppException _mapException(PlatformException e) {
    return switch (e.code) {
      'print_unavailable' => PrintException(
        'This device cannot print.',
        cause: e,
      ),
      'file_not_found' => const PrintException(
        'The file to print could not be found.',
      ),
      _ => PrintException(e.message ?? 'Could not start printing.', cause: e),
    };
  }
}
