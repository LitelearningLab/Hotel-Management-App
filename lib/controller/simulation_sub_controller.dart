import 'dart:developer';

import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/simulation_model.dart';

class SimulationSubController extends GetxController {
  late List<bool> isExpanded;
  int expandedIndex = -1;
  late String title;
  late SimulationModel simulation;
  @override
  void onInit() {
    log('SimulationSubController initialized!');
    final args = Get.arguments as Map<String, dynamic>?;
    title = args?['title'] ?? "";
    simulation = args?['simulation'] ??
        SimulationModel(category: "", order: 1, key: "", subcategory: []);
    super.onInit();
  }
}
