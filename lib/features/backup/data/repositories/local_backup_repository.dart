import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pastel_tasks/features/backup/data/services/backup_crypto_service.dart';
import 'package:pastel_tasks/features/backup/domain/enums/backup_type.dart';
import 'package:pastel_tasks/features/backup/domain/models/backup_payload.dart';
import 'package:pastel_tasks/features/backup/domain/repositories/backup_repository.dart';

class LocalBackupRepository implements BackupRepository {
  LocalBackupRepository(this._cryptoService);

  final BackupCryptoService _cryptoService;

  @override
  BackupType get type => BackupType.local;

  @override
  Future<void> initialize() async {
    // No specific initialization needed for local backups.
  }

  Future<Directory> _getBackupDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(docsDir.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  @override
  Future<String> createBackup(BackupPayload payload, {String? password}) async {
    final backupDir = await _getBackupDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final isEncrypted = password != null && password.isNotEmpty;
    final extension = isEncrypted ? '.enc.json' : '.json';
    final filename = 'pastel_backup_$timestamp$extension';
    final file = File(p.join(backupDir.path, filename));

    final jsonString = jsonEncode(payload.toJson());
    
    if (isEncrypted) {
      final compressed = _cryptoService.compressJsonToZip(jsonString, 'backup.json');
      final encrypted = _cryptoService.encryptBytes(compressed, password);
      await file.writeAsBytes(encrypted);
    } else {
      await file.writeAsString(jsonString);
    }

    return file.path;
  }

  @override
  Future<BackupPayload> restoreBackup(String reference, {String? password}) async {
    final file = File(reference);
    if (!await file.exists()) {
      throw Exception('Backup file not found at path: $reference');
    }

    final isEncrypted = reference.endsWith('.enc.json') || reference.endsWith('.enc');
    String jsonString;

    if (isEncrypted) {
      if (password == null || password.isEmpty) {
        throw Exception('Password required to restore this backup.');
      }
      final bytes = await file.readAsBytes();
      try {
        final decryptedBytes = _cryptoService.decryptBytes(bytes, password);
        jsonString = _cryptoService.decompressZipToJson(decryptedBytes, 'backup.json');
      } catch (e) {
        throw Exception('Failed to decrypt backup. Incorrect password or corrupted file.');
      }
    } else {
      jsonString = await file.readAsString();
    }

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return BackupPayload.fromJson(jsonMap);
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableBackups() async {
    final backupDir = await _getBackupDirectory();
    final List<Map<String, dynamic>> backups = [];

    await for (final entity in backupDir.list()) {
      if (entity is File && (entity.path.endsWith('.json') || entity.path.endsWith('.enc.json') || entity.path.endsWith('.enc'))) {
        final stat = await entity.stat();
        backups.add({
          'reference': entity.path,
          'name': p.basename(entity.path),
          'date': stat.modified,
          'size': stat.size,
          'isEncrypted': entity.path.contains('.enc'),
        });
      }
    }
    
    // Sort descending by date
    backups.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return backups;
  }

  @override
  Future<void> deleteBackup(String reference) async {
    final file = File(reference);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
