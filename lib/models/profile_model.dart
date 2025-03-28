import 'package:uuid/uuid.dart';
import 'crosshair_model.dart';

/// A model representing a user profile
class ProfileModel {
  /// The unique identifier
  final String id;
  
  /// The name
  String name;
  
  /// The description
  String description;
  
  /// The list of crosshair IDs
  List<String> crosshairIds;
  
  /// The active crosshair ID
  String? activeCrosshairId;
  
  /// The last modified date
  DateTime lastModified;
  
  /// Create a new profile
  ProfileModel({
    String? id,
    this.name = 'New Profile',
    this.description = '',
    List<String>? crosshairIds,
    this.activeCrosshairId,
    DateTime? lastModified,
  }) : 
    id = id ?? const Uuid().v4(),
    crosshairIds = crosshairIds ?? <String>[],
    lastModified = lastModified ?? DateTime.now();
  
  /// Create a copy with the given parameters
  ProfileModel copyWith({
    String? name,
    String? description,
    List<String>? crosshairIds,
    String? activeCrosshairId,
    DateTime? lastModified,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      crosshairIds: crosshairIds ?? List.from(this.crosshairIds),
      activeCrosshairId: activeCrosshairId ?? this.activeCrosshairId,
      lastModified: lastModified ?? this.lastModified,
    );
  }
  
  /// Add a crosshair ID
  void addCrosshairId(String id) {
    if (!crosshairIds.contains(id)) {
      crosshairIds.add(id);
      lastModified = DateTime.now();
    }
  }
  
  /// Remove a crosshair ID
  void removeCrosshairId(String id) {
    if (crosshairIds.contains(id)) {
      crosshairIds.remove(id);
      
      if (activeCrosshairId == id) {
        activeCrosshairId = crosshairIds.isNotEmpty ? crosshairIds.first : null;
      }
      
      lastModified = DateTime.now();
    }
  }
  
  /// Set the active crosshair ID
  void setActiveCrosshairId(String id) {
    if (crosshairIds.contains(id)) {
      activeCrosshairId = id;
      lastModified = DateTime.now();
    }
  }
  
  /// Convert this model to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'crosshairIds': crosshairIds,
      'activeCrosshairId': activeCrosshairId,
      'lastModified': lastModified.millisecondsSinceEpoch,
    };
  }
  
  /// Create a model from a map
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      crosshairIds: List<String>.from(map['crosshairIds']),
      activeCrosshairId: map['activeCrosshairId'],
      lastModified: DateTime.fromMillisecondsSinceEpoch(map['lastModified']),
    );
  }
  
  /// Convert to CSV format
  String toCsv(List<CrosshairModel> crosshairs) {
    final buffer = StringBuffer();
    buffer.writeln('"$id","$name","$description","${lastModified.toIso8601String()}"');
    
    for (final crosshair in crosshairs) {
      if (crosshairIds.contains(crosshair.id)) {
        buffer.writeln(crosshair.toCsv());
      }
    }
    
    return buffer.toString();
  }
  
  /// Get CSV header
  static String csvHeader() {
    return '"ID","Name","Description","LastModified"\n${CrosshairModel.csvHeader()}';
  }
}