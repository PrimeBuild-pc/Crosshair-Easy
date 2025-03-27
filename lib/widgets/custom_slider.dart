import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A custom slider widget with label and value display
class CustomSlider extends StatelessWidget {
  /// Label for the slider
  final String label;
  
  /// Current value
  final double value;
  
  /// Minimum value
  final double min;
  
  /// Maximum value
  final double max;
  
  /// Number of decimal places to display
  final int decimalPlaces;
  
  /// Optional unit to display after the value
  final String? unit;
  
  /// Whether to display integer values only
  final bool integerOnly;
  
  /// Optional custom color for the slider
  final Color? activeColor;
  
  /// Callback when value changes
  final ValueChanged<double> onChanged;
  
  /// Constructor
  const CustomSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.decimalPlaces = 1,
    this.unit,
    this.integerOnly = false,
    this.activeColor,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _formatValue(value),
              style: TextStyle(
                color: AppTheme.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        
        // Slider row with min/max labels
        Row(
          children: [
            // Min value label
            SizedBox(
              width: 24,
              child: Text(
                _formatValue(min),
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 10,
                ),
              ),
            ),
            
            // Slider
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: activeColor ?? AppTheme.primaryColor,
                  inactiveTrackColor: AppTheme.backgroundColor,
                  thumbColor: activeColor ?? AppTheme.primaryColor,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: integerOnly ? (max - min).round() : (max - min) * 10.0 ~/ 1,
                  onChanged: (newValue) {
                    if (integerOnly) {
                      onChanged(newValue.roundToDouble());
                    } else {
                      onChanged(newValue);
                    }
                  },
                ),
              ),
            ),
            
            // Max value label
            SizedBox(
              width: 24,
              child: Text(
                _formatValue(max),
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 10,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // Format the value for display
  String _formatValue(double value) {
    String formattedValue;
    
    if (integerOnly) {
      formattedValue = value.round().toString();
    } else {
      formattedValue = value.toStringAsFixed(decimalPlaces);
      // Remove trailing zeros
      if (formattedValue.contains('.')) {
        formattedValue = formattedValue.replaceAll(RegExp(r'0+$'), '');
        formattedValue = formattedValue.replaceAll(RegExp(r'\.$'), '');
      }
    }
    
    // Add unit if provided
    if (unit != null) {
      formattedValue += ' $unit';
    }
    
    return formattedValue;
  }
}