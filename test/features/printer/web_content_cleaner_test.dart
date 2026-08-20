import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/printer/data/web_content_cleaner.dart';

void main() {
  group('WebContentCleaner', () {
    const cleaner = WebContentCleaner();

    test('strips script, style, nav, and ads from HTML', () {
      const html = '''
        <html>
          <head>
            <style>body { color: red; }</style>
            <script>console.log("track");</script>
          </head>
          <body>
            <header><h1>Site Header</h1></header>
            <nav><a href="/home">Home</a></nav>
            <article>
              <h2>Article Title</h2>
              <p>This is the main content paragraph.</p>
              <div class="ad-banner">Ad banner text</div>
              <p>Second paragraph with reference: https://example.com/page?utm_source=fb&fbclid=123</p>
            </article>
            <aside>Sidebar content</aside>
            <footer>Footer copyright 2026</footer>
          </body>
        </html>
      ''';

      final cleaned = cleaner.clean(html);

      expect(cleaned, contains('Article Title'));
      expect(cleaned, contains('This is the main content paragraph.'));
      expect(cleaned, contains('Second paragraph with reference'));
      expect(cleaned, contains('https://example.com/page'));
      expect(cleaned, isNot(contains('utm_source')));
      expect(cleaned, isNot(contains('fbclid')));
      expect(cleaned, isNot(contains('Site Header')));
      expect(cleaned, isNot(contains('Ad banner text')));
      expect(cleaned, isNot(contains('Sidebar content')));
      expect(cleaned, isNot(contains('Footer copyright')));
      expect(cleaned, isNot(contains('console.log')));
    });

    test('decodes HTML entities properly', () {
      const input =
          '<p>Rock &amp; Roll &mdash; &quot;Quotes&quot; &#39;Single&#39; &copy; 2026</p>';
      final cleaned = cleaner.clean(input);
      expect(cleaned, equals('Rock & Roll — "Quotes" \'Single\' © 2026'));
    });

    test('handles empty or blank input gracefully', () {
      expect(cleaner.clean(''), equals(''));
      expect(cleaner.clean('   \n\t  '), equals(''));
    });
  });
}
