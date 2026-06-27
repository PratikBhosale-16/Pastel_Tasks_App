import 'package:uuid/uuid.dart';

/// Generates application identifiers without exposing the UUID package.
final class UuidService {
  /// Creates a UUID service.
  UuidService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  /// Generates a random version 4 UUID.
  String generate() => _uuid.v4();
}
