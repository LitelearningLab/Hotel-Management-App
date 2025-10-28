import 'dart:math';

import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/simulation_model.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/response/simulation_responce.dart';
import 'package:hotelmanagementapp/view/home.dart';

class SimulationController extends GetxController {
  List<SimulationModel> simulations = [];
  SimulationResponse simulationResponce = SimulationResponse();
  bool loading = true;
  @override
  void onInit() {
    init();
    timestampIndex = 4;
    currentIndex = 2;
    super.onInit();
  }

  init() async {
    simulations = await simulationResponce
        .getSimulationCollection(CollectionNames.simulation);
    log(simulations.length);
    loading = false;
    update();
  }
}
