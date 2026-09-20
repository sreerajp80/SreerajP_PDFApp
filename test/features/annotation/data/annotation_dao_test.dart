import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/annotation/data/annotation_dao.dart';
import 'package:pdfapp/features/annotation/domain/annotation.dart';
import 'package:pdfapp/features/annotation/domain/annotation_type.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late AnnotationDao dao;

  final now = DateTime.fromMillisecondsSinceEpoch(1700000000000);

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
    dao = AnnotationDao(appDb.database);
  });

  tearDown(() => appDb.close());

  MarkupAnnotation markup(String fp, int page) => MarkupAnnotation(
    id: null,
    fingerprint: fp,
    page: page,
    color: 0xFFFFEB3B,
    createdAt: now,
    updatedAt: now,
    markupType: AnnotationType.highlight,
    quads: const [Rect.fromLTWH(0.1, 0.2, 0.3, 0.04)],
  );

  test('insert returns an id and byFile reads it back', () async {
    final id = await dao.insert(markup('fp1', 1));
    expect(id, greaterThan(0));

    final all = await dao.byFile('fp1');
    expect(all.length, 1);
    expect(all.first.id, id);
    expect(all.first.page, 1);
  });

  test('byPage filters to one page', () async {
    await dao.insert(markup('fp1', 1));
    await dao.insert(markup('fp1', 2));
    await dao.insert(markup('fp1', 2));

    expect((await dao.byPage('fp1', 1)).length, 1);
    expect((await dao.byPage('fp1', 2)).length, 2);
  });

  test('byFile does not leak across files', () async {
    await dao.insert(markup('fp1', 1));
    await dao.insert(markup('fp2', 1));
    expect((await dao.byFile('fp1')).length, 1);
    expect((await dao.byFile('fp2')).length, 1);
  });

  test('update changes the stored note text', () async {
    final id = await dao.insert(
      NoteAnnotation(
        id: null,
        fingerprint: 'fp1',
        page: 1,
        color: 0xFFFFC107,
        createdAt: now,
        updatedAt: now,
        anchor: const Offset(0.5, 0.5),
        text: 'old',
      ),
    );
    final stored = (await dao.byFile('fp1')).first as NoteAnnotation;
    await dao.update(
      NoteAnnotation(
        id: id,
        fingerprint: stored.fingerprint,
        page: stored.page,
        color: stored.color,
        createdAt: stored.createdAt,
        updatedAt: now,
        anchor: stored.anchor,
        text: 'new',
      ),
    );
    final after = (await dao.byFile('fp1')).first as NoteAnnotation;
    expect(after.text, 'new');
  });

  test('deleteById removes one row', () async {
    final id = await dao.insert(markup('fp1', 1));
    await dao.deleteById(id);
    expect(await dao.byFile('fp1'), isEmpty);
  });

  test('deleteAllForFile clears only that file', () async {
    await dao.insert(markup('fp1', 1));
    await dao.insert(markup('fp1', 2));
    await dao.insert(markup('fp2', 1));
    await dao.deleteAllForFile('fp1');
    expect(await dao.byFile('fp1'), isEmpty);
    expect((await dao.byFile('fp2')).length, 1);
  });

  test('update with no id throws', () async {
    expect(() => dao.update(markup('fp1', 1)), throwsArgumentError);
  });
}
