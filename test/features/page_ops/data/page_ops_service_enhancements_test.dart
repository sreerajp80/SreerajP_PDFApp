import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';

class _FakePdfBoxChannel extends PdfBoxChannel {
  @override
  Future<String> applyWatermark(
    String path,
    String outputPath, {
    String? password,
    String? text,
    String? imagePath,
    double opacity = 0.3,
    double rotation = 45.0,
    double fontSize = 36.0,
    String? colorHex,
    bool isTiled = false,
    double tileSpacingX = 150.0,
    double tileSpacingY = 150.0,
    String? pageRange,
  }) async {
    return outputPath;
  }

  @override
  Future<String> generateNUpPdf(
    String path,
    String outputPath, {
    String? password,
    int gridCount = 4,
    String sheetSize = 'a4',
    String orientation = 'auto',
    bool addBorders = true,
    double margin = 12.0,
  }) async {
    return outputPath;
  }

  @override
  Future<String> mergePdfs(List<String> paths, String outputPath) async {
    return outputPath;
  }

  @override
  Future<String> trimPdfMargins(
    String path,
    String outputPath, {
    String? password,
    double padding = 12.0,
    bool symmetric = true,
  }) async {
    return outputPath;
  }

  @override
  Future<String> compressPdf(
    String cachePath,
    String outputPath, {
    String? password,
  }) async {
    return outputPath;
  }

  @override
  Future<String> extractText(
    String cachePath, {
    String? password,
    int? startPage,
    int? endPage,
  }) async {
    return 'Sample text content';
  }
}

class _FakeOpenDocumentChannel extends OpenDocumentChannel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    messenger.setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getTemporaryDirectory') {
        return Directory.systemTemp.path;
      }
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(pathProviderChannel, null);
  });

  group('PageOpsService Enhancements', () {
    late PageOpsService service;

    setUp(() {
      service = PageOpsService(
        _FakePdfBoxChannel(),
        _FakeOpenDocumentChannel(),
      );
    });

    test('applyWatermark delegates to pdfbox channel', () async {
      final result = await service.applyWatermark(
        'input.pdf',
        text: 'TEST WATERMARK',
        opacity: 0.5,
        rotation: 30,
        isTiled: true,
      );
      expect(result, contains('watermarked_'));
    });

    test('generateNUp delegates to pdfbox channel', () async {
      final result = await service.generateNUp(
        'input.pdf',
        gridCount: 9,
        sheetSize: 'letter',
      );
      expect(result, contains('nup_'));
    });

    test('runBatchOperation processes batch merge', () async {
      final docs = [
        const OpenedDocument(
          uri: 'content://1',
          displayName: 'doc1.pdf',
          sizeBytes: 100,
          cachePath: 'doc1.pdf',
        ),
        const OpenedDocument(
          uri: 'content://2',
          displayName: 'doc2.pdf',
          sizeBytes: 200,
          cachePath: 'doc2.pdf',
        ),
      ];

      final result = await service.runBatchOperation(
        documents: docs,
        type: BatchOpType.merge,
      );

      expect(result.type, equals(BatchOpType.merge));
      expect(result.successCount, equals(1));
      expect(result.items.first.outputPath, contains('merged_'));
    });

    test('runBatchOperation processes batch trim', () async {
      final docs = [
        const OpenedDocument(
          uri: 'content://1',
          displayName: 'doc1.pdf',
          sizeBytes: 100,
          cachePath: 'doc1.pdf',
        ),
      ];

      final result = await service.runBatchOperation(
        documents: docs,
        type: BatchOpType.trimMargins,
      );

      expect(result.type, equals(BatchOpType.trimMargins));
      expect(result.successCount, equals(1));
      expect(result.items.first.outputPath, contains('trimmed_'));
    });

    test('runBatchOperation processes batch text extraction', () async {
      final docs = [
        const OpenedDocument(
          uri: 'content://1',
          displayName: 'doc1.pdf',
          sizeBytes: 100,
          cachePath: 'doc1.pdf',
        ),
      ];

      final result = await service.runBatchOperation(
        documents: docs,
        type: BatchOpType.extractText,
      );

      expect(result.type, equals(BatchOpType.extractText));
      expect(result.successCount, equals(1));
      expect(result.items.first.outputPath, contains('extracted_'));
    });
  });
}
