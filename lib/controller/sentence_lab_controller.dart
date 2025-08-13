import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/sentence_db_helper.dart';

class SentenceLabController extends GetxController {
  RxString title = "Sentence Lab".obs;
  late List<SentenceLabModel> sentenceLabList;
  final RxBool isLoading = true.obs;

  List<Map<String, dynamic>> sentenceConstructionLabList = [
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
  ];
  @override
  void onInit() {
    log('[onInit] Starting onInit');
    onFirst();
    super.onInit();
  }

  onFirst() async {
    log('[onFirst] Called');
    final args = Get.arguments as Map<String, dynamic>?;
    title.value = args?['title'] ?? "Sentence Lab";
    log('[onFirst] title set to: ${title.value}');

    sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
    log('[onFirst] Loaded ${sentenceLabList.length} items from local DB');

    try {
      log('[onFirst] Fetching latest data from Firebase...');
      final firebaseData = await fetchSentenceLabData();
      log('[onFirst] Fetched ${firebaseData.length} sections from Firebase');

      log('[onFirst] Saving/Updating local data...');
      await saveDataLocallyIncremental(firebaseData);
      log('[onFirst] Incremental save completed');

      // Reload local after merge
      sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
    } catch (e, stacktrace) {
      log('[onFirst] Error syncing data: $e');
      log("$stacktrace");
    }

    isLoading.value = false;
    update();
  }

  Future<List<SentenceLabModel>> fetchSentenceLabData() async {
    log('[fetchSentenceLabData] Fetching from Firebase...');
    final ref = FirebaseDatabase.instance.ref().child("SentenceLabCollection");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      log('[fetchSentenceLabData] Data exists in Firebase');
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      final parsed = parseSentenceLabCollection(data);
      log('[fetchSentenceLabData] Parsed ${parsed.length} sections');
      return parsed;
    } else {
      log('[fetchSentenceLabData] No data found in Firebase');
      throw Exception('No data found');
    }
  }

  List<SentenceLabModel> parseSentenceLabCollection(Map<String, dynamic> json) {
    log('[parseSentenceLabCollection] Parsing JSON...');
    final sections = json.entries.map((sectionEntry) {
      final sectionName = sectionEntry.key;
      final categoryMap = Map<String, dynamic>.from(sectionEntry.value as Map);

      final categories = categoryMap.entries.map((categoryEntry) {
        final categoryName = categoryEntry.key;
        final subCategoryMap =
            Map<String, dynamic>.from(categoryEntry.value as Map);

        final subCategories = subCategoryMap.entries.map((subCategoryEntry) {
          final subCategoryId = subCategoryEntry.key;
          final rawList = subCategoryEntry.value as List<dynamic>;

          final sentenceModels = rawList.map((e) {
            return SentenceModel.fromJson(Map<String, dynamic>.from(e as Map));
          }).toList();

          return SubCategoryModel(
            id: subCategoryId,
            sentence: sentenceModels,
          );
        }).toList();

        return CategoryModel(
          categoryName: categoryName,
          subCategories: subCategories,
        );
      }).toList();

      return SentenceLabModel(
        sectionName: sectionName,
        categories: categories,
      );
    }).toList();

    log('[parseSentenceLabCollection] Completed parsing JSON');
    return sections;
  }

  Future<void> saveDataLocallyIncremental(List<SentenceLabModel> data) async {
    final dbHelper = SentenceDBHelper();

    for (var section in data) {
      // Section
      int? sectionId = await dbHelper.getSectionIdByName(section.sectionName);
      if (sectionId == null) {
        sectionId = await dbHelper.insertSection(section.sectionName);
      }

      for (var category in section.categories) {
        // Category
        int? categoryId =
            await dbHelper.getCategoryId(sectionId!, category.categoryName);
        if (categoryId == null) {
          categoryId =
              await dbHelper.insertCategory(sectionId, category.categoryName);
        }

        for (var subCategory in category.subCategories) {
          // SubCategory
          int? subCategoryDbId =
              await dbHelper.getSubCategoryDbId(categoryId!, subCategory.id);
          if (subCategoryDbId == null) {
            subCategoryDbId =
                await dbHelper.insertSubCategory(categoryId, subCategory.id);
          }

          for (var sentence in subCategory.sentence) {
            // Sentence
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
}
