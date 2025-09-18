import 'dart:async';
import 'dart:developer';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SentenceDBHelper {
  // -----------------------------
  // Singleton Setup
  // -----------------------------
  static final SentenceDBHelper _instance = SentenceDBHelper._internal();
  factory SentenceDBHelper() => _instance;
  SentenceDBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  // -----------------------------
  // Init & Schema
  // -----------------------------
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sentence_lab.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async => _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE sentences ADD COLUMN isDownloaded INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE sentences ADD COLUMN localPath TEXT DEFAULT ""');
          await db.execute(
              'ALTER TABLE categories ADD COLUMN "order" INTEGER DEFAULT 0');
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
      categoryOrder INTEGER,
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

  // -----------------------------
  // Section Methods
  // -----------------------------
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
    return result.isNotEmpty ? result.first['id'] as int : null;
  }

  // -----------------------------
  // Category Methods
  // -----------------------------
  Future<int> insertCategory(
      int sectionId, String categoryName, int categoryOrder) async {
    final db = await database;
    return await db.insert(
      'categories',
      {
        'sectionId': sectionId,
        'categoryName': categoryName,
        'categoryOrder': categoryOrder,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int?> getCategoryId(int sectionId, String categoryName) async {
    final db = await database;
    final result = await db.query(
      'categories',
      where: 'sectionId = ? AND categoryName = ?',
      whereArgs: [sectionId, categoryName],
    );
    return result.isNotEmpty ? result.first['id'] as int : null;
  }

  // -----------------------------
  // SubCategory Methods
  // -----------------------------
  Future<int> insertSubCategory(int categoryId, String subCategoryId) async {
    final db = await database;
    return await db.insert(
      'sub_categories',
      {'categoryId': categoryId, 'subCategoryId': subCategoryId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int?> getSubCategoryDbId(int categoryId, String subCategoryId) async {
    final db = await database;
    final result = await db.query(
      'sub_categories',
      where: 'categoryId = ? AND subCategoryId = ?',
      whereArgs: [categoryId, subCategoryId],
    );
    return result.isNotEmpty ? result.first['id'] as int : null;
  }

  Future<int?> getSubCategoryDbIdBySubCategoryId(String subCategoryId) async {
    final db = await database;
    final result = await db.query(
      'sub_categories',
      where: 'subCategoryId = ?',
      whereArgs: [subCategoryId],
    );
    return result.isNotEmpty ? result.first['id'] as int : null;
  }

  // -----------------------------
  // Sentence Methods
  // -----------------------------
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

  Future<bool> _sentenceExists(int subCategoryDbId, String text) async {
    final db = await database;
    final result = await db.query(
      'sentences',
      where: 'subCategoryId = ? AND text = ?',
      whereArgs: [subCategoryDbId, text],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<SentenceModel>> getSentencesBySubCategoryDbId(
      int subCategoryDbId) async {
    final db = await database;
    final rows = await db.query(
      'sentences',
      where: 'subCategoryId = ?',
      whereArgs: [subCategoryDbId],
    );
    return rows.map((s) {
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

  Future<void> updateSentenceDownloadStatusAndPath(
      int sentenceId, bool isDownloaded, String localPath) async {
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
      log('⚠️ Sentence with id $sentenceId not found');
      return;
    }

    final currentStatus = result.first['isDownloaded'] as int;
    final newStatus = currentStatus == 1 ? 0 : 1;

    await db.update(
      'sentences',
      {'isDownloaded': newStatus},
      where: 'id = ?',
      whereArgs: [sentenceId],
    );

    log('🔄 Sentence $sentenceId download status changed: $currentStatus → $newStatus');
  }

  // -----------------------------
  // Save Methods
  // -----------------------------
  Future<void> saveDataLocally(List<SentenceLabModel> data) async {
    for (var section in data) {
      int? sectionId = await getSectionIdByName(section.sectionName);
      sectionId ??= await insertSection(section.sectionName);

      for (var category in section.categories) {
        int? categoryId =
            await getCategoryId(sectionId!, category.categoryName);
        categoryId ??= await insertCategory(
            sectionId, category.categoryName, category.order);

        for (var subCategory in category.subCategories) {
          int? subCategoryDbId =
              await getSubCategoryDbId(categoryId!, subCategory.id);
          subCategoryDbId ??=
              await insertSubCategory(categoryId!, subCategory.id);

          for (var sentence in subCategory.sentence) {
            final exists =
                await _sentenceExists(subCategoryDbId!, sentence.text);
            if (!exists) {
              await insertSentence(subCategoryDbId, sentence);
            }
          }
        }
      }
    }
  }

  // -----------------------------
  // Fetch Methods
  // -----------------------------
  Future<List<SentenceLabModel>> getAllSentenceLabData() async {
    final db = await database;
    final sectionRows = await db.query('sentence_lab_sections');

    List<SentenceLabModel> result = [];

    for (var section in sectionRows) {
      int sectionId = section['id'] as int;
      String sectionName = section['sectionName'] as String;

      final categoryRows = await db
          .query('categories', where: 'sectionId = ?', whereArgs: [sectionId]);

      List<CategoryModel> categories = [];

      for (var category in categoryRows) {
        int categoryId = category['id'] as int;
        String categoryName = category['categoryName'] as String;

        final subCategoryRows = await db.query('sub_categories',
            where: 'categoryId = ?', whereArgs: [categoryId]);

        List<SubCategoryModel> subCategories = [];

        // for (var sub in subCategoryRows) {
        //   int subCategoryDbId = sub['id'] as int;
        //   String subCategoryId = sub['subCategoryId'] as String;

        //   final sentences =
        //       await getSentencesBySubCategoryDbId(subCategoryDbId);

        //   subCategories
        //       .add(SubCategoryModel(id: subCategoryId, sentence: sentences));
        // }

        categories.add(CategoryModel(
            order: category['categoryOrder'] as int,
            categoryName: categoryName,
            subCategories: subCategories));
      }

      result.add(
          SentenceLabModel(sectionName: sectionName, categories: categories));
    }

    return result;
  }

  Future<List<SubCategoryModel>> getSubCategoriesByCategoryId(
      int categoryId) async {
    final db = await database;
    final rows = await db.query('sub_categories',
        where: 'categoryId = ?', whereArgs: [categoryId]);

    List<SubCategoryModel> subCategories = [];
    for (var sub in rows) {
      int subCategoryDbId = sub['id'] as int;
      String subCategoryId = sub['subCategoryId'] as String;

      final sentences = await getSentencesBySubCategoryDbId(subCategoryDbId);

      subCategories
          .add(SubCategoryModel(id: subCategoryId, sentence: sentences));
    }
    return subCategories;
  }

  Future<List<SubCategoryModel>> getSubCategoriesByCategoryName(
      String categoryName) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT s.id, s.subCategoryId
      FROM sub_categories s
      JOIN categories c ON s.categoryId = c.id
      WHERE c.categoryName = ?
    ''', [categoryName]);

    List<SubCategoryModel> subCategories = [];
    for (var sub in rows) {
      int subCategoryDbId = sub['id'] as int;
      String subCategoryId = sub['subCategoryId'] as String;

      final sentences = await getSentencesBySubCategoryDbId(subCategoryDbId);

      subCategories
          .add(SubCategoryModel(id: subCategoryId, sentence: sentences));
    }
    return subCategories;
  }

  Future<void> syncData(List<SentenceLabModel> newData) async {
    final db = await database;

    // 1. Load local data
    final localData = await getAllSentenceLabData();

    final localSectionNames = localData.map((s) => s.sectionName).toSet();
    final newSectionNames = newData.map((s) => s.sectionName).toSet();

    // 2. Delete sections missing in newData
    for (var local in localSectionNames) {
      if (!newSectionNames.contains(local)) {
        final sectionId = await getSectionIdByName(local);
        if (sectionId != null) {
          await db.delete('sentences',
              where:
                  'subCategoryId IN (SELECT id FROM sub_categories WHERE categoryId IN (SELECT id FROM categories WHERE sectionId = ?))',
              whereArgs: [sectionId]);
          await db.delete('sub_categories',
              where:
                  'categoryId IN (SELECT id FROM categories WHERE sectionId = ?)',
              whereArgs: [sectionId]);
          await db.delete('categories',
              where: 'sectionId = ?', whereArgs: [sectionId]);
          await db.delete('sentence_lab_sections',
              where: 'id = ?', whereArgs: [sectionId]);
        }
      }
    }

    // 3. Upsert logic for new data
    for (var section in newData) {
      int? sectionId = await getSectionIdByName(section.sectionName);
      sectionId ??= await insertSection(section.sectionName);

      for (var category in section.categories) {
        int? categoryId =
            await getCategoryId(sectionId!, category.categoryName);
        categoryId ??= await insertCategory(
            sectionId, category.categoryName, category.order);

        for (var subCategory in category.subCategories) {
          int? subCategoryDbId =
              await getSubCategoryDbId(categoryId!, subCategory.id);
          subCategoryDbId ??=
              await insertSubCategory(categoryId!, subCategory.id);

          for (var sentence in subCategory.sentence) {
            final existing = await db.query(
              'sentences',
              where: 'subCategoryId = ? AND text = ?',
              whereArgs: [subCategoryDbId, sentence.text],
              limit: 1,
            );

            if (existing.isEmpty) {
              // Insert new sentence
              await insertSentence(subCategoryDbId!, sentence);
            } else {
              // Update only server-controlled fields, keep local user data
              final local = existing.first;
              await db.update(
                'sentences',
                {
                  'file': sentence.file,
                  'isPriority': sentence.isPriority ? 1 : 0,
                  'text': sentence.text,
                  // keep local values
                  'isDownloaded': local['isDownloaded'],
                  'localPath': local['localPath'],
                },
                where: 'id = ?',
                whereArgs: [local['id']],
              );
            }
          }
        }
      }
    }
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sentence_lab.db');
    await deleteDatabase(path);
  }

  // -----------------------------
  // Utility
  // -----------------------------
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('sentences');
    await db.delete('sub_categories');
    await db.delete('categories');
    await db.delete('sentence_lab_sections');
  }
}
