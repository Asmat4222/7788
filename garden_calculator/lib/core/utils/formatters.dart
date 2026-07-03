import 'package:intl/intl.dart';

/// Formatting helpers used across calculators.
class Formatters {
  Formatters._();

  static final NumberFormat _thousands = NumberFormat.decimalPattern('en_US');

  /// Formats a whole-number sheckle value with thousands separators.
  static String sheckles(num value) {
    return _thousands.format(value.round());
  }

  /// Compact form: 1.2K, 3.4M, 5.6B — handy for big mutation stacks.
  static String compact(num value) {
    final v = value.abs();
    if (v >= 1e12) return '${(value / 1e12).toStringAsFixed(2)}T';
    if (v >= 1e9) return '${(value / 1e9).toStringAsFixed(2)}B';
    if (v >= 1e6) return '${(value / 1e6).toStringAsFixed(2)}M';
    if (v >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
    return _thousands.format(value.round());
  }

  /// Multiplier display, e.g. 2,000× or 1.5×.
  static String multiplier(num value) {
    if (value == value.roundToDouble()) {
      return '${_thousands.format(value.round())}×';
    }
    return '${value.toStringAsFixed(2)}×';
  }

  static String weight(num kg) {
    return '${kg.toStringAsFixed(2)} kg';
  }
}
