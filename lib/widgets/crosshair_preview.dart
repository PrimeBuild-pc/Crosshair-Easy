import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/crosshair_model.dart';
import '../utils/constants.dart';

/// A crosshair preview
class CrosshairPreview extends StatefulWidget {
  /// The crosshair model
  final CrosshairModel? crosshair;
  
  /// The background image
  final String? backgroundImage;
  
  /// Whether to show the grid
  final bool showGrid;
  
  /// Whether to show the info
  final bool showInfo;
  
  /// Whether the preview is interactive
  final bool interactive;
  
  /// Create a new crosshair preview
  const CrosshairPreview({
    Key? key,
    this.crosshair,
    this.backgroundImage,
    this.showGrid = false,
    this.showInfo = false,
    this.interactive = false,
  }) : super(key: key);

  @override
  State<CrosshairPreview> createState() => _CrosshairPreviewState();
}

class _CrosshairPreviewState extends State<CrosshairPreview> with SingleTickerProviderStateMixin {
  /// The animation controller for animations
  AnimationController? _animationController;
  
  /// The current animation value
  double _animationValue = 1.0;

  @override
  void initState() {
    super.initState();
    
    if (widget.crosshair?.enableAnimation ?? false) {
      _setupAnimation();
    }
  }
  
  @override
  void didUpdateWidget(CrosshairPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if ((widget.crosshair?.enableAnimation ?? false) != (oldWidget.crosshair?.enableAnimation ?? false) ||
        widget.crosshair?.animationType != oldWidget.crosshair?.animationType ||
        widget.crosshair?.animationSpeed != oldWidget.crosshair?.animationSpeed) {
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
  
  /// Setup the animation
  void _setupAnimation() {
    _animationController?.dispose();
    
    if (widget.crosshair?.enableAnimation ?? false) {
      final speed = widget.crosshair!.animationSpeed;
      final duration = Duration(milliseconds: (1000 / speed).round());
      
      _animationController = AnimationController(
        duration: duration,
        vsync: this,
      );
      
      switch (widget.crosshair!.animationType) {
        case AnimationType.breathing:
          _animationController!.addListener(() {
            setState(() {
              _animationValue = 0.7 + 0.3 * _animationController!.value;
            });
          });
          break;
        case AnimationType.pulse:
          _animationController!.addListener(() {
            setState(() {
              _animationValue = 0.5 + 0.5 * math.sin(_animationController!.value * math.pi * 2);
            });
          });
          break;
        case AnimationType.blink:
          _animationController!.addStatusListener((status) {
            setState(() {
              _animationValue = status == AnimationStatus.forward ? 1.0 : 0.3;
            });
          });
          break;
        case AnimationType.none:
          setState(() {
            _animationValue = 1.0;
          });
          break;
      }
      
      _animationController!.repeat(reverse: widget.crosshair!.animationType == AnimationType.breathing);
    } else {
      setState(() {
        _animationValue = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.previewBackgroundSize,
      height: Constants.previewBackgroundSize,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        image: widget.backgroundImage != null
            ? DecorationImage(
                image: AssetImage(widget.backgroundImage!),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          if (widget.showGrid)
            _buildGrid(),
          if (widget.crosshair != null)
            Center(
              child: CustomPaint(
                size: const Size(Constants.previewBackgroundSize, Constants.previewBackgroundSize),
                painter: CrosshairPainter(
                  crosshair: widget.crosshair!,
                  animationValue: _animationValue,
                ),
              ),
            ),
          if (widget.showInfo && widget.crosshair != null)
            Positioned(
              bottom: Constants.paddingSmall,
              left: Constants.paddingSmall,
              right: Constants.paddingSmall,
              child: Container(
                padding: const EdgeInsets.all(Constants.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
                ),
                child: Text(
                  '${widget.crosshair!.name} (${widget.crosshair!.shape.toString().split('.').last})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// Build the grid
  Widget _buildGrid() {
    return CustomPaint(
      size: const Size(Constants.previewBackgroundSize, Constants.previewBackgroundSize),
      painter: GridPainter(),
    );
  }
}

/// A crosshair painter
class CrosshairPainter extends CustomPainter {
  /// The crosshair model
  final CrosshairModel crosshair;
  
  /// The animation value
  final double animationValue;
  
  /// Create a new crosshair painter
  const CrosshairPainter({
    required this.crosshair,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    switch (crosshair.shape) {
      case CrosshairShape.classic:
        _drawClassicCrosshair(canvas, size, center);
        break;
      case CrosshairShape.dot:
        _drawDotCrosshair(canvas, size, center);
        break;
      case CrosshairShape.cross:
        _drawCrossCrosshair(canvas, size, center);
        break;
      case CrosshairShape.circle:
        _drawCircleCrosshair(canvas, size, center);
        break;
      case CrosshairShape.custom:
        _drawCustomCrosshair(canvas, size, center);
        break;
    }
    
    if (crosshair.showDot) {
      _drawDot(canvas, center);
    }
  }
  
  /// Draw a classic crosshair
  void _drawClassicCrosshair(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = crosshair.color.withOpacity(crosshair.opacity * animationValue)
      ..strokeWidth = crosshair.thickness * Constants.previewCrosshairScale
      ..style = PaintingStyle.stroke;
    
    final outlinePaint = Paint()
      ..color = crosshair.outlineColor.withOpacity(crosshair.opacity * animationValue)
      ..strokeWidth = (crosshair.thickness + crosshair.outlineThickness * 2) * Constants.previewCrosshairScale
      ..style = PaintingStyle.stroke;
    
    final scaledSize = crosshair.size * Constants.previewCrosshairScale;
    final scaledGap = crosshair.gap * Constants.previewCrosshairScale;
    
    if (crosshair.outlineThickness > 0) {
      // Top line
      canvas.drawLine(
        Offset(center.dx, center.dy - scaledSize),
        Offset(center.dx, center.dy - scaledGap),
        outlinePaint,
      );
      
      // Bottom line
      canvas.drawLine(
        Offset(center.dx, center.dy + scaledGap),
        Offset(center.dx, center.dy + scaledSize),
        outlinePaint,
      );
      
      // Left line
      canvas.drawLine(
        Offset(center.dx - scaledSize, center.dy),
        Offset(center.dx - scaledGap, center.dy),
        outlinePaint,
      );
      
      // Right line
      canvas.drawLine(
        Offset(center.dx + scaledGap, center.dy),
        Offset(center.dx + scaledSize, center.dy),
        outlinePaint,
      );
    }
    
    // Top line
    canvas.drawLine(
      Offset(center.dx, center.dy - scaledSize),
      Offset(center.dx, center.dy - scaledGap),
      paint,
    );
    
    // Bottom line
    canvas.drawLine(
      Offset(center.dx, center.dy + scaledGap),
      Offset(center.dx, center.dy + scaledSize),
      paint,
    );
    
    // Left line
    canvas.drawLine(
      Offset(center.dx - scaledSize, center.dy),
      Offset(center.dx - scaledGap, center.dy),
      paint,
    );
    
    // Right line
    canvas.drawLine(
      Offset(center.dx + scaledGap, center.dy),
      Offset(center.dx + scaledSize, center.dy),
      paint,
    );
  }
  
  /// Draw a dot crosshair
  void _drawDotCrosshair(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = crosshair.color.withOpacity(crosshair.opacity * animationValue)
      ..style = PaintingStyle.fill;
    
    final outlinePaint = Paint()
      ..color = crosshair.outlineColor.withOpacity(crosshair.opacity * animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = crosshair.outlineThickness * Constants.previewCrosshairScale;
    
    final radius = crosshair.size / 4 * Constants.previewCrosshairScale;
    
    // Dot
    canvas.drawCircle(center, radius, paint);
    
    if (crosshair.outlineThickness > 0) {
      canvas.drawCircle(center, radius, outlinePaint);
    }
  }
  
  /// Draw a cross crosshair
  void _drawCrossCrosshair(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = crosshair.color.withOpacity(crosshair.opacity * animationValue)
      ..strokeWidth = crosshair.thickness * Constants.previewCrosshairScale
      ..style = PaintingStyle.stroke;
    
    final outlinePaint = Paint()
      ..color = crosshair.outlineColor.withOpacity(crosshair.opacity * animationValue)
      ..strokeWidth = (crosshair.thickness + crosshair.outlineThickness * 2) * Constants.previewCrosshairScale
      ..style = PaintingStyle.stroke;
    
    final scaledSize = crosshair.size * Constants.previewCrosshairScale;
    
    if (crosshair.outlineThickness > 0) {
      // Top-left to bottom-right
      canvas.drawLine(
        Offset(center.dx - scaledSize, center.dy - scaledSize),
        Offset(center.dx + scaledSize, center.dy + scaledSize),
        outlinePaint,
      );
      
      // Top-right to bottom-left
      canvas.drawLine(
        Offset(center.dx + scaledSize, center.dy - scaledSize),
        Offset(center.dx - scaledSize, center.dy + scaledSize),
        outlinePaint,
      );
    }
    
    // Top-left to bottom-right
    canvas.drawLine(
      Offset(center.dx - scaledSize, center.dy - scaledSize),
      Offset(center.dx + scaledSize, center.dy + scaledSize),
      paint,
    );
    
    // Top-right to bottom-left
    canvas.drawLine(
      Offset(center.dx + scaledSize, center.dy - scaledSize),
      Offset(center.dx - scaledSize, center.dy + scaledSize),
      paint,
    );
  }
  
  /// Draw a circle crosshair
  void _drawCircleCrosshair(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = crosshair.color.withOpacity(crosshair.opacity * animationValue)
      ..strokeWidth = crosshair.thickness * Constants.previewCrosshairScale
      ..style = PaintingStyle.stroke;
    
    final outlinePaint = Paint()
      ..color = crosshair.outlineColor.withOpacity(crosshair.opacity * animationValue)
      ..strokeWidth = (crosshair.thickness + crosshair.outlineThickness * 2) * Constants.previewCrosshairScale
      ..style = PaintingStyle.stroke;
    
    final radius = crosshair.size * Constants.previewCrosshairScale / 2;
    
    if (crosshair.outlineThickness > 0) {
      canvas.drawCircle(center, radius, outlinePaint);
    }
    
    canvas.drawCircle(center, radius, paint);
  }
  
  /// Draw a custom crosshair
  void _drawCustomCrosshair(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = crosshair.color.withOpacity(crosshair.opacity * animationValue)
      ..strokeWidth = crosshair.thickness * Constants.previewCrosshairScale;
    
    final scaledSize = crosshair.size * Constants.previewCrosshairScale;
    
    // Example custom crosshair (T-shaped)
    // Top vertical line
    canvas.drawLine(
      Offset(center.dx, center.dy - scaledSize),
      Offset(center.dx, center.dy),
      paint,
    );
    
    // Horizontal line
    canvas.drawLine(
      Offset(center.dx - scaledSize / 2, center.dy),
      Offset(center.dx + scaledSize / 2, center.dy),
      paint,
    );
  }
  
  /// Draw a dot
  void _drawDot(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = crosshair.dotColor.withOpacity(crosshair.opacity * animationValue)
      ..style = PaintingStyle.fill;
    
    final radius = crosshair.dotSize * Constants.previewCrosshairScale;
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CrosshairPainter oldDelegate) {
    return oldDelegate.crosshair != crosshair ||
        oldDelegate.animationValue != animationValue;
  }
}

/// A grid painter
class GridPainter extends CustomPainter {
  /// Create a new grid painter
  const GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    const gridSize = 20.0;
    
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
    
    // Draw center lines
    final centerPaint = Paint()
      ..color = Colors.grey[600]!.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Vertical center line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      centerPaint,
    );
    
    // Horizontal center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return false;
  }
}