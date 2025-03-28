import 'package:flutter/material.dart';
import '../models/crosshair_model.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

/// A shape selector button
class ShapeSelectorButton extends StatelessWidget {
  /// The shape
  final CrosshairShape shape;
  
  /// Callback when the shape is selected
  final VoidCallback onTap;
  
  /// Whether the shape is selected
  final bool isSelected;
  
  /// Create a new shape selector button
  const ShapeSelectorButton({
    Key? key,
    required this.shape,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey[800]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: _buildShapeIcon(),
        ),
      ),
    );
  }
  
  /// Build the shape icon
  Widget _buildShapeIcon() {
    switch (shape) {
      case CrosshairShape.classic:
        return CustomPaint(
          size: const Size(30, 30),
          painter: ClassicCrosshairPainter(
            color: isSelected ? AppTheme.primary : Colors.white,
          ),
        );
      case CrosshairShape.dot:
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.white,
            shape: BoxShape.circle,
          ),
        );
      case CrosshairShape.cross:
        return CustomPaint(
          size: const Size(30, 30),
          painter: CrossCrosshairPainter(
            color: isSelected ? AppTheme.primary : Colors.white,
          ),
        );
      case CrosshairShape.circle:
        return CustomPaint(
          size: const Size(30, 30),
          painter: CircleCrosshairPainter(
            color: isSelected ? AppTheme.primary : Colors.white,
          ),
        );
      case CrosshairShape.custom:
        return Icon(
          Icons.add_circle_outline,
          color: isSelected ? AppTheme.primary : Colors.white,
          size: 30,
        );
    }
  }
}

/// A shape selector
class ShapeSelector extends StatelessWidget {
  /// The current shape
  final CrosshairShape currentShape;
  
  /// Callback when a shape is selected
  final ValueChanged<CrosshairShape> onShapeSelected;
  
  /// Create a new shape selector
  const ShapeSelector({
    Key? key,
    required this.currentShape,
    required this.onShapeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shape',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Constants.paddingSmall),
        Wrap(
          spacing: 0,
          runSpacing: 0,
          children: CrosshairShape.values.map((shape) {
            return ShapeSelectorButton(
              shape: shape,
              onTap: () => onShapeSelected(shape),
              isSelected: currentShape == shape,
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// A classic crosshair painter
class ClassicCrosshairPainter extends CustomPainter {
  /// The color
  final Color color;
  
  /// Create a new classic crosshair painter
  const ClassicCrosshairPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final center = Offset(size.width / 2, size.height / 2);
    final gap = 5.0;
    
    // Top line
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, center.dy - gap),
      paint,
    );
    
    // Bottom line
    canvas.drawLine(
      Offset(center.dx, center.dy + gap),
      Offset(center.dx, size.height),
      paint,
    );
    
    // Left line
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(center.dx - gap, center.dy),
      paint,
    );
    
    // Right line
    canvas.drawLine(
      Offset(center.dx + gap, center.dy),
      Offset(size.width, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(ClassicCrosshairPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// A cross crosshair painter
class CrossCrosshairPainter extends CustomPainter {
  /// The color
  final Color color;
  
  /// Create a new cross crosshair painter
  const CrossCrosshairPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Top-left to bottom-right line
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
    
    // Top-right to bottom-left line
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CrossCrosshairPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// A circle crosshair painter
class CircleCrosshairPainter extends CustomPainter {
  /// The color
  final Color color;
  
  /// Create a new circle crosshair painter
  const CircleCrosshairPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    
    // Circle
    canvas.drawCircle(center, radius, paint);
    
    // Center dot
    canvas.drawCircle(
      center,
      2,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CircleCrosshairPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}