import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/files/output_file_name.dart';

void main() {
  final now = DateTime(2026, 11, 5, 9, 3, 7);

  test('keeps the original name and adds the action and a readable time', () {
    expect(
      OutputFileName.build('EliteHub_Invoice.pdf', now, action: 'signed'),
      'EliteHub_Invoice_signed_20261105_090307.pdf',
    );
  });

  test('works without an action and with another extension', () {
    expect(OutputFileName.build('Notes', now), 'Notes_20261105_090307.pdf');
    expect(
      OutputFileName.build('Book.pdf', now, action: 'text', extension: 'txt'),
      'Book_text_20261105_090307.txt',
    );
  });

  test('removes the .pdf extension in any case', () {
    expect(OutputFileName.baseOf('Report.PDF'), 'Report');
    expect(OutputFileName.baseOf('notes'), 'notes');
    expect(OutputFileName.baseOf('a.pdf.pdf'), 'a.pdf');
  });

  test('replaces characters that are not allowed in file names', () {
    expect(
      OutputFileName.baseOf('a/b\\c:d*e?f"g<h>i|j.pdf'),
      'a_b_c_d_e_f_g_h_i_j',
    );
    expect(OutputFileName.baseOf('tab\there.pdf'), 'tab_here');
  });

  test('a path trick cannot leave the output folder', () {
    final name = OutputFileName.build('../../secret.pdf', now, action: 'x');
    expect(name.contains('/'), isFalse);
    expect(name.startsWith('.'), isFalse);
  });

  test('keeps Malayalam names', () {
    expect(OutputFileName.baseOf('ബിൽ 2026.pdf'), 'ബിൽ 2026');
  });

  test('shortens a very long name', () {
    final base = OutputFileName.baseOf('${'x' * 300}.pdf');
    expect(base.length, OutputFileName.maxBaseLength);
  });

  test('falls back when nothing usable is left', () {
    expect(OutputFileName.baseOf(''), OutputFileName.fallbackBase);
    expect(OutputFileName.baseOf(' .pdf'), OutputFileName.fallbackBase);
    expect(OutputFileName.baseOf('...'), OutputFileName.fallbackBase);
  });

  test('adds a copy number from the second copy on', () {
    expect(
      OutputFileName.build('a.pdf', now, action: 'merged', copy: 2),
      'a_merged_20261105_090307_2.pdf',
    );
    expect(
      OutputFileName.build('a.pdf', now, action: 'merged'),
      'a_merged_20261105_090307.pdf',
    );
  });

  group('uniquePath', () {
    late Directory dir;
    setUp(() async => dir = await Directory.systemTemp.createTemp('ofn'));
    tearDown(() => dir.delete(recursive: true));

    test('never returns the path of an existing file', () async {
      final first = await OutputFileName.uniquePath(
        dir,
        'a.pdf',
        now,
        action: 'merged',
      );
      expect(first, '${dir.path}/a_merged_20261105_090307.pdf');
      await File(first).writeAsString('x');
      final second = await OutputFileName.uniquePath(
        dir,
        'a.pdf',
        now,
        action: 'merged',
      );
      expect(second, '${dir.path}/a_merged_20261105_090307_2.pdf');
      await File(second).writeAsString('x');
      expect(
        await OutputFileName.uniquePath(dir, 'a.pdf', now, action: 'merged'),
        '${dir.path}/a_merged_20261105_090307_3.pdf',
      );
    });
  });
}
