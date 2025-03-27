import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/constants.dart';

/// A custom color picker widget
class ColorPicker extends StatefulWidget {
  /// Current color value
  final Color currentColor;
  
  /// Callback when color changes
  final ValueChanged<Color> onColorChanged;
  
  /// Constructor
  const ColorPicker({
    Key? key,
    required this.currentColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Color _color;
  late double _hue;
  late double _saturation;
  late double _value;
  late int _red;
  late int _green;
  late int _blue;
  
  @override
  void initState() {
    super.initState();
    _color = widget.currentColor;
    _updateHSVFromColor();
    _updateRGBFromColor();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentColor != oldWidget.currentColor) {
      _color = widget.currentColor;
      _updateHSVFromColor();
      _updateRGBFromColor();
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Update HSV values from the current color
  void _updateHSVFromColor() {
    final HSVColor hsv = HSVColor.fromColor(_color);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
  }
  
  // Update RGB values from the current color
  void _updateRGBFromColor() {
    _red = _color.red;
    _green = _color.green;
    _blue = _color.blue;
  }
  
  // Update color when HSV values change
  void _updateColorFromHSV() {
    final newColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
    if (newColor != _color) {
      setState(() {
        _color = newColor;
        _updateRGBFromColor();
      });
      widget.onColorChanged(_color);
    }
  }
  
  // Update color when RGB values change
  void _updateColorFromRGB() {
    final newColor = Color.fromARGB(255, _red, _green, _blue);
    if (newColor != _color) {
      setState(() {
        _color = newColor;
        _updateHSVFromColor();
      });
      widget.onColorChanged(_color);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current color display and preset colors
        Row(
          children: [
            // Current color
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _color,
                border: Border.all(color: AppTheme.dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            
            // Preset colors
            Expanded(
              child: SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.defaultColors.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final presetColor = AppConstants.defaultColors[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _color = presetColor;
                          _updateHSVFromColor();
                          _updateRGBFromColor();
                        });
                        widget.onColorChanged(_color);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: presetColor,
                          border: Border.all(
                            color: _color == presetColor
                                ? AppTheme.primaryColor
                                : AppTheme.dividerColor,
                            width: _color == presetColor ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Tabs for HSV and RGB
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'HSV'),
            Tab(text: 'RGB'),
          ],
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.secondaryTextColor,
          indicatorColor: AppTheme.primaryColor,
        ),
        
        // Tab content
        SizedBox(
          height: 160,
          child: TabBarView(
            controller: _tabController,
            children: [
              // HSV tab
              _buildHSVTab(),
              
              // RGB tab
              _buildRGBTab(),
            ],
          ),
        ),
      ],
    );
  }
  
  // Build the HSV tab
  Widget _buildHSVTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Hue slider
          _buildColorSlider(
            label: 'Hue',
            value: _hue,
            min: 0,
            max: 360,
            activeColor: HSVColor.fromAHSV(1, _hue, 1, 1).toColor(),
            onChanged: (value) {
              setState(() {
                _hue = value;
                _updateColorFromHSV();
              });
            },
          ),
          
          // Saturation slider
          _buildColorSlider(
            label: 'Saturation',
            value: _saturation,
            min: 0,
            max: 1,
            activeColor: HSVColor.fromAHSV(1, _hue, _saturation, 1).toColor(),
            onChanged: (value) {
              setState(() {
                _saturation = value;
                _updateColorFromHSV();
              });
            },
          ),
          
          // Value (brightness) slider
          _buildColorSlider(
            label: 'Value',
            value: _value,
            min: 0,
            max: 1,
            activeColor: HSVColor.fromAHSV(1, _hue, 1, _value).toColor(),
            onChanged: (value) {
              setState(() {
                _value = value;
                _updateColorFromHSV();
              });
            },
          ),
        ],
      ),
    );
  }
  
  // Build the RGB tab
  Widget _buildRGBTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Red slider
          _buildColorSlider(
            label: 'Red',
            value: _red.toDouble(),
            min: 0,
            max: 255,
            activeColor: Colors.red.shade700,
            valueLabel: _red.toString(),
            onChanged: (value) {
              setState(() {
                _red = value.round();
                _updateColorFromRGB();
              });
            },
          ),
          
          // Green slider
          _buildColorSlider(
            label: 'Green',
            value: _green.toDouble(),
            min: 0,
            max: 255,
            activeColor: Colors.green.shade700,
            valueLabel: _green.toString(),
            onChanged: (value) {
              setState(() {
                _green = value.round();
                _updateColorFromRGB();
              });
            },
          ),
          
          // Blue slider
          _buildColorSlider(
            label: 'Blue',
            value: _blue.toDouble(),
            min: 0,
            max: 255,
            activeColor: Colors.blue.shade700,
            valueLabel: _blue.toString(),
            onChanged: (value) {
              setState(() {
                _blue = value.round();
                _updateColorFromRGB();
              });
            },
          ),
        ],
      ),
    );
  }
  
  // Build a slider for color components
  Widget _buildColorSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Color activeColor,
    String? valueLabel,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: activeColor,
            inactiveColor: AppTheme.backgroundColor,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            valueLabel ?? (max > 1 ? value.round().toString() : value.toStringAsFixed(2)),
            style: TextStyle(
              color: AppTheme.textColor,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}