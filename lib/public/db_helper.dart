import 'dart:developer';
import 'dart:io';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
        downloadStatus INTEGER
      )
    ''');
  }

  static Future<void> insertSubcategory(SubcategoryPro item, String id) async {
    final db = await database;
    await ensureTableExists(id); // Ensure the table exists before inserting

    await db.rawInsert(
      'INSERT OR REPLACE INTO "$id" (file, isPriority, syllables, text, pronun, downloadStatus) VALUES (?, ?, ?, ?, ?, ?)',
      [
        item.file,
        item.isPriority,
        item.syllables,
        item.text,
        item.pronun,
        item.downloadStatus == true ? 1 : 0
      ],
    );
  }

  static Future<List<SubcategoryPro>> getAllSubcategories(String id) async {
    final db = await database;
    await ensureTableExists(id);
    final result = await db.rawQuery('SELECT * FROM "$id"');
    return result.map((e) => SubcategoryPro.fromMap(e)).toList();
  }

  static Future<void> toggleDownloadStatus(String file, String id) async {
    final db = await database;

    final result = await db.query(
      '"$id"',
      columns: ['downloadStatus'],
      where: 'file = ?',
      whereArgs: [file],
    );

    if (result.isNotEmpty) {
      final currentStatus = result.first['downloadStatus'] == 1;

      final newStatus = currentStatus ? 0 : 1;

      await db.update(
        '"$id"',
        {'downloadStatus': newStatus},
        where: 'file = ?',
        whereArgs: [file],
      );
      log("updated download status for $file in table $id to $newStatus");
    } else {
      print('⚠️ File not found in table $id: $file');
    }
  }

  static Future<bool> isDownloaded(String file, String id) async {
    final db = await database;
    final result = await db.query(
      id,
      where: 'file = ?',
      whereArgs: [file],
    );
    return result.isNotEmpty && result.first['downloadStatus'] == 1;
  }
}
