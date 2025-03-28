import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/crosshair_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

/// The settings screen
class SettingsScreen extends StatefulWidget {
  /// Create a new settings screen
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Autosave settings
  bool _autoSave = true;
  
  // Autosave interval in seconds
  int _autoSaveInterval = 60;
  
  // Performance mode
  bool _performanceMode = false;
  
  // Show debug info
  bool _showDebugInfo = false;
  
  // Show tooltips
  bool _showTooltips = true;
  
  // Show animation for crosshair preview
  bool _showAnimation = true;
  
  // Export settings
  bool _includeMetadata = true;
  
  // Default export format
  String _defaultExportFormat = 'CSV';
  
  // Theme settings
  String _theme = 'Dark';
  
  // Cache size
  int _cacheSize = 100;
  
  // Whether any changes were made and not saved yet
  bool _hasChanges = false;
  
  @override
  void initState() {
    super.initState();
    
    // Load settings
    _loadSettings();
  }
  
  /// Load settings from preferences
  void _loadSettings() {
    // In a real app, we would load these from shared preferences
    // For now, we'll just use the default values
    Logger.info('Loading settings');
    
    setState(() {
      _autoSave = true;
      _autoSaveInterval = 60;
      _performanceMode = false;
      _showDebugInfo = false;
      _showTooltips = true;
      _showAnimation = true;
      _includeMetadata = true;
      _defaultExportFormat = 'CSV';
      _theme = 'Dark';
      _cacheSize = 100;
      _hasChanges = false;
    });
  }
  
  /// Save settings to preferences
  Future<void> _saveSettings() async {
    // In a real app, we would save these to shared preferences
    // For now, we'll just log them
    Logger.info('Saving settings');
    Logger.info('Auto-save: $_autoSave');
    Logger.info('Auto-save interval: $_autoSaveInterval seconds');
    Logger.info('Performance mode: $_performanceMode');
    Logger.info('Show debug info: $_showDebugInfo');
    Logger.info('Show tooltips: $_showTooltips');
    Logger.info('Show animation: $_showAnimation');
    Logger.info('Include metadata: $_includeMetadata');
    Logger.info('Default export format: $_defaultExportFormat');
    Logger.info('Theme: $_theme');
    Logger.info('Cache size: $_cacheSize MB');
    
    // Show a snackbar to indicate settings were saved
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    
    setState(() {
      _hasChanges = false;
    });
  }
  
