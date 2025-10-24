import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/university_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/update_checker.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  List<dynamic> categories = [];
  late UniversityModel universityModel;
  late String userName;
  List<Map<String, dynamic>> homeRecentHistory = [];
  bool recentHistoryLoaded = true;

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
    // AllAssets.frontOffice,
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
    checkSubscriptionValidity();
    _checkFirstTimeAndRequestMic();

    super.onReady();
  }

  Future<void> _checkFirstTimeAndRequestMic() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked = prefs.getBool('mic_permission_requested') ?? false;

    if (!alreadyAsked) {
      if (!kIsWeb) {
        await _requestMicPermission();
      }

      // Save so we don’t ask again
      await prefs.setBool('mic_permission_requested', true);
    }
  }

  Future<void> loadRecentHistory() async {
    log("message: loadRecentHistory called");
    recentHistoryLoaded = true;
    homeRecentHistory = [];
    update();

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('recentHistory');

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      recentHistory = decoded
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
      homeRecentHistory = recentHistory;
    }

    recentHistoryLoaded = false;
    update();
  }

  Future checkSubscriptionValidity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String userId = prefs.getString("userId") ?? "";
      log("$userId user id printing for checkin");
      final userSnapshot = await FirebaseFirestore.instance
          .collection('UserNode')
          .doc(userId)
          .get();
      log("$userId printining the userId");

      if (!userSnapshot.exists) return false;

      final userData = userSnapshot.data()!;
      final companyId = userData['companyid'];

      if (companyId == null || companyId.toString().isEmpty) return false;

      final companySnapshot = await FirebaseFirestore.instance
          .collection('UserNode')
          .where('_id', isEqualTo: companyId)
          .limit(1)
          .get();

      if (companySnapshot.docs.isEmpty) return false;

      final companyData = companySnapshot.docs.first.data();

      // Company status check
      if (companyData['status'] != "1") return false;
      if (companyData.containsKey('accessLinks')) {
        accessLinks = companyData['accessLinks'];
      } else {
        accessLinks =
            "E-Learning , Knowledge Check , Glossary , Simulation , local";
      }

      log("Here printing the access links: $accessLinks");

      // Subscription dates check
      final userSubDate =
          DateTime.tryParse(userData['subscriptionenddate'] ?? '');
      final companySubDate =
          DateTime.tryParse(companyData['subscriptionenddate'] ?? '');
      final now = DateTime.now();

      bool isUserActive = userSubDate != null && userSubDate.isAfter(now);
      log("${userSubDate} left is showing the usersub date and right is showing current time $now");
      bool isCompanyActive =
          companySubDate != null && companySubDate.isAfter(now);
      log("$isUserActive this is user active $isCompanyActive is company active");
      if (!isUserActive) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Fluttertoast.showToast(
            msg: "Subscription date has been finished.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);
        Get.offAll(() => LoginPage());
      }
    } catch (e) {
      log("Error checking subscription: $e");
    }
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
    await loadRecentHistory();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";
    userName = prefs.getString("userName") ?? "";

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
      final String collegeId = userData['companyid'] ?? '';
      log("College ID: $collegeId");
      if (collegeId.isNotEmpty) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('UniversityCollection')
            .where('collegeId', isEqualTo: collegeId)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs.first.data() as Map<String, dynamic>;

          universityModel = UniversityModel.fromMap(data);
          cardNames.insert(4, universityModel.collegeName);
          cardImages.insert(4, universityModel.photo);
          log("${universityModel.photo} here im printing which im fetching from firebase");
          update();

          log('📘 College Name: ${universityModel.collegeName}');
          log('🏷️ College ID: ${universityModel.collegeId}');

          // for (var category in universityModel.category) {
          //   log('\n📚 Category: ${category.name}');
          //   log('   ID: ${category.id}');
          //   log('   Order: ${category.order}');

          //   for (var subject in category.subcategory) {
          //     log('   ➤ ${subject.text}');
          //   }
          //   log('-----------------------------');
          // }
        } else {
          log('⚠️ No college data found for this collegeId.');
        }
      } else {
        log('⚠️ No collegeId found for user.');
      }
    } catch (e) {
      log('❌ Error fetching data: $e');
    }

    update();
  }

  void exitPopup(BuildContext context) {
    kHeight = MediaQuery.of(context).size.height;
    kWidth = MediaQuery.of(context).size.width;
    kText = MediaQuery.of(context).textScaler;

    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding:
              EdgeInsets.only(left: kWidth / 32.35, right: kWidth / 32.75),
          actionsPadding: EdgeInsets.only(
              right: kWidth / 26.2,
              left: kWidth / 26.2,
              bottom: kHeight / 28.4),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: Text(
            'Log out',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          content: Text(
            'Are you sure want to log out?',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w500),
          ),
          actions: [
            SizedBox(
              width: displayWidth(context) > 700 ? kWidth / 10 : kWidth / 2.5,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: kText.scale(15)),
                  )),
            ),
            SizedBox(
              width: displayWidth(context) > 700 ? kWidth / 10 : kWidth / 2.5,
              child: TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    debugPrint("printing the clickings");
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      kIsWeb
                          ? Get.rootDelegate.offNamed(AppRoutes.login)
                          : Get.offAll(() => LoginPage());
                    });

                    // Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
                  },
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      side: MaterialStatePropertyAll(
                          BorderSide(width: 1, color: Colors.green))),
                  child: Text('Log out',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: kText.scale(15)))),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  Future<void> _requestMicPermission() async {
    var status = await Permission.microphone.status;

    if (status.isDenied) {
      // First time / previously denied
      var result = await Permission.microphone.request();

      if (result.isPermanentlyDenied) {
        // User clicked "Don't ask again"
        Get.dialog(
          AlertDialog(
            title: const Text("Microphone Permission"),
            content: const Text(
                "We need microphone access to use this feature. Please enable it in Settings."),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child:  Text("Cancel",style: TextStyle(color: linearColor),),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Get.back();
                },
                child:  Text("Open Settings",style: TextStyle(color: linearColor),),
              ),
            ],
          ),
        );
      }
    }
  }
}
