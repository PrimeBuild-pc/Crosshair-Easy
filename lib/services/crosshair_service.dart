import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/crosshair_model.dart';
import '../utils/ffi_bridge.dart';
import '../utils/logger.dart';

/// Service class for managing crosshair operations
class CrosshairService {
  static const String _crosshairsDir = 'crosshairs';
  
  /// Generate a crosshair image
  static Future<Uint8List> renderCrosshair(
    CrosshairModel crosshair, {
    required int width,
    required int height,
    Color? backgroundColor,
  }) async {
    try {
      // Use the FFI bridge to render the crosshair
      return await FFIBridge.renderCrosshair(
        shape: crosshair.shape,
        size: crosshair.size.toInt(),
        thickness: crosshair.thickness.toInt(),
        gap: crosshair.gap.toInt(),
        opacity: (crosshair.opacity * 255).toInt(),
        centerDotSize: crosshair.centerDotSize.toInt(),
        outline: crosshair.outline,
        outlineThickness: crosshair.outlineThickness.toInt(),
        color: crosshair.color.value,
        outlineColor: crosshair.outlineColor.value,
        backgroundColor: backgroundColor?.value ?? Colors.transparent.value,
      );
    } catch (e) {
      await Logger.error('Failed to render crosshair', e);
      rethrow;
    }
  }
  
  /// Export a crosshair to a PNG file
  static Future<String> exportPNG(
    CrosshairModel crosshair, {
    required int width,
    required int height,
    Color? backgroundColor,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$_crosshairsDir';
      
      // Create directory if it doesn't exist
      await Directory(path).create(recursive: true);
      
      // Generate the crosshair image
      final imageData = await renderCrosshair(
        crosshair,
        width: width,
        height: height,
        backgroundColor: backgroundColor,
      );
      
      // Create a unique filename based on crosshair properties
      final filename = '${crosshair.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '$path/$filename';
      
      // Write to file
      final file = File(filePath);
      await file.writeAsBytes(imageData);
      
      await Logger.info('Exported crosshair to $filePath');
      return filePath;
    } catch (e) {
      await Logger.error('Failed to export PNG', e);
      rethrow;
    }
  }
  
  /// Export a crosshair to an SVG file
  static Future<String> exportSVG(
    CrosshairModel crosshair, {
    Color? backgroundColor,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$_crosshairsDir';
      
      // Create directory if it doesn't exist
      await Directory(path).create(recursive: true);
      
      // Create a unique filename based on crosshair properties
      final filename = '${crosshair.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.svg';
      final filePath = '$path/$filename';
      
      // Generate SVG content
      final svgContent = _generateSVG(crosshair, backgroundColor: backgroundColor);
      
      // Write to file
      final file = File(filePath);
      await file.writeAsString(svgContent);
      
      await Logger.info('Exported SVG to $filePath');
      return filePath;
    } catch (e) {
      await Logger.error('Failed to export SVG', e);
      rethrow;
    }
  }
  
  /// Generate SVG content for a crosshair
  static String _generateSVG(
    CrosshairModel crosshair, {
    Color? backgroundColor,
  }) {
    final width = 128;
    final height = 128;
    final centerX = width / 2;
    final centerY = height / 2;
    
    // Background element
    final backgroundElement = backgroundColor != null
        ? '<rect width="$width" height="$height" fill="${_colorToHex(backgroundColor)}" />'
        : '';
    
    // SVG elements based on shape
    String elements;
    
    switch (crosshair.shape) {
      case 'Classic':
        elements = _generateClassicSVG(crosshair, centerX, centerY);
        break;
      case 'Dot':
        elements = _generateDotSVG(crosshair, centerX, centerY);
        break;
      case 'Circle':
        elements = _generateCircleSVG(crosshair, centerX, centerY);
        break;
      // Add other shapes as needed
      default:
        elements = _generateClassicSVG(crosshair, centerX, centerY);
    }
    
    // Combine elements into SVG document
    return '''
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg width="$width" height="$height" viewBox="0 0 $width $height" xmlns="http://www.w3.org/2000/svg">
  $backgroundElement
  $elements
</svg>
''';
  }
  
