import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/dbHelper/progress_bar_db_helper.dart';
import 'package:hotelmanagementapp/model/front_office_model.dart';
import 'package:hotelmanagementapp/model/progress_model.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/response/front_office_responce.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class FrontOfficeController extends GetxController {
  String title = '';
  String image = '';

  final int itemCount = 10;
  late List<bool> isExpanded;
  int expandedIndex = -1;
  int glossaryIndex = -1;

  FrontOfficeResponse frontOfficeResponse = FrontOfficeResponse();
  List<FrontOfficeDocument> frontOfficeData = [];
  bool loading = false;
  String collectionName = "";
  int index = 0;
  List<FrontOfficeDocument> originalData = [];
  String pronunCollectionName = "";
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String searchTerm = "";
  int totalPercentage = 0;
  double particularPercentage = 0;
  Map<String, ProgressModel> progressData = {};

  @override
  void onInit() {
    super.onInit();

    init();

    update();
  }

  Future<void> init() async {
    try {
      loading = true;
      update();

      final args = Get.arguments;
      final box = GetStorage();

      if (args != null) {
        // Mobile navigation ✅
        title = args['title'] ?? "";
        image = args['image'] ?? "";
        index = args['index'] ?? "";

        // Store for web refresh
        box.write('pageData', args);
      } else {
        // Web refresh fallback ✅
        final saved = box.read(AppRoutes.frontOffice) ?? {};
        title = saved['title'] ?? "";
        image = saved['image'] ?? "";
        index = saved['index'] ?? "";
      }

      isExpanded = List.generate(itemCount, (_) => false);

      pronunCollectionName = index == 0
          ? CollectionNames.frontOfficePronun
          : index == 1
              ? CollectionNames.foodAndBeveragePronun
              : index == 2
                  ? CollectionNames.foodProductionPronun
                  : index == 3
                      ? CollectionNames.houseKeepingPronun
                      : "";

      collectionName = index == 0
          ? CollectionNames.frontOffice
          : index == 1
              ? CollectionNames.foodAndBeverage
              : index == 2
                  ? CollectionNames.foodProduction
                  : index == 3
                      ? CollectionNames.houseKeeping
                      : "";

      log("Collection Name: $collectionName");

      frontOfficeData =
          await frontOfficeResponse.getFrontOfficeCollection(collectionName);

      originalData = List.from(frontOfficeData);
      totalPercentage = originalData.length * 3;

      await _loadProgress();
      particularPercentage = await _getTotalProgress();

      log("Total percentage: $totalPercentage | Particular percentage: $particularPercentage");
    } catch (e, s) {
      print("Error in init(): $e");
      print("Stacktrace: $s");
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> _loadProgress() async {
    for (var h in originalData) {
      final p = await ProgressBarDbHelper.getProgress(h.category);
      if (p == null) {
        ProgressModel fresh = ProgressModel(
          id: h.category,
          option1Time: 0,
          option1Done: false,
          option2Time: 0,
          option2Done: false,
          percentageEarned: 0,
        );
        await ProgressBarDbHelper.saveProgress(fresh);
        progressData[h.category] = fresh;
      } else {
        progressData[h.category] = p;
      }
    }
    update();
  }

  Future<double> _getTotalProgress() async {
    return await ProgressBarDbHelper.getTotalProgress();
  }

  void showPopupAtTap(Offset tapPosition) {
    final overlay = Get.overlayContext!;
    late OverlayEntry entry;
    final adjustedPosition = Offset(
      tapPosition.dx - 60, // shift to the left
      tapPosition.dy - 0, // shift slightly up
    );

    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: adjustedPosition.dx,
        top: adjustedPosition.dy,
        child: TapPopup(onFinish: () => entry.remove()),
      ),
    );

    Overlay.of(overlay).insert(entry);
  }

  void searchByCategory(String query) {
    searchTerm = query;
    update();

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    frontOfficeData = originalData
        .where(
            (item) => item.category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Debug
    for (var item in frontOfficeData) {
      print(
          "Filtered Item Category: ${item.category}"); // Should print the original casing
    }

    update();
  }

  void clearSearch() {
    searchController.clear();
    isSearching = false;
    searchTerm = "";
    frontOfficeData = List.from(originalData);
    update();
  }

  List<TextSpan> highlightOccurrences(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;

    while (true) {
      final matchIndex = lowerText.indexOf(lowerQuery, start);

      if (matchIndex == -1) {
        // Add the remaining part of the text
        spans.add(TextSpan(
          text: text.substring(start),
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            // fontSize: kText.scale(
            //     isKwidth > 700
            //         ? 16
            //         : 14)
          ),
        ));
        break;
      }

      // Add normal text before the match
      if (matchIndex > start) {
        spans.add(TextSpan(
          text: text.substring(start, matchIndex),
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            // fontSize: kText.scale(
            //     isKwidth > 700
            //         ? 16
            //         : 14)
          ),
        ));
      }

      // Add highlighted match text
      spans.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: linearColor,
          // fontSize: 15,
        ),
      ));

      start = matchIndex + query.length;
    }

    return spans;
  }
}
