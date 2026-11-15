import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/domain/signature_image_tools.dart';
import 'package:pdfapp/features/sign_document/presentation/my_signatures_sheet.dart';
import 'package:pdfapp/features/sign_document/presentation/providers.dart';
import 'package:pdfapp/features/sign_document/presentation/sign_placement_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfrx/pdfrx.dart';

/// Starts "Sign" for the open PDF: choose (or draw / import) a signature, then
/// place it. Called from the viewer menu.
Future<void> startSignFlow(
  BuildContext context,
  WidgetRef ref, {
  required String path,
  required String displayName,
  required PdfDocument document,
  required int currentPage,
}) async {
  final choice = await showModalBottomSheet<SignFlowChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const MySignaturesSheet(),
  );
  if (choice == null || !context.mounted) return;

  final LoadedSignature? signature;
  if (choice is UseSavedSignature) {
    signature = choice.signature;
  } else if (choice is DrawNewSignature) {
    signature = await context.pushNamed<LoadedSignature>(
      AppRoute.signaturePad.name,
    );
  } else {
    signature = await _importImage(context, ref);
  }
  if (signature == null || !context.mounted) return;
  if (choice is! UseSavedSignature) ref.invalidate(mySignaturesProvider);

  await context.pushNamed<void>(
    AppRoute.signPlacement.name,
    extra: SignRequest(
      path: path,
      displayName: displayName,
      document: document,
      initialPage: currentPage,
      signature: signature,
    ),
  );
}

Future<LoadedSignature?> _importImage(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context);
  final RgbaImage? image;
  try {
    image = await ref.read(signDocumentServiceProvider).pickAndDecodeImage();
  } on ImageReadException catch (e) {
    AppLogger.warning('sign_flow: picked picture not usable', error: e);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorSignatureImage)));
    }
    return null;
  } catch (e, st) {
    AppLogger.error('sign_flow: image pick failed', error: e, stackTrace: st);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorOpFailed)));
    }
    return null;
  }
  if (image == null || !context.mounted) return null;
  return context.pushNamed<LoadedSignature>(
    AppRoute.importSignature.name,
    extra: image,
  );
}
