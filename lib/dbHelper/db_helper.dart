import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'app_data.db');

    return await openDatabase(path, version: 1);
  }

  static Future<void> ensureTableExists(String id) async {
    final db = await database;
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "$id" (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      file TEXT,
      isPriority TEXT,
      syllables TEXT,
      text TEXT,
      pronun TEXT,
      downloadStatus INTEGER,
      localPath TEXT,
      sentenceSamples TEXT,
      meaningSamples TEXT
    )
  ''');
  }

  static Future<void> insertSubcategory(
      SubcategoryPro item, String tableId) async {
    final db = await database;
    await ensureTableExists(tableId);

    // Check if it already exists
    final existing = await db.query(
      '"$tableId"',
      where: 'file = ?',
      whereArgs: [item.file],
    );

    String localPath = item.localPath;
    int downloadStatus = item.downloadStatus ? 1 : 0;

    if (existing.isNotEmpty) {
      localPath = existing.first['localPath'] as String? ?? localPath;
      downloadStatus =
          existing.first['downloadStatus'] as int? ?? downloadStatus;
    }

    await db.insert(
      '"$tableId"',
      {
        'file': item.file,
        'isPriority': item.isPriority,
        'syllables': item.syllables,
        'text': item.text,
        'pronun': item.pronun,
        'downloadStatus': downloadStatus,
        'localPath': localPath,
        'sentenceSamples': jsonEncode(item.sentenceSamples),
        'meaningSamples': jsonEncode(item.meaningSamples), // ✅ new field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateLocalPath(
      String file, String id, String localPath) async {
    final db = await database;
    await db.update(
      '"$id"',
      {'localPath': localPath},
      where: 'file = ?',
      whereArgs: [file],
    );
  }

  static Future<String> downloadAndEncryptAudio(
      String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception("Failed to download audio");

    final key = encrypt.Key.fromUtf8('1234567890123456'); // 16 char key
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encryptBytes(response.bodyBytes, iv: iv);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = p.join(dir.path, "$fileName.enc");
    await File(filePath).writeAsBytes(encrypted.bytes);

    return filePath;
  }

  static Future<List<SubcategoryPro>> getAllSubcategories(String id) async {
    final db = await database;
    await ensureTableExists(id);
    final result = await db.rawQuery('SELECT * FROM "$id"');
    return result.map((e) => SubcategoryPro.fromMap(e)).toList();
  }

  Future<void> toggleDownloadStatus(String id, String file, bool status) async {
    final db = await database;
    await db.update(
      '"$id"',
      {'downloadStatus': status ? 1 : 0},
      where: 'file = ?',
      whereArgs: [file],
    );
  }

  static Future<void> setDownloadStatus(
      String file, String tableId, int status) async {
    final db = await database;
    await ensureTableExists(tableId);
    await db.update(
      '"$tableId"',
      {'downloadStatus': status},
      where: 'file = ?',
      whereArgs: [file],
    );
    log("✅ Set downloadStatus for $file in table $tableId → $status");
  }

  Future<bool> isDownloaded(String id, String file) async {
    final db = await database;
    final result = await db.query(
      '"$id"',
      where: 'file = ?',
      whereArgs: [file],
    );
    if (result.isNotEmpty) {
      return result.first['downloadStatus'] == 1;
    }
    return false;
  }
}
