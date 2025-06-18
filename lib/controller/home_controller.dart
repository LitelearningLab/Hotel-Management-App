import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/main.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';

class HomeController extends GetxController {
  List<String> cardNames = [
    "Front Office\nManagement",
    "Food & Beverage Service\nManagement",
    "Food Production",
    "Accommodation\nManagement - Housekeeping",
    "Mock Interview"
  ];
  List<String> cardImages = [
    AllAssets.frontOffice,
    AllAssets.foodAndBevarage,
    AllAssets.foodProduction,
    AllAssets.houseKeeping,
    // AllAssets.interview
  ];
  List<String> smartShorts = [
    "Interactive Simulations",
    "Language Lab",
    "Content Library"
  ];
  @override
  void onInit() {
    // bulkEditDocuments();
    super.onInit();
  }

  void showPopupAtTap(Offset tapPosition) {
    final overlay = Get.overlayContext!;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: tapPosition.dx,
        top: tapPosition.dy,
        child: TapPopup(onFinish: () => entry.remove()),
      ),
    );

    Overlay.of(overlay).insert(entry);
  }
}
