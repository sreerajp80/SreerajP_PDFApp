import 'dart:math';

/// Reading velocity metrics and time estimates for the active document.
class ReadingVelocity {
  const ReadingVelocity({
    this.wordsPerMinute = 200,
    this.secondsPerPage = 60.0,
    this.pageWordCounts = const {},
    this.chapterTitle,
    this.chapterStartPage = 1,
    this.chapterEndPage,
    this.sampleCount = 0,
  });

  /// Default baseline reading speed in words per minute (~200-220 WPM for adult readers).
  static const int defaultWpm = 200;

  /// User's calculated or baseline reading speed in words per minute.
  final int wordsPerMinute;

  /// Smoothed average duration spent per page in seconds.
  final double secondsPerPage;

  /// Word counts per page (cached as pages are read/loaded).
  final Map<int, int> pageWordCounts;

  /// Name of the current chapter from outline/TOC, if available.
  final String? chapterTitle;

  /// Start page of the current chapter.
  final int chapterStartPage;

  /// End page of the current chapter (inclusive). If null, defaults to total pages.
  final int? chapterEndPage;

  /// Number of pages sampled for reading velocity calculation.
  final int sampleCount;

  /// Estimates the remaining reading time in minutes for the current chapter from [currentPage].
  int estimateChapterMinutesLeft(int currentPage, int totalPages) {
    final endPage = chapterEndPage ?? totalPages;
    if (currentPage > endPage || totalPages <= 0) return 0;

    final remainingPages = max(0, endPage - currentPage + 1);

    // Sum word counts if available for remaining pages.
    var remainingWords = 0;
    var pagesWithWordCounts = 0;
    for (var p = currentPage; p <= endPage; p++) {
      final count = pageWordCounts[p];
      if (count != null && count > 0) {
        remainingWords += count;
        pagesWithWordCounts++;
      }
    }

    if (pagesWithWordCounts > 0 && remainingWords > 0) {
      // Estimate average words for pages not yet loaded in this chapter.
      final avgWords = remainingWords / pagesWithWordCounts;
      final totalEstimatedWords =
          remainingWords + ((remainingPages - pagesWithWordCounts) * avgWords);
      final minutes = (totalEstimatedWords / max(1, wordsPerMinute)).ceil();
      return max(1, minutes);
    }

    // Fallback using seconds per page.
    final minutes = ((remainingPages * secondsPerPage) / 60.0).ceil();
    return max(1, minutes);
  }

  /// Estimates remaining reading time in minutes for the whole document from [currentPage].
  int estimateTotalMinutesLeft(int currentPage, int totalPages) {
    if (currentPage > totalPages || totalPages <= 0) return 0;
    final remainingPages = max(0, totalPages - currentPage + 1);

    var remainingWords = 0;
    var pagesWithWordCounts = 0;
    for (var p = currentPage; p <= totalPages; p++) {
      final count = pageWordCounts[p];
      if (count != null && count > 0) {
        remainingWords += count;
        pagesWithWordCounts++;
      }
    }

    if (pagesWithWordCounts > 0 && remainingWords > 0) {
      final avgWords = remainingWords / pagesWithWordCounts;
      final totalEstimatedWords =
          remainingWords + ((remainingPages - pagesWithWordCounts) * avgWords);
      final minutes = (totalEstimatedWords / max(1, wordsPerMinute)).ceil();
      return max(1, minutes);
    }

    final minutes = ((remainingPages * secondsPerPage) / 60.0).ceil();
    return max(1, minutes);
  }

  ReadingVelocity copyWith({
    int? wordsPerMinute,
    double? secondsPerPage,
    Map<int, int>? pageWordCounts,
    String? chapterTitle,
    int? chapterStartPage,
    int? chapterEndPage,
    int? sampleCount,
  }) {
    return ReadingVelocity(
      wordsPerMinute: wordsPerMinute ?? this.wordsPerMinute,
      secondsPerPage: secondsPerPage ?? this.secondsPerPage,
      pageWordCounts: pageWordCounts ?? this.pageWordCounts,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      chapterStartPage: chapterStartPage ?? this.chapterStartPage,
      chapterEndPage: chapterEndPage ?? this.chapterEndPage,
      sampleCount: sampleCount ?? this.sampleCount,
    );
  }
}
