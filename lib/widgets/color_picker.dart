import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

/// A color picker button
class ColorPickerButton extends StatelessWidget {
  /// The current color
  final Color color;
  
  /// Callback when the color changes
  final ValueChanged<Color> onColorChanged;
  
  /// The label
  final String label;
  
  /// Whether the button is disabled
  final bool disabled;
  
  /// Create a new color picker button
  const ColorPickerButton({
    Key? key,
    required this.color,
    required this.onColorChanged,
    required this.label,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: disabled ? null : () => _showColorPicker(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              border: Border.all(
                color: Colors.grey[800]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  /// Show the color picker dialog
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color currentColor = color;
        
        return AlertDialog(
          title: Text(label),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: (color) {
                currentColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              labelTypes: const [],
              displayThumbColor: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onColorChanged(currentColor);
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

/// A preset color button
class PresetColorButton extends StatelessWidget {
  /// The color
  final Color color;
  
  /// Callback when the color is selected
  final VoidCallback onTap;
  
  /// Whether the button is selected
  final bool isSelected;
  
  /// Create a new preset color button
  const PresetColorButton({
    Key? key,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey[800]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

/// A row of preset colors
class PresetColorsRow extends StatelessWidget {
  /// The current color
  final Color currentColor;
  
  /// Callback when a color is selected
  final ValueChanged<Color> onColorSelected;
  
  /// The list of preset colors
  final List<Color> presetColors;
  
  /// Create a new preset colors row
  const PresetColorsRow({
    Key? key,
    required this.currentColor,
    required this.onColorSelected,
    this.presetColors = const [
      Colors.white,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.lime,
      Colors.cyan,
      Colors.amber,
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: presetColors.map((color) {
        return PresetColorButton(
          color: color,
          onTap: () => onColorSelected(color),
          isSelected: currentColor.value == color.value,
        );
      }).toList(),
    );
  }
}