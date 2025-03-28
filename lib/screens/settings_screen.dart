import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  /// Create a new settings screen
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSave = true;
  bool _darkTheme = true;
  bool _enableAnimations = true;
  bool _allowBackgroundUsage = false;
  bool _isResetting = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        _autoSave = prefs.getBool('settings_auto_save') ?? true;
        _darkTheme = prefs.getBool('settings_dark_theme') ?? true;
        _enableAnimations = prefs.getBool('settings_enable_animations') ?? true;
        _allowBackgroundUsage = prefs.getBool('settings_allow_background_usage') ?? false;
      });
    } catch (e) {
      await Logger.error('Failed to load settings', e);
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('settings_auto_save', _autoSave);
      await prefs.setBool('settings_dark_theme', _darkTheme);
      await prefs.setBool('settings_enable_animations', _enableAnimations);
      await prefs.setBool('settings_allow_background_usage', _allowBackgroundUsage);
      
      await Logger.info('Settings saved');
    } catch (e) {
      await Logger.error('Failed to save settings', e);
    }
  }
  
  Future<void> _resetSettings() async {
    try {
      setState(() {
        _isResetting = true;
      });
      
      final prefs = await SharedPreferences.getInstance();
      
      // Reset settings to default values
      await prefs.setBool('settings_auto_save', true);
      await prefs.setBool('settings_dark_theme', true);
      await prefs.setBool('settings_enable_animations', true);
      await prefs.setBool('settings_allow_background_usage', false);
      
      // Reload settings
      await _loadSettings();
      
      await Logger.info('Settings reset to defaults');
      
      setState(() {
        _isResetting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings reset to defaults'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      await Logger.error('Failed to reset settings', e);
      
      setState(() {
        _isResetting = false;
      });
    }
  }
  
  Future<void> _confirmResetSettings() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      await _resetSettings();
    }
  }
  
  Future<void> _clearAllData() async {
    try {
      setState(() {
        _isResetting = true;
      });
      
      final prefs = await SharedPreferences.getInstance();
      
      // Clear all data (profiles, crosshairs, settings)
      await prefs.clear();
      
      // Restore default settings
      await _resetSettings();
      
      await Logger.info('All data cleared');
      
      setState(() {
        _isResetting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data has been cleared'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      await Logger.error('Failed to clear all data', e);
      
      setState(() {
        _isResetting = false;
      });
    }
  }
  
  Future<void> _confirmClearAllData() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to clear all data? This will delete all profiles, crosshairs, and settings. This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      await _clearAllData();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isResetting
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // General settings
                _buildSectionHeader('General'),
                SwitchListTile(
                  title: const Text('Auto-save changes'),
                  subtitle: const Text('Automatically save changes to crosshairs'),
                  value: _autoSave,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _autoSave = value;
                    });
                    _saveSettings();
                  },
                ),
                const Divider(),
                
                // Appearance settings
                _buildSectionHeader('Appearance'),
                SwitchListTile(
                  title: const Text('Dark theme'),
                  subtitle: const Text('Use dark theme for the application'),
                  value: _darkTheme,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _darkTheme = value;
                    });
                    _saveSettings();
                  },
                ),
                SwitchListTile(
                  title: const Text('Enable animations'),
                  subtitle: const Text('Show animations in the UI'),
                  value: _enableAnimations,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _enableAnimations = value;
                    });
                    _saveSettings();
                  },
                ),
                const Divider(),
                
                // Performance settings
                _buildSectionHeader('Performance'),
                SwitchListTile(
                  title: const Text('Allow background usage'),
                  subtitle: const Text('Allow the app to run in the background'),
                  value: _allowBackgroundUsage,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _allowBackgroundUsage = value;
                    });
                    _saveSettings();
                  },
                ),
                const Divider(),
                
                // About section
                _buildSectionHeader('About'),
                ListTile(
                  title: const Text('Version'),
                  subtitle: const Text(Constants.appVersion),
                  leading: const Icon(Icons.info),
                ),
                ListTile(
                  title: const Text('Author'),
                  subtitle: const Text(Constants.appAuthor),
                  leading: const Icon(Icons.person),
                ),
                // GitHub repository
                ListTile(
                  title: const Text('GitHub Repository'),
                  subtitle: const Text(Constants.appRepositoryUrl),
                  leading: const Icon(Icons.code),
                  onTap: () {
                    // Open GitHub repository
                  },
                ),
                // Website
                ListTile(
                  title: const Text('Website'),
                  subtitle: const Text(Constants.appWebsiteUrl),
                  leading: const Icon(Icons.language),
                  onTap: () {
                    // Open website
                  },
                ),
                const Divider(),
                
                // Reset section
                _buildSectionHeader('Reset'),
                ListTile(
                  title: const Text('Reset Settings'),
                  subtitle: const Text('Reset all settings to default values'),
                  leading: const Icon(Icons.refresh),
                  onTap: _confirmResetSettings,
                ),
                ListTile(
                  title: const Text('Clear All Data'),
                  subtitle: const Text('Delete all profiles, crosshairs, and settings'),
                  leading: const Icon(Icons.delete_forever),
                  onTap: _confirmClearAllData,
                  textColor: Colors.red,
                  iconColor: Colors.red,
                ),
              ],
            ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}