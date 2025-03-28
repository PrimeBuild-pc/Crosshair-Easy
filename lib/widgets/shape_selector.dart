import 'package:flutter/material.dart';
import '../models/crosshair_model.dart';
import '../utils/constants.dart';
import 'crosshair_preview.dart';

/// A widget for selecting and previewing different crosshair shapes
class ShapeSelector extends StatelessWidget {
  /// The current crosshair
  final CrosshairModel? currentCrosshair;
  
  /// The callback when a preset is selected
  final Function(CrosshairModel) onPresetSelected;
  
  /// Whether to show labels
  final bool showLabels;
  
  /// Whether to show info in previews
  final bool showInfo;
  
  /// Create a new shape selector
  const ShapeSelector({
    Key? key,
    this.currentCrosshair,
    required this.onPresetSelected,
    this.showLabels = true,
    this.showInfo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabels)
          Padding(
            padding: const EdgeInsets.only(bottom: Constants.paddingSmall),
            child: Text(
              'Preset Shapes',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPresetItem(
                context,
                CrosshairModel.classicPreset(),
                'Classic',
              ),
              _buildPresetItem(
                context,
                CrosshairModel.dotPreset(),
                'Dot',
              ),
              _buildPresetItem(
                context,
                CrosshairModel.circlePreset(),
                'Circle',
              ),
              _buildPresetItem(
                context,
                _createDotCirclePreset(),
                'Circle+Dot',
              ),
              _buildPresetItem(
                context,
                _createCrossCirclePreset(),
                'Cross+Circle',
              ),
              _buildPresetItem(
                context,
                _createTPreset(),
                'T-Shape',
              ),
              _buildPresetItem(
                context,
                _createXPreset(),
                'X-Shape',
              ),
              _buildPresetItem(
                context,
                _createTrianglePreset(),
                'Triangle',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a preset item
  Widget _buildPresetItem(BuildContext context, CrosshairModel preset, String label) {
    const size = 80.0;
    final isSelected = currentCrosshair != null && 
                      currentCrosshair!.name == preset.name;
    
    return Padding(
      padding: const EdgeInsets.only(right: Constants.paddingMedium),
      child: Column(
        children: [
          InkWell(
            onTap: () => onPresetSelected(preset),
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(Constants.borderRadius),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Constants.borderRadius - 1),
                child: CrosshairPreview(
                  crosshair: preset,
                  showInfo: showInfo,
                ),
              ),
            ),
          ),
          if (showLabels)
            Padding(
              padding: const EdgeInsets.only(top: Constants.paddingSmall),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// Create a circle with dot preset
  CrosshairModel _createDotCirclePreset() {
    return CrosshairModel(
      name: 'Circle+Dot',
      description: 'Circle with center dot',
      topLine: LineComponent(enabled: false),
      rightLine: LineComponent(enabled: false),
      bottomLine: LineComponent(enabled: false),
      leftLine: LineComponent(enabled: false),
      outerCircle: CircleComponent(
        enabled: true,
        color: Colors.lime,
        radius: 10,
        thickness: 1.5,
      ),
      centerDot: DotComponent(
        enabled: true,
        color: Colors.lime,
        size: 2,
      ),
    );
  }
  
  /// Create a cross with circle preset
  CrosshairModel _createCrossCirclePreset() {
    return CrosshairModel(
      name: 'Cross+Circle',
      description: 'Classic crosshair with outer circle',
      topLine: LineComponent(
        color: Colors.yellowAccent,
        thickness: 2,
        length: 8,
        gap: 3,
      ),
      rightLine: LineComponent(
        color: Colors.yellowAccent,
        thickness: 2,
        length: 8,
        gap: 3,
      ),
      bottomLine: LineComponent(
        color: Colors.yellowAccent,
        thickness: 2,
        length: 8,
        gap: 3,
      ),
      leftLine: LineComponent(
        color: Colors.yellowAccent,
        thickness: 2,
        length: 8,
        gap: 3,
      ),
      outerCircle: CircleComponent(
        enabled: true,
        color: Colors.yellowAccent,
        radius: 15,
        thickness: 1,
      ),
      centerDot: DotComponent(
        enabled: false,
      ),
    );
  }
  
  /// Create a T-shaped preset
  CrosshairModel _createTPreset() {
    return CrosshairModel(
      name: 'T-Shape',
      description: 'T-shaped crosshair',
      topLine: LineComponent(
        color: Colors.cyan,
        thickness: 2,
        length: 12,
        gap: 0,
      ),
      rightLine: LineComponent(
        color: Colors.cyan,
        thickness: 2,
        length: 6,
        gap: 0,
        offset: const Offset(6, 0),
      ),
      leftLine: LineComponent(
        color: Colors.cyan,
        thickness: 2,
        length: 6,
        gap: 0,
        offset: const Offset(-6, 0),
      ),
      bottomLine: LineComponent(enabled: false),
      outerCircle: CircleComponent(enabled: false),
      centerDot: DotComponent(enabled: false),
    );
  }
  
  /// Create an X-shaped preset
  CrosshairModel _createXPreset() {
    return CrosshairModel(
      name: 'X-Shape',
      description: 'X-shaped crosshair',
      // Use diagonal lines by setting appropriate offsets
      topLine: LineComponent(
        color: Colors.deepOrange,
        thickness: 1.5,
        length: 12,
        gap: 3,
        offset: const Offset(-5, -5),
      ),
      rightLine: LineComponent(
        color: Colors.deepOrange,
        thickness: 1.5,
        length: 12,
        gap: 3,
        offset: const Offset(5, -5),
      ),
      bottomLine: LineComponent(
        color: Colors.deepOrange,
        thickness: 1.5,
        length: 12,
        gap: 3,
        offset: const Offset(5, 5),
      ),
      leftLine: LineComponent(
        color: Colors.deepOrange,
        thickness: 1.5,
        length: 12,
        gap: 3,
        offset: const Offset(-5, 5),
      ),
      centerDot: DotComponent(
        enabled: true,
        color: Colors.deepOrange,
        size: 1,
      ),
    );
  }
  
  /// Create a triangle preset
  CrosshairModel _createTrianglePreset() {
    return CrosshairModel(
      name: 'Triangle',
      description: 'Triangle crosshair',
      // Simulate a triangle with three lines at appropriate angles
      topLine: LineComponent(
        color: Colors.purple,
        thickness: 1.5,
        length: 10,
        gap: 0,
        offset: const Offset(0, -7),
        capStyle: LineCapStyle.round,
      ),
      rightLine: LineComponent(
        color: Colors.purple,
        thickness: 1.5,
        length: 10,
        gap: 0,
        offset: const Offset(6, 4),
        capStyle: LineCapStyle.round,
      ),
      leftLine: LineComponent(
        color: Colors.purple,
        thickness: 1.5,
        length: 10,
        gap: 0,
        offset: const Offset(-6, 4),
        capStyle: LineCapStyle.round,
      ),
      bottomLine: LineComponent(enabled: false),
      centerDot: DotComponent(enabled: false),
    );
  }
}