import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'crosshair_model.dart';

/// Model class for user profiles
class ProfileModel {
  /// Unique identifier for the profile
  final String id;
  
  /// Profile name
  String name;
  
  /// Profile description
  String description;
  
  /// Game name associated with this profile
  String? gameName;
  
  /// Whether the profile is marked as favorite
  bool isFavorite;
  
  /// List of crosshairs in this profile
  List<CrosshairModel> crosshairs;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last modified timestamp
  DateTime updatedAt;
  
  /// Constructor
  ProfileModel({
    String? id,
    this.name = 'New Profile',
    this.description = 'A collection of crosshairs',
    this.gameName,
    this.isFavorite = false,
    List<CrosshairModel>? crosshairs,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        crosshairs = crosshairs ?? [CrosshairModel.defaultCrosshair()],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
  
  /// Create a copy of this profile with some properties replaced
  ProfileModel copyWith({
    String? name,
    String? description,
    String? gameName,
    bool? isFavorite,
    List<CrosshairModel>? crosshairs,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      gameName: gameName ?? this.gameName,
      isFavorite: isFavorite ?? this.isFavorite,
      crosshairs: crosshairs ?? List.from(this.crosshairs),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
  
  /// Add a crosshair to this profile
  void addCrosshair(CrosshairModel crosshair) {
    crosshairs.add(crosshair);
    updatedAt = DateTime.now();
  }
  
  /// Remove a crosshair from this profile
  bool removeCrosshair(String crosshairId) {
    final initialLength = crosshairs.length;
    crosshairs.removeWhere((c) => c.id == crosshairId);
    
    if (crosshairs.length != initialLength) {
      updatedAt = DateTime.now();
      return true;
    }
    
    return false;
  }
  
  /// Update a crosshair in this profile
  bool updateCrosshair(CrosshairModel updatedCrosshair) {
    final index = crosshairs.indexWhere((c) => c.id == updatedCrosshair.id);
    
    if (index >= 0) {
      crosshairs[index] = updatedCrosshair;
      updatedAt = DateTime.now();
      return true;
    }
    
    return false;
  }
  
  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'gameName': gameName,
      'isFavorite': isFavorite,
      'crosshairs': crosshairs.map((c) => c.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// Create from JSON map
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final crosshairsJson = json['crosshairs'] as List;
    final crosshairs = crosshairsJson
        .map((c) => CrosshairModel.fromJson(c))
        .toList();
    
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      gameName: json['gameName'],
      isFavorite: json['isFavorite'],
      crosshairs: crosshairs,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  /// Create a default profile
  factory ProfileModel.defaultProfile() {
    return ProfileModel(
      name: 'Default Profile',
      description: 'Default collection of crosshairs',
      crosshairs: [
        CrosshairModel.defaultCrosshair(),
        CrosshairModel.dotCrosshair(),
        CrosshairModel.circleCrosshair(),
      ],
    );
  }
}