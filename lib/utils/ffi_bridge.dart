import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'logger.dart';

/// Bridge to native code
class FFIBridge {
  /// The library
  static late DynamicLibrary _library;
  
  /// Whether the library is loaded
  static bool _isLoaded = false;
  
  /// Get the library path
  static String get _libraryPath {
    if (Platform.isWindows) {
      return 'native/crosshair_engine.dll';
    } else if (Platform.isLinux) {
      return 'native/libcrosshair_engine.so';
    } else if (Platform.isMacOS) {
      return 'native/libcrosshair_engine.dylib';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  
  /// Load the library
  static bool load() {
    if (_isLoaded) {
      return true;
    }
    
    try {
      _library = DynamicLibrary.open(_libraryPath);
      _isLoaded = true;
      Logger.info('Loaded native library');
      return true;
    } catch (e) {
      Logger.error('Failed to load native library: $e');
      return false;
    }
  }
  
  /// Call a native function
  static T call<T>(String name, {required T Function(Function) converter}) {
    if (!_isLoaded && !load()) {
      throw StateError('Native library not loaded');
    }
    
    try {
      final function = _library.lookupFunction<NativeFunction, Function>(name);
      return converter(function);
    } catch (e) {
      Logger.error('Failed to call native function $name: $e');
      rethrow;
    }
  }
}