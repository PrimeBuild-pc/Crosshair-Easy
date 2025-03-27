import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/profile_model.dart';
import '../utils/logger.dart';

/// Service class for managing profiles
class ProfileService {
  static const String _profilesDir = 'profiles';
  static const String _lastProfileKey = 'last_profile';
  
  /// Get the path to the profiles directory
  static Future<String> _getProfilesPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$_profilesDir';
    
    // Create directory if it doesn't exist
    await Directory(path).create(recursive: true);
    
    return path;
  }
  
  /// Save a profile to disk
  static Future<void> saveProfile(ProfileModel profile) async {
    try {
      final path = await _getProfilesPath();
      final file = File('$path/${profile.id}.json');
      
      // Convert profile to JSON string
      final jsonString = jsonEncode(profile.toJson());
      
      // Write to file
      await file.writeAsString(jsonString);
      
      // Update last used profile
      await _saveLastUsedProfile(profile.id);
      
      await Logger.info('Saved profile: ${profile.name}');
    } catch (e) {
      await Logger.error('Failed to save profile', e);
      rethrow;
    }
  }
  
  /// Load a profile from disk
  static Future<ProfileModel?> loadProfile(String profileId) async {
    try {
      final path = await _getProfilesPath();
      final file = File('$path/$profileId.json');
      
      if (!await file.exists()) {
        await Logger.warning('Profile not found: $profileId');
        return null;
      }
      
      // Read JSON string from file
      final jsonString = await file.readAsString();
      
      // Parse JSON to profile
      final json = jsonDecode(jsonString);
      return ProfileModel.fromJson(json);
    } catch (e) {
      await Logger.error('Failed to load profile', e);
      return null;
    }
  }
  
  /// Delete a profile from disk
  static Future<bool> deleteProfile(String profileId) async {
    try {
      final path = await _getProfilesPath();
      final file = File('$path/$profileId.json');
      
      if (await file.exists()) {
        await file.delete();
        await Logger.info('Deleted profile: $profileId');
        return true;
      } else {
        await Logger.warning('Profile not found for deletion: $profileId');
        return false;
      }
    } catch (e) {
      await Logger.error('Failed to delete profile', e);
      return false;
    }
  }
  
  /// Load all profiles from disk
  static Future<List<ProfileModel>> loadAllProfiles() async {
    try {
      final path = await _getProfilesPath();
      final directory = Directory(path);
      
      if (!await directory.exists()) {
        await Logger.info('Profiles directory does not exist, creating it');
        await directory.create(recursive: true);
        return [];
      }
      
      final profiles = <ProfileModel>[];
      
      // List all .json files in the profiles directory
      await for (final file in directory.list()) {
        if (file is File && file.path.endsWith('.json')) {
          try {
            // Read and parse the profile
            final jsonString = await file.readAsString();
            final json = jsonDecode(jsonString);
            profiles.add(ProfileModel.fromJson(json));
          } catch (e) {
            await Logger.error('Failed to parse profile file: ${file.path}', e);
            // Continue with the next file
          }
        }
      }
      
      // Sort profiles (favorites first, then by name)
      profiles.sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1;
        if (!a.isFavorite && b.isFavorite) return 1;
        return a.name.compareTo(b.name);
      });
      
      await Logger.info('Loaded ${profiles.length} profiles');
      return profiles;
    } catch (e) {
      await Logger.error('Failed to load profiles', e);
      return [];
    }
  }
  
  /// Save the ID of the last used profile
  static Future<void> _saveLastUsedProfile(String profileId) async {
    try {
      final path = await _getProfilesPath();
      final file = File('$path/$_lastProfileKey.txt');
      
      // Write profile ID to file
      await file.writeAsString(profileId);
    } catch (e) {
      await Logger.error('Failed to save last used profile', e);
    }
  }
  
  /// Get the ID of the last used profile
  static Future<String?> getLastUsedProfileId() async {
    try {
      final path = await _getProfilesPath();
      final file = File('$path/$_lastProfileKey.txt');
      
      if (!await file.exists()) {
        return null;
      }
      
      // Read profile ID from file
      return await file.readAsString();
    } catch (e) {
      await Logger.error('Failed to get last used profile', e);
      return null;
    }
  }
  
  /// Initialize default profile if no profiles exist
  static Future<ProfileModel> initializeDefaultProfile() async {
    try {
      final profiles = await loadAllProfiles();
      
      if (profiles.isEmpty) {
        // Create default profile
        final defaultProfile = ProfileModel.defaultProfile();
        await saveProfile(defaultProfile);
        return defaultProfile;
      } else {
        // Try to load last used profile
        final lastProfileId = await getLastUsedProfileId();
        if (lastProfileId != null) {
          final lastProfile = await loadProfile(lastProfileId);
          if (lastProfile != null) {
            return lastProfile;
          }
        }
        
        // Use the first profile if last used not found
        return profiles.first;
      }
    } catch (e) {
      await Logger.error('Failed to initialize default profile', e);
      // Return a new default profile if everything fails
      return ProfileModel.defaultProfile();
    }
  }
}