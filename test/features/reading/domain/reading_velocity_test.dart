import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/reading/domain/reading_velocity.dart';

void main() {
  group('ReadingVelocity', () {
    test('estimates chapter and total minutes left correctly', () {
      const velocity = ReadingVelocity(chapterEndPage: 10);

      // On page 1 of 10 pages in chapter (10 remaining pages * 60s / 60s) = 10 mins
      expect(velocity.estimateChapterMinutesLeft(1, 20), 10);

      // On page 6 of 10 pages in chapter (5 remaining pages * 60s / 60s) = 5 mins
      expect(velocity.estimateChapterMinutesLeft(6, 20), 5);

      // On page 10 of 10 pages in chapter = 1 min
      expect(velocity.estimateChapterMinutesLeft(10, 20), 1);

      // Total document remaining time (20 pages total, on page 1) = 20 mins
      expect(velocity.estimateTotalMinutesLeft(1, 20), 20);
    });

    test('uses word counts when available for precise calculation', () {
      const velocity = ReadingVelocity(
        pageWordCounts: {1: 300, 2: 300, 3: 400},
        chapterEndPage: 3,
      );

      // 1000 words / 200 wpm = 5 minutes
      expect(velocity.estimateChapterMinutesLeft(1, 3), 5);
    });
  });
}
