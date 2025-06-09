import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LanguageLabController extends GetxController {
  int selectedIndex = 0;
  ontapTab(int index) {
    selectedIndex = index;
    update();
  }
}
