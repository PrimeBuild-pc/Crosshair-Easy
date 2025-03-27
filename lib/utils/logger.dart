import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'constants.dart';

/// Logger utility for application-wide logging
class Logger {
  static const String _logFilename = 'app.log';
  static File? _logFile;
  
  /// Initialize the logger
  static Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${AppConstants.logDirectory}';
      
      // Create log directory if it doesn't exist
      await Directory(path).create(recursive: true);
      
      _logFile = File('$path/$_logFilename');
      
      // Create log file if it doesn't exist
      if (!await _logFile!.exists()) {
        await _logFile!.create();
      }
      
      // Rotate log if needed
      await _rotateLogIfNeeded();
      
      // Write initial log entry
      await info('Logger initialized');
    } catch (e) {
      print('Failed to initialize logger: $e');
    }
  }
  
  /// Log an informational message
  static Future<void> info(String message) async {
    return _log('INFO', message);
  }
  
  /// Log a warning message
  static Future<void> warning(String message) async {
    return _log('WARNING', message);
  }
  
  /// Log an error message with optional exception
  static Future<void> error(String message, [dynamic exception]) async {
    final exceptionText = exception != null ? ': $exception' : '';
    return _log('ERROR', '$message$exceptionText');
  }
  
  /// Internal method to write log entries
  static Future<void> _log(String level, String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $level: $message\n';
    
    // Print to console
    print(logEntry.trim());
    
    // Write to log file if available
    if (_logFile != null) {
      try {
        await _logFile!.writeAsString(
          logEntry,
          mode: FileMode.append,
        );
      } catch (e) {
        print('Failed to write to log file: $e');
      }
    }
  }
  
  /// Rotate log file if it's too large
  static Future<void> _rotateLogIfNeeded() async {
    if (_logFile == null) return;
    
    try {
      final stat = await _logFile!.stat();
      final fileSizeInMB = stat.size / (1024 * 1024);
      
      // Rotate if log is larger than 5MB
      if (fileSizeInMB > 5) {
        final directory = _logFile!.parent;
        final oldPath = _logFile!.path;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newPath = '${directory.path}/app_$timestamp.log';
        
        // Move old log file
        await _logFile!.rename(newPath);
        
        // Create new log file
        _logFile = File(oldPath);
        await _logFile!.create();
        
        await info('Log rotated, old log saved as ${newPath.split('/').last}');
      }
    } catch (e) {
      print('Failed to rotate log: $e');
    }
  }
}