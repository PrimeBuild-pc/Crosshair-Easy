import 'package:flutter/material.dart';

/// Constants used throughout the app
class AppConstants {
  // App information
  static const String appName = 'Crosshair Studio';
  static const String appVersion = '1.0.0';
  static const String appCopyright = '© 2025 Crosshair Studio';
  
  // File paths
  static const String logDirectory = 'logs';
  static const String settingsFile = 'settings.json';
  
  // Default values
  static const int defaultExportWidth = 128;
  static const int defaultExportHeight = 128;
  static const double defaultCrosshairSize = 16.0;
  static const double defaultCrosshairThickness = 2.0;
  static const double defaultCrosshairGap = 4.0;
  static const double defaultCrosshairOpacity = 1.0;
  static const double defaultCenterDotSize = 2.0;
  static const double defaultOutlineThickness = 1.0;
  
  // Crosshair options
  static const List<String> crosshairShapes = [
    'Classic',
    'Dot',
    'Circle',
    'Cross',
    'T',
    'Square',
    'Diamond',
  ];
  
  static const List<String> animationTypes = [
    'Pulse',
    'Breathe',
    'Expand',
    'Contract',
    'Rotate',
  ];
  
  static const List<String> supportedExportFormats = [
    'PNG',
    'SVG',
  ];
  
  static const List<Color> defaultColors = [
    Colors.green,
    Colors.white,
    Colors.red,
    Colors.cyan,
    Colors.yellow,
    Colors.pink,
    Colors.purple,
    Colors.orange,
  ];
}