import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';

class InAppWebViewGetController extends GetxController {
  late String url;

  bool isSimulation = false;
  @override
  void onReady() {
    log("${Get.currentRoute} get current route printing");
    final args = Get.arguments as Map<String, dynamic>?;
    url = args?['url'] ?? "";
    isSimulation = args?['isSimulation'] ?? false;

    if (url != ApiRoutes.privacyPolicy) {
      startTimerMainCategory("name");
    }
    update();
    super.onReady();
  }
}
