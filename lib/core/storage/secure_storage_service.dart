import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Application-agnostic secure key-value storage.
final class SecureStorageService {
  /// Creates a secure storage service.
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Reads a value for [key].
  Future<String?> read(String key) => _storage.read(key: key);

  /// Writes [value] for [key].
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  /// Deletes a value for [key].
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Deletes every secure value owned by the application.
  Future<void> deleteAll() => _storage.deleteAll();
}
