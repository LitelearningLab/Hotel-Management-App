import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AudioCryptoHelper {
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// Download from [url], encrypt and save to local storage.
  static Future<String> downloadAndEncryptFile(
      String url, String fileName) async {
    try {
      if (!url.startsWith('http')) throw Exception('❌ Invalid URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = join(dir.path, '$fileName.enc');
        final file = File(filePath);

        final encrypted = _encrypter.encryptBytes(response.bodyBytes, iv: _iv);
        await file.writeAsBytes(encrypted.bytes, flush: true);

        print('✅ Encrypted and saved: $filePath');
        return filePath;
      } else {
        throw Exception('❌ Failed to download or empty content: $url');
      }
    } catch (e) {
      print('❌ Error in downloadAndEncryptFile: $e');
      return '';
    }
  }

  static Future<String> decryptFile(
      String encryptedPath, String fileName) async {
    try {
      final file = File(encryptedPath);

      if (!await file.exists()) {
        print("❌ File doesn't exist: $encryptedPath");
        return '';
      }

      final encryptedBytes = await file.readAsBytes();
      print("🔐 Encrypted bytes length: ${encryptedBytes.length}");

      if (encryptedBytes.isEmpty) {
        print("❌ Encrypted file is empty: $encryptedPath");
        return '';
      }

      final decryptedBytes = _encrypter.decryptBytes(
        encrypt.Encrypted(encryptedBytes),
        iv: _iv,
      );

      final tempDir = await getTemporaryDirectory();
      final decryptedPath = join(tempDir.path, '$fileName.mp3');

      final decryptedFile = File(decryptedPath);
      await decryptedFile.writeAsBytes(decryptedBytes, flush: true);

      print("✅ Decrypted path: $decryptedPath");
      return decryptedPath;
    } catch (e) {
      print('❌ Decryption failed for $encryptedPath: $e');
      return '';
    }
  }
}
