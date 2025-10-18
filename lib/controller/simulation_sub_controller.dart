import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/model/simulation_model.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class SimulationSubController extends GetxController {
  late List<bool> isExpanded;
  int expandedIndex = -1;
  late String title;
  late SimulationModel simulation;
  @override
  void onInit() {
    log('SimulationSubController initialized!');
    final args = Get.arguments as Map<String, dynamic>?;
    final box = GetStorage();

    // ✅ Always set fallback first (prevents LateInitializationError)
    simulation =
        SimulationModel(category: "", order: 1, key: "", subcategory: []);
    title = "";

    if (args != null) {
      title = args['title'] ?? "";
      simulation = args['simulation'] ?? simulation;
      box.write(AppRoutes.simulationSub, {
        'title': title,
        'simulation': simulation.toJson(),
      });
    } else {
      final saved = box.read(AppRoutes.simulationSub) ?? {};
      title = saved['title'] ?? "";

      final simJson = saved['simulation'];
      if (simJson != null) {
        simulation = SimulationModel.fromJson(
          Map<String, dynamic>.from(simJson),
        );
      }
    }
    debugPrint("SimulationSubController title: $title");
    update();

    super.onInit();
  }
}
