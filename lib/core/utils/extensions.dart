/// Utility extensions for common operations
/// 
/// This file contains extension methods that can be used throughout the app
/// to add functionality to existing types.
library;

extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Checks if the string is a valid email format
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
}

extension DateTimeExtensions on DateTime {
  /// Returns a formatted date string (e.g., "Jan 15, 2024")
  String toFormattedDate() {
    return '${_getMonthName(month)} $day, $year';
  }

  /// Returns the month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
