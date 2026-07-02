import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class DBHelper {
  static Database? _db;

  static String _sanitizeLocalPath(String path) {
    final trimmed = path.trim();
    if (trimmed.startsWith('file://')) {
      return trimmed.replaceFirst('file://', '');
    }
    return trimmed;
  }

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
      file TEXT UNIQUE,
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
    final existingByFile = await db.query(
      '"$tableId"',
      where: 'file = ?',
      whereArgs: [item.file],
    );
    List<Map<String, Object?>> existing = existingByFile;

    // Fallback: backend file/url may change between sessions, so recover
    // persisted localPath/downloadStatus using stable display text.
    if (existing.isEmpty) {
      existing = await db.query(
        '"$tableId"',
        where: 'LOWER(text) = ?',
        whereArgs: [item.text.toLowerCase()],
      );
    }

    String localPath = item.localPath;
    int downloadStatus = item.downloadStatus ? 1 : 0;

    if (existing.isNotEmpty) {
      localPath = existing.first['localPath'] as String? ?? localPath;
      downloadStatus =
          existing.first['downloadStatus'] as int? ?? downloadStatus;
    }

    // If matched by text but file changed, remove stale row before inserting
    // the new key to avoid duplicate records for the same word.
    if (existingByFile.isEmpty && existing.isNotEmpty) {
      await db.delete(
        '"$tableId"',
        where: 'LOWER(text) = ?',
        whereArgs: [item.text.toLowerCase()],
      );
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

  static Future<void> insertSoundcategory(
      SoundPractice item, String tableId) async {
    final db = await database;
    await ensureTableExists(tableId);

    // Check if it already exists
    final existingByFile = await db.query(
      '"$tableId"',
      where: 'file = ?',
      whereArgs: [item.file],
    );
    List<Map<String, Object?>> existing = existingByFile;

    if (existing.isEmpty) {
      existing = await db.query(
        '"$tableId"',
        where: 'LOWER(text) = ?',
        whereArgs: [item.text.toLowerCase()],
      );
    }

    String localPath = item.localPath;
    int downloadStatus = item.downloadStatus ? 1 : 0;

    if (existing.isNotEmpty) {
      localPath = existing.first['localPath'] as String? ?? localPath;
      downloadStatus =
          existing.first['downloadStatus'] as int? ?? downloadStatus;
    }

    if (existingByFile.isEmpty && existing.isNotEmpty) {
      await db.delete(
        '"$tableId"',
        where: 'LOWER(text) = ?',
        whereArgs: [item.text.toLowerCase()],
      );
    }

    await db.insert(
      '"$tableId"',
      {
        'file': item.file,
        'syllables': item.syllables,
        'text': item.text,
        'pronun': item.pronun,
        'downloadStatus': downloadStatus,
        'localPath': localPath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeDuplicates(String tableId) async {
    final db = await database;
    await ensureTableExists(tableId);

    // Find files with duplicates
    final duplicateFilesQuery = await db.rawQuery('''
    SELECT file, COUNT(*) as cnt
    FROM "$tableId"
    GROUP BY file
    HAVING cnt > 1
  ''');

    for (var row in duplicateFilesQuery) {
      String file = row['file'] as String;

      // Get all rows with this file, ordered by id
      final rows = await db.query('"$tableId"',
          where: 'file = ?',
          whereArgs: [file],
          orderBy: 'id ASC' // Keep the oldest one
          );

      if (rows.length > 1) {
        final idToKeep = rows.first['id'];

        await db.delete(
          '"$tableId"',
          where: 'file = ? AND id != ?',
          whereArgs: [file, idToKeep],
        );

        log('🧹 Removed duplicates for file: $file, kept id: $idToKeep');
      }
    }
  }

  static Future<void> updateSubcategory(
      SubcategoryPro item, String tableId) async {
    final db = await database;
    await ensureTableExists(tableId);

    await db.update(
      '"$tableId"',
      {
        'isPriority': item.isPriority,
        'syllables': item.syllables,
        'text': item.text,
        'pronun': item.pronun,
        'sentenceSamples': jsonEncode(item.sentenceSamples),
        'meaningSamples': jsonEncode(item.meaningSamples),
      },
      where: 'file = ?',
      whereArgs: [item.file],
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

  static Future<List<SubcategoryPro>> getAllSubcategoriesValidated(
      String id) async {
    final db = await database;
    await ensureTableExists(id);
    final rows = await db.rawQuery('SELECT * FROM "$id"');
    final items = rows.map((e) => SubcategoryPro.fromMap(e)).toList();

    for (final item in items) {
      final sanitizedPath = _sanitizeLocalPath(item.localPath);
      final hasLocalFile =
          sanitizedPath.isNotEmpty && await File(sanitizedPath).exists();

      if (hasLocalFile) {
        if (!item.downloadStatus || item.localPath != sanitizedPath) {
          await db.update(
            '"$id"',
            {
              'downloadStatus': 1,
              'localPath': sanitizedPath,
            },
            where: 'file = ?',
            whereArgs: [item.file],
          );
        }
        item.downloadStatus = true;
        item.localPath = sanitizedPath;
      } else {
        if (item.downloadStatus || item.localPath.isNotEmpty) {
          await db.update(
            '"$id"',
            {
              'downloadStatus': 0,
              'localPath': '',
            },
            where: 'file = ?',
            whereArgs: [item.file],
          );
        }
        item.downloadStatus = false;
        item.localPath = '';
      }
    }

    return items;
  }

  static Future<List<Map<String, dynamic>>> getAllSoundcategories(
      String table) async {
    final db = await database;
    return await db.query(table);
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

  static Future<void> clearTable(String tableId) async {
    final db = await database;
    await ensureTableExists(tableId);
    await db.delete('"$tableId"');
    log("🗑 Cleared all data from table $tableId");
  }

  /// Clear entire database (remove all tables & data)
  static Future<void> clearDatabase() async {
    final db = await database;
    final tables =
        await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');

    for (var table in tables) {
      final tableName = table['name'] as String;
      if (tableName != "sqlite_sequence") {
        await db.delete('"$tableName"');
        log("🗑 Cleared table $tableName");
      }
    }
  }
}
