import 'dart:convert';
import 'dart:io';

import 'package:characters/characters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const shortPrefixes = ['action', 'label', 'title', 'tab', 'nav', 'tooltip'];
  const limits = {'en': 20, 'ml': 22, 'sa': 22};

  group('Label length tests', () {
    for (final entry in limits.entries) {
      final locale = entry.key;
      final limit = entry.value;

      test('$locale labels do not exceed character limits ($limit chars)', () {
        final path = 'lib/l10n/app_$locale.arb';
        final map =
            jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
        final violations = <String>[];

        for (final item in map.entries) {
          final key = item.key;
          if (key.startsWith('@')) continue;

          final isShortKey = shortPrefixes.any(
            (prefix) => key.startsWith(prefix),
          );
          if (isShortKey) {
            final value = item.value.toString();
            final length = value.characters.length;
            if (length > limit) {
              violations.add('$key (length $length > $limit): "$value"');
            }
          }
        }

        expect(
          violations,
          isEmpty,
          reason:
              'The following keys in $path exceed the $limit-character limit:\n${violations.join('\n')}',
        );
      });
    }
  });

  test('every key names its category with a prefix', () {
    // Engineering standard section 8.6: the prefix decides which keys must
    // stay short, so a key without one would escape the budget check.
    const allPrefixes = [
      ...shortPrefixes,
      'desc',
      'help',
      'empty',
      'error',
      'body',
      'aboutDetail',
    ];
    // Key names fixed by guideline.md section 1.7 (the About badge).
    const fixedNames = {'madeWithLove', 'madeWithLoveA11y'};
    final map = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final missing = [
      for (final key in map.keys)
        if (!key.startsWith('@') &&
            !fixedNames.contains(key) &&
            !allPrefixes.any(
              (p) =>
                  key.startsWith(p) &&
                  key.length > p.length &&
                  RegExp('[A-Z0-9]').hasMatch(key[p.length]),
            ))
          key,
    ];
    expect(
      missing,
      isEmpty,
      reason: 'Keys without a category prefix: $missing',
    );
  });
}
