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
}
