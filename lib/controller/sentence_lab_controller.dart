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

    if (sentenceLabList.isNotEmpty) {
      log('[onFirst] Using local DB data, skipping Firebase fetch');
      isLoading.value = false;
      update();
      return;
    }

    try {
      log('[onFirst] No local data found, fetching from Firebase...');
      sentenceLabList = await fetchSentenceLabData();
      log('[onFirst] Fetched ${sentenceLabList.length} items from Firebase');

      log('[onFirst] Saving fetched data locally...');
      await saveDataLocally(sentenceLabList);
      log('[onFirst] Data saved locally');

      isLoading.value = false;
      update();
    } catch (e, stacktrace) {
      isLoading.value = false;
      update();
      log('[onFirst] Error fetching data: $e');
      log("$stacktrace");
    }
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
      log('[parseSentenceLabCollection] Parsing section: $sectionName');
      final categoryMap = Map<String, dynamic>.from(sectionEntry.value as Map);

      final categories = categoryMap.entries.map((categoryEntry) {
        final categoryName = categoryEntry.key;
        log('  [parseSentenceLabCollection] Parsing category: $categoryName');
        final subCategoryMap =
            Map<String, dynamic>.from(categoryEntry.value as Map);

        final subCategories = subCategoryMap.entries.map((subCategoryEntry) {
          final subCategoryId = subCategoryEntry.key;
          log('    [parseSentenceLabCollection] Parsing subCategory: $subCategoryId');
          final rawList = subCategoryEntry.value as List<dynamic>;

          final sentenceModels = rawList.map((e) {
            final sentence =
                SentenceModel.fromJson(Map<String, dynamic>.from(e as Map));
            log('      [parseSentenceLabCollection] Parsed sentence: ${sentence.text}');
            return sentence;
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

  Future<void> saveDataLocally(List<SentenceLabModel> data) async {
    log('[saveDataLocally] Starting saving data locally...');
    final dbHelper = SentenceDBHelper();

    log('[saveDataLocally] Clearing old data...');
    await dbHelper.clearAllData();

    for (var section in data) {
      log('[saveDataLocally] Inserting section: ${section.sectionName}');
      int sectionId = await dbHelper.insertSection(section.sectionName);

      for (var category in section.categories) {
        log('  [saveDataLocally] Inserting category: ${category.categoryName}');
        int categoryId =
            await dbHelper.insertCategory(sectionId, category.categoryName);

        for (var subCategory in category.subCategories) {
          log('    [saveDataLocally] Inserting subCategory: ${subCategory.id}');
          int subCategoryDbId =
              await dbHelper.insertSubCategory(categoryId, subCategory.id);

          for (var sentence in subCategory.sentence) {
            log('      [saveDataLocally] Inserting sentence: ${sentence.text}');
            await dbHelper.insertSentence(subCategoryDbId, sentence);
          }
        }
      }
    }
    print('[saveDataLocally] Finished saving data locally');
  }
}
