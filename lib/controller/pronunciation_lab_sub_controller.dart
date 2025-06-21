import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/utility/audio_player_manager.dart';

class PronunciationLabSubController extends GetxController {
  late String title;
  late List<SubcategoryPro> subcategories = [];
  late CategoryModel category;
  bool isLoading = true;
  String collectionName = '';
  late AudioPlayerManager audioPlayerManager;
  @override
  void onInit() {
    title = Get.arguments['title'];
    subcategories = Get.arguments['subcategories'] as List<SubcategoryPro>;
    collectionName = Get.arguments['pronunCollectionName'] ?? '';
    audioPlayerManager = AudioPlayerManager();
    fetchPronunById(Get.arguments['id'] ?? '');

    super.onInit();
    update();
  }

  Future<void> fetchPronunById(String id) async {
    if (subcategories.isEmpty) {
      final ref = FirebaseDatabase.instance.ref('$collectionName/$id');

      try {
        final snapshot = await ref.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>;
          final parsed = data.map((key, value) {
            if (value is Map) {
              return MapEntry(
                  key.toString(), Map<String, dynamic>.from(value as Map));
            } else if (value is List) {
              return MapEntry(
                key.toString(),
                value.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
              );
            } else {
              return MapEntry(key.toString(), value);
            }
          });

          category = CategoryModel.fromMap(parsed);
          subcategories = category.subcategories;
        } else {
          print('No data found for ID: $id');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }

      isLoading = false;
      update();
      print('No subcategories found for title: $title $collectionName');
    } else {
      isLoading = false;
      update();
      print('Subcategories for $title: ${subcategories.length}');
    }
  }
}
