import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../models/profile_model.dart';
import '../models/crosshair_model.dart';
import '../utils/logger.dart';

/// Service for exporting crosshairs and profiles
class ExportService {
  /// Get the documents directory
  static Future<Directory> get _documentsDir async =>
    await getApplicationDocumentsDirectory();
  
  /// Get the export directory
  static Future<Directory> get _exportDir async {
    final docsDir = await _documentsDir;
    final exportDir = Directory('${docsDir.path}/exported_crosshairs');
    
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    
    return exportDir;
  }
  
  /// Export a profile as CSV
  static Future<String> exportProfileAsCsv(
    ProfileModel profile,
    List<CrosshairModel> crosshairs,
  ) async {
    try {
      final exportDir = await _exportDir;
      final dateFormat = DateFormat('yyyyMMdd_HHmmss');
      final fileName = '${profile.name.replaceAll(' ', '_')}_${dateFormat.format(DateTime.now())}.csv';
      final file = File('${exportDir.path}/$fileName');
      
      final csv = StringBuffer();
      csv.writeln(ProfileModel.csvHeader());
      csv.write(profile.toCsv(crosshairs));
      
      await file.writeAsString(csv.toString());
      Logger.info('Exported profile to ${file.path}');
      
      return file.path;
    } catch (e) {
      Logger.error('Failed to export profile: $e');
      rethrow;
    }
  }
  
  /// Export a crosshair as CSV
  static Future<String> exportCrosshairAsCsv(CrosshairModel crosshair) async {
    try {
      final exportDir = await _exportDir;
      final dateFormat = DateFormat('yyyyMMdd_HHmmss');
      final fileName = '${crosshair.name.replaceAll(' ', '_')}_${dateFormat.format(DateTime.now())}.csv';
      final file = File('${exportDir.path}/$fileName');
      
      final csv = StringBuffer();
      csv.writeln(CrosshairModel.csvHeader());
      csv.writeln(crosshair.toCsv());
      
      await file.writeAsString(csv.toString());
      Logger.info('Exported crosshair to ${file.path}');
      
      return file.path;
    } catch (e) {
      Logger.error('Failed to export crosshair: $e');
      rethrow;
    }
  }
  
  /// Copy to clipboard
  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Logger.info('Copied to clipboard');
    } catch (e) {
      Logger.error('Failed to copy to clipboard: $e');
      rethrow;
    }
  }
  
  /// Export all profiles as CSV
  static Future<String> exportAllProfilesAsCsv(
    List<ProfileModel> profiles,
    List<CrosshairModel> crosshairs,
  ) async {
    try {
      final exportDir = await _exportDir;
      final dateFormat = DateFormat('yyyyMMdd_HHmmss');
      final fileName = 'all_profiles_${dateFormat.format(DateTime.now())}.csv';
      final file = File('${exportDir.path}/$fileName');
      
      final csv = StringBuffer();
      csv.writeln(ProfileModel.csvHeader());
      
      for (final profile in profiles) {
        csv.write(profile.toCsv(crosshairs));
        csv.writeln();
      }
      
      await file.writeAsString(csv.toString());
      Logger.info('Exported all profiles to ${file.path}');
      
      return file.path;
    } catch (e) {
      Logger.error('Failed to export all profiles: $e');
      rethrow;
    }
  }
}