import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/files/output_file_name.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_repository.dart';
import 'package:pdfapp/features/sign_document/data/signature_image_codec.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/domain/signature_image_tools.dart';
import 'package:pdfapp/features/sign_document/domain/signature_placement.dart';

/// Signs a PDF with a saved signature picture, and imports pictures.
///
/// Signing is **copy-on-write**: the signed PDF is a new file in the app cache;
/// the source file is never changed.
class SignDocumentService {
  SignDocumentService({
    required this.pdfBox,
    required this.openChannel,
    required this.repository,
    this.codec = const SignatureImageCodec(),
    Future<Directory> Function()? outputDir,
    DateTime Function()? clock,
  }) : _outputDir = outputDir ?? _defaultOutputDir,
       _clock = clock ?? DateTime.now;

  final PdfBoxChannel pdfBox;
  final OpenDocumentChannel openChannel;
  final SavedSignatureRepository repository;
  final SignatureImageCodec codec;
  final Future<Directory> Function() _outputDir;
  final DateTime Function() _clock;

  static Future<Directory> _defaultOutputDir() async {
    final temp = await getTemporaryDirectory();
    return Directory('${temp.path}/signed');
  }

  /// Writes a new PDF with [signature] drawn at every place in [placements],
  /// and returns its path. The new file is named after [displayName] (the
  /// original document's name, see [OutputFileName]). Throws
  /// [ValidationException] when there is nothing to place, and the usual PDF
  /// exceptions (for example [PdfPasswordRequiredException]) from the native
  /// side.
  Future<String> sign({
    required String sourcePath,
    required String displayName,
    required SavedSignature signature,
    required List<SignaturePlacement> placements,
    String? password,
  }) async {
    if (placements.isEmpty) {
      throw const ValidationException('placements', 'Nothing to place.');
    }
    final dir = await _outputDir();
    if (!await dir.exists()) await dir.create(recursive: true);
    final out = await OutputFileName.uniquePath(
      dir,
      displayName,
      _clock(),
      action: 'signed',
    );
    final imagePath = await repository.pathOf(signature);
    return pdfBox.stampImages(sourcePath, out, [
      for (final p in placements) p.toPlatformMap(imagePath),
    ], password: password);
  }

  /// Lets the user pick a picture through the system picker and decodes it.
  ///
  /// Returns null when the user cancels. The picker's cache copy is always
  /// deleted afterwards. Throws [ImageReadException] for a file that is not a
  /// usable picture.
  Future<RgbaImage?> pickAndDecodeImage() async {
    final path = await openChannel.pickImage();
    if (path == null) return null;
    try {
      return await codec.decodeFile(path);
    } finally {
      try {
        final copy = File(path);
        if (await copy.exists()) await copy.delete();
      } on FileSystemException {
        // Best effort: the cache is cleared by the app and the system anyway.
      }
    }
  }

  /// Makes an imported picture ready to save: optionally turns light paper
  /// see-through, then trims the empty edges. Returns null when nothing is
  /// left (for example a blank photo).
  static RgbaImage? prepareImported(
    RgbaImage image, {
    required bool removeBackground,
  }) {
    final source = removeBackground
        ? SignatureImageTools.removeLightBackground(image)
        : image;
    final bounds = SignatureImageTools.opaqueBounds(source);
    if (bounds == null) return null;
    return SignatureImageTools.crop(source, bounds, padding: 4);
  }

  /// Encodes [image] as PNG and stores it in the saved signatures list.
  Future<LoadedSignature> saveSignature(
    RgbaImage image, {
    required SignatureSource source,
  }) async {
    final png = await codec.encodePng(image);
    return repository.savePng(
      png,
      widthPx: image.width,
      heightPx: image.height,
      source: source,
    );
  }
}
