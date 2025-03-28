import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

/// Enum for different line cap styles
enum LineCapStyle {
  /// Butt cap style (flat end)
  butt,
  
  /// Round cap style (rounded end)
  round,
  
  /// Square cap style (square end)
  square,
}

/// Basic shape component
class ShapeComponent {
  /// Whether the component is enabled
  final bool enabled;
  
  /// The color of the component
  final Color color;
  
  /// The opacity of the component (0.0 - 1.0)
  final double opacity;
  
  /// The thickness of the component
  final double thickness;
  
  /// The outline thickness of the component
  final double outlineThickness;
  
  /// The outline color of the component
  final Color outlineColor;
  
  /// The line cap style of the component
  final LineCapStyle capStyle;
  
  /// The offset from center
  final Offset offset;
  
  /// Create a new shape component
  ShapeComponent({
    this.enabled = true,
    this.color = Colors.white,
    this.opacity = 1.0,
    this.thickness = 2.0,
    this.outlineThickness = 0.0,
    this.outlineColor = Colors.black,
    this.capStyle = LineCapStyle.butt,
    this.offset = Offset.zero,
  });
  
  /// Copy with new parameters
  ShapeComponent copyWith({
    bool? enabled,
    Color? color,
    double? opacity,
    double? thickness,
    double? outlineThickness,
    Color? outlineColor,
    LineCapStyle? capStyle,
    Offset? offset,
  }) {
    return ShapeComponent(
      enabled: enabled ?? this.enabled,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      thickness: thickness ?? this.thickness,
      outlineThickness: outlineThickness ?? this.outlineThickness,
      outlineColor: outlineColor ?? this.outlineColor,
      capStyle: capStyle ?? this.capStyle,
      offset: offset ?? this.offset,
    );
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'color': color.value,
      'opacity': opacity,
      'thickness': thickness,
      'outlineThickness': outlineThickness,
      'outlineColor': outlineColor.value,
      'capStyle': capStyle.index,
      'offsetX': offset.dx,
      'offsetY': offset.dy,
    };
  }
  
  /// Create from map
  factory ShapeComponent.fromMap(Map<String, dynamic> map) {
    return ShapeComponent(
      enabled: map['enabled'] ?? true,
      color: Color(map['color']),
      opacity: map['opacity'] ?? 1.0,
      thickness: map['thickness'] ?? 2.0,
      outlineThickness: map['outlineThickness'] ?? 0.0,
      outlineColor: Color(map['outlineColor']),
      capStyle: map['capStyle'] != null ? 
        LineCapStyle.values[map['capStyle']] : LineCapStyle.butt,
      offset: Offset(map['offsetX'] ?? 0.0, map['offsetY'] ?? 0.0),
    );
  }
}

/// Line component for crosshair
class LineComponent extends ShapeComponent {
  /// The length of the line
  final double length;
  
  /// The gap from center
  final double gap;
  
  /// Create a new line component
  LineComponent({
    super.enabled,
    super.color,
    super.opacity,
    super.thickness,
    super.outlineThickness,
    super.outlineColor,
    super.capStyle,
    super.offset,
    this.length = 10.0,
    this.gap = 3.0,
  });
  
  /// Copy with new parameters
  @override
  LineComponent copyWith({
    bool? enabled,
    Color? color,
    double? opacity,
    double? thickness,
    double? outlineThickness,
    Color? outlineColor,
    LineCapStyle? capStyle,
    Offset? offset,
    double? length,
    double? gap,
  }) {
    return LineComponent(
      enabled: enabled ?? this.enabled,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      thickness: thickness ?? this.thickness,
      outlineThickness: outlineThickness ?? this.outlineThickness,
      outlineColor: outlineColor ?? this.outlineColor,
      capStyle: capStyle ?? this.capStyle,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      gap: gap ?? this.gap,
    );
  }
  
  /// Convert to map
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'length': length,
      'gap': gap,
    };
  }
  
  /// Create from map
  factory LineComponent.fromMap(Map<String, dynamic> map) {
    return LineComponent(
      enabled: map['enabled'] ?? true,
      color: Color(map['color']),
      opacity: map['opacity'] ?? 1.0,
      thickness: map['thickness'] ?? 2.0,
      outlineThickness: map['outlineThickness'] ?? 0.0,
      outlineColor: Color(map['outlineColor']),
      capStyle: map['capStyle'] != null ? 
        LineCapStyle.values[map['capStyle']] : LineCapStyle.butt,
      offset: Offset(map['offsetX'] ?? 0.0, map['offsetY'] ?? 0.0),
      length: map['length'] ?? 10.0,
      gap: map['gap'] ?? 3.0,
    );
  }
}

