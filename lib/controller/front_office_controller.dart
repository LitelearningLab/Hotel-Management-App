import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/model/front_office_model.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/response/front_office_responce.dart';

class FrontOfficeController extends GetxController {
  String title = '';
  String image = '';

  final int itemCount = 10;
  late List<bool> isExpanded;
  int expandedIndex = -1;

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

  @override
  void onInit() {
    super.onInit();

    init();

    update();
  }

  init() async {
    loading = true;
    update();
    final args = Get.arguments as Map<String, dynamic>?;
    title = args?['title'] ?? "";
    image = args?['image'] ?? "";
    index = args?['index'] ?? "";
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
    log(collectionName);
    frontOfficeData =
        await frontOfficeResponse.getFrontOfficeCollection(collectionName);
    originalData = List.from(frontOfficeData);
    loading = false;
    update();
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
    var matches = text.toLowerCase().split(query.toLowerCase());
    List<TextSpan> spans = [];
    int start = 0;

    for (int i = 0; i < matches.length; i++) {
      String matchText = matches[i];
      // Add normal text
      spans.add(TextSpan(
        text: matchText,
        style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 15),
      ));
      start += matchText.length;
      // Add bold text (if not at the end)
      if (i < matches.length - 1) {
        spans.add(TextSpan(
          text: text.substring(start, start + query.length),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: linearColor,
            fontSize: 15,
          ),
        ));
        start += query.length;
      }
    }
    return spans;
  }
}
