import 'package:intl/intl.dart';

/// Small display helpers shared by screens that show file facts.
///
/// Pure functions so they can be unit-tested without a widget tree.
class DisplayFormat {
  const DisplayFormat._();

  static const List<String> _units = ['B', 'KB', 'MB', 'GB', 'TB'];

  /// Formats a byte count for people: `0 B`, `900 B`, `1.4 KB`, `12.0 MB`.
  ///
  /// Uses 1024-based units (what Android file managers show). Bytes are shown
  /// whole; larger units get one decimal so sizes stay readable at a glance.
  /// A negative count is treated as 0 rather than throwing — this is display
  /// text, and a bad size must never break the screen.
  ///
  /// The number is formatted for [localeName] (engineering standard §8.9).
  static String bytes(int count, [String localeName = 'en']) {
    if (count <= 0) return '${decimal(0, localeName)} ${_units.first}';

    var value = count.toDouble();
    var unit = 0;
    while (value >= 1024 && unit < _units.length - 1) {
      value /= 1024;
      unit++;
    }
    // Bytes are whole things; there is no such thing as half a byte.
    final text = decimal(value, localeName, fractionDigits: unit == 0 ? 0 : 1);
    return '$text ${_units[unit]}';
  }

  /// Formats [value] with exactly [fractionDigits] decimals, using the digits
  /// and decimal mark of [localeName] (engineering standard §8.9).
  static String decimal(
    num value,
    String localeName, {
    int fractionDigits = 0,
  }) {
    final format = NumberFormat.decimalPattern(formattingLocale(localeName))
      ..minimumFractionDigits = fractionDigits
      ..maximumFractionDigits = fractionDigits
      // Plain numbers for settings and sizes: no thousands separator.
      ..turnOffGrouping();
    return format.format(value);
  }

  /// The locale to hand to `intl` (engineering standard §8.3.2). Languages
  /// `intl` has no data for (Sanskrit) are formatted with the template
  /// language's patterns, while the UI text stays translated.
  ///
  /// Order: the full locale in `intl` form (`en_US`, never `en-US`), then its
  /// language code, then the template language.
  static String formattingLocale(String localeName) {
    try {
      final full = Intl.canonicalizedLocale(localeName);
      if (NumberFormat.localeExists(full)) return full;
      final languageCode = full.split('_').first;
      if (NumberFormat.localeExists(languageCode)) return languageCode;
    } catch (_) {
      // A malformed locale name: fall through to the template language.
    }
    return 'en';
  }

  /// Formats a date+time in the reader's locale (e.g. `Jul 14, 2026 16:22`).
  ///
  /// `intl` throws if it has no date symbols for [localeName]. In the running
  /// app `GlobalMaterialLocalizations` loads them for the active locale, but a
  /// display helper must never throw inside a build, so an unknown locale falls
  /// back to the default format instead of breaking the screen.
  static String dateTime(DateTime value, String localeName) {
    final local = value.toLocal();
    try {
      return DateFormat.yMMMd(localeName).add_Hm().format(local);
    } catch (_) {
      // Catches both intl's LocaleDataException (an Exception) and the
      // ArgumentError a malformed locale name raises — hence the bare catch.
      return DateFormat.yMMMd().add_Hm().format(local);
    }
  }
}
