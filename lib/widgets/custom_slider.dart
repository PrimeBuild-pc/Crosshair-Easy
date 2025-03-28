import 'package:flutter/material.dart';

/// A custom slider with a label
class CustomSlider extends StatelessWidget {
  /// The current value
  final double value;
  
  /// Callback when the value changes
  final ValueChanged<double> onChanged;
  
  /// The minimum value
  final double min;
  
  /// The maximum value
  final double max;
  
  /// The number of divisions
  final int? divisions;
  
  /// The label
  final String label;
  
  /// The label format
  final String? labelFormat;
  
  /// Whether the slider is disabled
  final bool disabled;
  
  /// Create a new custom slider
  const CustomSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labelFormat,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _formatValue(value),
              style: TextStyle(
                color: disabled ? Colors.grey : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorTextStyle: const TextStyle(fontSize: 12),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: _formatValue(value),
            onChanged: disabled ? null : onChanged,
          ),
        ),
      ],
    );
  }
  
  /// Format the value based on the label format
  String _formatValue(double value) {
    if (labelFormat == null) {
      return value.toStringAsFixed(1);
    }
    
    return labelFormat!.replaceAll('{value}', value.toStringAsFixed(1));
  }
}

/// A custom toggle with a label
class CustomToggle extends StatelessWidget {
  /// The current value
  final bool value;
  
  /// Callback when the value changes
  final ValueChanged<bool> onChanged;
  
  /// The label
  final String label;
  
  /// The description
  final String? description;
  
  /// Whether the toggle is disabled
  final bool disabled;
  
  /// Create a new custom toggle
  const CustomToggle({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.description,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null)
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: disabled ? null : onChanged,
          ),
        ],
      ),
    );
  }
}