import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hotelmanagementapp/model/grammer_lab_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';

class GrammerLabController extends GetxController {
  RxString title = "Grammer Lab".obs;
  RxBool isLoading = true.obs;
  List<GrammarDoc> grammarDocs = [];
  List<Map<String, dynamic>> grammarCheckLabList = [
    {
      'title': 'Parts of Speech',
      'load': 'Parts of Speech',
      'menuText': 'Parts of Speech',
      'backgroundImage': AllAssets.back1,
      'image': 'assets/images/Grammar_Lab_Main_Page_List_Icon.png',
      'bgColor': Color(0xFF5370D4),
    },
    {
      'title': 'Tenses',
      'load': 'Tenses',
      'menuText': 'Tenses',
      'backgroundImage': AllAssets.back1,
      'image': 'assets/images/Grammar_Lab_Main_Page_List_Icon.png',
      'bgColor': Color(0xFF3DBAD3),
    },
    {
      'title': 'Sentence Structure',
      'load': 'Sentence Structure',
      'menuText': 'Sentence Structure',
      'backgroundImage': AllAssets.back1,
      'image': 'assets/images/Grammar_Lab_Main_Page_List_Icon.png',
      'bgColor': Color(0xFF0190FE),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    fetchGrammarDocList();
    // Initialization logic can go here
  }

  Future fetchGrammarDocList() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection("GrammerLabCollection").get();

      grammarDocs = snapshot.docs.map((doc) {
        final data = doc.data();
        return GrammarDoc.fromJson(data);
      }).toList();

      isLoading.value = false;
      update();
    } catch (e) {
      print('Error fetching grammar docs: $e');
      isLoading.value = false;
      update();
    }
  }
}
