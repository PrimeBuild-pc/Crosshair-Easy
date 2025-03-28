import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../utils/constants.dart';

/// An advanced color picker with support for different color modes
/// and predefined color palettes
class AdvancedColorPicker extends StatefulWidget {
  /// The current color
  final Color color;
  
  /// Callback when color is changed
  final ValueChanged<Color> onColorChanged;
  
  /// Whether to show the alpha channel
  final bool enableAlpha;
  
  /// Whether to show the quick palette
  final bool showQuickPalette;
  
  /// Whether to show the fluorescent colors
  final bool showFluorescentColors;
  
  /// Whether to enable color history
  final bool enableColorHistory;
  
  /// Custom title for the picker
  final String? title;
  
  /// Create a new advanced color picker
  const AdvancedColorPicker({
    Key? key,
    required this.color,
    required this.onColorChanged,
    this.enableAlpha = true,
    this.showQuickPalette = true,
    this.showFluorescentColors = true,
    this.enableColorHistory = true,
    this.title,
  }) : super(key: key);

  @override
  State<AdvancedColorPicker> createState() => _AdvancedColorPickerState();
}

class _AdvancedColorPickerState extends State<AdvancedColorPicker> {
  // Track current picker mode
  ColorPickerType _currentPickerType = ColorPickerType.hsv;
  
  // Color history
  final List<Color> _colorHistory = [];
  
  // Gaming-focused fluorescent colors
  final List<Color> _fluorescentColors = [
    const Color(0xFF00FF00), // Neon Green
    const Color(0xFF00FFFF), // Cyan
    const Color(0xFFFF00FF), // Magenta
    const Color(0xFFFF0000), // Red
    const Color(0xFFFFFF00), // Yellow
    const Color(0xFF0000FF), // Blue
    const Color(0xFFFF9900), // Orange
    const Color(0xFF00FF99), // Spring Green
    const Color(0xFF9900FF), // Purple
    const Color(0xFFFF0099), // Pink
  ];
  
  // Gaming-themed color palette
  final List<Color> _gamingColors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.lime,
    Colors.brown,
    Colors.grey,
    const Color(0xFF660000), // Dark Red
    const Color(0xFF006600), // Dark Green
    const Color(0xFF000066), // Dark Blue
    const Color(0xFFFFCCCC), // Light Red
    const Color(0xFFCCFFCC), // Light Green
    const Color(0xFFCCCCFF), // Light Blue
  ];

  @override
  void initState() {
    super.initState();
    if (widget.enableColorHistory) {
      _colorHistory.add(widget.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Constants.paddingSmall),
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          
        // Color mode selector
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildModeSelector(ColorPickerType.hsv, 'HSV'),
              _buildModeSelector(ColorPickerType.hsl, 'HSL'),
              _buildModeSelector(ColorPickerType.rgb, 'RGB'),
              _buildModeSelector(ColorPickerType.material, 'Material'),
              _buildModeSelector(ColorPickerType.wheel, 'Wheel'),
            ],
          ),
        ),
        
        const SizedBox(height: Constants.paddingMedium),
        
        // Color picker based on selected mode
        _buildColorPicker(),
        
        const SizedBox(height: Constants.paddingMedium),
        
        // Quick palette (gaming colors)
        if (widget.showQuickPalette)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gaming Colors',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: Constants.paddingSmall),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _gamingColors.length,
                  itemBuilder: (context, index) {
                    return _buildColorOption(_gamingColors[index]);
                  },
                ),
              ),
            ],
          ),
        
        // Fluorescent colors
        if (widget.showFluorescentColors)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.paddingMedium),
              Text(
                'Fluorescent Colors',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: Constants.paddingSmall),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _fluorescentColors.length,
                  itemBuilder: (context, index) {
                    return _buildColorOption(_fluorescentColors[index]);
                  },
                ),
              ),
            ],
          ),
        
        // Color history
        if (widget.enableColorHistory && _colorHistory.length > 1)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.paddingMedium),
              Text(
                'History',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: Constants.paddingSmall),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colorHistory.length,
                  itemBuilder: (context, index) {
                    return _buildColorOption(_colorHistory[index]);
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
  
  /// Build a mode selector
  Widget _buildModeSelector(ColorPickerType type, String label) {
    final isSelected = _currentPickerType == type;
    
    return Padding(
      padding: const EdgeInsets.only(right: Constants.paddingSmall),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _currentPickerType = type;
            });
          }
        },
      ),
    );
  }
  
  /// Build the appropriate color picker based on the selected mode
  Widget _buildColorPicker() {
    switch (_currentPickerType) {
      case ColorPickerType.hsv:
        return SizedBox(
          width: double.infinity,
          child: ColorPicker(
            pickerColor: widget.color,
            onColorChanged: _handleColorChanged,
            enableAlpha: widget.enableAlpha,
            displayThumbColor: true,
            paletteType: PaletteType.hsv,
            pickerAreaHeightPercent: 0.8,
          ),
        );
      case ColorPickerType.hsl:
        return SizedBox(
          width: double.infinity,
          child: ColorPicker(
            pickerColor: widget.color,
            onColorChanged: _handleColorChanged,
            enableAlpha: widget.enableAlpha,
            displayThumbColor: true,
            paletteType: PaletteType.hsl,
            pickerAreaHeightPercent: 0.8,
          ),
        );
      case ColorPickerType.rgb:
        return SizedBox(
          width: double.infinity,
          child: ColorPicker(
            pickerColor: widget.color,
            onColorChanged: _handleColorChanged,
            enableAlpha: widget.enableAlpha,
            displayThumbColor: true,
            paletteType: PaletteType.rgb,
            pickerAreaHeightPercent: 0.8,
          ),
        );
      case ColorPickerType.material:
        return SizedBox(
          width: double.infinity,
          height: 300,
          child: MaterialPicker(
            pickerColor: widget.color,
            onColorChanged: _handleColorChanged,
            enableLabel: true,
          ),
        );
      case ColorPickerType.wheel:
        return SizedBox(
          width: double.infinity,
          height: 300,
          child: ColorPickerArea(
            builder: (BuildContext context, List<Color> colors) {
              return GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: colors.map((Color color) {
                  return GestureDetector(
                    onTap: () => _handleColorChanged(color),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
    }
  }
  
  /// Handle color change from any source
  void _handleColorChanged(Color color) {
    widget.onColorChanged(color);
    
    if (widget.enableColorHistory) {
      // Add to history if different from last color
      if (_colorHistory.isEmpty || _colorHistory.last != color) {
        setState(() {
          // Keep history to a reasonable size
          if (_colorHistory.length >= 10) {
            _colorHistory.removeAt(0);
          }
          _colorHistory.add(color);
        });
      }
    }
  }
  
  /// Build a color option button
  Widget _buildColorOption(Color color) {
    final isSelected = widget.color.value == color.value;
    const size = 36.0;
    
    return GestureDetector(
      onTap: () => _handleColorChanged(color),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary 
              : color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}

/// The type of color picker
enum ColorPickerType {
  /// HSV color picker
  hsv,
  
  /// HSL color picker
  hsl,
  
  /// RGB color picker
  rgb,
  
  /// Material color picker
  material,
  
  /// Color wheel picker
  wheel,
}