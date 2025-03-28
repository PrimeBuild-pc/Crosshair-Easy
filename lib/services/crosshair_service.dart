import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crosshair_model.dart';
import '../utils/logger.dart';

/// Service for managing crosshairs
class CrosshairService extends ChangeNotifier {
  /// The list of crosshairs
  final List<CrosshairModel> _crosshairs = [];
  
  /// The shared preferences key
  static const String _prefsKey = 'crosshairs';
  
  /// Get the list of crosshairs
  List<CrosshairModel> get crosshairs => List.unmodifiable(_crosshairs);
  
  /// Initialize the service
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final crosshairsJson = prefs.getStringList(_prefsKey) ?? [];
      
      _crosshairs.clear();
      
      for (final json in crosshairsJson) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          final crosshair = CrosshairModel.fromMap(map);
          _crosshairs.add(crosshair);
        } catch (e) {
          Logger.error('Failed to parse crosshair: $e');
        }
      }
      
      if (_crosshairs.isEmpty) {
        _addDefaultCrosshairs();
      }
      
      notifyListeners();
    } catch (e) {
      Logger.error('Failed to initialize crosshair service: $e');
    }
  }
  
  /// Save the crosshairs
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final crosshairsJson = _crosshairs.map((c) => jsonEncode(c.toMap())).toList();
      await prefs.setStringList(_prefsKey, crosshairsJson);
    } catch (e) {
      Logger.error('Failed to save crosshairs: $e');
    }
  }
  
  /// Add a crosshair
  Future<CrosshairModel> addCrosshair(CrosshairModel crosshair) async {
    _crosshairs.add(crosshair);
    notifyListeners();
    await _save();
    return crosshair;
  }
  
  /// Update a crosshair
  Future<void> updateCrosshair(CrosshairModel crosshair) async {
    final index = _crosshairs.indexWhere((c) => c.id == crosshair.id);
    
    if (index != -1) {
      _crosshairs[index] = crosshair;
      notifyListeners();
      await _save();
    }
  }
  
  /// Delete a crosshair
  Future<void> deleteCrosshair(String id) async {
    _crosshairs.removeWhere((c) => c.id == id);
    notifyListeners();
    await _save();
  }
  
  /// Get a crosshair by ID
  CrosshairModel? getCrosshairById(String id) {
    try {
      return _crosshairs.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Add default crosshairs
  void _addDefaultCrosshairs() {
    _crosshairs.add(CrosshairModel(
      name: 'Default Classic',
      color: Colors.lime,
      shape: CrosshairShape.classic,
    ));
    
    _crosshairs.add(CrosshairModel(
      name: 'Red Dot',
      color: Colors.red,
      shape: CrosshairShape.dot,
      showDot: true,
      dotSize: 3.0,
      dotColor: Colors.red,
    ));
    
    _crosshairs.add(CrosshairModel(
      name: 'Blue Circle',
      color: Colors.blue,
      shape: CrosshairShape.circle,
      thickness: 1.5,
    ));
  }
}