import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/firebase_service.dart';

class PronunciationLabController extends GetxController {
  late DatabaseReference databaseRef;
  List<Category> categories = <Category>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  RxString title = "Pronunciation Lab".obs;
  List<Map<String, dynamic>> pronunciationLabList = [
    {
      'title': 'Days, Dates, Months & Numbers',
      'load': 'daysdates',
      'menuText': 'Days, Dates, Months & Numbers',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plDays,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Letters Of The English Alphabet',
      'load': 'Latters and NATO',
      'menuText': 'Letters Of The English Alphabet',
      'backgroundImage': AllAssets.back2,
      'image': AllAssets.plLetters,
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'US States & Cities',
      'load': 'States and Cities',
      'menuText': 'US States & Cities',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plUSState,
      'bgColor': Color(0xFF0190FE),
    },
    {
      'title': 'Most Commonly Used Words',
      'load': 'CommonWords',
      'menuText': 'Most Commonly Used Words',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plMostCommon,
      'bgColor': Color(0xFF8540C8),
    },
    {
      'title': 'Common American Names',
      'load': 'ProcessWords',
      'menuText': 'Common American Names',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plCommon,
      'bgColor': Color(0xFFFF6548),
    },
    {
      'title': 'Restaurant, Hotel & Travel',
      'load': 'Restaurant Hotel Travel',
      'menuText': 'Restaurant, Hotel & Travel',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plRestaurant,
      'bgColor': Color(0xFF5146FF),
    },
    {
      'title': 'Business Words',
      'load': 'Business Words',
      'menuText': 'Business Words',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plBusiness,
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Information Technology',
      'load': 'Information Technology',
      'menuText': 'Information Technology',
      'backgroundImage': AllAssets.back1,
      'image': AllAssets.plIT,
      'bgColor': Color(0xFF3DBAD3),
    },
  ];
  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>?;
    title.value = args?['title'] ?? "";
    databaseRef = FirebaseDatabase.instance.ref(title == "English Pronunciation"
        ? "EnglishLabCollection"
        : "FrenchLabCollection");
    _fetchData();
    log("PronunciationLabController initialized with title: ${title.value}");

    super.onInit();
  }

  Future<void> _fetchData() async {
    isLoading.value = true;

    try {
      DatabaseEvent event = await databaseRef.once();
      final data = event.snapshot.value;

      log("📥 Raw snapshot: $data");

      if (data != null && data is List) {
        categories = data.map((item) {
          final categoryMap = Map<String, dynamic>.from(item as Map);

          // Ensure subcategories are a List<Map<String, dynamic>>
          if (categoryMap['subcategories'] is List) {
            categoryMap['subcategories'] =
                (categoryMap['subcategories'] as List).map((subcat) {
              final subcatMap = Map<String, dynamic>.from(subcat);

              // 🔹 Normalize sentenceSamples to List<String>
              if (subcatMap['sentenceSamples'] is List) {
                subcatMap['sentenceSamples'] =
                    (subcatMap['sentenceSamples'] as List)
                        .map((e) => e.toString())
                        .toList();
              } else {
                subcatMap['sentenceSamples'] = <String>[];
              }

              return subcatMap;
            }).toList();
          }

          return Category.fromJson(categoryMap);
        }).toList();

        log("✅ Data loaded: ${categories.length} categories");
        if (categories.isNotEmpty && categories[0].subcategories.isNotEmpty) {
          log("📜 First subcategory sentenceSamples: ${categories[0].subcategories[0].sentenceSamples}");
        }
      } else {
        errorMessage.value = "No data found or invalid format.";
        log("⚠️ No data found or invalid format.");
      }
    } catch (e) {
      errorMessage.value = "Error: ${e.toString()}";
      log("❌ Error fetching data from Firebase: ${e.toString()}");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
