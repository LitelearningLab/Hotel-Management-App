import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FrontOfficeController extends GetxController {
  String title = '';
  String image = '';

  final int itemCount = 10;
  late List<bool> isExpanded;
  int expandedIndex = -1;
  List<List<String>> allLinks = [];
  final List<String> hospitalityTopics = [
    "INTRODUCTION - TOURISM AND ITS IMPORTANCE",
    "INTRODUCTION - HOSPITALITY AND ITS ORIGIN",
    "INTRODUCTION - HOTELS, THEIR EVOLUTION AND GROWTH",
    "INTRODUCTION - CORE AREAS FRONT OFFICE",
    "INTRODUCTION - TRAVEL AND HOTEL INDUSTRY AND THEIR INTER-RELATIONSHIP",
    "INTRODUCTION - INTERDEPENDENCY OF TOURISM, TRAVEL, AND HOSPITALITY INDUSTRY",
    "INTRODUCTION - CLASSIFICATION OF HOTELS",
    "STAFFING AND ORGANIZATIONAL STRUCTURE OF HOTEL",
    "FRONT OFFICE ORGANIZATION",
    "UPDATED FRONT OFFICE LAYOUT AND EQUIPMENT",
    "JOB DESCRIPTION OF FRONT OFFICE PERSONNEL",
    "ATTRIBUTES OF FRONT OFFICE STAFF",
    "GRE AND LOBBY MANAGER",
    "GUEST CYCLE",
    "TYPES OF HOTEL GUESTS",
    "RESERVATION",
    "GROUP RESERVATION AND CANCELLATIONS",
    "REGISTRATION",
    "FRONT OFFICE COMMUNICATION",
    "SECURITY DEPARTMENT",
  ];
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    title = args?['title'] ?? "";
    image = args?['image'] ?? "";
    onLink();
    isExpanded = List.generate(itemCount, (_) => false);
    update();
  }

  onLink() async {
    allLinks = await fetchAllLinks();
  }

  Future<List<List<String>>> fetchAllLinks() async {
    List<List<String>> allLinks = [];

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('FrontOffice').get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['links'] != null && data['links'] is List) {
          List<String> links = List<String>.from(data['links']);
          allLinks.add(links);
        }
      }
    } catch (e) {
      print('Error fetching links: $e');
    }

    return allLinks;
  }
}
