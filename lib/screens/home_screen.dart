import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crosshair_model.dart';
import '../services/crosshair_service.dart';
import '../services/profile_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/crosshair_preview.dart';
import '../widgets/color_picker.dart';
import '../widgets/custom_slider.dart';
import '../widgets/shape_selector.dart';

/// The home screen
class HomeScreen extends StatefulWidget {
  /// Create a new home screen
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  /// The animation controller for the settings panel
  late AnimationController _panelController;
  
  /// The animation for the settings panel
  late Animation<double> _panelAnimation;
  
  /// The current crosshair
  CrosshairModel? _currentCrosshair;
  
  /// Whether the grid is visible
  bool _showGrid = true;
  
  /// Whether the info is visible
  bool _showInfo = true;
  
  /// The panel state
  bool _isPanelVisible = true;

  @override
  void initState() {
    super.initState();
    
    _panelController = AnimationController(
      duration: Constants.animationDuration,
      vsync: this,
    );
    
    _panelAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeInOut,
    );
    
    _panelController.forward();
    
    // Load the active crosshair
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActiveCrosshair();
    });
  }
  
  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }
  
  /// Load the active crosshair
  void _loadActiveCrosshair() {
    final profileService = Provider.of<ProfileService>(context, listen: false);
    final crosshairService = Provider.of<CrosshairService>(context, listen: false);
    
    final activeProfile = profileService.activeProfile;
    
    if (activeProfile != null && activeProfile.activeCrosshairId != null) {
      setState(() {
        _currentCrosshair = crosshairService.getCrosshairById(activeProfile.activeCrosshairId!);
      });
    } else if (crosshairService.crosshairs.isNotEmpty) {
      setState(() {
        _currentCrosshair = crosshairService.crosshairs.first;
      });
      
      if (activeProfile != null) {
        profileService.setActiveCrosshairForProfile(
          activeProfile.id,
          _currentCrosshair!.id,
        );
        
        if (!activeProfile.crosshairIds.contains(_currentCrosshair!.id)) {
          profileService.addCrosshairToProfile(
            activeProfile.id,
            _currentCrosshair!.id,
          );
        }
      }
    }
  }
  
  /// Toggle the panel
  void _togglePanel() {
    setState(() {
      _isPanelVisible = !_isPanelVisible;
    });
    
    if (_isPanelVisible) {
      _panelController.forward();
    } else {
      _panelController.reverse();
    }
  }
  
  /// Create a new crosshair
  void _createNewCrosshair() {
    final crosshairService = Provider.of<CrosshairService>(context, listen: false);
    final profileService = Provider.of<ProfileService>(context, listen: false);
    
    final newCrosshair = CrosshairModel(
      name: 'New Crosshair',
    );
    
    crosshairService.addCrosshair(newCrosshair).then((crosshair) {
      setState(() {
        _currentCrosshair = crosshair;
      });
      
      final activeProfile = profileService.activeProfile;
      
      if (activeProfile != null) {
        profileService.addCrosshairToProfile(
          activeProfile.id,
          crosshair.id,
        );
        
        profileService.setActiveCrosshairForProfile(
          activeProfile.id,
          crosshair.id,
        );
      }
    });
  }
  
  /// Save the current crosshair
  void _saveCrosshair() {
    if (_currentCrosshair != null) {
      final crosshairService = Provider.of<CrosshairService>(context, listen: false);
      crosshairService.updateCrosshair(_currentCrosshair!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Crosshair saved'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  /// Update the current crosshair
  void _updateCrosshair(CrosshairModel updatedCrosshair) {
    setState(() {
      _currentCrosshair = updatedCrosshair;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crosshair Studio'),
        actions: [
          IconButton(
            icon: Icon(_isPanelVisible ? Icons.chevron_right : Icons.chevron_left),
            onPressed: _togglePanel,
            tooltip: _isPanelVisible ? 'Hide panel' : 'Show panel',
          ),
        ],
      ),
      body: Row(
        children: [
          // Main content
          Expanded(
            flex: 3,
            child: Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Preview
                  CrosshairPreview(
                    crosshair: _currentCrosshair,
                    showGrid: _showGrid,
                    showInfo: _showInfo,
                  ),
                  
                  const SizedBox(height: Constants.padding),
                  
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Grid toggle
                      CustomToggle(
                        value: _showGrid,
                        onChanged: (value) {
                          setState(() {
                            _showGrid = value;
                          });
                        },
                        label: 'Grid',
                      ),
                      
                      const SizedBox(width: Constants.padding),
                      
                      // Info toggle
                      CustomToggle(
                        value: _showInfo,
                        onChanged: (value) {
                          setState(() {
                            _showInfo = value;
                          });
                        },
                        label: 'Info',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Settings panel
          AnimatedBuilder(
            animation: _panelAnimation,
            builder: (context, child) {
              final width = MediaQuery.of(context).size.width * 0.35 * _panelAnimation.value;
              
              if (width < 5) {
                return const SizedBox.shrink();
              }
              
              return SizedBox(
                width: width,
                child: child,
              );
            },
            child: Container(
              color: AppTheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(Constants.padding),
                    color: AppTheme.background,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _currentCrosshair?.name ?? 'No Crosshair Selected',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _createNewCrosshair,
                          tooltip: 'Create new crosshair',
                        ),
                        IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: _saveCrosshair,
                          tooltip: 'Save crosshair',
                        ),
                      ],
                    ),
                  ),
                  
                  // Settings
                  Expanded(
                    child: _currentCrosshair != null
                        ? _buildCrosshairSettings()
                        : const Center(
                            child: Text('Select or create a crosshair'),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build the crosshair settings
  Widget _buildCrosshairSettings() {
    if (_currentCrosshair == null) {
      return const SizedBox.shrink();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Constants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          TextField(
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: _currentCrosshair!.name),
            onChanged: (value) {
              _updateCrosshair(_currentCrosshair!.copyWith(name: value));
            },
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Shape
          ShapeSelector(
            currentShape: _currentCrosshair!.shape,
            onShapeSelected: (shape) {
              _updateCrosshair(_currentCrosshair!.copyWith(shape: shape));
            },
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Color
          ColorPickerButton(
            color: _currentCrosshair!.color,
            onColorChanged: (color) {
              _updateCrosshair(_currentCrosshair!.copyWith(color: color));
            },
            label: 'Color',
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Preset colors
          PresetColorsRow(
            currentColor: _currentCrosshair!.color,
            onColorSelected: (color) {
              _updateCrosshair(_currentCrosshair!.copyWith(color: color));
            },
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Size
          CustomSlider(
            label: 'Size',
            value: _currentCrosshair!.size,
            min: Constants.minSize,
            max: Constants.maxSize,
            divisions: Constants.sliderDivisions,
            onChanged: (value) {
              _updateCrosshair(_currentCrosshair!.copyWith(size: value));
            },
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Thickness
          CustomSlider(
            label: 'Thickness',
            value: _currentCrosshair!.thickness,
            min: Constants.minThickness,
            max: Constants.maxThickness,
            divisions: Constants.sliderDivisions,
            onChanged: (value) {
              _updateCrosshair(_currentCrosshair!.copyWith(thickness: value));
            },
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Gap
          CustomSlider(
            label: 'Gap',
            value: _currentCrosshair!.gap,
            min: Constants.minGap,
            max: Constants.maxGap,
            divisions: Constants.sliderDivisions,
            onChanged: (value) {
              _updateCrosshair(_currentCrosshair!.copyWith(gap: value));
            },
            disabled: _currentCrosshair!.shape != CrosshairShape.classic,
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Opacity
          CustomSlider(
            label: 'Opacity',
            value: _currentCrosshair!.opacity,
            min: Constants.minOpacity,
            max: Constants.maxOpacity,
            divisions: Constants.sliderDivisions,
            onChanged: (value) {
              _updateCrosshair(_currentCrosshair!.copyWith(opacity: value));
            },
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Outline
          ExpansionTile(
            title: const Text('Outline'),
            initiallyExpanded: false,
            childrenPadding: const EdgeInsets.symmetric(
              vertical: Constants.paddingSmall,
            ),
            children: [
              CustomSlider(
                label: 'Thickness',
                value: _currentCrosshair!.outlineThickness,
                min: Constants.minOutlineThickness,
                max: Constants.maxOutlineThickness,
                divisions: Constants.sliderDivisions,
                onChanged: (value) {
                  _updateCrosshair(_currentCrosshair!.copyWith(outlineThickness: value));
                },
              ),
              
              const SizedBox(height: Constants.padding),
              
              ColorPickerButton(
                color: _currentCrosshair!.outlineColor,
                onColorChanged: (color) {
                  _updateCrosshair(_currentCrosshair!.copyWith(outlineColor: color));
                },
                label: 'Color',
                disabled: _currentCrosshair!.outlineThickness <= 0,
              ),
            ],
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Dot
          ExpansionTile(
            title: const Text('Center Dot'),
            initiallyExpanded: false,
            childrenPadding: const EdgeInsets.symmetric(
              vertical: Constants.paddingSmall,
            ),
            children: [
              CustomToggle(
                value: _currentCrosshair!.showDot,
                onChanged: (value) {
                  _updateCrosshair(_currentCrosshair!.copyWith(showDot: value));
                },
                label: 'Show Dot',
              ),
              
              const SizedBox(height: Constants.padding),
              
              CustomSlider(
                label: 'Size',
                value: _currentCrosshair!.dotSize,
                min: Constants.minDotSize,
                max: Constants.maxDotSize,
                divisions: Constants.sliderDivisions,
                onChanged: (value) {
                  _updateCrosshair(_currentCrosshair!.copyWith(dotSize: value));
                },
                disabled: !_currentCrosshair!.showDot,
              ),
              
              const SizedBox(height: Constants.padding),
              
              ColorPickerButton(
                color: _currentCrosshair!.dotColor,
                onColorChanged: (color) {
                  _updateCrosshair(_currentCrosshair!.copyWith(dotColor: color));
                },
                label: 'Color',
                disabled: !_currentCrosshair!.showDot,
              ),
            ],
          ),
          
          const SizedBox(height: Constants.padding),
          
          // Animation
          ExpansionTile(
            title: const Text('Animation'),
            initiallyExpanded: false,
            childrenPadding: const EdgeInsets.symmetric(
              vertical: Constants.paddingSmall,
            ),
            children: [
              CustomToggle(
                value: _currentCrosshair!.enableAnimation,
                onChanged: (value) {
                  _updateCrosshair(_currentCrosshair!.copyWith(enableAnimation: value));
                },
                label: 'Enable Animation',
              ),
              
              const SizedBox(height: Constants.padding),
              
              DropdownButtonFormField<AnimationType>(
                decoration: const InputDecoration(
                  labelText: 'Animation Type',
                  border: OutlineInputBorder(),
                ),
                value: _currentCrosshair!.animationType,
                items: AnimationType.values.map((type) {
                  return DropdownMenuItem<AnimationType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: _currentCrosshair!.enableAnimation
                    ? (value) {
                        if (value != null) {
                          _updateCrosshair(_currentCrosshair!.copyWith(animationType: value));
                        }
                      }
                    : null,
              ),
              
              const SizedBox(height: Constants.padding),
              
              CustomSlider(
                label: 'Speed',
                value: _currentCrosshair!.animationSpeed,
                min: Constants.minAnimationSpeed,
                max: Constants.maxAnimationSpeed,
                divisions: Constants.sliderDivisions,
                onChanged: (value) {
                  _updateCrosshair(_currentCrosshair!.copyWith(animationSpeed: value));
                },
                disabled: !_currentCrosshair!.enableAnimation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}