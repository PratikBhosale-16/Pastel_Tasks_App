import 'package:equatable/equatable.dart';

/// Represents a user-defined category for tasks.
class Tag extends Equatable {
  const Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.position,
    required this.createdAt,
  });

  /// Unique identifier.
  final String id;

  /// Display name of the tag.
  final String name;

  /// Hex string or color value.
  final String color;

  /// Icon identifier.
  final String icon;

  /// Order in the UI.
  final double position;

  /// Creation timestamp.
  final DateTime createdAt;

  Tag copyWith({
    String? id,
    String? name,
    String? color,
    String? icon,
    double? position,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, color, icon, position, createdAt];
}
