import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Model class for crosshair configuration
class CrosshairModel {
  /// Unique identifier for the crosshair
  final String id;
  
  /// Name of the crosshair
  String name;
  
  /// Shape type (e.g., 'Classic', 'Dot', 'Circle', 'T', 'Cross', etc.)
  String shape;
  
  /// Primary color of the crosshair
  Color color;
  
  /// Size of the crosshair (overall size)
  double size;
  
  /// Thickness of the crosshair lines
  double thickness;
  
  /// Gap in the center of the crosshair
  double gap;
  
  /// Opacity of the crosshair (0.0 to 1.0)
  double opacity;
  
  /// Whether to show a center dot
  bool showCenterDot;
  
  /// Size of the center dot
  double centerDotSize;
  
  /// Whether to show an outline
  bool outline;
  
  /// Thickness of the outline
  double outlineThickness;
  
  /// Color of the outline
  Color outlineColor;
  
  /// Whether the crosshair has animation
  bool animated;
  
  /// Animation type if animated is true
  String? animationType;
  
  /// Animation speed if animated is true (1.0 is normal speed)
  double animationSpeed;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last modified timestamp
  DateTime updatedAt;
  
  /// Constructor
  CrosshairModel({
    String? id,
    this.name = 'New Crosshair',
    this.shape = 'Classic',
    Color? color,
    this.size = 16.0,
    this.thickness = 2.0,
    this.gap = 4.0,
    this.opacity = 1.0,
    this.showCenterDot = false,
    this.centerDotSize = 2.0,
    this.outline = false,
    this.outlineThickness = 1.0,
    Color? outlineColor,
    this.animated = false,
    this.animationType,
    this.animationSpeed = 1.0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        color = color ?? Colors.green,
        outlineColor = outlineColor ?? Colors.black,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
  
  /// Create a copy of this crosshair with some properties replaced
  CrosshairModel copyWith({
    String? name,
    String? shape,
    Color? color,
    double? size,
    double? thickness,
    double? gap,
    double? opacity,
    bool? showCenterDot,
    double? centerDotSize,
    bool? outline,
    double? outlineThickness,
    Color? outlineColor,
    bool? animated,
    String? animationType,
    double? animationSpeed,
  }) {
    return CrosshairModel(
      id: id,
      name: name ?? this.name,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      size: size ?? this.size,
      thickness: thickness ?? this.thickness,
      gap: gap ?? this.gap,
      opacity: opacity ?? this.opacity,
      showCenterDot: showCenterDot ?? this.showCenterDot,
      centerDotSize: centerDotSize ?? this.centerDotSize,
      outline: outline ?? this.outline,
      outlineThickness: outlineThickness ?? this.outlineThickness,
      outlineColor: outlineColor ?? this.outlineColor,
      animated: animated ?? this.animated,
      animationType: animationType ?? this.animationType,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
  
  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shape': shape,
      'color': color.value,
      'size': size,
      'thickness': thickness,
      'gap': gap,
      'opacity': opacity,
      'showCenterDot': showCenterDot,
      'centerDotSize': centerDotSize,
      'outline': outline,
      'outlineThickness': outlineThickness,
      'outlineColor': outlineColor.value,
      'animated': animated,
      'animationType': animationType,
      'animationSpeed': animationSpeed,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// Create from JSON map
  factory CrosshairModel.fromJson(Map<String, dynamic> json) {
    return CrosshairModel(
      id: json['id'],
      name: json['name'],
      shape: json['shape'],
      color: Color(json['color']),
      size: json['size'],
      thickness: json['thickness'],
      gap: json['gap'],
      opacity: json['opacity'],
      showCenterDot: json['showCenterDot'],
      centerDotSize: json['centerDotSize'],
      outline: json['outline'],
      outlineThickness: json['outlineThickness'],
      outlineColor: Color(json['outlineColor']),
      animated: json['animated'],
      animationType: json['animationType'],
      animationSpeed: json['animationSpeed'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  /// Create a default crosshair
  factory CrosshairModel.defaultCrosshair() {
    return CrosshairModel(
      name: 'Default Crosshair',
      shape: 'Classic',
      color: Colors.green,
      size: 16.0,
      thickness: 2.0,
      gap: 4.0,
      opacity: 1.0,
      showCenterDot: false,
      centerDotSize: 2.0,
      outline: false,
      outlineThickness: 1.0,
      outlineColor: Colors.black,
      animated: false,
      animationSpeed: 1.0,
    );
  }
  
  /// Create a sample dot crosshair
  factory CrosshairModel.dotCrosshair() {
    return CrosshairModel(
      name: 'Simple Dot',
      shape: 'Dot',
      color: Colors.red,
      size: 12.0,
      opacity: 1.0,
      showCenterDot: false,
      outline: true,
      outlineThickness: 1.0,
      outlineColor: Colors.white,
    );
  }
  
  /// Create a sample circle crosshair
  factory CrosshairModel.circleCrosshair() {
    return CrosshairModel(
      name: 'Circle',
      shape: 'Circle',
      color: Colors.cyan,
      size: 24.0,
      thickness: 1.5,
      opacity: 0.8,
      showCenterDot: true,
      centerDotSize: 2.0,
      outline: false,
    );
  }
}