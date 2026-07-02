import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart" as p;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class AudioCryptoHelper {
  static final key = encrypt.Key.fromUtf8('1234567890123456');
  static final iv = encrypt.IV.fromUtf8('1234567890123456');
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static Future<String> decryptFile(
      String encryptedPath, String outputFileName) async {
    final encryptedFile = File(encryptedPath);
    if (!await encryptedFile.exists()) {
      throw Exception("Encrypted file not found: $encryptedPath");
    }

    // Read encrypted bytes
    final encryptedBytes = await encryptedFile.readAsBytes();

    // Decrypt
    final decryptedBytes = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );

    // Save to temporary file
    final tempDir = await getTemporaryDirectory();
    final outputPath = p.join(tempDir.path, "$outputFileName.mp3");
    await File(outputPath).writeAsBytes(decryptedBytes);
    // just_audio.setFilePath expects a plain filesystem path on both iOS/Android.
    return outputPath;
  }

  static Future<String> downloadAndEncryptAudio(
      String url, String fileName) async {
    // Step 1: Download audio
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception("Failed to download audio");

    // Step 2: Prepare encryption
    // final key = encrypt.Key.fromUtf8('1234567890123456'); // 16 chars
    // final iv = encrypt.IV.fromLength(16);
    // final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Step 3: Encrypt data
    final encrypted = encrypter.encryptBytes(response.bodyBytes, iv: iv);

    // Step 4: Save encrypted file
    final dir = await getApplicationDocumentsDirectory();
    final filePath = p.join(dir.path, "$fileName.enc");
    final file = File(filePath);
    await file.writeAsBytes(encrypted.bytes);

 
    return file.path;
// Return path to store in DB
  }
}
