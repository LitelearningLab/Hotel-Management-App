import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/dbHelper/sentence_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SentenceLabController extends GetxController {
  RxString title = "Sentence Lab".obs;
  List<SentenceLabModel> sentenceLabList = [];
  final RxBool isLoading = true.obs;
  bool hasInitialized = true;
  List<Map<String, dynamic>> sentenceConstructionLabList = [
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
    {'image': AllAssets.slPcp, 'bgColor': Color(0xFF5370D4)},
    {'image': AllAssets.slQl, 'bgColor': Color(0xFF3DBAD3)},
    {'image': AllAssets.slFs, 'bgColor': Color(0xFF0190FE)},
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

    final prefs = await SharedPreferences.getInstance();
    hasInitialized = prefs.getBool("sentenceLabInitialized2") ?? false;
    update();

    if (!hasInitialized) {
      // 🚨 First-time run → clear everything
      log('[onFirst] First-time run detected → clearing local DB...');
      await SentenceDBHelper().deleteDatabaseFile();

      try {
        log('[onFirst] Fetching latest data from Firebase (first run)...');
        final firebaseData = await fetchSentenceLabData();
        log('[onFirst] Fetched ${firebaseData.length} sections from Firebase');

        log('[onFirst] Saving fresh data locally...');
        // sentenceLabList = firebaseData;
        await SentenceDBHelper().saveDataLocally(firebaseData);
        // log('[onFirst] Initial save completed');

        // // Reload local after save
        sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
      } catch (e, stacktrace) {
        log('[onFirst] Error during first-time fetch: $e');
        log("$stacktrace");
      }

      // ✅ Mark initialization as done
      await prefs.setBool("sentenceLabInitialized2", true);
      isLoading.value = false;
      update();
      return;
    }

    // 🔄 Normal logic after initialization
    sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
    log('[onFirst] Loaded ${sentenceLabList.length} items from local DB');

    if (sentenceLabList.isNotEmpty) {
      // ✅ Already have local data → use it directly
      isLoading.value = false;
      update();

      // 🔄 Background refresh from Firebase
      unawaited(() async {
        try {
          log('[onFirst] Background sync started...');
          final firebaseData = await fetchSentenceLabData();
          await SentenceDBHelper().syncData(firebaseData);

          // Reload after sync
          sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
          log('[onFirst] Sync completed → ${sentenceLabList.length} items');
          update();
        } catch (e, st) {
          log('[onFirst] Sync failed: $e');
          log("$st");
        }
      }());
      return;
    }

    // 2. If no local data → fetch from Firebase once
    try {
      log('[onFirst] Fetching latest data from Firebase...');
      final firebaseData = await fetchSentenceLabData();
      log('[onFirst] Fetched ${firebaseData.length} sections from Firebase');

      log('[onFirst] Saving data locally...');
      await SentenceDBHelper().saveDataLocally(firebaseData);
      log('[onFirst] Initial save completed');

      // Reload local after save
      sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
    } catch (e, stacktrace) {
      log('[onFirst] Error fetching data: $e');
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
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        snapshot.value as Map,
      );
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

      final categories = categoryMap.entries
          .where((e) => e.key != 'order') // exclude 'order' key
          .map((categoryEntry) {
        final categoryName = categoryEntry.key;
        final subCategoryMap = Map<String, dynamic>.from(
          categoryEntry.value as Map,
        );

        final subCategories = subCategoryMap.entries
            .where((subCategoryEntry) => subCategoryEntry.key != 'order')
            .map((subCategoryEntry) {
          final subCategoryId = subCategoryEntry.key;
          final rawList = subCategoryEntry.value as List<dynamic>; // safe now

          final sentenceModels = rawList
              .map(
                (e) => SentenceModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();

          return SubCategoryModel(
            id: subCategoryId,
            sentence: sentenceModels,
            // You can now also parse the order here if needed
            // order: subCategoryMap['order']?.toString() ?? '',
          );
        }).toList();
        log(
          "${subCategoryMap['order']} here is printing what im getting from the backend",
        );
        return CategoryModel(
          order: int.tryParse(subCategoryMap['order']?.toString() ?? "2") ?? 10,
          categoryName: categoryName,
          subCategories: subCategories,
        );
      }).toList();

      return SentenceLabModel(sectionName: sectionName, categories: categories);
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
        int? categoryId = await dbHelper.getCategoryId(
          sectionId!,
          category.categoryName,
        );
        categoryId ??= await dbHelper.insertCategory(
          sectionId,
          category.categoryName,
          category.order,
        );

        for (var subCategory in category.subCategories) {
          // SubCategory
          int? subCategoryDbId = await dbHelper.getSubCategoryDbId(
            categoryId!,
            subCategory.id,
          );
          subCategoryDbId ??= await dbHelper.insertSubCategory(
            categoryId,
            subCategory.id,
          );

          for (var sentence in subCategory.sentence) {
            // Sentence
            final exists = await _sentenceExists(
              subCategoryDbId!,
              sentence.text,
              dbHelper,
            );
            if (!exists) {
              await dbHelper.insertSentence(subCategoryDbId, sentence);
            }
          }
        }
      }
    }
  }

  Future<bool> _sentenceExists(
    int subCategoryDbId,
    String text,
    SentenceDBHelper dbHelper,
  ) async {
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
