import 'package:pastel_tasks/features/tasks/domain/models/tag.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';

/// Extension methods to map between Tag domain model and TagCollection.
extension TagMapper on Tag {
  /// Converts a domain Tag to an Isar TagCollection.
  TagCollection toIsar() {
    return TagCollection()
      ..uuid = id
      ..name = name
      ..color = color
      ..icon = icon
      ..position = position
      ..createdAt = createdAt;
  }
}

extension TagCollectionMapper on TagCollection {
  /// Converts an Isar TagCollection to a domain Tag.
  Tag toDomain() {
    return Tag(
      id: uuid,
      name: name,
      color: color,
      icon: icon,
      position: position,
      createdAt: createdAt,
    );
  }
}