/// Circle component for crosshair
class CircleComponent extends ShapeComponent {
  /// The radius of the circle
  final double radius;
  
  /// Whether the circle is filled
  final bool filled;
  
  /// Create a new circle component
  CircleComponent({
    super.enabled,
    super.color,
    super.opacity,
    super.thickness,
    super.outlineThickness,
    super.outlineColor,
    super.offset,
    this.radius = 5.0,
    this.filled = false,
  }) : super(capStyle: LineCapStyle.round);
  
  /// Copy with new parameters
  @override
  CircleComponent copyWith({
    bool? enabled,
    Color? color,
    double? opacity,
    double? thickness,
    double? outlineThickness,
    Color? outlineColor,
    Offset? offset,
    double? radius,
    bool? filled,
  }) {
    return CircleComponent(
      enabled: enabled ?? this.enabled,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      thickness: thickness ?? this.thickness,
      outlineThickness: outlineThickness ?? this.outlineThickness,
      outlineColor: outlineColor ?? this.outlineColor,
      offset: offset ?? this.offset,
      radius: radius ?? this.radius,
      filled: filled ?? this.filled,
    );
  }
  
  /// Convert to map
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'radius': radius,
      'filled': filled,
    };
  }
  
  /// Create from map
  factory CircleComponent.fromMap(Map<String, dynamic> map) {
    return CircleComponent(
      enabled: map['enabled'] ?? true,
      color: Color(map['color']),
      opacity: map['opacity'] ?? 1.0,
      thickness: map['thickness'] ?? 2.0,
      outlineThickness: map['outlineThickness'] ?? 0.0,
      outlineColor: Color(map['outlineColor']),
      offset: Offset(map['offsetX'] ?? 0.0, map['offsetY'] ?? 0.0),
      radius: map['radius'] ?? 5.0,
      filled: map['filled'] ?? false,
    );
  }
}

/// Dot component for crosshair
class DotComponent extends ShapeComponent {
  /// The size of the dot
  final double size;
  
  /// Create a new dot component
  DotComponent({
    super.enabled,
    super.color,
    super.opacity,
    super.outlineThickness,
    super.outlineColor,
    super.offset,
    this.size = 2.0,
  }) : super(thickness: 0.0, capStyle: LineCapStyle.round);
  
  /// Copy with new parameters
  @override
  DotComponent copyWith({
    bool? enabled,
    Color? color,
    double? opacity,
    double? outlineThickness,
    Color? outlineColor,
    Offset? offset,
    double? size,
  }) {
    return DotComponent(
      enabled: enabled ?? this.enabled,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      outlineThickness: outlineThickness ?? this.outlineThickness,
      outlineColor: outlineColor ?? this.outlineColor,
      offset: offset ?? this.offset,
      size: size ?? this.size,
    );
  }
  
  /// Convert to map
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'size': size,
    };
  }
  
  /// Create from map
  factory DotComponent.fromMap(Map<String, dynamic> map) {
    return DotComponent(
      enabled: map['enabled'] ?? true,
      color: Color(map['color']),
      opacity: map['opacity'] ?? 1.0,
      outlineThickness: map['outlineThickness'] ?? 0.0,
      outlineColor: Color(map['outlineColor']),
      offset: Offset(map['offsetX'] ?? 0.0, map['offsetY'] ?? 0.0),
      size: map['size'] ?? 2.0,
    );
  }
}

/// Animation properties for the crosshair
class AnimationProperties {
  /// Whether animation is enabled
  final bool enabled;
  
  /// The animation type
  final CrosshairAnimationType type;
  
  /// The animation speed
  final double speed;
  
  /// The animation intensity
  final double intensity;
  
  /// Create new animation properties
  AnimationProperties({
    this.enabled = false,
    this.type = CrosshairAnimationType.breathing,
    this.speed = 1.0,
    this.intensity = 1.0,
  });
  
