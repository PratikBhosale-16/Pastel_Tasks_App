import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:pastel_tasks/features/backup/domain/enums/backup_type.dart';
import 'package:pastel_tasks/features/backup/domain/models/backup_payload.dart';
import 'package:pastel_tasks/features/backup/domain/repositories/backup_repository.dart';



class DriveBackupRepository implements BackupRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveAppdataScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;

  @override
  BackupType get type => BackupType.googleDrive;

  @override
  Future<void> initialize() async {
    _currentUser = await _googleSignIn.signInSilently();
    if (_currentUser != null) {
      await _initDriveApi();
    }
  }

  Future<void> signIn() async {
    _currentUser = await _googleSignIn.signIn();
    if (_currentUser != null) {
      await _initDriveApi();
    } else {
      throw Exception('Google Sign-In failed or was cancelled.');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _driveApi = null;
  }

  bool get isSignedIn => _currentUser != null;
  String? get userEmail => _currentUser?.email;

  Future<void> _initDriveApi() async {
    final authenticateClient = await _googleSignIn.authenticatedClient();
    if (authenticateClient == null) {
      throw Exception('Failed to obtain authenticated HTTP client for Google Drive.');
    }
    _driveApi = drive.DriveApi(authenticateClient);
  }

  @override
  Future<String> createBackup(BackupPayload payload, {String? password}) async {
    if (_driveApi == null) {
      throw Exception('Google Drive API not initialized. Please sign in first.');
    }

    final jsonString = jsonEncode(payload.toJson());
    final bytes = utf8.encode(jsonString);

    // Using appDataFolder to keep backups hidden from normal user drive space
    final fileMetadata = drive.File()
      ..name = 'pastel_backup_latest.json'
      ..parents = ['appDataFolder'];

    final media = drive.Media(Stream.value(bytes), bytes.length);

    // Check if backup already exists to overwrite it
    final existingFiles = await _driveApi!.files.list(
      spaces: 'appDataFolder',
      q: "name='pastel_backup_latest.json'",
    );

    drive.File result;
    if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
      final fileId = existingFiles.files!.first.id!;
      result = await _driveApi!.files.update(
        drive.File(),
        fileId,
        uploadMedia: media,
      );
    } else {
      result = await _driveApi!.files.create(
        fileMetadata,
        uploadMedia: media,
      );
    }

    return result.id!;
  }

  @override
  Future<BackupPayload> restoreBackup(String reference, {String? password}) async {
    if (_driveApi == null) {
      throw Exception('Google Drive API not initialized. Please sign in first.');
    }

    final media = await _driveApi!.files.get(
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
    if (_driveApi == null) {
      return [];
    }

    final response = await _driveApi!.files.list(
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
          'isEncrypted': false, // For simplicity, we are not encrypting drive backups yet or we can use CryptoService
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
    if (_driveApi != null) {
      await _driveApi!.files.delete(reference);
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
