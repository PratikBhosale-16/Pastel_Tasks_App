import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class BackupCryptoService {
  /// Compresses a JSON string to a ZIP byte array.
  List<int> compressJsonToZip(String jsonString, String filename) {
    final archive = Archive();
    final bytes = utf8.encode(jsonString);
    archive.addFile(ArchiveFile(filename, bytes.length, bytes));
    final zipEncoder = ZipEncoder();
    return zipEncoder.encode(archive) as List<int>;
  }

  /// Decompresses a ZIP byte array back to a JSON string.
  String decompressZipToJson(List<int> zipBytes, String filename) {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final file = archive.findFile(filename);
    if (file == null) {
      throw Exception('File $filename not found in backup archive.');
    }
    final content = file.content as List<int>;
    return utf8.decode(content);
  }

  /// Derives an encryption key from a password.
  encrypt.Key _deriveKey(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return encrypt.Key(Uint8List.fromList(digest.bytes));
  }

  /// Encrypts raw bytes using AES-GCM and a user-provided password.
  List<int> encryptBytes(List<int> data, String password) {
    final key = _deriveKey(password);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));
    
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    
    // Prepend IV to the encrypted data
    return [...iv.bytes, ...encrypted.bytes];
  }

  /// Decrypts raw bytes using AES-GCM and a user-provided password.
  List<int> decryptBytes(List<int> data, String password) {
    if (data.length < 16) {
      throw Exception('Invalid encrypted backup format.');
    }
    
    final ivBytes = data.sublist(0, 16);
    final encryptedBytes = data.sublist(16);
    
    final key = _deriveKey(password);
    final iv = encrypt.IV(Uint8List.fromList(ivBytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));
    
    final decrypted = encrypter.decryptBytes(encrypt.Encrypted(Uint8List.fromList(encryptedBytes)), iv: iv);
    return decrypted;
  }
}