  /// Copy with new parameters
  AnimationProperties copyWith({
    bool? enabled,
    CrosshairAnimationType? type,
    double? speed,
    double? intensity,
  }) {
    return AnimationProperties(
      enabled: enabled ?? this.enabled,
      type: type ?? this.type,
      speed: speed ?? this.speed,
      intensity: intensity ?? this.intensity,
    );
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'type': type.index,
      'speed': speed,
      'intensity': intensity,
    };
  }
  
  /// Create from map
  factory AnimationProperties.fromMap(Map<String, dynamic> map) {
    return AnimationProperties(
      enabled: map['enabled'] ?? false,
      type: CrosshairAnimationType.values[map['type'] ?? 0],
      speed: map['speed'] ?? 1.0,
      intensity: map['intensity'] ?? 1.0,
    );
  }
}

/// The type of crosshair animation
enum CrosshairAnimationType {
  /// Breathing animation
  breathing,
  
  /// Pulse animation
  pulse,
  
  /// Blink animation
  blink,
  
  /// Scale animation
  scale,
  
  /// Rotate animation
  rotate,
}

/// A model representing a customizable crosshair
class CrosshairModel {
  /// The unique identifier
  final String id;
  
  /// The name
  String name;
  
  /// The description
  String description;
  
  /// Global scale factor
  double scale;
  
  /// Global opacity
  double opacity;
  
  /// Global color - will be applied if individual components don't specify a color
  Color? globalColor;
  
  /// Top line component
  LineComponent topLine;
  
  /// Right line component
  LineComponent rightLine;
  
  /// Bottom line component
  LineComponent bottomLine;
  
  /// Left line component
  LineComponent leftLine;
  
  /// Outer circle component
  CircleComponent outerCircle;
  
  /// Inner circle component
  CircleComponent innerCircle;
  
  /// Center dot component
  DotComponent centerDot;
  
  /// Animation properties
  AnimationProperties animation;
  
  /// Create a new crosshair
  CrosshairModel({
    String? id,
    this.name = 'New Crosshair',
    this.description = '',
    this.scale = 1.0,
    this.opacity = 1.0,
    this.globalColor,
    LineComponent? topLine,
    LineComponent? rightLine,
    LineComponent? bottomLine,
    LineComponent? leftLine,
    CircleComponent? outerCircle,
    CircleComponent? innerCircle,
    DotComponent? centerDot,
    AnimationProperties? animation,
  }) : 
    id = id ?? const Uuid().v4(),
    topLine = topLine ?? LineComponent(
      offset: const Offset(0, -5), 
      color: Colors.greenAccent,
    ),
    rightLine = rightLine ?? LineComponent(
      offset: const Offset(5, 0), 
      color: Colors.greenAccent,
    ),
    bottomLine = bottomLine ?? LineComponent(
      offset: const Offset(0, 5), 
      color: Colors.greenAccent,
    ),
    leftLine = leftLine ?? LineComponent(
      offset: const Offset(-5, 0), 
      color: Colors.greenAccent,
    ),
    outerCircle = outerCircle ?? CircleComponent(
      enabled: false, 
      radius: 10, 
      color: Colors.greenAccent,
    ),
    innerCircle = innerCircle ?? CircleComponent(
      enabled: false, 
      radius: 5, 
      color: Colors.greenAccent,
    ),
    centerDot = centerDot ?? DotComponent(
      color: Colors.greenAccent,
    ),
    animation = animation ?? AnimationProperties();
  
