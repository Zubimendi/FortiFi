/// Simple logger utility
class Logger {
  static void info(String message) {
    print('[INFO] $message');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    print('[ERROR] $message');
    if (error != null) {
      print('Error: $error');
    }
    if (stackTrace != null) {
      print('Stack: $stackTrace');
    }
  }

  static void debug(String message) {
    print('[DEBUG] $message');
  }
}
