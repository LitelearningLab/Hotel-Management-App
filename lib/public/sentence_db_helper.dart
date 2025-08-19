import 'dart:async';
import 'dart:developer';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SentenceDBHelper {
  static final SentenceDBHelper _instance = SentenceDBHelper._internal();
  factory SentenceDBHelper() => _instance;
  SentenceDBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'sentence_lab.db');

    return await openDatabase(
      path,
      version: 2, // bumped version to 2 for schema update
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add new columns to sentences table
          await db.execute(
              'ALTER TABLE sentences ADD COLUMN isDownloaded INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE sentences ADD COLUMN localPath TEXT DEFAULT ""');
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
        CREATE TABLE sentence_lab_sections(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sectionName TEXT UNIQUE
        )
      ''');

    await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sectionId INTEGER,
          categoryName TEXT,
          FOREIGN KEY(sectionId) REFERENCES sentence_lab_sections(id)
        )
      ''');

    await db.execute('''
        CREATE TABLE sub_categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          categoryId INTEGER,
          subCategoryId TEXT,
          FOREIGN KEY(categoryId) REFERENCES categories(id)
        )
      ''');

    await db.execute('''
        CREATE TABLE sentences(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          subCategoryId INTEGER,
          file TEXT,
          isPriority INTEGER,
          text TEXT,
          isDownloaded INTEGER DEFAULT 0,
          localPath TEXT DEFAULT "",
          FOREIGN KEY(subCategoryId) REFERENCES sub_categories(id)
        )
      ''');
  }

  Future<int> insertSection(String sectionName) async {
    final db = await database;
    return await db.insert(
      'sentence_lab_sections',
      {'sectionName': sectionName},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int?> getSectionIdByName(String sectionName) async {
    final db = await database;
    final result = await db.query(
      'sentence_lab_sections',
      where: 'sectionName = ?',
      whereArgs: [sectionName],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  Future<int> insertCategory(int sectionId, String categoryName) async {
    final db = await database;
    return await db.insert(
        'categories',
        {
          'sectionId': sectionId,
          'categoryName': categoryName,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int?> getCategoryId(int sectionId, String categoryName) async {
    final db = await database;
    final result = await db.query('categories',
        where: 'sectionId = ? AND categoryName = ?',
        whereArgs: [sectionId, categoryName]);
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  Future<int> insertSubCategory(int categoryId, String subCategoryId) async {
    final db = await database;
    return await db.insert(
        'sub_categories',
        {
          'categoryId': categoryId,
          'subCategoryId': subCategoryId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int?> getSubCategoryDbId(int categoryId, String subCategoryId) async {
    final db = await database;
    final result = await db.query('sub_categories',
        where: 'categoryId = ? AND subCategoryId = ?',
        whereArgs: [categoryId, subCategoryId]);
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  Future<int> insertSentence(
      int subCategoryDbId, SentenceModel sentence) async {
    final db = await database;
    return await db.insert('sentences', {
      'subCategoryId': subCategoryDbId,
      'file': sentence.file,
      'isPriority': sentence.isPriority ? 1 : 0,
      'text': sentence.text,
      'isDownloaded': sentence.isDownloaded ? 1 : 0,
      'localPath': sentence.localPath,
    });
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('sentences');
    await db.delete('sub_categories');
    await db.delete('categories');
    await db.delete('sentence_lab_sections');
  }

  Future<void> saveDataLocallyIncremental(List<SentenceLabModel> data) async {
    final dbHelper = SentenceDBHelper();

    for (var section in data) {
      // 1. Section
      int? sectionId = await dbHelper.getSectionIdByName(section.sectionName);
      if (sectionId == null) {
        sectionId = await dbHelper.insertSection(section.sectionName);
        if (sectionId == 0) {
          // If insert ignored (already exists), fetch id
          sectionId = await dbHelper.getSectionIdByName(section.sectionName);
        }
      }

      for (var category in section.categories) {
        // 2. Category
        int? categoryId =
            await dbHelper.getCategoryId(sectionId!, category.categoryName);
        if (categoryId == null) {
          categoryId =
              await dbHelper.insertCategory(sectionId, category.categoryName);
          if (categoryId == 0) {
            categoryId =
                await dbHelper.getCategoryId(sectionId, category.categoryName);
          }
        }

        for (var subCategory in category.subCategories) {
          // 3. Subcategory
          int? subCategoryDbId =
              await dbHelper.getSubCategoryDbId(categoryId!, subCategory.id);
          if (subCategoryDbId == null) {
            subCategoryDbId =
                await dbHelper.insertSubCategory(categoryId, subCategory.id);
            if (subCategoryDbId == 0) {
              subCategoryDbId =
                  await dbHelper.getSubCategoryDbId(categoryId, subCategory.id);
            }
          }

          for (var sentence in subCategory.sentence) {
            // 4. Sentence check
            final exists = await _sentenceExists(
                subCategoryDbId!, sentence.text, dbHelper);
            if (!exists) {
              await dbHelper.insertSentence(subCategoryDbId, sentence);
            }
          }
        }
      }
    }
  }

  // Helper: check if sentence already exists by subcategory + text
  Future<bool> _sentenceExists(
      int subCategoryDbId, String text, SentenceDBHelper dbHelper) async {
    final db = await dbHelper.database;
    final res = await db.query(
      'sentences',
      where: 'subCategoryId = ? AND text = ?',
      whereArgs: [subCategoryDbId, text],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<void> removeMissingDataFromFirebase(
      List<String> firebaseSentenceIds) async {
    final db = await database;

    // Step 1: Get all sentence IDs currently stored in SQLite
    final localSentences = await db.query('sentences', columns: ['id']);
    final localIds = localSentences.map((row) => row['id'].toString()).toSet();

    // Step 2: Firebase IDs → set for quick lookup
    final firebaseIdSet = firebaseSentenceIds.toSet();

    // Step 3: Find IDs that are in SQLite but NOT in Firebase
    final missingIds = localIds.difference(firebaseIdSet);

    if (missingIds.isEmpty) {
      log("✅ No missing data to remove.");
      return;
    }

    // Step 4: Delete missing sentences from SQLite
    final placeholders = List.filled(missingIds.length, '?').join(',');
    await db.delete(
      'sentences',
      where: 'id IN ($placeholders)',
      whereArgs: missingIds.toList(),
    );

    log("🗑️ Removed ${missingIds.length} missing sentences from SQLite.");
  }

  Future<List<SentenceLabModel>> getAllSentenceLabData() async {
    final db = await database;

    final sectionRows = await db.query('sentence_lab_sections');

    List<SentenceLabModel> result = [];

    for (var section in sectionRows) {
      int sectionId = section['id'] as int;
      String sectionName = section['sectionName'] as String;

      final categoryRows = await db.query(
        'categories',
        where: 'sectionId = ?',
        whereArgs: [sectionId],
      );

      List<CategoryModel> categories = [];

      for (var category in categoryRows) {
        int categoryId = category['id'] as int;
        String categoryName = category['categoryName'] as String;

        final subCategoryRows = await db.query(
          'sub_categories',
          where: 'categoryId = ?',
          whereArgs: [categoryId],
        );

        List<SubCategoryModel> subCategories = [];

        for (var subCategory in subCategoryRows) {
          int subCategoryDbId = subCategory['id'] as int;
          String subCategoryId = subCategory['subCategoryId'] as String;

          final sentenceRows = await db.query(
            'sentences',
            where: 'subCategoryId = ?',
            whereArgs: [subCategoryDbId],
          );

          List<SentenceModel> sentences = sentenceRows.map((s) {
            return SentenceModel(
              id: s['id'] as int,
              file: s['file'] as String,
              isPriority: (s['isPriority'] as int) == 1,
              text: s['text'] as String,
              isDownloaded: (s['isDownloaded'] as int) == 1,
              localPath: s['localPath'] as String,
            );
          }).toList();

          subCategories.add(SubCategoryModel(
            id: subCategoryId,
            sentence: sentences,
          ));
        }

        categories.add(CategoryModel(
          categoryName: categoryName,
          subCategories: subCategories,
        ));
      }

      result.add(SentenceLabModel(
        sectionName: sectionName,
        categories: categories,
      ));
    }

    return result;
  }

  Future<void> updateSentenceDownloadStatusAndPath(
    int sentenceId,
    bool isDownloaded,
    String localPath,
  ) async {
    final db = await database;
    await db.update(
      'sentences',
      {
        'isDownloaded': isDownloaded ? 1 : 0,
        'localPath': localPath,
      },
      where: 'id = ?',
      whereArgs: [sentenceId],
    );
  }

  Future<void> toggleSentenceDownloadStatus(int sentenceId) async {
    final db = await database;
    final result = await db.query(
      'sentences',
      columns: ['isDownloaded'],
      where: 'id = ?',
      whereArgs: [sentenceId],
    );

    if (result.isEmpty) {
      log('toggleSentenceDownloadStatus: Sentence with id $sentenceId not found');
      return;
    }

    int currentStatus = result.first['isDownloaded'] as int;
    int newStatus = currentStatus == 1 ? 0 : 1;

    await db.update(
      'sentences',
      {'isDownloaded': newStatus},
      where: 'id = ?',
      whereArgs: [sentenceId],
    );

    log('toggleSentenceDownloadStatus: sentenceId $sentenceId isDownloaded changed from $currentStatus to $newStatus');
  }

  Future<List<SentenceModel>> getSentencesBySubCategoryDbId(
      int subCategoryDbId) async {
    final db = await database;

    final sentenceRows = await db.query(
      'sentences',
      where: 'subCategoryId = ?',
      whereArgs: [subCategoryDbId],
    );

    return sentenceRows.map((s) {
      return SentenceModel(
        id: s['id'] as int,
        file: s['file'] as String,
        isPriority: (s['isPriority'] as int) == 1,
        text: s['text'] as String,
        isDownloaded: (s['isDownloaded'] as int) == 1,
        localPath: s['localPath'] as String,
      );
    }).toList();
  }

  Future<int?> getSubCategoryDbIdBySubCategoryId(String subCategoryId) async {
    final db = await database;
    final result = await db.query(
      'sub_categories',
      where: 'subCategoryId = ?',
      whereArgs: [subCategoryId],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }

    return null;
  }

  Future<List<SubCategoryModel>> getSubCategoriesByCategoryId(
      int categoryId) async {
    final db = await database;
    final subCategoryRows = await db.query(
      'sub_categories',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );

    List<SubCategoryModel> subCategories = [];

    for (var sub in subCategoryRows) {
      int subCategoryDbId = sub['id'] as int;
      String subCategoryId = sub['subCategoryId'] as String;

      final sentences = await getSentencesBySubCategoryDbId(subCategoryDbId);

      subCategories.add(SubCategoryModel(
        id: subCategoryId,
        sentence: sentences,
      ));
    }

    return subCategories;
  }

  Future<List<SubCategoryModel>> getSubCategoriesByCategoryName(
      String categoryName) async {
    final db = await database;

    // First get all sub_categories for the categoryName
    final subCategoryRows = await db.rawQuery('''
      SELECT s.id, s.subCategoryId
      FROM sub_categories s
      JOIN categories c ON s.categoryId = c.id
      WHERE c.categoryName = ?
    ''', [categoryName]);

    List<SubCategoryModel> subCategories = [];

    for (var sub in subCategoryRows) {
      int subCategoryDbId = sub['id'] as int;
      String subCategoryId = sub['subCategoryId'] as String;

      final sentences = await getSentencesBySubCategoryDbId(subCategoryDbId);

      subCategories.add(SubCategoryModel(
        id: subCategoryId,
        sentence: sentences,
      ));
    }

    return subCategories;
  }
}
