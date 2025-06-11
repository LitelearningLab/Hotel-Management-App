import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/firebase_service.dart';

class PronunciationLabController extends GetxController {
  final databaseRef = FirebaseDatabase.instance.ref("EnglishLabCollection");
  List<Category> categories = <Category>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  RxString title = "Pronunciation Lab".obs;

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>?;
    title.value = args?['title'] ?? "";
    _fetchData();
    log("PronunciationLabController initialized with title: ${title.value}");

    super.onInit();
  }

  Future<void> _fetchData() async {
    isLoading.value = true;

    try {
      DatabaseEvent event = await databaseRef.once();
      final data = event.snapshot.value;

      if (data != null && data is List) {
        // Directly cast each entry as a Map and convert to Category
        categories = data.map((item) {
          final categoryMap = Map<String, dynamic>.from(item as Map);
          if (categoryMap['subcategories'] is List) {
            categoryMap['subcategories'] =
                (categoryMap['subcategories'] as List)
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();
          }
          return Category.fromJson(categoryMap);
        }).toList();

        log("✅ Data loaded: ${categories.length} categories");
        log(categories[0].subcategories[0].pronun);
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
