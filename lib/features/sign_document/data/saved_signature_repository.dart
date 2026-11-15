import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_dao.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';

/// The user's saved signature pictures.
///
/// Each picture is a PNG in the app's **private** files folder
/// (`my_signatures/`), never in the cache (the system may clear the cache) and
/// never in shared storage. The database row ([SavedSignatureDao]) holds only the
/// file name and size. This class is the only place that turns a file name into
/// a path.
///
/// A signature is personal data: nothing here logs its content or its path.
class SavedSignatureRepository {
  SavedSignatureRepository({
    required this.dao,
    Future<Directory> Function()? folder,
  }) : _folder = folder ?? _defaultFolder;

  final SavedSignatureDao dao;
  final Future<Directory> Function() _folder;

  static Future<Directory> _defaultFolder() async {
    final base = await getApplicationSupportDirectory();
    return Directory('${base.path}/${AppConstants.savedSignaturesFolder}');
  }

  Future<Directory> _ensureFolder() async {
    final dir = await _folder();
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// The full path of a signature's picture, for the native stamp call.
  Future<String> pathOf(SavedSignature signature) async {
    final dir = await _folder();
    return '${dir.path}/${signature.fileName}';
  }

  /// Every saved signature with its picture, newest first.
  ///
  /// A row whose picture file is gone (or cannot be read) is removed quietly, so
  /// the list never shows a broken thumbnail.
  Future<List<LoadedSignature>> loadAll() async {
    final rows = await dao.all();
    final loaded = <LoadedSignature>[];
    for (final sig in rows) {
      try {
        final file = File(await pathOf(sig));
        final png = await file.readAsBytes();
        if (png.isEmpty) throw const FileSystemException('empty');
        loaded.add(LoadedSignature(signature: sig, png: png));
      } on FileSystemException {
        AppLogger.warning('A saved signature picture was missing; removed.');
        final id = sig.id;
        if (id != null) await dao.deleteById(id);
      }
    }
    return loaded;
  }

  /// Saves [png] as a new signature and returns it with its database id.
  ///
  /// If the database step fails, the file just written is removed again so no
  /// orphan picture is left behind.
  Future<LoadedSignature> savePng(
    Uint8List png, {
    required int widthPx,
    required int heightPx,
    required SignatureSource source,
    DateTime? now,
  }) async {
    final created = now ?? DateTime.now();
    final fileName = 'sig_${created.microsecondsSinceEpoch}.png';
    final File file;
    try {
      final dir = await _ensureFolder();
      file = File('${dir.path}/$fileName');
      await file.writeAsBytes(png, flush: true);
    } on FileSystemException catch (e) {
      throw StorageException('Could not save the signature.', cause: e);
    }
    final draft = SavedSignature(
      id: null,
      fileName: fileName,
      widthPx: widthPx,
      heightPx: heightPx,
      source: source,
      createdAt: created,
    );
    try {
      final id = await dao.insert(draft);
      return LoadedSignature(
        signature: draft.copyWith(id: id),
        png: png,
      );
    } catch (e) {
      await _deleteQuietly(file);
      throw StorageException('Could not save the signature.', cause: e);
    }
  }

  /// Removes a saved signature: its row and its picture file.
  Future<void> delete(SavedSignature signature) async {
    final id = signature.id;
    if (id != null) await dao.deleteById(id);
    await _deleteQuietly(File(await pathOf(signature)));
  }

  /// Removes the whole private signature folder ("Delete all data"). The rows
  /// are cleared by the purge service together with the other tables.
  Future<void> deleteAllFiles() async {
    try {
      final dir = await _folder();
      if (await dir.exists()) await dir.delete(recursive: true);
    } on FileSystemException {
      // No detail logged: the error text would carry the private path.
      AppLogger.warning('Could not delete the saved signature folder.');
    }
  }

  static Future<void> _deleteQuietly(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // Best effort: a left-over file in private storage harms nothing.
    }
  }
}
