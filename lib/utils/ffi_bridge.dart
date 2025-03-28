import 'logger.dart';

/// Bridge to native code
/// This is a simplified version for web development
class FFIBridge {
  /// Whether the library is loaded
  static bool _isLoaded = false;
  
  /// Initialize the bridge
  static Future<void> initialize() async {
    await Logger.info('Initializing FFI bridge (web mode)');
    _isLoaded = true;
  }
  
  /// Check if the bridge is initialized
  static bool isInitialized() {
    return _isLoaded;
  }
}