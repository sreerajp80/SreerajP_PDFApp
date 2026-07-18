import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/annotation/data/annotation_dao.dart';
import 'package:pdfapp/features/annotation/domain/annotation.dart';

/// The single surface the UI uses for overlay annotations (Phase 5).
///
/// It stores marks in the app database (via [AnnotationDao]) and, on request,
/// exports them into a **new** PDF copy through PdfBox-Android. The source file
/// is never changed.
class AnnotationRepository {
  AnnotationRepository({
    required AnnotationDao dao,
    required PdfBoxChannel pdfBox,
    required OpenDocumentChannel openChannel,
  }) : _dao = dao,
       _pdfBox = pdfBox,
       _openChannel = openChannel;

  final AnnotationDao _dao;
  final PdfBoxChannel _pdfBox;
  final OpenDocumentChannel _openChannel;

  Future<List<Annotation>> forFile(String fingerprint) =>
      _dao.byFile(fingerprint);

  /// Adds an annotation and returns it with its new database id filled in.
  Future<Annotation> add(Annotation annotation) async {
    final id = await _dao.insert(annotation);
    return Annotation.fromRow({...annotation.toRow(), 'id': id});
  }

  Future<void> update(Annotation annotation) => _dao.update(annotation);

  Future<void> delete(int id) => _dao.deleteById(id);

  Future<void> clearFile(String fingerprint) =>
      _dao.deleteAllForFile(fingerprint);

  /// Exports [annotations] into a new annotated copy of [sourcePath], returning
  /// the path of the produced file in the app cache. Copy-on-write.
  Future<String> exportAnnotatedCopy({
    required String sourcePath,
    required List<Annotation> annotations,
    String? password,
  }) async {
    final out = await _outputPath('annotated');
    final flattened = annotations.map(_toPlatformMap).toList();
    return _pdfBox.exportAnnotations(
      sourcePath,
      out,
      flattened,
      password: password,
    );
  }

  /// Saves a produced file to a user-chosen location (SAF). Returns the saved
  /// name, or null if the user cancelled.
  Future<String?> saveToDevice(String sourcePath, String suggestedName) =>
      _openChannel.saveToDevice(sourcePath, suggestedName);

  /// Flattens a domain annotation into the map the platform side expects.
  Map<String, Object?> _toPlatformMap(Annotation a) {
    final base = <String, Object?>{
      'type': a.type.storageName,
      'page': a.page,
      'color': a.color,
    };
    switch (a) {
      case MarkupAnnotation():
        base['quads'] = a.quads
            .map((r) => [r.left, r.top, r.width, r.height])
            .toList();
      case InkAnnotation():
        base['strokes'] = a.strokes
            .map(
              (s) => {
                'w': s.width,
                'pts': s.points.map((p) => [p.dx, p.dy]).toList(),
              },
            )
            .toList();
      case NoteAnnotation():
        base['at'] = [a.anchor.dx, a.anchor.dy];
        base['text'] = a.text;
      case BookmarkAnnotation():
        base['label'] = a.label;
    }
    return base;
  }

  Future<String> _outputPath(String prefix) async {
    final temp = await getTemporaryDirectory();
    final dir = Directory('${temp.path}/annotations');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/${prefix}_$ts.pdf';
  }
}
