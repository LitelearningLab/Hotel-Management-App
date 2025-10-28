import 'dart:developer';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class InAppWebViewGetController extends GetxController {
  late String url;
  late String finalUrl;
  String userId = "";
  String deviceId = "";
  bool isSimulation = false;
  @override
  void onReady() {
    onFirst();
    super.onReady();
  }

  void onFirst() async {
    log("${Get.currentRoute} get current route printing");
    final args = Get.arguments as Map<String, dynamic>?;
    finalUrl = args?['url'] ?? "";
    isSimulation = args?['isSimulation'] ?? false;
    final uri = Uri.parse(finalUrl);
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    if (!kIsWeb) {
      deviceId = (Platform.isAndroid
          ? await const AndroidId().getId()
          : await getPermanentDeviceId())!;
    } else {
      deviceId = "Web-App-User";
    }
    Uri updatedUri = uri.replace(queryParameters: {
      ...uri.queryParameters,
      'uid': userId,
      'device': deviceId,
    });

    url = updatedUri.toString();
    log("Final URL -> $url");
    if (url != ApiRoutes.privacyPolicy) {
      startTimerMainCategory("name");
    }
    update();
  }
}
