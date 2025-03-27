import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/constants.dart';

/// Widget for selecting crosshair shapes
class ShapeSelector extends StatelessWidget {
  /// Currently selected shape
  final String selectedShape;
  
  /// Callback when shape is selected
  final ValueChanged<String> onShapeSelected;
  
  /// Constructor
  const ShapeSelector({
    Key? key,
    required this.selectedShape,
    required this.onShapeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crosshair Shape',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        
        // Shape grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: AppConstants.crosshairShapes.length,
          itemBuilder: (context, index) {
            final shape = AppConstants.crosshairShapes[index];
            final isSelected = shape == selectedShape;
            
            return _buildShapeItem(shape, isSelected);
          },
        ),
      ],
    );
  }
  
  /// Build a shape selector item
  Widget _buildShapeItem(String shape, bool isSelected) {
    return InkWell(
      onTap: () => onShapeSelected(shape),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withOpacity(0.2) 
              : AppTheme.surfaceColor,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shape preview
            SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: _buildShapePreview(shape),
              ),
            ),
            const SizedBox(height: 8),
            
            // Shape name
            Text(
              shape,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a preview of the shape
  Widget _buildShapePreview(String shape) {
    switch (shape) {
      case 'Classic':
        return _buildClassicPreview();
      case 'Dot':
        return _buildDotPreview();
      case 'Circle':
        return _buildCirclePreview();
      case 'Cross':
        return _buildCrossPreview();
      case 'T':
        return _buildTPreview();
      case 'Square':
        return _buildSquarePreview();
      case 'Diamond':
        return _buildDiamondPreview();
      default:
        return _buildClassicPreview();
    }
  }
  
  /// Build a preview of the classic (plus) crosshair
  Widget _buildClassicPreview() {
    final color = AppTheme.primaryColor;
    
    return Stack(
      children: [
        // Horizontal line
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 24,
            height: 2,
            color: color,
          ),
        ),
        
        // Vertical line
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 2,
            height: 24,
            color: color,
          ),
        ),
        
        // Gap in the center
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 4,
            height: 4,
            color: AppTheme.surfaceColor,
          ),
        ),
      ],
    );
  }
  
  /// Build a preview of the dot crosshair
  Widget _buildDotPreview() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
  
  /// Build a preview of the circle crosshair
  Widget _buildCirclePreview() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 2,
        ),
      ),
    );
  }
  
  /// Build a preview of the cross crosshair (X shape)
  Widget _buildCrossPreview() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: CrossPainter(
          color: AppTheme.primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
  
  /// Build a preview of the T crosshair
  Widget _buildTPreview() {
    final color = AppTheme.primaryColor;
    
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        children: [
          // Horizontal line (top)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 20,
              height: 2,
              color: color,
            ),
          ),
          
          // Vertical line (center)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 2,
              height: 20,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build a preview of the square crosshair
  Widget _buildSquarePreview() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 2,
        ),
      ),
    );
  }
  
  /// Build a preview of the diamond crosshair
  Widget _buildDiamondPreview() {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees in radians
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: AppTheme.primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the cross (X) shape
class CrossPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  
  CrossPainter({
    required this.color,
    required this.strokeWidth,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // Draw X shape
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
    
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(CrossPainter oldDelegate) {
    return oldDelegate.color != color || 
           oldDelegate.strokeWidth != strokeWidth;
  }
}