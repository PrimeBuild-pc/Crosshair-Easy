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
  
  /// The background color
  final Color backgroundColor;
  
  /// Create a new crosshair preview
  const CrosshairPreview({
    Key? key,
    this.crosshair,
    this.backgroundImage,
    this.showGrid = false,
    this.showInfo = false,
    this.interactive = false,
    this.backgroundColor = const Color(0xFF1A1A1A),
  }) : super(key: key);

  @override
  State<CrosshairPreview> createState() => _CrosshairPreviewState();
}

class _CrosshairPreviewState extends State<CrosshairPreview> with SingleTickerProviderStateMixin {
  /// The animation controller for animations
  AnimationController? _animationController;
  
  /// The current animation value
  double _animationValue = 1.0;
  
  /// Current rotation angle (for rotate animation)
  double _rotationAngle = 0.0;
  
  /// Current scale factor (for scale animation)
  double _scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    
    if (widget.crosshair != null && widget.crosshair!.animation.enabled) {
      _setupAnimation();
    }
  }
  
  @override
  void didUpdateWidget(CrosshairPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final oldAnimate = oldWidget.crosshair != null && oldWidget.crosshair!.animation.enabled;
    final newAnimate = widget.crosshair != null && widget.crosshair!.animation.enabled;
    
    if (oldAnimate != newAnimate || 
        (newAnimate && oldWidget.crosshair!.animation.type != widget.crosshair!.animation.type) ||
        (newAnimate && oldWidget.crosshair!.animation.speed != widget.crosshair!.animation.speed) ||
        (newAnimate && oldWidget.crosshair!.animation.intensity != widget.crosshair!.animation.intensity)) {
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
    _animationController = null;
    
    if (widget.crosshair != null && widget.crosshair!.animation.enabled) {
      final speed = widget.crosshair!.animation.speed;
      final duration = Duration(milliseconds: (2000 / speed).round());
      final intensity = widget.crosshair!.animation.intensity;
      
      _animationController = AnimationController(
        duration: duration,
        vsync: this,
      );
      
      switch (widget.crosshair!.animation.type) {
        case CrosshairAnimationType.breathing:
          _animationController!.addListener(() {
            setState(() {
              // Calculate animation value with max range based on intensity
              final amplitude = 0.3 * intensity;
              _animationValue = (1.0 - amplitude) + amplitude * 
                (0.5 + 0.5 * math.sin(_animationController!.value * math.pi * 2));
              _rotationAngle = 0.0;
              _scaleFactor = 1.0;
            });
          });
          break;
        case CrosshairAnimationType.pulse:
          _animationController!.addListener(() {
            setState(() {
              // Pulse has sharper transitions than breathing
              final amplitude = 0.5 * intensity;
              _animationValue = (1.0 - amplitude) + amplitude * 
                math.pow(math.sin(_animationController!.value * math.pi * 2), 2).toDouble();
              _rotationAngle = 0.0;
              _scaleFactor = 1.0;
            });
          });
          break;
        case CrosshairAnimationType.blink:
          _animationController!.addListener(() {
            setState(() {
              // Binary blink - either visible or faded based on intensity
              final minValue = 1.0 - (0.8 * intensity);
              _animationValue = _animationController!.value < 0.5 ? 1.0 : minValue;
              _rotationAngle = 0.0;
              _scaleFactor = 1.0;
            });
          });
          break;
        case CrosshairAnimationType.scale:
          _animationController!.addListener(() {
            setState(() {
              // Scale animation - grows and shrinks
              _animationValue = 1.0;
              _rotationAngle = 0.0;
              // Range of scaling based on intensity
              final amplitude = 0.3 * intensity;
              _scaleFactor = 1.0 + amplitude * 
                math.sin(_animationController!.value * math.pi * 2);
            });
          });
          break;
        case CrosshairAnimationType.rotate:
          _animationController!.addListener(() {
            setState(() {
              // Rotation animation
              _animationValue = 1.0;
              // Range of rotation in radians based on intensity
              final amplitude = math.pi / 8 * intensity;
              _rotationAngle = amplitude * 
                math.sin(_animationController!.value * math.pi * 2);
              _scaleFactor = 1.0;
            });
          });
          break;
      }
      
      _animationController!.repeat();
    } else {
      setState(() {
        _animationValue = 1.0;
        _rotationAngle = 0.0;
        _scaleFactor = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.previewBackgroundSize,
      height: Constants.previewBackgroundSize,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
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
              child: Transform.rotate(
                angle: _rotationAngle,
                child: Transform.scale(
                  scale: _scaleFactor,
                  child: CustomPaint(
                    size: const Size(Constants.previewBackgroundSize, Constants.previewBackgroundSize),
                    painter: CrosshairPainter(
                      crosshair: widget.crosshair!,
                      animationValue: _animationValue,
                    ),
                  ),
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
                  widget.crosshair!.name,
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
    
    // Apply global scale and opacity
    final globalScale = crosshair.scale;
    final globalOpacity = crosshair.opacity * animationValue;
    
    // Draw outer circle if enabled
    if (crosshair.outerCircle.enabled) {
      _drawCircleComponent(canvas, center, crosshair.outerCircle, globalScale, globalOpacity);
    }
    
    // Draw inner circle if enabled
    if (crosshair.innerCircle.enabled) {
      _drawCircleComponent(canvas, center, crosshair.innerCircle, globalScale, globalOpacity);
    }
    
    // Draw lines if enabled
    if (crosshair.topLine.enabled) {
      _drawLineComponent(canvas, center, crosshair.topLine, globalScale, globalOpacity);
    }
    
    if (crosshair.rightLine.enabled) {
      _drawLineComponent(canvas, center, crosshair.rightLine, globalScale, globalOpacity);
    }
    
    if (crosshair.bottomLine.enabled) {
      _drawLineComponent(canvas, center, crosshair.bottomLine, globalScale, globalOpacity);
    }
    
    if (crosshair.leftLine.enabled) {
      _drawLineComponent(canvas, center, crosshair.leftLine, globalScale, globalOpacity);
    }
    
    // Draw center dot if enabled
    if (crosshair.centerDot.enabled) {
      _drawDotComponent(canvas, center, crosshair.centerDot, globalScale, globalOpacity);
    }
  }
  
  /// Draw a line component
  void _drawLineComponent(Canvas canvas, Offset center, LineComponent line, double globalScale, double globalOpacity) {
    final componentOpacity = line.opacity * globalOpacity;
    final componentColor = crosshair.globalColor ?? line.color;
    
    final scaledThickness = line.thickness * Constants.previewCrosshairScale * globalScale;
    final scaledOutlineThickness = line.outlineThickness * Constants.previewCrosshairScale * globalScale;
    final scaledLength = line.length * Constants.previewCrosshairScale * globalScale;
    final scaledGap = line.gap * Constants.previewCrosshairScale * globalScale;
    
    // Apply offset to center position
    final scaledOffset = Offset(
      line.offset.dx * Constants.previewCrosshairScale * globalScale,
      line.offset.dy * Constants.previewCrosshairScale * globalScale,
    );
    final lineCenter = center + scaledOffset;
    
    // Create paint objects
    final paint = Paint()
      ..color = componentColor.withOpacity(componentOpacity)
      ..strokeWidth = scaledThickness
      ..style = PaintingStyle.stroke;
    
    final outlinePaint = Paint()
      ..color = line.outlineColor.withOpacity(componentOpacity)
      ..strokeWidth = scaledThickness + (scaledOutlineThickness * 2)
      ..style = PaintingStyle.stroke;
    
    // Set StrokeCap based on capStyle
    switch (line.capStyle) {
      case LineCapStyle.butt:
        paint.strokeCap = StrokeCap.butt;
        outlinePaint.strokeCap = StrokeCap.butt;
        break;
      case LineCapStyle.round:
        paint.strokeCap = StrokeCap.round;
        outlinePaint.strokeCap = StrokeCap.round;
        break;
      case LineCapStyle.square:
        paint.strokeCap = StrokeCap.square;
        outlinePaint.strokeCap = StrokeCap.square;
        break;
    }
    
    // Calculate line start and end points based on offset direction
    Offset start, end;
    final direction = line.offset.direction;
    
    if (direction.abs() < 0.1) { // Horizontal left to right
      start = Offset(lineCenter.dx - scaledLength, lineCenter.dy);
      end = Offset(lineCenter.dx - scaledGap, lineCenter.dy);
    } else if ((direction - math.pi).abs() < 0.1) { // Horizontal right to left
      start = Offset(lineCenter.dx + scaledGap, lineCenter.dy);
      end = Offset(lineCenter.dx + scaledLength, lineCenter.dy);
    } else if ((direction - math.pi/2).abs() < 0.1) { // Vertical top to bottom
      start = Offset(lineCenter.dx, lineCenter.dy + scaledGap);
      end = Offset(lineCenter.dx, lineCenter.dy + scaledLength);
    } else if ((direction + math.pi/2).abs() < 0.1) { // Vertical bottom to top
      start = Offset(lineCenter.dx, lineCenter.dy - scaledLength);
      end = Offset(lineCenter.dx, lineCenter.dy - scaledGap);
    } else {
      // For any other angle, use the offset direction to calculate the line
      final angle = math.atan2(line.offset.dy, line.offset.dx);
      final nx = math.cos(angle);
      final ny = math.sin(angle);
      
      start = Offset(
        lineCenter.dx + nx * scaledGap,
        lineCenter.dy + ny * scaledGap,
      );
      end = Offset(
        lineCenter.dx + nx * scaledLength,
        lineCenter.dy + ny * scaledLength,
      );
    }
    
    // Draw outline if needed
    if (scaledOutlineThickness > 0) {
      canvas.drawLine(start, end, outlinePaint);
    }
    
    // Draw main line
    canvas.drawLine(start, end, paint);
  }
  
  /// Draw a circle component
  void _drawCircleComponent(Canvas canvas, Offset center, CircleComponent circle, double globalScale, double globalOpacity) {
    final componentOpacity = circle.opacity * globalOpacity;
    final componentColor = crosshair.globalColor ?? circle.color;
    
    final scaledThickness = circle.thickness * Constants.previewCrosshairScale * globalScale;
    final scaledOutlineThickness = circle.outlineThickness * Constants.previewCrosshairScale * globalScale;
    final scaledRadius = circle.radius * Constants.previewCrosshairScale * globalScale;
    
    // Apply offset to center position
    final scaledOffset = Offset(
      circle.offset.dx * Constants.previewCrosshairScale * globalScale,
      circle.offset.dy * Constants.previewCrosshairScale * globalScale,
    );
    final circleCenter = center + scaledOffset;
    
    // Create paint objects
    final paint = Paint()
      ..color = componentColor.withOpacity(componentOpacity)
      ..strokeWidth = scaledThickness
      ..style = circle.filled ? PaintingStyle.fill : PaintingStyle.stroke;
    
    final outlinePaint = Paint()
      ..color = circle.outlineColor.withOpacity(componentOpacity)
      ..strokeWidth = scaledThickness + (scaledOutlineThickness * 2)
      ..style = PaintingStyle.stroke;
    
    // Draw outline if needed
    if (scaledOutlineThickness > 0 && !circle.filled) {
      canvas.drawCircle(circleCenter, scaledRadius, outlinePaint);
    }
    
    // Draw main circle
    canvas.drawCircle(circleCenter, scaledRadius, paint);
    
    // If filled with outline, draw the outline on top
    if (scaledOutlineThickness > 0 && circle.filled) {
      outlinePaint.style = PaintingStyle.stroke;
      canvas.drawCircle(circleCenter, scaledRadius, outlinePaint);
    }
  }
  
  /// Draw a dot component
  void _drawDotComponent(Canvas canvas, Offset center, DotComponent dot, double globalScale, double globalOpacity) {
    final componentOpacity = dot.opacity * globalOpacity;
    final componentColor = crosshair.globalColor ?? dot.color;
    
    final scaledSize = dot.size * Constants.previewCrosshairScale * globalScale;
    final scaledOutlineThickness = dot.outlineThickness * Constants.previewCrosshairScale * globalScale;
    
    // Apply offset to center position
    final scaledOffset = Offset(
      dot.offset.dx * Constants.previewCrosshairScale * globalScale,
      dot.offset.dy * Constants.previewCrosshairScale * globalScale,
    );
    final dotCenter = center + scaledOffset;
    
    // Create paint objects
    final paint = Paint()
      ..color = componentColor.withOpacity(componentOpacity)
      ..style = PaintingStyle.fill;
    
    final outlinePaint = Paint()
      ..color = dot.outlineColor.withOpacity(componentOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scaledOutlineThickness;
    
    // Draw dot
    canvas.drawCircle(dotCenter, scaledSize, paint);
    
    // Draw outline if needed
    if (scaledOutlineThickness > 0) {
      canvas.drawCircle(dotCenter, scaledSize, outlinePaint);
    }
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