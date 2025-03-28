import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';
import '../utils/logger.dart';

/// Service for managing profiles
class ProfileService extends ChangeNotifier {
  /// The list of profiles
  final List<ProfileModel> _profiles = [];
  
  /// The ID of the active profile
  String? _activeProfileId;
  
  /// The shared preferences key for profiles
  static const String _profilesPrefsKey = 'profiles';
  
  /// The shared preferences key for the active profile ID
  static const String _activeProfilePrefsKey = 'activeProfileId';
  
  /// Get the list of profiles
  List<ProfileModel> get profiles => List.unmodifiable(_profiles);
  
  /// Get the active profile
  ProfileModel? get activeProfile {
    if (_activeProfileId == null) {
      return _profiles.isNotEmpty ? _profiles.first : null;
    }
    
    try {
      return _profiles.firstWhere((p) => p.id == _activeProfileId);
    } catch (e) {
      return _profiles.isNotEmpty ? _profiles.first : null;
    }
  }
  
  /// Initialize the service
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getStringList(_profilesPrefsKey) ?? [];
      final activeProfileId = prefs.getString(_activeProfilePrefsKey);
      
      _profiles.clear();
      
      for (final json in profilesJson) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          final profile = ProfileModel.fromMap(map);
          _profiles.add(profile);
        } catch (e) {
          Logger.error('Failed to parse profile: $e');
        }
      }
      
      if (_profiles.isEmpty) {
        _addDefaultProfile();
      }
      
      _activeProfileId = activeProfileId ?? _profiles.first.id;
      
      notifyListeners();
    } catch (e) {
      Logger.error('Failed to initialize profile service: $e');
    }
  }
  
  /// Save the profiles
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = _profiles.map((p) => jsonEncode(p.toMap())).toList();
      await prefs.setStringList(_profilesPrefsKey, profilesJson);
      
      if (_activeProfileId != null) {
        await prefs.setString(_activeProfilePrefsKey, _activeProfileId!);
      }
    } catch (e) {
      Logger.error('Failed to save profiles: $e');
    }
  }
  
  /// Add a profile
  Future<ProfileModel> addProfile(ProfileModel profile) async {
    _profiles.add(profile);
    
    if (_profiles.length == 1) {
      _activeProfileId = profile.id;
    }
    
    notifyListeners();
    await _save();
    return profile;
  }
  
  /// Update a profile
  Future<void> updateProfile(ProfileModel profile) async {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    
    if (index != -1) {
      _profiles[index] = profile;
      notifyListeners();
      await _save();
    }
  }
  
  /// Delete a profile
  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    
    if (_activeProfileId == id) {
      _activeProfileId = _profiles.isNotEmpty ? _profiles.first.id : null;
    }
    
    notifyListeners();
    await _save();
  }
  
  /// Set the active profile
  Future<void> setActiveProfile(String id) async {
    final profile = getProfileById(id);
    
    if (profile != null) {
      _activeProfileId = id;
      notifyListeners();
      await _save();
    }
  }
  
  /// Get a profile by ID
  ProfileModel? getProfileById(String id) {
    try {
      return _profiles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Add a crosshair to a profile
  Future<void> addCrosshairToProfile(String profileId, String crosshairId) async {
    final profile = getProfileById(profileId);
    
    if (profile != null) {
      profile.addCrosshairId(crosshairId);
      
      if (profile.activeCrosshairId == null) {
        profile.activeCrosshairId = crosshairId;
      }
      
      notifyListeners();
      await _save();
    }
  }
  
  /// Remove a crosshair from a profile
  Future<void> removeCrosshairFromProfile(String profileId, String crosshairId) async {
    final profile = getProfileById(profileId);
    
    if (profile != null) {
      profile.removeCrosshairId(crosshairId);
      notifyListeners();
      await _save();
    }
  }
  
  /// Set the active crosshair for a profile
  Future<void> setActiveCrosshairForProfile(String profileId, String crosshairId) async {
    final profile = getProfileById(profileId);
    
    if (profile != null) {
      profile.setActiveCrosshairId(crosshairId);
      notifyListeners();
      await _save();
    }
  }
  
  /// Add default profile
  void _addDefaultProfile() {
    _profiles.add(ProfileModel(
      name: 'Default Profile',
      description: 'Default profile with predefined crosshairs',
    ));
  }
}