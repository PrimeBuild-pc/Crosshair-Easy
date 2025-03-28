import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/crosshair_model.dart';
import '../models/profile_model.dart';
import '../utils/logger.dart';

/// Service for exporting crosshairs and profiles
class ExportService {
  /// Export a single profile as CSV
  static Future<String> exportProfileAsCsv(
    ProfileModel profile,
    List<CrosshairModel> allCrosshairs,
  ) async {
    try {
      final buffer = StringBuffer();
      buffer.writeln(ProfileModel.csvHeader());
      buffer.write(profile.toCsv(allCrosshairs));
      
      final filePath = await _writeCsvToFile(
        '${profile.name.replaceAll(' ', '_')}_profile.csv',
        buffer.toString(),
      );
      
      Logger.info('Profile exported as CSV: $filePath');
      
      return filePath;
    } catch (e) {
      Logger.error('Failed to export profile as CSV', e);
      rethrow;
    }
  }
  
  /// Export all profiles as CSV
  static Future<String> exportAllProfilesAsCsv(
    List<ProfileModel> profiles,
    List<CrosshairModel> allCrosshairs,
  ) async {
    try {
      final buffer = StringBuffer();
      buffer.writeln(ProfileModel.csvHeader());
      
      for (final profile in profiles) {
        buffer.write(profile.toCsv(allCrosshairs));
        buffer.writeln();
      }
      
      final filePath = await _writeCsvToFile(
        'all_profiles.csv',
        buffer.toString(),
      );
      
      Logger.info('All profiles exported as CSV: $filePath');
      
      return filePath;
    } catch (e) {
      Logger.error('Failed to export all profiles as CSV', e);
      rethrow;
    }
  }
  
  /// Export a single crosshair as CSV
  static Future<String> exportCrosshairAsCsv(CrosshairModel crosshair) async {
    try {
      final buffer = StringBuffer();
      buffer.writeln(CrosshairModel.csvHeader());
      buffer.write(crosshair.toCsv());
      
      final filePath = await _writeCsvToFile(
        '${crosshair.name.replaceAll(' ', '_')}_crosshair.csv',
        buffer.toString(),
      );
      
      Logger.info('Crosshair exported as CSV: $filePath');
      
      return filePath;
    } catch (e) {
      Logger.error('Failed to export crosshair as CSV', e);
      rethrow;
    }
  }
  
  /// Export all crosshairs as CSV
  static Future<String> exportAllCrosshairsAsCsv(
    List<CrosshairModel> crosshairs,
  ) async {
    try {
      final buffer = StringBuffer();
      buffer.writeln(CrosshairModel.csvHeader());
      
      for (final crosshair in crosshairs) {
        buffer.write(crosshair.toCsv());
        buffer.writeln();
      }
      
      final filePath = await _writeCsvToFile(
        'all_crosshairs.csv',
        buffer.toString(),
      );
      
      Logger.info('All crosshairs exported as CSV: $filePath');
      
      return filePath;
    } catch (e) {
      Logger.error('Failed to export all crosshairs as CSV', e);
      rethrow;
    }
  }
  
  /// Copy text to clipboard
  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Logger.info('Text copied to clipboard');
    } catch (e) {
      Logger.error('Failed to copy to clipboard', e);
      rethrow;
    }
  }
  
  /// Write CSV data to a file and return the file path
  static Future<String> _writeCsvToFile(
    String fileName,
    String csvData,
  ) async {
    try {
      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      
      // Create the exports directory if it doesn't exist
      final exportsDir = Directory('${directory.path}/exports');
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }
      
      // Create the file
      final file = File('${exportsDir.path}/$fileName');
      await file.writeAsString(csvData);
      
      return file.path;
    } catch (e) {
      Logger.error('Failed to write CSV to file', e);
      rethrow;
    }
  }
}