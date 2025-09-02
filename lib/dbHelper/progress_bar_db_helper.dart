import 'package:hotelmanagementapp/model/progress_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProgressBarDbHelper {
  static Database? _db;

  static Future<Database> getDB() async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'progress.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE progress(
            id TEXT PRIMARY KEY,
            option1Time INTEGER,
            option1Done INTEGER,
            option2Time INTEGER,
            option2Done INTEGER,
            percentageEarned REAL
          )
        ''');
      },
    );
  }

  static Future<void> saveProgress(ProgressModel progress) async {
    final db = await getDB();
    await db.insert('progress', progress.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<ProgressModel?> getProgress(String id) async {
    final db = await getDB();
    final result = await db.query('progress', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return ProgressModel.fromMap(result.first);
    }
    return null;
  }

  static Future<List<ProgressModel>> getAllProgress() async {
    final db = await getDB();
    final maps = await db.query('progress');
    return List.generate(maps.length, (i) => ProgressModel.fromMap(maps[i]));
  }

  static Future<double> getTotalProgress() async {
    final db = await getDB();
    final maps = await db.query('progress');
    double total = 0;
    for (var row in maps) {
      total += row['percentageEarned'] as double;
    }
    return total;
  }
}