  /// Reset settings to defaults
  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text('Are you sure you want to reset all settings to their default values?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                _loadSettings();
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to defaults'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
  
  /// Clear all cached data
  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text('Are you sure you want to clear all cached data? This will not affect your saved profiles and crosshairs.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                // In a real app, we would clear the cache here
                Logger.info('Clearing cache');
                
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
  
  /// Set a value and mark that changes were made
  void _setValue<T>(T value, void Function(T) setter) {
    setState(() {
      setter(value);
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          // Save button
          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.only(right: Constants.padding),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: _saveSettings,
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.backgroundGradientStart,
              AppTheme.backgroundGradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(Constants.padding),
          children: [
            // Auto-save settings
            _buildSection(
              'Auto-save',
              [
                SwitchListTile(
                  title: const Text('Auto-save'),
                  subtitle: const Text('Automatically save changes'),
                  value: _autoSave,
                  onChanged: (value) => _setValue(value, (v) => _autoSave = v),
                  activeColor: AppTheme.primary,
                ),
                if (_autoSave)
                  ListTile(
                    title: const Text('Auto-save interval'),
                    subtitle: Slider(
                      value: _autoSaveInterval.toDouble(),
                      min: 10,
                      max: 300,
                      divisions: 29,
                      label: '${_autoSaveInterval.round()} seconds',
                      onChanged: (value) => _setValue(value.round(), (v) => _autoSaveInterval = v),
                      activeColor: AppTheme.primary,
                    ),
                    trailing: Text(
                      '${_autoSaveInterval.round()} s',
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
              ],
            ),
            
            // Performance settings
            _buildSection(
              'Performance',
              [
                SwitchListTile(
                  title: const Text('Performance Mode'),
                  subtitle: const Text('Optimize for performance'),
                  value: _performanceMode,
                  onChanged: (value) => _setValue(value, (v) => _performanceMode = v),
                  activeColor: AppTheme.primary,
                ),
                ListTile(
                  title: const Text('Cache Size'),
                  subtitle: Slider(
                    value: _cacheSize.toDouble(),
                    min: 10,
                    max: 500,
                    divisions: 49,
                    label: '${_cacheSize.round()} MB',
                    onChanged: (value) => _setValue(value.round(), (v) => _cacheSize = v),
                    activeColor: AppTheme.primary,
                  ),
                  trailing: Text(
                    '${_cacheSize.round()} MB',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Clear Cache'),
                  subtitle: const Text('Remove all cached data'),
                  trailing: ElevatedButton(
                    onPressed: _clearCache,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
            
            // User interface settings
            _buildSection(
              'User Interface',
              [
                SwitchListTile(
                  title: const Text('Show Tooltips'),
                  subtitle: const Text('Display helpful tooltips'),
                  value: _showTooltips,
                  onChanged: (value) => _setValue(value, (v) => _showTooltips = v),
                  activeColor: AppTheme.primary,
                ),
                SwitchListTile(
                  title: const Text('Show Animation'),
                  subtitle: const Text('Show animation in crosshair preview'),
                  value: _showAnimation,
                  onChanged: (value) => _setValue(value, (v) => _showAnimation = v),
                  activeColor: AppTheme.primary,
                ),
                ListTile(
                  title: const Text('Theme'),
                  subtitle: const Text('Select the application theme'),
                  trailing: DropdownButton<String>(
                    value: _theme,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Dark',
                        child: Text('Dark'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Light',
                        child: Text('Light'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'System',
                        child: Text('System'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _setValue(value, (v) => _theme = v);
                      }
                    },
                  ),
                ),
              ],
            ),
            
            // Export settings
            _buildSection(
              'Export',
              [
                SwitchListTile(
                  title: const Text('Include Metadata'),
                  subtitle: const Text('Include metadata when exporting'),
                  value: _includeMetadata,
                  onChanged: (value) => _setValue(value, (v) => _includeMetadata = v),
                  activeColor: AppTheme.primary,
                ),
                ListTile(
                  title: const Text('Default Export Format'),
                  subtitle: const Text('Select the default export format'),
                  trailing: DropdownButton<String>(
                    value: _defaultExportFormat,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'CSV',
                        child: Text('CSV'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _setValue(value, (v) => _defaultExportFormat = v);
                      }
                    },
                  ),
                ),
              ],
            ),
            
            // Debug settings
            _buildSection(
              'Debug',
              [
                SwitchListTile(
                  title: const Text('Show Debug Info'),
                  subtitle: const Text('Display debug information'),
                  value: _showDebugInfo,
                  onChanged: (value) => _setValue(value, (v) => _showDebugInfo = v),
                  activeColor: AppTheme.primary,
                ),
                if (_showDebugInfo)
                  ListTile(
                    title: const Text('Application Info'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Version: 1.0.0'),
                        Text('Build: ${DateTime.now().toIso8601String()}'),
                        const Text('Platform: Web'),
                        Consumer<CrosshairService>(
                          builder: (context, service, child) {
                            return Text('Crosshairs: ${service.crosshairs.length}');
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            // Reset button
            const SizedBox(height: Constants.padding),
            ElevatedButton.icon(
              icon: const Icon(Icons.restore),
              label: const Text('Reset All Settings'),
              onPressed: _resetSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a section of settings
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: Constants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.padding),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Constants.borderRadius),
                topRight: Radius.circular(Constants.borderRadius),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}