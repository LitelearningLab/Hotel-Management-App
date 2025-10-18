import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class SentenceLabSubController extends GetxController {
  String title = "";
  List<CategoryModel> subcategories = [];
  List<CategoryModel> sortedSubcategories = [];

  @override
  void onInit() {
    final args = Get.arguments;
    final box = GetStorage();
    if (args != null) {
      title = args['title'] ?? "";
      subcategories = List<CategoryModel>.from(args['subcategories'] ?? []);
    } else {
      final saved = box.read(AppRoutes.sentenceLabSub) ?? {};
      title = saved['title'] ?? "";

      // Check and convert List<dynamic> → List<CategoryModel>
      final rawList = saved['subcategories'];
      if (rawList is List) {
        subcategories = rawList.map((e) {
          if (e is CategoryModel) {
            return e;
          } else if (e is Map<String, dynamic>) {
            return CategoryModel.fromJson(e);
          }
          throw Exception("Invalid data type in subcategories list");
        }).toList();
      } else {
        subcategories = [];
      }
    }

    sortedSubcategories = [...subcategories]
      ..sort((a, b) => a.order.compareTo(b.order));
    update();
    super.onInit();
  }
}
