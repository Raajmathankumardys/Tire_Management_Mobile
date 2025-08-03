import 'package:intl/intl.dart';

class EpochDateConverter {
  /// Converts epoch seconds (int or string) to DateTime.
  static DateTime? fromEpochSeconds(dynamic value) {
    try {
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      } else if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return DateTime.fromMillisecondsSinceEpoch(parsed * 1000);
        }
      }
    } catch (_) {
      // Handle invalid inputs
    }
    return null; // Return null if invalid
  }

  String formatEpoch(int epochSeconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  /// Converts DateTime to epoch seconds
  static int toEpochSeconds(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  /// Validates if input is a valid epoch second (int or string)
  static bool isValidEpochSecond(dynamic value) {
    final epoch =
        (value is int) ? value : (value is String ? int.tryParse(value) : null);
    if (epoch == null) return false;

    try {
      final dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
      return dt.isAfter(DateTime.fromMillisecondsSinceEpoch(0));
    } catch (_) {
      return false;
    }
  }

  /// Validates if input is a valid DateTime
  static bool isValidDateTime(dynamic value) {
    if (value is DateTime) return true;
    if (value is String) {
      try {
        DateTime.parse(value);
        return true;
      } catch (_) {}
    }
    return false;
  }
}
