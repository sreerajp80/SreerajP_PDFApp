import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/storage/fingerprint.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('fp_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  File writeFile(String name, List<int> bytes) {
    final f = File('${tempDir.path}/$name')..writeAsBytesSync(bytes);
    return f;
  }

  test('has the "<size>:<sha256hex>" shape', () async {
    final f = writeFile('a.bin', [1, 2, 3, 4]);
    final fp = await Fingerprint.ofFile(f.path);

    final parts = fp.split(':');
    expect(parts, hasLength(2));
    expect(parts[0], '4'); // size in bytes
    expect(parts[1], hasLength(64)); // sha-256 hex
  });

  test('same content gives the same fingerprint', () async {
    final a = writeFile('a.bin', [10, 20, 30]);
    final b = writeFile('b.bin', [10, 20, 30]);
    expect(await Fingerprint.ofFile(a.path), await Fingerprint.ofFile(b.path));
  });

  test('changed content gives a different fingerprint', () async {
    final f = writeFile('a.bin', [10, 20, 30]);
    final before = await Fingerprint.ofFile(f.path);

    f.writeAsBytesSync([10, 20, 31]);
    final after = await Fingerprint.ofFile(f.path);

    expect(before, isNot(after));
  });

  test('throws StorageException when the file is missing', () async {
    expect(
      () => Fingerprint.ofFile('${tempDir.path}/missing.bin'),
      throwsA(isA<StorageException>()),
    );
  });
}
