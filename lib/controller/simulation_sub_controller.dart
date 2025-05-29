import 'dart:developer';

import 'package:get/get.dart';

class SimulationSubController extends GetxController {
  late List<bool> isExpanded;
  int expandedIndex = -1;
  @override
  void onInit() {
    log('SimulationSubController initialized!');
    super.onInit();
  }
}
