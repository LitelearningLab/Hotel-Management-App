import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
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

    // 🔥 Web: Directly load from Firebase (NO DB CALL)
    if (kIsWeb) {
      log('[onFirst] Running on Web → Skipping local DB.');
      try {
        log('[onFirst] Fetching data from Firebase (Web)...');
        sentenceLabList = await fetchSentenceLabData();
        log('[onFirst] Loaded ${sentenceLabList.length} sections from Firebase.');
      } catch (e, st) {
        log('[onFirst] Web fetch failed: $e');
        log('$st');
      }
      isLoading.value = false;
      update();
      return;
    }

    // 📱 Non-Web: Local DB logic
    final prefs = await SharedPreferences.getInstance();
    hasInitialized = prefs.getBool("sentenceLabInitialized6") ?? false;
    update();

    if (!hasInitialized) {
      // 🚨 First run → clear DB and fetch new data
      log('[onFirst] First-time run detected → clearing local DB...');
      await SentenceDBHelper().deleteDatabaseFile();

      try {
        log('[onFirst] Fetching latest data from Firebase (first run)...');
        final firebaseData = await fetchSentenceLabData();
        log('[onFirst] Fetched ${firebaseData.length} sections');

        log('[onFirst] Saving data locally...');
        await SentenceDBHelper().saveDataLocally(firebaseData);

        sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
      } catch (e, st) {
        log('[onFirst] Error during first fetch: $e');
        log('$st');
      }

      await prefs.setBool("sentenceLabInitialized6", true);
    } else {
      // ✅ Already initialized
      sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
      log('[onFirst] Loaded ${sentenceLabList.length} items locally');

      if (sentenceLabList.isNotEmpty) {
        // 🔄 Background sync
        unawaited(() async {
          try {
            log('[onFirst] Background sync started...');
            final firebaseData = await fetchSentenceLabData();
            await SentenceDBHelper().syncData(firebaseData);
            sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
            log('[onFirst] Sync complete → ${sentenceLabList.length} items');
            update();
          } catch (e, st) {
            log('[onFirst] Sync failed: $e');
            log('$st');
          }
        }());
      } else {
        // No local data → fetch directly and save
        try {
          log('[onFirst] No local data → fetching from Firebase...');
          final firebaseData = await fetchSentenceLabData();
          await SentenceDBHelper().saveDataLocally(firebaseData);
          sentenceLabList = await SentenceDBHelper().getAllSentenceLabData();
        } catch (e, st) {
          log('[onFirst] Error fetching data: $e');
          log('$st');
        }
      }
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
