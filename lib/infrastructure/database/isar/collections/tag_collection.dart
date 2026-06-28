import 'package:isar/isar.dart';

part 'tag_collection.g.dart';

@collection
class TagCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String name;

  late String color;

  late String icon;

  @Index()
  late double position;

  late DateTime createdAt;
}
