import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/crosshair_model.dart';
import '../theme/app_theme.dart';
import '../utils/ffi_bridge.dart';

/// Widget for displaying a crosshair preview
class CrosshairPreview extends StatefulWidget {
  /// Crosshair model to preview
  final CrosshairModel crosshair;
  
  /// Background type ('Dark', 'Light', 'Gray', 'White', 'Transparent')
  final String backgroundType;
  
  /// Size of the preview widget
  final double size;
  
  /// Show grid lines in the background
  final bool showGrid;
  
  /// Constructor
  const CrosshairPreview({
    Key? key,
    required this.crosshair,
    this.backgroundType = 'Dark',
    this.size = 200,
    this.showGrid = false,
  }) : super(key: key);

  @override
  _CrosshairPreviewState createState() => _CrosshairPreviewState();
}

class _CrosshairPreviewState extends State<CrosshairPreview> with SingleTickerProviderStateMixin {
  ui.Image? _crosshairImage;
  bool _isLoading = true;
  AnimationController? _animationController;
  Timer? _animationTrigger;
  
  @override
  void initState() {
    super.initState();
    _renderCrosshair();
    
    if (widget.crosshair.animated) {
      _setupAnimation();
    }
  }
  
  @override
  void didUpdateWidget(CrosshairPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Re-render if crosshair properties changed
    if (widget.crosshair != oldWidget.crosshair ||
        widget.backgroundType != oldWidget.backgroundType ||
        widget.size != oldWidget.size) {
      _renderCrosshair();
    }
    
    // Update animation state if needed
    if (widget.crosshair.animated != oldWidget.crosshair.animated ||
        widget.crosshair.animationType != oldWidget.crosshair.animationType ||
        widget.crosshair.animationSpeed != oldWidget.crosshair.animationSpeed) {
      _updateAnimation();
    }
  }
  
  @override
  void dispose() {
    _animationController?.dispose();
    _animationTrigger?.cancel();
    super.dispose();
  }
  
  // Setup animation controller
  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (1000 / widget.crosshair.animationSpeed).round()),
    );
    
    _animationController!.repeat(reverse: true);
    
    // For types of animations that need to be re-triggered
    if (widget.crosshair.animationType == 'Pulse' ||
        widget.crosshair.animationType == 'Expand') {
      _setupAnimationTrigger();
    }
  }
  
  // Setup a trigger for animations that should fire periodically
  void _setupAnimationTrigger() {
    _animationTrigger?.cancel();
    
    _animationTrigger = Timer.periodic(
      Duration(seconds: 3), 
      (_) {
        if (_animationController != null) {
          _animationController!.reset();
          _animationController!.repeat(reverse: true);
        }
      },
    );
  }
  
  // Update animation when properties change
  void _updateAnimation() {
    _animationController?.dispose();
    _animationController = null;
    _animationTrigger?.cancel();
    
    if (widget.crosshair.animated) {
      _setupAnimation();
    }
  }
  
  // Render the crosshair
  Future<void> _renderCrosshair() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final renderedData = await FFIBridge.renderCrosshair(
        shape: widget.crosshair.shape,
        size: widget.crosshair.size.toInt(),
        thickness: widget.crosshair.thickness.toInt(),
        gap: widget.crosshair.gap.toInt(),
        opacity: (widget.crosshair.opacity * 255).toInt(),
        centerDotSize: widget.crosshair.centerDotSize.toInt(),
        outline: widget.crosshair.outline,
        outlineThickness: widget.crosshair.outlineThickness.toInt(),
        color: widget.crosshair.color.value,
        outlineColor: widget.crosshair.outlineColor.value,
        backgroundColor: _getBackgroundColor().value,
        width: widget.size.toInt(),
        height: widget.size.toInt(),
      );
      
      final codec = await ui.instantiateImageCodec(renderedData);
      final frame = await codec.getNextFrame();
      
      setState(() {
        _crosshairImage = frame.image;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error rendering crosshair: $e');
    }
  }
  
  // Get the background color based on the selected type
  Color _getBackgroundColor() {
    switch (widget.backgroundType) {
      case 'White':
        return Colors.white;
      case 'Gray':
        return Colors.grey.shade700;
      case 'Light':
        return Colors.grey.shade300;
      case 'Transparent':
        return Colors.transparent;
      case 'Dark':
      default:
        return Colors.black87;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Grid background if enabled
          if (widget.showGrid)
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: GridPainter(
                gridSize: 10,
                lineColor: AppTheme.dividerColor.withOpacity(0.5),
              ),
            ),
          
          // Crosshair image or loading indicator
          if (_isLoading)
            Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              ),
            )
          else if (_crosshairImage != null)
            widget.crosshair.animated && _animationController != null
              ? AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return _buildAnimatedCrosshair();
                  },
                )
              : Center(
                  child: RawImage(
                    image: _crosshairImage,
                    width: widget.size,
                    height: widget.size,
                    fit: BoxFit.contain,
                  ),
                ),
        ],
      ),
    );
  }
  
  // Build an animated version of the crosshair
  Widget _buildAnimatedCrosshair() {
    if (_crosshairImage == null || _animationController == null) {
      return const SizedBox.shrink();
    }
    
    switch (widget.crosshair.animationType) {
      case 'Pulse':
        return Opacity(
          opacity: 0.5 + (_animationController!.value * 0.5),
          child: RawImage(
            image: _crosshairImage,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        );
        
      case 'Breathe':
        return Opacity(
          opacity: 0.7 + (_animationController!.value * 0.3),
          child: RawImage(
            image: _crosshairImage,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        );
        
      case 'Expand':
        final scale = 0.8 + (_animationController!.value * 0.4);
        return Transform.scale(
          scale: scale,
          child: RawImage(
            image: _crosshairImage,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        );
        
      case 'Contract':
        final scale = 1.2 - (_animationController!.value * 0.4);
        return Transform.scale(
          scale: scale,
          child: RawImage(
            image: _crosshairImage,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        );
        
      case 'Rotate':
        final angle = _animationController!.value * 0.2;
        return Transform.rotate(
          angle: angle,
          child: RawImage(
            image: _crosshairImage,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        );
        
      default:
        return RawImage(
          image: _crosshairImage,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
        );
    }
  }
}

/// Custom painter for drawing a grid
class GridPainter extends CustomPainter {
  final double gridSize;
  final Color lineColor;
  
  GridPainter({
    required this.gridSize,
    required this.lineColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5;
    
    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw center lines with different color/thickness
    final centerPaint = Paint()
      ..color = lineColor.withOpacity(0.8)
      ..strokeWidth = 1.0;
    
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Horizontal center line
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      centerPaint,
    );
    
    // Vertical center line
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      centerPaint,
    );
  }
  
  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize ||
           oldDelegate.lineColor != lineColor;
  }
}