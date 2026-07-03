import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pastel_tasks/features/backup/domain/enums/backup_type.dart';
import 'package:pastel_tasks/features/backup/domain/models/backup_payload.dart';
import 'package:pastel_tasks/features/backup/domain/repositories/backup_repository.dart';
import 'package:pastel_tasks/features/settings/domain/repositories/account_service.dart';

class DriveBackupRepository implements BackupRepository {
  final AccountService _accountService;

  DriveBackupRepository(this._accountService);

  @override
  BackupType get type => BackupType.googleDrive;

  @override
  Future<void> initialize() async {
    await _accountService.initialize();
  }

  Future<void> signIn() async {
    await _accountService.signIn();
  }

  Future<void> signOut() async {
    await _accountService.signOut();
  }

  bool get isSignedIn => !_accountService.currentProfile.isGuest;
  String? get userEmail => _accountService.currentProfile.email;

  Future<drive.DriveApi> _getDriveApi() async {
    final client = await _accountService.getAuthenticatedClient();
    if (client == null) {
      throw Exception('Failed to obtain authenticated HTTP client for Google Drive.');
    }
    return drive.DriveApi(client);
  }

  @override
  Future<String> createBackup(BackupPayload payload, {String? password}) async {
    final api = await _getDriveApi();
    final jsonString = jsonEncode(payload.toJson());
    final bytes = utf8.encode(jsonString);

    // Using appDataFolder to keep backups hidden from normal user drive space
    final fileMetadata = drive.File()
      ..name = 'pastel_backup_latest.json'
      ..parents = ['appDataFolder'];

    final media = drive.Media(Stream.value(bytes), bytes.length);

    // Check if backup already exists to overwrite it
    final existingFiles = await api.files.list(
      spaces: 'appDataFolder',
      q: "name='pastel_backup_latest.json'",
    );

    drive.File result;
    if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
      final fileId = existingFiles.files!.first.id!;
      result = await api.files.update(
        drive.File(),
        fileId,
        uploadMedia: media,
      );
    } else {
      result = await api.files.create(
        fileMetadata,
        uploadMedia: media,
      );
    }

    return result.id!;
  }

  @override
  Future<BackupPayload> restoreBackup(String reference, {String? password}) async {
    final api = await _getDriveApi();

    final media = await api.files.get(
      reference,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final bytes = await _readStream(media.stream);
    final jsonString = utf8.decode(bytes);
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return BackupPayload.fromJson(jsonMap);
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableBackups() async {
    if (!isSignedIn) {
      return [];
    }
    final api = await _getDriveApi();

    final response = await api.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id, name, modifiedTime, size)',
    );

    final backups = <Map<String, dynamic>>[];
    if (response.files != null) {
      for (final file in response.files!) {
        backups.add({
          'reference': file.id,
          'name': file.name,
          'date': file.modifiedTime,
          'size': int.tryParse(file.size ?? '0') ?? 0,
          'isEncrypted': false, // For simplicity, we are not encrypting drive backups yet
        });
      }
    }
    
    // Sort descending by date
    backups.sort((a, b) {
      final dateA = a['date'] as DateTime?;
      final dateB = b['date'] as DateTime?;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateB.compareTo(dateA);
    });
    
    return backups;
  }

  @override
  Future<void> deleteBackup(String reference) async {
    if (isSignedIn) {
      final api = await _getDriveApi();
      await api.files.delete(reference);
    }
  }

  Future<List<int>> _readStream(Stream<List<int>> stream) async {
    final bytes = <int>[];
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
    return bytes;
  }
}
