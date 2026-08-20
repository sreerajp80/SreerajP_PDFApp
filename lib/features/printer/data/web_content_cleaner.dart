/// Cleans shared web content and HTML before converting to PDF (Feature 3.5).
///
/// Strips unnecessary headers, footers, sidebars, navigation bars, cookie banners,
/// scripts, styles, and advertisements, extracting the clean readable article text.
class WebContentCleaner {
  const WebContentCleaner();

  /// Cleans raw [input] (which may be HTML or text containing web boilerplate).
  /// Returns clean readable article text formatted for PDF conversion.
  String clean(String input) {
    if (input.trim().isEmpty) return '';

    var text = input;

    // 1. Remove script, style, noscript, svg, iframe, form blocks entirely
    text = text.replaceAll(
      RegExp(r'<script\b[^>]*>[\s\S]*?<\/script>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<style\b[^>]*>[\s\S]*?<\/style>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<noscript\b[^>]*>[\s\S]*?<\/noscript>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<svg\b[^>]*>[\s\S]*?<\/svg>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<iframe\b[^>]*>[\s\S]*?<\/iframe>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<form\b[^>]*>[\s\S]*?<\/form>', caseSensitive: false),
      '',
    );

    // 2. Remove common boilerplate containers: nav, header, footer, aside
    text = text.replaceAll(
      RegExp(r'<nav\b[^>]*>[\s\S]*?<\/nav>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<header\b[^>]*>[\s\S]*?<\/header>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<footer\b[^>]*>[\s\S]*?<\/footer>', caseSensitive: false),
      '',
    );
    text = text.replaceAll(
      RegExp(r'<aside\b[^>]*>[\s\S]*?<\/aside>', caseSensitive: false),
      '',
    );

    // 3. Remove elements with classes/ids related to ads, banners, cookies, popups, share widgets
    text = text.replaceAll(
      RegExp(
        r'<div\b[^>]*(?:class|id)=["\x27][^"\x27]*(?:ad-|advert|banner|cookie|consent|sidebar|share-button|social-share|popup|modal)[^"\x27]*["\x27][^>]*>[\s\S]*?<\/div>',
        caseSensitive: false,
      ),
      '',
    );

    // 4. Try extracting from <article> or <main> if available
    final articleMatch = RegExp(
      r'<article\b[^>]*>([\s\S]*?)<\/article>',
      caseSensitive: false,
    ).firstMatch(text);
    if (articleMatch != null && articleMatch.group(1)!.trim().isNotEmpty) {
      text = articleMatch.group(1)!;
    } else {
      final mainMatch = RegExp(
        r'<main\b[^>]*>([\s\S]*?)<\/main>',
        caseSensitive: false,
      ).firstMatch(text);
      if (mainMatch != null && mainMatch.group(1)!.trim().isNotEmpty) {
        text = mainMatch.group(1)!;
      }
    }

    // 5. Convert structural HTML tags to proper line breaks and spacing
    text = text.replaceAll(RegExp(r'<br\s*\/?>', caseSensitive: false), '\n');
    text = text.replaceAll(
      RegExp(
        r'<\/(?:p|div|section|h[1-6]|tr|li|blockquote)>',
        caseSensitive: false,
      ),
      '\n\n',
    );
    text = text.replaceAll(
      RegExp(r'<(?:h[1-6])\b[^>]*>', caseSensitive: false),
      '\n\n',
    );
    text = text.replaceAll(
      RegExp(r'<li\b[^>]*>', caseSensitive: false),
      '\n • ',
    );

    // 6. Strip all remaining HTML tags
    text = text.replaceAll(RegExp(r'<[^>]+>'), ' ');

    // 7. Decode HTML entities
    text = _decodeHtmlEntities(text);

    // 8. Clean up excess whitespace while preserving paragraph breaks
    final lines = text.split('\n');
    final cleanedLines = <String>[];
    var lastWasEmpty = false;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        if (!lastWasEmpty && cleanedLines.isNotEmpty) {
          cleanedLines.add('');
          lastWasEmpty = true;
        }
      } else {
        // Strip tracking URL fragments
        final cleanedLine = _cleanTrackingUrls(trimmed);
        cleanedLines.add(cleanedLine);
        lastWasEmpty = false;
      }
    }

    return cleanedLines.join('\n').trim();
  }

  /// Removes common web marketing and analytics tracking parameters from text URLs.
  String _cleanTrackingUrls(String text) {
    return text.replaceAllMapped(
      RegExp(r'(https?:\/\/[^\s\?]+)\?([^\s]+)', caseSensitive: false),
      (match) {
        final base = match.group(1)!;
        final query = match.group(2)!;
        final params = query.split('&').where((p) {
          final key = p.split('=').first.toLowerCase();
          return !key.startsWith('utm_') &&
              key != 'fbclid' &&
              key != 'gclid' &&
              key != 'ref' &&
              key != 'source' &&
              key != 'mc_cid';
        }).toList();

        if (params.isEmpty) return base;
        return '$base?${params.join('&')}';
      },
    );
  }

  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—')
        .replaceAll('&hellip;', '…')
        .replaceAll('&copy;', '©')
        .replaceAll('&reg;', '®')
        .replaceAll('&trade;', '™');
  }
}
