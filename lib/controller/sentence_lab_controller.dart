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
      String sectionName = sectionEntry.key;
      Map<String, dynamic> categoriesMap =
          Map<String, dynamic>.from(sectionEntry.value as Map);

      List<CategoryModel> categoryList =
          categoriesMap.entries.map((categoryEntry) {
        String categoryName = categoryEntry.key;
        Map<String, dynamic> sentencesMap =
            Map<String, dynamic>.from(categoryEntry.value as Map);

        List<SubCategoryModel> subCategoryList =
            sentencesMap.entries.map((sentenceEntry) {
          String sentenceId = sentenceEntry.key;
          Map<String, dynamic> sentenceJson =
              Map<String, dynamic>.from(sentenceEntry.value as Map);

          return SubCategoryModel(
            id: sentenceId,
            sentence: SentenceModel.fromJson(sentenceJson),
          );
        }).toList();

        return CategoryModel(
          categoryName: categoryName,
          subCategories: subCategoryList,
        );
      }).toList();

      return SentenceLabModel(
        sectionName: sectionName,
        categories: categoryList,
      );
    }).toList();
  }
}
