import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';

void main() {
  final hash = 'a' * 64;

  group('FileOffer', () {
    test('round-trips through the wire format', () {
      final offer = FileOffer([
        OfferedFile(name: 'one.pdf', sizeBytes: 10, sha256: hash),
        OfferedFile(name: 'രണ്ട്.pdf', sizeBytes: 0, sha256: 'b' * 64),
      ]);
      final back = TransferOffer.fromWire(offer.toWire()) as FileOffer;
      expect(back.files.length, 2);
      expect(back.files[1].name, 'രണ്ട്.pdf');
      expect(back.totalBytes, 10);
    });

    test('a bad entry refuses the whole list', () {
      Map<String, Object?> wire(Object entry) => {
        'kind': 'files',
        'files': [
          {'name': 'ok.pdf', 'size': 1, 'sha256': hash},
          entry,
        ],
      };
      for (final bad in <Object>[
        {'name': '', 'size': 1, 'sha256': hash},
        {'name': 'x.pdf', 'size': -1, 'sha256': hash},
        {'name': 'x.pdf', 'size': FileOffer.maxFileBytes + 1, 'sha256': hash},
        {'name': 'x.pdf', 'size': 1, 'sha256': 'XYZ'},
        {'name': 'x.pdf', 'size': 1, 'sha256': 'A' * 64},
        {'name': 'x' * 300, 'size': 1, 'sha256': hash},
        'not a map',
      ]) {
        expect(FileOffer.fromWire(wire(bad)), isNull, reason: '$bad');
      }
    });

    test('empty or too long lists are refused', () {
      expect(FileOffer.fromWire({'kind': 'files', 'files': []}), isNull);
      expect(
        FileOffer.fromWire({
          'kind': 'files',
          'files': List.generate(
            FileOffer.maxFiles + 1,
            (i) => {'name': '$i.pdf', 'size': 1, 'sha256': hash},
          ),
        }),
        isNull,
      );
    });
  });

  group('safePdfFileName', () {
    test('removes folders and dangerous characters', () {
      expect(safePdfFileName('../../etc/passwd'), 'passwd.pdf');
      expect(safePdfFileName(r'C:\x\report.pdf'), 'report.pdf');
      expect(safePdfFileName('a:b*c?.pdf'), 'a_b_c_.pdf');
      expect(safePdfFileName('..hidden.pdf'), 'hidden.pdf');
      expect(safePdfFileName('tab\there.PDF'), 'tab_here.pdf');
    });

    test('always gives a usable name ending in .pdf', () {
      expect(safePdfFileName(''), 'document.pdf');
      expect(safePdfFileName('...'), 'document.pdf');
      expect(safePdfFileName('notes'), 'notes.pdf');
      expect(safePdfFileName('ഗ്രന്ഥം.pdf'), 'ഗ്രന്ഥം.pdf');
    });

    test('long names are cut by whole letters', () {
      final long = 'ക്ഷ' * 200;
      final out = safePdfFileName(long);
      expect(out.endsWith('.pdf'), isTrue);
      // Every kept letter is a whole "ക്ഷ" cluster.
      final base = out.substring(0, out.length - 4);
      expect(base.length % 'ക്ഷ'.length, 0);
    });
  });
}
