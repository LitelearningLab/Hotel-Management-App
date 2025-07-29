import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/university_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  List<dynamic> categories = [];
  late UniversityModel universityModel;

  List<String> cardNames = [
    "Front Office Management",
    "Food & Beverage Service\nManagement",
    "Food Production",
    "Accommodation\nManagement - Housekeeping",
  ];
  List<String> cardImages = [
    AllAssets.frontOffice,
    AllAssets.foodAndBevarage,
    AllAssets.foodProduction,
    AllAssets.houseKeeping,
    AllAssets.frontOffice,
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

  @override
  void onReady() {
    // TODO: implement onReady
    fetchCollegeSyllabus();
    super.onReady();
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

  Future<void> fetchCollegeSyllabus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";

    if (userId.isEmpty) {
      print(
          '❌ Error: userId is empty. Make sure user is logged in and userId is saved.');
      return;
    }

    try {
      final userRef =
          FirebaseFirestore.instance.collection('UserNode').doc(userId);
      final userSnapshot = await userRef.get();
      final userData = userSnapshot.data() ?? {};
      final String collegeId = userData['collegeId'] ?? '';
      log("College ID: $collegeId");

      if (collegeId.isNotEmpty) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('UniversityCollection')
            .doc(collegeId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;

          // ✅ Parse using your model
          universityModel = UniversityModel.fromMap(data);
          cardNames.insert(4, universityModel.collegeName);
          update();

          print('📘 College Name: ${universityModel.collegeName}');
          print('🏷️ College ID: ${universityModel.collegeId}');

          for (var category in universityModel.category) {
            print('\n📚 Category: ${category.name}');
            print('   ID: ${category.id}');
            print('   Order: ${category.order}');

            for (var subject in category.subcategory) {
              print('   ➤ ${subject.text}');
            }
            print('-----------------------------');
          }
        } else {
          print('⚠️ No college data found for this collegeId.');
        }
      } else {
        print('⚠️ No collegeId found for user.');
      }
    } catch (e) {
      print('❌ Error fetching data: $e');
    }

    update();
  }
}
