import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_dao.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_repository.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A DAO whose insert always fails, to check the clean-up path.
class _FailingInsertDao extends SavedSignatureDao {
  _FailingInsertDao(super.db);

  @override
  Future<int> insert(SavedSignature signature) async =>
      throw Exception('disk full');
}

void main() {
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late Directory root;
  late Directory folder;
  late SavedSignatureDao dao;
  late SavedSignatureRepository repo;

  final png = Uint8List.fromList([137, 80, 78, 71, 1, 2, 3]);

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
    root = await Directory.systemTemp.createTemp('sig_repo_test');
    folder = Directory('${root.path}/my_signatures');
    dao = SavedSignatureDao(appDb.database);
    repo = SavedSignatureRepository(dao: dao, folder: () async => folder);
  });

  tearDown(() async {
    await appDb.close();
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('savePng writes the file and the row, and loadAll reads both', () async {
    final saved = await repo.savePng(
      png,
      widthPx: 300,
      heightPx: 100,
      source: SignatureSource.drawn,
    );
    expect(saved.signature.id, isNotNull);
    expect(File(await repo.pathOf(saved.signature)).existsSync(), isTrue);

    final all = await repo.loadAll();
    expect(all, hasLength(1));
    expect(all.single.png, png);
    expect(all.single.signature.source, SignatureSource.drawn);
  });

  test('the list is newest first', () async {
    await repo.savePng(
      png,
      widthPx: 1,
      heightPx: 1,
      source: SignatureSource.drawn,
      now: DateTime(2026),
    );
    await repo.savePng(
      png,
      widthPx: 2,
      heightPx: 2,
      source: SignatureSource.imported,
      now: DateTime(2026, 6),
    );
    final all = await repo.loadAll();
    expect(all.map((s) => s.signature.widthPx), [2, 1]);
  });

  test('a row whose file is gone is removed quietly', () async {
    final saved = await repo.savePng(
      png,
      widthPx: 1,
      heightPx: 1,
      source: SignatureSource.drawn,
    );
    await File(await repo.pathOf(saved.signature)).delete();

    expect(await repo.loadAll(), isEmpty);
    expect(await dao.all(), isEmpty);
  });

  test('delete removes both the row and the file', () async {
    final saved = await repo.savePng(
      png,
      widthPx: 1,
      heightPx: 1,
      source: SignatureSource.drawn,
    );
    final path = await repo.pathOf(saved.signature);
    await repo.delete(saved.signature);
    expect(File(path).existsSync(), isFalse);
    expect(await dao.all(), isEmpty);
  });

  test('a failed database insert leaves no orphan file', () async {
    final failing = SavedSignatureRepository(
      dao: _FailingInsertDao(appDb.database),
      folder: () async => folder,
    );
    await expectLater(
      failing.savePng(
        png,
        widthPx: 1,
        heightPx: 1,
        source: SignatureSource.drawn,
      ),
      throwsA(isA<StorageException>()),
    );
    expect(folder.listSync(), isEmpty);
  });

  test('deleteAllFiles removes the private folder', () async {
    await repo.savePng(
      png,
      widthPx: 1,
      heightPx: 1,
      source: SignatureSource.drawn,
    );
    await repo.deleteAllFiles();
    expect(folder.existsSync(), isFalse);
    // Safe to call again when nothing is there.
    await repo.deleteAllFiles();
  });
}
