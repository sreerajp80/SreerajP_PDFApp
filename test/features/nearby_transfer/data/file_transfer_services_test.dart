import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/nearby_transfer/data/file_transfer_services.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_guest.dart';
import 'package:pdfapp/features/nearby_transfer/domain/send_item.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';
import 'package:pdfapp/features/viewer/data/recent_files_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A channel with no platform behind it.
class _FakeChannel extends OpenDocumentChannel {
  ({String uri, String name})? nextPick;
  final Map<String, String> reachable = {};
  final List<String> released = [];
  final List<({String path, String name})> savedRequests = [];
  Set<String> failNames = {};
  Map<String, String> cacheFor = {};

  @override
  Future<({String uri, String name})?> pickFolder() async => nextPick;

  @override
  Future<String?> folderName(String uri) async => reachable[uri];

  @override
  Future<void> releaseFolder(String uri) async => released.add(uri);

  @override
  Future<List<({String name, String? uri})>> saveFilesToFolder(
    String treeUri,
    List<({String path, String name})> files,
  ) async {
    savedRequests.addAll(files);
    return [
      for (final f in files)
        (
          name: f.name,
          uri: failNames.contains(f.name) ? null : '$treeUri/${f.name}',
        ),
    ];
  }

  @override
  Future<OpenedDocument> resolveToCache(String uri) async {
    final path = cacheFor[uri];
    if (path == null) throw const StorageException('gone');
    return OpenedDocument(
      uri: uri,
      displayName: p.basename(path),
      sizeBytes: File(path).lengthSync(),
      cachePath: path,
    );
  }
}

void main() {
  setUpAll(sqfliteFfiInit);

  late _FakeChannel channel;
  late SharedPreferences prefs;
  late Directory work;

  setUp(() async {
    channel = _FakeChannel();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    work = await Directory.systemTemp.createTemp('folio_svc_');
  });

  tearDown(() async {
    if (work.existsSync()) await work.delete(recursive: true);
  });

  group('ReceiveFolderService', () {
    test('no folder yet, then a chosen folder is remembered', () async {
      final service = ReceiveFolderService(prefs, channel);
      expect((await service.current()).folder, isNull);
      expect((await service.current()).lost, isFalse);

      channel.nextPick = (uri: 'content://tree/A', name: 'Folio');
      channel.reachable['content://tree/A'] = 'Folio';
      final picked = await service.choose();
      expect(picked?.name, 'Folio');
      expect(
        prefs.getString(AppConstants.prefReceiveFolderUri),
        'content://tree/A',
      );
      expect((await service.current()).folder?.uri, 'content://tree/A');
    });

    test('changing the folder releases the old one', () async {
      final service = ReceiveFolderService(prefs, channel);
      channel.nextPick = (uri: 'content://tree/A', name: 'A');
      await service.choose();
      channel.nextPick = (uri: 'content://tree/B', name: 'B');
      await service.choose();
      expect(channel.released, ['content://tree/A']);
      expect(
        prefs.getString(AppConstants.prefReceiveFolderUri),
        'content://tree/B',
      );
    });

    test('cancelling the picker keeps the old folder', () async {
      final service = ReceiveFolderService(prefs, channel);
      channel.nextPick = (uri: 'content://tree/A', name: 'A');
      await service.choose();
      channel.nextPick = null;
      expect(await service.choose(), isNull);
      expect(channel.released, isEmpty);
      expect(
        prefs.getString(AppConstants.prefReceiveFolderUri),
        'content://tree/A',
      );
    });

    test('a folder that is gone is reported as lost', () async {
      await prefs.setString(
        AppConstants.prefReceiveFolderUri,
        'content://tree/X',
      );
      final status = await ReceiveFolderService(prefs, channel).current();
      expect(status.folder, isNull);
      expect(status.lost, isTrue);
    });
  });

  group('OutgoingFilesService', () {
    test('prepares readable files and lists the rest as skipped', () async {
      final a = File(p.join(work.path, 'a.pdf'))..writeAsStringSync('%PDF-1');
      final b = File(p.join(work.path, 'b.pdf'))..writeAsStringSync('%PDF-22');
      channel.cacheFor['content://b'] = b.path;
      final result = await OutgoingFilesService(channel).prepare([
        SendItem(name: 'a.pdf', cachePath: a.path),
        const SendItem(name: 'b.pdf', uri: 'content://b'),
        const SendItem(name: 'gone.pdf', uri: 'content://gone'),
      ]);
      expect(result.ready.map((r) => r.offered.name), ['a.pdf', 'b.pdf']);
      expect(result.ready[1].offered.sizeBytes, 7);
      expect(result.ready[0].offered.sha256, hasLength(64));
      expect(result.skipped, ['gone.pdf']);
    });
  });

  group('ReceivedFilesStore', () {
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

    ReceivedFile received(String name, {ReceivedFileProblem? problem}) {
      final file = File(p.join(work.path, name))..writeAsStringSync('%PDF-');
      return ReceivedFile(
        offered: OfferedFile(name: name, sizeBytes: 5, sha256: 'c' * 64),
        path: file.path,
        problem: problem,
      );
    }

    test(
      'saves good files, lists bad ones, adds recents, cleans cache',
      () async {
        final files = [
          received('one.pdf'),
          received('bad.pdf', problem: ReceivedFileProblem.damaged),
          received('two.pdf'),
        ];
        channel.failNames = {'two.pdf'};
        final result = await ReceivedFilesStore(
          channel,
          dao,
          prefs,
        ).save(const ReceiveFolder(uri: 'content://tree/A', name: 'A'), files);
        expect(result.saved, ['one.pdf']);
        expect(result.failed, containsAll(['bad.pdf', 'two.pdf']));
        expect(channel.savedRequests.map((r) => r.name), [
          'one.pdf',
          'two.pdf',
        ]);
        final recents = await dao.list();
        expect(recents.single.displayName, 'one.pdf');
        expect(recents.single.uri, 'content://tree/A/one.pdf');
        for (final f in files) {
          expect(File(f.path).existsSync(), isFalse);
        }
      },
    );

    test('does not add recents when the user turned that off', () async {
      await prefs.setBool(AppConstants.prefRememberRecentFiles, false);
      await ReceivedFilesStore(channel, dao, prefs).save(
        const ReceiveFolder(uri: 'content://tree/A', name: 'A'),
        [received('one.pdf')],
      );
      expect(await dao.list(), isEmpty);
    });
  });
}
