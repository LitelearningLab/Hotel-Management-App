import 'package:get/get.dart';
import 'package:hotelmanagementapp/controller/front_office_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';

class InitialBinding with Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
    // Get.put(LanguageDropDownController(), permanent: true);
  }
}

class FrontOfficeBinding with Bindings {
  @override
  void dependencies() {
    Get.put(FrontOfficeController());
  }
}
