/// A simple logger class
class Logger {
  /// Log a debug message
  static void debug(String message) {
    _log('DEBUG', message);
  }
  
  /// Log an info message
  static Future<void> info(String message) async {
    _log('INFO', message);
  }
  
  /// Log a warning message
  static void warn(String message) {
    _log('WARN', message);
  }
  
  /// Log an error message
  static Future<void> error(String message, [dynamic exception]) async {
    if (exception != null) {
      _log('ERROR', '$message: $exception');
    } else {
      _log('ERROR', message);
    }
  }
  
  /// Log a message with the given level
  static void _log(String level, String message) {
    final date = DateTime.now().toIso8601String();
    // ignore: avoid_print
    print('[$date] $level: $message');
  }
}