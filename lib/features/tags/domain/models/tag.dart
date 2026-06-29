import 'package:equatable/equatable.dart';

/// Represents a single tag entity.
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

  /// The name of the tag (must be unique).
  final String name;

  /// Hex string representing the tag's color.
  final String color;

  /// The code point of the Material Symbol icon as string.
  final String icon;

  /// Order index for manual sorting.
  final double position;

  /// When the tag was created.
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