  // Generate SVG elements for a classic crosshair
  static String _generateClassicSVG(CrosshairModel crosshair, double centerX, double centerY) {
    final elements = <String>[];
    
    // Add outline elements if enabled
    if (crosshair.outline) {
      // Horizontal outline
      elements.add('''
<rect 
  x="${centerX - crosshair.size}" 
  y="${centerY - crosshair.thickness / 2 - crosshair.outlineThickness}" 
  width="${crosshair.size * 2}" 
  height="${crosshair.thickness + crosshair.outlineThickness * 2}" 
  fill="${_colorToHex(crosshair.outlineColor)}" 
  opacity="${crosshair.opacity}"
/>
''');
      
      // Vertical outline
      elements.add('''
<rect 
  x="${centerX - crosshair.thickness / 2 - crosshair.outlineThickness}" 
  y="${centerY - crosshair.size}" 
  width="${crosshair.thickness + crosshair.outlineThickness * 2}" 
  height="${crosshair.size * 2}" 
  fill="${_colorToHex(crosshair.outlineColor)}" 
  opacity="${crosshair.opacity}"
/>
''');
    }
    
    // Horizontal line
    elements.add('''
<rect 
  x="${centerX - crosshair.size}" 
  y="${centerY - crosshair.thickness / 2}" 
  width="${crosshair.size * 2}" 
  height="${crosshair.thickness}" 
  fill="${_colorToHex(crosshair.color)}" 
  opacity="${crosshair.opacity}"
/>
''');
    
    // Vertical line
    elements.add('''
<rect 
  x="${centerX - crosshair.thickness / 2}" 
  y="${centerY - crosshair.size}" 
  width="${crosshair.thickness}" 
  height="${crosshair.size * 2}" 
  fill="${_colorToHex(crosshair.color)}" 
  opacity="${crosshair.opacity}"
/>
''');
    
    // Center dot
    if (crosshair.showCenterDot) {
      if (crosshair.outline) {
        elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.centerDotSize + crosshair.outlineThickness}" 
  fill="${_colorToHex(crosshair.outlineColor)}" 
  opacity="${crosshair.opacity}"
/>
''');
      }
      
      elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.centerDotSize}" 
  fill="${_colorToHex(crosshair.color)}" 
  opacity="${crosshair.opacity}"
/>
''');
    }
    
    return elements.join('\n');
  }
  
  // Generate SVG elements for a dot crosshair
  static String _generateDotSVG(CrosshairModel crosshair, double centerX, double centerY) {
    final elements = <String>[];
    
    if (crosshair.outline) {
      elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.size / 3 + crosshair.outlineThickness}" 
  fill="${_colorToHex(crosshair.outlineColor)}" 
  opacity="${crosshair.opacity}"
/>
''');
    }
    
    elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.size / 3}" 
  fill="${_colorToHex(crosshair.color)}" 
  opacity="${crosshair.opacity}"
/>
''');
    
    return elements.join('\n');
  }
  
  // Generate SVG elements for a circle crosshair
  static String _generateCircleSVG(CrosshairModel crosshair, double centerX, double centerY) {
    final elements = <String>[];
    
    if (crosshair.outline) {
      elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.size / 2}" 
  stroke="${_colorToHex(crosshair.outlineColor)}" 
  stroke-width="${crosshair.thickness + crosshair.outlineThickness * 2}" 
  fill="none" 
  opacity="${crosshair.opacity}"
/>
''');
    }
    
    elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.size / 2}" 
  stroke="${_colorToHex(crosshair.color)}" 
  stroke-width="${crosshair.thickness}" 
  fill="none" 
  opacity="${crosshair.opacity}"
/>
''');
    
    if (crosshair.showCenterDot) {
      if (crosshair.outline) {
        elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.centerDotSize + crosshair.outlineThickness}" 
  fill="${_colorToHex(crosshair.outlineColor)}" 
  opacity="${crosshair.opacity}"
/>
''');
      }
      
      elements.add('''
<circle 
  cx="$centerX" 
  cy="$centerY" 
  r="${crosshair.centerDotSize}" 
  fill="${_colorToHex(crosshair.color)}" 
  opacity="${crosshair.opacity}"
/>
''');
    }
    
    return elements.join('\n');
  }
  
  // Convert a color to hex string
  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}