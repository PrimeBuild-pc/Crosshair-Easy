import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// A custom slider for adjusting crosshair parameters
class CustomSlider extends StatelessWidget {
  /// The label for the slider
  final String label;
  
  /// The current value
  final double value;
  
  /// Callback when value changes
  final ValueChanged<double> onChanged;
  
  /// Minimum value
  final double min;
  
  /// Maximum value
  final double max;
  
  /// Number of divisions
  final int? divisions;
  
  /// Whether to show value as percentage
  final bool showPercent;
  
  /// Prefix for value display
  final String? prefix;
  
  /// Suffix for value display
  final String? suffix;
  
  /// Function to format the value
  final String Function(double)? valueFormatter;
  
  /// Whether to show the value
  final bool showValue;
  
  /// The secondary color for the active track
  final Color? activeTrackColor;
  
  /// The secondary color for the inactive track
  final Color? inactiveTrackColor;
  
  /// The secondary color for the thumb
  final Color? thumbColor;
  
  /// Whether to show the reset button
  final bool showResetButton;
  
  /// Default value for reset
  final double defaultValue;
  
  /// Create a new custom slider
  const CustomSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.showPercent = false,
    this.prefix,
    this.suffix,
    this.valueFormatter,
    this.showValue = true,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.showResetButton = true,
    this.defaultValue = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    String formattedValue;
    if (valueFormatter != null) {
      formattedValue = valueFormatter!(value);
    } else if (showPercent) {
      formattedValue = '${(value * 100).toInt()}%';
    } else {
      formattedValue = value.toStringAsFixed(
        value % 1 == 0 ? 0 : 1
      );
    }
    
    if (prefix != null) {
      formattedValue = '$prefix$formattedValue';
    }
    
    if (suffix != null) {
      formattedValue = '$formattedValue$suffix';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                if (showValue)
                  Text(
                    formattedValue,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                if (showResetButton && value != defaultValue)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.restart_alt, size: 16),
                    onPressed: () => onChanged(defaultValue),
                    tooltip: 'Reset to default',
                  ),
              ],
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeTrackColor ?? colorScheme.primary,
            inactiveTrackColor: inactiveTrackColor ?? colorScheme.primaryContainer.withOpacity(0.3),
            thumbColor: thumbColor ?? colorScheme.primary,
            overlayColor: colorScheme.primary.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        
        // Optional min/max labels
        if (min != 0 || max != 1)
          Padding(
            padding: const EdgeInsets.only(
              left: Constants.paddingSmall,
              right: Constants.paddingSmall,
              bottom: Constants.paddingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  min.toStringAsFixed(min % 1 == 0 ? 0 : 1),
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                Text(
                  max.toStringAsFixed(max % 1 == 0 ? 0 : 1),
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}