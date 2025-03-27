import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _autoSaveProfiles = true;
  bool _showGridInPreview = false;
  bool _enableAnimations = true;
  String _defaultExportFormat = 'PNG';
  String _startupProfile = 'Last Used';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // General settings
            _buildSectionHeader('General'),
            _buildSwitchSetting(
              'Auto-save profiles',
              'Automatically save profiles when modified',
              _autoSaveProfiles,
              (value) {
                setState(() {
                  _autoSaveProfiles = value;
                });
              },
            ),
            _buildSwitchSetting(
              'Show grid in preview',
              'Display a grid in the crosshair preview',
              _showGridInPreview,
              (value) {
                setState(() {
                  _showGridInPreview = value;
                });
              },
            ),
            _buildSwitchSetting(
              'Enable animations',
              'Enable UI animations and transitions',
              _enableAnimations,
              (value) {
                setState(() {
                  _enableAnimations = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Export settings
            _buildSectionHeader('Export Settings'),
            _buildDropdownSetting(
              'Default export format',
              'Default format used when exporting crosshairs',
              _defaultExportFormat,
              ['PNG', 'SVG'],
              (value) {
                if (value != null) {
                  setState(() {
                    _defaultExportFormat = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Startup settings
            _buildSectionHeader('Startup'),
            _buildDropdownSetting(
              'Default profile',
              'Profile to load when the application starts',
              _startupProfile,
              ['Last Used', 'Default', 'New Profile'],
              (value) {
                if (value != null) {
                  setState(() {
                    _startupProfile = value;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset to Defaults'),
                  onPressed: () {
                    _showResetConfirmationDialog();
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Settings'),
                  onPressed: () {
                    // TODO: Save settings to disk
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build a section header
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(color: AppTheme.dividerColor),
        const SizedBox(height: 8),
      ],
    );
  }

  // Build a switch setting
  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      color: AppTheme.cardColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppTheme.secondaryTextColor,
            fontSize: 12,
          ),
        ),
        value: value,
        activeColor: AppTheme.primaryColor,
        onChanged: onChanged,
      ),
    );
  }

  // Build a dropdown setting
  Widget _buildDropdownSetting(
    String title,
    String subtitle,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Card(
      color: AppTheme.cardColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppTheme.dividerColor,
                ),
              ),
              child: DropdownButton<String>(
                value: value,
                dropdownColor: AppTheme.surfaceColor,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.secondaryTextColor,
                ),
                style: TextStyle(
                  color: AppTheme.textColor,
                ),
                onChanged: onChanged,
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show a confirmation dialog for resetting settings
  void _showResetConfirmationDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings?'),
          content: const Text(
            'This will reset all settings to their default values. This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                setState(() {
                  _autoSaveProfiles = true;
                  _showGridInPreview = false;
                  _enableAnimations = true;
                  _defaultExportFormat = 'PNG';
                  _startupProfile = 'Last Used';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}