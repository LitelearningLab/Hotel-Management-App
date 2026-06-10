import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/university_model.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class UniversityLabController extends GetxController {
  late UniversityModel universityModel;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    final args = Get.arguments;
    final box = GetStorage();
    if (args != null) {
      if (args is UniversityModel) {
        universityModel = args;
      } else if (args is Map<String, dynamic>) {
        universityModel = UniversityModel.fromMap(args);
      } else {
        universityModel = UniversityModel(collegeName: '', collegeId: '', category: [], photo: '');
      }
    } else {
      final saved = box.read(AppRoutes.universityLab);
      if (saved != null && saved is Map<String, dynamic>) {
        universityModel = UniversityModel.fromMap(saved);
      } else {
        universityModel = UniversityModel(collegeName: '', collegeId: '', category: [], photo: '');
      }
    }
    super.onInit();
  }
}
