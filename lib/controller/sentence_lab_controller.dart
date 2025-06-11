import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';

class SentenceLabController extends GetxController {
  RxString title = "Sentence Lab".obs;
  List<SentenceLabModel> sentenceLabList = [];
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
    super.onInit();

    fetchSentenceLabData("SentenceLabCollection");
    final args = Get.arguments as Map<String, dynamic>?;
    title.value = args?['title'] ?? "Sentence Lab";

    update();
  }

  Future<void> fetchSentenceLabData(String title) async {
    isLoading.value = true;
    final databaseRef = FirebaseDatabase.instance.ref();
    try {
      final snapshot = await databaseRef.child(title).get();

      if (snapshot.exists) {
        final List<dynamic> dataList = snapshot.value as List<dynamic>;

        sentenceLabList = dataList
            .map((item) =>
                SentenceLabModel.fromMap(Map<String, dynamic>.from(item)))
            .toList();
        // Print for debugging
        for (var category in sentenceLabList) {
          log('Category: ${category.category}');
          for (var sub in category.subcategory) {
            log('  Subcategory: ${sub.subcategory}');
            for (var file in sub.file) {
              log('    Text: ${file.text}, Audio: ${file.audio}');
            }
          }
        }
        isLoading.value = false;
      } else {
        log("No data found at $title");
        isLoading.value = false;
      }
    } catch (e) {
      log("Error fetching data from Firebase: $e");
      isLoading.value = false;
    }
    update();
  }
}