  /// Create a copy with new parameters
  CrosshairModel copyWith({
    String? name,
    String? description,
    double? scale,
    double? opacity,
    Color? globalColor,
    LineComponent? topLine,
    LineComponent? rightLine,
    LineComponent? bottomLine,
    LineComponent? leftLine,
    CircleComponent? outerCircle,
    CircleComponent? innerCircle,
    DotComponent? centerDot,
    AnimationProperties? animation,
  }) {
    return CrosshairModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
      globalColor: globalColor ?? this.globalColor,
      topLine: topLine ?? this.topLine,
      rightLine: rightLine ?? this.rightLine,
      bottomLine: bottomLine ?? this.bottomLine,
      leftLine: leftLine ?? this.leftLine,
      outerCircle: outerCircle ?? this.outerCircle,
      innerCircle: innerCircle ?? this.innerCircle,
      centerDot: centerDot ?? this.centerDot,
      animation: animation ?? this.animation,
    );
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'scale': scale,
      'opacity': opacity,
      'globalColor': globalColor?.value,
      'topLine': topLine.toMap(),
      'rightLine': rightLine.toMap(),
      'bottomLine': bottomLine.toMap(),
      'leftLine': leftLine.toMap(),
      'outerCircle': outerCircle.toMap(),
      'innerCircle': innerCircle.toMap(),
      'centerDot': centerDot.toMap(),
      'animation': animation.toMap(),
    };
  }
  
  /// Create from map
  factory CrosshairModel.fromMap(Map<String, dynamic> map) {
    return CrosshairModel(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      scale: map['scale'] ?? 1.0,
      opacity: map['opacity'] ?? 1.0,
      globalColor: map['globalColor'] != null ? Color(map['globalColor']) : null,
      topLine: map['topLine'] != null ? LineComponent.fromMap(map['topLine']) : null,
      rightLine: map['rightLine'] != null ? LineComponent.fromMap(map['rightLine']) : null,
      bottomLine: map['bottomLine'] != null ? LineComponent.fromMap(map['bottomLine']) : null,
      leftLine: map['leftLine'] != null ? LineComponent.fromMap(map['leftLine']) : null,
      outerCircle: map['outerCircle'] != null ? CircleComponent.fromMap(map['outerCircle']) : null,
      innerCircle: map['innerCircle'] != null ? CircleComponent.fromMap(map['innerCircle']) : null,
      centerDot: map['centerDot'] != null ? DotComponent.fromMap(map['centerDot']) : null,
      animation: map['animation'] != null ? AnimationProperties.fromMap(map['animation']) : null,
    );
  }
  
  /// Convert to CSV format
  String toCsv() {
    final map = toMap();
    final flatMap = _flattenMap(map, '');
    
    // Create a CSV string with all the flattened properties
    final values = flatMap.values.map((v) {
      if (v == null) return '';
      if (v is String) return '"$v"';
      return v.toString();
    }).join(',');
    
    return values;
  }
  
  /// Flatten a nested map with dot notation
  Map<String, dynamic> _flattenMap(Map<String, dynamic> map, String prefix) {
    final result = <String, dynamic>{};
    
    map.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      
      if (value is Map<String, dynamic>) {
        result.addAll(_flattenMap(value, newKey));
      } else {
        result[newKey] = value;
      }
    });
    
    return result;
  }
  
  /// Get CSV header
  static String csvHeader() {
    // Create a sample crosshair and flatten its map to get all possible keys
    final sample = CrosshairModel();
    final map = sample.toMap();
    final flatMap = sample._flattenMap(map, '');
    
    // Create a CSV header with all the keys
    return flatMap.keys.map((k) => '"$k"').join(',');
  }
  
  /// Create a classic crosshair preset
  factory CrosshairModel.classicPreset() {
    return CrosshairModel(
      name: 'Classic',
      description: 'Classic FPS crosshair',
      topLine: LineComponent(
        color: Colors.lime,
        thickness: 2,
        length: 10,
        gap: 3,
      ),
      rightLine: LineComponent(
        color: Colors.lime,
        thickness: 2,
        length: 10,
        gap: 3,
      ),
      bottomLine: LineComponent(
        color: Colors.lime,
        thickness: 2,
        length: 10,
        gap: 3,
      ),
      leftLine: LineComponent(
        color: Colors.lime,
        thickness: 2,
        length: 10,
        gap: 3,
      ),
      centerDot: DotComponent(
        enabled: true,
        color: Colors.lime,
        size: 2,
      ),
    );
  }
  
  /// Create a dot crosshair preset
  factory CrosshairModel.dotPreset() {
    return CrosshairModel(
      name: 'Dot',
      description: 'Simple dot crosshair',
      topLine: LineComponent(enabled: false),
      rightLine: LineComponent(enabled: false),
      bottomLine: LineComponent(enabled: false),
      leftLine: LineComponent(enabled: false),
      centerDot: DotComponent(
        enabled: true,
        color: Colors.deepOrange,
        size: 4,
      ),
    );
  }
  
  /// Create a circle crosshair preset
  factory CrosshairModel.circlePreset() {
    return CrosshairModel(
      name: 'Circle',
      description: 'Circle with dot crosshair',
      topLine: LineComponent(enabled: false),
      rightLine: LineComponent(enabled: false),
      bottomLine: LineComponent(enabled: false),
      leftLine: LineComponent(enabled: false),
      outerCircle: CircleComponent(
        enabled: true,
        color: Colors.cyanAccent,
        radius: 10,
        thickness: 1.5,
      ),
      centerDot: DotComponent(
        enabled: true,
        color: Colors.cyanAccent,
        size: 2,
      ),
    );
  }
}