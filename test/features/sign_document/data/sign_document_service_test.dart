import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_dao.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_repository.dart';
import 'package:pdfapp/features/sign_document/data/sign_document_service.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/domain/signature_image_tools.dart';
import 'package:pdfapp/features/sign_document/domain/signature_placement.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _RecordingPdfBox extends PdfBoxChannel {
  _RecordingPdfBox() : super(method: const MethodChannel('fake/pdfbox'));

  String? source;
  String? output;
  String? password;
  List<Map<String, Object?>>? placements;

  @override
  Future<String> stampImages(
    String path,
    String outputPath,
    List<Map<String, Object?>> placements, {
    String? password,
  }) async {
    source = path;
    output = outputPath;
    this.placements = placements;
    this.password = password;
    return outputPath;
  }
}

class _FakeOpenChannel extends OpenDocumentChannel {
  _FakeOpenChannel(this.result)
    : super(method: const MethodChannel('fake/open'));

  final String? result;

  @override
  Future<String?> pickImage() async => result;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late Directory root;
  late SavedSignatureRepository repo;

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
    root = await Directory.systemTemp.createTemp('sign_service_test');
    repo = SavedSignatureRepository(
      dao: SavedSignatureDao(appDb.database),
      folder: () async => Directory('${root.path}/my_signatures'),
    );
  });

  tearDown(() async {
    await appDb.close();
    if (await root.exists()) await root.delete(recursive: true);
  });

  SignDocumentService service(_RecordingPdfBox pdfBox, {String? picked}) =>
      SignDocumentService(
        pdfBox: pdfBox,
        openChannel: _FakeOpenChannel(picked),
        repository: repo,
        outputDir: () async => Directory('${root.path}/signed'),
        clock: () => DateTime(2026, 11, 15, 14, 32, 5),
      );

  final signature = SavedSignature(
    id: 1,
    fileName: 'sig_1.png',
    widthPx: 300,
    heightPx: 100,
    source: SignatureSource.drawn,
    createdAt: DateTime(2026),
  );

  test('sign writes a new file and never targets the source', () async {
    final pdfBox = _RecordingPdfBox();
    final out = await service(pdfBox).sign(
      sourcePath: '/cache/original.pdf',
      displayName: 'EliteHub_Invoice.pdf',
      signature: signature,
      placements: const [
        SignaturePlacement(page: 1, rect: Rect.fromLTWH(0.1, 0.1, 0.3, 0.1)),
        SignaturePlacement(page: 3, rect: Rect.fromLTWH(0.5, 0.8, 0.2, 0.05)),
      ],
      password: 'pw',
    );

    expect(pdfBox.source, '/cache/original.pdf');
    expect(out, isNot('/cache/original.pdf'));
    expect(
      out,
      '${root.path}/signed/EliteHub_Invoice_signed_20261115_143205.pdf',
    );
    expect(pdfBox.password, 'pw');
    expect(pdfBox.placements, hasLength(2));
    expect(pdfBox.placements!.last['page'], 3);
    expect(
      pdfBox.placements!.first['imagePath'],
      '${root.path}/my_signatures/sig_1.png',
    );
  });

  test('a second copy in the same second gets a number', () async {
    final pdfBox = _RecordingPdfBox();
    await Directory('${root.path}/signed').create(recursive: true);
    await File(
      '${root.path}/signed/EliteHub_Invoice_signed_20261115_143205.pdf',
    ).writeAsString('first');
    final out = await service(pdfBox).sign(
      sourcePath: '/cache/original.pdf',
      displayName: 'EliteHub_Invoice.pdf',
      signature: signature,
      placements: const [
        SignaturePlacement(page: 1, rect: Rect.fromLTWH(0.1, 0.1, 0.3, 0.1)),
      ],
    );
    expect(
      out,
      '${root.path}/signed/EliteHub_Invoice_signed_20261115_143205_2.pdf',
    );
  });

  test('sign with no placements is refused before any native call', () async {
    final pdfBox = _RecordingPdfBox();
    await expectLater(
      service(pdfBox).sign(
        sourcePath: '/cache/a.pdf',
        displayName: 'a.pdf',
        signature: signature,
        placements: const [],
      ),
      throwsA(isA<ValidationException>()),
    );
    expect(pdfBox.source, isNull);
  });

  test('cancelling the picker returns null', () async {
    expect(await service(_RecordingPdfBox()).pickAndDecodeImage(), isNull);
  });

  test('a picked file that is not a picture is reported and removed', () async {
    final bad = File('${root.path}/not_a_picture.png')
      ..writeAsBytesSync(Uint8List.fromList(List.filled(64, 7)));
    await expectLater(
      service(_RecordingPdfBox(), picked: bad.path).pickAndDecodeImage(),
      throwsA(isA<ImageReadException>()),
    );
    expect(bad.existsSync(), isFalse, reason: 'cache copy must be deleted');
  });

  test('an empty picked file is reported', () async {
    final empty = File('${root.path}/empty.png')..writeAsBytesSync([]);
    await expectLater(
      service(_RecordingPdfBox(), picked: empty.path).pickAndDecodeImage(),
      throwsA(isA<ImageReadException>()),
    );
  });

  group('prepareImported', () {
    RgbaImage paperWithInk() {
      // 6 x 4 white paper with one dark ink pixel at (3, 2).
      final px = Uint8List(6 * 4 * 4)..fillRange(0, 6 * 4 * 4, 255);
      const i = (2 * 6 + 3) * 4;
      px.setRange(i, i + 4, [0, 0, 0, 255]);
      return RgbaImage(rgba: px, width: 6, height: 4);
    }

    test('removes the paper and trims to the ink (with padding)', () {
      final out = SignDocumentService.prepareImported(
        paperWithInk(),
        removeBackground: true,
      )!;
      // One ink pixel + up to 4 px padding, limited by the picture edges.
      expect(out.width, 6);
      expect(out.height, 4);
      expect(SignatureImageTools.opaqueBounds(out)!.width, 1);
    });

    test('without background removal the whole picture is kept', () {
      final out = SignDocumentService.prepareImported(
        paperWithInk(),
        removeBackground: false,
      )!;
      expect(SignatureImageTools.opaqueBounds(out)!.width, 6);
    });

    test('a blank photo leaves nothing', () {
      final blank = RgbaImage(
        rgba: Uint8List(4 * 4 * 4)..fillRange(0, 64, 255),
        width: 4,
        height: 4,
      );
      expect(
        SignDocumentService.prepareImported(blank, removeBackground: true),
        isNull,
      );
    });
  });
}
