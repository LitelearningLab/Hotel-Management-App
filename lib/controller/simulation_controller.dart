import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/simulation_model.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/response/simulation_responce.dart';
import 'package:hotelmanagementapp/view/home.dart';

class SimulationController extends GetxController {
  List<SimulationModel> simulations = [];
  SimulationResponse simulationResponce = SimulationResponse();
  bool loading = true;
  Map<String, dynamic>? simulationStatus;
  @override
  void onInit() {
    init();
    fetchInReviewStatus();
    timestampIndex = 4;
    currentIndex = 2;
    super.onInit();
  }

  Future<void> init() async {
    simulations = await simulationResponce
        .getSimulationCollection(CollectionNames.simulation);
    log("simulations.length${simulations.length}");
    loading = false;
    update();
  }

  Future<void> fetchInReviewStatus() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('InteractiveSimulationInReview')
          .get();
      if (snapshot.docs.isNotEmpty) {
        simulationStatus = snapshot.docs.first.data();
        update();
      }
    } catch (e) {
      print('Error fetching status: $e');
    }
  }

  void showReviewPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: const Text('Section Under Review'),
        content: const Text(
          'This section is temporarily under review. We’ll inform you as soon as it’s available again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: linearColor),
            ),
          ),
        ],
      ),
    );
  }

  bool isLabActive(String labKey) {
    log("simulationStatus: $simulationStatus , labKey: $labKey");
    if (simulationStatus == null) return false;
    return (simulationStatus![labKey] ?? '') == 'active';
  }
}
