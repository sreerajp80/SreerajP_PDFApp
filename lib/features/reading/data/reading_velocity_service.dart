import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';
import 'package:pdfapp/features/reading/domain/reading_velocity.dart';

/// Tracks active reading speed and provides real-time chapter and document time estimates.
class ReadingVelocityService extends ChangeNotifier {
  ReadingVelocityService({
    this.textSource,
    List<PdfOutlineNode>? outline,
    int initialWpm = ReadingVelocity.defaultWpm,
  }) : _velocity = ReadingVelocity(wordsPerMinute: initialWpm) {
    if (outline != null) {
      _indexOutline(outline);
    }
  }

  final PdfTextSource? textSource;
  ReadingVelocity _velocity;
  ReadingVelocity get velocity => _velocity;

  int _activePage = 1;
  DateTime? _pageEnteredAt;
  final List<PdfOutlineNode> _outlineNodes = [];
  final List<_ChapterSpan> _chapters = [];

  void setOutline(List<PdfOutlineNode> nodes, int totalPages) {
    _outlineNodes.clear();
    _outlineNodes.addAll(nodes);
    _indexOutline(nodes, totalPages: totalPages);
    _updateChapterForPage(_activePage);
  }

  void _indexOutline(List<PdfOutlineNode> nodes, {int? totalPages}) {
    _chapters.clear();
    final flatList = <PdfOutlineNode>[];

    void flatten(List<PdfOutlineNode> list) {
      for (final node in list) {
        if (node.dest?.pageNumber != null) {
          flatList.add(node);
        }
        if (node.children.isNotEmpty) {
          flatten(node.children);
        }
      }
    }

    flatten(nodes);
    flatList.sort(
      (a, b) => (a.dest?.pageNumber ?? 0).compareTo(b.dest?.pageNumber ?? 0),
    );

    for (var i = 0; i < flatList.length; i++) {
      final current = flatList[i];
      final start = current.dest?.pageNumber ?? 1;
      final int end;
      if (i + 1 < flatList.length) {
        final nextStart = flatList[i + 1].dest?.pageNumber ?? start;
        end = max(start, nextStart - 1);
      } else {
        end = totalPages ?? start + 20;
      }
      _chapters.add(
        _ChapterSpan(title: current.title, startPage: start, endPage: end),
      );
    }
  }

  /// Called when the reader lands on a new page.
  void onPageChanged(int pageNumber, int totalPages) {
    final now = DateTime.now();
    if (_pageEnteredAt != null && _activePage != pageNumber) {
      final dwellSeconds =
          now.difference(_pageEnteredAt!).inMilliseconds / 1000.0;
      _recordDwellTime(_activePage, dwellSeconds);
    }

    _activePage = pageNumber;
    _pageEnteredAt = now;
    _updateChapterForPage(pageNumber);
    unawaited(_cachePageWordCount(pageNumber));
  }

  void _updateChapterForPage(int pageNumber) {
    if (_chapters.isEmpty) return;

    _ChapterSpan? currentChapter;
    for (final c in _chapters) {
      if (pageNumber >= c.startPage && pageNumber <= c.endPage) {
        currentChapter = c;
        break;
      }
    }

    if (currentChapter != null) {
      _velocity = _velocity.copyWith(
        chapterTitle: currentChapter.title,
        chapterStartPage: currentChapter.startPage,
        chapterEndPage: currentChapter.endPage,
      );
      notifyListeners();
    }
  }

  /// Records reading time spent on [page]. Filters out rapid page flips (<3s) or idling (>300s).
  void _recordDwellTime(int page, double seconds) {
    if (seconds < 3.0 || seconds > 300.0) {
      return; // Ignore fast flips or left-idle
    }

    final currentCount = _velocity.sampleCount;
    final newSecondsPerPage = currentCount == 0
        ? seconds
        : (_velocity.secondsPerPage * 0.7) +
              (seconds * 0.3); // Exponential moving average

    final wordCount = _velocity.pageWordCounts[page];
    int newWpm = _velocity.wordsPerMinute;

    if (wordCount != null && wordCount > 10) {
      final calculatedWpm = ((wordCount / seconds) * 60).round();
      if (calculatedWpm >= 50 && calculatedWpm <= 800) {
        newWpm = currentCount == 0
            ? calculatedWpm
            : ((_velocity.wordsPerMinute * 0.75) + (calculatedWpm * 0.25))
                  .round();
      }
    }

    _velocity = _velocity.copyWith(
      secondsPerPage: newSecondsPerPage,
      wordsPerMinute: newWpm,
      sampleCount: currentCount + 1,
    );
    notifyListeners();
  }

  Future<void> _cachePageWordCount(int page) async {
    final source = textSource;
    if (source == null || _velocity.pageWordCounts.containsKey(page)) {
      return;
    }
    try {
      final pageData = await source.page(page);
      final text = pageData.text.trim();
      final words = text.isEmpty
          ? 0
          : text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

      final updated = Map<int, int>.from(_velocity.pageWordCounts);
      updated[page] = words;
      _velocity = _velocity.copyWith(pageWordCounts: updated);
      notifyListeners();
    } catch (_) {
      // Ignored for non-text or locked pages
    }
  }
}

class _ChapterSpan {
  const _ChapterSpan({
    required this.title,
    required this.startPage,
    required this.endPage,
  });

  final String title;
  final int startPage;
  final int endPage;
}
