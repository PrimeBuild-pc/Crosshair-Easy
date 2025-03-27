import 'package:flutter/material.dart';

import '../models/crosshair_model.dart';
import '../models/profile_model.dart';
import '../services/crosshair_service.dart';
import '../services/profile_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/color_picker.dart';
import '../widgets/crosshair_preview.dart';
import '../widgets/custom_slider.dart';
import '../widgets/shape_selector.dart';
import 'about_screen.dart';
import 'export_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// The main home screen of the application
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProfileModel _currentProfile;
  late CrosshairModel _currentCrosshair;
  bool _isLoading = true;
  bool _showExpandedControls = false;
  bool _showAnimationControls = false;
  bool _showGrid = false;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  // Initialize data from storage or create defaults
  Future<void> _initializeData() async {
    try {
      _currentProfile = await ProfileService.initializeDefaultProfile();
      
      if (_currentProfile.crosshairs.isNotEmpty) {
        _currentCrosshair = _currentProfile.crosshairs.first;
      } else {
        _currentCrosshair = CrosshairModel.defaultCrosshair();
        _currentProfile.addCrosshair(_currentCrosshair);
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
      // Handle error, use defaults
      setState(() {
        _currentProfile = ProfileModel.defaultProfile();
        _currentCrosshair = _currentProfile.crosshairs.first;
        _isLoading = false;
      });
    }
  }
  
  // Save the current state
  Future<void> _saveCurrentState() async {
    try {
      // Update the crosshair in the profile
      _currentProfile.updateCrosshair(_currentCrosshair);
      
      // Save the profile
      await ProfileService.saveProfile(_currentProfile);
    } catch (e) {
      print('Error saving state: $e');
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save changes: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crosshair Studio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profiles',
            onPressed: () => _navigateToProfiles(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => _navigateToSettings(),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Export',
            onPressed: () => _navigateToExport(),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'About',
            onPressed: () => _navigateToAbout(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            )
          : Container(
              decoration: AppTheme.backgroundGradient,
              child: Row(
                children: [
                  // Left panel: Crosshair preview
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Crosshair name
                          Text(
                            _currentCrosshair.name,
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Profile name
                          Text(
                            'Profile: ${_currentProfile.name}',
                            style: TextStyle(
                              color: AppTheme.secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Crosshair preview
                          SizedBox(
                            width: 300,
                            height: 300,
                            child: Stack(
                              children: [
                                CrosshairPreview(
                                  crosshair: _currentCrosshair,
                                  backgroundType: 'Dark', // TODO: Make customizable
                                  showGrid: _showGrid,
                                ),
                                
                                // Grid toggle button
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      _showGrid ? Icons.grid_on : Icons.grid_off,
                                      color: _showGrid
                                          ? AppTheme.primaryColor
                                          : AppTheme.secondaryTextColor,
                                    ),
                                    tooltip: 'Toggle Grid',
                                    onPressed: () {
                                      setState(() {
                                        _showGrid = !_showGrid;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Right panel: Controls
                  SizedBox(
                    width: 320,
                    child: Card(
                      margin: const EdgeInsets.all(16),
                      color: AppTheme.surfaceColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Crosshair name field
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Crosshair Name',
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(text: _currentCrosshair.name),
                              onChanged: (value) {
                                setState(() {
                                  _currentCrosshair = _currentCrosshair.copyWith(
                                    name: value,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Controls
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Color picker
                                    Text(
                                      'Color',
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ColorPicker(
                                      currentColor: _currentCrosshair.color,
                                      onColorChanged: (color) {
                                        setState(() {
                                          _currentCrosshair = _currentCrosshair.copyWith(
                                            color: color,
                                          );
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Basic sliders
                                    Text(
                                      'Basic Settings',
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomSlider(
                                      label: 'Size',
                                      value: _currentCrosshair.size,
                                      min: 4,
                                      max: 32,
                                      activeColor: AppTheme.primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _currentCrosshair = _currentCrosshair.copyWith(
                                            size: value,
                                          );
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    CustomSlider(
                                      label: 'Thickness',
                                      value: _currentCrosshair.thickness,
                                      min: 1,
                                      max: 6,
                                      activeColor: AppTheme.primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _currentCrosshair = _currentCrosshair.copyWith(
                                            thickness: value,
                                          );
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    CustomSlider(
                                      label: 'Gap',
                                      value: _currentCrosshair.gap,
                                      min: 0,
                                      max: 12,
                                      activeColor: AppTheme.primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _currentCrosshair = _currentCrosshair.copyWith(
                                            gap: value,
                                          );
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    CustomSlider(
                                      label: 'Opacity',
                                      value: _currentCrosshair.opacity,
                                      min: 0.1,
                                      max: 1.0,
                                      activeColor: AppTheme.primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _currentCrosshair = _currentCrosshair.copyWith(
                                            opacity: value,
                                          );
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Advanced settings toggle
                                    _buildExpandableSection(
                                      title: 'Advanced Settings',
                                      isExpanded: _showExpandedControls,
                                      onToggle: () {
                                        setState(() {
                                          _showExpandedControls = !_showExpandedControls;
                                        });
                                      },
                                      children: [
                                        const SizedBox(height: 16),
                                        
                                        // Center dot toggle
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Center Dot',
                                                style: TextStyle(
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: _currentCrosshair.showCenterDot,
                                              activeColor: AppTheme.primaryColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  _currentCrosshair = _currentCrosshair.copyWith(
                                                    showCenterDot: value,
                                                  );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        
                                        // Center dot size slider (conditionally shown)
                                        if (_currentCrosshair.showCenterDot) ...[
                                          const SizedBox(height: 8),
                                          CustomSlider(
                                            label: 'Center Dot Size',
                                            value: _currentCrosshair.centerDotSize,
                                            min: 1,
                                            max: 6,
                                            activeColor: AppTheme.primaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                _currentCrosshair = _currentCrosshair.copyWith(
                                                  centerDotSize: value,
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Outline toggle
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Outline',
                                                style: TextStyle(
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: _currentCrosshair.outline,
                                              activeColor: AppTheme.primaryColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  _currentCrosshair = _currentCrosshair.copyWith(
                                                    outline: value,
                                                  );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        
                                        // Outline controls (conditionally shown)
                                        if (_currentCrosshair.outline) ...[
                                          const SizedBox(height: 8),
                                          CustomSlider(
                                            label: 'Outline Thickness',
                                            value: _currentCrosshair.outlineThickness,
                                            min: 1,
                                            max: 3,
                                            activeColor: AppTheme.primaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                _currentCrosshair = _currentCrosshair.copyWith(
                                                  outlineThickness: value,
                                                );
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Outline Color',
                                            style: TextStyle(
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ColorPicker(
                                            currentColor: _currentCrosshair.outlineColor,
                                            onColorChanged: (color) {
                                              setState(() {
                                                _currentCrosshair = _currentCrosshair.copyWith(
                                                  outlineColor: color,
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Animation toggle
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Animation',
                                                style: TextStyle(
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: _currentCrosshair.animated,
                                              activeColor: AppTheme.primaryColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  _currentCrosshair = _currentCrosshair.copyWith(
                                                    animated: value,
                                                    animationType: value
                                                        ? _currentCrosshair.animationType ?? AppConstants.animationTypes.first
                                                        : null,
                                                  );
                                                  
                                                  _showAnimationControls = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        
                                        // Animation controls (conditionally shown)
                                        if (_currentCrosshair.animated && _showAnimationControls) ...[
                                          const SizedBox(height: 16),
                                          Text(
                                            'Animation Type',
                                            style: TextStyle(
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildAnimationTypeSelector(),
                                          const SizedBox(height: 8),
                                          CustomSlider(
                                            label: 'Animation Speed',
                                            value: _currentCrosshair.animationSpeed,
                                            min: 0.5,
                                            max: 2.0,
                                            activeColor: AppTheme.primaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                _currentCrosshair = _currentCrosshair.copyWith(
                                                  animationSpeed: value,
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Shape selector
                                    ShapeSelector(
                                      selectedShape: _currentCrosshair.shape,
                                      onShapeSelected: (shape) {
                                        setState(() {
                                          _currentCrosshair = _currentCrosshair.copyWith(
                                            shape: shape,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reset'),
                                  onPressed: () {
                                    _showResetConfirmationDialog();
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.save),
                                  label: const Text('Save'),
                                  onPressed: () {
                                    _saveCurrentState();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Crosshair saved'),
                                        backgroundColor: AppTheme.surfaceColor,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  // Build an expandable section with title and toggle
  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        InkWell(
          onTap: onToggle,
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppTheme.textColor,
              ),
            ],
          ),
        ),
        
        // Expandable content
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isExpanded ? null : 0,
          child: isExpanded ? Column(children: children) : null,
        ),
      ],
    );
  }
  
  // Build animation type selector
  Widget _buildAnimationTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.animationTypes.map((type) {
        final isSelected = _currentCrosshair.animationType == type;
        
        return InkWell(
          onTap: () {
            setState(() {
              _currentCrosshair = _currentCrosshair.copyWith(
                animationType: type,
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppTheme.primaryColor.withOpacity(0.2) 
                  : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  // Show reset confirmation dialog
  void _showResetConfirmationDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Crosshair?'),
        content: const Text(
          'This will reset all settings to their default values. This action cannot be undone.',
        ),
        actions: [
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
                _currentCrosshair = CrosshairModel.defaultCrosshair();
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
  
  // Navigate to profiles screen
  void _navigateToProfiles() async {
    await _saveCurrentState();
    
    final result = await Navigator.push<ProfileModel>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          initialProfile: _currentProfile,
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        _currentProfile = result;
        if (_currentProfile.crosshairs.isNotEmpty) {
          _currentCrosshair = _currentProfile.crosshairs.first;
        }
      });
    }
  }
  
  // Navigate to settings screen
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
  
  // Navigate to export screen
  void _navigateToExport() async {
    await _saveCurrentState();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExportScreen(
          crosshair: _currentCrosshair,
        ),
      ),
    );
  }
  
  // Navigate to about screen
  void _navigateToAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }
}