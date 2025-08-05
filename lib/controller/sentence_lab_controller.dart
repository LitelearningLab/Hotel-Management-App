import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';

class SentenceLabController extends GetxController {
  RxString title = "Sentence Lab".obs;
  late List<SentenceLabModel> sentenceLabList;
  final RxBool isLoading = true.obs;
  List<Map<String, dynamic>> sentenceConstructionLabList = [
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Professional Call Procedures',
      'load': 'Professional Call Procedures',
      'menuText': 'Professional Call Procedures',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slPcp,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Questions Lab',
      'load': 'Questions Lab',
      'menuText': 'Questions Lab',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slQl,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Frequent Scenarios',
      'load': 'Samples for frequent scenarios',
      'menuText': 'Frequent Scenarios',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.slFs,
      'bgColor': Color(0xFF0190FE),
    },
  ];

  @override
  void onInit() {
    onFirst();
    super.onInit();
  }

  onFirst() async {
    final args = Get.arguments as Map<String, dynamic>?;
    title.value = args?['title'] ?? "Sentence Lab";
    sentenceLabList = await fetchSentenceLabData();
    isLoading.value = false;
    update();
  }

  Future<List<SentenceLabModel>> fetchSentenceLabData() async {
    final ref = FirebaseDatabase.instance.ref().child("SentenceLabCollection");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      return parseSentenceLabCollection(data);
    } else {
      throw Exception('No data found');
    }
  }

  List<SentenceLabModel> parseSentenceLabCollection(Map<String, dynamic> json) {
    return json.entries.map((sectionEntry) {
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
  }
}
