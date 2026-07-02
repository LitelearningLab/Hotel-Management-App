import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/university_model.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class UniversityLabSubController extends GetxController {
  late UniversityCategory category;
  late String collegeName = "";
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final box = GetStorage();

    if (args != null && args is Map) {
      final rawCat = args['category'];
      if (rawCat is UniversityCategory) {
        category = rawCat;
      } else if (rawCat is Map) {
        category =
            UniversityCategory.fromMap(Map<String, dynamic>.from(rawCat));
      }
      collegeName = args['collegeName'] ?? "";
      box.write(AppRoutes.universityLabSub, {
        'category': category.toMap(),
        'collegeName': collegeName,
      });
    } else if (args is UniversityCategory) {
      category = args;
      collegeName = "";
    } else {
      final saved = box.read(AppRoutes.universityLabSub) ?? {};
      collegeName = saved['collegeName'] ?? "";
      final catJson = saved['category'];
      if (catJson != null && catJson is Map) {
        category =
            UniversityCategory.fromMap(Map<String, dynamic>.from(catJson));
      } else if (saved is Map && saved.containsKey('name')) {
        category = UniversityCategory.fromMap(Map<String, dynamic>.from(saved));
      } else {
        category = UniversityCategory(
            name: '', order: "0", id: '', key: '', subcategory: []);
      }
    }
    update();
  }
}
