import 'dart:ui';
import 'package:uuid/uuid.dart';

/// The shape of the crosshair
enum CrosshairShape {
  /// Classic crosshair shape
  classic,
  
  /// Dot crosshair shape
  dot,
  
  /// Cross crosshair shape
  cross,
  
  /// Circle crosshair shape
  circle,
  
  /// Custom crosshair shape
  custom,
}

/// The type of crosshair animation
enum AnimationType {
  /// No animation
  none,
  
  /// Breathing animation
  breathing,
  
  /// Pulse animation
  pulse,
  
  /// Blink animation
  blink,
}

/// A model representing a customizable crosshair
class CrosshairModel {
  /// The unique identifier
  final String id;
  
  /// The name
  String name;
  
  /// The color
  Color color;
  
  /// The opacity (0.0 - 1.0)
  double opacity;
  
  /// The size
  double size;
  
  /// The thickness
  double thickness;
  
  /// The outline thickness
  double outlineThickness;
  
  /// The outline color
  Color outlineColor;
  
  /// The gap size
  double gap;
  
  /// The shape
  CrosshairShape shape;
  
  /// Whether to show the dot
  bool showDot;
  
  /// The dot size
  double dotSize;
  
  /// The dot color
  Color dotColor;
  
  /// Whether to enable animation
  bool enableAnimation;
  
  /// The animation type
  AnimationType animationType;
  
  /// The animation speed
  double animationSpeed;
  
  /// Create a new crosshair
  CrosshairModel({
    String? id,
    this.name = 'New Crosshair',
    this.color = const Color(0xFFFFFFFF),
    this.opacity = 1.0,
    this.size = 20.0,
    this.thickness = 2.0,
    this.outlineThickness = 0.0,
    this.outlineColor = const Color(0xFF000000),
    this.gap = 5.0,
    this.shape = CrosshairShape.classic,
    this.showDot = false,
    this.dotSize = 2.0,
    this.dotColor = const Color(0xFFFFFFFF),
    this.enableAnimation = false,
    this.animationType = AnimationType.none,
    this.animationSpeed = 1.0,
  }) : id = id ?? const Uuid().v4();
  
  /// Create a copy with the given parameters
  CrosshairModel copyWith({
    String? name,
    Color? color,
    double? opacity,
    double? size,
    double? thickness,
    double? outlineThickness,
    Color? outlineColor,
    double? gap,
    CrosshairShape? shape,
    bool? showDot,
    double? dotSize,
    Color? dotColor,
    bool? enableAnimation,
    AnimationType? animationType,
    double? animationSpeed,
  }) {
    return CrosshairModel(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      size: size ?? this.size,
      thickness: thickness ?? this.thickness,
      outlineThickness: outlineThickness ?? this.outlineThickness,
      outlineColor: outlineColor ?? this.outlineColor,
      gap: gap ?? this.gap,
      shape: shape ?? this.shape,
      showDot: showDot ?? this.showDot,
      dotSize: dotSize ?? this.dotSize,
      dotColor: dotColor ?? this.dotColor,
      enableAnimation: enableAnimation ?? this.enableAnimation,
      animationType: animationType ?? this.animationType,
      animationSpeed: animationSpeed ?? this.animationSpeed,
    );
  }
  
  /// Convert this model to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'opacity': opacity,
      'size': size,
      'thickness': thickness,
      'outlineThickness': outlineThickness,
      'outlineColor': outlineColor.value,
      'gap': gap,
      'shape': shape.index,
      'showDot': showDot,
      'dotSize': dotSize,
      'dotColor': dotColor.value,
      'enableAnimation': enableAnimation,
      'animationType': animationType.index,
      'animationSpeed': animationSpeed,
    };
  }
  
  /// Create a model from a map
  factory CrosshairModel.fromMap(Map<String, dynamic> map) {
    return CrosshairModel(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
      opacity: map['opacity'],
      size: map['size'],
      thickness: map['thickness'],
      outlineThickness: map['outlineThickness'],
      outlineColor: Color(map['outlineColor']),
      gap: map['gap'],
      shape: CrosshairShape.values[map['shape']],
      showDot: map['showDot'],
      dotSize: map['dotSize'],
      dotColor: Color(map['dotColor']),
      enableAnimation: map['enableAnimation'],
      animationType: AnimationType.values[map['animationType']],
      animationSpeed: map['animationSpeed'],
    );
  }
  
  /// Convert to CSV format
  String toCsv() {
    return '"$id","$name",${color.value},${opacity.toStringAsFixed(2)},${size.toStringAsFixed(2)},${thickness.toStringAsFixed(2)},${outlineThickness.toStringAsFixed(2)},${outlineColor.value},${gap.toStringAsFixed(2)},${shape.index},${showDot ? 1 : 0},${dotSize.toStringAsFixed(2)},${dotColor.value},${enableAnimation ? 1 : 0},${animationType.index},${animationSpeed.toStringAsFixed(2)}';
  }
  
  /// Get CSV header
  static String csvHeader() {
    return '"ID","Name","Color","Opacity","Size","Thickness","OutlineThickness","OutlineColor","Gap","Shape","ShowDot","DotSize","DotColor","EnableAnimation","AnimationType","AnimationSpeed"';
  }
}