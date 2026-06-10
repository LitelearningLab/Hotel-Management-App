import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/university_model.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class UniversityLabSubController extends GetxController {
  late UniversityCategory category;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    final args = Get.arguments;
    final box = GetStorage();
    if (args != null) {
      if (args is UniversityCategory) {
        category = args;
      } else if (args is Map<String, dynamic>) {
        category = UniversityCategory.fromMap(args);
      } else {
        category = UniversityCategory(name: '', order: 0, id: '', key: '', subcategory: []);
      }
    } else {
      final saved = box.read(AppRoutes.universityLabSub);
      if (saved != null && saved is Map<String, dynamic>) {
        category = UniversityCategory.fromMap(saved);
      } else {
        category = UniversityCategory(name: '', order: 0, id: '', key: '', subcategory: []);
      }
    }
    super.onInit();
  }
}
