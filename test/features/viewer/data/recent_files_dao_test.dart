import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/viewer/data/recent_files_dao.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late RecentFilesDao dao;

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
    dao = RecentFilesDao(appDb.database);
  });

  tearDown(() => appDb.close());

  RecentFile file(String fp, int openedAtMs) => RecentFile(
    fingerprint: fp,
    uri: 'content://$fp',
    displayName: '$fp.pdf',
    sizeBytes: 100,
    lastOpenedAt: DateTime.fromMillisecondsSinceEpoch(openedAtMs),
  );

  test('upsert then read back by fingerprint', () async {
    await dao.upsert(file('a', 1000));
    final got = await dao.byFingerprint('a');
    expect(got, isNotNull);
    expect(got!.displayName, 'a.pdf');
    expect(got.uri, 'content://a');
  });

  test('list is newest-first', () async {
    await dao.upsert(file('old', 1000));
    await dao.upsert(file('new', 5000));
    final list = await dao.list();
    expect(list.map((f) => f.fingerprint), ['new', 'old']);
  });

  test('upsert refreshes an existing entry', () async {
    await dao.upsert(file('a', 1000));
    await dao.upsert(file('a', 9000));
    final list = await dao.list();
    expect(list, hasLength(1));
    expect(list.first.lastOpenedAt.millisecondsSinceEpoch, 9000);
  });

  test('setPageCount stores the count', () async {
    await dao.upsert(file('a', 1000));
    await dao.setPageCount('a', 42);
    expect((await dao.byFingerprint('a'))!.pageCount, 42);
  });

  test('remove deletes the entry', () async {
    await dao.upsert(file('a', 1000));
    await dao.remove('a');
    expect(await dao.byFingerprint('a'), isNull);
  });
}
