import 'package:get/get.dart';
import 'package:hotelmanagementapp/controller/front_office_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/language_lab_controller.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_controller.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_controller.dart';
import 'package:hotelmanagementapp/controller/simulation_controller.dart';
import 'package:hotelmanagementapp/controller/simulation_sub_controller.dart';

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

class SimulationBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SimulationController());
  }
}

class SimulationSubBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SimulationSubController());
  }
}

class LanguageLabBinding with Bindings {
  @override
  void dependencies() {
    Get.put(LanguageLabController());
  }
}

class PronunciationLabBinding with Bindings {
  @override
  void dependencies() {
    Get.put(PronunciationLabController());
  }
}

class SentenceLabBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SentenceLabController());
  }
}
