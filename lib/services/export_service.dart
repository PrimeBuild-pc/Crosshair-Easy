import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/crosshair_model.dart';
import '../utils/logger.dart';
import 'crosshair_service.dart';

/// Service class for exporting crosshairs
class ExportService {
  static const String _exportsDir = 'exports';
  static const int _maxExportHistory = 20;
  
  /// Export a crosshair to a file
  static Future<String> exportCrosshair(
    CrosshairModel crosshair, {
    required String format,
    required int width,
    required int height,
    Color? backgroundColor,
  }) async {
    try {
      String exportPath;
      
      // Use the appropriate export method based on format
      if (format.toUpperCase() == 'PNG') {
        exportPath = await CrosshairService.exportPNG(
          crosshair,
          width: width,
          height: height,
          backgroundColor: backgroundColor,
        );
      } else if (format.toUpperCase() == 'SVG') {
        exportPath = await CrosshairService.exportSVG(
          crosshair,
          backgroundColor: backgroundColor,
        );
      } else {
        throw UnsupportedError('Unsupported export format: $format');
      }
      
      // Add to export history
      await _addToExportHistory(exportPath);
      
      return exportPath;
    } catch (e) {
      await Logger.error('Failed to export crosshair', e);
      rethrow;
    }
  }
  
  /// Get the path to the exports directory
  static Future<String> _getExportsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$_exportsDir';
    
    // Create directory if it doesn't exist
    await Directory(path).create(recursive: true);
    
    return path;
  }
  
  /// Add a file path to the export history
  static Future<void> _addToExportHistory(String filePath) async {
    try {
      final path = await _getExportsPath();
      final historyFile = File('$path/history.txt');
      
      List<String> history = [];
      
      // Read existing history if it exists
      if (await historyFile.exists()) {
        final content = await historyFile.readAsString();
        history = content.split('\n')
            .where((line) => line.isNotEmpty)
            .toList();
      }
      
      // Add new export to history
      history.insert(0, filePath);
      
      // Limit history size
      if (history.length > _maxExportHistory) {
        history = history.sublist(0, _maxExportHistory);
      }
      
      // Write updated history
      await historyFile.writeAsString(history.join('\n'));
    } catch (e) {
      await Logger.error('Failed to add to export history', e);
    }
  }
  
  /// Get the export history
  static Future<List<String>> getExportHistory() async {
    try {
      final path = await _getExportsPath();
      final historyFile = File('$path/history.txt');
      
      if (!await historyFile.exists()) {
        return [];
      }
      
      final content = await historyFile.readAsString();
      
      // Split by lines and filter out empty lines
      final history = content.split('\n')
          .where((line) => line.isNotEmpty)
          .toList();
      
      // Filter out files that no longer exist
      final filteredHistory = <String>[];
      for (final filePath in history) {
        if (await File(filePath).exists()) {
          filteredHistory.add(filePath);
        }
      }
      
      // Update history file if items were filtered out
      if (filteredHistory.length != history.length) {
        await historyFile.writeAsString(filteredHistory.join('\n'));
      }
      
      return filteredHistory;
    } catch (e) {
      await Logger.error('Failed to get export history', e);
      return [];
    }
  }
  
  /// Copy a crosshair as text to the clipboard
  static Future<void> copyToClipboard(CrosshairModel crosshair) async {
    try {
      // Create a simple text representation of the crosshair settings
      final text = '''
Crosshair: ${crosshair.name}
Shape: ${crosshair.shape}
Size: ${crosshair.size}
Thickness: ${crosshair.thickness}
Gap: ${crosshair.gap}
Opacity: ${(crosshair.opacity * 100).toInt()}%
Color: ${_colorToString(crosshair.color)}
Outline: ${crosshair.outline ? 'Yes' : 'No'}
${crosshair.outline ? 'Outline Thickness: ${crosshair.outlineThickness}' : ''}
${crosshair.outline ? 'Outline Color: ${_colorToString(crosshair.outlineColor)}' : ''}
Center Dot: ${crosshair.showCenterDot ? 'Yes' : 'No'}
${crosshair.showCenterDot ? 'Center Dot Size: ${crosshair.centerDotSize}' : ''}
      '''.trim();
      
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: text));
      
      await Logger.info('Copied crosshair to clipboard');
    } catch (e) {
      await Logger.error('Failed to copy to clipboard', e);
      rethrow;
    }
  }
  
  /// Convert a color to a string representation
  static String _colorToString(Color color) {
    return 'RGB(${color.red}, ${color.green}, ${color.blue})';
  }
}