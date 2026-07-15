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
  static String bytes(int count) {
    if (count <= 0) return '0 ${_units.first}';

    var value = count.toDouble();
    var unit = 0;
    while (value >= 1024 && unit < _units.length - 1) {
      value /= 1024;
      unit++;
    }
    // Bytes are whole things; there is no such thing as half a byte.
    final text = unit == 0
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '$text ${_units[unit]}';
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
