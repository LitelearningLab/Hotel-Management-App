import 'package:get/get.dart';
import 'package:hotelmanagementapp/controller/content_lab_controller.dart';
import 'package:hotelmanagementapp/controller/front_office_controller.dart';
import 'package:hotelmanagementapp/controller/grammer_lab_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/language_lab_controller.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_controller.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_sub_controller.dart';
import 'package:hotelmanagementapp/controller/search_screen_controller.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_controller.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_sub_cat_controller.dart';
import 'package:hotelmanagementapp/controller/simulation_controller.dart';
import 'package:hotelmanagementapp/controller/simulation_sub_controller.dart';
import 'package:hotelmanagementapp/controller/sound_lab_controller.dart';
import 'package:hotelmanagementapp/controller/sound_page_controller.dart';
import 'package:hotelmanagementapp/controller/splash_controller.dart';

class InitialBinding with Bindings {
  @override
  void dependencies() {
    // Get.put(HomeController(), permanent: true);
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

class PronunciationLabSubBinding with Bindings {
  @override
  void dependencies() {
    Get.put(PronunciationLabSubController());
  }
}

class GrammerLabBinding with Bindings {
  @override
  void dependencies() {
    Get.put(GrammerLabController());
  }
}

class SoundPageBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SoundPageController());
  }
}

class SoundLabBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SoundLabController());
  }
}

class SentenceLabSubCatBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SentenceLabSubCatController());
  }
}

class SearchScreenBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SearchScreenController());
  }
}

class ContentLabBinding with Bindings {
  @override
  void dependencies() {
    Get.put(ContentLabController());
  }
}

class SplashScreenBinding with Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class NoInternetBinding with Bindings {
  @override
  void dependencies() {}
}
